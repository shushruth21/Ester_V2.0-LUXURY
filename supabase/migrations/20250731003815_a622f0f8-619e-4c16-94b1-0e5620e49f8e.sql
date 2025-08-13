-- Create DINING CHAIR category if it doesn't exist (fixing spelling)
INSERT INTO public.categories (name, slug, description, image_url)
VALUES (
  'DINING CHAIR',
  'dining-chair',
  'Stylish and comfortable dining chairs for your dining room',
  NULL
)
ON CONFLICT (slug) DO NOTHING;

-- Create DINING CHAIR models
WITH dining_chair_category AS (
  SELECT id FROM public.categories WHERE slug = 'dining-chair' LIMIT 1
)
INSERT INTO public.furniture_models (category_id, name, slug, description, base_price, is_featured)
SELECT 
  dcc.id,
  model_name,
  LOWER(REPLACE(model_name, ' ', '-')),
  'Premium ' || model_name || ' dining chair with customizable options',
  15000.00,
  false
FROM dining_chair_category dcc
CROSS JOIN (
  VALUES 
    ('Velit'),
    ('Arizona'),
    ('Noto'),
    ('Joli'),
    ('Souvenir'),
    ('Mellow'),
    ('Sperone'),
    ('Turtle'),
    ('Scarpa')
) AS models(model_name)
ON CONFLICT (slug) DO NOTHING;

-- Add missing attribute values for DINING CHAIR specific options

-- Add "SINGLE CHAIR" to number_of_seats
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT id, 'single_chair', 'SINGLE CHAIR', 1
FROM public.attribute_types 
WHERE name = 'number_of_seats'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = attribute_types.id 
  AND av.value = 'single_chair'
);

-- Add "24 inches" to seat_depth if not exists
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT id, '24_inches', '24" (Twentyfour inches)', 24
FROM public.attribute_types 
WHERE name = 'seat_depth'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = attribute_types.id 
  AND av.value = '24_inches'
);

-- Add "16 inches" to seat_height if not exists
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT id, '16_inches', '16" (Sixteen inches)', 16
FROM public.attribute_types 
WHERE name = 'seat_height'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = attribute_types.id 
  AND av.value = '16_inches'
);

-- Add "Ply" to wood_type
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT id, 'ply', 'Ply', 3
FROM public.attribute_types 
WHERE name = 'wood_type'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = attribute_types.id 
  AND av.value = 'ply'
);

-- Add "50-D U/R" to foam_type_seats
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT id, '50d_ur', '50-D U/R', 2
FROM public.attribute_types 
WHERE name = 'foam_type_seats'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = attribute_types.id 
  AND av.value = '50d_ur'
);

-- Add "20-D SSG" to foam_type_back_rest
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT id, '20d_ssg', '20-D SSG', 3
FROM public.attribute_types 
WHERE name = 'foam_type_back_rest'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = attribute_types.id 
  AND av.value = '20d_ssg'
);

-- Add dining chair specific leg options
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT 
  at.id,
  leg_data.value,
  leg_data.display_name,
  leg_data.sort_order
FROM public.attribute_types at
CROSS JOIN (
  VALUES 
    ('stainless_steel', 'Stainless Steel', 10),
    ('golden', 'Golden', 11),
    ('mild_steel_black', 'Mild Steel-Black', 12),
    ('mild_steel_brown', 'Mild Steel-Brown', 13),
    ('wood_teak', 'Wood-Teak', 14),
    ('wood_walnut', 'Wood-Walnut', 15),
    ('wood_special', 'Wood-???', 16),
    ('l8', 'L8', 17),
    ('l9', 'L9', 18),
    ('l10', 'L10', 19)
) AS leg_data(value, display_name, sort_order)
WHERE at.name = 'legs'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = at.id 
  AND av.value = leg_data.value
);

-- Link all DINING CHAIR models to their attributes
WITH dining_chair_models AS (
  SELECT fm.id as model_id
  FROM public.furniture_models fm
  JOIN public.categories c ON fm.category_id = c.id
  WHERE c.name = 'DINING CHAIR'
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
    'fabric_code', 'indicative_fabric_colour', 'legs', 'stitching_type',
    'overall_length', 'overall_width', 'overall_height'
  )
)
INSERT INTO public.model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
  dcm.model_id,
  am.attribute_type_id,
  am.is_required,
  CASE 
    -- Set default values for required attributes
    WHEN am.attribute_name = 'number_of_seats' THEN (
      SELECT av.id FROM public.attribute_values av 
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = 'single_chair'
    )
    WHEN am.attribute_name = 'seat_depth' THEN (
      SELECT av.id FROM public.attribute_values av 
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = '22_inches'
    )
    WHEN am.attribute_name = 'seat_height' THEN (
      SELECT av.id FROM public.attribute_values av 
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = '16_inches'
    )
    WHEN am.attribute_name = 'wood_type' THEN (
      SELECT av.id FROM public.attribute_values av 
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = 'ply' LIMIT 1
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
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = 'stainless_steel' LIMIT 1
    )
    ELSE NULL
  END
FROM dining_chair_models dcm
CROSS JOIN attribute_mappings am
ON CONFLICT (model_id, attribute_type_id) DO NOTHING;