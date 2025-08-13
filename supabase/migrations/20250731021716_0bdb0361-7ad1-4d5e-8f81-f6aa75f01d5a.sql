-- Configure all SOFA COMFORT models with comprehensive customization attributes

-- Insert model_attributes for all SOFA COMFORT models
WITH sofa_comfort_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm 
  JOIN categories c ON fm.category_id = c.id 
  WHERE c.name ILIKE '%sofa comfort%'
),
attribute_mappings AS (
  SELECT 
    at.id as attribute_type_id,
    at.name as attribute_name,
    CASE 
      WHEN at.name = 'model' THEN true
      WHEN at.name = 'no_of_seats' THEN true
      WHEN at.name = 'need_lounger' THEN true
      WHEN at.name = 'lounger_position' THEN false
      WHEN at.name = 'lounger_length' THEN false
      WHEN at.name = 'seat_width' THEN true
      WHEN at.name = 'arm_rest_type' THEN true
      WHEN at.name = 'arm_rest_height' THEN false
      WHEN at.name = 'need_consoles' THEN true
      WHEN at.name = 'how_many_consoles' THEN false
      WHEN at.name = 'console_type' THEN false
      WHEN at.name = 'need_corner_unit' THEN true
      WHEN at.name = 'seat_depth' THEN true
      WHEN at.name = 'seat_height' THEN true
      WHEN at.name = 'overall_length' THEN false
      WHEN at.name = 'overall_width' THEN false
      WHEN at.name = 'overall_height' THEN false
      WHEN at.name = 'wood_type' THEN true
      WHEN at.name = 'foam_type_seats' THEN true
      WHEN at.name = 'foam_type_back_rest' THEN true
      WHEN at.name = 'fabric_cladding_plan' THEN true
      WHEN at.name = 'fabric_code' THEN true
      WHEN at.name = 'indicative_fabric_colour' THEN false
      WHEN at.name = 'legs' THEN true
      WHEN at.name = 'accessories' THEN false
      WHEN at.name = 'stitching_type' THEN true
      WHEN at.name = 'color' THEN true
      WHEN at.name = 'material' THEN true
      WHEN at.name = 'finish' THEN true
      ELSE false
    END as is_required,
    CASE 
      WHEN at.name = 'model' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = 'Grimaldo' LIMIT 1)
      WHEN at.name = 'no_of_seats' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = '2 (Two) seats' LIMIT 1)
      WHEN at.name = 'need_lounger' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = 'No' LIMIT 1)
      WHEN at.name = 'seat_width' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = '24" (Tweentyfour inches)' LIMIT 1)
      WHEN at.name = 'arm_rest_type' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = 'Default' LIMIT 1)
      WHEN at.name = 'need_consoles' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = 'No' LIMIT 1)
      WHEN at.name = 'need_corner_unit' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = 'No' LIMIT 1)
      WHEN at.name = 'seat_depth' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = '24" (Tweentyfour inches)' LIMIT 1)
      WHEN at.name = 'seat_height' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = '18" (Eighteen inches)' LIMIT 1)
      WHEN at.name = 'wood_type' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = 'Neem' LIMIT 1)
      WHEN at.name = 'foam_type_seats' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = '32-D P' LIMIT 1)
      WHEN at.name = 'foam_type_back_rest' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = '32-D P' LIMIT 1)
      WHEN at.name = 'fabric_cladding_plan' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = 'Single Colour' LIMIT 1)
      WHEN at.name = 'fabric_code' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = 'Vendor1-Collection-Name-Colour-Code' LIMIT 1)
      WHEN at.name = 'legs' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = 'Stainles Steel' LIMIT 1)
      WHEN at.name = 'stitching_type' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = 'S1' LIMIT 1)
      WHEN at.name = 'color' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = 'Beige' LIMIT 1)
      WHEN at.name = 'material' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = 'Fabric' LIMIT 1)
      WHEN at.name = 'finish' THEN (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id AND av.value = 'Matte' LIMIT 1)
      ELSE NULL
    END as default_value_id
  FROM attribute_types at
  WHERE at.name IN (
    'model', 'no_of_seats', 'need_lounger', 'lounger_position', 'lounger_length', 
    'seat_width', 'arm_rest_type', 'arm_rest_height', 'need_consoles', 'how_many_consoles',
    'console_type', 'need_corner_unit', 'seat_depth', 'seat_height', 'overall_length',
    'overall_width', 'overall_height', 'wood_type', 'foam_type_seats', 'foam_type_back_rest',
    'fabric_cladding_plan', 'fabric_code', 'indicative_fabric_colour', 'legs', 'accessories',
    'stitching_type', 'color', 'material', 'finish'
  )
)
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
  scm.model_id,
  am.attribute_type_id,
  am.is_required,
  am.default_value_id
FROM sofa_comfort_models scm
CROSS JOIN attribute_mappings am
ON CONFLICT (model_id, attribute_type_id) DO UPDATE SET
  is_required = EXCLUDED.is_required,
  default_value_id = EXCLUDED.default_value_id;