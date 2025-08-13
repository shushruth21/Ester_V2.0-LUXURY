-- Part 1: Create attribute types for Arm Chair customization
INSERT INTO public.attribute_types (name, display_name, input_type, is_required, sort_order) VALUES
('arm_chair_model', 'Model', 'select', true, 1),
('arm_chair_num_seats', 'Number of Seats', 'select', true, 2),
('arm_chair_seat_depth', 'Seat Depth', 'select', true, 3),
('arm_chair_seat_height', 'Seat Height', 'select', true, 4),
('arm_chair_overall_length', 'Overall Length', 'select', true, 5),
('arm_chair_overall_width', 'Overall Width', 'select', true, 6),
('arm_chair_overall_height', 'Overall Height', 'select', true, 7),
('arm_chair_wood_type', 'Wood Type', 'select', true, 8),
('arm_chair_foam_type_seats', 'Foam Type (Seats)', 'select', true, 9),
('arm_chair_foam_type_backrest', 'Foam Type (Backrest)', 'select', true, 10),
('arm_chair_fabric_cladding_plan', 'Fabric Cladding Plan', 'select', true, 11),
('arm_chair_fabric_code', 'Fabric Code', 'select', true, 12),
('arm_chair_indicative_fabric_color', 'Fabric Color', 'color', true, 13),
('arm_chair_legs', 'Leg Style', 'select', true, 14),
('arm_chair_stitching_type', 'Stitching Type', 'select', true, 15);

-- Part 2: Add attribute values for Arm Chair customization
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier, hex_color) VALUES
-- Model options
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_model'), 'arm_chair_1', 'Arm Chair 1', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_model'), 'arm_chair_2', 'Arm Chair 2', 2, 200, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_model'), 'arm_chair_3', 'Arm Chair 3', 3, 400, NULL),

-- Number of seats
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_num_seats'), '1_seat', '1 (One) seat', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_num_seats'), '2_seats', '2 (Two) seats', 2, 500, NULL),

-- Seat depth
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_seat_depth'), '22_inches', '22" (Twenty-two inches)', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_seat_depth'), '24_inches', '24" (Twenty-four inches)', 2, 100, NULL),

-- Seat height
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_seat_height'), '16_inches', '16" (Sixteen inches)', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_seat_height'), '18_inches', '18" (Eighteen inches)', 2, 50, NULL),

-- Overall length
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_overall_length'), '72_inches', '72" (Seventy-two inches)', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_overall_length'), '78_inches', '78" (Seventy-eight inches)', 2, 150, NULL),

-- Overall width
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_overall_width'), '30_inches', '30" (Thirty inches)', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_overall_width'), '36_inches', '36" (Thirty-six inches)', 2, 100, NULL),

-- Overall height
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_overall_height'), '30_inches', '30" (Thirty inches)', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_overall_height'), '32_inches', '32" (Thirty-two inches)', 2, 75, NULL),

-- Wood type
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_wood_type'), 'teak', 'Teak', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_wood_type'), 'oak', 'Oak', 2, 300, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_wood_type'), 'mahogany', 'Mahogany', 3, 500, NULL),

-- Foam type seats
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_foam_type_seats'), '32d_p', '32-D P', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_foam_type_seats'), '40d_ur', '40-D U/R', 2, 150, NULL),

-- Foam type backrest
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_foam_type_backrest'), '20d_ssg', '20-D SSG', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_foam_type_backrest'), '32d_p', '32-D P', 2, 100, NULL),

-- Fabric cladding plan
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_fabric_cladding_plan'), 'single_colour', 'Single Colour', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_fabric_cladding_plan'), 'dual_colour', 'Dual Colour', 2, 200, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_fabric_cladding_plan'), 'tri_colour', 'Tri Colour', 3, 400, NULL),

-- Fabric code
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_fabric_code'), 'vendor_a_blue', 'VendorA-CollectionX-Blue', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_fabric_code'), 'vendor_b_green', 'VendorB-CollectionY-Green', 2, 100, NULL),

-- Fabric color
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_indicative_fabric_color'), 'red', 'Red', 1, 0, '#FF0000'),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_indicative_fabric_color'), 'blue', 'Blue', 2, 0, '#0000FF'),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_indicative_fabric_color'), 'green', 'Green', 3, 0, '#00FF00'),

-- Legs
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_legs'), 'stainless_steel', 'Stainless Steel', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_legs'), 'wooden_tapered', 'Wooden Tapered', 2, 150, NULL),

-- Stitching type
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_stitching_type'), 'single_stitch', 'Single Stitch', 1, 0, NULL),
((SELECT id FROM public.attribute_types WHERE name = 'arm_chair_stitching_type'), 'double_stitch', 'Double Stitch', 2, 100, NULL);

-- Part 3: Link attributes to Arm Chair models
INSERT INTO public.model_attributes (model_id, attribute_type_id, is_required, default_value_id)
SELECT 
    fm.id,
    at.id,
    at.is_required,
    (SELECT av.id FROM public.attribute_values av WHERE av.attribute_type_id = at.id ORDER BY av.sort_order LIMIT 1)
FROM 
    public.furniture_models fm
JOIN 
    public.categories c ON fm.category_id = c.id
CROSS JOIN 
    public.attribute_types at
WHERE 
    c.name = 'Arm Chair'
    AND at.name IN (
        'arm_chair_model',
        'arm_chair_num_seats', 
        'arm_chair_seat_depth',
        'arm_chair_seat_height',
        'arm_chair_overall_length',
        'arm_chair_overall_width',
        'arm_chair_overall_height',
        'arm_chair_wood_type',
        'arm_chair_foam_type_seats',
        'arm_chair_foam_type_backrest',
        'arm_chair_fabric_cladding_plan',
        'arm_chair_fabric_code',
        'arm_chair_indicative_fabric_color',
        'arm_chair_legs',
        'arm_chair_stitching_type'
    );