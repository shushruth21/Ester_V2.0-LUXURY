-- Get the KIDS BED category ID and add the specific models
DO $$
DECLARE
    kids_bed_category_id uuid;
BEGIN
    -- Get the KIDS BED category ID
    SELECT id INTO kids_bed_category_id 
    FROM categories 
    WHERE slug = 'kids-bed';

    -- Clear existing furniture models for KIDS BED category if any
    DELETE FROM furniture_models WHERE category_id = kids_bed_category_id;

    -- Insert the 17 specific kids bed models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (kids_bed_category_id, 'Akoya', 'akoya', 'Pearl-inspired elegant kids bed with soft curves', 799.00, true),
    (kids_bed_category_id, 'Bagheera', 'bagheera', 'Jungle Book inspired adventure bed for kids', 899.00, true),
    (kids_bed_category_id, 'Berlioz', 'berlioz', 'Musical-themed kids bed with artistic design', 749.00, false),
    (kids_bed_category_id, 'Cyclone Taupe', 'cyclone-taupe', 'Dynamic spiral design bed in neutral taupe', 849.00, false),
    (kids_bed_category_id, 'Elsa', 'elsa', 'Frozen-inspired magical ice queen bed', 999.00, true),
    (kids_bed_category_id, 'Jerry', 'jerry', 'Playful cartoon mouse-themed kids bed', 699.00, false),
    (kids_bed_category_id, 'Mickey', 'mickey', 'Classic Disney Mickey Mouse themed bed', 899.00, true),
    (kids_bed_category_id, 'Morey', 'morey', 'Ocean-themed kids bed with wave patterns', 779.00, false),
    (kids_bed_category_id, 'Mowgli', 'mowgli', 'Jungle adventure bed inspired by The Jungle Book', 829.00, false),
    (kids_bed_category_id, 'Pikachu', 'pikachu', 'Electric Pokemon-themed bright yellow bed', 949.00, true),
    (kids_bed_category_id, 'Rocketship', 'rocketship', 'Space adventure rocket-shaped kids bed', 1199.00, true),
    (kids_bed_category_id, 'Roger', 'roger', 'Classic traditional kids bed with timeless design', 649.00, false),
    (kids_bed_category_id, 'Sante', 'sante', 'Health-conscious eco-friendly kids bed', 729.00, false),
    (kids_bed_category_id, 'Scallop', 'scallop', 'Seashell-shaped bed perfect for ocean lovers', 799.00, false),
    (kids_bed_category_id, 'Sophie', 'sophie', 'Elegant princess-style bed for little girls', 879.00, false),
    (kids_bed_category_id, 'SunnyBloom', 'sunnybloom', 'Bright flower-themed bed with sunny colors', 749.00, false),
    (kids_bed_category_id, 'Tiffany', 'tiffany', 'Luxury-inspired elegant kids bed with refined details', 949.00, false);
END $$;