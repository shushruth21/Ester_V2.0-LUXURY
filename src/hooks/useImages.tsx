import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

export interface Image {
  id: string;
  filename: string;
  storage_path: string;
  alt_text: string | null;
  display_order: number;
  is_primary: boolean;
  model_id: string | null;
  category_id: string | null;
  file_size: number | null;
  mime_type: string | null;
  created_at: string;
  updated_at: string;
}

export interface ImageUpload {
  id: string;
  user_id: string;
  upload_session_id: string;
  total_files: number;
  completed_files: number;
  failed_files: number;
  status: 'pending' | 'processing' | 'completed' | 'failed';
  metadata: any;
  created_at: string;
  updated_at: string;
}

export const useImages = (modelId?: string, categoryId?: string) => {
  return useQuery({
    queryKey: ["images", modelId, categoryId],
    queryFn: async (): Promise<Image[]> => {
      let query = supabase.from("images").select("*");
      
      if (modelId) {
        query = query.eq("model_id", modelId);
      }
      
      if (categoryId) {
        query = query.eq("category_id", categoryId);
      }
      
      const { data, error } = await query
        .order("display_order")
        .order("created_at");

      if (error) {
        throw new Error(error.message);
      }

      return data || [];
    },
    enabled: !!(modelId || categoryId),
  });
};

export const useImagesByModel = (modelId: string) => {
  return useImages(modelId, undefined);
};

export const useImagesByCategory = (categoryId: string) => {
  return useImages(undefined, categoryId);
};

export const useUploadImage = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ 
      file, 
      modelId, 
      categoryId, 
      altText, 
      isPrimary = false,
      displayOrder = 0 
    }: {
      file: File;
      modelId?: string;
      categoryId?: string;
      altText?: string;
      isPrimary?: boolean;
      displayOrder?: number;
    }) => {
      // Determine bucket and folder structure
      const bucket = modelId ? 'furniture-images' : 'category-images';
      const folder = modelId ? `models/${modelId}` : `categories/${categoryId}`;
      const fileName = `${folder}/${Date.now()}-${file.name}`;

      // Upload to storage
      const { data: uploadData, error: uploadError } = await supabase.storage
        .from(bucket)
        .upload(fileName, file);

      if (uploadError) {
        throw new Error(`Upload failed: ${uploadError.message}`);
      }

      // Get public URL
      const { data: urlData } = supabase.storage
        .from(bucket)
        .getPublicUrl(fileName);

      // Save image metadata to database
      const { data: imageData, error: imageError } = await supabase
        .from("images")
        .insert({
          filename: file.name,
          storage_path: fileName,
          alt_text: altText,
          display_order: displayOrder,
          is_primary: isPrimary,
          model_id: modelId || null,
          category_id: categoryId || null,
          file_size: file.size,
          mime_type: file.type,
        })
        .select()
        .single();

      if (imageError) {
        // Cleanup uploaded file if database insert fails
        await supabase.storage.from(bucket).remove([fileName]);
        throw new Error(`Database save failed: ${imageError.message}`);
      }

      return { 
        image: imageData, 
        publicUrl: urlData.publicUrl 
      };
    },
    onSuccess: (data, variables) => {
      // Invalidate relevant queries
      queryClient.invalidateQueries({ 
        queryKey: ["images", variables.modelId, variables.categoryId] 
      });
      
      if (variables.modelId) {
        queryClient.invalidateQueries({ 
          queryKey: ["images", variables.modelId] 
        });
      }
      
      if (variables.categoryId) {
        queryClient.invalidateQueries({ 
          queryKey: ["images", undefined, variables.categoryId] 
        });
      }
    },
  });
};

export const useUpdateImage = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ 
      id, 
      updates 
    }: {
      id: string;
      updates: Partial<Pick<Image, 'alt_text' | 'display_order' | 'is_primary'>>;
    }) => {
      const { data, error } = await supabase
        .from("images")
        .update(updates)
        .eq("id", id)
        .select()
        .single();

      if (error) {
        throw new Error(error.message);
      }

      return data;
    },
    onSuccess: (data) => {
      // Invalidate relevant queries
      queryClient.invalidateQueries({ 
        queryKey: ["images", data.model_id, data.category_id] 
      });
    },
  });
};

export const useDeleteImage = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (id: string) => {
      // First get the image data to know which file to delete
      const { data: imageData, error: fetchError } = await supabase
        .from("images")
        .select("*")
        .eq("id", id)
        .single();

      if (fetchError) {
        throw new Error(fetchError.message);
      }

      // Delete from database first
      const { error: deleteError } = await supabase
        .from("images")
        .delete()
        .eq("id", id);

      if (deleteError) {
        throw new Error(deleteError.message);
      }

      // Delete from storage
      const bucket = imageData.model_id ? 'furniture-images' : 'category-images';
      const { error: storageError } = await supabase.storage
        .from(bucket)
        .remove([imageData.storage_path]);

      if (storageError) {
        console.warn("Failed to delete file from storage:", storageError.message);
      }

      return imageData;
    },
    onSuccess: (data) => {
      // Invalidate relevant queries
      queryClient.invalidateQueries({ 
        queryKey: ["images", data.model_id, data.category_id] 
      });
    },
  });
};

export const useImageUploadSession = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ sessionId, totalFiles, metadata }: {
      sessionId: string;
      totalFiles: number;
      metadata?: any;
    }) => {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) throw new Error("User not authenticated");

      const { data, error } = await supabase
        .from("image_upload_sessions")
        .insert({
          user_id: user.id,
          upload_session_id: sessionId,
          total_files: totalFiles,
          metadata: metadata,
        })
        .select()
        .single();

      if (error) {
        throw new Error(error.message);
      }

      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["image-uploads"] });
    },
  });
};

export const useUpdateUploadSession = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ 
      sessionId, 
      updates 
    }: {
      sessionId: string;
      updates: Partial<Pick<ImageUpload, 'completed_files' | 'failed_files' | 'status'>>;
    }) => {
      const { data, error } = await supabase
        .from("image_upload_sessions")
        .update(updates)
        .eq("upload_session_id", sessionId)
        .select()
        .single();

      if (error) {
        throw new Error(error.message);
      }

      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["image-uploads"] });
    },
  });
};