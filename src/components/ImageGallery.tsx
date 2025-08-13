import React, { useState } from 'react';
import { ChevronLeft, ChevronRight, X, Expand } from 'lucide-react';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogTrigger } from '@/components/ui/dialog';
import { Badge } from '@/components/ui/badge';
import { useImages } from '@/hooks/useImages';
import { Skeleton } from '@/components/ui/skeleton';

interface ImageGalleryProps {
  modelId?: string;
  categoryId?: string;
  className?: string;
  showPrimaryBadge?: boolean;
  allowFullscreen?: boolean;
}

export const ImageGallery: React.FC<ImageGalleryProps> = ({
  modelId,
  categoryId,
  className = "",
  showPrimaryBadge = true,
  allowFullscreen = true,
}) => {
  const [selectedIndex, setSelectedIndex] = useState(0);
  const [isFullscreenOpen, setIsFullscreenOpen] = useState(false);
  
  const { data: images, isLoading, error } = useImages(modelId, categoryId);

  if (isLoading) {
    return (
      <Card className={`p-4 ${className}`}>
        <Skeleton className="w-full aspect-square rounded-lg mb-4" />
        <div className="flex gap-2">
          {Array.from({ length: 3 }).map((_, i) => (
            <Skeleton key={i} className="w-16 h-16 rounded" />
          ))}
        </div>
      </Card>
    );
  }

  if (error) {
    return (
      <Card className={`p-4 ${className}`}>
        <div className="text-center py-8">
          <p className="text-muted-foreground">Failed to load images</p>
        </div>
      </Card>
    );
  }

  if (!images || images.length === 0) {
    return (
      <Card className={`p-4 ${className}`}>
        <div className="text-center py-8">
          <p className="text-muted-foreground">No images available</p>
        </div>
      </Card>
    );
  }

  const selectedImage = images[selectedIndex];

  const getImageUrl = (storagePath: string) => {
    const bucket = modelId ? 'furniture-images' : 'category-images';
    return `https://fztqvqgbkqkufdtswshb.supabase.co/storage/v1/object/public/${bucket}/${storagePath}`;
  };

  const goToPrevious = () => {
    setSelectedIndex(prev => prev === 0 ? images.length - 1 : prev - 1);
  };

  const goToNext = () => {
    setSelectedIndex(prev => prev === images.length - 1 ? 0 : prev + 1);
  };

  return (
    <Card className={`overflow-hidden ${className}`}>
      {/* Main Image Display */}
      <div className="relative">
        <div className="aspect-square relative overflow-hidden bg-muted">
          <img
            src={getImageUrl(selectedImage.storage_path)}
            alt={selectedImage.alt_text || 'Product image'}
            className="w-full h-full object-cover"
          />
          
          {/* Primary Badge */}
          {showPrimaryBadge && selectedImage.is_primary && (
            <Badge className="absolute top-2 left-2" variant="secondary">
              Primary
            </Badge>
          )}
          
          {/* Fullscreen Button */}
          {allowFullscreen && (
            <Dialog open={isFullscreenOpen} onOpenChange={setIsFullscreenOpen}>
              <DialogTrigger asChild>
                <Button
                  variant="secondary"
                  size="sm"
                  className="absolute top-2 right-2"
                >
                  <Expand className="h-4 w-4" />
                </Button>
              </DialogTrigger>
              <DialogContent className="max-w-4xl w-full p-0 bg-black/95">
                <div className="relative">
                  <img
                    src={getImageUrl(selectedImage.storage_path)}
                    alt={selectedImage.alt_text || 'Product image'}
                    className="w-full h-auto max-h-[90vh] object-contain"
                  />
                  <Button
                    variant="ghost"
                    size="sm"
                    className="absolute top-2 right-2 text-white hover:bg-white/20"
                    onClick={() => setIsFullscreenOpen(false)}
                  >
                    <X className="h-4 w-4" />
                  </Button>
                </div>
              </DialogContent>
            </Dialog>
          )}
          
          {/* Navigation Arrows (only show if multiple images) */}
          {images.length > 1 && (
            <>
              <Button
                variant="secondary"
                size="sm"
                className="absolute left-2 top-1/2 transform -translate-y-1/2"
                onClick={goToPrevious}
              >
                <ChevronLeft className="h-4 w-4" />
              </Button>
              <Button
                variant="secondary"
                size="sm"
                className="absolute right-2 top-1/2 transform -translate-y-1/2"
                onClick={goToNext}
              >
                <ChevronRight className="h-4 w-4" />
              </Button>
            </>
          )}
        </div>
      </div>

      {/* Thumbnail Strip */}
      {images.length > 1 && (
        <div className="p-4">
          <div className="flex gap-2 overflow-x-auto">
            {images.map((image, index) => (
              <button
                key={image.id}
                onClick={() => setSelectedIndex(index)}
                className={`relative flex-shrink-0 w-16 h-16 rounded overflow-hidden border-2 transition-colors ${
                  index === selectedIndex
                    ? 'border-primary'
                    : 'border-muted hover:border-primary/50'
                }`}
              >
                <img
                  src={getImageUrl(image.storage_path)}
                  alt={image.alt_text || 'Thumbnail'}
                  className="w-full h-full object-cover"
                />
                {image.is_primary && (
                  <div className="absolute top-0 right-0 w-2 h-2 bg-primary rounded-full transform translate-x-1 -translate-y-1" />
                )}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Image Info */}
      {selectedImage.alt_text && (
        <div className="px-4 pb-4">
          <p className="text-sm text-muted-foreground">
            {selectedImage.alt_text}
          </p>
        </div>
      )}
    </Card>
  );
};

export default ImageGallery;