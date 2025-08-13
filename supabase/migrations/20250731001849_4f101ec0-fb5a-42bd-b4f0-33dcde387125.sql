-- Add attributes for SOFA LUXURY models
DO $$
DECLARE
    luxury_category_id UUID;
    model_rec RECORD;
    attr_type_id UUID;
    attr_value_id UUID;
BEGIN
    -- Get the SOFA LUXURY category ID
    SELECT id INTO luxury_category_id FROM categories WHERE name = 'SOFA LUXURY';
    
    -- Create attribute types for SOFA LUXURY
    INSERT INTO attribute_types (name, display_name, description, input_type, sort_order) VALUES
    ('number_of_seats', 'No. of seat/s', 'Number of seats configuration', 'select', 1),
    ('need_lounger', 'Do you need lounger?', 'Whether lounger is needed', 'select', 2),
    ('lounger_position', 'Lounger position', 'Position of the lounger', 'select', 3),
    ('lounger_length', 'Lounger Length', 'Length of the lounger', 'select', 4),
    ('seat_width', 'Seat width', 'Width of individual seats', 'select', 5),
    ('arm_rest_type', 'Arm rest type', 'Type of arm rest', 'select', 6),
    ('arm_rest_height', 'Arm rest height', 'Height of arm rest', 'input', 7),
    ('need_consoles', 'Do you need console/s?', 'Whether consoles are needed', 'select', 8),
    ('console_count', 'How many consoles?', 'Number of consoles', 'select', 9),
    ('console_type', 'Console type', 'Type of console', 'select', 10),
    ('need_corner_unit', 'Do you need Corner unit?', 'Whether corner unit is needed', 'select', 11),
    ('seat_depth', 'Seat depth', 'Depth of the seat', 'select', 12),
    ('seat_height', 'Seat Height', 'Height of the seat', 'select', 13),
    ('overall_length', 'Overall length', 'Total length of sofa', 'input', 14),
    ('overall_width', 'Overall width', 'Total width of sofa', 'input', 15),
    ('overall_height', 'Overall height', 'Total height of sofa', 'input', 16),
    ('wood_type', 'Wood type', 'Type of wood used', 'select', 17),
    ('foam_type_seats', 'Foam Type-Seats', 'Foam type for seats', 'select', 18),
    ('foam_type_back_rest', 'Foam Type-Back rest', 'Foam type for back rest', 'select', 19),
    ('fabric_cladding_plan', 'Fabric cladding plan', 'Fabric color scheme', 'select', 20),
    ('fabric_code', 'Fabric code', 'Fabric vendor and collection code', 'select', 21),
    ('indicative_fabric_colour', 'Indicative Fabric Colour', 'Fabric color indication', 'input', 22),
    ('legs', 'Legs', 'Type of legs', 'select', 23),
    ('accessories', 'Accessories', 'Additional accessories', 'select', 24),
    ('stitching_type', 'Stitching type', 'Type of stitching', 'select', 25);

    -- Insert attribute values for number_of_seats
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'number_of_seats';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, '1_seat', '1 (One) seat', 1),
    (attr_type_id, '2_seats', '2 (Two) seats', 2),
    (attr_type_id, '3_seats', '3 (Three) seats', 3),
    (attr_type_id, '2_3_c_seats', '2+3+C seats', 4);

    -- Insert attribute values for need_lounger
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'need_lounger';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'yes', 'Yes', 1),
    (attr_type_id, 'no', 'No', 2);

    -- Insert attribute values for lounger_position
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'lounger_position';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'right_hand_side', 'Right Hand Side (picture)', 1),
    (attr_type_id, 'left_hand_side', 'Left Hand Side (picture)', 2);

    -- Insert attribute values for lounger_length
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'lounger_length';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, '5_5_feet', '5.5 (Five and a half) feet', 1),
    (attr_type_id, '6_feet', '6 (Six) feet', 2),
    (attr_type_id, '6_5_feet', '6.5 (Six and a half) feet', 3),
    (attr_type_id, '7_feet', '7 (Seven) feet', 4);

    -- Insert attribute values for seat_width
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'seat_width';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, '22_inches', '22" (Tweentytwo inches)', 1),
    (attr_type_id, '24_inches', '24" (Tweentyfour inches)', 2),
    (attr_type_id, '26_inches', '26" (Tweentysix inches)', 3),
    (attr_type_id, '28_inches', '28" (Tweentyeight inches)', 4);

    -- Insert attribute values for arm_rest_type
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'arm_rest_type';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'default', 'Default', 1),
    (attr_type_id, 'ocean', 'Ocean', 2),
    (attr_type_id, 'smug', 'Smug', 3),
    (attr_type_id, 'box', 'Box', 4);

    -- Insert attribute values for need_consoles
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'need_consoles';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'yes', 'Yes', 1),
    (attr_type_id, 'no', 'No', 2);

    -- Insert attribute values for console_count
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'console_count';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, '1_one', '1 (One)', 1),
    (attr_type_id, '2_two', '2 (Two)', 2);

    -- Insert attribute values for console_type
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'console_type';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, '6_inches', '6" (Six inches)', 1),
    (attr_type_id, '10_inches', '10" (Ten inches)', 2);

    -- Insert attribute values for need_corner_unit
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'need_corner_unit';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'yes', 'Yes', 1),
    (attr_type_id, 'no', 'No', 2);

    -- Insert attribute values for seat_depth
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'seat_depth';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, '22_inches', '22" (Tweentytwo inches)', 1),
    (attr_type_id, '24_inches', '24" (Tweentyfour inches)', 2);

    -- Insert attribute values for seat_height
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'seat_height';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, '16_inches', '16" (Sixteen inches)', 1),
    (attr_type_id, '18_inches', '18" (Eighteen inches)', 2);

    -- Insert attribute values for wood_type
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'wood_type';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'neem', 'Neem', 1),
    (attr_type_id, 'mahaghani', 'Mahaghani', 2),
    (attr_type_id, 'pine', 'Pine', 3);

    -- Insert attribute values for foam_type_seats
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'foam_type_seats';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, '32_d_p', '32-D P', 1),
    (attr_type_id, '40_d_ur', '40-D U/R', 2),
    (attr_type_id, '20_d_ssg', '20-D SSG', 3),
    (attr_type_id, 'candy_c', 'Candy C', 4),
    (attr_type_id, 'memory', 'Memory', 5),
    (attr_type_id, 'latex', 'Latex', 6);

    -- Insert attribute values for foam_type_back_rest
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'foam_type_back_rest';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, '32_d_p', '32-D P', 1),
    (attr_type_id, '40_d_ur', '40-D U/R', 2),
    (attr_type_id, '20_d_ssg', '20-D SSG', 3),
    (attr_type_id, 'candy_c', 'Candy C', 4),
    (attr_type_id, 'memory', 'Memory', 5),
    (attr_type_id, 'latex', 'Latex', 6);

    -- Insert attribute values for fabric_cladding_plan
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'fabric_cladding_plan';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'single_colour', 'Single Colour', 1),
    (attr_type_id, 'dual_colour', 'Dual Colour', 2),
    (attr_type_id, 'tri_colour', 'Tri Colour', 3);

    -- Insert attribute values for fabric_code
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'fabric_code';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'vendor1_collection_colour', 'Vendor1-Collection-Name-Colour-Code', 1),
    (attr_type_id, 'vendor2_collection_colour', 'Vendor2-Collection-Name-Colour-Code', 2),
    (attr_type_id, 'vendor3_collection_colour', 'Vendor3-Collection-Name-Colour-Code', 3);

    -- Insert attribute values for legs
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'legs';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'stainless_steel', 'Stainles Steel', 1),
    (attr_type_id, 'golden', 'Golden', 2),
    (attr_type_id, 'mild_steel_black', 'Mild Steel-Black', 3),
    (attr_type_id, 'mild_steel_brown', 'Mild Steel-Brown', 4),
    (attr_type_id, 'wood_teak', 'Wood-Teak', 5),
    (attr_type_id, 'wood_walnut', 'Wood-Walnut', 6),
    (attr_type_id, 'wood_other', 'Wood-???', 7),
    (attr_type_id, 'l8', 'L8', 8),
    (attr_type_id, 'l9', 'L9', 9),
    (attr_type_id, 'l10', 'L10', 10);

    -- Insert attribute values for accessories
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'accessories';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'wireless_charging', 'Wireless Charging Unit', 1),
    (attr_type_id, 'usb', 'USB', 2),
    (attr_type_id, 'lighting', 'lighing...', 3),
    (attr_type_id, 'tray', 'Tray', 4),
    (attr_type_id, 'single_cup_holder', 'Single cup holder', 5),
    (attr_type_id, 'dual_cup_holder', 'dual cup holder', 6);

    -- Insert attribute values for stitching_type
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'stitching_type';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 's1', 'S1', 1),
    (attr_type_id, 's2', 'S2', 2),
    (attr_type_id, 's3', 'S3', 3);

    -- Link all attribute types to all SOFA LUXURY models
    FOR model_rec IN 
        SELECT id FROM furniture_models WHERE category_id = luxury_category_id
    LOOP
        -- Link all attribute types to this model
        FOR attr_type_id IN 
            SELECT id FROM attribute_types WHERE name IN (
                'number_of_seats', 'need_lounger', 'lounger_position', 'lounger_length', 'seat_width',
                'arm_rest_type', 'arm_rest_height', 'need_consoles', 'console_count', 'console_type',
                'need_corner_unit', 'seat_depth', 'seat_height', 'overall_length', 'overall_width',
                'overall_height', 'wood_type', 'foam_type_seats', 'foam_type_back_rest', 'fabric_cladding_plan',
                'fabric_code', 'indicative_fabric_colour', 'legs', 'accessories', 'stitching_type'
            )
        LOOP
            -- Get the first attribute value as default for select types
            SELECT id INTO attr_value_id 
            FROM attribute_values 
            WHERE attribute_type_id = attr_type_id 
            ORDER BY sort_order 
            LIMIT 1;

            -- Insert model attribute with default value for select types, null for input types
            INSERT INTO model_attributes (model_id, attribute_type_id, default_value_id, is_required)
            SELECT 
                model_rec.id, 
                attr_type_id, 
                CASE 
                    WHEN at.input_type = 'select' THEN attr_value_id 
                    ELSE NULL 
                END,
                true
            FROM attribute_types at 
            WHERE at.id = attr_type_id;
        END LOOP;
    END LOOP;
    
END $$;