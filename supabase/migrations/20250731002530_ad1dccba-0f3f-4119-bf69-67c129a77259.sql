-- Add BED models and bed-specific attributes
DO $$
DECLARE
    bed_category_id UUID;
    model_rec RECORD;
    attr_type_id UUID;
    attr_value_id UUID;
BEGIN
    -- Get the BED category ID
    SELECT id INTO bed_category_id FROM categories WHERE name = 'BED';
    
    -- Clear existing models in BED category
    DELETE FROM furniture_models WHERE category_id = bed_category_id;
    
    -- Insert new BED models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (bed_category_id, 'Aveo', 'aveo', 'Modern bed with sleek design', 3200.00, false),
    (bed_category_id, 'Diamante', 'diamante', 'Diamond-inspired luxury bed', 4500.00, true),
    (bed_category_id, 'Bretton', 'bretton', 'British-inspired classic bed', 3600.00, false),
    (bed_category_id, 'Noale', 'noale', 'Italian countryside bed design', 3400.00, false),
    (bed_category_id, 'Quaddy', 'quaddy', 'Quadratic modern bed frame', 3300.00, false),
    (bed_category_id, 'Ilara', 'ilara', 'Elegant bed with refined curves', 3800.00, false),
    (bed_category_id, 'Eudald', 'eudald', 'European-style luxury bed', 4200.00, false),
    (bed_category_id, 'Paxa', 'paxa', 'Peaceful bed for restful sleep', 3500.00, false),
    (bed_category_id, 'Matita', 'matita', 'Pencil-thin minimalist bed', 3100.00, false),
    (bed_category_id, 'Labyrin', 'labyrin', 'Maze-inspired artistic bed', 3700.00, false),
    (bed_category_id, 'Ovidio', 'ovidio', 'Poetic bed with flowing lines', 3900.00, false),
    (bed_category_id, 'Convio', 'convio', 'Conversational bed design', 3600.00, false),
    (bed_category_id, 'Savoy', 'savoy', 'Royal-inspired luxury bed', 4800.00, true),
    (bed_category_id, 'Raphia', 'raphia', 'Natural fiber-inspired bed', 3400.00, false),
    (bed_category_id, 'Manao', 'manao', 'Mango wood-inspired bed', 3300.00, false),
    (bed_category_id, 'Nowra', 'nowra', 'Australian-inspired bed design', 3500.00, false),
    (bed_category_id, 'Camfo', 'camfo', 'Camouflage-pattern bed', 3200.00, false),
    (bed_category_id, 'Marezzato', 'marezzato', 'Marbled luxury bed design', 4100.00, false),
    (bed_category_id, 'Daphne', 'daphne', 'Laurel-inspired natural bed', 3600.00, false),
    (bed_category_id, 'Rochester', 'rochester', 'English manor bed design', 4000.00, false),
    (bed_category_id, 'Ethiya', 'ethiya', 'Ethical design sustainable bed', 3700.00, false),
    (bed_category_id, 'Fiaba', 'fiaba', 'Fairy tale-inspired bed', 3900.00, false),
    (bed_category_id, 'Campanula', 'campanula', 'Bell flower-inspired bed', 3500.00, false),
    (bed_category_id, 'Ortensia', 'ortensia', 'Hydrangea-inspired bed design', 3800.00, false),
    (bed_category_id, 'Gelso', 'gelso', 'Mulberry wood bed design', 3400.00, false),
    (bed_category_id, 'Oleander', 'oleander', 'Mediterranean-inspired bed', 3600.00, false),
    (bed_category_id, 'Dreztta', 'dreztta', 'Dressed-up luxury bed', 4300.00, false),
    (bed_category_id, 'Jipsta', 'jipsta', 'Hip modern bed design', 3300.00, false),
    (bed_category_id, 'Bubble', 'bubble', 'Soft rounded bed design', 3500.00, false),
    (bed_category_id, 'Chooseyy', 'chooseyy', 'Customizable modular bed', 3700.00, false),
    (bed_category_id, 'Bohemia', 'bohemia', 'Bohemian-style artistic bed', 3800.00, false),
    (bed_category_id, 'Cazewell', 'cazewell', 'Well-crafted traditional bed', 3900.00, false),
    (bed_category_id, 'Alchemist', 'alchemist', 'Transformative bed design', 4600.00, true),
    (bed_category_id, 'Tempah', 'tempah', 'Temple-inspired sacred bed', 4100.00, false),
    (bed_category_id, 'Captane', 'captane', 'Captain-inspired nautical bed', 3600.00, false),
    (bed_category_id, 'Lennox', 'lennox', 'Scottish-inspired highland bed', 3800.00, false),
    (bed_category_id, 'Vertico', 'vertico', 'Vertical-lined modern bed', 3400.00, false),
    (bed_category_id, 'Knightowl', 'knightowl', 'Night guardian bed design', 3700.00, false),
    (bed_category_id, 'Eyedea', 'eyedea', 'Visionary innovative bed', 4200.00, false),
    (bed_category_id, 'Lismore', 'lismore', 'Irish castle-inspired bed', 4000.00, false);

    -- Create bed-specific attribute types
    INSERT INTO attribute_types (name, display_name, description, input_type, sort_order) VALUES
    ('bed_dimensions', 'Dimensions', 'Bed size dimensions', 'select', 1),
    ('storage_option', 'Storage option', 'Whether bed has storage', 'select', 2),
    ('storage_type', 'Storage type', 'Type of storage mechanism', 'select', 3),
    ('headboard_design', 'Headboard Design', 'Style of headboard', 'select', 4),
    ('leg_options', 'Leg options', 'Type of bed legs', 'select', 5),
    ('bed_accessories', 'Bed accessories', 'Additional bed features', 'select', 6);

    -- Insert attribute values for bed_dimensions
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'bed_dimensions';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'single_36_78', 'Single-36"/78"', 1),
    (attr_type_id, 'double_xl_48_78', 'Double XL-48"/78"', 2),
    (attr_type_id, 'queen_66_78', 'Queen-66"/78"', 3),
    (attr_type_id, 'king_72_78', 'King-72"/78"', 4),
    (attr_type_id, 'king_xl_78_78', 'King XL-78"/78"', 5);

    -- Insert attribute values for storage_option
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'storage_option';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'with_storage', 'With Storage', 1),
    (attr_type_id, 'without_storage', 'Without Storage', 2);

    -- Insert attribute values for storage_type
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'storage_type';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'side_drawers', 'Side Draws', 1),
    (attr_type_id, 'box_storage', 'Box Storage', 2);

    -- Insert attribute values for headboard_design
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'headboard_design';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'type_1', 'Type 1', 1),
    (attr_type_id, 'type_2', 'Type 2', 2);

    -- Insert attribute values for leg_options
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'leg_options';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'type_1_2', 'Type 1-.2"', 1),
    (attr_type_id, 'type_2_4', 'Type 2..4', 2);

    -- Insert attribute values for bed_accessories
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'bed_accessories';
    INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order) VALUES
    (attr_type_id, 'reading_light', 'reading light', 1),
    (attr_type_id, 'mobile_charging', 'mobile charging', 2);

    -- Link all bed attribute types to all BED models
    FOR model_rec IN 
        SELECT id FROM furniture_models WHERE category_id = bed_category_id
    LOOP
        -- Link all bed attribute types to this model
        FOR attr_type_id IN 
            SELECT id FROM attribute_types WHERE name IN (
                'bed_dimensions', 'storage_option', 'storage_type', 'headboard_design', 
                'leg_options', 'bed_accessories'
            )
        LOOP
            -- Get the first attribute value as default
            SELECT id INTO attr_value_id 
            FROM attribute_values 
            WHERE attribute_type_id = attr_type_id 
            ORDER BY sort_order 
            LIMIT 1;

            -- Insert model attribute with default value
            INSERT INTO model_attributes (model_id, attribute_type_id, default_value_id, is_required)
            VALUES (model_rec.id, attr_type_id, attr_value_id, true);
        END LOOP;
    END LOOP;
    
END $$;