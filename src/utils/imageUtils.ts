export const getSupabaseImageUrl = (storagePath: string, bucket: 'furniture-images' | 'category-images'): string => {
  return `https://edfcezdzxsuduavemdsz.supabase.co/storage/v1/object/public/${bucket}/${storagePath}`;
};

export const getCategoryImageUrl = (categoryId: string, images?: any[]): string | null => {
  if (!images || images.length === 0) return null;
  
  // Find primary image first, then fall back to first image
  const primaryImage = images.find(img => img.is_primary);
  const image = primaryImage || images[0];
  
  return getSupabaseImageUrl(image.storage_path, 'category-images');
};

export const getModelImageUrl = (modelId: string, images?: any[]): string | null => {
  if (!images || images.length === 0) return null;
  
  // Find primary image first, then fall back to first image
  const primaryImage = images.find(img => img.is_primary);
  const image = primaryImage || images[0];
  
  return getSupabaseImageUrl(image.storage_path, 'furniture-images');
};