-- Restore model_attributes for ARM CHAIR models to fix missing customization options

-- First, let's get the ARM CHAIR category and model IDs
WITH arm_chair_models AS (
  SELECT fm.id as model_id, fm.name as model_name
  FROM furniture_models fm
  JOIN categories c ON fm.category_id = c.id
  WHERE c.name = 'Armchair'
),
attribute_mapping AS (
  -- Map attribute types by name to IDs for ARM CHAIR specific attributes
  SELECT 
    at.id as attribute_type_id,
    at.name as attribute_name,
    at.sort_order
  FROM attribute_types at
  WHERE at.name IN (
    'color', 'material', 'seat_depth', 'seat_height', 'wood_type',
    'foam_type_seats', 'foam_type_back_rest', 'fabric_cladding_plan',
    'fabric_code', 'legs', 'finish', 'style', 'stitching_type'
  )
)
-- Insert model_attributes for all ARM CHAIR models
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
  acm.model_id,
  am.attribute_type_id,
  CASE 
    WHEN am.attribute_name IN ('color', 'material', 'seat_depth', 'seat_height', 'wood_type', 'foam_type_seats', 'foam_type_back_rest', 'legs') THEN true
    ELSE false
  END as is_required,
  -- Set default values for key attributes
  CASE 
    WHEN am.attribute_name = 'color' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = am.attribute_type_id AND av.value = 'Charcoal Gray' LIMIT 1
    )
    WHEN am.attribute_name = 'material' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = am.attribute_type_id AND av.value = 'Fabric' LIMIT 1
    )
    WHEN am.attribute_name = 'seat_depth' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = am.attribute_type_id AND av.value = '22" (Twenty-two inches)' LIMIT 1
    )
    WHEN am.attribute_name = 'seat_height' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = am.attribute_type_id AND av.value = '18" (Eighteen inches)' LIMIT 1
    )
    WHEN am.attribute_name = 'wood_type' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = am.attribute_type_id AND av.value = 'Ply' LIMIT 1
    )
    WHEN am.attribute_name = 'foam_type_seats' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = am.attribute_type_id AND av.value = '32-D P' LIMIT 1
    )
    WHEN am.attribute_name = 'foam_type_back_rest' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = am.attribute_type_id AND av.value = '32-D P' LIMIT 1
    )
    WHEN am.attribute_name = 'fabric_cladding_plan' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = am.attribute_type_id AND av.value = 'Single Colour' LIMIT 1
    )
    WHEN am.attribute_name = 'legs' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = am.attribute_type_id AND av.value = 'Stainless Steel' LIMIT 1
    )
    ELSE NULL
  END as default_value_id
FROM arm_chair_models acm
CROSS JOIN attribute_mapping am
WHERE NOT EXISTS (
  -- Only insert if the model_attribute relationship doesn't already exist
  SELECT 1 FROM model_attributes ma 
  WHERE ma.model_id = acm.model_id 
  AND ma.attribute_type_id = am.attribute_type_id
);

-- Verify the restoration worked
SELECT 
  fm.name as model_name,
  COUNT(ma.id) as attribute_count
FROM furniture_models fm
JOIN categories c ON fm.category_id = c.id
LEFT JOIN model_attributes ma ON fm.id = ma.model_id
WHERE c.name = 'Armchair'
GROUP BY fm.id, fm.name
ORDER BY fm.name;