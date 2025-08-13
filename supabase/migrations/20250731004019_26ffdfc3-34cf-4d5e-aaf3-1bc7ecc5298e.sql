-- Create PUFFEE category if it doesn't exist
INSERT INTO public.categories (name, slug, description, image_url)
VALUES (
  'PUFFEE',
  'puffee',
  'Modern and comfortable puffee furniture with various leg options',
  NULL
)
ON CONFLICT (slug) DO NOTHING;

-- Create PUFFEE models
WITH puffee_category AS (
  SELECT id FROM public.categories WHERE slug = 'puffee' LIMIT 1
)
INSERT INTO public.furniture_models (category_id, name, slug, description, base_price, is_featured)
SELECT 
  pc.id,
  model_name,
  LOWER(REPLACE(model_name, ' ', '-')),
  'Premium ' || model_name || ' puffee with customizable leg options',
  8000.00,
  false
FROM puffee_category pc
CROSS JOIN (
  VALUES 
    ('Rioni'),
    ('Entro'),
    ('Twils'),
    ('Galet'),
    ('Wade'),
    ('Atay'),
    ('Falkon'),
    ('Amet'),
    ('Driade'),
    ('Amaretto'),
    ('Tod'),
    ('Marenco'),
    ('Nesos'),
    ('Pyro'),
    ('Marion'),
    ('Sabot'),
    ('Kubico'),
    ('Qeeboo')
) AS models(model_name)
ON CONFLICT (slug) DO NOTHING;

-- Add PUFFEE specific leg options
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order)
SELECT 
  at.id,
  leg_data.value,
  leg_data.display_name,
  leg_data.sort_order
FROM public.attribute_types at
CROSS JOIN (
  VALUES 
    ('type_1_2', 'Type 1-.2"', 20),
    ('type_2_4', 'Type 2..4', 21)
) AS leg_data(value, display_name, sort_order)
WHERE at.name = 'legs'
AND NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = at.id 
  AND av.value = leg_data.value
);

-- Link all PUFFEE models to leg options attribute
WITH puffee_models AS (
  SELECT fm.id as model_id
  FROM public.furniture_models fm
  JOIN public.categories c ON fm.category_id = c.id
  WHERE c.name = 'PUFFEE'
),
leg_attribute AS (
  SELECT id as attribute_type_id
  FROM public.attribute_types 
  WHERE name = 'legs'
)
INSERT INTO public.model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
  pm.model_id,
  la.attribute_type_id,
  true, -- Leg options are required for puffees
  (
    SELECT av.id FROM public.attribute_values av 
    WHERE av.attribute_type_id = la.attribute_type_id 
    AND av.value = 'type_1_2' 
    LIMIT 1
  ) -- Set Type 1-.2" as default
FROM puffee_models pm
CROSS JOIN leg_attribute la
ON CONFLICT (model_id, attribute_type_id) DO NOTHING;