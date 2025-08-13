-- Fix Model-Attribute Mappings for All Categories (Corrected)
-- This migration ensures every model has proper attribute mappings for configuration

-- 1. Map attributes to ARM CHAIR models (complete the existing mappings)
INSERT INTO public.model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT fm.id, at.id, TRUE, NULL
FROM public.furniture_models fm
JOIN public.attribute_types at ON at.name IN ('Seat Width', 'Fabric Cladding', 'Armrest Style', 'Cushion Firmness', 'Leg Finish')
WHERE fm.category_id = (SELECT id FROM public.categories WHERE slug = 'arm-chair')
  AND NOT EXISTS (
    SELECT 1 FROM public.model_attributes ma WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
  );

-- 2. Map attributes to DINING CHAIR models
INSERT INTO public.model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT fm.id, at.id, TRUE, NULL
FROM public.furniture_models fm
JOIN public.attribute_types at ON at.name IN ('Wood Type', 'Fabric Cladding', 'Seat Height', 'Back Support', 'Leg Finish')
WHERE fm.category_id = (SELECT id FROM public.categories WHERE slug = 'dining-chair')
  AND NOT EXISTS (
    SELECT 1 FROM public.model_attributes ma WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
  );

-- 3. Map attributes to SOFA models
INSERT INTO public.model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT fm.id, at.id, TRUE, NULL
FROM public.furniture_models fm
JOIN public.attribute_types at ON at.name IN ('Seating Capacity', 'Fabric Cladding', 'Cushion Firmness', 'Armrest Style', 'Leg Finish')
WHERE fm.category_id = (SELECT id FROM public.categories WHERE slug = 'sofa')
  AND NOT EXISTS (
    SELECT 1 FROM public.model_attributes ma WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
  );

-- 4. Map attributes to RECLINER models
INSERT INTO public.model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT fm.id, at.id, TRUE, NULL
FROM public.furniture_models fm
JOIN public.attribute_types at ON at.name IN ('Fabric Cladding', 'Cushion Firmness', 'Reclining Mechanism', 'Armrest Style', 'Leg Finish')
WHERE fm.category_id = (SELECT id FROM public.categories WHERE slug = 'recliner')
  AND NOT EXISTS (
    SELECT 1 FROM public.model_attributes ma WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
  );

-- 5. Map attributes to BED models
INSERT INTO public.model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT fm.id, at.id, TRUE, NULL
FROM public.furniture_models fm
JOIN public.attribute_types at ON at.name IN ('Bed Size', 'Fabric Cladding', 'Headboard Style', 'Storage Option', 'Leg Finish')
WHERE fm.category_id = (SELECT id FROM public.categories WHERE slug = 'bed')
  AND NOT EXISTS (
    SELECT 1 FROM public.model_attributes ma WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
  );

-- 6. Map attributes to LOUNGER models
INSERT INTO public.model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT fm.id, at.id, TRUE, NULL
FROM public.furniture_models fm
JOIN public.attribute_types at ON at.name IN ('Fabric Cladding', 'Cushion Firmness', 'Adjustable Positions', 'Armrest Style', 'Leg Finish')
WHERE fm.category_id = (SELECT id FROM public.categories WHERE slug = 'lounger')
  AND NOT EXISTS (
    SELECT 1 FROM public.model_attributes ma WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
  );

-- 7. Populate missing attribute values for better coverage
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT at.id, val.value, val.display_name, val.price_modifier, val.sort_order
FROM public.attribute_types at
JOIN (VALUES
  -- Seat Width options
  ('Seat Width', '20', '20" (Standard)', 0, 1),
  ('Seat Width', '22', '22" (Comfortable)', 300, 2),
  ('Seat Width', '24', '24" (Spacious)', 600, 3),
  ('Seat Width', '26', '26" (Extra Wide)', 1000, 4),
  
  -- Seat Height options
  ('Seat Height', '16', '16" (Low)', 0, 1),
  ('Seat Height', '18', '18" (Standard)', 100, 2),
  ('Seat Height', '20', '20" (Counter Height)', 200, 3),
  ('Seat Height', '24', '24" (Bar Height)', 400, 4),
  
  -- Back Support options
  ('Back Support', 'low', 'Low Back', 0, 1),
  ('Back Support', 'mid', 'Mid Back', 200, 2),
  ('Back Support', 'high', 'High Back', 400, 3),
  ('Back Support', 'ergonomic', 'Ergonomic', 600, 4),
  
  -- Seating Capacity options
  ('Seating Capacity', '2', '2 Seater', 0, 1),
  ('Seating Capacity', '3', '3 Seater', 800, 2),
  ('Seating Capacity', '4', '4 Seater', 1500, 3),
  ('Seating Capacity', 'sectional', 'Sectional', 2500, 4),
  
  -- Reclining Mechanism options
  ('Reclining Mechanism', 'manual', 'Manual Push-Back', 0, 1),
  ('Reclining Mechanism', 'lever', 'Lever Control', 300, 2),
  ('Reclining Mechanism', 'power', 'Electric Power', 800, 3),
  ('Reclining Mechanism', 'zero-gravity', 'Zero Gravity', 1200, 4),
  
  -- Bed Size options
  ('Bed Size', 'twin', 'Twin', 0, 1),
  ('Bed Size', 'full', 'Full', 400, 2),
  ('Bed Size', 'queen', 'Queen', 800, 3),
  ('Bed Size', 'king', 'King', 1200, 4),
  ('Bed Size', 'california-king', 'California King', 1500, 5),
  
  -- Headboard Style options
  ('Headboard Style', 'panel', 'Panel', 0, 1),
  ('Headboard Style', 'tufted', 'Tufted', 400, 2),
  ('Headboard Style', 'wingback', 'Wingback', 600, 3),
  ('Headboard Style', 'platform', 'Platform', 200, 4),
  
  -- Storage Option options
  ('Storage Option', 'none', 'No Storage', 0, 1),
  ('Storage Option', 'drawers', 'Under-bed Drawers', 500, 2),
  ('Storage Option', 'hydraulic', 'Hydraulic Lift', 800, 3),
  ('Storage Option', 'ottoman', 'Storage Ottoman', 300, 4),
  
  -- Adjustable Positions options
  ('Adjustable Positions', '3', '3 Positions', 0, 1),
  ('Adjustable Positions', '5', '5 Positions', 300, 2),
  ('Adjustable Positions', '7', '7 Positions', 600, 3),
  ('Adjustable Positions', 'infinite', 'Infinite Positions', 1000, 4)
) AS val(attr_name, value, display_name, price_modifier, sort_order) ON at.name = val.attr_name
WHERE NOT EXISTS (
  SELECT 1 FROM public.attribute_values av 
  WHERE av.attribute_type_id = at.id AND av.value = val.value
);

-- 8. Set default values for model attributes (corrected syntax)
-- Set defaults for each attribute type by finding the first available value
UPDATE public.model_attributes 
SET default_value_id = (
  SELECT av.id 
  FROM public.attribute_values av 
  WHERE av.attribute_type_id = model_attributes.attribute_type_id 
  ORDER BY av.sort_order 
  LIMIT 1
)
WHERE default_value_id IS NULL;