-- COMPREHENSIVE FURNITURE CONFIGURATION MIGRATION - FIXED
-- Implements complete attribute system for all categories

-- First, create missing SOFA ECONOMY models
WITH sofa_economy_category AS (
  SELECT id FROM public.categories WHERE name = 'SOFA ECONOMY'
),
new_economy_models AS (
  SELECT 
    gen_random_uuid() as id,
    cat.id as category_id,
    model_data.name,
    model_data.slug,
    model_data.description,
    15000 as base_price,
    false as is_featured
  FROM sofa_economy_category cat
  CROSS JOIN (
    VALUES
    ('Arbiter', 'arbiter', 'Premium Arbiter sofa design'),
    ('Crezz', 'crezz', 'Modern Crezz sofa collection'),
    ('Dolce', 'dolce', 'Elegant Dolce sofa series'),
    ('Liken', 'liken', 'Contemporary Liken sofa'),
    ('Marvik', 'marvik', 'Stylish Marvik sofa design'),
    ('Melbourne', 'melbourne', 'Melbourne luxury sofa'),
    ('Smartle', 'smartle', 'Smart Smartle sofa collection'),
    ('Feira', 'feira', 'Comfortable Feira sofa'),
    ('Prisciano', 'prisciano', 'Classic Prisciano design'),
    ('Priscilo', 'priscilo', 'Refined Priscilo sofa'),
    ('Sloggy', 'sloggy', 'Cozy Sloggy sofa series')
  ) AS model_data(name, slug, description)
)
INSERT INTO public.furniture_models (id, category_id, name, slug, description, base_price, is_featured, created_at, updated_at)
SELECT id, category_id, name, slug, description, base_price, is_featured, now(), now()
FROM new_economy_models
WHERE NOT EXISTS (
  SELECT 1 FROM furniture_models fm2 
  WHERE fm2.slug = new_economy_models.slug
);

-- Create additional attribute types needed for comprehensive configuration
INSERT INTO public.attribute_types (id, name, display_name, input_type, sort_order, created_at) VALUES
-- SOFA BED specific attributes
(gen_random_uuid(), 'recliner', 'Recliner', 'select', 50, now()),
(gen_random_uuid(), 'recliner_position', 'Recliner Position', 'select', 51, now()),
(gen_random_uuid(), 'seater_type', 'Seater Type', 'select', 52, now()),
(gen_random_uuid(), 'lounger_storage_option', 'Lounger Storage Option', 'select', 53, now()),
-- BED specific attributes
(gen_random_uuid(), 'dimensions', 'Dimensions', 'select', 60, now()),
(gen_random_uuid(), 'storage_option', 'Storage Option', 'select', 61, now()),
(gen_random_uuid(), 'storage_type', 'Storage Type', 'select', 62, now()),
(gen_random_uuid(), 'headboard_design', 'Headboard Design', 'select', 63, now()),
(gen_random_uuid(), 'bed_leg_options', 'Bed Leg Options', 'select', 64, now()),
(gen_random_uuid(), 'bed_features', 'Bed Features', 'select', 65, now())
ON CONFLICT (name) DO NOTHING;

-- Create attribute values for new attribute types with conflict handling
WITH attribute_lookup AS (
  SELECT id, name FROM public.attribute_types
)
INSERT INTO public.attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier, created_at)
SELECT 
  gen_random_uuid(),
  al.id,
  value_data.value,
  value_data.display_name,
  value_data.sort_order,
  value_data.price_modifier,
  now()
FROM attribute_lookup al
CROSS JOIN (
  VALUES
  -- Recliner values
  ('recliner', 'yes', 'Yes', 1, 5000),
  ('recliner', 'no', 'No', 2, 0),
  
  -- Recliner position values
  ('recliner_position', 'rhs', 'RHS', 1, 0),
  ('recliner_position', 'lhs', 'LHS', 2, 0),
  ('recliner_position', 'na', 'N/A', 3, 0),
  
  -- Seater type values
  ('seater_type', 'with_sofa_cum_bed', 'With Sofa Cum Bed', 1, 8000),
  ('seater_type', 'without_sofa_cum_bed', 'Without Sofa Cum Bed', 2, 0),
  
  -- Lounger storage option values
  ('lounger_storage_option', 'with_storage', 'With Storage', 1, 3000),
  ('lounger_storage_option', 'without_storage', 'Without Storage', 2, 0),
  
  -- Dimensions values
  ('dimensions', 'single_36_78', 'Single-36"/78"', 1, 0),
  ('dimensions', 'double_xl_48_78', 'Double XL-48"/78"', 2, 5000),
  ('dimensions', 'queen_66_78', 'Queen-66"/78"', 3, 10000),
  ('dimensions', 'king_72_78', 'King-72"/78"', 4, 15000),
  ('dimensions', 'king_xl_78_78', 'King XL-78"/78"', 5, 20000),
  
  -- Storage option values (note: these will have different values to avoid conflicts)
  ('storage_option', 'bed_with_storage', 'With Storage', 1, 5000),
  ('storage_option', 'bed_without_storage', 'Without Storage', 2, 0),
  
  -- Storage type values
  ('storage_type', 'side_draws', 'Side Draws', 1, 2000),
  ('storage_type', 'box_storage', 'Box Storage', 2, 3000),
  
  -- Headboard design values
  ('headboard_design', 'type_1', 'Type 1', 1, 2000),
  ('headboard_design', 'type_2', 'Type 2', 2, 3000),
  
  -- Bed leg options values
  ('bed_leg_options', 'type_1_2', 'Type 1-.2"', 1, 500),
  ('bed_leg_options', 'type_2_4', 'Type 2..4', 2, 800),
  
  -- Bed features values
  ('bed_features', 'reading_light', 'Reading Light', 1, 2500),
  ('bed_features', 'mobile_charging', 'Mobile Charging', 2, 1500)
) AS value_data(attribute_name, value, display_name, sort_order, price_modifier)
WHERE al.name = value_data.attribute_name
ON CONFLICT (attribute_type_id, value) DO NOTHING;

-- Add additional no_of_seats values for SOFA BED with conflict handling
INSERT INTO public.attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier, created_at)
SELECT 
  gen_random_uuid(),
  at.id,
  value_data.value,
  value_data.display_name,
  value_data.sort_order,
  value_data.price_modifier,
  now()
FROM attribute_types at
CROSS JOIN (
  VALUES
  ('2_str', '2 Str', 1, 0),
  ('3_str', '3 Str', 2, 2000),
  ('2_str_lounger_rhs', '2 Str+Lounger(RHS)', 3, 6000),
  ('2_str_lounger_lhs', '2 Str+Lounger(LHS)', 4, 6000),
  ('3_str_lounger_rhs', '3 Str+Lounger(RHS)', 5, 8000),
  ('3_str_lounger_lhs', '3 Str+Lounger(LHS)', 6, 8000),
  ('1_str_recliner', '1 Str Recliner', 7, 12000),
  ('lounger_rhs', 'Lounger (RHS)', 8, 6000),
  ('lounger_lhs', 'Lounger (LHS)', 9, 6000),
  ('single_chair', 'SINGLE CHAIR', 10, 0)
) AS value_data(value, display_name, sort_order, price_modifier)
WHERE at.name = 'no_of_seats'
ON CONFLICT (attribute_type_id, value) DO NOTHING;

-- Add chair-specific foam values with conflict handling
INSERT INTO public.attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier, created_at)
SELECT 
  gen_random_uuid(),
  at.id,
  value_data.value,
  value_data.display_name,
  value_data.sort_order,
  value_data.price_modifier,
  now()
FROM attribute_types at
CROSS JOIN (
  VALUES
  ('50_d_ur', '50-D U/R', 10, 1200)
) AS value_data(value, display_name, sort_order, price_modifier)
WHERE at.name = 'foam_type_seats'
ON CONFLICT (attribute_type_id, value) DO NOTHING;

-- Add sofa bed specific leg values with conflict handling
INSERT INTO public.attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier, created_at)
SELECT 
  gen_random_uuid(),
  at.id,
  value_data.value,
  value_data.display_name,
  value_data.sort_order,
  value_data.price_modifier,
  now()
FROM attribute_types at
CROSS JOIN (
  VALUES
  ('wood_leg_h2', 'Wood Leg (H-2")', 20, 800),
  ('nylon_bush_h2', 'Nylon Bush (H-2")', 21, 600)
) AS value_data(value, display_name, sort_order, price_modifier)
WHERE at.name = 'legs'
ON CONFLICT (attribute_type_id, value) DO NOTHING;

-- Add Ply wood type for chairs with conflict handling
INSERT INTO public.attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier, created_at)
SELECT 
  gen_random_uuid(),
  at.id,
  'ply',
  'Ply',
  10,
  500,
  now()
FROM attribute_types at
WHERE at.name = 'wood_type'
ON CONFLICT (attribute_type_id, value) DO NOTHING;

-- Now create model_attributes relationships

-- SOFA ECONOMY: Link all models to comprehensive sofa attributes
WITH sofa_economy_models AS (
  SELECT fm.id as model_id 
  FROM furniture_models fm 
  JOIN categories c ON fm.category_id = c.id 
  WHERE c.name = 'SOFA ECONOMY'
),
sofa_attributes AS (
  SELECT id as attribute_type_id, name
  FROM attribute_types 
  WHERE name IN (
    'model', 'no_of_seats', 'do_you_need_lounger', 'lounger_position', 'lounger_length',
    'seat_width', 'arm_rest_type', 'arm_rest_height', 'do_you_need_consoles', 'how_many_consoles',
    'console_type', 'do_you_need_corner_unit', 'seat_depth', 'seat_height', 'overall_length',
    'overall_width', 'overall_height', 'wood_type', 'foam_type_seats', 'foam_type_back_rest',
    'fabric_cladding_plan', 'fabric_code', 'indicative_fabric_colour', 'legs', 'accessories', 'stitching_type'
  )
)
INSERT INTO public.model_attributes (id, model_id, attribute_type_id, is_required, created_at)
SELECT 
  gen_random_uuid(),
  sem.model_id,
  sa.attribute_type_id,
  CASE WHEN sa.name IN ('model', 'no_of_seats', 'seat_width', 'seat_depth', 'wood_type', 'fabric_cladding_plan') THEN true ELSE false END,
  now()
FROM sofa_economy_models sem
CROSS JOIN sofa_attributes sa
WHERE NOT EXISTS (
  SELECT 1 FROM model_attributes ma 
  WHERE ma.model_id = sem.model_id 
  AND ma.attribute_type_id = sa.attribute_type_id
);

-- ARM CHAIR: Link all models to chair-specific attributes
WITH arm_chair_models AS (
  SELECT fm.id as model_id 
  FROM furniture_models fm 
  JOIN categories c ON fm.category_id = c.id 
  WHERE c.name = 'ARM CHAIR'
),
chair_attributes AS (
  SELECT id as attribute_type_id, name
  FROM attribute_types 
  WHERE name IN (
    'model', 'no_of_seats', 'seat_depth', 'seat_height', 'overall_length', 'overall_width',
    'overall_height', 'wood_type', 'foam_type_seats', 'foam_type_back_rest', 'fabric_cladding_plan',
    'fabric_code', 'indicative_fabric_colour', 'legs', 'stitching_type'
  )
)
INSERT INTO public.model_attributes (id, model_id, attribute_type_id, is_required, created_at)
SELECT 
  gen_random_uuid(),
  acm.model_id,
  ca.attribute_type_id,
  CASE WHEN ca.name IN ('model', 'no_of_seats', 'seat_depth', 'wood_type', 'fabric_cladding_plan') THEN true ELSE false END,
  now()
FROM arm_chair_models acm
CROSS JOIN chair_attributes ca
WHERE NOT EXISTS (
  SELECT 1 FROM model_attributes ma 
  WHERE ma.model_id = acm.model_id 
  AND ma.attribute_type_id = ca.attribute_type_id
);

-- DINNING CHAIR: Link all models to dining chair attributes
WITH dining_chair_models AS (
  SELECT fm.id as model_id 
  FROM furniture_models fm 
  JOIN categories c ON fm.category_id = c.id 
  WHERE c.name = 'DINNING CHAIR'
),
dining_chair_attributes AS (
  SELECT id as attribute_type_id, name
  FROM attribute_types 
  WHERE name IN (
    'model', 'no_of_seats', 'seat_depth', 'seat_height', 'overall_length', 'overall_width',
    'overall_height', 'wood_type', 'foam_type_seats', 'foam_type_back_rest', 'fabric_cladding_plan',
    'fabric_code', 'indicative_fabric_colour', 'legs', 'stitching_type'
  )
)
INSERT INTO public.model_attributes (id, model_id, attribute_type_id, is_required, created_at)
SELECT 
  gen_random_uuid(),
  dcm.model_id,
  dca.attribute_type_id,
  CASE WHEN dca.name IN ('model', 'no_of_seats', 'seat_depth', 'wood_type', 'fabric_cladding_plan') THEN true ELSE false END,
  now()
FROM dining_chair_models dcm
CROSS JOIN dining_chair_attributes dca
WHERE NOT EXISTS (
  SELECT 1 FROM model_attributes ma 
  WHERE ma.model_id = dcm.model_id 
  AND ma.attribute_type_id = dca.attribute_type_id
);

-- SOFA BED: Link all models to comprehensive sofa bed attributes
WITH sofa_bed_models AS (
  SELECT fm.id as model_id 
  FROM furniture_models fm 
  JOIN categories c ON fm.category_id = c.id 
  WHERE c.name = 'SOFA BED'
),
sofa_bed_attributes AS (
  SELECT id as attribute_type_id, name
  FROM attribute_types 
  WHERE name IN (
    'model', 'no_of_seats', 'seat_width', 'recliner', 'recliner_position', 'seater_type',
    'do_you_need_lounger', 'lounger_position', 'lounger_length', 'lounger_storage_option',
    'arm_rest_type', 'arm_rest_height', 'seat_depth', 'seat_height', 'overall_length',
    'overall_width', 'overall_height', 'wood_type', 'foam_type_seats', 'foam_type_back_rest',
    'fabric_cladding_plan', 'fabric_code', 'indicative_fabric_colour', 'legs', 'accessories', 'stitching_type'
  )
)
INSERT INTO public.model_attributes (id, model_id, attribute_type_id, is_required, created_at)
SELECT 
  gen_random_uuid(),
  sbm.model_id,
  sba.attribute_type_id,
  CASE WHEN sba.name IN ('model', 'no_of_seats', 'seat_width', 'recliner', 'seater_type', 'wood_type', 'fabric_cladding_plan') THEN true ELSE false END,
  now()
FROM sofa_bed_models sbm
CROSS JOIN sofa_bed_attributes sba
WHERE NOT EXISTS (
  SELECT 1 FROM model_attributes ma 
  WHERE ma.model_id = sbm.model_id 
  AND ma.attribute_type_id = sba.attribute_type_id
);

-- KIDS BED: Add missing attributes to enhance existing configuration
WITH kids_bed_models AS (
  SELECT fm.id as model_id 
  FROM furniture_models fm 
  JOIN categories c ON fm.category_id = c.id 
  WHERE c.name = 'KIDS BED'
),
bed_attributes AS (
  SELECT id as attribute_type_id, name
  FROM attribute_types 
  WHERE name IN (
    'model', 'dimensions', 'storage_option', 'storage_type', 'headboard_design', 'bed_leg_options', 'bed_features'
  )
)
INSERT INTO public.model_attributes (id, model_id, attribute_type_id, is_required, created_at)
SELECT 
  gen_random_uuid(),
  kbm.model_id,
  ba.attribute_type_id,
  CASE WHEN ba.name IN ('model', 'dimensions') THEN true ELSE false END,
  now()
FROM kids_bed_models kbm
CROSS JOIN bed_attributes ba
WHERE NOT EXISTS (
  SELECT 1 FROM model_attributes ma 
  WHERE ma.model_id = kbm.model_id 
  AND ma.attribute_type_id = ba.attribute_type_id
);

-- PUFFEE: Add comprehensive attributes beyond just leg options
WITH puffee_models AS (
  SELECT fm.id as model_id 
  FROM furniture_models fm 
  JOIN categories c ON fm.category_id = c.id 
  WHERE c.name = 'PUFFEE'
),
puffee_attributes AS (
  SELECT id as attribute_type_id, name
  FROM attribute_types 
  WHERE name IN (
    'model', 'bed_leg_options', 'fabric_cladding_plan', 'fabric_code', 'indicative_fabric_colour', 'wood_type'
  )
)
INSERT INTO public.model_attributes (id, model_id, attribute_type_id, is_required, created_at)
SELECT 
  gen_random_uuid(),
  pm.model_id,
  pa.attribute_type_id,
  CASE WHEN pa.name IN ('model', 'bed_leg_options') THEN true ELSE false END,
  now()
FROM puffee_models pm
CROSS JOIN puffee_attributes pa
WHERE NOT EXISTS (
  SELECT 1 FROM model_attributes ma 
  WHERE ma.model_id = pm.model_id 
  AND ma.attribute_type_id = pa.attribute_type_id
);

-- Success message
SELECT 'Comprehensive furniture configuration completed successfully! All categories now have full customization options.' as message;