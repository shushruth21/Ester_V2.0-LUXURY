-- Create attribute types for SOFA BED
INSERT INTO attribute_types (name, display_name, input_type, description, sort_order) VALUES
('no_of_seats', 'No. of seat/s', 'select', 'Number and configuration of seats', 1),
('seat_width', 'Seat width', 'select', 'Width of individual seats in inches', 2),
('recliner', 'Recliner', 'select', 'Whether recliner is available', 3),
('recliner_position', 'Recliner Position', 'select', 'Position of recliner (RHS/LHS/N/A)', 4),
('seater_type', 'Seater Type', 'select', 'With or without sofa cum bed functionality', 5),
('need_lounger', 'Do you need lounger?', 'select', 'Whether lounger is required', 6),
('lounger_position', 'Lounger position', 'select', 'Position of lounger relative to picture', 7),
('lounger_length', 'Lounger Length', 'select', 'Length of lounger in feet', 8),
('lounger_storage', 'Lounger Storage option', 'select', 'Storage option for lounger', 9),
('arm_rest_type', 'Arm rest type', 'select', 'Type of arm rest', 10),
('arm_rest_height', 'Arm rest height', 'select', 'Height of arm rest', 11),
('seat_depth', 'Seat depth', 'select', 'Depth of seats in inches', 12),
('seat_height', 'Seat Height', 'select', 'Height of seat from ground in inches', 13),
('overall_length', 'Overall length', 'select', 'Total length of sofa', 14),
('overall_width', 'Overall width', 'select', 'Total width of sofa', 15),
('overall_height', 'Overall height', 'select', 'Total height of sofa', 16),
('wood_type', 'Wood type', 'select', 'Type of wood used in frame', 17),
('foam_type_seats', 'Foam Type-Seats', 'select', 'Type of foam used in seats', 18),
('foam_type_backrest', 'Foam Type-Back rest', 'select', 'Type of foam used in back rest', 19),
('fabric_cladding_plan', 'Fabric cladding plan', 'select', 'Color scheme for fabric', 20),
('fabric_code', 'Fabric code', 'select', 'Vendor and fabric specifications', 21),
('indicative_fabric_colour', 'Indicative Fabric Colour', 'color', 'Color indicator for fabric', 22),
('legs', 'Legs', 'select', 'Type and height of legs', 23),
('sofa_accessories', 'Accessories', 'select', 'Additional accessories like USB ports', 24),
('stitching_type', 'Stitching type', 'select', 'Type of stitching pattern', 25);

-- Create attribute values for SOFA BED
-- No. of seat/s
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, '2_str', '2 Str', 1, 0 FROM attribute_types WHERE name = 'no_of_seats'
UNION ALL
SELECT id, '3_str', '3 Str', 2, 200 FROM attribute_types WHERE name = 'no_of_seats'
UNION ALL
SELECT id, '2_str_lounger_rhs', '2 Str+Lounger(RHS)', 3, 500 FROM attribute_types WHERE name = 'no_of_seats'
UNION ALL
SELECT id, '2_str_lounger_lhs', '2 Str+Lounger(LHS)', 4, 500 FROM attribute_types WHERE name = 'no_of_seats'
UNION ALL
SELECT id, '3_str_lounger_rhs', '3 Str+Lounger(RHS)', 5, 700 FROM attribute_types WHERE name = 'no_of_seats'
UNION ALL
SELECT id, '3_str_lounger_lhs', '3 Str+Lounger(LHS)', 6, 700 FROM attribute_types WHERE name = 'no_of_seats'
UNION ALL
SELECT id, '1_str_recliner', '1 Str Recliner', 7, 300 FROM attribute_types WHERE name = 'no_of_seats'
UNION ALL
SELECT id, 'lounger_rhs', 'Lounger (RHS)', 8, 400 FROM attribute_types WHERE name = 'no_of_seats'
UNION ALL
SELECT id, 'lounger_lhs', 'Lounger (LHS)', 9, 400 FROM attribute_types WHERE name = 'no_of_seats';

-- Seat width
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, '22_inches', '22" (Twenty-two inches)', 1, 0 FROM attribute_types WHERE name = 'seat_width'
UNION ALL
SELECT id, '24_inches', '24" (Twenty-four inches)', 2, 50 FROM attribute_types WHERE name = 'seat_width'
UNION ALL
SELECT id, '26_inches', '26" (Twenty-six inches)', 3, 100 FROM attribute_types WHERE name = 'seat_width'
UNION ALL
SELECT id, '28_inches', '28" (Twenty-eight inches)', 4, 150 FROM attribute_types WHERE name = 'seat_width';

-- Recliner
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, 'yes', 'Yes', 1, 300 FROM attribute_types WHERE name = 'recliner'
UNION ALL
SELECT id, 'no', 'No', 2, 0 FROM attribute_types WHERE name = 'recliner';

-- Recliner Position
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, 'rhs', 'RHS', 1, 0 FROM attribute_types WHERE name = 'recliner_position'
UNION ALL
SELECT id, 'lhs', 'LHS', 2, 0 FROM attribute_types WHERE name = 'recliner_position'
UNION ALL
SELECT id, 'na', 'N/A', 3, 0 FROM attribute_types WHERE name = 'recliner_position';

-- Seater Type
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, 'with_sofa_cum_bed', 'With Sofa Cum Bed', 1, 400 FROM attribute_types WHERE name = 'seater_type'
UNION ALL
SELECT id, 'without_sofa_cum_bed', 'Without Sofa Cum Bed', 2, 0 FROM attribute_types WHERE name = 'seater_type';

-- Do you need lounger?
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, 'yes', 'Yes', 1, 500 FROM attribute_types WHERE name = 'need_lounger'
UNION ALL
SELECT id, 'no', 'No', 2, 0 FROM attribute_types WHERE name = 'need_lounger';

-- Lounger position
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, 'right_hand_side', 'Right Hand Side (picture)', 1, 0 FROM attribute_types WHERE name = 'lounger_position'
UNION ALL
SELECT id, 'left_hand_side', 'Left Hand Side (picture)', 2, 0 FROM attribute_types WHERE name = 'lounger_position';

-- Lounger Length
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, '5_5_feet', '5.5 (Five and a half) feet', 1, 0 FROM attribute_types WHERE name = 'lounger_length'
UNION ALL
SELECT id, '6_feet', '6 (Six) feet', 2, 100 FROM attribute_types WHERE name = 'lounger_length'
UNION ALL
SELECT id, '6_5_feet', '6.5 (Six and a half) feet', 3, 200 FROM attribute_types WHERE name = 'lounger_length'
UNION ALL
SELECT id, '7_feet', '7 (Seven) feet', 4, 300 FROM attribute_types WHERE name = 'lounger_length';

-- Lounger Storage option
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, 'with_storage', 'With Storage', 1, 200 FROM attribute_types WHERE name = 'lounger_storage'
UNION ALL
SELECT id, 'without_storage', 'Without Storage', 2, 0 FROM attribute_types WHERE name = 'lounger_storage';

-- Seat depth
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, '22_inches', '22" (Twenty-two inches)', 1, 0 FROM attribute_types WHERE name = 'seat_depth'
UNION ALL
SELECT id, '24_inches', '24" (Twenty-four inches)', 2, 50 FROM attribute_types WHERE name = 'seat_depth';

-- Seat Height
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, '16_inches', '16" (Sixteen inches)', 1, 0 FROM attribute_types WHERE name = 'seat_height'
UNION ALL
SELECT id, '18_inches', '18" (Eighteen inches)', 2, 50 FROM attribute_types WHERE name = 'seat_height';

-- Wood type
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, 'neem', 'Neem', 1, 0 FROM attribute_types WHERE name = 'wood_type'
UNION ALL
SELECT id, 'pine', 'Pine', 2, 150 FROM attribute_types WHERE name = 'wood_type';

-- Foam Type-Seats
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, '32_d_p', '32-D P', 1, 0 FROM attribute_types WHERE name = 'foam_type_seats'
UNION ALL
SELECT id, '40_d_ur', '40-D U/R', 2, 100 FROM attribute_types WHERE name = 'foam_type_seats'
UNION ALL
SELECT id, '20_d_ssg', '20-D SSG', 3, 50 FROM attribute_types WHERE name = 'foam_type_seats'
UNION ALL
SELECT id, 'candy_c', 'Candy C', 4, 200 FROM attribute_types WHERE name = 'foam_type_seats';

-- Foam Type-Back rest
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, '32_d_p', '32-D P', 1, 0 FROM attribute_types WHERE name = 'foam_type_backrest'
UNION ALL
SELECT id, '40_d_ur', '40-D U/R', 2, 100 FROM attribute_types WHERE name = 'foam_type_backrest'
UNION ALL
SELECT id, '20_d_ssg', '20-D SSG', 3, 50 FROM attribute_types WHERE name = 'foam_type_backrest'
UNION ALL
SELECT id, 'candy_c', 'Candy C', 4, 200 FROM attribute_types WHERE name = 'foam_type_backrest';

-- Fabric cladding plan
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, 'single_colour', 'Single Colour', 1, 0 FROM attribute_types WHERE name = 'fabric_cladding_plan'
UNION ALL
SELECT id, 'dual_colour', 'Dual Colour', 2, 150 FROM attribute_types WHERE name = 'fabric_cladding_plan'
UNION ALL
SELECT id, 'tri_colour', 'Tri Colour', 3, 300 FROM attribute_types WHERE name = 'fabric_cladding_plan';

-- Fabric code
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, 'vendor1_collection', 'Vendor1-Collection-Name-Colour-Code', 1, 0 FROM attribute_types WHERE name = 'fabric_code'
UNION ALL
SELECT id, 'vendor2_collection', 'Vendor2-Collection-Name-Colour-Code', 2, 100 FROM attribute_types WHERE name = 'fabric_code'
UNION ALL
SELECT id, 'vendor3_collection', 'Vendor3-Collection-Name-Colour-Code', 3, 200 FROM attribute_types WHERE name = 'fabric_code';

-- Legs
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, 'wood_leg_2', 'Wood Leg (H-2")', 1, 100 FROM attribute_types WHERE name = 'legs'
UNION ALL
SELECT id, 'nylon_bush_2', 'Nylon Bush (H-2")', 2, 0 FROM attribute_types WHERE name = 'legs';

-- Accessories
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) 
SELECT id, 'usb', 'USB', 1, 150 FROM attribute_types WHERE name = 'sofa_accessories';

-- Create SOFA BED models
INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Cory (R)', 'cory-r', 'Versatile sofa bed with reclining feature', 2499.00, true),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Stefan (R)', 'stefan-r', 'Modern reclining sofa bed with premium comfort', 2699.00, true),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Felix (R)', 'felix-r', 'Contemporary reclining sofa bed with sleek design', 2599.00, false),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Beckett', 'beckett', 'Classic sofa bed with timeless appeal', 2199.00, false),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Riva', 'riva', 'Elegant sofa bed with sophisticated styling', 2399.00, true),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Anke', 'anke', 'Scandinavian-inspired minimalist sofa bed', 2299.00, false),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Indiana', 'indiana', 'Rustic sofa bed with vintage charm', 2149.00, false),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Dino', 'dino', 'Playful and comfortable family sofa bed', 1999.00, false),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Avebury', 'avebury', 'Traditional English-style sofa bed', 2799.00, true),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Malmo', 'malmo', 'Nordic design sofa bed with clean lines', 2549.00, false),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Amore', 'amore', 'Romantic Italian-inspired sofa bed', 2899.00, true),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Albatross', 'albatross', 'Spacious sofa bed with extra comfort', 2649.00, false),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Dinny', 'dinny', 'Compact and efficient sofa bed solution', 1899.00, false),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Vinci', 'vinci', 'Artistic design sofa bed with unique features', 2999.00, true),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Zaxxy', 'zaxxy', 'Modern geometric design sofa bed', 2749.00, false),
((SELECT id FROM categories WHERE slug = 'sofa-bed'), 'Itasca', 'itasca', 'Nature-inspired comfortable sofa bed', 2349.00, false);