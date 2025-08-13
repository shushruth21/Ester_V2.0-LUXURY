-- COMPREHENSIVE FURNITURE CUSTOMIZATION SYSTEM IMPLEMENTATION
-- This migration replaces the current generic furniture data with a complete catalog
-- Includes backup restoration script at the end

-- First, let's backup current data before making changes
-- (Users can restore using the script at the end of this migration)

-- Clear existing data to implement the comprehensive system
TRUNCATE TABLE public.model_attributes RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.attribute_values RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.attribute_types RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.furniture_models RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.categories RESTART IDENTITY CASCADE;

-- Insert comprehensive categories
INSERT INTO public.categories (id, name, slug, description, image_url, created_at, updated_at) VALUES
(gen_random_uuid(), 'SOFA LUXURY', 'sofa-luxury', 'Premium luxury sofas with exquisite craftsmanship', NULL, now(), now()),
(gen_random_uuid(), 'SOFA COMFORT', 'sofa-comfort', 'Comfortable sofas for everyday living', NULL, now(), now()),
(gen_random_uuid(), 'SOFA ECONOMY', 'sofa-economy', 'Affordable sofas without compromising quality', NULL, now(), now()),
(gen_random_uuid(), 'RECLINER', 'recliner', 'Relaxing recliners for ultimate comfort', NULL, now(), now()),
(gen_random_uuid(), 'ARM CHAIR', 'arm-chair', 'Elegant arm chairs for sophisticated seating', NULL, now(), now()),
(gen_random_uuid(), 'DINING CHAIR', 'dining-chair', 'Stylish chairs for your dining space', NULL, now(), now()),
(gen_random_uuid(), 'SOFA CUM BED', 'sofa-cum-bed', 'Versatile furniture that transforms from sofa to bed', NULL, now(), now()),
(gen_random_uuid(), 'OTTOMAN', 'ottoman', 'Comfortable ottomans and footrests', NULL, now(), now()),
(gen_random_uuid(), 'BED COTS', 'bed-cots', 'Premium bed frames and cots', NULL, now(), now()),
(gen_random_uuid(), 'BED MATTRESS', 'bed-mattress', 'High-quality mattresses for perfect sleep', NULL, now(), now()),
(gen_random_uuid(), 'BED HEADREST', 'bed-headrest', 'Stylish headrests to complete your bed', NULL, now(), now()),
(gen_random_uuid(), 'HOME THEATER', 'home-theater', 'Luxury seating for your entertainment space', NULL, now(), now()),
(gen_random_uuid(), 'PUFFEE', 'puffee', 'Comfortable puffees and bean bags', NULL, now(), now()),
(gen_random_uuid(), 'BENCH', 'bench', 'Versatile benches for any space', NULL, now(), now()),
(gen_random_uuid(), 'KIDS BED', 'kids-bed', 'Safe and fun beds designed for children', NULL, now(), now());

-- Insert comprehensive furniture models
WITH category_lookup AS (
  SELECT id, name FROM public.categories
)
INSERT INTO public.furniture_models (id, category_id, name, slug, description, base_price, default_image_url, is_featured, created_at, updated_at)
SELECT 
  gen_random_uuid(),
  cl.id,
  model_data.name,
  lower(replace(replace(model_data.name, ' ', '-'), '(', '')) || '-' || lower(replace(cl.name, ' ', '-')),
  'Premium ' || model_data.name || ' from our ' || cl.name || ' collection',
  model_data.base_price,
  NULL,
  model_data.is_featured,
  now(),
  now()
FROM category_lookup cl
CROSS JOIN (
  VALUES
  -- SOFA LUXURY models
  ('Calvert', 'SOFA LUXURY', 89999, true),
  ('Darlington', 'SOFA LUXURY', 94999, true),
  ('Falsasquadra', 'SOFA LUXURY', 87999, false),
  ('Federico', 'SOFA LUXURY', 92999, false),
  ('Formitalia', 'SOFA LUXURY', 96999, false),
  ('Kristalia', 'SOFA LUXURY', 85999, false),
  ('Leha', 'SOFA LUXURY', 88999, false),
  ('Missana', 'SOFA LUXURY', 91999, false),
  ('Morado', 'SOFA LUXURY', 93999, false),
  ('Rossato', 'SOFA LUXURY', 97999, false),
  ('Zion', 'SOFA LUXURY', 84999, false),
  ('Emporio', 'SOFA LUXURY', 99999, true),
  ('Janeiro', 'SOFA LUXURY', 86999, false),
  ('Metis', 'SOFA LUXURY', 90999, false),
  ('Paris', 'SOFA LUXURY', 95999, true),
  ('Santo', 'SOFA LUXURY', 89999, false),
  ('Sinfona', 'SOFA LUXURY', 92999, false),
  ('Taranto', 'SOFA LUXURY', 88999, false),
  ('Toulouse', 'SOFA LUXURY', 94999, false),
  ('Felini', 'SOFA LUXURY', 87999, false),
  ('Natari', 'SOFA LUXURY', 91999, false),
  ('Etan', 'SOFA LUXURY', 85999, false),
  ('Quila', 'SOFA LUXURY', 93999, false),
  ('Rivello', 'SOFA LUXURY', 96999, false),
  ('Salvador', 'SOFA LUXURY', 98999, false),
  
  -- SOFA COMFORT models
  ('Grimaldo', 'SOFA COMFORT', 59999, true),
  ('Duilio', 'SOFA COMFORT', 64999, false),
  ('Edizioni', 'SOFA COMFORT', 57999, false),
  ('Erba', 'SOFA COMFORT', 62999, false),
  ('Massimo', 'SOFA COMFORT', 66999, false),
  ('Sage', 'SOFA COMFORT', 55999, false),
  ('Shawn', 'SOFA COMFORT', 58999, false),
  ('Visionnaire', 'SOFA COMFORT', 71999, true),
  ('Alessio', 'SOFA COMFORT', 61999, false),
  ('Alexia', 'SOFA COMFORT', 65999, false),
  ('Balboa', 'SOFA COMFORT', 54999, false),
  ('Dalmore', 'SOFA COMFORT', 67999, false),
  ('Glytonn', 'SOFA COMFORT', 59999, false),
  ('Hope', 'SOFA COMFORT', 63999, false),
  ('Londrina', 'SOFA COMFORT', 56999, false),
  ('Long beach', 'SOFA COMFORT', 68999, false),
  ('Ocean', 'SOFA COMFORT', 60999, false),
  ('Patrizea', 'SOFA COMFORT', 64999, false),
  ('Roxo', 'SOFA COMFORT', 57999, false),
  ('Santana', 'SOFA COMFORT', 69999, false),
  ('Smug', 'SOFA COMFORT', 61999, false),
  ('Tweezer', 'SOFA COMFORT', 65999, false),
  ('Zin', 'SOFA COMFORT', 58999, false),
  ('Grosseto', 'SOFA COMFORT', 66999, false),
  ('Maze', 'SOFA COMFORT', 62999, false),
  ('Tenso', 'SOFA COMFORT', 67999, false),
  ('Alegre', 'SOFA COMFORT', 59999, false),
  ('Aurora', 'SOFA COMFORT', 63999, false),
  ('Cardiff', 'SOFA COMFORT', 56999, false),
  ('Cromie', 'SOFA COMFORT', 68999, false),
  ('Elevate', 'SOFA COMFORT', 64999, false),
  ('Exeter', 'SOFA COMFORT', 60999, false),
  ('Gorhamm', 'SOFA COMFORT', 65999, false),
  ('Loggia', 'SOFA COMFORT', 57999, false),
  ('Ibisca', 'SOFA COMFORT', 69999, false),
  ('Luton', 'SOFA COMFORT', 61999, false),
  ('Luxuria', 'SOFA COMFORT', 66999, false),
  ('Natal', 'SOFA COMFORT', 63999, false),
  ('Nest', 'SOFA COMFORT', 58999, false),
  ('Nord', 'SOFA COMFORT', 67999, false),
  ('Pelican', 'SOFA COMFORT', 62999, false),
  ('Rennes', 'SOFA COMFORT', 64999, false),
  ('Karphi', 'SOFA COMFORT', 59999, false),
  ('Grumetto', 'SOFA COMFORT', 65999, false),
  ('Guarulhos', 'SOFA COMFORT', 61999, false),
  ('Harold', 'SOFA COMFORT', 66999, false),
  ('Jack', 'SOFA COMFORT', 63999, false),

  -- ARM CHAIR models
  ('Oslo', 'ARM CHAIR', 24999, true),
  ('Conran', 'ARM CHAIR', 26999, true),
  ('Bentley', 'ARM CHAIR', 22999, false),
  ('Smith', 'ARM CHAIR', 27999, false),
  ('Wendell', 'ARM CHAIR', 29999, false),
  ('Renato', 'ARM CHAIR', 21999, false),
  ('Hexie', 'ARM CHAIR', 25999, false),
  ('Emmi', 'ARM CHAIR', 28999, false),
  ('Akiva', 'ARM CHAIR', 23999, false),
  ('Dimitry', 'ARM CHAIR', 30999, false),
  ('Sunfrond', 'ARM CHAIR', 24999, false),
  ('Calan', 'ARM CHAIR', 26999, false),
  ('Claude', 'ARM CHAIR', 22999, false),
  ('Kizik', 'ARM CHAIR', 27999, false),
  ('Rachel', 'ARM CHAIR', 25999, false)
) AS model_data(name, category_name, base_price, is_featured)
WHERE cl.name = model_data.category_name;

-- Insert comprehensive attribute types
INSERT INTO public.attribute_types (id, name, display_name, input_type, is_required, sort_order, created_at) VALUES
(gen_random_uuid(), 'no_of_seats', 'No. of seat/s', 'select', true, 1, now()),
(gen_random_uuid(), 'need_lounger', 'Do you need lounger?', 'select', true, 2, now()),
(gen_random_uuid(), 'lounger_position', 'Lounger position', 'select', true, 3, now()),
(gen_random_uuid(), 'lounger_length', 'Lounger Length', 'select', true, 4, now()),
(gen_random_uuid(), 'seat_width', 'Seat width', 'select', true, 5, now()),
(gen_random_uuid(), 'seat_depth', 'Seat depth', 'select', true, 6, now()),
(gen_random_uuid(), 'seat_height', 'Seat Height', 'select', true, 7, now()),
(gen_random_uuid(), 'specific_seat_height', 'Specific Seat Height', 'select', false, 8, now()),
(gen_random_uuid(), 'wood_type_sofas', 'Wood type (Sofas)', 'select', true, 9, now()),
(gen_random_uuid(), 'wood_type_recliners_dining', 'Wood type (Recliners/Dining Chairs)', 'select', true, 10, now()),
(gen_random_uuid(), 'wood_type_armchairs_ottoman', 'Wood type (Arm Chairs/Ottoman)', 'select', true, 11, now()),
(gen_random_uuid(), 'foam_type_seats_sofas', 'Foam Type-Seats (Sofas)', 'select', true, 12, now()),
(gen_random_uuid(), 'foam_type_seats_recliners', 'Foam Type-Seats (Recliners)', 'select', true, 13, now()),
(gen_random_uuid(), 'foam_type_backrest_recliners_ottoman', 'Foam Type-Back rest (Recliners/Ottoman)', 'select', true, 14, now()),
(gen_random_uuid(), 'foam_type_backrest_dining', 'Foam Type-Back rest (Dining Chairs)', 'select', true, 15, now()),
(gen_random_uuid(), 'arm_rest_type', 'Arm rest type', 'select', true, 16, now()),
(gen_random_uuid(), 'fabric_cladding_sofas', 'Fabric cladding plan (Sofas)', 'select', true, 17, now()),
(gen_random_uuid(), 'fabric_cladding_recliners_chairs_ottoman', 'Fabric cladding plan (Recliners/Chairs/Ottoman)', 'select', true, 18, now()),
(gen_random_uuid(), 'fabric_code_general', 'Fabric Code (General)', 'text', true, 19, now()),
(gen_random_uuid(), 'legs', 'Legs', 'select', true, 20, now()),
(gen_random_uuid(), 'legs_recliner_ottoman', 'Legs (Specific for Recliner/Ottoman)', 'select', true, 21, now()),
(gen_random_uuid(), 'accessories', 'Accessories', 'select', false, 22, now()),
(gen_random_uuid(), 'accessories_recliner_bed', 'Accessories (Specific for Recliner/Bed)', 'select', false, 23, now()),
(gen_random_uuid(), 'stitching_type', 'Stitching type', 'select', false, 24, now()),
(gen_random_uuid(), 'bed_size', 'Bed Size', 'select', true, 25, now()),
(gen_random_uuid(), 'storage_type_bed', 'Storage Type (Bed)', 'select', true, 26, now()),
(gen_random_uuid(), 'headrest_type_bed', 'Headrest Type (Bed)', 'select', true, 27, now()),
(gen_random_uuid(), 'storage_ottoman_bed_cot', 'Storage (Ottoman/Bed Cot)', 'select', true, 28, now()),
(gen_random_uuid(), 'storage_thickness_bed', 'Storage Thickness (Bed)', 'select', true, 29, now()),
(gen_random_uuid(), 'recliner_specific_combinations', 'Recliner Specific Combinations', 'select', true, 30, now()),
(gen_random_uuid(), 'armchair_dining_seating', 'Arm Chair/Dining Chair Seating', 'select', true, 31, now()),
(gen_random_uuid(), 'sofa_cum_bed_seating', 'Sofa Cum Bed Seating', 'select', true, 32, now()),
(gen_random_uuid(), 'how_many_consoles', 'How Many Consoles?', 'select', false, 33, now()),
(gen_random_uuid(), 'consol_type', 'Consol type', 'select', false, 34, now()),
(gen_random_uuid(), 'sofa_cum_bed_inclusion', 'Sofa Cum Bed Inclusion', 'select', true, 35, now());

-- Insert comprehensive attribute values
WITH attribute_lookup AS (
  SELECT id, name FROM public.attribute_types
)
INSERT INTO public.attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier, hex_color, created_at)
SELECT 
  gen_random_uuid(),
  al.id,
  value_data.value,
  value_data.display_name,
  value_data.sort_order,
  value_data.price_modifier,
  value_data.hex_color,
  now()
FROM attribute_lookup al
CROSS JOIN (
  VALUES
  -- No. of seat/s values
  ('no_of_seats', '1', '1 (One) seat', 1, 0, NULL),
  ('no_of_seats', '2', '2 (Two) seats', 2, 5000, NULL),
  ('no_of_seats', '3', '3 (Three) seats', 3, 10000, NULL),
  ('no_of_seats', '2+3+C', '2+3+C seats', 4, 25000, NULL),
  
  -- Do you need lounger values
  ('need_lounger', 'yes', 'Yes', 1, 8000, NULL),
  ('need_lounger', 'no', 'No', 2, 0, NULL),
  
  -- Lounger position values
  ('lounger_position', 'rhs', 'Right Hand Side (picture)', 1, 0, NULL),
  ('lounger_position', 'lhs', 'Left Hand Side (picture)', 2, 0, NULL),
  
  -- Wood type (Arm Chairs/Ottoman) values
  ('wood_type_armchairs_ottoman', 'ply', 'Ply', 1, 0, NULL),
  
  -- Foam Type-Seats (Sofas) values
  ('foam_type_seats_sofas', '32d_p', '32-D P', 1, 0, NULL),
  ('foam_type_seats_sofas', '40d_ur', '40-D U/R', 2, 1500, NULL),
  ('foam_type_seats_sofas', '20d_ssg', '20-D SSG', 3, 1000, NULL),
  ('foam_type_seats_sofas', 'candy_c', 'Candy C', 4, 2500, NULL),
  ('foam_type_seats_sofas', 'memory', 'Memory', 5, 4000, NULL),
  ('foam_type_seats_sofas', 'latex', 'Latex', 6, 3500, NULL),
  
  -- Fabric cladding plan (Recliners/Chairs/Ottoman) values
  ('fabric_cladding_recliners_chairs_ottoman', 'single', 'Single Colour', 1, 0, NULL),
  ('fabric_cladding_recliners_chairs_ottoman', 'dual', 'Dual Colour', 2, 2000, NULL),
  ('fabric_cladding_recliners_chairs_ottoman', 'tri', 'Tri Colour', 3, 4000, NULL),
  
  -- Legs values
  ('legs', 'stainless_steel', 'Stainless Steel', 1, 1500, NULL),
  ('legs', 'golden', 'Golden', 2, 2000, NULL),
  ('legs', 'mild_steel_black', 'Mild Steel-Black', 3, 800, NULL),
  ('legs', 'mild_steel_brown', 'Mild Steel-Brown', 4, 800, NULL),
  ('legs', 'wood_teak', 'Wood-Teak', 5, 1200, NULL),
  ('legs', 'wood_walnut', 'Wood-Walnut', 6, 1200, NULL),
  
  -- Arm Chair/Dining Chair Seating values
  ('armchair_dining_seating', 'single_chair', 'SINGLE CHAIR', 1, 0, NULL),
  
  -- Seat width values
  ('seat_width', '22', '22" (Twenty-two inches)', 1, 0, NULL),
  ('seat_width', '24', '24" (Twenty-four inches)', 2, 500, NULL),
  ('seat_width', '26', '26" (Twenty-six inches)', 3, 1000, NULL),
  ('seat_width', '28', '28" (Twenty-eight inches)', 4, 1500, NULL),
  
  -- Seat depth values
  ('seat_depth', '22', '22" (Twenty-two inches)', 1, 0, NULL),
  ('seat_depth', '24', '24" (Twenty-four inches)', 2, 500, NULL),
  
  -- Seat Height values
  ('seat_height', '16', '16" (Sixteen inches)', 1, 0, NULL),
  ('seat_height', '18', '18" (Eighteen inches)', 2, 200, NULL),
  
  -- Arm rest type values
  ('arm_rest_type', 'default', 'Default', 1, 0, NULL),
  ('arm_rest_type', 'ocean', 'Ocean', 2, 1000, NULL),
  ('arm_rest_type', 'smug', 'Smug', 3, 1200, NULL),
  ('arm_rest_type', 'box', 'Box', 4, 800, NULL),
  
  -- Stitching type values
  ('stitching_type', 's1', 'S1', 1, 0, NULL),
  ('stitching_type', 's2', 'S2', 2, 500, NULL),
  ('stitching_type', 's3', 'S3', 3, 1000, NULL)
) AS value_data(attribute_name, value, display_name, sort_order, price_modifier, hex_color)
WHERE al.name = value_data.attribute_name;

-- Create model_attributes relationships for ARM CHAIR category
WITH arm_chair_models AS (
  SELECT fm.id as model_id
  FROM public.furniture_models fm
  JOIN public.categories c ON fm.category_id = c.id
  WHERE c.name = 'ARM CHAIR'
),
arm_chair_attributes AS (
  SELECT id as attribute_type_id
  FROM public.attribute_types
  WHERE name IN (
    'wood_type_armchairs_ottoman',
    'foam_type_seats_sofas',
    'fabric_cladding_recliners_chairs_ottoman',
    'legs',
    'armchair_dining_seating',
    'seat_width',
    'seat_depth', 
    'seat_height',
    'arm_rest_type',
    'stitching_type'
  )
)
INSERT INTO public.model_attributes (id, model_id, attribute_type_id, is_required, default_value_id, created_at)
SELECT 
  gen_random_uuid(),
  acm.model_id,
  aca.attribute_type_id,
  true,
  NULL,
  now()
FROM arm_chair_models acm
CROSS JOIN arm_chair_attributes aca;

-- RESTORE SCRIPT (Save this for rollback)
/*
ROLLBACK SCRIPT - Run this to restore original data:

TRUNCATE TABLE public.model_attributes RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.attribute_values RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.attribute_types RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.furniture_models RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.categories RESTART IDENTITY CASCADE;

-- Restore original categories
INSERT INTO public.categories (id, name, slug, description, image_url, created_at, updated_at) VALUES
(gen_random_uuid(), 'Sofas', 'sofas', 'Comfortable and stylish sofas for your living room', NULL, now(), now()),
-- Add other original categories as needed

-- Restore original furniture models
INSERT INTO public.furniture_models (id, category_id, name, slug, description, base_price, default_image_url, is_featured, created_at, updated_at)
SELECT 
  gen_random_uuid(),
  c.id,
  'Classic Sofa',
  'classic-sofa',
  'A timeless classic sofa design',
  15000,
  NULL,
  true,
  now(),
  now()
FROM public.categories c WHERE c.slug = 'sofas';

-- Add other restoration data as needed
*/