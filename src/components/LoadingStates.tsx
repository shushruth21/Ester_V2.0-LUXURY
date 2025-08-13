import React from 'react';
import { Skeleton } from '@/components/ui/skeleton';
import { Card, CardContent, CardHeader } from '@/components/ui/card';
import { Loader2 } from 'lucide-react';

export const CategoryGridSkeleton = () => (
  <section className="py-16 bg-secondary/30">
    <div className="container mx-auto px-4">
      <div className="text-center mb-12">
        <Skeleton className="h-8 w-64 mx-auto mb-4" />
        <Skeleton className="h-4 w-96 mx-auto" />
      </div>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        {Array.from({ length: 6 }).map((_, i) => (
          <Card key={i} className="overflow-hidden">
            <CardHeader className="p-0">
              <Skeleton className="h-48 w-full" />
            </CardHeader>
            <CardContent className="p-6">
              <Skeleton className="h-6 w-32 mb-2" />
              <Skeleton className="h-4 w-full mb-2" />
              <Skeleton className="h-4 w-3/4" />
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  </section>
);

export const ModelCardSkeleton = () => (
  <Card className="overflow-hidden">
    <CardHeader className="p-0">
      <Skeleton className="h-64 w-full" />
    </CardHeader>
    <CardContent className="p-6">
      <Skeleton className="h-6 w-32 mb-2" />
      <Skeleton className="h-4 w-20 mb-4" />
      <Skeleton className="h-10 w-full" />
    </CardContent>
  </Card>
);

export const ModelGridSkeleton = () => (
  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    {Array.from({ length: 9 }).map((_, i) => (
      <ModelCardSkeleton key={i} />
    ))}
  </div>
);

export const PageLoadingSpinner = ({ message = "Loading..." }: { message?: string }) => (
  <div className="min-h-screen flex items-center justify-center bg-background">
    <div className="text-center space-y-4">
      <Loader2 className="h-8 w-8 animate-spin mx-auto text-primary" />
      <p className="text-muted-foreground">{message}</p>
    </div>
  </div>
);

export const InlineLoadingSpinner = ({ size = "sm", message }: { size?: "sm" | "md" | "lg"; message?: string }) => {
  const sizeClasses = {
    sm: "h-4 w-4",
    md: "h-6 w-6", 
    lg: "h-8 w-8"
  };

  return (
    <div className="flex items-center justify-center gap-2 py-4">
      <Loader2 className={`${sizeClasses[size]} animate-spin text-primary`} />
      {message && <span className="text-sm text-muted-foreground">{message}</span>}
    </div>
  );
};