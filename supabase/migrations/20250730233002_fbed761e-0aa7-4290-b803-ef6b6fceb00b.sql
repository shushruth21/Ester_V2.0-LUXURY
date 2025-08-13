-- Get the BENCH category ID and add the specific models
DO $$
DECLARE
    bench_category_id uuid;
BEGIN
    -- Get the BENCH category ID
    SELECT id INTO bench_category_id 
    FROM categories 
    WHERE slug = 'bench';

    -- Clear existing furniture models for BENCH category if any
    DELETE FROM furniture_models WHERE category_id = bench_category_id;

    -- Insert the 10 specific bench models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (bench_category_id, 'Conrad', 'conrad', 'Classic wooden bench with traditional design', 599.00, true),
    (bench_category_id, 'Contour', 'contour', 'Ergonomic curved bench for comfort', 749.00, true),
    (bench_category_id, 'Crave', 'crave', 'Modern minimalist bench design', 449.00, false),
    (bench_category_id, 'Dale', 'dale', 'Rustic farmhouse-style bench', 529.00, false),
    (bench_category_id, 'Dana', 'dana', 'Elegant upholstered bench seat', 679.00, false),
    (bench_category_id, 'Dapper', 'dapper', 'Sophisticated leather bench', 899.00, true),
    (bench_category_id, 'Decker', 'decker', 'Industrial metal and wood bench', 629.00, false),
    (bench_category_id, 'Fandango', 'fandango', 'Vibrant colorful bench design', 549.00, false),
    (bench_category_id, 'Hale', 'hale', 'Sturdy outdoor-ready bench', 799.00, false),
    (bench_category_id, 'Sloafer', 'sloafer', 'Casual lounge-style bench', 649.00, false);
END $$;