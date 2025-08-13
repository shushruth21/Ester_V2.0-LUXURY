import React, { useState, useEffect } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Separator } from '@/components/ui/separator';
import { useToast } from '@/hooks/use-toast';
import { useCart } from '@/contexts/CartContext';
import { useAuth } from '@/contexts/AuthContext';
import { createOrdersFromCart } from '@/services/orderService';
import { createJobCardFromOrder } from '@/services/jobCardService';
import { ArrowLeft, ArrowRight, Shield, CheckCircle, Loader2, Mail, Timer } from 'lucide-react';
import { exportOrderSummaryToPDF } from "@/utils/pdf";
import { createOrderVerification, sendVerificationConfirmationEmail } from "@/services/verificationService";
import { supabase } from '@/integrations/supabase/client';
import { InputOTP, InputOTPGroup, InputOTPSlot } from "@/components/ui/input-otp";
import { createInvoice, verifyOTP } from '@/services/invoiceService';
import { usePerformanceMonitor } from '@/hooks/usePerformanceMonitor';
import { useOfflineStatus } from '@/hooks/useOfflineStatus';
import { measurePerformance } from '@/utils/performance';

export const CheckoutPage = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  const { items, getTotalPrice, clearCart } = useCart();
  const { user } = useAuth();
  const { trackInteraction } = usePerformanceMonitor('CheckoutPage');
  const { isOnline } = useOfflineStatus();
  
  const [isConfirming, setIsConfirming] = useState(false);
  const [orderConfirmed, setOrderConfirmed] = useState(false);
  const [currentStep, setCurrentStep] = useState('');
  const [createdOrders, setCreatedOrders] = useState<any[]>([]);
  
  // OTP states
  const [showOtpInput, setShowOtpInput] = useState(false);
  const [otpCode, setOtpCode] = useState('');
  const [isSendingOtp, setIsSendingOtp] = useState(false);
  const [isVerifyingOtp, setIsVerifyingOtp] = useState(false);
  const [otpSent, setOtpSent] = useState(false);
  const [invoiceId, setInvoiceId] = useState<string>('');
  const [otpTimer, setOtpTimer] = useState(0);

  useEffect(() => {
    if (items.length === 0) {
      navigate('/cart');
    }
  }, [items, navigate]);

  // OTP Timer effect
  useEffect(() => {
    let interval: NodeJS.Timeout;
    if (otpTimer > 0) {
      interval = setInterval(() => {
        setOtpTimer((prev) => prev - 1);
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [otpTimer]);

  const sendOtpForVerification = async () => {
    if (!user?.email) {
      toast({
        title: "Authentication Required",
        description: "Please sign in to continue with checkout.",
        variant: "destructive",
      });
      return;
    }

    setIsSendingOtp(true);
    try {
      // Create a temporary invoice for OTP tracking
      const totalAmount = getTotalPrice() + 99; // Include shipping
      const invoice = await createInvoice({
        orderId: 'temp-' + Date.now(), // Temporary order ID
        amount: totalAmount,
        customerEmail: user.email
      });

      setInvoiceId(invoice.id);

      // Send OTP email
      const { error } = await supabase.functions.invoke('send-otp-email', {
        body: {
          email: user.email,
          otpCode: invoice.otp_code,
          invoiceNumber: invoice.invoice_number
        }
      });

      if (error) {
        throw new Error('Failed to send OTP email');
      }

      setOtpSent(true);
      setShowOtpInput(true);
      setOtpTimer(600); // 10 minutes
      toast({
        title: "OTP Sent",
        description: "Please check your email for the verification code.",
      });

    } catch (error) {
      console.error('Error sending OTP:', error);
      toast({
        title: "Failed to Send OTP",
        description: error instanceof Error ? error.message : "Please try again.",
        variant: "destructive",
      });
    } finally {
      setIsSendingOtp(false);
    }
  };

  const verifyOtpAndProceed = async () => {
    if (otpCode.length !== 6) {
      toast({
        title: "Invalid OTP",
        description: "Please enter a valid 6-digit code.",
        variant: "destructive",
      });
      return;
    }

    setIsVerifyingOtp(true);
    try {
      const isValid = await verifyOTP(invoiceId, otpCode);
      
      if (!isValid) {
        toast({
          title: "Invalid OTP",
          description: "The code you entered is invalid or has expired.",
          variant: "destructive",
        });
        return;
      }

      // OTP verified successfully, proceed with order creation
      toast({
        title: "Email Verified",
        description: "Proceeding with order confirmation...",
      });
      
      setShowOtpInput(false);
      await handleOrderConfirmation();

    } catch (error) {
      console.error('Error verifying OTP:', error);
      toast({
        title: "Verification Failed",
        description: "Please try again or request a new code.",
        variant: "destructive",
      });
    } finally {
      setIsVerifyingOtp(false);
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

    setIsConfirming(true);
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
      setOrderConfirmed(true);
      
      // Step 8: Show success and redirect to verification page
      toast({
        title: "Order Verified!",
        description: `Successfully created and verified ${orders.length} order(s). Check your email for confirmation details.`,
      });

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
        setOrderConfirmed(true);
        setTimeout(() => navigate('/customer-dashboard'), 2000);
      } else {
        toast({
          title: "Order Failed",
          description: error instanceof Error ? error.message : "Failed to create order. Please try again.",
          variant: "destructive",
        });
      }
    } finally {
      setIsConfirming(false);
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

  if (items.length === 0) {
    return null;
  }

  return (
    <div className="min-h-screen bg-background py-8">
      <div className="container mx-auto px-4 max-w-4xl">
        <div className="flex items-center gap-4 mb-8">
          <Button 
            variant="ghost" 
            size="sm" 
            onClick={() => navigate('/cart')}
            className="flex items-center gap-2"
          >
            <ArrowLeft className="h-4 w-4" />
            Back to Cart
          </Button>
          <h2 className="text-xl font-semibold">Checkout</h2>
        </div>

        {!user ? (
          <Card className="max-w-md mx-auto">
            <CardHeader>
              <CardTitle>Sign In Required</CardTitle>
              <CardDescription>
                Please sign in to your account to proceed with checkout
              </CardDescription>
            </CardHeader>
            <CardContent>
              <Link to="/auth">
                <Button className="w-full">
                  Sign In to Continue
                  <ArrowRight className="h-4 w-4 ml-2" />
                </Button>
              </Link>
            </CardContent>
          </Card>
        ) : (
          <div className="grid lg:grid-cols-3 gap-8">
            <div className="lg:col-span-2">
              <Card id="order-summary-preview">
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Shield className="h-5 w-5" />
                    Order Review
                  </CardTitle>
                  <CardDescription>
                    Review your order details before verification and confirmation
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  {items.map((item) => (
                    <div key={item.id} className="flex justify-between items-start p-4 border border-border rounded-lg">
                      <div className="flex-1">
                        <h3 className="font-semibold">{item.modelName}</h3>
                        <p className="text-sm text-muted-foreground">Qty: {item.quantity}</p>
                        <div className="mt-2 space-y-1">
                          {Object.entries(item.configuration?.attributes || {}).map(([key, value]: [string, any]) => (
                            <div key={key} className="text-xs text-muted-foreground">
                              <span className="font-medium">{value.display_name}:</span>{' '}
                              <span>{value.selected_value}</span>
                              {value.price_modifier && value.price_modifier !== 0 && (
                                <span className="ml-1 text-primary">
                                  ({value.price_modifier > 0 ? '+' : ''}₹{value.price_modifier.toLocaleString()})
                                </span>
                              )}
                            </div>
                          ))}
                          {item.customerDetails && (
                            <div className="mt-2 pt-2 border-t border-border space-y-1">
                              <p className="text-xs font-medium text-muted-foreground">Customer Details:</p>
                              <p className="text-xs text-muted-foreground">{item.customerDetails.name}</p>
                              <p className="text-xs text-muted-foreground">{item.customerDetails.email}</p>
                              <p className="text-xs text-muted-foreground">{item.customerDetails.phone}</p>
                            </div>
                          )}
                        </div>
                        {item.remarks && (
                          <p className="text-xs text-muted-foreground mt-2">
                            Remarks: {item.remarks}
                          </p>
                        )}
                      </div>
                      <div className="text-right">
                        <p className="font-semibold">₹{(item.totalPrice * item.quantity).toLocaleString()}</p>
                        <p className="text-sm text-muted-foreground">
                          ₹{item.totalPrice.toLocaleString()} each
                        </p>
                      </div>
                    </div>
                  ))}
                  
                  <div className="pt-4">
                    {!orderConfirmed ? (
                      <div className="space-y-3">
                          <Button 
                            onClick={() => navigate('/verify-otp')}
                            className="w-full"
                            size="lg"
                          >
                            <div className="flex items-center gap-2">
                              <Shield className="h-4 w-4" />
                              Proceed to Verification
                            </div>
                          </Button>
                      </div>
                    ) : (
                      <div className="text-center space-y-4">
                        <div className="flex items-center justify-center gap-2 text-green-600">
                          <CheckCircle className="h-5 w-5" />
                          <span className="font-semibold">Order Confirmed Successfully</span>
                        </div>
                        <div className="space-y-2 text-sm text-muted-foreground">
                          <p>✅ Order created in our system</p>
                          <p>✅ Job cards generated for production</p>
                          <p>✅ Confirmation email sent</p>
                          <p className="font-medium">Redirecting to your orders...</p>
                        </div>
                        {createdOrders.length > 0 && (
                          <div className="text-xs text-muted-foreground space-y-1">
                            <p>Order IDs:</p>
                            {createdOrders.map((order, index) => (
                              <p key={order.id} className="font-mono">#{order.id.slice(0, 8)}...</p>
                            ))}
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                </CardContent>
              </Card>
            </div>

            <div>
              <Card>
                <CardHeader>
                  <CardTitle>Order Summary</CardTitle>
                </CardHeader>
                <CardContent id="order-summary-preview" className="space-y-4">
                  <div className="space-y-2">
                    <div className="flex justify-between text-sm">
                      <span>Subtotal ({items.reduce((sum, item) => sum + item.quantity, 0)} items)</span>
                      <span>₹{getTotalPrice().toLocaleString()}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span>Shipping</span>
                      <span>₹99</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span>Tax</span>
                      <span>Included</span>
                    </div>
                    <Separator />
                    <div className="flex justify-between font-semibold">
                      <span>Estimated Total</span>
                      <span>₹{(getTotalPrice() + 99).toLocaleString()}</span>
                    </div>
                  </div>

                  <div className="text-xs text-muted-foreground space-y-1">
                    <p>• Email verification required for order confirmation</p>
                    <p>• Free white-glove delivery included</p>
                    <p>• 1-year warranty coverage</p>
                    <p>• Payment details will be shared after verification</p>
                  </div>

                  {/* Order details for PDF */}
                  <div className="print:block hidden space-y-2 mt-4 pt-4 border-t">
                    <h3 className="font-semibold text-sm">Order Details:</h3>
                    {items.map((item, index) => (
                      <div key={item.id} className="text-xs space-y-1">
                        <p><strong>Item {index + 1}:</strong> {item.modelName}</p>
                        <p><strong>Quantity:</strong> {item.quantity}</p>
                        <p><strong>Price:</strong> ₹{item.totalPrice.toLocaleString()}</p>
                        {item.customerDetails && (
                          <div className="ml-2">
                            <p><strong>Customer:</strong> {item.customerDetails.name}</p>
                            <p><strong>Email:</strong> {item.customerDetails.email}</p>
                            <p><strong>Phone:</strong> {item.customerDetails.phone}</p>
                          </div>
                        )}
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
