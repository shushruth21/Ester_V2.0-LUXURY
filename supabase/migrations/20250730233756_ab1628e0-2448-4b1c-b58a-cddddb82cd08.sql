-- Get the SOFA COMFORT category ID and add the specific models
DO $$
DECLARE
    sofa_comfort_category_id uuid;
BEGIN
    -- Get the SOFA COMFORT category ID
    SELECT id INTO sofa_comfort_category_id 
    FROM categories 
    WHERE slug = 'sofa-comfort';

    -- Clear existing furniture models for SOFA COMFORT category if any
    DELETE FROM furniture_models WHERE category_id = sofa_comfort_category_id;

    -- Insert the 47 specific sofa comfort models
    INSERT INTO furniture_models (category_id, name, slug, description, base_price, is_featured) VALUES
    (sofa_comfort_category_id, 'Grimaldo', 'grimaldo', 'Italian-inspired luxury comfort sofa with premium materials', 2299.00, true),
    (sofa_comfort_category_id, 'Alegre', 'alegre', 'Joyful and vibrant comfort sofa perfect for family gatherings', 1899.00, true),
    (sofa_comfort_category_id, 'Alessio', 'alessio', 'Classic Italian comfort design with timeless appeal', 2199.00, false),
    (sofa_comfort_category_id, 'Alexia', 'alexia', 'Elegant feminine-inspired comfort sofa with soft curves', 1999.00, true),
    (sofa_comfort_category_id, 'Aurora', 'aurora', 'Dawn-inspired comfort sofa with warm, welcoming tones', 2099.00, false),
    (sofa_comfort_category_id, 'Balboa', 'balboa', 'Rocky-inspired sturdy comfort sofa built for relaxation', 1799.00, false),
    (sofa_comfort_category_id, 'Cardiff', 'cardiff', 'Welsh-inspired traditional comfort sofa with modern touches', 1899.00, false),
    (sofa_comfort_category_id, 'Cromie', 'cromie', 'Color-rich comfort sofa with vibrant personality', 1749.00, false),
    (sofa_comfort_category_id, 'Dalmore', 'dalmore', 'Scottish Highland-inspired luxury comfort sofa', 2399.00, true),
    (sofa_comfort_category_id, 'Duilio', 'duilio', 'Roman-inspired grand comfort sofa for majestic living', 2199.00, false),
    (sofa_comfort_category_id, 'Edizioni', 'edizioni', 'Limited edition designer comfort sofa with artistic flair', 2699.00, true),
    (sofa_comfort_category_id, 'Elevate', 'elevate', 'Height-adjustable modern comfort sofa with tech integration', 2499.00, true),
    (sofa_comfort_category_id, 'Erba', 'erba', 'Herb garden-inspired natural comfort sofa', 1649.00, false),
    (sofa_comfort_category_id, 'Exeter', 'exeter', 'English countryside comfort sofa with traditional craftsmanship', 1999.00, false),
    (sofa_comfort_category_id, 'Glytonn', 'glytonn', 'Nordic-inspired minimalist comfort sofa', 1849.00, false),
    (sofa_comfort_category_id, 'Gorhamm', 'gorhamm', 'Double-M design comfort sofa with unique character', 1799.00, false),
    (sofa_comfort_category_id, 'Grosseto', 'grosseto', 'Tuscan-inspired rustic comfort sofa', 1899.00, false),
    (sofa_comfort_category_id, 'Grumetto', 'grumetto', 'Playful compact comfort sofa perfect for smaller spaces', 1599.00, false),
    (sofa_comfort_category_id, 'Guarulhos', 'guarulhos', 'Brazilian-inspired tropical comfort sofa', 1749.00, false),
    (sofa_comfort_category_id, 'Harold', 'harold', 'Classic gentleman''s comfort sofa with refined elegance', 2099.00, false),
    (sofa_comfort_category_id, 'Hope', 'hope', 'Optimistic design comfort sofa bringing joy to any room', 1699.00, false),
    (sofa_comfort_category_id, 'Ibisca', 'ibisca', 'Exotic bird-inspired comfort sofa with graceful lines', 1849.00, false),
    (sofa_comfort_category_id, 'Jack', 'jack', 'All-purpose versatile comfort sofa for everyday living', 1599.00, false),
    (sofa_comfort_category_id, 'Karphi', 'karphi', 'Greek island-inspired Mediterranean comfort sofa', 1949.00, false),
    (sofa_comfort_category_id, 'Loggia', 'loggia', 'Architectural-inspired comfort sofa with structural beauty', 2199.00, false),
    (sofa_comfort_category_id, 'Londrina', 'londrina', 'South American-inspired vibrant comfort sofa', 1799.00, false),
    (sofa_comfort_category_id, 'Long beach', 'long-beach', 'Coastal California-inspired relaxed comfort sofa', 1899.00, true),
    (sofa_comfort_category_id, 'Luton', 'luton', 'English town-inspired cozy comfort sofa', 1699.00, false),
    (sofa_comfort_category_id, 'Luxuria', 'luxuria', 'Ultra-luxurious comfort sofa with premium features', 3199.00, true),
    (sofa_comfort_category_id, 'Massimo', 'massimo', 'Maximum comfort Italian design sofa', 2299.00, true),
    (sofa_comfort_category_id, 'Maze', 'maze', 'Intricate design comfort sofa with complex beauty', 1949.00, false),
    (sofa_comfort_category_id, 'Natal', 'natal', 'Birth-inspired new beginning comfort sofa', 1749.00, false),
    (sofa_comfort_category_id, 'Nest', 'nest', 'Cozy cocoon-like comfort sofa for ultimate relaxation', 1899.00, true),
    (sofa_comfort_category_id, 'Nord', 'nord', 'Northern-inspired cool comfort sofa with clean lines', 1849.00, false),
    (sofa_comfort_category_id, 'Ocean', 'ocean', 'Deep blue sea-inspired comfort sofa with flowing design', 2099.00, true),
    (sofa_comfort_category_id, 'Patrizea', 'patrizea', 'Patrician-inspired noble comfort sofa', 2399.00, false),
    (sofa_comfort_category_id, 'Pelican', 'pelican', 'Coastal bird-inspired spacious comfort sofa', 1999.00, false),
    (sofa_comfort_category_id, 'Rennes', 'rennes', 'French city-inspired sophisticated comfort sofa', 2199.00, false),
    (sofa_comfort_category_id, 'Roxo', 'roxo', 'Purple-toned comfort sofa with royal elegance', 1899.00, false),
    (sofa_comfort_category_id, 'Sage', 'sage', 'Wise and serene comfort sofa in calming tones', 1799.00, false),
    (sofa_comfort_category_id, 'Santana', 'santana', 'Musical rhythm-inspired dynamic comfort sofa', 1949.00, false),
    (sofa_comfort_category_id, 'Shawn', 'shawn', 'Modern masculine comfort sofa with bold presence', 1849.00, false),
    (sofa_comfort_category_id, 'Smug', 'smug', 'Confidently comfortable sofa with superior design', 1699.00, false),
    (sofa_comfort_category_id, 'Tenso', 'tenso', 'Tension-balanced comfort sofa with ergonomic support', 2099.00, false),
    (sofa_comfort_category_id, 'Tweezer', 'tweezer', 'Precision-crafted comfort sofa with fine details', 1799.00, false),
    (sofa_comfort_category_id, 'Visionnaire', 'visionnaire', 'Future-forward comfort sofa with innovative design', 2799.00, true),
    (sofa_comfort_category_id, 'Zin', 'zin', 'Wine-inspired rich comfort sofa for connoisseurs', 2199.00, false);
END $$;