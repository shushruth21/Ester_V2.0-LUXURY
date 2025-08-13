-- Create BENCH category if it doesn't exist
INSERT INTO public.categories (name, slug, description, image_url)
VALUES (
  'BENCH',
  'bench',
  'Stylish and comfortable bench seating with customizable options',
  NULL
)
ON CONFLICT (slug) DO NOTHING;

-- Create BENCH models
WITH bench_category AS (
  SELECT id FROM public.categories WHERE slug = 'bench' LIMIT 1
)
INSERT INTO public.furniture_models (category_id, name, slug, description, base_price, is_featured)
SELECT 
  bc.id,
  model_name,
  LOWER(REPLACE(model_name, ' ', '-')),
  'Premium ' || model_name || ' bench with customizable seating options',
  12000.00,
  false
FROM bench_category bc
CROSS JOIN (
  VALUES 
    ('Contour'),
    ('Crave'),
    ('Fandango'),
    ('Dapper'),
    ('Dale'),
    ('Decker'),
    ('Hale'),
    ('Conrad'),
    ('Dana'),
    ('Sloafer')
) AS models(model_name)
ON CONFLICT (slug) DO NOTHING;

-- Add missing attribute values for BENCH

-- Add "2 Str" and "3 Str" to number_of_seats if not exists
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT 
  at.id,
  seat_data.value,
  seat_data.display_name,
  seat_data.sort_order
FROM public.attribute_types at
CROSS JOIN (
  VALUES 
    ('2_str', '2 Str', 2),
    ('3_str', '3 Str', 3)
) AS seat_data(value, display_name, sort_order)
WHERE at.name = 'number_of_seats'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = at.id 
  AND av.value = seat_data.value
);

-- Add "Candy C" to foam_type_seats if not exists
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT id, 'candy_c', 'Candy C', 4
FROM public.attribute_types 
WHERE name = 'foam_type_seats'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = attribute_types.id 
  AND av.value = 'candy_c'
);

-- Link all BENCH models to their attributes
WITH bench_models AS (
  SELECT fm.id as model_id
  FROM public.furniture_models fm
  JOIN public.categories c ON fm.category_id = c.id
  WHERE c.name = 'BENCH'
),
attribute_mappings AS (
  SELECT 
    at.id as attribute_type_id,
    at.name as attribute_name,
    CASE 
      WHEN at.name IN ('number_of_seats', 'seat_depth', 'seat_height', 'wood_type', 'foam_type_seats', 'fabric_cladding_plan', 'legs') THEN true
      ELSE false
    END as is_required
  FROM public.attribute_types at
  WHERE at.name IN (
    'number_of_seats', 'seat_depth', 'seat_height', 'wood_type', 
    'foam_type_seats', 'fabric_cladding_plan', 'fabric_code', 
    'indicative_fabric_colour', 'legs', 'overall_length', 
    'overall_width', 'overall_height'
  )
)
INSERT INTO public.model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
  bm.model_id,
  am.attribute_type_id,
  am.is_required,
  CASE 
    -- Set default values for required attributes
    WHEN am.attribute_name = 'number_of_seats' THEN (
      SELECT av.id FROM public.attribute_values av 
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = '2_str'
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
      WHERE av.attribute_type_id = am.attribute_type_id AND av.value = 'neem' LIMIT 1
    )
    WHEN am.attribute_name = 'foam_type_seats' THEN (
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
FROM bench_models bm
CROSS JOIN attribute_mappings am
ON CONFLICT (model_id, attribute_type_id) DO NOTHING;