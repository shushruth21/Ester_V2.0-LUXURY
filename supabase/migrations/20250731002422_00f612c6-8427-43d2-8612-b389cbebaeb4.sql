-- Add HOME THEATER models and link to relevant attributes
DO $$
DECLARE
    theater_category_id UUID;
    model_rec RECORD;
    attr_type_id UUID;
    attr_value_id UUID;
BEGIN
    -- Get the HOME THEATER category ID
    SELECT id INTO theater_category_id FROM categories WHERE name = 'HOME THEATER';
    
    -- Clear existing models in HOME THEATER category
    DELETE FROM furniture_models WHERE category_id = theater_category_id;
    
    -- Insert new HOME THEATER models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (theater_category_id, 'Chesam', 'chesam', 'Premium home theater seating with advanced features', 6200.00, false),
    (theater_category_id, 'Chigwell', 'chigwell', 'Luxury home theater chair with ergonomic design', 6500.00, false),
    (theater_category_id, 'Fritz', 'fritz', 'Modern home theater seating with tech integration', 6800.00, true),
    (theater_category_id, 'Krestina', 'krestina', 'Elegant home theater seating with refined comfort', 7200.00, false),
    (theater_category_id, 'Ercolani', 'ercolani', 'Italian-designed home theater seating', 7500.00, true),
    (theater_category_id, 'Redford', 'redford', 'Classic home theater seating with premium materials', 6900.00, false);

    -- Link relevant attribute types to all HOME THEATER models (excluding lounger-related attributes)
    FOR model_rec IN 
        SELECT id FROM furniture_models WHERE category_id = theater_category_id
    LOOP
        -- Link all relevant attribute types to this model (excluding lounger attributes)
        FOR attr_type_id IN 
            SELECT id FROM attribute_types WHERE name IN (
                'number_of_seats', 'seat_width', 'arm_rest_type', 'arm_rest_height', 
                'need_consoles', 'console_count', 'console_type', 'need_corner_unit', 
                'seat_depth', 'seat_height', 'overall_length', 'overall_width',
                'overall_height', 'wood_type', 'foam_type_seats', 'foam_type_back_rest', 
                'fabric_cladding_plan', 'fabric_code', 'indicative_fabric_colour', 
                'legs', 'accessories', 'stitching_type'
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