import { useState, useEffect } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { getCustomerOrders, deleteOrder } from "@/services/orderService";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { Calendar, Package, Clock, DollarSign, Plus, Eye, Trash2 } from "lucide-react";
import { Link } from "react-router-dom";
import { toast } from "sonner";

interface Order {
  id: string;
  model_id: string;
  customer_name: string;
  customer_email: string;
  customer_phone: string;
  configuration: any;
  total_price: number;
  remarks: string;
  status: string;
  created_at: string;
  updated_at: string;
}

export const CustomerDashboard = () => {
  const { user, userData } = useAuth();
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (user?.email) {
      fetchOrders();
    }
  }, [user?.email]);

  const fetchOrders = async () => {
    if (!user?.email) return;
    
    try {
      setLoading(true);
      const customerOrders = await getCustomerOrders(user.email);
      setOrders(customerOrders);
    } catch (error) {
      console.error('Error fetching orders:', error);
      toast.error('Failed to fetch orders');
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteOrder = async (orderId: string, orderName: string) => {
    if (!confirm(`Are you sure you want to delete the order "${orderName}"? This action cannot be undone.`)) {
      return;
    }

    try {
      const success = await deleteOrder(orderId);
      if (success) {
        toast.success('Order deleted successfully');
        // Refresh orders list
        fetchOrders();
      } else {
        toast.error('Failed to delete order');
      }
    } catch (error) {
      console.error('Error deleting order:', error);
      toast.error('Failed to delete order');
    }
  };

  const getStatusBadge = (status: string) => {
    const statusConfig = {
      pending: { variant: "secondary" as const, text: "Pending" },
      confirmed: { variant: "default" as const, text: "Confirmed" },
      in_production: { variant: "outline" as const, text: "In Production" },
      completed: { variant: "default" as const, text: "Completed" },
      delivered: { variant: "default" as const, text: "Delivered" }
    };

    const config = statusConfig[status as keyof typeof statusConfig] || 
                   { variant: "secondary" as const, text: status };

    return (
      <Badge variant={config.variant} className="capitalize">
        {config.text}
      </Badge>
    );
  };

  const getOrderStats = () => {
    const totalOrders = orders.length;
    const pendingOrders = orders.filter(order => order.status === 'pending').length;
    const completedOrders = orders.filter(order => order.status === 'completed' || order.status === 'delivered').length;
    const totalSpent = orders.reduce((sum, order) => sum + Number(order.total_price), 0);

    return { totalOrders, pendingOrders, completedOrders, totalSpent };
  };

  const stats = getOrderStats();

  if (loading) {
    return (
      <div className="container mx-auto p-6">
        <div className="flex items-center justify-center min-h-[400px]">
          <div className="text-lg">Loading your orders...</div>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto p-6 space-y-8">
      {/* Welcome Section */}
      <div className="space-y-2">
        <h1 className="text-3xl font-bold tracking-tight">
          Welcome back, {userData?.full_name || user?.email}!
        </h1>
        <p className="text-muted-foreground">
          Track your orders and manage your furniture configurations
        </p>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Orders</CardTitle>
            <Package className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.totalOrders}</div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Pending Orders</CardTitle>
            <Clock className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.pendingOrders}</div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Completed Orders</CardTitle>
            <Package className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.completedOrders}</div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Spent</CardTitle>
            <DollarSign className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">₹{stats.totalSpent.toLocaleString()}</div>
          </CardContent>
        </Card>
      </div>

      {/* Quick Actions */}
      <div className="flex flex-wrap gap-4">
        <Button asChild>
          <Link to="/">
            <Plus className="h-4 w-4 mr-2" />
            Place New Order
          </Link>
        </Button>
        <Button variant="outline" asChild>
          <Link to="/profile">
            <Eye className="h-4 w-4 mr-2" />
            View Profile
          </Link>
        </Button>
      </div>

      <Separator />

      {/* Recent Orders */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-2xl font-bold tracking-tight">Your Orders</h2>
        </div>

        {orders.length === 0 ? (
          <Card>
            <CardContent className="flex flex-col items-center justify-center py-12">
              <Package className="h-12 w-12 text-muted-foreground mb-4" />
              <h3 className="text-lg font-medium mb-2">No orders yet</h3>
              <p className="text-muted-foreground text-center mb-4">
                Start exploring our furniture collection to place your first order
              </p>
              <Button asChild>
                <Link to="/">Browse Furniture</Link>
              </Button>
            </CardContent>
          </Card>
        ) : (
          <div className="grid gap-6">
            {orders.map((order) => (
              <Card key={order.id}>
                <CardHeader>
                  <div className="flex items-center justify-between">
                    <div className="space-y-1">
                      <CardTitle className="text-lg">
                        {order.configuration?.modelName || 'Custom Order'}
                      </CardTitle>
                      <CardDescription>
                        Order placed on {new Date(order.created_at).toLocaleDateString()}
                      </CardDescription>
                    </div>
                    {getStatusBadge(order.status)}
                  </div>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <h4 className="font-medium">Order Details</h4>
                      <div className="text-sm text-muted-foreground space-y-1">
                        <div className="flex items-center gap-2">
                          <Calendar className="h-4 w-4" />
                          Ordered: {new Date(order.created_at).toLocaleDateString()}
                        </div>
                        <div className="flex items-center gap-2">
                          <DollarSign className="h-4 w-4" />
                          Total: ₹{Number(order.total_price).toLocaleString()}
                        </div>
                        {order.configuration?.quantity && (
                          <div className="flex items-center gap-2">
                            <Package className="h-4 w-4" />
                            Quantity: {order.configuration.quantity}
                          </div>
                        )}
                      </div>
                    </div>

                    {order.configuration && (
                      <div className="space-y-2">
                        <h4 className="font-medium">Configuration</h4>
                        <div className="text-sm text-muted-foreground space-y-1">
                          {Object.entries(order.configuration)
                            .filter(([key]) => !['modelName', 'basePrice', 'quantity'].includes(key))
                            .map(([key, value]) => (
                              <div key={key} className="flex justify-between">
                                <span className="capitalize">{key.replace(/_/g, ' ')}:</span>
                                <span>{String(value)}</span>
                              </div>
                            ))}
                        </div>
                      </div>
                    )}
                  </div>

                  {order.remarks && (
                    <div className="pt-2 border-t">
                      <h4 className="font-medium mb-1">Remarks</h4>
                      <p className="text-sm text-muted-foreground">{order.remarks}</p>
                    </div>
                  )}

                  {/* Delete button - only show for pending orders */}
                  {order.status === 'pending' && (
                    <div className="pt-2 border-t">
                      <Button
                        variant="destructive"
                        size="sm"
                        onClick={() => handleDeleteOrder(order.id, order.configuration?.modelName || 'Custom Order')}
                      >
                        <Trash2 className="h-4 w-4 mr-2" />
                        Delete Order
                      </Button>
                    </div>
                  )}
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};