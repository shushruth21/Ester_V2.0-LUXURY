import React, { useState, useEffect } from 'react';
import { useAuth } from '@/contexts/AuthContext';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { useToast } from '@/hooks/use-toast';
import { getAllJobCards, updateJobCardStatus, type JobCard } from '@/services/jobCardService';
import { Clock, Package, User, CheckCircle, Settings } from 'lucide-react';
import { Link } from 'react-router-dom';

export const StaffDashboard = () => {
  const { user, userType } = useAuth();
  const { toast } = useToast();
  const [jobCards, setJobCards] = useState<JobCard[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (userType === 'staff') {
      fetchJobCards();
    }
  }, [userType]);

  const fetchJobCards = async () => {
    try {
      const cards = await getAllJobCards();
      setJobCards(cards);
    } catch (error) {
      console.error('Error fetching job cards:', error);
      toast({
        title: "Error",
        description: "Failed to load job cards",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  const handleStatusUpdate = async (jobCardId: string, newStatus: string) => {
    try {
      await updateJobCardStatus(jobCardId, newStatus);
      await fetchJobCards(); // Refresh the list
      toast({
        title: "Success",
        description: "Job card status updated",
      });
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to update status",
        variant: "destructive",
      });
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'pending':
        return 'secondary';
      case 'in_progress':
        return 'default';
      case 'completed':
        return 'default';
      default:
        return 'secondary';
    }
  };

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'high':
        return 'destructive';
      case 'normal':
        return 'secondary';
      case 'low':
        return 'outline';
      default:
        return 'secondary';
    }
  };

  if (userType !== 'staff') {
    return (
      <div className="min-h-screen bg-background py-8">
        <div className="container mx-auto px-4">
          <Card className="max-w-md mx-auto">
            <CardHeader>
              <CardTitle>Access Denied</CardTitle>
              <CardDescription>Staff access required</CardDescription>
            </CardHeader>
          </Card>
        </div>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-background py-8">
        <div className="container mx-auto px-4">
          <div className="text-center">Loading job cards...</div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background py-8">
      <div className="container mx-auto px-4">
        <div className="mb-8">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold flex items-center gap-2">
                <CheckCircle className="h-8 w-8 text-green-600" />
                Staff Dashboard
              </h1>
              <p className="text-muted-foreground mt-2">Production workflow management system</p>
            </div>
            <div className="flex gap-3">
              <Link to="/orders">
                <Button variant="outline" className="flex items-center gap-2">
                  <Settings className="h-4 w-4" />
                  Manage Orders
                </Button>
              </Link>
              <Button onClick={fetchJobCards} variant="outline" className="flex items-center gap-2">
                <Package className="h-4 w-4" />
                Refresh
              </Button>
            </div>
          </div>
        </div>

        {/* Dashboard Stats */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
          <Card className="border-l-4 border-l-blue-500">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Total Jobs</p>
                  <p className="text-2xl font-bold">{jobCards.length}</p>
                </div>
                <Package className="h-8 w-8 text-blue-500" />
              </div>
            </CardContent>
          </Card>
          <Card className="border-l-4 border-l-yellow-500">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Pending</p>
                  <p className="text-2xl font-bold">{jobCards.filter(card => card.status === 'pending').length}</p>
                </div>
                <Clock className="h-8 w-8 text-yellow-500" />
              </div>
            </CardContent>
          </Card>
          <Card className="border-l-4 border-l-orange-500">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-muted-foreground">In Production</p>
                  <p className="text-2xl font-bold">{jobCards.filter(card => card.status === 'in_production').length}</p>
                </div>
                <User className="h-8 w-8 text-orange-500" />
              </div>
            </CardContent>
          </Card>
          <Card className="border-l-4 border-l-green-500">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Completed</p>
                  <p className="text-2xl font-bold">{jobCards.filter(card => card.status === 'completed').length}</p>
                </div>
                <CheckCircle className="h-8 w-8 text-green-500" />
              </div>
            </CardContent>
          </Card>
        </div>

        <div className="grid gap-6">
          {jobCards.length === 0 ? (
            <Card>
              <CardContent className="py-8 text-center">
                <Package className="h-12 w-12 mx-auto mb-4 text-muted-foreground" />
                <p className="text-muted-foreground">No job cards available</p>
              </CardContent>
            </Card>
          ) : (
            jobCards.map((jobCard) => (
              <Card key={jobCard.id}>
                <CardHeader>
                  <div className="flex justify-between items-start">
                    <div>
                      <CardTitle className="flex items-center gap-2">
                        <Package className="h-5 w-5" />
                        {jobCard.job_number}
                      </CardTitle>
                      <CardDescription>
                        Order ID: {jobCard.order_id}
                      </CardDescription>
                    </div>
                    <div className="flex gap-2">
                      <Badge variant={getPriorityColor(jobCard.priority)}>
                        {jobCard.priority}
                      </Badge>
                      <Badge variant={getStatusColor(jobCard.status)}>
                        {jobCard.status}
                      </Badge>
                    </div>
                  </div>
                </CardHeader>
                <CardContent className="space-y-4">
                  {/* Customer Details */}
                  <div className="flex items-start gap-3">
                    <User className="h-4 w-4 mt-1 text-muted-foreground" />
                    <div>
                      <p className="font-medium">Customer</p>
                      <p className="text-sm text-muted-foreground">
                        {jobCard.customer_details?.name || 'N/A'}
                      </p>
                      <p className="text-sm text-muted-foreground">
                        {jobCard.customer_details?.email || 'N/A'}
                      </p>
                    </div>
                  </div>

                  {/* Product Details */}
                  <div>
                    <p className="font-medium mb-2">Product Details</p>
                    <div className="bg-muted p-3 rounded-lg text-sm">
                      <p><strong>Model:</strong> {jobCard.product_details?.modelName || 'N/A'}</p>
                      <p><strong>Quantity:</strong> {jobCard.product_details?.quantity || 'N/A'}</p>
                      <p><strong>Total Price:</strong> ₹{jobCard.product_details?.totalPrice?.toLocaleString() || 'N/A'}</p>
                    </div>
                  </div>

                  {/* Configuration Details */}
                  {jobCard.configuration_details && Object.keys(jobCard.configuration_details).length > 0 && (
                    <div>
                      <p className="font-medium mb-2">Configuration</p>
                      <div className="bg-muted p-3 rounded-lg text-sm space-y-1">
                        {Object.entries(jobCard.configuration_details?.attributes || {}).map(([key, value]: [string, any]) => (
                          <div key={key}>
                            <strong>{value.display_name}:</strong> {value.selected_value}
                            {value.price_modifier && value.price_modifier !== 0 && (
                              <span className="ml-1 text-primary">
                                ({value.price_modifier > 0 ? '+' : ''}₹{value.price_modifier.toLocaleString()})
                              </span>
                            )}
                          </div>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Timeline */}
                  <div className="flex items-center gap-3">
                    <Clock className="h-4 w-4 text-muted-foreground" />
                    <div className="text-sm">
                      <p>Created: {new Date(jobCard.created_at).toLocaleDateString()}</p>
                      {jobCard.estimated_completion_date && (
                        <p>Estimated: {new Date(jobCard.estimated_completion_date).toLocaleDateString()}</p>
                      )}
                    </div>
                  </div>

                  {/* Notes */}
                  {jobCard.notes && (
                    <div>
                      <p className="font-medium mb-1">Notes</p>
                      <p className="text-sm text-muted-foreground bg-muted p-2 rounded">
                        {jobCard.notes}
                      </p>
                    </div>
                  )}

                  {/* Actions */}
                  <div className="flex gap-2 pt-4">
                    {jobCard.status === 'pending' && (
                      <Button
                        size="sm"
                        onClick={() => handleStatusUpdate(jobCard.id, 'in_progress')}
                      >
                        Start Production
                      </Button>
                    )}
                    {jobCard.status === 'in_progress' && (
                      <Button
                        size="sm"
                        onClick={() => handleStatusUpdate(jobCard.id, 'completed')}
                        className="flex items-center gap-2"
                      >
                        <CheckCircle className="h-4 w-4" />
                        Mark Complete
                      </Button>
                    )}
                  </div>
                </CardContent>
              </Card>
            ))
          )}
        </div>
      </div>
    </div>
  );
};