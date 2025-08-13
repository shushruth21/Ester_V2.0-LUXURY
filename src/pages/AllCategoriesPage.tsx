import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ArrowRight, ArrowLeft } from "lucide-react";
import { useCategories } from "@/hooks/useCategories";
import { Skeleton } from "@/components/ui/skeleton";
import sofaProduct1 from "@/assets/sofa-product-1.jpg";

export const AllCategoriesPage = () => {
  const { data: categories = [], isLoading } = useCategories();

  return (
    <div className="min-h-screen">
      {/* Page Header */}
      <div className="py-6 px-4">
        <Link to="/home" className="inline-flex items-center text-muted-foreground hover:text-primary mb-4 transition-colors">
          <ArrowLeft className="h-4 w-4 mr-2" />
          Back to Home
        </Link>
        <h1 className="text-2xl font-bold text-foreground mb-2">
          All Collections
        </h1>
        <p className="text-muted-foreground mb-4">
          Discover our complete range of premium furniture collections
        </p>
        {!isLoading && (
          <Badge variant="secondary" className="text-sm px-3 py-1">
            {categories.length} Collections Available
          </Badge>
        )}
      </div>

      {/* Categories Grid */}
      <div className="px-4 pb-6">
        {isLoading ? (
          <div className="grid grid-cols-2 gap-4">
            {[...Array(6)].map((_, i) => (
              <Skeleton key={i} className="h-40" />
            ))}
          </div>
        ) : categories.length === 0 ? (
          <div className="text-center py-8">
            <p className="text-muted-foreground mb-4">
              No categories available yet.
            </p>
            <Link to="/home">
              <Button>
                <ArrowLeft className="h-4 w-4 mr-2" />
                Back to Home
              </Button>
            </Link>
          </div>
        ) : (
          <div className="grid grid-cols-2 gap-4">
            {categories.map((category, index) => (
              <Card 
                key={category.id} 
                className="group hover:shadow-lg transition-all duration-300 overflow-hidden"
              >
                <div className="relative h-24 overflow-hidden">
                  <img
                    src={category.image_url || sofaProduct1}
                    alt={category.name}
                    className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                  />
                  <div className="absolute inset-0 bg-gradient-to-b from-black/60 via-transparent to-transparent" />
                  
                  {/* Category name overlay */}
                  <div className="absolute bottom-2 left-2 right-2">
                    <h3 className="text-sm font-bold text-white line-clamp-1">
                      {category.name}
                    </h3>
                  </div>
                </div>
                
                <CardContent className="p-3">
                  {category.description && (
                    <p className="text-xs text-muted-foreground mb-3 line-clamp-2">
                      {category.description}
                    </p>
                  )}
                  <Link to={`/category/${category.slug}`}>
                    <Button variant="outline" size="sm" className="w-full text-xs">
                      Browse Collection
                      <ArrowRight className="h-3 w-3 ml-1" />
                    </Button>
                  </Link>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};