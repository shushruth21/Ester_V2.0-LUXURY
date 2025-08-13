import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

export interface AttributeType {
  id: string;
  name: string;
  display_name: string;
  input_type: string;
  sort_order: number;
  description?: string;
  created_at: string;
  updated_at: string;
}

export interface AttributeValue {
  id: string;
  attribute_type_id: string;
  value: string;
  display_name: string;
  sort_order: number;
  price_modifier: number;
  hex_color: string | null;
}

export interface ModelAttribute {
  id: string;
  model_id: string;
  attribute_type_id: string;
  is_required: boolean;
  default_value_id: string | null;
  attribute_type: AttributeType;
  attribute_values: AttributeValue[];
}

export const useModelAttributes = (modelId: string) => {
  return useQuery({
    queryKey: ["model-attributes", modelId],
    queryFn: async (): Promise<ModelAttribute[]> => {
      const { data: modelAttributes, error: attributesError } = await supabase
        .from("model_attributes")
        .select(`
          *,
          attribute_type:attribute_types(*)
        `)
        .eq("model_id", modelId);

      if (attributesError) {
        throw new Error(attributesError.message);
      }

      // Get attribute values for each attribute type
      const attributeTypeIds = modelAttributes?.map(ma => ma.attribute_type_id) || [];
      
      const { data: attributeValues, error: valuesError } = await supabase
        .from("attribute_values")
        .select("*")
        .in("attribute_type_id", attributeTypeIds)
        .order("sort_order");

      if (valuesError) {
        throw new Error(valuesError.message);
      }

      // Combine the data
      const result = modelAttributes?.map(ma => ({
        ...ma,
        attribute_values: attributeValues?.filter(av => av.attribute_type_id === ma.attribute_type_id) || []
      })) || [];

      // Sort by attribute type sort order
      return result.sort((a, b) => (a.attribute_type?.sort_order || 0) - (b.attribute_type?.sort_order || 0));
    },
    enabled: !!modelId,
  });
};