import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useOptimizedQuery } from "./useOptimizedQuery";

export interface Category {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  image_url: string | null;
  created_at: string;
  updated_at: string;
}

export interface FurnitureModel {
  id: string;
  category_id: string;
  name: string;
  slug: string;
  description: string | null;
  base_price: number;
  default_image_url: string | null;
  is_featured: boolean;
  created_at: string;
  updated_at: string;
}

export const useCategories = () => {
  return useOptimizedQuery({
    queryKey: ["categories"],
    queryFn: async (): Promise<Category[]> => {
      const { data, error } = await supabase
        .from("categories")
        .select("*")
        .order("name");

      if (error) {
        throw new Error(error.message);
      }

      // Reorder to put Armchair first
      const sortedData = data || [];
      const armchairIndex = sortedData.findIndex(cat => cat.name.toLowerCase().includes('armchair'));
      if (armchairIndex > -1) {
        const armchair = sortedData.splice(armchairIndex, 1)[0];
        sortedData.unshift(armchair);
      }

      return sortedData;
    },
    backgroundRefetch: true,
    prefetch: true,
  });
};

export const useCategoryBySlug = (slug: string) => {
  return useQuery({
    queryKey: ["category", slug],
    queryFn: async (): Promise<Category | null> => {
      const { data, error } = await supabase
        .from("categories")
        .select("*")
        .eq("slug", slug)
        .maybeSingle();

      if (error) {
        throw new Error(error.message);
      }

      return data;
    },
    enabled: !!slug,
  });
};

export const useFurnitureModelsByCategory = (categoryId: string) => {
  return useOptimizedQuery({
    queryKey: ["furniture-models", categoryId],
    queryFn: async (): Promise<FurnitureModel[]> => {
      const { data, error } = await supabase
        .from("furniture_models")
        .select("*")
        .eq("category_id", categoryId)
        .order("name");

      if (error) {
        throw new Error(error.message);
      }

      return data || [];
    },
    enabled: !!categoryId,
    backgroundRefetch: true,
  });
};

export const useModelBySlug = (slug: string) => {
  return useQuery({
    queryKey: ["model", slug],
    queryFn: async (): Promise<FurnitureModel | null> => {
      const { data, error } = await supabase
        .from("furniture_models")
        .select("*")
        .eq("slug", slug)
        .maybeSingle();

      if (error) {
        throw new Error(error.message);
      }

      return data;
    },
    enabled: !!slug,
  });
};