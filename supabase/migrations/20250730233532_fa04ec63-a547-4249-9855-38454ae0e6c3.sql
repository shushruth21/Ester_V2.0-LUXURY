-- Get the PUFFEE category ID and add the specific models
DO $$
DECLARE
    puffee_category_id uuid;
BEGIN
    -- Get the PUFFEE category ID
    SELECT id INTO puffee_category_id 
    FROM categories 
    WHERE slug = 'puffee';

    -- Clear existing furniture models for PUFFEE category if any
    DELETE FROM furniture_models WHERE category_id = puffee_category_id;

    -- Insert the 18 specific puffee models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (puffee_category_id, 'Amaretto', 'amaretto', 'Sweet almond-inspired soft puffee ottoman', 449.00, true),
    (puffee_category_id, 'Amet', 'amet', 'Minimalist round puffee with clean design', 329.00, false),
    (puffee_category_id, 'Atay', 'atay', 'Tea ceremony-inspired meditation puffee', 399.00, false),
    (puffee_category_id, 'Driade', 'driade', 'Mythological forest nymph-inspired puffee', 529.00, true),
    (puffee_category_id, 'Entro', 'entro', 'Entrance-focused welcoming puffee design', 379.00, false),
    (puffee_category_id, 'Falkon', 'falkon', 'Aerodynamic bird-inspired puffee ottoman', 479.00, false),
    (puffee_category_id, 'Galet', 'galet', 'Smooth pebble-shaped coastal puffee', 429.00, false),
    (puffee_category_id, 'Kubico', 'kubico', 'Geometric cubic-inspired modern puffee', 459.00, true),
    (puffee_category_id, 'Marenco', 'marenco', 'Italian coastal-inspired luxury puffee', 549.00, false),
    (puffee_category_id, 'Marion', 'marion', 'Classic French-inspired elegant puffee', 489.00, false),
    (puffee_category_id, 'Nesos', 'nesos', 'Island-inspired tropical puffee design', 439.00, false),
    (puffee_category_id, 'Pyro', 'pyro', 'Fire-inspired warm-toned puffee ottoman', 499.00, false),
    (puffee_category_id, 'Qeeboo', 'qeeboo', 'Playful contemporary design puffee', 359.00, false),
    (puffee_category_id, 'Rioni', 'rioni', 'Neighborhood-inspired community puffee', 419.00, false),
    (puffee_category_id, 'Sabot', 'sabot', 'Wooden shoe-inspired rustic puffee', 389.00, false),
    (puffee_category_id, 'Tod', 'tod', 'Compact mini puffee for small spaces', 299.00, true),
    (puffee_category_id, 'Twils', 'twils', 'Textile-focused soft fabric puffee', 469.00, false),
    (puffee_category_id, 'Wade', 'wade', 'Water-resistant outdoor puffee design', 519.00, true);
END $$;