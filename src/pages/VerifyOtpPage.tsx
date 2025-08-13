import React, { useState, useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { useToast } from '@/hooks/use-toast';
import { useCart } from '@/contexts/CartContext';
import { useAuth } from '@/contexts/AuthContext';
import { createOrdersFromCart } from '@/services/orderService';
import { createJobCardFromOrder } from '@/services/jobCardService';
import { ArrowLeft, Shield, CheckCircle, Loader2 } from 'lucide-react';
import { exportOrderSummaryToPDF } from "@/utils/pdf";
import { createOrderVerification, sendVerificationConfirmationEmail } from "@/services/verificationService";
import { supabase } from '@/integrations/supabase/client';
import { InputOTP, InputOTPGroup, InputOTPSlot } from "@/components/ui/input-otp";
import { usePerformanceMonitor } from '@/hooks/usePerformanceMonitor';
import { useOfflineStatus } from '@/hooks/useOfflineStatus';
import { measurePerformance } from '@/utils/performance';

const FIXED_OTP = "0108";

export const VerifyOtpPage = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const { toast } = useToast();
  const { items, getTotalPrice, clearCart } = useCart();
  const { user } = useAuth();
  const { trackInteraction } = usePerformanceMonitor('VerifyOtpPage');
  const { isOnline } = useOfflineStatus();
  
  const [otpCode, setOtpCode] = useState('');
  const [isVerifying, setIsVerifying] = useState(false);
  const [isConfirming, setIsConfirming] = useState(false);
  const [currentStep, setCurrentStep] = useState('');

  useEffect(() => {
    if (items.length === 0) {
      navigate('/cart');
    }
    if (!user) {
      navigate('/auth');
    }
  }, [items, user, navigate]);

  const verifyOtpAndCreateOrder = async () => {
    if (otpCode.length !== 4) {
      toast({
        title: "Invalid OTP",
        description: "Please enter a valid 4-digit code.",
        variant: "destructive",
      });
      return;
    }

    if (otpCode !== FIXED_OTP) {
      toast({
        title: "Invalid OTP",
        description: "Invalid OTP. Please enter the correct code.",
        variant: "destructive",
      });
      return;
    }

    setIsVerifying(true);
    setIsConfirming(true);
    
    try {
      await handleOrderConfirmation();
    } finally {
      setIsVerifying(false);
      setIsConfirming(false);
    }
  };

  const handleOrderConfirmation = async () => {
    if (items.length === 0 || !user) {
      toast({
        title: "Authentication Required",
        description: "Please sign in to continue with checkout.",
        variant: "destructive",
      });
      return;
    }

    if (!isOnline) {
      toast({
        title: "No Internet Connection",
        description: "Please check your connection and try again.",
        variant: "destructive",
      });
      return;
    }

    let orders: any[] = [];
    let jobCards: any[] = [];

    try {
      await measurePerformance('orderConfirmation', async () => {
        // Step 1: Generate PDF summary for orders
        setCurrentStep('Generating order summary...');
        const pdfBlob = await exportOrderSummaryToPDF();
        
        // Step 2: Create orders from cart items
        setCurrentStep('Processing orders...');
        orders = await createOrdersFromCart(items);
        
        if (!orders || orders.length === 0) {
          throw new Error("Failed to create orders");
        }

        // Step 3: Create verification records for each order
        setCurrentStep('Creating verification records...');
        const verificationPromises = orders.map(async (order) => {
          const verificationResult = await createOrderVerification({
            orderId: order.id,
            email: user.email!,
            ipAddress: await getUserIPAddress(),
            userAgent: navigator.userAgent
          });
          
          if (!verificationResult.success) {
            throw new Error(`Failed to create verification for order ${order.id}`);
          }
          
          return {
            orderId: order.id,
            verificationCode: verificationResult.verificationCode!
          };
        });
        
        const verificationResults = await Promise.all(verificationPromises);

        // Step 4: Create job cards for each order
        setCurrentStep('Creating production schedules...');
        const jobCardPromises = orders.map(order => 
          createJobCardFromOrder(order.id)
        );
        
        const jobCardResults = await Promise.allSettled(jobCardPromises);
        const successfulJobCards = jobCardResults
          .filter((result): result is PromiseFulfilledResult<any> => result.status === 'fulfilled')
          .map(result => result.value);

        // Step 5: Send order confirmation email
        setCurrentStep('Sending order confirmation...');
        try {
          await supabase.functions.invoke('send-order-confirmation', {
            body: {
              customerEmail: user.email!,
              orders: orders,
              jobCards: successfulJobCards
            }
          });
        } catch (emailError) {
          console.error('Order confirmation email sending failed:', emailError);
          // Don't fail the entire process if email fails
        }

        // Step 6: Send verification confirmation emails
        setCurrentStep('Sending verification confirmations...');
        for (const verification of verificationResults) {
          try {
            await sendVerificationConfirmationEmail(
              verification.orderId,
              verification.verificationCode,
              user.email!
            );
          } catch (emailError) {
            console.error('Verification email sending failed:', emailError);
            // Don't fail the entire process if email fails
          }
        }

        // Step 7: Clear cart
        clearCart();
        
        // Step 8: Show success and redirect to verification page
        toast({
          title: "Order Confirmed",
          description: `Successfully created and verified ${orders.length} order(s). Check your email for confirmation details.`,
        });

        trackInteraction('orderSuccess');

        // Redirect to order verification page for the first order
        if (verificationResults.length > 0) {
          const firstVerification = verificationResults[0];
          setTimeout(() => {
            navigate(`/order-verification?orderId=${firstVerification.orderId}&code=${firstVerification.verificationCode}`);
          }, 2000);
        } else {
          setTimeout(() => {
            navigate('/customer-dashboard');
          }, 2000);
        }
      });
    } catch (error) {
      console.error('❌ Order confirmation failed:', error);
      trackInteraction('orderFailed');
      
      // If orders were created but something else failed
      if (orders.length > 0) {
        toast({
          title: "Partial Success",
          description: "Orders created but some steps failed. Check your customer dashboard.",
          variant: "default",
        });
        setTimeout(() => navigate('/customer-dashboard'), 2000);
      } else {
        toast({
          title: "Order Failed",
          description: error instanceof Error ? error.message : "Failed to create order. Please try again.",
          variant: "destructive",
        });
      }
    } finally {
      setCurrentStep('');
    }
  };

  // Helper function to get user IP address (for verification audit)
  const getUserIPAddress = async (): Promise<string> => {
    try {
      const response = await fetch('https://api.ipify.org?format=json');
      const data = await response.json();
      return data.ip || 'unknown';
    } catch {
      return 'unknown';
    }
  };

  if (items.length === 0 || !user) {
    return null;
  }

  return (
    <div className="min-h-screen bg-background py-8">
      <div className="container mx-auto px-4 max-w-md">
        <div className="flex items-center gap-4 mb-8">
          <Button 
            variant="ghost" 
            size="sm" 
            onClick={() => navigate('/checkout')}
            className="flex items-center gap-2"
            disabled={isConfirming}
          >
            <ArrowLeft className="h-4 w-4" />
            Back to Checkout
          </Button>
        </div>

        <Card>
          <CardHeader className="text-center">
            <div className="flex items-center justify-center gap-2 mb-2">
              <Shield className="h-6 w-6 text-primary" />
              <CardTitle>Verify Order</CardTitle>
            </div>
            <CardDescription>
              Enter the 4-digit verification code to confirm your order
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-6">
            <div className="text-center space-y-4">
              <p className="text-sm text-muted-foreground">
                Please enter the verification code to proceed with your order confirmation.
              </p>
              
              <div className="flex justify-center">
                <InputOTP
                  maxLength={4}
                  value={otpCode}
                  onChange={setOtpCode}
                  disabled={isConfirming}
                >
                  <InputOTPGroup>
                    <InputOTPSlot index={0} />
                    <InputOTPSlot index={1} />
                    <InputOTPSlot index={2} />
                    <InputOTPSlot index={3} />
                  </InputOTPGroup>
                </InputOTP>
              </div>

              <div className="space-y-4">
                <Button 
                  onClick={verifyOtpAndCreateOrder}
                  disabled={otpCode.length !== 4 || isConfirming}
                  className="w-full"
                  size="lg"
                >
                  {isConfirming ? (
                    <div className="flex items-center gap-2">
                      <Loader2 className="h-4 w-4 animate-spin" />
                      {currentStep || 'Processing...'}
                    </div>
                  ) : (
                    <div className="flex items-center gap-2">
                      <CheckCircle className="h-4 w-4" />
                      Verify OTP & Confirm Order
                    </div>
                  )}
                </Button>

                {currentStep && (
                  <div className="text-sm text-muted-foreground text-center">
                    {currentStep}
                  </div>
                )}
              </div>
            </div>

            {/* Order Summary */}
            <div className="border-t pt-4 space-y-2">
              <h4 className="font-medium text-sm">Order Summary</h4>
              <div className="flex justify-between text-sm">
                <span>Items ({items.length})</span>
                <span>₹{getTotalPrice().toLocaleString()}</span>
              </div>
              <div className="flex justify-between text-sm">
                <span>Shipping</span>
                <span>₹99</span>
              </div>
              <div className="flex justify-between font-semibold border-t pt-2">
                <span>Total</span>
                <span>₹{(getTotalPrice() + 99).toLocaleString()}</span>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};