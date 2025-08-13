import React, { useState } from 'react';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { Trash2, Edit, Upload, Image as ImageIcon, FolderOpen } from 'lucide-react';
import { useCategories } from '@/hooks/useCategories';
import { useImages, useDeleteImage, useUpdateImage } from '@/hooks/useImages';
import { ImageUploader } from '@/components/ImageUploader';
import { ImageGallery } from '@/components/ImageGallery';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { Skeleton } from '@/components/ui/skeleton';
import { useToast } from '@/hooks/use-toast';

export const AdminImageManagerPage: React.FC = () => {
  const [selectedCategoryId, setSelectedCategoryId] = useState<string>('');
  const [selectedModelId, setSelectedModelId] = useState<string>('');
  const [editingImage, setEditingImage] = useState<any>(null);
  const [uploadDialogOpen, setUploadDialogOpen] = useState(false);
  
  const { data: categories, isLoading: categoriesLoading } = useCategories();
  const { data: images, isLoading: imagesLoading, refetch } = useImages(
    selectedModelId || undefined,
    selectedCategoryId || undefined
  );
  
  const { toast } = useToast();
  const deleteImageMutation = useDeleteImage();
  const updateImageMutation = useUpdateImage();

  const handleDeleteImage = async (imageId: string) => {
    if (!confirm('Are you sure you want to delete this image?')) return;
    
    try {
      await deleteImageMutation.mutateAsync(imageId);
      toast({
        title: "Image deleted",
        description: "The image has been successfully deleted.",
      });
    } catch (error) {
      toast({
        title: "Delete failed",
        description: error instanceof Error ? error.message : "Failed to delete image",
        variant: "destructive",
      });
    }
  };

  const handleUpdateImage = async (imageId: string, updates: any) => {
    try {
      await updateImageMutation.mutateAsync({ id: imageId, updates });
      setEditingImage(null);
      toast({
        title: "Image updated",
        description: "The image has been successfully updated.",
      });
    } catch (error) {
      toast({
        title: "Update failed",
        description: error instanceof Error ? error.message : "Failed to update image",
        variant: "destructive",
      });
    }
  };

  const getImageUrl = (storagePath: string, modelId?: string) => {
    const bucket = modelId ? 'furniture-images' : 'category-images';
    return `https://fztqvqgbkqkufdtswshb.supabase.co/storage/v1/object/public/${bucket}/${storagePath}`;
  };

  return (
    <div className="container mx-auto py-8 px-4">
      <div className="mb-8">
        <h1 className="text-3xl font-bold mb-2">Image Management</h1>
        <p className="text-muted-foreground">
          Manage product and category images for your furniture store
        </p>
      </div>

      <Tabs defaultValue="gallery" className="space-y-6">
        <TabsList>
          <TabsTrigger value="gallery">Image Gallery</TabsTrigger>
          <TabsTrigger value="upload">Upload Images</TabsTrigger>
          <TabsTrigger value="manage">Manage Images</TabsTrigger>
        </TabsList>

        {/* Filter Section */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <FolderOpen className="h-5 w-5" />
              Filter Images
            </CardTitle>
            <CardDescription>
              Select a category to view and manage its images
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <Label htmlFor="category-select">Category</Label>
                <Select value={selectedCategoryId} onValueChange={setSelectedCategoryId}>
                  <SelectTrigger id="category-select">
                    <SelectValue placeholder="Select a category" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="">All Categories</SelectItem>
                    {categories?.map((category) => (
                      <SelectItem key={category.id} value={category.id}>
                        {category.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              
              {/* TODO: Add model selection when we have models */}
              <div>
                <Label htmlFor="model-select">Model (Coming Soon)</Label>
                <Select disabled>
                  <SelectTrigger id="model-select">
                    <SelectValue placeholder="Select a model" />
                  </SelectTrigger>
                </Select>
              </div>
            </div>
          </CardContent>
        </Card>

        <TabsContent value="gallery">
          <Card>
            <CardHeader>
              <CardTitle>Image Gallery</CardTitle>
              <CardDescription>
                {selectedCategoryId ? 'Category images' : 'All images'} preview
              </CardDescription>
            </CardHeader>
            <CardContent>
              {selectedCategoryId || selectedModelId ? (
                <ImageGallery
                  categoryId={selectedCategoryId || undefined}
                  modelId={selectedModelId || undefined}
                  className="max-w-md mx-auto"
                />
              ) : (
                <div className="text-center py-12">
                  <ImageIcon className="mx-auto h-12 w-12 text-muted-foreground mb-4" />
                  <p className="text-muted-foreground">
                    Select a category to view images
                  </p>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="upload">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Upload className="h-5 w-5" />
                Upload Images
              </CardTitle>
              <CardDescription>
                Upload new images for categories or products
              </CardDescription>
            </CardHeader>
            <CardContent>
              {selectedCategoryId ? (
                <ImageUploader
                  categoryId={selectedCategoryId}
                  onUploadComplete={() => {
                    refetch();
                    toast({
                      title: "Upload complete",
                      description: "Images have been uploaded successfully.",
                    });
                  }}
                />
              ) : (
                <div className="text-center py-12">
                  <Upload className="mx-auto h-12 w-12 text-muted-foreground mb-4" />
                  <p className="text-muted-foreground mb-4">
                    Please select a category first to upload images
                  </p>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="manage">
          <Card>
            <CardHeader>
              <CardTitle>Manage Images</CardTitle>
              <CardDescription>
                Edit, organize, and delete images
              </CardDescription>
            </CardHeader>
            <CardContent>
              {imagesLoading ? (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {Array.from({ length: 6 }).map((_, i) => (
                    <Card key={i}>
                      <Skeleton className="aspect-square w-full" />
                      <div className="p-4 space-y-2">
                        <Skeleton className="h-4 w-3/4" />
                        <Skeleton className="h-4 w-1/2" />
                      </div>
                    </Card>
                  ))}
                </div>
              ) : images && images.length > 0 ? (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {images.map((image) => (
                    <Card key={image.id} className="overflow-hidden">
                      <div className="aspect-square relative">
                        <img
                          src={getImageUrl(image.storage_path, image.model_id || undefined)}
                          alt={image.alt_text || 'Image'}
                          className="w-full h-full object-cover"
                        />
                        {image.is_primary && (
                          <Badge className="absolute top-2 left-2" variant="secondary">
                            Primary
                          </Badge>
                        )}
                      </div>
                      
                      <div className="p-4 space-y-3">
                        <div>
                          <p className="font-medium truncate">{image.filename}</p>
                          <p className="text-sm text-muted-foreground truncate">
                            {image.alt_text || 'No description'}
                          </p>
                        </div>
                        
                        <div className="flex gap-2">
                          <Dialog>
                            <DialogTrigger asChild>
                              <Button variant="outline" size="sm" className="flex-1">
                                <Edit className="h-4 w-4 mr-1" />
                                Edit
                              </Button>
                            </DialogTrigger>
                            <DialogContent>
                              <DialogHeader>
                                <DialogTitle>Edit Image</DialogTitle>
                              </DialogHeader>
                              <ImageEditForm
                                image={image}
                                onSave={(updates) => handleUpdateImage(image.id, updates)}
                                onCancel={() => setEditingImage(null)}
                              />
                            </DialogContent>
                          </Dialog>
                          
                          <Button
                            variant="destructive"
                            size="sm"
                            onClick={() => handleDeleteImage(image.id)}
                            disabled={deleteImageMutation.isPending}
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      </div>
                    </Card>
                  ))}
                </div>
              ) : (
                <div className="text-center py-12">
                  <ImageIcon className="mx-auto h-12 w-12 text-muted-foreground mb-4" />
                  <p className="text-muted-foreground">
                    {selectedCategoryId ? 'No images found for this category' : 'Select a category to manage images'}
                  </p>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
};

const ImageEditForm: React.FC<{
  image: any;
  onSave: (updates: any) => void;
  onCancel: () => void;
}> = ({ image, onSave, onCancel }) => {
  const [altText, setAltText] = useState(image.alt_text || '');
  const [isPrimary, setIsPrimary] = useState(image.is_primary || false);
  const [displayOrder, setDisplayOrder] = useState(image.display_order || 0);

  const handleSave = () => {
    onSave({
      alt_text: altText,
      is_primary: isPrimary,
      display_order: displayOrder,
    });
  };

  return (
    <div className="space-y-4">
      <div>
        <Label htmlFor="alt-text">Alt Text</Label>
        <Input
          id="alt-text"
          value={altText}
          onChange={(e) => setAltText(e.target.value)}
          placeholder="Describe this image..."
        />
      </div>
      
      <div className="flex items-center space-x-2">
        <Switch
          id="is-primary"
          checked={isPrimary}
          onCheckedChange={setIsPrimary}
        />
        <Label htmlFor="is-primary">Primary Image</Label>
      </div>
      
      <div>
        <Label htmlFor="display-order">Display Order</Label>
        <Input
          id="display-order"
          type="number"
          value={displayOrder}
          onChange={(e) => setDisplayOrder(parseInt(e.target.value) || 0)}
          min="0"
        />
      </div>
      
      <div className="flex justify-end gap-2">
        <Button variant="outline" onClick={onCancel}>
          Cancel
        </Button>
        <Button onClick={handleSave}>
          Save Changes
        </Button>
      </div>
    </div>
  );
};

export default AdminImageManagerPage;