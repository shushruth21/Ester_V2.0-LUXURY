-- Phase 1 & 2: Add missing attribute values for all categories

-- Wood types for recliners/dining
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order) 
SELECT id, 'teak', 'Teak Wood', 150.00, 1 FROM attribute_types WHERE name = 'wood_type_recliners_dining'
UNION ALL
SELECT id, 'oak', 'Oak Wood', 120.00, 2 FROM attribute_types WHERE name = 'wood_type_recliners_dining'
UNION ALL
SELECT id, 'mahogany', 'Mahogany Wood', 180.00, 3 FROM attribute_types WHERE name = 'wood_type_recliners_dining'
UNION ALL
SELECT id, 'pine', 'Pine Wood', 80.00, 4 FROM attribute_types WHERE name = 'wood_type_recliners_dining'
UNION ALL
SELECT id, 'walnut', 'Walnut Wood', 200.00, 5 FROM attribute_types WHERE name = 'wood_type_recliners_dining';

-- Wood types for sofas
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'teak', 'Teak Wood', 200.00, 1 FROM attribute_types WHERE name = 'wood_type_sofas'
UNION ALL
SELECT id, 'oak', 'Oak Wood', 160.00, 2 FROM attribute_types WHERE name = 'wood_type_sofas'
UNION ALL
SELECT id, 'mahogany', 'Mahogany Wood', 240.00, 3 FROM attribute_types WHERE name = 'wood_type_sofas'
UNION ALL
SELECT id, 'pine', 'Pine Wood', 100.00, 4 FROM attribute_types WHERE name = 'wood_type_sofas'
UNION ALL
SELECT id, 'walnut', 'Walnut Wood', 280.00, 5 FROM attribute_types WHERE name = 'wood_type_sofas';

-- Foam types for dining chairs
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'standard', 'Standard Foam', 0.00, 1 FROM attribute_types WHERE name = 'foam_type_backrest_dining'
UNION ALL
SELECT id, 'memory_foam', 'Memory Foam', 80.00, 2 FROM attribute_types WHERE name = 'foam_type_backrest_dining'
UNION ALL
SELECT id, 'high_density', 'High Density Foam', 60.00, 3 FROM attribute_types WHERE name = 'foam_type_backrest_dining'
UNION ALL
SELECT id, 'gel_infused', 'Gel Infused Foam', 120.00, 4 FROM attribute_types WHERE name = 'foam_type_backrest_dining';

-- Foam types for sofa seats
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'standard', 'Standard Foam', 0.00, 1 FROM attribute_types WHERE name = 'foam_type_seats_sofas'
UNION ALL
SELECT id, 'memory_foam', 'Memory Foam', 150.00, 2 FROM attribute_types WHERE name = 'foam_type_seats_sofas'
UNION ALL
SELECT id, 'high_density', 'High Density Foam', 100.00, 3 FROM attribute_types WHERE name = 'foam_type_seats_sofas'
UNION ALL
SELECT id, 'gel_infused', 'Gel Infused Foam', 200.00, 4 FROM attribute_types WHERE name = 'foam_type_seats_sofas'
UNION ALL
SELECT id, 'spring_foam', 'Spring & Foam Combination', 180.00, 5 FROM attribute_types WHERE name = 'foam_type_seats_sofas';

-- Foam types for recliner seats
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'standard', 'Standard Foam', 0.00, 1 FROM attribute_types WHERE name = 'foam_type_seats_recliners'
UNION ALL
SELECT id, 'memory_foam', 'Memory Foam', 200.00, 2 FROM attribute_types WHERE name = 'foam_type_seats_recliners'
UNION ALL
SELECT id, 'high_density', 'High Density Foam', 150.00, 3 FROM attribute_types WHERE name = 'foam_type_seats_recliners'
UNION ALL
SELECT id, 'gel_memory', 'Gel Memory Foam', 250.00, 4 FROM attribute_types WHERE name = 'foam_type_seats_recliners';

-- Foam types for recliner/ottoman backrest
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'standard', 'Standard Foam', 0.00, 1 FROM attribute_types WHERE name = 'foam_type_backrest_recliners_ottoman'
UNION ALL
SELECT id, 'memory_foam', 'Memory Foam', 180.00, 2 FROM attribute_types WHERE name = 'foam_type_backrest_recliners_ottoman'
UNION ALL
SELECT id, 'lumbar_support', 'Lumbar Support Foam', 220.00, 3 FROM attribute_types WHERE name = 'foam_type_backrest_recliners_ottoman'
UNION ALL
SELECT id, 'contour_foam', 'Contour Foam', 160.00, 4 FROM attribute_types WHERE name = 'foam_type_backrest_recliners_ottoman';

-- Fabric cladding for sofas
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'cotton', 'Cotton Fabric', 0.00, 1 FROM attribute_types WHERE name = 'fabric_cladding_sofas'
UNION ALL
SELECT id, 'leather', 'Genuine Leather', 400.00, 2 FROM attribute_types WHERE name = 'fabric_cladding_sofas'
UNION ALL
SELECT id, 'microfiber', 'Microfiber', 150.00, 3 FROM attribute_types WHERE name = 'fabric_cladding_sofas'
UNION ALL
SELECT id, 'velvet', 'Velvet', 200.00, 4 FROM attribute_types WHERE name = 'fabric_cladding_sofas'
UNION ALL
SELECT id, 'linen', 'Linen', 180.00, 5 FROM attribute_types WHERE name = 'fabric_cladding_sofas'
UNION ALL
SELECT id, 'synthetic_leather', 'Synthetic Leather', 250.00, 6 FROM attribute_types WHERE name = 'fabric_cladding_sofas';

-- Armchair/dining seating options
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'fixed', 'Fixed Seating', 0.00, 1 FROM attribute_types WHERE name = 'armchair_dining_seating'
UNION ALL
SELECT id, 'swivel', 'Swivel Base', 120.00, 2 FROM attribute_types WHERE name = 'armchair_dining_seating'
UNION ALL
SELECT id, 'rocking', 'Rocking Chair', 150.00, 3 FROM attribute_types WHERE name = 'armchair_dining_seating'
UNION ALL
SELECT id, 'adjustable_height', 'Adjustable Height', 180.00, 4 FROM attribute_types WHERE name = 'armchair_dining_seating';

-- Recliner legs
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'metal_black', 'Black Metal Base', 0.00, 1 FROM attribute_types WHERE name = 'legs_recliner_ottoman'
UNION ALL
SELECT id, 'metal_chrome', 'Chrome Metal Base', 50.00, 2 FROM attribute_types WHERE name = 'legs_recliner_ottoman'
UNION ALL
SELECT id, 'wood_teak', 'Teak Wood Base', 80.00, 3 FROM attribute_types WHERE name = 'legs_recliner_ottoman'
UNION ALL
SELECT id, 'wood_walnut', 'Walnut Wood Base', 100.00, 4 FROM attribute_types WHERE name = 'legs_recliner_ottoman'
UNION ALL
SELECT id, 'swivel_base', 'Swivel Base', 150.00, 5 FROM attribute_types WHERE name = 'legs_recliner_ottoman';

-- Recliner accessories
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'none', 'No Accessories', 0.00, 1 FROM attribute_types WHERE name = 'accessories_recliner_bed'
UNION ALL
SELECT id, 'cup_holder', 'Cup Holder', 80.00, 2 FROM attribute_types WHERE name = 'accessories_recliner_bed'
UNION ALL
SELECT id, 'massage', 'Massage Function', 500.00, 3 FROM attribute_types WHERE name = 'accessories_recliner_bed'
UNION ALL
SELECT id, 'heating', 'Heating Function', 400.00, 4 FROM attribute_types WHERE name = 'accessories_recliner_bed'
UNION ALL
SELECT id, 'usb_ports', 'USB Charging Ports', 120.00, 5 FROM attribute_types WHERE name = 'accessories_recliner_bed'
UNION ALL
SELECT id, 'storage', 'Storage Compartment', 200.00, 6 FROM attribute_types WHERE name = 'accessories_recliner_bed';

-- Console types
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'none', 'No Console', 0.00, 1 FROM attribute_types WHERE name = 'consol_type'
UNION ALL
SELECT id, 'basic', 'Basic Console', 150.00, 2 FROM attribute_types WHERE name = 'consol_type'
UNION ALL
SELECT id, 'storage', 'Storage Console', 250.00, 3 FROM attribute_types WHERE name = 'consol_type'
UNION ALL
SELECT id, 'cooled', 'Cooled Console', 400.00, 4 FROM attribute_types WHERE name = 'consol_type'
UNION ALL
SELECT id, 'wireless_charging', 'Wireless Charging Console', 350.00, 5 FROM attribute_types WHERE name = 'consol_type';

-- How many consoles
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, '0', 'No Consoles', 0.00, 1 FROM attribute_types WHERE name = 'how_many_consoles'
UNION ALL
SELECT id, '1', 'One Console', 200.00, 2 FROM attribute_types WHERE name = 'how_many_consoles'
UNION ALL
SELECT id, '2', 'Two Consoles', 380.00, 3 FROM attribute_types WHERE name = 'how_many_consoles';

-- Need lounger
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'no', 'No Lounger', 0.00, 1 FROM attribute_types WHERE name = 'need_lounger'
UNION ALL
SELECT id, 'yes', 'Add Lounger', 300.00, 2 FROM attribute_types WHERE name = 'need_lounger';

-- Lounger position
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'left', 'Left Side', 0.00, 1 FROM attribute_types WHERE name = 'lounger_position'
UNION ALL
SELECT id, 'right', 'Right Side', 0.00, 2 FROM attribute_types WHERE name = 'lounger_position';

-- Recliner specific combinations
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'manual', 'Manual Reclining', 0.00, 1 FROM attribute_types WHERE name = 'recliner_specific_combinations'
UNION ALL
SELECT id, 'electric', 'Electric Reclining', 800.00, 2 FROM attribute_types WHERE name = 'recliner_specific_combinations'
UNION ALL
SELECT id, 'zero_gravity', 'Zero Gravity Position', 1200.00, 3 FROM attribute_types WHERE name = 'recliner_specific_combinations'
UNION ALL
SELECT id, 'lift_chair', 'Lift Chair Function', 1000.00, 4 FROM attribute_types WHERE name = 'recliner_specific_combinations';

-- Bed sizes
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'single', 'Single (3x6 ft)', 0.00, 1 FROM attribute_types WHERE name = 'bed_size'
UNION ALL
SELECT id, 'double', 'Double (4.5x6 ft)', 200.00, 2 FROM attribute_types WHERE name = 'bed_size'
UNION ALL
SELECT id, 'queen', 'Queen (5x6.5 ft)', 400.00, 3 FROM attribute_types WHERE name = 'bed_size'
UNION ALL
SELECT id, 'king', 'King (6x6.5 ft)', 600.00, 4 FROM attribute_types WHERE name = 'bed_size'
UNION ALL
SELECT id, 'super_king', 'Super King (6.5x7 ft)', 800.00, 5 FROM attribute_types WHERE name = 'bed_size';

-- Storage types for bed
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'none', 'No Storage', 0.00, 1 FROM attribute_types WHERE name = 'storage_type_bed'
UNION ALL
SELECT id, 'drawers', 'Under Bed Drawers', 300.00, 2 FROM attribute_types WHERE name = 'storage_type_bed'
UNION ALL
SELECT id, 'hydraulic', 'Hydraulic Storage', 500.00, 3 FROM attribute_types WHERE name = 'storage_type_bed'
UNION ALL
SELECT id, 'box_storage', 'Box Storage', 400.00, 4 FROM attribute_types WHERE name = 'storage_type_bed';

-- Headrest types for bed
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, 'none', 'No Headrest', 0.00, 1 FROM attribute_types WHERE name = 'headrest_type_bed'
UNION ALL
SELECT id, 'basic', 'Basic Headrest', 150.00, 2 FROM attribute_types WHERE name = 'headrest_type_bed'
UNION ALL
SELECT id, 'padded', 'Padded Headrest', 250.00, 3 FROM attribute_types WHERE name = 'headrest_type_bed'
UNION ALL
SELECT id, 'adjustable', 'Adjustable Headrest', 350.00, 4 FROM attribute_types WHERE name = 'headrest_type_bed'
UNION ALL
SELECT id, 'led_lights', 'LED Backlit Headrest', 500.00, 5 FROM attribute_types WHERE name = 'headrest_type_bed';

-- Storage thickness for bed
INSERT INTO attribute_values (attribute_type_id, value, display_name, price_modifier, sort_order)
SELECT id, '6_inch', '6 Inch Storage', 200.00, 1 FROM attribute_types WHERE name = 'storage_thickness_bed'
UNION ALL
SELECT id, '8_inch', '8 Inch Storage', 300.00, 2 FROM attribute_types WHERE name = 'storage_thickness_bed'
UNION ALL
SELECT id, '10_inch', '10 Inch Storage', 400.00, 3 FROM attribute_types WHERE name = 'storage_thickness_bed'
UNION ALL
SELECT id, '12_inch', '12 Inch Storage', 500.00, 4 FROM attribute_types WHERE name = 'storage_thickness_bed';

-- Phase 3: Create model-attribute mappings for all categories

-- DINING CHAIR category mappings
WITH dining_chair_category AS (
  SELECT id FROM categories WHERE slug = 'dining-chair'
),
dining_chair_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN dining_chair_category dcc ON fm.category_id = dcc.id
),
dining_chair_attributes AS (
  SELECT id as attr_id, name as attr_name FROM attribute_types 
  WHERE name IN ('wood_type_recliners_dining', 'foam_type_backrest_dining', 'fabric_cladding_recliners_chairs_ottoman', 'legs', 'stitching_type', 'armchair_dining_seating')
)
INSERT INTO model_attributes (model_id, attribute_type_id, is_required)
SELECT dcm.model_id, dca.attr_id, 
  CASE 
    WHEN dca.attr_name IN ('wood_type_recliners_dining', 'fabric_cladding_recliners_chairs_ottoman') THEN true
    ELSE false
  END as is_required
FROM dining_chair_models dcm
CROSS JOIN dining_chair_attributes dca;

-- SOFA category mappings (all sofa types)
WITH sofa_categories AS (
  SELECT id FROM categories WHERE slug IN ('sofa', 'corner-sofa', 'recliner-sofa', 'single-seat-sofa', 'l-shaped-sofa')
),
sofa_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN sofa_categories sc ON fm.category_id = sc.id
),
sofa_attributes AS (
  SELECT id as attr_id, name as attr_name FROM attribute_types 
  WHERE name IN ('no_of_seats', 'need_lounger', 'lounger_position', 'seat_width', 'seat_depth', 'seat_height', 'wood_type_sofas', 'foam_type_seats_sofas', 'fabric_cladding_sofas', 'legs', 'how_many_consoles', 'consol_type')
)
INSERT INTO model_attributes (model_id, attribute_type_id, is_required)
SELECT sm.model_id, sa.attr_id,
  CASE 
    WHEN sa.attr_name IN ('no_of_seats', 'fabric_cladding_sofas', 'wood_type_sofas') THEN true
    ELSE false
  END as is_required
FROM sofa_models sm
CROSS JOIN sofa_attributes sa;

-- RECLINER category mappings
WITH recliner_category AS (
  SELECT id FROM categories WHERE slug = 'recliner'
),
recliner_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN recliner_category rc ON fm.category_id = rc.id
),
recliner_attributes AS (
  SELECT id as attr_id, name as attr_name FROM attribute_types 
  WHERE name IN ('foam_type_seats_recliners', 'foam_type_backrest_recliners_ottoman', 'legs_recliner_ottoman', 'accessories_recliner_bed', 'recliner_specific_combinations', 'fabric_cladding_recliners_chairs_ottoman')
)
INSERT INTO model_attributes (model_id, attribute_type_id, is_required)
SELECT rm.model_id, ra.attr_id,
  CASE 
    WHEN ra.attr_name IN ('recliner_specific_combinations', 'fabric_cladding_recliners_chairs_ottoman') THEN true
    ELSE false
  END as is_required
FROM recliner_models rm
CROSS JOIN recliner_attributes ra;

-- BED categories mappings
WITH bed_categories AS (
  SELECT id FROM categories WHERE slug IN ('bed-cots', 'bunk-bed')
),
bed_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN bed_categories bc ON fm.category_id = bc.id
),
bed_attributes AS (
  SELECT id as attr_id, name as attr_name FROM attribute_types 
  WHERE name IN ('bed_size', 'storage_type_bed', 'headrest_type_bed', 'storage_thickness_bed', 'wood_type_recliners_dining', 'fabric_cladding_recliners_chairs_ottoman')
)
INSERT INTO model_attributes (model_id, attribute_type_id, is_required)
SELECT bm.model_id, ba.attr_id,
  CASE 
    WHEN ba.attr_name IN ('bed_size', 'wood_type_recliners_dining') THEN true
    ELSE false
  END as is_required
FROM bed_models bm
CROSS JOIN bed_attributes ba;

-- HOME THEATER category mappings
WITH home_theater_category AS (
  SELECT id FROM categories WHERE slug = 'home-theater'
),
home_theater_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN home_theater_category htc ON fm.category_id = htc.id
),
home_theater_attributes AS (
  SELECT id as attr_id, name as attr_name FROM attribute_types 
  WHERE name IN ('no_of_seats', 'foam_type_seats_recliners', 'fabric_cladding_recliners_chairs_ottoman', 'legs_recliner_ottoman', 'how_many_consoles', 'consol_type', 'recliner_specific_combinations', 'accessories_recliner_bed')
)
INSERT INTO model_attributes (model_id, attribute_type_id, is_required)
SELECT htm.model_id, hta.attr_id,
  CASE 
    WHEN hta.attr_name IN ('no_of_seats', 'fabric_cladding_recliners_chairs_ottoman') THEN true
    ELSE false
  END as is_required
FROM home_theater_models htm
CROSS JOIN home_theater_attributes hta;

-- BENCH category mappings
WITH bench_category AS (
  SELECT id FROM categories WHERE slug = 'bench'
),
bench_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN bench_category bc ON fm.category_id = bc.id
),
bench_attributes AS (
  SELECT id as attr_id, name as attr_name FROM attribute_types 
  WHERE name IN ('wood_type_recliners_dining', 'fabric_cladding_recliners_chairs_ottoman', 'legs', 'seat_width', 'seat_depth', 'seat_height')
)
INSERT INTO model_attributes (model_id, attribute_type_id, is_required)
SELECT bm.model_id, ba.attr_id,
  CASE 
    WHEN ba.attr_name IN ('wood_type_recliners_dining') THEN true
    ELSE false
  END as is_required
FROM bench_models bm
CROSS JOIN bench_attributes ba;

-- PUFFEE category mappings
WITH puffee_category AS (
  SELECT id FROM categories WHERE slug = 'puffee'
),
puffee_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN puffee_category pc ON fm.category_id = pc.id
),
puffee_attributes AS (
  SELECT id as attr_id, name as attr_name FROM attribute_types 
  WHERE name IN ('fabric_cladding_recliners_chairs_ottoman', 'foam_type_backrest_recliners_ottoman', 'legs', 'seat_width', 'seat_height')
)
INSERT INTO model_attributes (model_id, attribute_type_id, is_required)
SELECT pm.model_id, pa.attr_id,
  CASE 
    WHEN pa.attr_name IN ('fabric_cladding_recliners_chairs_ottoman') THEN true
    ELSE false
  END as is_required
FROM puffee_models pm
CROSS JOIN puffee_attributes pa;