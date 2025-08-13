-- Configure all HOME THEATER models with comprehensive customization attributes

-- First, let's get the HOME THEATER category ID and its models
DO $$
DECLARE
    home_theater_category_id UUID;
    model_record RECORD;
    attr_type_id UUID;
BEGIN
    -- Get HOME THEATER category ID
    SELECT id INTO home_theater_category_id 
    FROM categories 
    WHERE LOWER(name) LIKE '%home%theater%' OR LOWER(name) LIKE '%theater%' OR LOWER(name) LIKE '%home theatre%'
    LIMIT 1;

    IF home_theater_category_id IS NULL THEN
        RAISE EXCEPTION 'HOME THEATER category not found';
    END IF;

    -- Configure each HOME THEATER model with all attributes
    FOR model_record IN 
        SELECT id, name FROM furniture_models 
        WHERE category_id = home_theater_category_id
    LOOP
        RAISE NOTICE 'Configuring model: %', model_record.name;

        -- Model attribute (using existing attribute type)
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

        -- Number of seats
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'seat_count';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = '2 (Two) seats'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Seat width
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'seat_width';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = '24" (Twentyfour inches)'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Arm rest type
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'arm_rest_type';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Default'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Arm rest height
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'arm_rest_height';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required)
            VALUES (model_record.id, attr_type_id, false)
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Console need
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'console_need';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'No'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Console count
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'console_count';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, false, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = '1 (One)'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Console type
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'console_type';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, false, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = '6" (Six inches)'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Corner unit need
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'corner_unit_need';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'No'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Seat depth
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'seat_depth';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = '22" (Twentytwo inches)'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Seat height
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'seat_height';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = '16" (Sixteen inches)'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Overall length
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'overall_length';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required)
            VALUES (model_record.id, attr_type_id, false)
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Overall width
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'overall_width';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required)
            VALUES (model_record.id, attr_type_id, false)
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Overall height
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'overall_height';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required)
            VALUES (model_record.id, attr_type_id, false)
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Wood type
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'wood_type';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Neem'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Foam type seats
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'foam_type_seats';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = '32-D P'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Foam type back rest
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'foam_type_back_rest';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = '32-D P'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Fabric cladding plan
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'fabric_cladding_plan';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Single Colour'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Fabric code
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'fabric_code';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Vendor1-Collection-Name-Colour-Code'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Indicative fabric colour
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'indicative_fabric_colour';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required)
            VALUES (model_record.id, attr_type_id, false)
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Legs
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'legs';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'Stainles Steel'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Accessories
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'accessories';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, false, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'USB'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

        -- Stitching type
        SELECT id INTO attr_type_id FROM attribute_types WHERE name = 'stitching_type';
        IF attr_type_id IS NOT NULL THEN
            INSERT INTO model_attributes (model_id, attribute_type_id, is_required, default_value_id)
            SELECT model_record.id, attr_type_id, true, av.id
            FROM attribute_values av 
            WHERE av.attribute_type_id = attr_type_id 
            AND av.value = 'S1'
            LIMIT 1
            ON CONFLICT (model_id, attribute_type_id) DO NOTHING;
        END IF;

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
            AND av.value = 'Leather'
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

    RAISE NOTICE 'Successfully configured all HOME THEATER models with comprehensive attributes';
END $$;