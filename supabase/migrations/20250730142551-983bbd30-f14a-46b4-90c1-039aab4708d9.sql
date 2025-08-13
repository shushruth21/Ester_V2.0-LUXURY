-- Add comprehensive attribute values for existing attribute types
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) VALUES
-- Wood Type values
((SELECT id FROM attribute_types WHERE name = 'wood_type'), 'sheesham', 'Sheesham Wood', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'wood_type'), 'teak', 'Teak Wood', 2, 15000),
((SELECT id FROM attribute_types WHERE name = 'wood_type'), 'mango', 'Mango Wood', 3, 8000),
((SELECT id FROM attribute_types WHERE name = 'wood_type'), 'oak', 'Oak Wood', 4, 12000),
((SELECT id FROM attribute_types WHERE name = 'wood_type'), 'pine', 'Pine Wood', 5, 5000),

-- Fabric Code values
((SELECT id FROM attribute_types WHERE name = 'fabric_code'), 'fc001', 'Premium Cotton FC001', 1, 2000),
((SELECT id FROM attribute_types WHERE name = 'fabric_code'), 'fc002', 'Linen Blend FC002', 2, 3000),
((SELECT id FROM attribute_types WHERE name = 'fabric_code'), 'fc003', 'Velvet FC003', 3, 5000),
((SELECT id FROM attribute_types WHERE name = 'fabric_code'), 'fc004', 'Leather FC004', 4, 8000),
((SELECT id FROM attribute_types WHERE name = 'fabric_code'), 'fc005', 'Microfiber FC005', 5, 2500),

-- Foam Type values
((SELECT id FROM attribute_types WHERE name = 'foam_type'), 'standard', 'Standard Foam', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'foam_type'), 'memory', 'Memory Foam', 2, 4000),
((SELECT id FROM attribute_types WHERE name = 'foam_type'), 'high_density', 'High Density Foam', 3, 2500),
((SELECT id FROM attribute_types WHERE name = 'foam_type'), 'latex', 'Natural Latex', 4, 6000),

-- Console Type values
((SELECT id FROM attribute_types WHERE name = 'console_type'), 'none', 'No Console', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'console_type'), 'single', 'Single Console', 2, 3000),
((SELECT id FROM attribute_types WHERE name = 'console_type'), 'double', 'Double Console', 3, 5000),
((SELECT id FROM attribute_types WHERE name = 'console_type'), 'storage', 'Storage Console', 4, 4000),

-- Recliner Combination values
((SELECT id FROM attribute_types WHERE name = 'recliner_combination'), '1r', '1 Recliner', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'recliner_combination'), '2r', '2 Recliners', 2, 8000),
((SELECT id FROM attribute_types WHERE name = 'recliner_combination'), '3r', '3 Recliners', 3, 15000),
((SELECT id FROM attribute_types WHERE name = 'recliner_combination'), 'manual', 'Manual Recliner', 4, 5000),

-- Seating Capacity values
((SELECT id FROM attribute_types WHERE name = 'seating_capacity'), '2_seater', '2 Seater', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'seating_capacity'), '3_seater', '3 Seater', 2, 5000),
((SELECT id FROM attribute_types WHERE name = 'seating_capacity'), '5_seater', '5 Seater', 3, 12000),
((SELECT id FROM attribute_types WHERE name = 'seating_capacity'), '6_seater', '6 Seater', 4, 18000),
((SELECT id FROM attribute_types WHERE name = 'seating_capacity'), '7_seater', '7 Seater', 5, 25000),

-- Seating Type values
((SELECT id FROM attribute_types WHERE name = 'seating_type'), 'cushioned', 'Cushioned Seating', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'seating_type'), 'hard', 'Hard Seating', 2, -1000),
((SELECT id FROM attribute_types WHERE name = 'seating_type'), 'upholstered', 'Upholstered', 3, 3000),

-- Foam for Backrest values
((SELECT id FROM attribute_types WHERE name = 'foam_for_backrest'), 'standard_back', 'Standard Backrest Foam', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'foam_for_backrest'), 'lumbar', 'Lumbar Support Foam', 2, 2000),
((SELECT id FROM attribute_types WHERE name = 'foam_for_backrest'), 'memory_back', 'Memory Foam Backrest', 3, 3000),

-- Storage Thickness values
((SELECT id FROM attribute_types WHERE name = 'storage_thickness'), '4_inch', '4 Inch Storage', 1, 2000),
((SELECT id FROM attribute_types WHERE name = 'storage_thickness'), '6_inch', '6 Inch Storage', 2, 3500),
((SELECT id FROM attribute_types WHERE name = 'storage_thickness'), '8_inch', '8 Inch Storage', 3, 5000),

-- Accessories values
((SELECT id FROM attribute_types WHERE name = 'accessories'), 'pillows', 'Decorative Pillows', 1, 1500),
((SELECT id FROM attribute_types WHERE name = 'accessories'), 'throws', 'Throw Blankets', 2, 2000),
((SELECT id FROM attribute_types WHERE name = 'accessories'), 'covers', 'Protective Covers', 3, 1000),
((SELECT id FROM attribute_types WHERE name = 'accessories'), 'none_acc', 'No Accessories', 4, 0),

-- Lounger values
((SELECT id FROM attribute_types WHERE name = 'lounger'), 'left_lounger', 'Left Side Lounger', 1, 8000),
((SELECT id FROM attribute_types WHERE name = 'lounger'), 'right_lounger', 'Right Side Lounger', 2, 8000),
((SELECT id FROM attribute_types WHERE name = 'lounger'), 'both_lounger', 'Both Side Loungers', 3, 15000),
((SELECT id FROM attribute_types WHERE name = 'lounger'), 'no_lounger', 'No Lounger', 4, 0),

-- Legs values
((SELECT id FROM attribute_types WHERE name = 'legs'), 'wooden_legs', 'Wooden Legs', 1, 1000),
((SELECT id FROM attribute_types WHERE name = 'legs'), 'metal_legs', 'Metal Legs', 2, 1500),
((SELECT id FROM attribute_types WHERE name = 'legs'), 'plastic_legs', 'Plastic Legs', 3, 500),
((SELECT id FROM attribute_types WHERE name = 'legs'), 'no_legs', 'No Legs', 4, 0);

-- Create comprehensive model-attribute relationships for all categories

-- SOFA COMFORT models
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('seating_capacity', 'fabric_code', 'wood_type') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'SOFA COMFORT'
AND at.name IN ('seating_capacity', 'fabric_code', 'wood_type', 'foam_type', 'lounger', 'legs');

-- SOFA ECONOMY models
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('seating_capacity', 'fabric_code') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'SOFA ECONOMY'
AND at.name IN ('seating_capacity', 'fabric_code', 'wood_type', 'foam_type', 'lounger');

-- SOFA LUXURY models
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('seating_capacity', 'fabric_code', 'wood_type', 'foam_type') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'SOFA LUXURY'
AND at.name IN ('seating_capacity', 'fabric_code', 'wood_type', 'foam_type', 'lounger', 'legs', 'accessories');

-- SOFA CUM BED models
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('seating_capacity', 'fabric_code', 'foam_type') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'SOFA CUM BED'
AND at.name IN ('seating_capacity', 'fabric_code', 'wood_type', 'foam_type', 'storage_thickness');

-- RECLINER models
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('fabric_code', 'recliner_combination', 'foam_type') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'RECLINER'
AND at.name IN ('fabric_code', 'recliner_combination', 'foam_type', 'console_type', 'legs', 'wood_type');

-- DINING CHAIR models
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('wood_type', 'seating_type', 'foam_for_backrest') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'DINING CHAIR'
AND at.name IN ('wood_type', 'seating_type', 'foam_for_backrest', 'fabric_code', 'legs');

-- HOME THEATER models
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('seating_capacity', 'fabric_code', 'console_type') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'HOME THEATER'
AND at.name IN ('seating_capacity', 'fabric_code', 'console_type', 'foam_type', 'recliner_combination', 'legs');

-- BED COTS models (enhance existing)
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('wood_type', 'storage_thickness') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'BED COTS'
AND at.name IN ('wood_type', 'storage_thickness', 'accessories')
AND NOT EXISTS (
    SELECT 1 FROM model_attributes ma 
    WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
);

-- BED MATTRESS models (enhance existing)
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('foam_type', 'storage_thickness') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'BED MATTRESS'
AND at.name IN ('foam_type', 'storage_thickness', 'accessories', 'fabric_code')
AND NOT EXISTS (
    SELECT 1 FROM model_attributes ma 
    WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
);

-- OTTOMAN models (enhance existing)
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('fabric_code', 'foam_type') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'OTTOMAN'
AND at.name IN ('fabric_code', 'foam_type', 'wood_type', 'legs', 'storage_thickness')
AND NOT EXISTS (
    SELECT 1 FROM model_attributes ma 
    WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
);

-- BENCH models
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('wood_type', 'fabric_code') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'BENCH'
AND at.name IN ('wood_type', 'fabric_code', 'foam_type', 'storage_thickness', 'legs');

-- PUFFEE models
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('fabric_code', 'foam_type') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'PUFFEE'
AND at.name IN ('fabric_code', 'foam_type', 'wood_type', 'legs', 'storage_thickness');