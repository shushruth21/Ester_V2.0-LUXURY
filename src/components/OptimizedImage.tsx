import React, { useState, useRef, useEffect } from 'react';
import { cn } from '@/lib/utils';

interface OptimizedImageProps extends React.ImgHTMLAttributes<HTMLImageElement> {
  src: string;
  alt: string;
  fallbackSrc?: string;
  lazy?: boolean;
  placeholder?: 'blur' | 'skeleton';
  aspectRatio?: string;
  quality?: number;
}

export const OptimizedImage: React.FC<OptimizedImageProps> = ({
  src,
  alt,
  fallbackSrc = '/placeholder.svg',
  lazy = true,
  placeholder = 'skeleton',
  aspectRatio,
  quality = 85,
  className,
  onLoad,
  onError,
  ...props
}) => {
  const [isLoaded, setIsLoaded] = useState(false);
  const [hasError, setHasError] = useState(false);
  const [isInView, setIsInView] = useState(!lazy);
  const imgRef = useRef<HTMLImageElement>(null);

  // Intersection Observer for lazy loading
  useEffect(() => {
    if (!lazy || isInView) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsInView(true);
          observer.disconnect();
        }
      },
      { rootMargin: '50px' }
    );

    if (imgRef.current) {
      observer.observe(imgRef.current);
    }

    return () => observer.disconnect();
  }, [lazy, isInView]);

  const handleLoad = (e: React.SyntheticEvent<HTMLImageElement>) => {
    setIsLoaded(true);
    onLoad?.(e);
  };

  const handleError = (e: React.SyntheticEvent<HTMLImageElement>) => {
    setHasError(true);
    if (imgRef.current && fallbackSrc) {
      imgRef.current.src = fallbackSrc;
    }
    onError?.(e);
  };

  // Generate optimized src based on quality and device pixel ratio
  const getOptimizedSrc = (originalSrc: string) => {
    if (originalSrc.startsWith('http') && originalSrc.includes('supabase')) {
      const url = new URL(originalSrc);
      url.searchParams.set('quality', quality.toString());
      url.searchParams.set('width', '800'); // Max width for performance
      return url.toString();
    }
    return originalSrc;
  };

  const showSkeleton = !isLoaded && placeholder === 'skeleton';
  const imageClasses = cn(
    'transition-opacity duration-300',
    isLoaded ? 'opacity-100' : 'opacity-0',
    className
  );

  const skeletonClasses = cn(
    'absolute inset-0 bg-muted animate-pulse transition-opacity duration-300',
    isLoaded ? 'opacity-0' : 'opacity-100'
  );

  return (
    <div 
      className={cn('relative overflow-hidden', aspectRatio && `aspect-[${aspectRatio}]`)}
      ref={imgRef}
    >
      {showSkeleton && <div className={skeletonClasses} />}
      
      {isInView && (
        <img
          src={hasError ? fallbackSrc : getOptimizedSrc(src)}
          alt={alt}
          loading={lazy ? 'lazy' : 'eager'}
          onLoad={handleLoad}
          onError={handleError}
          className={imageClasses}
          {...props}
        />
      )}
    </div>
  );
};