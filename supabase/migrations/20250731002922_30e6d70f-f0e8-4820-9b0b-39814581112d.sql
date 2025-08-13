-- Link all KIDS BED models to the bed attributes
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id as model_id,
    at.id as attribute_type_id,
    true as is_required,
    NULL as default_value_id
FROM furniture_models fm
CROSS JOIN attribute_types at
WHERE fm.category_id = (SELECT id FROM categories WHERE slug = 'kids-bed')
  AND at.name IN ('dimensions', 'storage_option', 'storage_type', 'headboard_design', 'leg_options', 'accessories');