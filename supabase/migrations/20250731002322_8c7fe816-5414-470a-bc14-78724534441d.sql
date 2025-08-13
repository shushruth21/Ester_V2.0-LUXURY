-- Link existing attributes to SOFA ECONOMY models
DO $$
DECLARE
    economy_category_id UUID;
    model_rec RECORD;
    attr_type_id UUID;
    attr_value_id UUID;
BEGIN
    -- Get the SOFA ECONOMY category ID
    SELECT id INTO economy_category_id FROM categories WHERE name = 'SOFA ECONOMY';
    
    -- Link all attribute types to all SOFA ECONOMY models
    FOR model_rec IN 
        SELECT id FROM furniture_models WHERE category_id = economy_category_id
    LOOP
        -- Link all attribute types to this model (using existing attributes)
        FOR attr_type_id IN 
            SELECT id FROM attribute_types WHERE name IN (
                'number_of_seats', 'need_lounger', 'lounger_position', 'lounger_length', 'seat_width',
                'arm_rest_type', 'arm_rest_height', 'need_consoles', 'console_count', 'console_type',
                'need_corner_unit', 'seat_depth', 'seat_height', 'overall_length', 'overall_width',
                'overall_height', 'wood_type', 'foam_type_seats', 'foam_type_back_rest', 'fabric_cladding_plan',
                'fabric_code', 'indicative_fabric_colour', 'legs', 'accessories', 'stitching_type'
            )
        LOOP
            -- Skip if already linked
            IF EXISTS (
                SELECT 1 FROM model_attributes 
                WHERE model_id = model_rec.id AND attribute_type_id = attr_type_id
            ) THEN
                CONTINUE;
            END IF;
            
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