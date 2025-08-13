import { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { useToast } from '@/hooks/use-toast';
import { supabase } from '@/integrations/supabase/client';
import { createJobCardFromOrder } from '@/services/jobCardService';
import { CheckCircle, Clock, Package, User } from 'lucide-react';

interface Order {
  id: string;
  customer_name: string;
  customer_email: string;
  customer_phone: string;
  total_price: number;
  status: string;
  configuration: any;
  created_at: string;
  model_id: string;
  remarks?: string;
  verified_at?: string;
  verification_code?: string;
}

export const OrderManagement = () => {
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [processingOrderId, setProcessingOrderId] = useState<string | null>(null);
  const { toast } = useToast();

  const fetchOrders = async () => {
    try {
      const { data, error } = await supabase
        .from('orders')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) {
        console.error('Error fetching orders:', error);
        toast({
          title: "Error",
          description: "Failed to fetch orders",
          variant: "destructive",
        });
        return;
      }

      setOrders(data || []);
    } catch (error) {
      console.error('Error in fetchOrders:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchOrders();
  }, []);

  const handleConfirmOrder = async (orderId: string) => {
    setProcessingOrderId(orderId);
    
    try {
      // Create job card from order
      const result = await createJobCardFromOrder(orderId);
      
      if (result.success) {
        toast({
          title: "Success",
          description: `Job card created successfully! Job Number: ${result.jobCard?.job_number}`,
        });
        
        // Refresh orders to show updated status
        await fetchOrders();
      } else {
        toast({
          title: "Error",
          description: result.error || "Failed to create job card",
          variant: "destructive",
        });
      }
    } catch (error) {
      console.error('Error confirming order:', error);
      toast({
        title: "Error",
        description: "An unexpected error occurred",
        variant: "destructive",
      });
    } finally {
      setProcessingOrderId(null);
    }
  };

  const getStatusBadge = (status: string) => {
    const variants: Record<string, "default" | "secondary" | "destructive" | "outline"> = {
      pending: "outline",
      confirmed: "default",
      in_production: "secondary",
      completed: "default",
      delivered: "secondary"
    };

    const colors: Record<string, string> = {
      pending: "text-yellow-600 border-yellow-600",
      confirmed: "text-green-600 bg-green-50",
      in_production: "text-blue-600 bg-blue-50",
      completed: "text-purple-600 bg-purple-50",
      delivered: "text-gray-600 bg-gray-50"
    };

    return (
      <Badge variant={variants[status] || "outline"} className={colors[status]}>
        {status.replace('_', ' ').toUpperCase()}
      </Badge>
    );
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center p-8">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold">Order Management</h2>
        <Button onClick={fetchOrders} variant="outline">
          Refresh Orders
        </Button>
      </div>

      <div className="grid gap-4">
        {orders.map((order) => (
          <Card key={order.id} className="w-full">
            <CardHeader className="pb-3">
              <div className="flex items-center justify-between">
                <CardTitle className="text-lg flex items-center gap-2">
                  <Package className="h-5 w-5" />
                  Order #{order.id.slice(-8)}
                </CardTitle>
                {getStatusBadge(order.status)}
              </div>
            </CardHeader>
            
            <CardContent className="space-y-4">
              <div className="grid md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <div className="flex items-center gap-2">
                    <User className="h-4 w-4 text-muted-foreground" />
                    <span className="font-medium">{order.customer_name}</span>
                  </div>
                  <p className="text-sm text-muted-foreground">{order.customer_email}</p>
                  {order.customer_phone && (
                    <p className="text-sm text-muted-foreground">{order.customer_phone}</p>
                  )}
                </div>
                
                <div className="space-y-2">
                  <div className="flex items-center gap-2">
                    <Clock className="h-4 w-4 text-muted-foreground" />
                    <span className="text-sm">
                      {new Date(order.created_at).toLocaleDateString()}
                    </span>
                  </div>
                  <p className="text-lg font-semibold">
                    ${order.total_price.toFixed(2)}
                  </p>
                </div>
              </div>

              {order.configuration && (
                <div className="p-4 bg-muted/50 rounded-lg space-y-3">
                  <h4 className="font-semibold text-lg mb-3">Complete Order Summary</h4>
                  
                  {/* Product Information */}
                  <div className="grid md:grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <h5 className="font-medium text-primary">Product Details</h5>
                      <div className="text-sm space-y-1">
                        <p><strong>Model:</strong> {order.configuration.model_name || 'N/A'}</p>
                        <p><strong>Category:</strong> {order.configuration.category || 'N/A'}</p>
                        <p><strong>Base Price:</strong> ${order.configuration.base_price?.toFixed(2) || '0.00'}</p>
                        <p><strong>Quantity:</strong> {order.configuration.quantity || 1}</p>
                      </div>
                    </div>
                    
                    <div className="space-y-2">
                      <h5 className="font-medium text-primary">Configuration</h5>
                      <div className="text-sm space-y-1">
                        {order.configuration.selectedAttributes && Object.keys(order.configuration.selectedAttributes).length > 0 ? (
                          Object.entries(order.configuration.selectedAttributes).map(([key, value]: [string, any]) => (
                            <p key={key}>
                              <strong>{key.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}:</strong> {value?.display_name || value}
                            </p>
                          ))
                        ) : (
                          <p className="text-muted-foreground">Standard configuration</p>
                        )}
                      </div>
                    </div>
                  </div>
                  
                  {/* Additional Details */}
                  <div className="space-y-2">
                    <h5 className="font-medium text-primary">Additional Information</h5>
                    <div className="text-sm space-y-1">
                      {order.configuration.deliveryAddress && (
                        <p><strong>Delivery Address:</strong> {order.configuration.deliveryAddress}</p>
                      )}
                      {order.configuration.deliveryDate && (
                        <p><strong>Requested Delivery:</strong> {new Date(order.configuration.deliveryDate).toLocaleDateString()}</p>
                      )}
                      {order.configuration.specialInstructions && (
                        <p><strong>Special Instructions:</strong> {order.configuration.specialInstructions}</p>
                      )}
                      {order.remarks && (
                        <p><strong>Customer Remarks:</strong> {order.remarks}</p>
                      )}
                    </div>
                  </div>
                  
                  {/* Pricing Breakdown */}
                  <div className="border-t pt-3">
                    <h5 className="font-medium text-primary mb-2">Pricing Breakdown</h5>
                    <div className="text-sm space-y-1">
                      <div className="flex justify-between">
                        <span>Base Price:</span>
                        <span>${order.configuration.base_price?.toFixed(2) || '0.00'}</span>
                      </div>
                      {order.configuration.customizationCost > 0 && (
                        <div className="flex justify-between">
                          <span>Customization:</span>
                          <span>+${order.configuration.customizationCost?.toFixed(2) || '0.00'}</span>
                        </div>
                      )}
                      <div className="flex justify-between font-semibold text-base border-t pt-1">
                        <span>Total Amount:</span>
                        <span>${order.total_price.toFixed(2)}</span>
                      </div>
                    </div>
                  </div>
                </div>
              )}

              <div className="flex justify-end gap-2">
                {order.status === 'pending' && (
                  <Button
                    onClick={() => handleConfirmOrder(order.id)}
                    disabled={processingOrderId === order.id}
                    className="flex items-center gap-2"
                  >
                    <CheckCircle className="h-4 w-4" />
                    {processingOrderId === order.id ? 'Creating Job Card...' : 'Confirm & Create Job Card'}
                  </Button>
                )}
                
                {order.status === 'confirmed' && (
                  <Badge variant="default" className="text-green-600 bg-green-50">
                    Job Card Created
                  </Badge>
                )}
              </div>
            </CardContent>
          </Card>
        ))}
        
        {orders.length === 0 && (
          <Card className="p-8 text-center">
            <p className="text-muted-foreground">No orders found</p>
          </Card>
        )}
      </div>
    </div>
  );
};