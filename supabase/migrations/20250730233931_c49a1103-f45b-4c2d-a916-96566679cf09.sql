-- First, get the SOFA LUXURY category ID
DO $$
DECLARE
    luxury_category_id UUID;
BEGIN
    -- Get the SOFA LUXURY category ID
    SELECT id INTO luxury_category_id FROM categories WHERE name = 'SOFA LUXURY';
    
    -- Clear existing models in SOFA LUXURY category
    DELETE FROM furniture_models WHERE category_id = luxury_category_id;
    
    -- Insert new SOFA LUXURY models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (luxury_category_id, 'Calvert', 'calvert', 'Premium luxury sofa with sophisticated design', 8500.00, false),
    (luxury_category_id, 'Darlington', 'darlington', 'Elegant luxury sofa with refined craftsmanship', 9200.00, false),
    (luxury_category_id, 'Emporio', 'emporio', 'High-end designer sofa with premium materials', 11500.00, true),
    (luxury_category_id, 'Etan', 'etan', 'Contemporary luxury sofa with modern aesthetics', 8800.00, false),
    (luxury_category_id, 'Falsasquadra', 'falsasquadra', 'Architectural luxury sofa with geometric lines', 10200.00, false),
    (luxury_category_id, 'Federico', 'federico', 'Italian-inspired luxury sofa with timeless appeal', 9600.00, false),
    (luxury_category_id, 'Felini', 'felini', 'Sophisticated luxury sofa with artistic flair', 9800.00, false),
    (luxury_category_id, 'Formitalia', 'formitalia', 'Designer luxury sofa with exceptional comfort', 12000.00, true),
    (luxury_category_id, 'Janeiro', 'janeiro', 'Tropical-inspired luxury sofa with rich textures', 8900.00, false),
    (luxury_category_id, 'Kristalia', 'kristalia', 'Crystal-clear luxury sofa design with modern edge', 10800.00, false),
    (luxury_category_id, 'Leha', 'leha', 'Minimalist luxury sofa with clean lines', 8300.00, false),
    (luxury_category_id, 'Metis', 'metis', 'Intelligent luxury sofa design with adaptive features', 9400.00, false),
    (luxury_category_id, 'Missana', 'missana', 'Artistic luxury sofa with unique character', 9700.00, false),
    (luxury_category_id, 'Morado', 'morado', 'Rich purple-toned luxury sofa with opulent feel', 10500.00, false),
    (luxury_category_id, 'Natari', 'natari', 'Nature-inspired luxury sofa with organic forms', 9100.00, false),
    (luxury_category_id, 'Paris', 'paris', 'French-inspired luxury sofa with classic elegance', 11200.00, true),
    (luxury_category_id, 'Quila', 'quila', 'Modern luxury sofa with distinctive silhouette', 8700.00, false),
    (luxury_category_id, 'Rivello', 'rivello', 'Riverstone-inspired luxury sofa with flowing design', 9300.00, false),
    (luxury_category_id, 'Rossato', 'rossato', 'Italian luxury sofa with artisanal craftsmanship', 10600.00, false),
    (luxury_category_id, 'Salvador', 'salvador', 'Surreal luxury sofa with artistic inspiration', 11800.00, false),
    (luxury_category_id, 'Santo', 'santo', 'Sacred geometry luxury sofa with spiritual design', 9500.00, false),
    (luxury_category_id, 'Sinfona', 'sinfona', 'Musical luxury sofa with harmonious proportions', 10300.00, false),
    (luxury_category_id, 'Taranto', 'taranto', 'Mediterranean luxury sofa with coastal elegance', 9000.00, false),
    (luxury_category_id, 'Toulouse', 'toulouse', 'French provincial luxury sofa with vintage charm', 10700.00, false),
    (luxury_category_id, 'Zion', 'zion', 'Majestic luxury sofa with commanding presence', 12500.00, true);
END $$;