
import { useParams, useNavigate } from "react-router-dom";
import { useState, useMemo, useEffect } from "react";
import { useModelBySlug, useCategoryBySlug } from "@/hooks/useCategories";
import { useModelAttributes } from "@/hooks/useModelAttributes";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { useToast } from "@/hooks/use-toast";
import { ArrowLeft, ShoppingCart } from "lucide-react";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { useCart } from "@/contexts/CartContext";
import { useAuth } from "@/contexts/AuthContext";
import { ImageGallery } from "@/components/ImageGallery";

export const ModelConfiguratorPage = () => {
  const { slug } = useParams<{ slug: string }>();
  const navigate = useNavigate();
  const { data: model, isLoading, error } = useModelBySlug(slug || "");
  const { data: attributes, isLoading: attributesLoading } = useModelAttributes(model?.id || "");
  const { toast } = useToast();
  const { addItem } = useCart();
  const { user, userData } = useAuth();
  
  // Get category information to create proper back navigation
  const [categorySlug, setCategorySlug] = useState<string>("");
  
  useEffect(() => {
    if (model?.category_id) {
      // Fetch category to get slug
      supabase
        .from("categories")
        .select("slug")
        .eq("id", model.category_id)
        .single()
        .then(({ data }) => {
          if (data) {
            setCategorySlug(data.slug);
          }
        });
    }
  }, [model?.category_id]);
  
  const [selectedValues, setSelectedValues] = useState<Record<string, string>>({});
  const [remarks, setRemarks] = useState<string>("");
  const [customerDetails, setCustomerDetails] = useState({
    name: "",
    email: "",
    phone: ""
  });

  // Auto-fill customer details from auth
  useEffect(() => {
    if (user && userData) {
      setCustomerDetails({
        name: userData.full_name || "",
        email: userData.email || "",
        phone: ('mobile' in userData ? userData.mobile : '') || ""
      });
    }
  }, [user, userData]);
  const [showCartSummary, setShowCartSummary] = useState(false);
  const [isProcessing, setIsProcessing] = useState(false);
  
  // Calculate total price based on selected attributes
  const totalPrice = useMemo(() => {
    if (!model || !attributes) return Number(model?.base_price || 0);
    
    const basePrice = Number(model.base_price);
    const additionalCost = attributes.reduce((total, attr) => {
      const selectedValueId = selectedValues[attr.attribute_type_id];
      if (!selectedValueId) return total;
      
      const selectedValue = attr.attribute_values.find(val => val.id === selectedValueId);
      return total + Number(selectedValue?.price_modifier || 0);
    }, 0);
    
    return basePrice + additionalCost;
  }, [model, attributes, selectedValues]);
  
  // Initialize default values
  useEffect(() => {
    if (attributes && Object.keys(selectedValues).length === 0) {
      const defaultValues: Record<string, string> = {};
      attributes.forEach(attr => {
        if (attr.default_value_id) {
          defaultValues[attr.attribute_type_id] = attr.default_value_id;
        } else if (attr.attribute_values.length > 0) {
          defaultValues[attr.attribute_type_id] = attr.attribute_values[0].id;
        } else if (attr.attribute_type.input_type === 'input') {
          // For input fields, set an empty string as default
          defaultValues[attr.attribute_type_id] = '';
        }
      });
      setSelectedValues(defaultValues);
    }
  }, [attributes]);
  
  const handleAttributeChange = (attributeTypeId: string, valueId: string) => {
    setSelectedValues(prev => ({
      ...prev,
      [attributeTypeId]: valueId
    }));
  };
  
  const validateCustomerDetails = () => {
    if (!customerDetails.name.trim()) {
      toast({
        title: "Missing Information",
        description: "Please enter your full name.",
        variant: "destructive"
      });
      return false;
    }
    if (!customerDetails.email.trim()) {
      toast({
        title: "Missing Information", 
        description: "Please enter your email address.",
        variant: "destructive"
      });
      return false;
    }
    if (!customerDetails.phone.trim()) {
      toast({
        title: "Missing Information",
        description: "Please enter your phone number.",
        variant: "destructive"
      });
      return false;
    }
    return true;
  };

  const createOrderConfiguration = () => {
    if (!attributes || !model) return {};
    
    const configuration: Record<string, any> = {};
    attributes.forEach(attr => {
      const selectedValueId = selectedValues[attr.attribute_type_id];
      
      if (attr.attribute_type.input_type === 'input') {
        // For input fields, store the raw value
        configuration[attr.attribute_type.name] = {
          display_name: attr.attribute_type.display_name,
          selected_value: selectedValueId || '',
          price_modifier: 0
        };
      } else {
        // For select/color fields, find the selected value
        const selectedValue = attr.attribute_values.find(val => val.id === selectedValueId);
        if (selectedValue) {
          configuration[attr.attribute_type.name] = {
            display_name: attr.attribute_type.display_name,
            selected_value: selectedValue.display_name,
            price_modifier: Number(selectedValue.price_modifier)
          };
        }
      }
    });
    
    return {
      model_name: model.name,
      base_price: Number(model.base_price),
      total_price: totalPrice,
      attributes: configuration,
      remarks: remarks
    };
  };

  const handleAddToCart = async () => {
    if (!validateCustomerDetails() || !model) return;
    
    setIsProcessing(true);
    
    try {
      // Add item to cart
      addItem({
        modelId: model.id,
        modelName: model.name,
        basePrice: Number(model.base_price),
        totalPrice: totalPrice,
        configuration: createOrderConfiguration(),
        customerDetails: customerDetails,
        remarks: remarks
      });

      toast({
        title: "Added to Cart",
        description: `${model.name} has been added to your cart.`,
      });

      // Navigate to cart page
      navigate('/cart');
      
    } catch (error) {
      console.error('Error adding to cart:', error);
      toast({
        title: "Error",
        description: "Failed to add item to cart. Please try again.",
        variant: "destructive"
      });
    } finally {
      setIsProcessing(false);
    }
  };

  const handleRequestQuote = async () => {
    if (!validateCustomerDetails()) return;
    
    setIsProcessing(true);
    
    try {
      
      const configuration = createOrderConfiguration();
      
      const { data: order, error } = await supabase
        .from('orders')
        .insert({
          customer_email: customerDetails.email,
          customer_name: customerDetails.name,
          customer_phone: customerDetails.phone,
          model_id: model!.id,
          total_price: totalPrice,
          remarks: remarks,
          configuration: configuration,
          status: 'quote_requested'
        })
        .select()
        .single();

      if (error) throw error;

      toast({
        title: "Quote Requested Successfully",
        description: "We'll contact you soon with a detailed quote for your custom configuration.",
      });
      
      // Reset form
      setCustomerDetails({ name: "", email: "", phone: "" });
      setRemarks("");
      
    } catch (error) {
      console.error('Error creating quote request:', error);
      toast({
        title: "Error",
        description: "Failed to submit quote request. Please try again.",
        variant: "destructive"
      });
    } finally {
      setIsProcessing(false);
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background">
        <main className="container mx-auto px-4 py-6">
          <div className="space-y-6">
            <Skeleton className="h-8 w-64" />
            <Skeleton className="h-96 w-full" />
            <Skeleton className="h-32 w-full" />
            <Skeleton className="h-48 w-full" />
          </div>
        </main>
      </div>
    );
  }

  if (error || !model) {
    return (
      <div className="min-h-screen bg-background">
        <main className="container mx-auto px-4 py-6">
          <div className="text-center">
            <h1 className="text-2xl font-bold text-foreground mb-4">Model Not Found</h1>
            <p className="text-muted-foreground mb-4">The furniture model you're looking for doesn't exist.</p>
            <Button asChild className="mt-4">
              <a href="/categories">Browse All Categories</a>
            </Button>
          </div>
        </main>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      <main className="px-4 py-6">
        <div className="max-w-4xl mx-auto space-y-6">
          {/* Back Button */}
          <Button 
            variant="ghost" 
            onClick={() => navigate(categorySlug ? `/category/${categorySlug}` : '/categories')}
            className="flex items-center gap-2 p-2 h-auto"
          >
            <ArrowLeft className="h-4 w-4" />
            Back
          </Button>

          {/* Product Image Gallery */}
          <ImageGallery 
            modelId={model.id}
            className="max-w-full"
            showPrimaryBadge={true}
            allowFullscreen={true}
          />

          {/* Product Info */}
          <div className="space-y-6">
            <div>
              <h1 className="text-2xl font-bold text-foreground mb-2">{model.name}</h1>
              {model.description && (
                <p className="text-muted-foreground mb-4">{model.description}</p>
              )}
              {/* Enhanced Price Breakdown */}
              <div className="space-y-2">
                <div className="flex items-center justify-between">
                  <span className="text-lg text-muted-foreground">Base Price:</span>
                  <span className="text-lg font-medium">₹{Number(model.base_price).toLocaleString()}</span>
                </div>
                {attributes && Object.keys(selectedValues).length > 0 && (() => {
                  const additionalCosts = attributes
                    .map(attr => {
                      const selectedValueId = selectedValues[attr.attribute_type_id];
                      const selectedValue = attr.attribute_values.find(val => val.id === selectedValueId);
                      const priceModifier = Number(selectedValue?.price_modifier || 0);
                      return {
                        name: attr.attribute_type.display_name,
                        value: selectedValue?.display_name || '',
                        modifier: priceModifier
                      };
                    })
                    .filter(item => item.modifier !== 0);
                  
                  return additionalCosts.map((item, index) => (
                    <div key={index} className="flex items-center justify-between text-sm">
                      <span className="text-muted-foreground">{item.name} ({item.value}):</span>
                      <span className={item.modifier > 0 ? "text-green-600" : "text-red-600"}>
                        {item.modifier > 0 ? '+' : ''}₹{item.modifier.toLocaleString()}
                      </span>
                    </div>
                  ));
                })()}
                <div className="border-t pt-2">
                  <div className="flex items-center justify-between">
                    <span className="text-xl font-bold text-foreground">Total:</span>
                    <span className="text-2xl font-bold text-primary">₹{totalPrice.toLocaleString()}</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Configuration Options */}
            {attributesLoading ? (
              <Card>
                <CardHeader>
                  <CardTitle>Loading Configuration Options...</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    {[1, 2, 3, 4, 5].map((i) => (
                      <div key={i} className="space-y-2">
                        <Skeleton className="h-4 w-32" />
                        <Skeleton className="h-10 w-full" />
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            ) : attributes && attributes.length > 0 ? (
              <Card>
                <CardHeader>
                  <CardTitle>Customize Your {model.name}</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-6">
                    {attributes.map((attr) => (
                      <div key={attr.id} className="space-y-3">
                        <div className="flex items-center gap-2">
                          <label className="text-sm font-medium text-foreground">
                            {attr.attribute_type.display_name}
                          </label>
                          {attr.is_required && (
                            <Badge variant="secondary" className="text-xs">Required</Badge>
                          )}
                        </div>
                        
                        {attr.attribute_type.input_type === 'color' ? (
                          <div className="flex flex-wrap gap-4">
                            {attr.attribute_values.map((value) => (
                              <button
                                key={value.id}
                                onClick={() => handleAttributeChange(attr.attribute_type_id, value.id)}
                                className={`w-16 h-16 md:w-12 md:h-12 rounded-lg border-2 flex items-center justify-center transition-all touch-manipulation ${
                                  selectedValues[attr.attribute_type_id] === value.id
                                    ? 'border-primary shadow-lg scale-110'
                                    : 'border-muted hover:border-muted-foreground'
                                }`}
                                style={{ backgroundColor: value.hex_color || '#ccc' }}
                                title={value.display_name}
                              >
                                {selectedValues[attr.attribute_type_id] === value.id && (
                                  <span className="text-white text-lg">✓</span>
                                )}
                              </button>
                            ))}
                          </div>
                        ) : attr.attribute_type.input_type === 'input' ? (
                          <Input
                            value={selectedValues[attr.attribute_type_id] || ''}
                            onChange={(e) => handleAttributeChange(attr.attribute_type_id, e.target.value)}
                            placeholder={`Enter ${attr.attribute_type.display_name.toLowerCase()}`}
                            className="w-full"
                          />
                        ) : (
                          <Select
                            value={selectedValues[attr.attribute_type_id] || ''}
                            onValueChange={(value) => handleAttributeChange(attr.attribute_type_id, value)}
                          >
                            <SelectTrigger className="w-full">
                              <SelectValue placeholder={`Select ${attr.attribute_type.display_name}`} />
                            </SelectTrigger>
                            <SelectContent>
                              {attr.attribute_values.map((value) => (
                                <SelectItem key={value.id} value={value.id}>
                                  <div className="flex items-center justify-between w-full">
                                    <span>{value.display_name}</span>
                                     {Number(value.price_modifier) !== 0 && (
                                       <span className="ml-2 text-sm text-muted-foreground">
                                         {Number(value.price_modifier) > 0 ? '+' : ''}₹{Number(value.price_modifier).toLocaleString()}
                                       </span>
                                     )}
                                  </div>
                                </SelectItem>
                              ))}
                            </SelectContent>
                          </Select>
                        )}
                        
                        {/* Show selected value price modifier */}
                        {(() => {
                          const selectedValueId = selectedValues[attr.attribute_type_id];
                          const selectedValue = attr.attribute_values.find(val => val.id === selectedValueId);
                          const priceModifier = Number(selectedValue?.price_modifier || 0);
                          
                          if (priceModifier !== 0) {
                             return (
                               <p className="text-sm text-muted-foreground">
                                 {priceModifier > 0 ? '+' : ''}₹{priceModifier.toLocaleString()} price adjustment
                               </p>
                             );
                          }
                          return null;
                        })()}
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            ) : (
              <Card>
                <CardHeader>
                  <CardTitle>Customize Your {model.name}</CardTitle>
                </CardHeader>
                <CardContent>
                  <p className="text-muted-foreground">
                    No customization options available for this model. Contact us for custom configurations.
                  </p>
                </CardContent>
              </Card>
            )}

            {/* Customer Details & Remarks */}
            <Card>
              <CardHeader>
                <CardTitle>Customer Details & Additional Requirements</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label htmlFor="customer-name">Full Name *</Label>
                      <Input
                        id="customer-name"
                        placeholder="Enter your full name"
                        value={customerDetails.name}
                        onChange={(e) => setCustomerDetails(prev => ({ ...prev, name: e.target.value }))}
                      />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="customer-phone">Phone Number *</Label>
                      <Input
                        id="customer-phone"
                        placeholder="Enter your phone number"
                        value={customerDetails.phone}
                        onChange={(e) => setCustomerDetails(prev => ({ ...prev, phone: e.target.value }))}
                      />
                    </div>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="customer-email">Email Address *</Label>
                    <Input
                      id="customer-email"
                      type="email"
                      placeholder="Enter your email address"
                      value={customerDetails.email}
                      onChange={(e) => setCustomerDetails(prev => ({ ...prev, email: e.target.value }))}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="remarks">Additional Remarks/Requirements</Label>
                    <Textarea
                      id="remarks"
                      placeholder="Any special requirements, color preferences, delivery instructions, or other notes..."
                      value={remarks}
                      onChange={(e) => setRemarks(e.target.value)}
                      rows={4}
                    />
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Action Buttons - Fixed layout and visibility */}
            <div className="sticky bottom-0 bg-background border-t pt-4 space-y-3">
              <Button 
                size="lg" 
                className="w-full touch-manipulation min-h-[48px] flex items-center justify-center gap-2"
                onClick={handleAddToCart}
                disabled={isProcessing}
              >
                {isProcessing ? (
                  "Processing..."
                ) : (
                  <>
                    <ShoppingCart className="h-5 w-5" />
                    Add to Cart - ₹{totalPrice.toLocaleString()}
                  </>
                )}
              </Button>
              <Button 
                variant="outline" 
                size="lg" 
                className="w-full touch-manipulation min-h-[48px]"
                onClick={handleRequestQuote}
                disabled={isProcessing}
              >
                {isProcessing ? "Processing..." : "Request Quote"}
              </Button>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
};
