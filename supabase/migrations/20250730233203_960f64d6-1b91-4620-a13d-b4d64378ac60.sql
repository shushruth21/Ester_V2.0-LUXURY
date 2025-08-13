-- Get the DINNING CHAIR category ID and add the specific models
DO $$
DECLARE
    dinning_chair_category_id uuid;
BEGIN
    -- Get the DINNING CHAIR category ID
    SELECT id INTO dinning_chair_category_id 
    FROM categories 
    WHERE slug = 'dinning-chair';

    -- Clear existing furniture models for DINNING CHAIR category if any
    DELETE FROM furniture_models WHERE category_id = dinning_chair_category_id;

    -- Insert the 9 specific dining chair models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (dinning_chair_category_id, 'Arizona', 'arizona', 'Southwestern-inspired dining chair with rustic charm', 299.00, true),
    (dinning_chair_category_id, 'Joli', 'joli', 'Elegant French-style dining chair', 349.00, true),
    (dinning_chair_category_id, 'Mellow', 'mellow', 'Soft curved dining chair for relaxed dining', 279.00, false),
    (dinning_chair_category_id, 'Noto', 'noto', 'Minimalist Japanese-inspired dining chair', 399.00, false),
    (dinning_chair_category_id, 'Scarpa', 'scarpa', 'Italian designer dining chair with sleek lines', 449.00, true),
    (dinning_chair_category_id, 'Souvenir', 'souvenir', 'Vintage-inspired dining chair with character', 329.00, false),
    (dinning_chair_category_id, 'Sperone', 'sperone', 'Modern angular dining chair design', 379.00, false),
    (dinning_chair_category_id, 'Turtle', 'turtle', 'Organic shell-shaped dining chair', 359.00, false),
    (dinning_chair_category_id, 'Velit', 'velit', 'Contemporary upholstered dining chair', 419.00, false);
END $$;