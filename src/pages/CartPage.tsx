
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ShoppingBag, Plus, Minus, Trash2, ArrowRight } from "lucide-react";
import { Link } from "react-router-dom";
import { useCart } from "@/contexts/CartContext";

export const CartPage = () => {
  const { items, removeItem, updateQuantity, getTotalItems, getTotalPrice } = useCart();

  const subtotal = getTotalPrice();
  const shipping = 99;
  const total = subtotal + shipping;

  return (
    <div className="min-h-screen bg-background">
      <main className="px-4 py-6">
        <div className="max-w-4xl mx-auto space-y-6">
          {/* Header */}
          <div className="text-center">
            <h1 className="text-2xl font-bold text-foreground mb-2">Shopping Cart</h1>
            <p className="text-muted-foreground">
              {getTotalItems()} {getTotalItems() === 1 ? 'item' : 'items'} in your cart
            </p>
          </div>

          {/* Cart Items */}
          {items.length === 0 ? (
            <div className="text-center py-12">
              <ShoppingBag className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
              <h2 className="text-xl font-semibold text-foreground mb-2">Your cart is empty</h2>
              <p className="text-muted-foreground mb-6">
                Add some beautiful furniture to get started
              </p>
              <Link to="/categories">
                <Button>
                  Start Shopping
                  <ArrowRight className="h-4 w-4 ml-2" />
                </Button>
              </Link>
            </div>
          ) : (
            <>
              <div className="space-y-4">
                {items.map((item) => (
                  <Card key={item.id} className="overflow-hidden">
                    <CardContent className="p-0">
                      <div className="flex">
                        <div className="w-24 h-24 bg-muted flex-shrink-0">
                          <div className="w-full h-full flex items-center justify-center text-muted-foreground text-xs">
                            {item.modelName.slice(0, 2).toUpperCase()}
                          </div>
                        </div>
                        <div className="flex-1 p-4">
                          <div className="flex justify-between items-start mb-2">
                            <div>
                              <h3 className="font-semibold text-foreground text-sm line-clamp-1">
                                {item.modelName}
                              </h3>
                              <p className="text-xs text-muted-foreground">
                                Base: ₹{item.basePrice.toLocaleString()}
                              </p>
                            </div>
                            <Button 
                              variant="ghost" 
                              size="sm" 
                              className="p-1 h-auto"
                              onClick={() => removeItem(item.id)}
                            >
                              <Trash2 className="h-4 w-4 text-destructive" />
                            </Button>
                          </div>
                          
                          {/* Detailed Configuration */}
                          <div className="mb-3">
                            <p className="text-xs text-muted-foreground mb-2 font-medium">Exact Configuration Selected:</p>
                            <div className="space-y-1 text-xs">
                              {Object.entries(item.configuration?.attributes || {}).map(([key, value]: [string, any]) => (
                                <div key={key} className="flex justify-between items-center">
                                  <span className="text-muted-foreground">{value.display_name}:</span>
                                  <span className="font-medium">{value.selected_value}</span>
                                  {value.price_modifier !== 0 && (
                                    <span className="text-xs text-primary ml-1">
                                      {value.price_modifier > 0 ? '+' : ''}₹{value.price_modifier}
                                    </span>
                                  )}
                                </div>
                              ))}
                            </div>
                            
                            {/* Customer Details */}
                            <div className="mt-3 pt-2 border-t border-border">
                              <p className="text-xs text-muted-foreground mb-1 font-medium">Customer Details:</p>
                              <div className="space-y-1 text-xs">
                                <div className="flex justify-between">
                                  <span className="text-muted-foreground">Name:</span>
                                  <span className="font-medium">{item.customerDetails.name}</span>
                                </div>
                                <div className="flex justify-between">
                                  <span className="text-muted-foreground">Email:</span>
                                  <span className="font-medium">{item.customerDetails.email}</span>
                                </div>
                                <div className="flex justify-between">
                                  <span className="text-muted-foreground">Phone:</span>
                                  <span className="font-medium">{item.customerDetails.phone}</span>
                                </div>
                              </div>
                            </div>

                            {item.remarks && (
                              <div className="mt-3 pt-2 border-t border-border">
                                <p className="text-xs text-muted-foreground mb-1 font-medium">Special Requirements:</p>
                                <p className="text-xs bg-muted p-2 rounded text-foreground">
                                  {item.remarks}
                                </p>
                              </div>
                            )}
                          </div>

                          <p className="text-sm font-medium text-primary mb-3">
                            ₹{item.totalPrice.toLocaleString()} each
                          </p>
                          
                          <div className="flex items-center justify-between">
                            <div className="flex items-center space-x-2">
                              <Button 
                                variant="outline" 
                                size="sm" 
                                className="h-8 w-8 p-0"
                                onClick={() => updateQuantity(item.id, item.quantity - 1)}
                              >
                                <Minus className="h-3 w-3" />
                              </Button>
                              <span className="text-sm font-medium w-8 text-center">
                                {item.quantity}
                              </span>
                              <Button 
                                variant="outline" 
                                size="sm" 
                                className="h-8 w-8 p-0"
                                onClick={() => updateQuantity(item.id, item.quantity + 1)}
                              >
                                <Plus className="h-3 w-3" />
                              </Button>
                            </div>
                            <p className="text-sm font-bold">
                              ₹{(item.totalPrice * item.quantity).toLocaleString()}
                            </p>
                          </div>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>

              {/* Order Summary */}
              <Card>
                <CardHeader>
                  <CardTitle className="text-lg">Order Summary</CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="flex justify-between text-sm">
                    <span className="text-muted-foreground">Subtotal</span>
                    <span>₹{subtotal.toLocaleString()}</span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span className="text-muted-foreground">Shipping</span>
                    <span>₹{shipping}</span>
                  </div>
                  <div className="border-t pt-4">
                    <div className="flex justify-between font-bold">
                      <span>Total</span>
                      <span>₹{total.toLocaleString()}</span>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* Checkout Button */}
              <Link to="/checkout">
                <Button className="w-full" size="lg">
                  Proceed to Checkout
                  <ArrowRight className="h-4 w-4 ml-2" />
                </Button>
              </Link>
            </>
          )}
        </div>
      </main>
    </div>
  );
};
