-- Get the RECLINER category ID and add the specific models
DO $$
DECLARE
    recliner_category_id uuid;
BEGIN
    -- Get the RECLINER category ID
    SELECT id INTO recliner_category_id 
    FROM categories 
    WHERE slug = 'recliner';

    -- Clear existing furniture models for RECLINER category if any
    DELETE FROM furniture_models WHERE category_id = recliner_category_id;

    -- Insert the 9 specific recliner models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (recliner_category_id, 'Beha', 'beha', 'Ergonomic recliner with premium comfort features', 1299.00, true),
    (recliner_category_id, 'Belper', 'belper', 'Classic leather recliner with timeless appeal', 1199.00, false),
    (recliner_category_id, 'Hartmenn', 'hartmenn', 'German-engineered precision recliner with superior mechanics', 1599.00, true),
    (recliner_category_id, 'Kew', 'kew', 'Garden-inspired relaxation chair with natural elements', 1099.00, false),
    (recliner_category_id, 'Lyon', 'lyon', 'French-style elegant recliner with sophisticated design', 1399.00, true),
    (recliner_category_id, 'Norbury', 'norbury', 'Traditional English countryside recliner', 1249.00, false),
    (recliner_category_id, 'Reiss', 'reiss', 'Contemporary minimalist recliner with clean lines', 1349.00, false),
    (recliner_category_id, 'Reverie', 'reverie', 'Dreamy cloud-like recliner for ultimate relaxation', 1499.00, true),
    (recliner_category_id, 'Vivienne', 'vivienne', 'Luxury fashion-inspired recliner with bold styling', 1799.00, true);
END $$;