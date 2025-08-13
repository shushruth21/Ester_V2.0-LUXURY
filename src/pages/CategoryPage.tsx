import { useParams, Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ArrowRight, ArrowLeft } from "lucide-react";
import { useCategoryBySlug, useFurnitureModelsByCategory } from "@/hooks/useCategories";
import { Skeleton } from "@/components/ui/skeleton";

export const CategoryPage = () => {
  const { slug } = useParams<{ slug: string }>();
  const { data: category, isLoading: categoryLoading } = useCategoryBySlug(slug || "");
  const { data: models = [], isLoading: modelsLoading } = useFurnitureModelsByCategory(category?.id || "");

  if (categoryLoading) {
    return (
      <div className="min-h-screen">
        <div className="px-4 py-6">
          <Skeleton className="h-8 w-64 mb-4" />
          <Skeleton className="h-4 w-96 mb-6" />
          <div className="grid grid-cols-2 gap-4">
            {[...Array(6)].map((_, i) => (
              <Skeleton key={i} className="h-64" />
            ))}
          </div>
        </div>
      </div>
    );
  }

  if (!category) {
    return (
      <div className="min-h-screen">
        <div className="px-4 py-6 text-center">
          <h1 className="text-xl font-bold mb-4">Category not found</h1>
          <Link to="/home">
            <Button>
              <ArrowLeft className="h-4 w-4 mr-2" />
              Back to Home
            </Button>
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen">
      {/* Category Header */}
      <div className="py-6 px-4">
        <Link to="/home" className="inline-flex items-center text-muted-foreground hover:text-primary mb-4 transition-colors">
          <ArrowLeft className="h-4 w-4 mr-2" />
          Back to Collections
        </Link>
        <h1 className="text-2xl font-bold text-foreground mb-2">
          {category.name}
        </h1>
        {category.description && (
          <p className="text-muted-foreground mb-4">
            {category.description}
          </p>
        )}
        <Badge variant="secondary" className="text-sm px-3 py-1">
          {models.length} Models Available
        </Badge>
      </div>

      {/* Models Grid */}
      <div className="px-4 pb-6">
        {modelsLoading ? (
          <div className="grid grid-cols-2 gap-4">
            {[...Array(6)].map((_, i) => (
              <Skeleton key={i} className="h-64" />
            ))}
          </div>
        ) : models.length === 0 ? (
          <div className="text-center py-8">
            <p className="text-muted-foreground mb-4">
              No models available in this category yet.
            </p>
            <Link to="/home">
              <Button>
                <ArrowLeft className="h-4 w-4 mr-2" />
                Back to Collections
              </Button>
            </Link>
          </div>
        ) : (
          <div className="grid grid-cols-2 gap-4">
            {models.map((model, index) => (
              <Card 
                key={model.id} 
                className="group hover:shadow-lg transition-all duration-300"
              >
                <div className="relative h-32 overflow-hidden rounded-t-lg">
                  <img
                    src={model.default_image_url || "/placeholder.svg"}
                    alt={model.name}
                    className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                  />
                  {model.is_featured && (
                    <Badge className="absolute top-2 left-2 bg-accent text-accent-foreground text-xs">
                      Featured
                    </Badge>
                  )}
                  <div className="absolute top-2 right-2 bg-white/90 backdrop-blur text-primary px-2 py-1 rounded text-xs font-medium">
                    ₹{model.base_price.toLocaleString()}
                  </div>
                </div>
                
                <CardContent className="p-3">
                  <h3 className="text-sm font-semibold text-primary mb-1 line-clamp-1">
                    {model.name}
                  </h3>
                  {model.description && (
                    <p className="text-xs text-muted-foreground mb-2 line-clamp-2">
                      {model.description}
                    </p>
                  )}
                  <Link to={`/model/${model.slug}/configure`}>
                    <Button size="sm" className="w-full text-xs">
                      Customize
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