-- Configure all BED models with comprehensive customization attributes

-- First, create bed-specific attribute types and values
DO $$
DECLARE
    bed_category_id UUID;
    model_record RECORD;
    attr_type_id UUID;
    attr_value_id UUID;
    bed_models TEXT[] := ARRAY[
        'Aveo', 'Diamante', 'Bretton', 'Noale', 'Quaddy', 'Ilara', 'Eudald', 'Paxa', 'Matita', 'Labyrin', 
        'Ovidio', 'Convio', 'Savoy', 'Raphia', 'Manao', 'Nowra', 'Camfo', 'Marezzato', 'Daphne', 'Rochester', 
        'Ethiya', 'Fiaba', 'Campanula', 'Ortensia', 'Gelso', 'Oleander', 'Dreztta', 'Jipsta', 'Bubble', 'Chooseyy', 
        'Bohemia', 'Cazewell', 'Alchemist', 'Tempah', 'Cap"&"tane', 'Lennox', 'Vertico', 'Knightowl', 'Eyedea', 'Lismore'
    ];
    dimensions TEXT[] := ARRAY['Single-36"/78"', 'Double XL-48"/78"', 'Queen-66"/78"', 'King-72"/78"', 'King XL-78"/78"'];
    storage_options TEXT[] := ARRAY['With Storage', 'Without Storage'];
    storage_types TEXT[] := ARRAY['Side Draws', 'Box Storage'];
    headboard_designs TEXT[] := ARRAY['Type 1', 'Type 2'];
    leg_options TEXT[] := ARRAY['Type 1-.2"', 'Type 2..4'];
    leg_features TEXT[] := ARRAY['reading light', 'mobile charging'];
    item TEXT;
    counter INTEGER;
BEGIN
    -- Get BED category ID
    SELECT id INTO bed_category_id 
    FROM categories 
    WHERE LOWER(name) LIKE '%bed%'
    LIMIT 1;

    IF bed_category_id IS NULL THEN
        RAISE EXCEPTION 'BED category not found';
    END IF;

    -- Create/Update bed dimensions attribute type
    INSERT INTO attribute_types (name, display_name, description, input_type, sort_order)
    VALUES ('bed_dimensions', 'Dimensions', 'Bed size dimensions', 'select', 1)
    ON CONFLICT (name) DO UPDATE SET 
        display_name = EXCLUDED.display_name,
        description = EXCLUDED.description
    RETURNING id INTO attr_type_id;

    -- Add dimension values
    counter := 0;
    FOREACH item IN ARRAY dimensions
    LOOP
        counter := counter + 10;
        INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier)
        VALUES (attr_type_id, item, item, counter, 0)
        ON CONFLICT (attribute_type_id, value) DO NOTHING;
    END LOOP;

    -- Create/Update storage option attribute type
    INSERT INTO attribute_types (name, display_name, description, input_type, sort_order)
    VALUES ('storage_option', 'Storage Option', 'Whether bed includes storage', 'select', 2)
    ON CONFLICT (name) DO UPDATE SET 
        display_name = EXCLUDED.display_name,
        description = EXCLUDED.description
    RETURNING id INTO attr_type_id;

    -- Add storage option values
    counter := 0;
    FOREACH item IN ARRAY storage_options
    LOOP
        counter := counter + 10;
        INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier)
        VALUES (attr_type_id, item, item, counter, CASE WHEN item = 'With Storage' THEN 200.00 ELSE 0 END)
        ON CONFLICT (attribute_type_id, value) DO NOTHING;
    END LOOP;

    -- Create/Update storage type attribute type
    INSERT INTO attribute_types (name, display_name, description, input_type, sort_order)
    VALUES ('storage_type', 'Storage Type', 'Type of storage mechanism', 'select', 3)
    ON CONFLICT (name) DO UPDATE SET 
        display_name = EXCLUDED.display_name,
        description = EXCLUDED.description
    RETURNING id INTO attr_type_id;

    -- Add storage type values
    counter := 0;
    FOREACH item IN ARRAY storage_types
    LOOP
        counter := counter + 10;
        INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier)
        VALUES (attr_type_id, item, item, counter, CASE WHEN item = 'Box Storage' THEN 100.00 ELSE 50.00 END)
        ON CONFLICT (attribute_type_id, value) DO NOTHING;
    END LOOP;

    -- Create/Update headboard design attribute type
    INSERT INTO attribute_types (name, display_name, description, input_type, sort_order)
    VALUES ('headboard_design', 'Headboard Design', 'Style of headboard design', 'select', 4)
    ON CONFLICT (name) DO UPDATE SET 
        display_name = EXCLUDED.display_name,
        description = EXCLUDED.description
    RETURNING id INTO attr_type_id;

    -- Add headboard design values
    counter := 0;
    FOREACH item IN ARRAY headboard_designs
    LOOP
        counter := counter + 10;
        INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier)
        VALUES (attr_type_id, item, item, counter, CASE WHEN item = 'Type 2' THEN 75.00 ELSE 0 END)
        ON CONFLICT (attribute_type_id, value) DO NOTHING;
    END LOOP;

    -- Create/Update leg options attribute type
    INSERT INTO attribute_types (name, display_name, description, input_type, sort_order)
    VALUES ('leg_options', 'Leg Options', 'Type of bed legs', 'select', 5)
    ON CONFLICT (name) DO UPDATE SET 
        display_name = EXCLUDED.display_name,
        description = EXCLUDED.description
    RETURNING id INTO attr_type_id;

    -- Add leg option values
    counter := 0;
    FOREACH item IN ARRAY leg_options
    LOOP
        counter := counter + 10;
        INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier)
        VALUES (attr_type_id, item, item, counter, CASE WHEN item = 'Type 2..4' THEN 25.00 ELSE 0 END)
        ON CONFLICT (attribute_type_id, value) DO NOTHING;
    END LOOP;

    -- Create/Update leg features attribute type
    INSERT INTO attribute_types (name, display_name, description, input_type, sort_order)
    VALUES ('leg_features', 'Leg Features', 'Additional features for bed legs', 'select', 6)
    ON CONFLICT (name) DO UPDATE SET 
        display_name = EXCLUDED.display_name,
        description = EXCLUDED.description
    RETURNING id INTO attr_type_id;

    -- Add leg feature values
    counter := 0;
    FOREACH item IN ARRAY leg_features
    LOOP
        counter := counter + 10;
        INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier)
        VALUES (attr_type_id, item, item, counter, CASE WHEN item = 'mobile charging' THEN 150.00 ELSE 100.00 END)
        ON CONFLICT (attribute_type_id, value) DO NOTHING;
    END LOOP;

    -- Add bed model values to the existing model attribute type
    SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'model';
    IF attr_type_id IS NOT NULL THEN
        counter := 0;
        FOREACH item IN ARRAY bed_models
        LOOP
            counter := counter + 10;
            INSERT INTO attribute_values (attribute_type_id, value, display_name, sort_order, price_modifier)
            VALUES (attr_type_id, item, item, counter, 0)
            ON CONFLICT (attribute_type_id, value) DO NOTHING;
        END LOOP;
    END IF;

    -- Now configure each BED model with all attributes
    FOR model_record IN 
        SELECT id, name FROM furniture_models 
        WHERE category_id = bed_category_id
    LOOP
        RAISE NOTICE 'Configuring bed model: %', model_record.name;

        -- Model attribute
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'model';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = model_record.name
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Bed dimensions
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'bed_dimensions';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Queen-66"/78"'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Storage option
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'storage_option';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Without Storage'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Storage type
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'storage_type';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, false, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Side Draws'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Headboard design
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'headboard_design';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Type 1'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Leg options
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'leg_options';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Type 1-.2"'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Leg features
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'leg_features';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, false, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'reading light'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Add common attributes that apply to beds too
        
        -- Color
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'color';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Brown'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Material
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'material';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Wood'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Finish
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'finish';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Matte'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Style
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'style';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Modern'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

    END LOOP;

    RAISE NOTICE 'Successfully configured all BED models with comprehensive attributes';
END $$;