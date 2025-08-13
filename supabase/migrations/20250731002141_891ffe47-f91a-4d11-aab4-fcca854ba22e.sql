-- Add SOFA COMFORT models and link to existing attributes
DO $$
DECLARE
    comfort_category_id UUID;
    model_rec RECORD;
    attr_type_id UUID;
    attr_value_id UUID;
BEGIN
    -- Get the SOFA COMFORT category ID
    SELECT id INTO comfort_category_id FROM categories WHERE name = 'SOFA COMFORT';
    
    -- Clear existing models in SOFA COMFORT category
    DELETE FROM furniture_models WHERE category_id = comfort_category_id;
    
    -- Insert new SOFA COMFORT models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (comfort_category_id, 'Grimaldo', 'grimaldo', 'Comfortable sofa with excellent support', 4200.00, false),
    (comfort_category_id, 'Duilio', 'duilio', 'Classic comfort sofa with timeless design', 4500.00, false),
    (comfort_category_id, 'Edizioni', 'edizioni', 'Limited edition comfort sofa', 4800.00, true),
    (comfort_category_id, 'Erba', 'erba', 'Nature-inspired comfort sofa', 4300.00, false),
    (comfort_category_id, 'Massimo', 'massimo', 'Maximum comfort sofa design', 5200.00, true),
    (comfort_category_id, 'Sage', 'sage', 'Wise design comfort sofa', 4400.00, false),
    (comfort_category_id, 'Shawn', 'shawn', 'Modern comfort sofa with sleek lines', 4600.00, false),
    (comfort_category_id, 'Visionnaire', 'visionnaire', 'Visionary comfort sofa design', 5500.00, false),
    (comfort_category_id, 'Alessio', 'alessio', 'Italian comfort sofa with style', 4700.00, false),
    (comfort_category_id, 'Alexia', 'alexia', 'Elegant comfort sofa for modern homes', 4900.00, false),
    (comfort_category_id, 'Balboa', 'balboa', 'Beachside comfort sofa inspiration', 4350.00, false),
    (comfort_category_id, 'Dalmore', 'dalmore', 'Premium comfort sofa with rich textures', 5100.00, false),
    (comfort_category_id, 'Glytonn', 'glytonn', 'Glowing comfort sofa design', 4650.00, false),
    (comfort_category_id, 'Hope', 'hope', 'Optimistic comfort sofa design', 4250.00, false),
    (comfort_category_id, 'Londrina', 'londrina', 'London-inspired comfort sofa', 4550.00, false),
    (comfort_category_id, 'Long beach', 'long-beach', 'Coastal comfort sofa with relaxed vibes', 4450.00, false),
    (comfort_category_id, 'Ocean', 'ocean', 'Ocean-inspired comfort sofa', 4750.00, false),
    (comfort_category_id, 'Patrizea', 'patrizea', 'Patrician comfort sofa with noble design', 5000.00, false),
    (comfort_category_id, 'Roxo', 'roxo', 'Purple-toned comfort sofa', 4400.00, false),
    (comfort_category_id, 'Santana', 'santana', 'Musical comfort sofa with rhythm', 4600.00, false),
    (comfort_category_id, 'Smug', 'smug', 'Cozy comfort sofa for intimate spaces', 4300.00, false),
    (comfort_category_id, 'Tweezer', 'tweezer', 'Precision comfort sofa design', 4500.00, false),
    (comfort_category_id, 'Zin', 'zin', 'Zen comfort sofa for peaceful homes', 4350.00, false),
    (comfort_category_id, 'Grosseto', 'grosseto', 'Italian countryside comfort sofa', 4800.00, false),
    (comfort_category_id, 'Maze', 'maze', 'Intricate comfort sofa design', 4950.00, false),
    (comfort_category_id, 'Tenso', 'tenso', 'Tensioned comfort sofa with support', 4700.00, false),
    (comfort_category_id, 'Alegre', 'alegre', 'Joyful comfort sofa design', 4400.00, false),
    (comfort_category_id, 'Aurora', 'aurora', 'Dawn-inspired comfort sofa', 4850.00, false),
    (comfort_category_id, 'Cardiff', 'cardiff', 'Welsh comfort sofa with charm', 4550.00, false),
    (comfort_category_id, 'Cromie', 'cromie', 'Chromatic comfort sofa with colors', 4650.00, false),
    (comfort_category_id, 'Elevate', 'elevate', 'Elevated comfort sofa experience', 5300.00, true),
    (comfort_category_id, 'Exeter', 'exeter', 'English comfort sofa with tradition', 4750.00, false),
    (comfort_category_id, 'Gorhamm', 'gorhamm', 'Gothic comfort sofa with character', 4900.00, false),
    (comfort_category_id, 'Loggia', 'loggia', 'Arcade-inspired comfort sofa', 4600.00, false),
    (comfort_category_id, 'Ibisca', 'ibisca', 'Hibiscus comfort sofa with tropical feel', 4450.00, false),
    (comfort_category_id, 'Luton', 'luton', 'Town comfort sofa with urban appeal', 4350.00, false),
    (comfort_category_id, 'Luxuria', 'luxuria', 'Luxurious comfort sofa design', 5600.00, true),
    (comfort_category_id, 'Natal', 'natal', 'Birth-inspired comfort sofa', 4500.00, false),
    (comfort_category_id, 'Nest', 'nest', 'Nesting comfort sofa for families', 4400.00, false),
    (comfort_category_id, 'Nord', 'nord', 'Nordic comfort sofa with minimalism', 4700.00, false),
    (comfort_category_id, 'Pelican', 'pelican', 'Bird-inspired comfort sofa', 4550.00, false),
    (comfort_category_id, 'Rennes', 'rennes', 'French comfort sofa with elegance', 4800.00, false),
    (comfort_category_id, 'Karphi', 'karphi', 'Carp-inspired comfort sofa', 4450.00, false),
    (comfort_category_id, 'Grumetto', 'grumetto', 'Grounded comfort sofa design', 4650.00, false),
    (comfort_category_id, 'Guarulhos', 'guarulhos', 'Brazilian comfort sofa with warmth', 4750.00, false),
    (comfort_category_id, 'Harold', 'harold', 'Traditional comfort sofa with heritage', 4600.00, false),
    (comfort_category_id, 'Jack', 'jack', 'Versatile comfort sofa for all', 4300.00, false);

    -- Link all attribute types to all SOFA COMFORT models
    FOR model_rec IN 
        SELECT id FROM furniture_models WHERE category_id = comfort_category_id
    LOOP
        -- Link all attribute types to this model (using existing attributes from SOFA LUXURY)
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