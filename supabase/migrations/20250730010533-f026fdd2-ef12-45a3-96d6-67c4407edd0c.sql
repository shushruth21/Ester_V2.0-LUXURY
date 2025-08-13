-- Insert all new furniture categories
INSERT INTO public.categories (name, slug, description, image_url) VALUES 
('Sofa Luxury', 'sofa-luxury', 'Premium luxury sofas crafted with the finest materials and exquisite design for the most discerning customers', 'https://images.unsplash.com/photo-1721322800607-8c38375eef04?w=800'),
('Sofa Comfort', 'sofa-comfort', 'Comfortable everyday sofas perfect for family living rooms, combining style with everyday functionality', 'https://images.unsplash.com/photo-1721322800607-8c38375eef04?w=800'),
('Sofa Economy', 'sofa-economy', 'Budget-friendly sofa options that don''t compromise on quality or style, perfect for first homes', 'https://images.unsplash.com/photo-1721322800607-8c38375eef04?w=800'),
('Recliner', 'recliner', 'Adjustable reclining chairs for ultimate relaxation, featuring smooth mechanisms and comfortable padding', 'https://images.unsplash.com/photo-1485833077593-4278bba3f11f?w=800'),
('Arm Chair', 'arm-chair', 'Single seating chairs with comfortable armrests, perfect for reading corners and living room accents', 'https://images.unsplash.com/photo-1485833077593-4278bba3f11f?w=800'),
('Dining Chair', 'dining-chair', 'Elegant dining chairs designed for comfort during meals, available in various styles and materials', 'https://images.unsplash.com/photo-1485833077593-4278bba3f11f?w=800'),
('Sofa Cum Bed', 'sofa-cum-bed', 'Versatile convertible furniture that transforms from sofa to bed, perfect for small spaces and guest rooms', 'https://images.unsplash.com/photo-1721322800607-8c38375eef04?w=800'),
('Ottoman', 'ottoman', 'Stylish footrests and storage ottomans that complement your seating while providing additional functionality', 'https://images.unsplash.com/photo-1485833077593-4278bba3f11f?w=800'),
('Bed Cots', 'bed-cots', 'Quality bed frames and cots in various sizes and styles to create the perfect bedroom foundation', 'https://images.unsplash.com/photo-1500673922987-e212871fec22?w=800'),
('Bed Mattress', 'bed-mattress', 'Premium mattresses for every sleeping preference, from memory foam to spring and hybrid options', 'https://images.unsplash.com/photo-1500673922987-e212871fec22?w=800'),
('Bed Headrest', 'bed-headrest', 'Decorative and functional headboards that add style and comfort to your bedroom setup', 'https://images.unsplash.com/photo-1500673922987-e212871fec22?w=800'),
('Home Theater', 'home-theater', 'Specialized entertainment seating designed for the ultimate movie and gaming experience at home', 'https://images.unsplash.com/photo-1485833077593-4278bba3f11f?w=800'),
('Puffee', 'puffee', 'Casual and comfortable seating options including bean bags and floor cushions for relaxed living', 'https://images.unsplash.com/photo-1485833077593-4278bba3f11f?w=800'),
('Bench', 'bench', 'Versatile seating benches perfect for entryways, dining rooms, and bedroom foot-of-bed placement', 'https://images.unsplash.com/photo-1485833077593-4278bba3f11f?w=800'),
('Kids Bed', 'kids-bed', 'Safe and fun bedroom furniture designed specifically for children, including themed and safety features', 'https://images.unsplash.com/photo-1500673922987-e212871fec22?w=800');

-- Add sample furniture models for each new category to populate the product listings
-- Get category IDs first, then insert models
INSERT INTO public.furniture_models (category_id, name, slug, description, base_price, is_featured, default_image_url)
SELECT 
    c.id,
    c.name || ' Model 1',
    c.slug || '-model-1',
    'Premium ' || lower(c.name) || ' with exceptional quality and design.',
    CASE 
        WHEN c.name LIKE '%Luxury%' THEN 2500.00
        WHEN c.name LIKE '%Comfort%' THEN 1500.00
        WHEN c.name LIKE '%Economy%' THEN 800.00
        WHEN c.name = 'Home Theater' THEN 3000.00
        WHEN c.name LIKE '%Bed%' OR c.name = 'Bed Cots' THEN 1200.00
        WHEN c.name = 'Kids Bed' THEN 600.00
        ELSE 1000.00
    END,
    true,
    c.image_url
FROM public.categories c
WHERE c.slug IN ('sofa-luxury', 'sofa-comfort', 'sofa-economy', 'recliner', 'arm-chair', 'dining-chair', 'sofa-cum-bed', 'ottoman', 'bed-cots', 'bed-mattress', 'bed-headrest', 'home-theater', 'puffee', 'bench', 'kids-bed');