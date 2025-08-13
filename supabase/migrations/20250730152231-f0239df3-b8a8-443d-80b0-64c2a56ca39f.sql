-- Create missing attribute types
INSERT INTO attribute_types (name, display_name, input_type, is_required, sort_order) VALUES
('num_seats', 'Number of Seats', 'select', true, 1),
('need_lounger', 'Do you need lounger?', 'radio', false, 2),
('lounger_position', 'Lounger Position', 'select', false, 3),
('lounger_length', 'Lounger Length', 'select', false, 4),
('seat_width', 'Seat Width', 'select', false, 5),
('armrest_type', 'Arm Rest Type', 'select', false, 6),
('armrest_height', 'Arm Rest Height', 'select', false, 7),
('need_console', 'Do you need console/s?', 'radio', false, 8),
('console_count', 'How many consoles?', 'select', false, 9),
('console_type', 'Console Type', 'select', false, 10),
('need_corner_unit', 'Do you need Corner unit?', 'radio', false, 11),
('seat_depth', 'Seat Depth', 'select', false, 12),
('seat_height', 'Seat Height', 'select', false, 13),
('overall_length', 'Overall Length', 'select', false, 14),
('overall_width', 'Overall Width', 'select', false, 15),
('overall_height', 'Overall Height', 'select', false, 16),
('wood_type', 'Wood Type', 'select', false, 17),
('foam_type_seats', 'Foam Type - Seats', 'select', false, 18),
('foam_type_backrest', 'Foam Type - Back Rest', 'select', false, 19),
('fabric_cladding_plan', 'Fabric Cladding Plan', 'select', false, 20),
('fabric_code', 'Fabric Code', 'select', false, 21),
('indicative_fabric_colour', 'Indicative Fabric Colour', 'color', false, 22),
('legs', 'Legs', 'select', false, 23),
('accessories', 'Accessories', 'select', false, 24),
('stitching_type', 'Stitching Type', 'select', false, 25),
('dimensions', 'Dimensions', 'select', true, 1),
('storage_option', 'Storage Option', 'radio', false, 2),
('storage_type', 'Storage Type', 'select', false, 3),
('headboard_design', 'Headboard Design', 'select', false, 4),
('leg_options', 'Leg Options', 'select', false, 5),
('recliner', 'Recliner', 'radio', false, 6),
('seater_type', 'Seater Type', 'select', false, 7),
('lounger_storage_option', 'Lounger Storage Option', 'select', false, 8)
ON CONFLICT (name) DO NOTHING;

-- Create comprehensive attribute values (Part 1)
INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier) VALUES
-- Number of Seats
((SELECT id FROM attribute_types WHERE name = 'num_seats'), '1', '1 Seat', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'num_seats'), '2', '2 Seats', 2, 500),
((SELECT id FROM attribute_types WHERE name = 'num_seats'), '3', '3 Seats', 3, 1000),
((SELECT id FROM attribute_types WHERE name = 'num_seats'), '4', '4 Seats', 4, 1500),
((SELECT id FROM attribute_types WHERE name = 'num_seats'), '5+', '5+ Seats', 5, 2000),

-- Do you need lounger?
((SELECT id FROM attribute_types WHERE name = 'need_lounger'), 'yes', 'Yes', 1, 800),
((SELECT id FROM attribute_types WHERE name = 'need_lounger'), 'no', 'No', 2, 0),

-- Lounger Position
((SELECT id FROM attribute_types WHERE name = 'lounger_position'), 'left', 'Left', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'lounger_position'), 'right', 'Right', 2, 0),

-- Lounger Length
((SELECT id FROM attribute_types WHERE name = 'lounger_length'), 'short', 'Short (150cm)', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'lounger_length'), 'medium', 'Medium (170cm)', 2, 200),
((SELECT id FROM attribute_types WHERE name = 'lounger_length'), 'long', 'Long (190cm)', 3, 400),

-- Seat Width
((SELECT id FROM attribute_types WHERE name = 'seat_width'), '45cm', '45cm', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'seat_width'), '50cm', '50cm', 2, 100),
((SELECT id FROM attribute_types WHERE name = 'seat_width'), '55cm', '55cm', 3, 200),
((SELECT id FROM attribute_types WHERE name = 'seat_width'), '60cm', '60cm', 4, 300),

-- Arm Rest Type
((SELECT id FROM attribute_types WHERE name = 'armrest_type'), 'standard', 'Standard', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'armrest_type'), 'wide', 'Wide', 2, 200),
((SELECT id FROM attribute_types WHERE name = 'armrest_type'), 'cushioned', 'Cushioned', 3, 300),
((SELECT id FROM attribute_types WHERE name = 'armrest_type'), 'wooden', 'Wooden', 4, 150),

-- Arm Rest Height
((SELECT id FROM attribute_types WHERE name = 'armrest_height'), 'low', 'Low (20cm)', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'armrest_height'), 'medium', 'Medium (25cm)', 2, 50),
((SELECT id FROM attribute_types WHERE name = 'armrest_height'), 'high', 'High (30cm)', 3, 100),

-- Do you need console/s?
((SELECT id FROM attribute_types WHERE name = 'need_console'), 'yes', 'Yes', 1, 500),
((SELECT id FROM attribute_types WHERE name = 'need_console'), 'no', 'No', 2, 0),

-- How many consoles?
((SELECT id FROM attribute_types WHERE name = 'console_count'), '1', '1 Console', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'console_count'), '2', '2 Consoles', 2, 500),
((SELECT id FROM attribute_types WHERE name = 'console_count'), '3', '3 Consoles', 3, 1000),

-- Console Type
((SELECT id FROM attribute_types WHERE name = 'console_type'), 'basic', 'Basic', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'console_type'), 'storage', 'With Storage', 2, 300),
((SELECT id FROM attribute_types WHERE name = 'console_type'), 'cupholders', 'With Cup Holders', 3, 200),
((SELECT id FROM attribute_types WHERE name = 'console_type'), 'premium', 'Premium (Storage + Cup Holders)', 4, 500),

-- Do you need Corner unit?
((SELECT id FROM attribute_types WHERE name = 'need_corner_unit'), 'yes', 'Yes', 1, 1000),
((SELECT id FROM attribute_types WHERE name = 'need_corner_unit'), 'no', 'No', 2, 0),

-- Seat Depth
((SELECT id FROM attribute_types WHERE name = 'seat_depth'), '50cm', '50cm', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'seat_depth'), '55cm', '55cm', 2, 100),
((SELECT id FROM attribute_types WHERE name = 'seat_depth'), '60cm', '60cm', 3, 200),
((SELECT id FROM attribute_types WHERE name = 'seat_depth'), '65cm', '65cm', 4, 300),

-- Seat Height
((SELECT id FROM attribute_types WHERE name = 'seat_height'), '40cm', '40cm', 1, 0),
((SELECT id FROM attribute_types WHERE name = 'seat_height'), '45cm', '45cm', 2, 50),
((SELECT id FROM attribute_types WHERE name = 'seat_height'), '50cm', '50cm', 3, 100)
ON CONFLICT (attribute_type_id, value) DO NOTHING;