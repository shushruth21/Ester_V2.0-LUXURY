-- Add attribute values only for existing attribute types
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT at.id, 'sheesham', 'Sheesham Wood', 1, 0
FROM attribute_types at WHERE at.name = 'wood_type'
UNION ALL
SELECT at.id, 'teak', 'Teak Wood', 2, 15000
FROM attribute_types at WHERE at.name = 'wood_type'
UNION ALL
SELECT at.id, 'mango', 'Mango Wood', 3, 8000
FROM attribute_types at WHERE at.name = 'wood_type'
UNION ALL
SELECT at.id, 'oak', 'Oak Wood', 4, 12000
FROM attribute_types at WHERE at.name = 'wood_type'
UNION ALL
SELECT at.id, 'pine', 'Pine Wood', 5, 5000
FROM attribute_types at WHERE at.name = 'wood_type'
UNION ALL
SELECT at.id, 'fc001', 'Premium Cotton FC001', 1, 2000
FROM attribute_types at WHERE at.name = 'fabric_code'
UNION ALL
SELECT at.id, 'fc002', 'Linen Blend FC002', 2, 3000
FROM attribute_types at WHERE at.name = 'fabric_code'
UNION ALL
SELECT at.id, 'fc003', 'Velvet FC003', 3, 5000
FROM attribute_types at WHERE at.name = 'fabric_code'
UNION ALL
SELECT at.id, 'fc004', 'Leather FC004', 4, 8000
FROM attribute_types at WHERE at.name = 'fabric_code'
UNION ALL
SELECT at.id, 'fc005', 'Microfiber FC005', 5, 2500
FROM attribute_types at WHERE at.name = 'fabric_code'
UNION ALL
SELECT at.id, 'standard', 'Standard Foam', 1, 0
FROM attribute_types at WHERE at.name = 'foam_type'
UNION ALL
SELECT at.id, 'memory', 'Memory Foam', 2, 4000
FROM attribute_types at WHERE at.name = 'foam_type'
UNION ALL
SELECT at.id, 'high_density', 'High Density Foam', 3, 2500
FROM attribute_types at WHERE at.name = 'foam_type'
UNION ALL
SELECT at.id, 'latex', 'Natural Latex', 4, 6000
FROM attribute_types at WHERE at.name = 'foam_type';

-- Add model-attribute relationships for categories that need them
-- First, let's enhance existing categories with more attributes

-- SOFA COMFORT models - add missing attributes
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('fabric_code', 'wood_type') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'SOFA COMFORT'
AND at.name IN ('fabric_code', 'wood_type', 'foam_type')
AND NOT EXISTS (
    SELECT 1 FROM model_attributes ma 
    WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
);

-- SOFA ECONOMY models - add missing attributes
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('fabric_code') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'SOFA ECONOMY'
AND at.name IN ('fabric_code', 'wood_type', 'foam_type')
AND NOT EXISTS (
    SELECT 1 FROM model_attributes ma 
    WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
);

-- SOFA LUXURY models - add missing attributes
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('fabric_code', 'wood_type', 'foam_type') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'SOFA LUXURY'
AND at.name IN ('fabric_code', 'wood_type', 'foam_type')
AND NOT EXISTS (
    SELECT 1 FROM model_attributes ma 
    WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
);

-- SOFA CUM BED models - add missing attributes
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
WHERE c.name = 'SOFA CUM BED'
AND at.name IN ('fabric_code', 'wood_type', 'foam_type')
AND NOT EXISTS (
    SELECT 1 FROM model_attributes ma 
    WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
);

-- RECLINER models - add missing attributes
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
WHERE c.name = 'RECLINER'
AND at.name IN ('fabric_code', 'foam_type', 'wood_type')
AND NOT EXISTS (
    SELECT 1 FROM model_attributes ma 
    WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
);

-- DINING CHAIR models - add missing attributes
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('wood_type') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'DINING CHAIR'
AND at.name IN ('wood_type', 'fabric_code', 'foam_type')
AND NOT EXISTS (
    SELECT 1 FROM model_attributes ma 
    WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
);

-- HOME THEATER models - add missing attributes
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('fabric_code') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'HOME THEATER'
AND at.name IN ('fabric_code', 'foam_type', 'wood_type')
AND NOT EXISTS (
    SELECT 1 FROM model_attributes ma 
    WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
);

-- BED COTS models - add missing attributes
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('wood_type') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'BED COTS'
AND at.name IN ('wood_type', 'foam_type', 'fabric_code')
AND NOT EXISTS (
    SELECT 1 FROM model_attributes ma 
    WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
);

-- BED MATTRESS models - add missing attributes
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    CASE 
        WHEN at.name IN ('foam_type') THEN true
        ELSE false
    END,
    (SELECT av.id FROM attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM furniture_models fm
CROSS JOIN attribute_types at
JOIN categories c ON fm.category_id = c.id
WHERE c.name = 'BED MATTRESS'
AND at.name IN ('foam_type', 'fabric_code')
AND NOT EXISTS (
    SELECT 1 FROM model_attributes ma 
    WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
);

-- OTTOMAN models - add missing attributes
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
AND at.name IN ('fabric_code', 'foam_type', 'wood_type')
AND NOT EXISTS (
    SELECT 1 FROM model_attributes ma 
    WHERE ma.model_id = fm.id AND ma.attribute_type_id = at.id
);

-- BENCH models - add attributes
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
AND at.name IN ('wood_type', 'fabric_code', 'foam_type');

-- PUFFEE models - add attributes
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
AND at.name IN ('fabric_code', 'foam_type', 'wood_type');