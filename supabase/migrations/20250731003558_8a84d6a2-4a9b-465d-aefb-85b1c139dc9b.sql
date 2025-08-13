-- Link all SOFA BED models to the sofa bed attributes
INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id as model_id,
    at.id as attribute_type_id,
    true as is_required,
    NULL as default_value_id
FROM furniture_models fm
CROSS JOIN attribute_types at
WHERE fm.category_id = (SELECT id FROM categories WHERE slug = 'sofa-bed')
  AND at.name IN (
    'sofa_no_of_seats', 'sofa_seat_width', 'sofa_recliner', 'sofa_recliner_position',
    'sofa_seater_type', 'sofa_need_lounger', 'sofa_lounger_position', 'sofa_lounger_length',
    'sofa_lounger_storage', 'sofa_seat_depth', 'sofa_seat_height', 'sofa_wood_type',
    'sofa_foam_type_seats', 'sofa_foam_type_backrest', 'sofa_fabric_cladding_plan',
    'sofa_fabric_code', 'sofa_legs', 'sofa_accessories'
  );