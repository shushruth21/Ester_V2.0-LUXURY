-- Get the BED category ID and add the specific models
DO $$
DECLARE
    bed_category_id uuid;
BEGIN
    -- Get the BED category ID
    SELECT id INTO bed_category_id 
    FROM categories 
    WHERE slug = 'bed';

    -- Clear existing furniture models for BED category if any
    DELETE FROM furniture_models WHERE category_id = bed_category_id;

    -- Insert the 40 specific bed models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (bed_category_id, 'Aveo', 'aveo', 'Modern platform bed with sleek design', 1299.00, true),
    (bed_category_id, 'Diamante', 'diamante', 'Luxury bed with diamond-quilted headboard', 2199.00, true),
    (bed_category_id, 'Bretton', 'bretton', 'Traditional wooden bed frame', 899.00, false),
    (bed_category_id, 'Noale', 'noale', 'Contemporary bed with clean lines', 1099.00, false),
    (bed_category_id, 'Quaddy', 'quaddy', 'Geometric design bed frame', 1399.00, false),
    (bed_category_id, 'Ilara', 'ilara', 'Elegant upholstered bed', 1599.00, true),
    (bed_category_id, 'Eudald', 'eudald', 'Classic wooden bed with storage', 1249.00, false),
    (bed_category_id, 'Paxa', 'paxa', 'Minimalist platform bed', 799.00, false),
    (bed_category_id, 'Matita', 'matita', 'Artistic bed with unique headboard', 1699.00, false),
    (bed_category_id, 'Labyrin', 'labyrin', 'Intricate design bed frame', 1899.00, false),
    (bed_category_id, 'Ovidio', 'ovidio', 'Italian-inspired luxury bed', 2399.00, true),
    (bed_category_id, 'Convio', 'convio', 'Curved headboard bed', 1199.00, false),
    (bed_category_id, 'Savoy', 'savoy', 'Victorian-style ornate bed', 1799.00, false),
    (bed_category_id, 'Raphia', 'raphia', 'Natural material bed frame', 999.00, false),
    (bed_category_id, 'Manao', 'manao', 'Tropical hardwood bed', 1349.00, false),
    (bed_category_id, 'Nowra', 'nowra', 'Contemporary Australian-inspired bed', 1149.00, false),
    (bed_category_id, 'Camfo', 'camfo', 'Military-inspired sturdy bed', 899.00, false),
    (bed_category_id, 'Marezzato', 'marezzato', 'Marbled finish luxury bed', 2099.00, false),
    (bed_category_id, 'Daphne', 'daphne', 'Feminine floral-inspired bed', 1299.00, false),
    (bed_category_id, 'Rochester', 'rochester', 'Classic American style bed', 1599.00, false),
    (bed_category_id, 'Ethiya', 'ethiya', 'Bohemian-style bed frame', 1199.00, false),
    (bed_category_id, 'Fiaba', 'fiaba', 'Fairy-tale inspired bed', 1799.00, true),
    (bed_category_id, 'Campanula', 'campanula', 'Bell-flower inspired bed design', 1399.00, false),
    (bed_category_id, 'Ortensia', 'ortensia', 'Hydrangea-inspired bed frame', 1249.00, false),
    (bed_category_id, 'Gelso', 'gelso', 'Mulberry wood bed frame', 1449.00, false),
    (bed_category_id, 'Oleander', 'oleander', 'Mediterranean-inspired bed', 1699.00, false),
    (bed_category_id, 'Dreztta', 'dreztta', 'Designer bed with unique styling', 1999.00, false),
    (bed_category_id, 'Jipsta', 'jipsta', 'Modern urban bed design', 999.00, false),
    (bed_category_id, 'Bubble', 'bubble', 'Rounded soft-form bed', 1299.00, false),
    (bed_category_id, 'Chooseyy', 'chooseyy', 'Customizable modular bed', 1599.00, false),
    (bed_category_id, 'Bohemia', 'bohemia', 'Artistic bohemian bed frame', 1399.00, false),
    (bed_category_id, 'Cazewell', 'cazewell', 'English countryside bed', 1549.00, false),
    (bed_category_id, 'Alchemist', 'alchemist', 'Mystical design bed frame', 1899.00, false),
    (bed_category_id, 'Tempah', 'tempah', 'Contemporary Asian-inspired bed', 1199.00, false),
    (bed_category_id, 'Captane', 'captane', 'Captain-style nautical bed', 1349.00, false),
    (bed_category_id, 'Lennox', 'lennox', 'Scottish-inspired bed frame', 1249.00, false),
    (bed_category_id, 'Vertico', 'vertico', 'Vertical-lined modern bed', 1099.00, false),
    (bed_category_id, 'Knightowl', 'knightowl', 'Medieval-inspired bed design', 1799.00, false),
    (bed_category_id, 'Eyedea', 'eyedea', 'Visionary design bed frame', 1649.00, false),
    (bed_category_id, 'Lismore', 'lismore', 'Crystal-inspired elegant bed', 2299.00, true);
END $$;