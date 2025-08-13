-- Add missing attribute values for RECLINER models

-- Add "1 Str" to number_of_seats if not exists
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT id, '1_str', '1 Str', 1
FROM public.attribute_types 
WHERE name = 'number_of_seats'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = attribute_types.id 
  AND av.value = '1_str'
);

-- Add "22 inches" to seat_depth if not exists
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT id, '22_inches', '22" (Twentytwo inches)', 22
FROM public.attribute_types 
WHERE name = 'seat_depth'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = attribute_types.id 
  AND av.value = '22_inches'
);

-- Add "18 inches" to seat_height if not exists
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT id, '18_inches', '18" (Eighteen inches)', 18
FROM public.attribute_types 
WHERE name = 'seat_height'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = attribute_types.id 
  AND av.value = '18_inches'
);

-- Add leg types for recliners if not exists
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT id, 'wood_leg_h2', 'Wood Leg (H-2")', 1
FROM public.attribute_types 
WHERE name = 'legs'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = attribute_types.id 
  AND av.value = 'wood_leg_h2'
);

INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT id, 'nylon_bush_h2', 'Nylon Bush (H-2")', 2
FROM public.attribute_types 
WHERE name = 'legs'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = attribute_types.id 
  AND av.value = 'nylon_bush_h2'
);

-- Create attribute types for dimensions
INSERT INTO public.attribute_types (name, display_name, input_type, sort_order)
VALUES 
  ('overall_length', 'Overall Length', 'input', 12),
  ('overall_width', 'Overall Width', 'input', 13),
  ('overall_height', 'Overall Height', 'input', 14)
ON CONFLICT (name) DO NOTHING;

-- Link all RECLINER models to their attributes
WITH recliner_models AS (
  SELECT fm.id as model_id
  FROM public.furniture_models fm
  JOIN public.categories c ON fm.category_id = c.id
  WHERE c.name = 'RECLINER'
),
attribute_mappings AS (
  SELECT 
    at.id as attribute_type_id,
    at.name as attribute_name,
    CASE 
      WHEN at.name IN ('number_of_seats', 'seat_depth', 'seat_height', 'wood_type', 'foam_type_seats', 'foam_type_back_rest', 'fabric_cladding_plan', 'legs') THEN true
      ELSE false
    END as is_required
  FROM public.attribute_types at
  WHERE at.name IN (
    'number_of_seats', 'seat_depth', 'seat_height', 'wood_type', 
    'foam_type_seats', 'foam_type_back_rest', 'fabric_cladding_plan', 
    'fabric_code', 'indicative_fabric_colour', 'legs', 'accessories', 
    'stitching_type', 'overall_length', 'overall_width', 'overall_height'
  )
)
INSERT INTO public.model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
  rm.model_id,
  am.attribute_type_id,
  am.is_required,
  CASE 
    -- Set default values for required attributes
    WHEN am.attribute_name = 'number_of_seats' THEN (
      SELECT av.id FROM public.attribute_values av 
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = '1_str'
    )
    WHEN am.attribute_name = 'seat_depth' THEN (
      SELECT av.id FROM public.attribute_values av 
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = '22_inches'
    )
    WHEN am.attribute_name = 'seat_height' THEN (
      SELECT av.id FROM public.attribute_values av 
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = '18_inches'
    )
    WHEN am.attribute_name = 'wood_type' THEN (
      SELECT av.id FROM public.attribute_values av 
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = 'neem' LIMIT 1
    )
    WHEN am.attribute_name = 'foam_type_seats' THEN (
      SELECT av.id FROM public.attribute_values av 
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = '32d_p' LIMIT 1
    )
    WHEN am.attribute_name = 'foam_type_back_rest' THEN (
      SELECT av.id FROM public.attribute_values av 
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = '32d_p' LIMIT 1
    )
    WHEN am.attribute_name = 'fabric_cladding_plan' THEN (
      SELECT av.id FROM public.attribute_values av 
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = 'single_colour' LIMIT 1
    )
    WHEN am.attribute_name = 'legs' THEN (
      SELECT av.id FROM public.attribute_values av 
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = 'wood_leg_h2' LIMIT 1
    )
    ELSE NULL
  END
FROM recliner_models rm
CROSS JOIN attribute_mappings am
ON CONFLICT (model_id, attribute_type_id) DO NOTHING;