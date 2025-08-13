import React from 'react';
import { Link } from "react-router-dom";
import { ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useImagesByCategory } from "@/hooks/useImages";
import { getCategoryImageUrl } from "@/utils/imageUtils";
import { Category } from "@/hooks/useCategories";
import sofaProduct1 from "@/assets/sofa-product-1.jpg";

interface CategoryCardProps {
  category: Category;
  index: number;
}

export const CategoryCard: React.FC<CategoryCardProps> = ({ category, index }) => {
  const { data: images } = useImagesByCategory(category.id);
  
  // Use custom uploaded image if available, otherwise fall back to placeholder
  const imageUrl = getCategoryImageUrl(category.id, images) || category.image_url || sofaProduct1;

  return (
    <div
      className={`card-category group animate-slide-in`}
      style={{ animationDelay: `${index * 0.1}s` }}
    >
      <div className="relative h-80 overflow-hidden">
        <img
          src={imageUrl}
          alt={category.name}
          className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
          onError={(e) => {
            // Fallback to placeholder if image fails to load
            e.currentTarget.src = sofaProduct1;
          }}
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent" />
        
        {/* Modern design badge */}
        <div className="absolute top-4 right-4 bg-accent text-accent-foreground px-3 py-1 rounded-full text-sm font-medium">
          Premium
        </div>

        {/* Category name overlay */}
        <div className="absolute bottom-6 left-6 right-6">
          <h3 className="text-2xl font-display font-bold text-white mb-2">
            {category.name}
          </h3>
          {category.description && (
            <p className="text-white/90 text-sm line-clamp-2">
              {category.description}
            </p>
          )}
        </div>
      </div>

      <div className="p-6">
        <Link to={`/category/${category.slug}`}>
          <Button 
            variant="outline-luxury" 
            className="w-full group"
          >
            Explore Collection
            <ArrowRight className="h-4 w-4 group-hover:translate-x-1 transition-transform" />
          </Button>
        </Link>
      </div>
    </div>
  );
};

export default CategoryCard;