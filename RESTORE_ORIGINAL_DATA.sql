-- RESTORE ORIGINAL DATA SCRIPT
-- Run this script in the Supabase SQL Editor to restore the original simple furniture data
-- WARNING: This will replace ALL current furniture data with the original simple structure

-- Clear all current data
TRUNCATE TABLE public.model_attributes RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.attribute_values RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.attribute_types RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.furniture_models RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.categories RESTART IDENTITY CASCADE;

-- Restore original categories
INSERT INTO public.categories (id, name, slug, description, image_url, created_at, updated_at) VALUES
(gen_random_uuid(), 'Sofas', 'sofas', 'Comfortable and stylish sofas for your living room', NULL, now(), now()),
(gen_random_uuid(), 'Chairs', 'chairs', 'Elegant chairs for any space', NULL, now(), now()),
(gen_random_uuid(), 'Tables', 'tables', 'Beautiful tables for dining and working', NULL, now(), now()),
(gen_random_uuid(), 'Storage', 'storage', 'Storage solutions for your home', NULL, now(), now()),
(gen_random_uuid(), 'Lighting', 'lighting', 'Lighting fixtures to brighten your space', NULL, now(), now()),
(gen_random_uuid(), 'Decor', 'decor', 'Decorative items to enhance your home', NULL, now(), now());

-- Restore original furniture models
WITH category_lookup AS (
  SELECT id, slug FROM public.categories
)
INSERT INTO public.furniture_models (id, category_id, name, slug, description, base_price, default_image_url, is_featured, created_at, updated_at)
SELECT 
  gen_random_uuid(),
  cl.id,
  model_data.name,
  model_data.slug,
  model_data.description,
  model_data.base_price,
  NULL,
  model_data.is_featured,
  now(),
  now()
FROM category_lookup cl
CROSS JOIN (
  VALUES
  ('Classic Sofa', 'classic-sofa', 'sofas', 'A timeless classic sofa design', 15000, true),
  ('Modern Chair', 'modern-chair', 'chairs', 'Sleek and modern chair design', 5000, false),
  ('Dining Table', 'dining-table', 'tables', 'Elegant dining table for family meals', 12000, false),
  ('Bookshelf', 'bookshelf', 'storage', 'Spacious bookshelf for your collection', 8000, false),
  ('Table Lamp', 'table-lamp', 'lighting', 'Stylish table lamp for ambient lighting', 2500, false),
  ('Wall Art', 'wall-art', 'decor', 'Beautiful wall art to decorate your space', 1500, false)
) AS model_data(name, slug, category_slug, description, base_price, is_featured)
WHERE cl.slug = model_data.category_slug;

-- Restore original attribute types
INSERT INTO public.attribute_types (id, name, display_name, input_type, is_required, sort_order, created_at) VALUES
(gen_random_uuid(), 'color', 'Color', 'select', true, 1, now()),
(gen_random_uuid(), 'material', 'Material', 'select', true, 2, now()),
(gen_random_uuid(), 'size', 'Size', 'select', true, 3, now()),
(gen_random_uuid(), 'finish', 'Finish', 'select', false, 4, now());

-- Restore original attribute values
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
  -- Color values
  ('color', 'red', 'Red', 1, 0, '#ff0000'),
  ('color', 'blue', 'Blue', 2, 500, '#0000ff'),
  ('color', 'green', 'Green', 3, 500, '#00ff00'),
  ('color', 'black', 'Black', 4, 1000, '#000000'),
  
  -- Material values
  ('material', 'wood', 'Wood', 1, 0, NULL),
  ('material', 'metal', 'Metal', 2, 1500, NULL),
  ('material', 'fabric', 'Fabric', 3, 500, NULL),
  ('material', 'leather', 'Leather', 4, 2000, NULL),
  
  -- Size values
  ('size', 'small', 'Small', 1, -1000, NULL),
  ('size', 'medium', 'Medium', 2, 0, NULL),
  ('size', 'large', 'Large', 3, 2000, NULL),
  
  -- Finish values
  ('finish', 'matte', 'Matte', 1, 0, NULL),
  ('finish', 'glossy', 'Glossy', 2, 800, NULL)
) AS value_data(attribute_name, value, display_name, sort_order, price_modifier, hex_color)
WHERE al.name = value_data.attribute_name;

-- Create simple model_attributes relationships
WITH all_models AS (
  SELECT id as model_id FROM public.furniture_models
),
all_attributes AS (
  SELECT id as attribute_type_id FROM public.attribute_types
  WHERE name IN ('color', 'material', 'size')
)
INSERT INTO public.model_attributes (id, model_id, attribute_type_id, is_required, default_value_id, created_at)
SELECT 
  gen_random_uuid(),
  am.model_id,
  aa.attribute_type_id,
  true,
  NULL,
  now()
FROM all_models am
CROSS JOIN all_attributes aa;

-- Success message
SELECT 'Original furniture data has been restored successfully!' as message;