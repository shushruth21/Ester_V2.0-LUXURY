-- Get the SOFA BED category ID and add the specific models
DO $$
DECLARE
    sofa_bed_category_id uuid;
BEGIN
    -- Get the SOFA BED category ID
    SELECT id INTO sofa_bed_category_id 
    FROM categories 
    WHERE slug = 'sofa-bed';

    -- Clear existing furniture models for SOFA BED category if any
    DELETE FROM furniture_models WHERE category_id = sofa_bed_category_id;

    -- Insert the 16 specific sofa bed models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (sofa_bed_category_id, 'Albatross', 'albatross', 'Graceful convertible sofa bed with spacious sleeping area', 1899.00, true),
    (sofa_bed_category_id, 'Amore', 'amore', 'Romantic Italian-inspired sofa bed perfect for couples', 1799.00, true),
    (sofa_bed_category_id, 'Anke', 'anke', 'Scandinavian minimalist sofa bed with clean functionality', 1599.00, false),
    (sofa_bed_category_id, 'Avebury', 'avebury', 'Classic English countryside sofa bed with traditional charm', 1749.00, false),
    (sofa_bed_category_id, 'Beckett', 'beckett', 'Literary-inspired sophisticated sofa bed for the cultured home', 1849.00, true),
    (sofa_bed_category_id, 'Cory (R)', 'cory-r', 'Right-handed corner sofa bed configuration', 2199.00, false),
    (sofa_bed_category_id, 'Dinny', 'dinny', 'Compact urban sofa bed perfect for small spaces', 1299.00, false),
    (sofa_bed_category_id, 'Dino', 'dino', 'Playful family-friendly sofa bed with durable construction', 1399.00, false),
    (sofa_bed_category_id, 'Felix (R)', 'felix-r', 'Right-handed luxurious sofa bed with premium materials', 2099.00, true),
    (sofa_bed_category_id, 'Indiana', 'indiana', 'Adventure-inspired rugged sofa bed for active lifestyles', 1699.00, false),
    (sofa_bed_category_id, 'Itasca', 'itasca', 'Nature-inspired sofa bed with organic design elements', 1649.00, false),
    (sofa_bed_category_id, 'Malmo', 'malmo', 'Swedish-designed modern sofa bed with smart storage', 1799.00, true),
    (sofa_bed_category_id, 'Riva', 'riva', 'Coastal-inspired sofa bed perfect for waterfront homes', 1749.00, false),
    (sofa_bed_category_id, 'Stefan (R)', 'stefan-r', 'Right-handed contemporary sofa bed with sleek profile', 1949.00, false),
    (sofa_bed_category_id, 'Vinci', 'vinci', 'Renaissance-inspired artistic sofa bed with masterful craftsmanship', 2299.00, true),
    (sofa_bed_category_id, 'Zaxxy', 'zaxxy', 'Modern tech-forward sofa bed with innovative features', 2199.00, true);
END $$;