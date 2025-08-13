-- Configure all SOFA LUXURY models with comprehensive customization options

-- First, ensure we have all SOFA LUXURY models with proper attributes
WITH sofa_models AS (
  SELECT fm.id as model_id, fm.name as model_name
  FROM furniture_models fm
  JOIN categories c ON fm.category_id = c.id
  WHERE c.name = 'Sofas'
),
sofa_luxury_attributes AS (
  -- All SOFA LUXURY specific attributes
  SELECT 
    at.id as attribute_type_id,
    at.name as attribute_name,
    at.sort_order
  FROM attribute_types at
  WHERE at.name IN (
    'number_of_seats', 'need_lounger', 'lounger_position', 'lounger_length',
    'seat_width', 'arm_rest_type', 'arm_rest_height', 'need_consoles',
    'console_count', 'console_type', 'need_corner_unit', 'seat_depth',
    'seat_height', 'overall_length', 'overall_width', 'overall_height',
    'wood_type', 'foam_type_seats', 'foam_type_back_rest', 'fabric_cladding_plan',
    'fabric_code', 'indicative_fabric_colour', 'legs', 'accessories',
    'stitching_type', 'color', 'material', 'finish', 'style'
  )
)
-- Insert comprehensive model_attributes for all SOFA models
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
  sm.model_id,
  sla.attribute_type_id,
  CASE 
    WHEN sla.attribute_name IN ('number_of_seats', 'need_lounger', 'seat_width', 'seat_depth', 'seat_height', 'wood_type', 'foam_type_seats', 'foam_type_back_rest', 'fabric_cladding_plan', 'legs', 'color', 'material') THEN true
    ELSE false
  END as is_required,
  -- Set intelligent default values for key attributes
  CASE 
    WHEN sla.attribute_name = 'number_of_seats' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = '3 (Three) seats' LIMIT 1
    )
    WHEN sla.attribute_name = 'need_lounger' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'No' LIMIT 1
    )
    WHEN sla.attribute_name = 'lounger_position' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'Right Hand Side (picture)' LIMIT 1
    )
    WHEN sla.attribute_name = 'lounger_length' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = '6 (Six) feet' LIMIT 1
    )
    WHEN sla.attribute_name = 'seat_width' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = '24" (Twentyfour inches)' LIMIT 1
    )
    WHEN sla.attribute_name = 'arm_rest_type' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'Default' LIMIT 1
    )
    WHEN sla.attribute_name = 'need_consoles' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'No' LIMIT 1
    )
    WHEN sla.attribute_name = 'console_count' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = '1 (One)' LIMIT 1
    )
    WHEN sla.attribute_name = 'console_type' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = '6" (Six inches)' LIMIT 1
    )
    WHEN sla.attribute_name = 'need_corner_unit' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'No' LIMIT 1
    )
    WHEN sla.attribute_name = 'seat_depth' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = '22" (Twentytwo inches)' LIMIT 1
    )
    WHEN sla.attribute_name = 'seat_height' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = '18" (Eighteen inches)' LIMIT 1
    )
    WHEN sla.attribute_name = 'wood_type' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'Neem' LIMIT 1
    )
    WHEN sla.attribute_name = 'foam_type_seats' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = '32-D P' LIMIT 1
    )
    WHEN sla.attribute_name = 'foam_type_back_rest' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = '32-D P' LIMIT 1
    )
    WHEN sla.attribute_name = 'fabric_cladding_plan' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'Single Colour' LIMIT 1
    )
    WHEN sla.attribute_name = 'fabric_code' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'Vendor1-Collection-Name-Colour-Code' LIMIT 1
    )
    WHEN sla.attribute_name = 'legs' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'Stainless Steel' LIMIT 1
    )
    WHEN sla.attribute_name = 'accessories' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'USB' LIMIT 1
    )
    WHEN sla.attribute_name = 'stitching_type' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'S1' LIMIT 1
    )
    WHEN sla.attribute_name = 'color' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'Charcoal Gray' LIMIT 1
    )
    WHEN sla.attribute_name = 'material' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'Premium Leather' LIMIT 1
    )
    WHEN sla.attribute_name = 'finish' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'Matte' LIMIT 1
    )
    WHEN sla.attribute_name = 'style' THEN (
      SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = sla.attribute_type_id AND av.value = 'Modern' LIMIT 1
    )
    ELSE NULL
  END as default_value_id
FROM sofa_models sm
CROSS JOIN sofa_luxury_attributes sla
WHERE NOT EXISTS (
  -- Only insert if the model_attribute relationship doesn't already exist
  SELECT 1 FROM model_attributes ma 
  WHERE ma.model_id = sm.model_id 
  AND ma.attribute_type_id = sla.attribute_type_id
);

-- Verify the comprehensive configuration worked
SELECT 
  fm.name as model_name,
  COUNT(ma.id) as total_attributes
FROM furniture_models fm
JOIN categories c ON fm.category_id = c.id
LEFT JOIN model_attributes ma ON fm.id = ma.model_id
WHERE c.name = 'Sofas'
GROUP BY fm.id, fm.name
ORDER BY fm.name;