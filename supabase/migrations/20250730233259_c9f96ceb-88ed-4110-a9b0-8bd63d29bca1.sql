-- Get the HOME THEATER category ID and add the specific models
DO $$
DECLARE
    home_theater_category_id uuid;
BEGIN
    -- Get the HOME THEATER category ID
    SELECT id INTO home_theater_category_id 
    FROM categories 
    WHERE slug = 'home-theater';

    -- Clear existing furniture models for HOME THEATER category if any
    DELETE FROM furniture_models WHERE category_id = home_theater_category_id;

    -- Insert the 6 specific home theater models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (home_theater_category_id, 'Chesam', 'chesam', 'Premium leather home theater seating with reclining features', 2499.00, true),
    (home_theater_category_id, 'Chigwell', 'chigwell', 'Luxury home cinema chair with cup holders', 1899.00, true),
    (home_theater_category_id, 'Ercolani', 'ercolani', 'Italian-designed theater seating with premium comfort', 2799.00, true),
    (home_theater_category_id, 'Fritz', 'fritz', 'Modern home theater recliner with USB charging', 1699.00, false),
    (home_theater_category_id, 'Krestina', 'krestina', 'Elegant home cinema seating with ambient lighting', 2199.00, false),
    (home_theater_category_id, 'Redford', 'redford', 'Classic American-style theater chair', 1599.00, false);
END $$;