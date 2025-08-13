import { Button } from "@/components/ui/button";
import { ArrowRight } from "lucide-react";
import { Link } from "react-router-dom";
import { useCategories } from "@/hooks/useCategories";
import { CategoryCard } from "@/components/CategoryCard";
import { CategoryGridSkeleton } from "./LoadingStates";
import { usePerformanceMonitor } from '@/hooks/usePerformanceMonitor';

export const CategoryGrid = () => {
  const { data: categories = [], isLoading } = useCategories();
  const { trackInteraction } = usePerformanceMonitor('CategoryGrid');

  return (
    <section className="py-20 bg-gradient-card">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16 animate-fade-up">
          <h2 className="text-4xl md:text-5xl font-display font-bold text-gradient-primary mb-4">
            Explore Our Collections
          </h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Discover furniture that transforms your space into a sanctuary of comfort and style
          </p>
        </div>

        {isLoading ? (
          <CategoryGridSkeleton />
        ) : (
          <div className="grid md:grid-cols-2 lg:grid-cols-2 gap-8">
            {categories.slice(0, 6).map((category, index) => (
              <CategoryCard
                key={category.id}
                category={category}
                index={index}
              />
            ))}
          </div>
        )}

        <div className="text-center mt-12">
          <Link to="/categories">
            <Button 
              size="lg" 
              variant="luxury"
              onClick={() => trackInteraction('viewAllCategories')}
            >
              View All Categories
              <ArrowRight className="h-5 w-5 ml-2" />
            </Button>
          </Link>
        </div>
      </div>
    </section>
  );
};