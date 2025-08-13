import { useState, useEffect } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { useToast } from "@/hooks/use-toast";
import { CheckCircle, Calendar, Package, ArrowLeft, Home } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";

interface Order {
  id: string;
  customer_name: string;
  customer_email: string;
  customer_phone: string;
  total_price: number;
  status: string;
  verified_at: string;
  verification_code: string;
  configuration: any;
  model_id: string;
  created_at: string;
}

export const OrderVerificationPage = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [order, setOrder] = useState<Order | null>(null);
  const [verificationDetails, setVerificationDetails] = useState<any>(null);
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const { toast } = useToast();

  const orderId = searchParams.get('orderId');
  const verificationCode = searchParams.get('code');

  useEffect(() => {
    if (!orderId || !verificationCode) {
      toast({
        title: "Invalid Verification Link",
        description: "The verification link is invalid or expired.",
        variant: "destructive",
      });
      navigate('/home');
      return;
    }

    fetchOrderDetails();
  }, [orderId, verificationCode]);

  const fetchOrderDetails = async () => {
    try {
      // Fetch order details
      const { data: orderData, error: orderError } = await supabase
        .from('orders')
        .select('*')
        .eq('id', orderId)
        .eq('verification_code', verificationCode)
        .single();

      if (orderError) {
        throw new Error('Order not found or verification code invalid');
      }

      setOrder(orderData);

      // Fetch verification details
      const { data: verificationData } = await supabase
        .from('order_verifications')
        .select('*')
        .eq('order_id', orderId)
        .eq('verification_code', verificationCode)
        .single();

      setVerificationDetails(verificationData);

    } catch (error) {
      console.error('Error fetching order details:', error);
      toast({
        title: "Verification Failed",
        description: "Could not verify the order. Please check your verification link.",
        variant: "destructive",
      });
      navigate('/home');
    } finally {
      setIsLoading(false);
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
          <p className="text-muted-foreground">Verifying your order...</p>
        </div>
      </div>
    );
  }

  if (!order) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <Card className="max-w-md">
          <CardHeader>
            <CardTitle className="text-destructive">Verification Failed</CardTitle>
            <CardDescription>
              The order could not be verified. Please check your verification link.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Button onClick={() => navigate('/home')} className="w-full">
              <Home className="h-4 w-4 mr-2" />
              Return to Home
            </Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background py-8">
      <div className="container mx-auto px-4 max-w-4xl">
        <div className="flex items-center gap-4 mb-8">
          <Button 
            variant="ghost" 
            size="sm" 
            onClick={() => navigate('/home')}
            className="flex items-center gap-2"
          >
            <ArrowLeft className="h-4 w-4" />
            Back to Home
          </Button>
          <h1 className="text-2xl font-bold">Order Verification</h1>
        </div>

        <div className="space-y-6">
          {/* Verification Status */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-green-600">
                <CheckCircle className="h-6 w-6" />
                Order Successfully Verified
              </CardTitle>
              <CardDescription>
                Your order has been verified and is now confirmed for production.
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid md:grid-cols-2 gap-4">
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Verification Code</p>
                  <p className="font-mono text-lg">{order.verification_code}</p>
                </div>
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Verified At</p>
                  <p className="text-lg">{new Date(order.verified_at).toLocaleString()}</p>
                </div>
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Order Status</p>
                  <Badge variant="secondary" className="bg-green-100 text-green-800">
                    {order.status.toUpperCase()}
                  </Badge>
                </div>
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Total Amount</p>
                  <p className="text-lg font-semibold">₹{order.total_price.toLocaleString()}</p>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Customer Details */}
          <Card>
            <CardHeader>
              <CardTitle>Customer Information</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <div>
                <p className="text-sm font-medium text-muted-foreground">Name</p>
                <p>{order.customer_name}</p>
              </div>
              <div>
                <p className="text-sm font-medium text-muted-foreground">Email</p>
                <p>{order.customer_email}</p>
              </div>
              {order.customer_phone && (
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Phone</p>
                  <p>{order.customer_phone}</p>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Order Configuration */}
          {order.configuration && Object.keys(order.configuration).length > 0 && (
            <Card>
              <CardHeader>
                <CardTitle>Product Configuration</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-2">
                  {Object.entries(order.configuration.attributes || {}).map(([key, value]: [string, any]) => (
                    <div key={key} className="flex justify-between py-2 border-b border-border last:border-0">
                      <span className="capitalize text-muted-foreground">{key.replace(/([A-Z])/g, ' $1').trim()}</span>
                      <span className="font-medium">{value}</span>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}

          {/* Next Steps */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Package className="h-5 w-5" />
                What Happens Next?
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-3">
                <div className="flex items-start gap-3">
                  <div className="w-6 h-6 rounded-full bg-primary text-primary-foreground flex items-center justify-center text-sm font-medium">1</div>
                  <div>
                    <p className="font-medium">Production Planning</p>
                    <p className="text-sm text-muted-foreground">Our team will create a detailed production plan for your custom furniture</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <div className="w-6 h-6 rounded-full bg-primary text-primary-foreground flex items-center justify-center text-sm font-medium">2</div>
                  <div>
                    <p className="font-medium">Manufacturing</p>
                    <p className="text-sm text-muted-foreground">Skilled craftsmen will begin creating your furniture with attention to every detail</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <div className="w-6 h-6 rounded-full bg-primary text-primary-foreground flex items-center justify-center text-sm font-medium">3</div>
                  <div>
                    <p className="font-medium">Quality Check & Delivery</p>
                    <p className="text-sm text-muted-foreground">Final quality inspection and scheduled delivery to your location</p>
                  </div>
                </div>
              </div>
              
              <div className="bg-muted p-4 rounded-lg mt-6">
                <div className="flex items-center gap-2 mb-2">
                  <Calendar className="h-4 w-4" />
                  <span className="font-medium">Estimated Timeline</span>
                </div>
                <p className="text-sm text-muted-foreground">
                  Your order will be completed within 4-6 weeks from verification. 
                  You'll receive regular updates via email and SMS.
                </p>
              </div>
            </CardContent>
          </Card>

          {/* Contact Information */}
          <Card>
            <CardHeader>
              <CardTitle>Need Help?</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-sm text-muted-foreground mb-4">
                If you have any questions about your order, please contact us:
              </p>
              <div className="space-y-2 text-sm">
                <p><strong>Email:</strong> orders@estre.in</p>
                <p><strong>Phone:</strong> +91-8087-ESTRE</p>
                <p><strong>Order Reference:</strong> {order.verification_code}</p>
              </div>
            </CardContent>
          </Card>

          {/* Action Buttons */}
          <div className="flex gap-4">
            <Button onClick={() => navigate('/home')} variant="outline" className="flex-1">
              <Home className="h-4 w-4 mr-2" />
              Return to Home
            </Button>
            <Button 
              onClick={() => window.print()} 
              variant="secondary" 
              className="flex-1"
            >
              Print Confirmation
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
};