import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Heart, ShoppingBag, ArrowRight } from "lucide-react";
import { Link } from "react-router-dom";

export const WishlistPage = () => {
  // Mock wishlist data
  const wishlistItems = [
    {
      id: 1,
      name: "Luxury Sectional Sofa",
      price: 2499,
      image: "/placeholder.svg",
      inStock: true
    },
    {
      id: 2,
      name: "Modern Dining Table",
      price: 1299,
      image: "/placeholder.svg",
      inStock: false
    }
  ];

  return (
    <div className="min-h-screen bg-background">
      <main className="px-4 py-6">
        <div className="space-y-6">
          {/* Header */}
          <div className="text-center">
            <h1 className="text-2xl font-bold text-foreground mb-2">My Wishlist</h1>
            <p className="text-muted-foreground">
              {wishlistItems.length} items saved for later
            </p>
          </div>

          {/* Wishlist Items */}
          {wishlistItems.length === 0 ? (
            <div className="text-center py-12">
              <Heart className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
              <h2 className="text-xl font-semibold text-foreground mb-2">Your wishlist is empty</h2>
              <p className="text-muted-foreground mb-6">
                Start browsing and save items you love
              </p>
              <Link to="/categories">
                <Button>
                  Explore Collections
                  <ArrowRight className="h-4 w-4 ml-2" />
                </Button>
              </Link>
            </div>
          ) : (
            <div className="space-y-4">
              {wishlistItems.map((item) => (
                <Card key={item.id} className="overflow-hidden">
                  <CardContent className="p-0">
                    <div className="flex">
                      <div className="w-24 h-24 bg-muted flex-shrink-0">
                        <img
                          src={item.image}
                          alt={item.name}
                          className="w-full h-full object-cover"
                        />
                      </div>
                      <div className="flex-1 p-4">
                        <div className="flex justify-between items-start mb-2">
                          <h3 className="font-semibold text-foreground text-sm line-clamp-1">
                            {item.name}
                          </h3>
                          <Button variant="ghost" size="sm" className="p-1 h-auto">
                            <Heart className="h-4 w-4 fill-current text-red-500" />
                          </Button>
                        </div>
                        <p className="text-sm font-medium text-primary mb-2">
                          ${item.price.toLocaleString()}
                        </p>
                        <div className="flex items-center justify-between">
                          <Badge variant={item.inStock ? "secondary" : "destructive"} className="text-xs">
                            {item.inStock ? "In Stock" : "Out of Stock"}
                          </Badge>
                          <Button size="sm" disabled={!item.inStock}>
                            <ShoppingBag className="h-3 w-3 mr-1" />
                            Add to Cart
                          </Button>
                        </div>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          )}
        </div>
      </main>
    </div>
  );
};