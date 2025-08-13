-- Get the ARM CHAIR category ID and add the specific models
DO $$
DECLARE
    arm_chair_category_id uuid;
BEGIN
    -- Get the ARM CHAIR category ID
    SELECT id INTO arm_chair_category_id 
    FROM categories 
    WHERE slug = 'arm-chair';

    -- Clear existing furniture models for ARM CHAIR category if any
    DELETE FROM furniture_models WHERE category_id = arm_chair_category_id;

    -- Insert the 15 specific arm chair models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (arm_chair_category_id, 'Oslo', 'oslo', 'Modern Scandinavian-inspired armchair with clean lines', 899.00, true),
    (arm_chair_category_id, 'Conran', 'conran', 'Contemporary armchair with sophisticated design', 1299.00, true),
    (arm_chair_category_id, 'Bentley', 'bentley', 'Luxury armchair with premium materials', 1899.00, false),
    (arm_chair_category_id, 'Smith', 'smith', 'Classic armchair with timeless appeal', 699.00, false),
    (arm_chair_category_id, 'Wendell', 'wendell', 'Comfortable armchair perfect for reading', 799.00, false),
    (arm_chair_category_id, 'Renato', 'renato', 'Italian-inspired armchair with elegant curves', 1499.00, true),
    (arm_chair_category_id, 'Hexie', 'hexie', 'Geometric design armchair with modern flair', 949.00, false),
    (arm_chair_category_id, 'Emmi', 'emmi', 'Soft and cozy armchair for maximum comfort', 599.00, false),
    (arm_chair_category_id, 'Akiva', 'akiva', 'Mid-century modern armchair with wooden frame', 1199.00, false),
    (arm_chair_category_id, 'Dimitry', 'dimitry', 'Bold armchair with striking presence', 1099.00, false),
    (arm_chair_category_id, 'Sunfrond', 'sunfrond', 'Nature-inspired armchair with organic shapes', 849.00, false),
    (arm_chair_category_id, 'Calan', 'calan', 'Minimalist armchair with subtle details', 749.00, false),
    (arm_chair_category_id, 'Claude', 'claude', 'French-inspired armchair with refined elegance', 1399.00, true),
    (arm_chair_category_id, 'Kizik', 'kizik', 'Contemporary armchair with unique styling', 999.00, false),
    (arm_chair_category_id, 'Rachel', 'rachel', 'Graceful armchair with feminine touches', 899.00, false);
END $$;