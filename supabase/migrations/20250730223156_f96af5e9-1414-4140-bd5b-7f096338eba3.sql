-- Clear existing categories and add the 12 new ones
DELETE FROM categories;

-- Insert the 12 new categories
INSERT INTO categories (name, slug, description) VALUES 
('SOFA LUXURY', 'sofa-luxury', 'Premium luxury sofas with the finest materials and craftsmanship'),
('SOFA COMFORT', 'sofa-comfort', 'Comfortable sofas designed for everyday relaxation'),
('SOFA ECONOMY', 'sofa-economy', 'Affordable sofas without compromising on quality'),
('HOME THEATER', 'home-theater', 'Specialized seating for your home entertainment setup'),
('BED', 'bed', 'Comfortable beds for the perfect night sleep'),
('KIDS BED', 'kids-bed', 'Fun and safe beds designed specifically for children'),
('SOFA BED', 'sofa-bed', 'Versatile furniture that transforms from sofa to bed'),
('RECLINER', 'recliner', 'Adjustable chairs for ultimate comfort and relaxation'),
('ARM CHAIR', 'arm-chair', 'Elegant armchairs for any room'),
('DINNING CHAIR', 'dinning-chair', 'Stylish chairs for your dining room'),
('PUFFEE', 'puffee', 'Soft and comfortable poufs for flexible seating'),
('BENCH', 'bench', 'Versatile benches for seating and storage solutions');