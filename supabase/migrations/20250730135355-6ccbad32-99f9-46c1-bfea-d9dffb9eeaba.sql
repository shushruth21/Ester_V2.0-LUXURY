-- COMPREHENSIVE FURNITURE DATABASE POPULATION
-- This migration adds 120+ furniture models across 10 empty categories
-- and populates all missing attribute values

-- First, add missing attribute values for all attribute types that currently have 0 values

-- Bed Size (attribute_type_id for 'bed_size')
WITH bed_size_attr AS (
  SELECT id FROM attribute_types WHERE name = 'bed_size'
)
INSERT INTO attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier)
SELECT 
  gen_random_uuid(),
  bed_size_attr.id,
  vals.value,
  vals.display_name,
  vals.sort_order,
  vals.price_modifier
FROM bed_size_attr
CROSS JOIN (VALUES
  ('single', 'Single', 1, -2000),
  ('double', 'Double', 2, 0),
  ('queen', 'Queen', 3, 3000),
  ('king', 'King', 4, 6000),
  ('super_king', 'Super King', 5, 10000)
) AS vals(value, display_name, sort_order, price_modifier);

-- Storage Type Bed
WITH storage_type_bed_attr AS (
  SELECT id FROM attribute_types WHERE name = 'storage_type_bed'
)
INSERT INTO attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier)
SELECT 
  gen_random_uuid(),
  storage_type_bed_attr.id,
  vals.value,
  vals.display_name,
  vals.sort_order,
  vals.price_modifier
FROM storage_type_bed_attr
CROSS JOIN (VALUES
  ('no_storage', 'No Storage', 1, 0),
  ('box_storage', 'Box Storage', 2, 5000),
  ('hydraulic_storage', 'Hydraulic Storage', 3, 8000),
  ('drawer_storage', 'Drawer Storage', 4, 6000)
) AS vals(value, display_name, sort_order, price_modifier);

-- Headrest Type Bed
WITH headrest_type_bed_attr AS (
  SELECT id FROM attribute_types WHERE name = 'headrest_type_bed'
)
INSERT INTO attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier)
SELECT 
  gen_random_uuid(),
  headrest_type_bed_attr.id,
  vals.value,
  vals.display_name,
  vals.sort_order,
  vals.price_modifier
FROM headrest_type_bed_attr
CROSS JOIN (VALUES
  ('tufted', 'Tufted', 1, 3000),
  ('panel', 'Panel', 2, 1500),
  ('upholstered', 'Upholstered', 3, 2500),
  ('wooden', 'Wooden', 4, 1000),
  ('metal', 'Metal', 5, 800)
) AS vals(value, display_name, sort_order, price_modifier);

-- Storage Ottoman Bed Cot
WITH storage_ottoman_bed_cot_attr AS (
  SELECT id FROM attribute_types WHERE name = 'storage_ottoman_bed_cot'
)
INSERT INTO attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier)
SELECT 
  gen_random_uuid(),
  storage_ottoman_bed_cot_attr.id,
  vals.value,
  vals.display_name,
  vals.sort_order,
  vals.price_modifier
FROM storage_ottoman_bed_cot_attr
CROSS JOIN (VALUES
  ('yes', 'With Storage', 1, 4000),
  ('no', 'Without Storage', 2, 0)
) AS vals(value, display_name, sort_order, price_modifier);

-- Storage Thickness Bed
WITH storage_thickness_bed_attr AS (
  SELECT id FROM attribute_types WHERE name = 'storage_thickness_bed'
)
INSERT INTO attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier)
SELECT 
  gen_random_uuid(),
  storage_thickness_bed_attr.id,
  vals.value,
  vals.display_name,
  vals.sort_order,
  vals.price_modifier
FROM storage_thickness_bed_attr
CROSS JOIN (VALUES
  ('6_inch', '6 inches', 1, 0),
  ('8_inch', '8 inches', 2, 1500),
  ('10_inch', '10 inches', 3, 3000),
  ('12_inch', '12 inches', 4, 4500)
) AS vals(value, display_name, sort_order, price_modifier);

-- Mattress Type
WITH mattress_type_attr AS (
  SELECT id FROM attribute_types WHERE name = 'mattress_type'
)
INSERT INTO attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier)
SELECT 
  gen_random_uuid(),
  mattress_type_attr.id,
  vals.value,
  vals.display_name,
  vals.sort_order,
  vals.price_modifier
FROM mattress_type_attr
CROSS JOIN (VALUES
  ('memory_foam', 'Memory Foam', 1, 8000),
  ('spring', 'Spring', 2, 3000),
  ('latex', 'Latex', 3, 6000),
  ('hybrid', 'Hybrid', 4, 10000),
  ('orthopedic', 'Orthopedic', 5, 12000)
) AS vals(value, display_name, sort_order, price_modifier);

-- Bench Length
WITH bench_length_attr AS (
  SELECT id FROM attribute_types WHERE name = 'bench_length'
)
INSERT INTO attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier)
SELECT 
  gen_random_uuid(),
  bench_length_attr.id,
  vals.value,
  vals.display_name,
  vals.sort_order,
  vals.price_modifier
FROM bench_length_attr
CROSS JOIN (VALUES
  ('small_3ft', 'Small (3 feet)', 1, 0),
  ('medium_4ft', 'Medium (4 feet)', 2, 2000),
  ('large_5ft', 'Large (5 feet)', 3, 4000),
  ('extra_large_6ft', 'Extra Large (6 feet)', 4, 6000)
) AS vals(value, display_name, sort_order, price_modifier);

-- Chair Seat Type
WITH chair_seat_type_attr AS (
  SELECT id FROM attribute_types WHERE name = 'chair_seat_type'
)
INSERT INTO attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier)
SELECT 
  gen_random_uuid(),
  chair_seat_type_attr.id,
  vals.value,
  vals.display_name,
  vals.sort_order,
  vals.price_modifier
FROM chair_seat_type_attr
CROSS JOIN (VALUES
  ('cushioned', 'Cushioned', 1, 2000),
  ('hard', 'Hard Seat', 2, 0),
  ('woven', 'Woven', 3, 1500),
  ('upholstered', 'Upholstered', 4, 3000)
) AS vals(value, display_name, sort_order, price_modifier);

-- Ottoman Shape
WITH ottoman_shape_attr AS (
  SELECT id FROM attribute_types WHERE name = 'ottoman_shape'
)
INSERT INTO attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier)
SELECT 
  gen_random_uuid(),
  ottoman_shape_attr.id,
  vals.value,
  vals.display_name,
  vals.sort_order,
  vals.price_modifier
FROM ottoman_shape_attr
CROSS JOIN (VALUES
  ('square', 'Square', 1, 0),
  ('rectangular', 'Rectangular', 2, 1000),
  ('round', 'Round', 3, 500),
  ('oval', 'Oval', 4, 1500)
) AS vals(value, display_name, sort_order, price_modifier);

-- Recliner Type
WITH recliner_type_attr AS (
  SELECT id FROM attribute_types WHERE name = 'recliner_type'
)
INSERT INTO attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier)
SELECT 
  gen_random_uuid(),
  recliner_type_attr.id,
  vals.value,
  vals.display_name,
  vals.sort_order,
  vals.price_modifier
FROM recliner_type_attr
CROSS JOIN (VALUES
  ('manual', 'Manual Recliner', 1, 0),
  ('power', 'Power Recliner', 2, 15000),
  ('zero_gravity', 'Zero Gravity', 3, 25000),
  ('massage', 'Massage Recliner', 4, 35000)
) AS vals(value, display_name, sort_order, price_modifier);

-- Theater Seating Type
WITH theater_seating_type_attr AS (
  SELECT id FROM attribute_types WHERE name = 'theater_seating_type'
)
INSERT INTO attribute_values (id, attribute_type_id, value, display_name, sort_order, price_modifier)
SELECT 
  gen_random_uuid(),
  theater_seating_type_attr.id,
  vals.value,
  vals.display_name,
  vals.sort_order,
  vals.price_modifier
FROM theater_seating_type_attr
CROSS JOIN (VALUES
  ('single_seat', 'Single Seat', 1, 0),
  ('double_seat', 'Double Seat', 2, 8000),
  ('triple_seat', 'Triple Seat', 3, 15000),
  ('four_seat', 'Four Seat', 4, 22000)
) AS vals(value, display_name, sort_order, price_modifier);

-- Now add furniture models for each empty category

-- BED COTS
WITH bed_cots_category AS (
  SELECT id FROM categories WHERE UPPER(name) = 'BED COTS'
)
INSERT INTO furniture_models (id, category_id, name, slug, description, base_price, is_featured)
SELECT 
  gen_random_uuid(),
  bed_cots_category.id,
  models.name,
  models.slug,
  models.description,
  models.base_price,
  models.is_featured
FROM bed_cots_category
CROSS JOIN (VALUES
  ('Classic Wooden Bed Cot', 'classic-wooden-bed-cot', 'A timeless wooden bed cot with elegant design and sturdy construction', 25000, true),
  ('Modern Platform Bed Cot', 'modern-platform-bed-cot', 'Minimalist platform bed with clean lines and contemporary appeal', 32000, false),
  ('Storage Bed Cot with Drawers', 'storage-bed-cot-drawers', 'Practical bed cot with built-in storage drawers for extra space', 38000, false),
  ('Upholstered Bed Cot', 'upholstered-bed-cot', 'Luxurious upholstered bed cot with premium fabric finish', 42000, false),
  ('Hydraulic Storage Bed Cot', 'hydraulic-storage-bed-cot', 'Advanced hydraulic storage system for maximum space utilization', 45000, false),
  ('Tufted Headrest Bed Cot', 'tufted-headrest-bed-cot', 'Elegant tufted headrest design with premium comfort', 35000, false),
  ('Wooden Panel Bed Cot', 'wooden-panel-bed-cot', 'Natural wood panel design with rustic charm', 28000, false),
  ('Metal Frame Bed Cot', 'metal-frame-bed-cot', 'Durable metal frame construction with modern aesthetics', 22000, false),
  ('Queen Size Luxury Bed Cot', 'queen-size-luxury-bed-cot', 'Spacious queen size bed cot with luxury features', 48000, false),
  ('King Size Premium Bed Cot', 'king-size-premium-bed-cot', 'Premium king size bed cot for ultimate comfort', 55000, false),
  ('Compact Single Bed Cot', 'compact-single-bed-cot', 'Space-saving single bed cot perfect for small rooms', 18000, false)
) AS models(name, slug, description, base_price, is_featured);

-- BED HEADREST
WITH bed_headrest_category AS (
  SELECT id FROM categories WHERE UPPER(name) = 'BED HEADREST'
)
INSERT INTO furniture_models (id, category_id, name, slug, description, base_price, is_featured)
SELECT 
  gen_random_uuid(),
  bed_headrest_category.id,
  models.name,
  models.slug,
  models.description,
  models.base_price,
  models.is_featured
FROM bed_headrest_category
CROSS JOIN (VALUES
  ('Tufted Leather Headrest', 'tufted-leather-headrest', 'Luxurious leather headrest with elegant button tufting', 15000, true),
  ('Wooden Panel Headrest', 'wooden-panel-headrest', 'Natural wood panel headrest with contemporary design', 10000, false),
  ('Upholstered Fabric Headrest', 'upholstered-fabric-headrest', 'Soft fabric upholstered headrest for comfort', 12000, false),
  ('Metal Frame Headrest', 'metal-frame-headrest', 'Modern metal frame headrest with sleek finish', 8000, false),
  ('Carved Wooden Headrest', 'carved-wooden-headrest', 'Intricately carved wooden headrest with artistic details', 18000, false),
  ('Quilted Velvet Headrest', 'quilted-velvet-headrest', 'Premium velvet quilted headrest for luxury feel', 20000, false),
  ('Minimalist Panel Headrest', 'minimalist-panel-headrest', 'Clean minimalist design with simple lines', 9000, false),
  ('Vintage Style Headrest', 'vintage-style-headrest', 'Classic vintage design with timeless appeal', 14000, false),
  ('Modern Geometric Headrest', 'modern-geometric-headrest', 'Contemporary geometric pattern headrest', 16000, false),
  ('Rustic Wood Headrest', 'rustic-wood-headrest', 'Rustic reclaimed wood headrest with character', 13000, false)
) AS models(name, slug, description, base_price, is_featured);

-- BED MATTRESS
WITH bed_mattress_category AS (
  SELECT id FROM categories WHERE UPPER(name) = 'BED MATTRESS'
)
INSERT INTO furniture_models (id, category_id, name, slug, description, base_price, is_featured)
SELECT 
  gen_random_uuid(),
  bed_mattress_category.id,
  models.name,
  models.slug,
  models.description,
  models.base_price,
  models.is_featured
FROM bed_mattress_category
CROSS JOIN (VALUES
  ('Memory Foam Mattress', 'memory-foam-mattress', 'Premium memory foam mattress for perfect body contouring', 25000, true),
  ('Spring Mattress Classic', 'spring-mattress-classic', 'Traditional spring mattress with excellent support', 15000, false),
  ('Latex Natural Mattress', 'latex-natural-mattress', 'Natural latex mattress with organic materials', 35000, false),
  ('Hybrid Comfort Mattress', 'hybrid-comfort-mattress', 'Hybrid design combining springs and foam layers', 40000, false),
  ('Orthopedic Support Mattress', 'orthopedic-support-mattress', 'Orthopedic mattress for spinal alignment and health', 45000, false),
  ('Cooling Gel Mattress', 'cooling-gel-mattress', 'Advanced cooling gel technology for temperature regulation', 38000, false),
  ('Firm Support Mattress', 'firm-support-mattress', 'Extra firm mattress for strong back support', 28000, false),
  ('Plush Comfort Mattress', 'plush-comfort-mattress', 'Soft plush mattress for cloud-like comfort', 32000, false),
  ('Pocket Spring Mattress', 'pocket-spring-mattress', 'Individual pocket springs for motion isolation', 42000, false),
  ('Bamboo Fiber Mattress', 'bamboo-fiber-mattress', 'Eco-friendly bamboo fiber mattress with natural properties', 30000, false)
) AS models(name, slug, description, base_price, is_featured);

-- BENCH
WITH bench_category AS (
  SELECT id FROM categories WHERE UPPER(name) = 'BENCH'
)
INSERT INTO furniture_models (id, category_id, name, slug, description, base_price, is_featured)
SELECT 
  gen_random_uuid(),
  bench_category.id,
  models.name,
  models.slug,
  models.description,
  models.base_price,
  models.is_featured
FROM bench_category
CROSS JOIN (VALUES
  ('Wooden Garden Bench', 'wooden-garden-bench', 'Classic wooden bench perfect for gardens and outdoor spaces', 12000, true),
  ('Upholstered Dining Bench', 'upholstered-dining-bench', 'Comfortable upholstered bench for dining areas', 15000, false),
  ('Storage Bench Ottoman', 'storage-bench-ottoman', 'Multi-functional bench with hidden storage compartment', 18000, false),
  ('Metal Frame Bench', 'metal-frame-bench', 'Durable metal frame bench with modern industrial look', 10000, false),
  ('Leather Accent Bench', 'leather-accent-bench', 'Premium leather bench for elegant accent seating', 22000, false),
  ('Rustic Wooden Bench', 'rustic-wooden-bench', 'Rustic style wooden bench with natural finish', 14000, false),
  ('Tufted Velvet Bench', 'tufted-velvet-bench', 'Luxurious tufted velvet bench for bedroom or entryway', 20000, false),
  ('Minimalist Modern Bench', 'minimalist-modern-bench', 'Clean modern design bench with sleek lines', 16000, false),
  ('Vintage Style Bench', 'vintage-style-bench', 'Antique-inspired bench with classic charm', 19000, false),
  ('Outdoor Weather Bench', 'outdoor-weather-bench', 'Weather-resistant bench for outdoor use', 13000, false)
) AS models(name, slug, description, base_price, is_featured);

-- DINING CHAIR
WITH dining_chair_category AS (
  SELECT id FROM categories WHERE UPPER(name) = 'DINING CHAIR'
)
INSERT INTO furniture_models (id, category_id, name, slug, description, base_price, is_featured)
SELECT 
  gen_random_uuid(),
  dining_chair_category.id,
  models.name,
  models.slug,
  models.description,
  models.base_price,
  models.is_featured
FROM dining_chair_category
CROSS JOIN (VALUES
  ('Classic Wooden Dining Chair', 'classic-wooden-dining-chair', 'Traditional wooden dining chair with comfortable seat', 8000, true),
  ('Upholstered Dining Chair', 'upholstered-dining-chair', 'Comfortable upholstered dining chair with premium fabric', 12000, false),
  ('Modern Metal Dining Chair', 'modern-metal-dining-chair', 'Contemporary metal frame dining chair', 7000, false),
  ('Leather Dining Chair', 'leather-dining-chair', 'Premium leather dining chair for elegant dining', 15000, false),
  ('Woven Seat Dining Chair', 'woven-seat-dining-chair', 'Traditional woven seat chair with natural materials', 6000, false),
  ('High Back Dining Chair', 'high-back-dining-chair', 'High back dining chair for extra support and comfort', 10000, false),
  ('Scandinavian Style Chair', 'scandinavian-style-chair', 'Minimalist Scandinavian design dining chair', 9000, false),
  ('Vintage Dining Chair', 'vintage-dining-chair', 'Classic vintage style dining chair with character', 11000, false),
  ('Ergonomic Dining Chair', 'ergonomic-dining-chair', 'Ergonomically designed chair for long sitting comfort', 13000, false),
  ('Folding Dining Chair', 'folding-dining-chair', 'Space-saving folding dining chair for flexible use', 5000, false)
) AS models(name, slug, description, base_price, is_featured);

-- HOME THEATER
WITH home_theater_category AS (
  SELECT id FROM categories WHERE UPPER(name) = 'HOME THEATER'
)
INSERT INTO furniture_models (id, category_id, name, slug, description, base_price, is_featured)
SELECT 
  gen_random_uuid(),
  home_theater_category.id,
  models.name,
  models.slug,
  models.description,
  models.base_price,
  models.is_featured
FROM home_theater_category
CROSS JOIN (VALUES
  ('Luxury Recliner Theater Seat', 'luxury-recliner-theater-seat', 'Premium reclining theater seat with cup holders', 45000, true),
  ('Power Reclining Theater Row', 'power-reclining-theater-row', 'Electric power reclining theater seating for 2', 85000, false),
  ('Leather Theater Seating', 'leather-theater-seating', 'Genuine leather theater seating with premium comfort', 95000, false),
  ('Home Cinema Sofa', 'home-cinema-sofa', 'Comfortable sofa designed specifically for home cinema', 65000, false),
  ('Theater Sectional Seating', 'theater-sectional-seating', 'Large sectional seating perfect for family movie nights', 120000, false),
  ('Massage Theater Chair', 'massage-theater-chair', 'Theater chair with built-in massage functionality', 75000, false),
  ('Zero Gravity Theater Seat', 'zero-gravity-theater-seat', 'Advanced zero gravity positioning for ultimate comfort', 110000, false),
  ('Heated Theater Seating', 'heated-theater-seating', 'Theater seating with heating elements for luxury', 80000, false),
  ('Swivel Theater Chair', 'swivel-theater-chair', 'Swivel base theater chair for flexible viewing', 55000, false),
  ('LED Accent Theater Seat', 'led-accent-theater-seat', 'Theater seat with LED accent lighting', 60000, false)
) AS models(name, slug, description, base_price, is_featured);

-- KIDS BED
WITH kids_bed_category AS (
  SELECT id FROM categories WHERE UPPER(name) = 'KIDS BED'
)
INSERT INTO furniture_models (id, category_id, name, slug, description, base_price, is_featured)
SELECT 
  gen_random_uuid(),
  kids_bed_category.id,
  models.name,
  models.slug,
  models.description,
  models.base_price,
  models.is_featured
FROM kids_bed_category
CROSS JOIN (VALUES
  ('Car Shaped Kids Bed', 'car-shaped-kids-bed', 'Fun car-shaped bed that kids will love', 20000, true),
  ('Princess Castle Bed', 'princess-castle-bed', 'Magical princess castle bed for little princesses', 25000, false),
  ('Bunk Bed for Kids', 'bunk-bed-kids', 'Space-saving bunk bed perfect for siblings', 35000, false),
  ('Storage Kids Bed', 'storage-kids-bed', 'Kids bed with built-in storage drawers', 22000, false),
  ('Themed Superhero Bed', 'themed-superhero-bed', 'Superhero themed bed for adventure lovers', 24000, false),
  ('Convertible Toddler Bed', 'convertible-toddler-bed', 'Grows with your child from toddler to teen', 18000, false),
  ('Loft Bed with Desk', 'loft-bed-with-desk', 'Loft bed with study desk underneath', 30000, false),
  ('Wooden Kids Single Bed', 'wooden-kids-single-bed', 'Classic wooden single bed in kid-friendly size', 15000, false),
  ('Tent Style Kids Bed', 'tent-style-kids-bed', 'Adventure tent-style bed for imaginative play', 21000, false),
  ('Safety Rail Kids Bed', 'safety-rail-kids-bed', 'Safe kids bed with protective rails', 17000, false)
) AS models(name, slug, description, base_price, is_featured);

-- OTTOMAN
WITH ottoman_category AS (
  SELECT id FROM categories WHERE UPPER(name) = 'OTTOMAN'
)
INSERT INTO furniture_models (id, category_id, name, slug, description, base_price, is_featured)
SELECT 
  gen_random_uuid(),
  ottoman_category.id,
  models.name,
  models.slug,
  models.description,
  models.base_price,
  models.is_featured
FROM ottoman_category
CROSS JOIN (VALUES
  ('Storage Ottoman Square', 'storage-ottoman-square', 'Square ottoman with hidden storage compartment', 8000, true),
  ('Round Velvet Ottoman', 'round-velvet-ottoman', 'Luxurious round velvet ottoman for accent seating', 10000, false),
  ('Leather Ottoman Classic', 'leather-ottoman-classic', 'Classic leather ottoman with timeless appeal', 12000, false),
  ('Rectangular Storage Ottoman', 'rectangular-storage-ottoman', 'Large rectangular ottoman with ample storage', 15000, false),
  ('Tufted Button Ottoman', 'tufted-button-ottoman', 'Elegant tufted ottoman with button details', 9000, false),
  ('Modern Fabric Ottoman', 'modern-fabric-ottoman', 'Contemporary fabric ottoman in modern design', 7000, false),
  ('Ottoman Coffee Table', 'ottoman-coffee-table', 'Multi-functional ottoman that doubles as coffee table', 14000, false),
  ('Vintage Style Ottoman', 'vintage-style-ottoman', 'Antique-inspired ottoman with classic charm', 11000, false),
  ('Oval Shaped Ottoman', 'oval-shaped-ottoman', 'Unique oval-shaped ottoman for distinctive style', 13000, false),
  ('Bench Style Ottoman', 'bench-style-ottoman', 'Long bench-style ottoman for versatile seating', 16000, false)
) AS models(name, slug, description, base_price, is_featured);

-- PUFFEE
WITH puffee_category AS (
  SELECT id FROM categories WHERE UPPER(name) = 'PUFFEE'
)
INSERT INTO furniture_models (id, category_id, name, slug, description, base_price, is_featured)
SELECT 
  gen_random_uuid(),
  puffee_category.id,
  models.name,
  models.slug,
  models.description,
  models.base_price,
  models.is_featured
FROM puffee_category
CROSS JOIN (VALUES
  ('Bean Bag Puffee Large', 'bean-bag-puffee-large', 'Large comfortable bean bag perfect for lounging', 6000, true),
  ('Leather Puffee Ottoman', 'leather-puffee-ottoman', 'Premium leather puffee for luxury comfort', 12000, false),
  ('Fabric Puffee Round', 'fabric-puffee-round', 'Soft fabric round puffee for casual seating', 5000, false),
  ('XXL Bean Bag Puffee', 'xxl-bean-bag-puffee', 'Extra large bean bag for maximum comfort', 8000, false),
  ('Kids Puffee Colorful', 'kids-puffee-colorful', 'Colorful puffee designed specifically for children', 4000, false),
  ('Memory Foam Puffee', 'memory-foam-puffee', 'Memory foam filled puffee for superior comfort', 10000, false),
  ('Outdoor Puffee Waterproof', 'outdoor-puffee-waterproof', 'Weather-resistant puffee for outdoor use', 7000, false),
  ('Velvet Puffee Luxury', 'velvet-puffee-luxury', 'Luxurious velvet puffee with elegant finish', 9000, false),
  ('Gaming Puffee Chair', 'gaming-puffee-chair', 'Ergonomic puffee designed for gaming comfort', 11000, false),
  ('Moroccan Style Puffee', 'moroccan-style-puffee', 'Traditional Moroccan style puffee with ethnic design', 8500, false)
) AS models(name, slug, description, base_price, is_featured);

-- RECLINER
WITH recliner_category AS (
  SELECT id FROM categories WHERE UPPER(name) = 'RECLINER'
)
INSERT INTO furniture_models (id, category_id, name, slug, description, base_price, is_featured)
SELECT 
  gen_random_uuid(),
  recliner_category.id,
  models.name,
  models.slug,
  models.description,
  models.base_price,
  models.is_featured
FROM recliner_category
CROSS JOIN (VALUES
  ('Power Recliner Luxury', 'power-recliner-luxury', 'Electric power recliner with premium features', 45000, true),
  ('Manual Recliner Classic', 'manual-recliner-classic', 'Traditional manual recliner with comfortable padding', 25000, false),
  ('Zero Gravity Recliner', 'zero-gravity-recliner', 'Advanced zero gravity recliner for ultimate relaxation', 65000, false),
  ('Massage Recliner Chair', 'massage-recliner-chair', 'Recliner with built-in massage functionality', 75000, false),
  ('Leather Recliner Premium', 'leather-recliner-premium', 'Premium leather recliner with elegant design', 55000, false),
  ('Fabric Recliner Comfort', 'fabric-recliner-comfort', 'Comfortable fabric recliner for daily use', 35000, false),
  ('Rocker Recliner Chair', 'rocker-recliner-chair', 'Recliner with gentle rocking motion', 40000, false),
  ('Heated Recliner Luxury', 'heated-recliner-luxury', 'Luxury recliner with heating elements', 60000, false),
  ('Swivel Recliner Modern', 'swivel-recliner-modern', 'Modern recliner with 360-degree swivel base', 50000, false),
  ('Compact Recliner Small', 'compact-recliner-small', 'Space-saving compact recliner for smaller rooms', 30000, false)
) AS models(name, slug, description, base_price, is_featured);

-- SOFA CUM BED
WITH sofa_cum_bed_category AS (
  SELECT id FROM categories WHERE UPPER(name) = 'SOFA CUM BED'
)
INSERT INTO furniture_models (id, category_id, name, slug, description, base_price, is_featured)
SELECT 
  gen_random_uuid(),
  sofa_cum_bed_category.id,
  models.name,
  models.slug,
  models.description,
  models.base_price,
  models.is_featured
FROM sofa_cum_bed_category
CROSS JOIN (VALUES
  ('Convertible Sofa Bed', 'convertible-sofa-bed', 'Easy-to-convert sofa bed for guests and daily use', 35000, true),
  ('Storage Sofa Cum Bed', 'storage-sofa-cum-bed', 'Sofa bed with built-in storage compartments', 42000, false),
  ('L-Shaped Sofa Bed', 'l-shaped-sofa-bed', 'L-shaped sectional that converts to a bed', 55000, false),
  ('Fabric Sofa Cum Bed', 'fabric-sofa-cum-bed', 'Comfortable fabric sofa with easy bed conversion', 38000, false),
  ('Leather Sofa Bed Luxury', 'leather-sofa-bed-luxury', 'Premium leather sofa bed with luxury features', 65000, false),
  ('Pull-Out Sofa Bed', 'pull-out-sofa-bed', 'Traditional pull-out sofa bed mechanism', 32000, false),
  ('Futon Sofa Bed Modern', 'futon-sofa-bed-modern', 'Modern futon-style sofa bed with sleek design', 28000, false),
  ('Click-Clack Sofa Bed', 'click-clack-sofa-bed', 'Easy click-clack mechanism sofa bed', 30000, false),
  ('Memory Foam Sofa Bed', 'memory-foam-sofa-bed', 'Sofa bed with memory foam mattress for comfort', 48000, false),
  ('Compact Sofa Bed Small', 'compact-sofa-bed-small', 'Space-saving compact sofa bed for small spaces', 25000, false)
) AS models(name, slug, description, base_price, is_featured);

-- SOFA ECONOMY
WITH sofa_economy_category AS (
  SELECT id FROM categories WHERE UPPER(name) = 'SOFA ECONOMY'
)
INSERT INTO furniture_models (id, category_id, name, slug, description, base_price, is_featured)
SELECT 
  gen_random_uuid(),
  sofa_economy_category.id,
  models.name,
  models.slug,
  models.description,
  models.base_price,
  models.is_featured
FROM sofa_economy_category
CROSS JOIN (VALUES
  ('Budget Fabric Sofa', 'budget-fabric-sofa', 'Affordable fabric sofa with good quality and comfort', 15000, true),
  ('Simple 2-Seater Sofa', 'simple-2-seater-sofa', 'Basic 2-seater sofa perfect for small spaces', 12000, false),
  ('Economy 3-Seater Sofa', 'economy-3-seater-sofa', 'Value-for-money 3-seater sofa for families', 18000, false),
  ('Compact Loveseat Sofa', 'compact-loveseat-sofa', 'Small loveseat perfect for apartments', 10000, false),
  ('Basic Sectional Sofa', 'basic-sectional-sofa', 'Affordable sectional sofa with modular design', 22000, false),
  ('Student Sofa Budget', 'student-sofa-budget', 'Budget-friendly sofa perfect for students', 8000, false),
  ('Starter Home Sofa', 'starter-home-sofa', 'Ideal sofa for first-time home buyers', 14000, false),
  ('Minimalist Sofa Simple', 'minimalist-sofa-simple', 'Simple minimalist design at economy price', 16000, false),
  ('Apartment Size Sofa', 'apartment-size-sofa', 'Perfect size sofa for apartment living', 13000, false),
  ('Value Pack Sofa Set', 'value-pack-sofa-set', 'Complete sofa set at unbeatable value', 20000, false)
) AS models(name, slug, description, base_price, is_featured);

-- Now create model_attributes relationships for all new models
-- We'll link each model to relevant attributes

-- Get attribute type IDs
WITH attr_ids AS (
  SELECT 
    id as color_id, 'color' as attr_name
  FROM attribute_types WHERE name = 'color'
  UNION ALL
  SELECT 
    id as material_id, 'material' as attr_name
  FROM attribute_types WHERE name = 'material'
  UNION ALL
  SELECT 
    id as size_id, 'size' as attr_name
  FROM attribute_types WHERE name = 'size'
),
-- Get all new models
new_models AS (
  SELECT 
    fm.id as model_id,
    c.name as category_name
  FROM furniture_models fm
  JOIN categories c ON fm.category_id = c.id
  WHERE UPPER(c.name) IN ('BED COTS', 'BED HEADREST', 'BED MATTRESS', 'BENCH', 'DINING CHAIR', 'HOME THEATER', 'KIDS BED', 'OTTOMAN', 'PUFFEE', 'RECLINER', 'SOFA CUM BED', 'SOFA ECONOMY')
),
-- Get attribute type IDs for basic attributes
basic_attrs AS (
  SELECT id FROM attribute_types WHERE name IN ('color', 'material', 'size')
)
INSERT INTO model_attributes (id, model_id, attribute_type_id, is_required)
SELECT 
  gen_random_uuid(),
  nm.model_id,
  ba.id,
  true
FROM new_models nm
CROSS JOIN basic_attrs ba;

-- Add category-specific attributes for BED COTS
WITH bed_cots_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN categories c ON fm.category_id = c.id
  WHERE UPPER(c.name) = 'BED COTS'
),
bed_specific_attrs AS (
  SELECT id FROM attribute_types WHERE name IN ('bed_size', 'storage_type_bed', 'headrest_type_bed')
)
INSERT INTO model_attributes (id, model_id, attribute_type_id, is_required)
SELECT 
  gen_random_uuid(),
  bcm.model_id,
  bsa.id,
  true
FROM bed_cots_models bcm
CROSS JOIN bed_specific_attrs bsa;

-- Add category-specific attributes for RECLINER
WITH recliner_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN categories c ON fm.category_id = c.id
  WHERE UPPER(c.name) = 'RECLINER'
),
recliner_specific_attrs AS (
  SELECT id FROM attribute_types WHERE name IN ('recliner_type')
)
INSERT INTO model_attributes (id, model_id, attribute_type_id, is_required)
SELECT 
  gen_random_uuid(),
  rm.model_id,
  rsa.id,
  true
FROM recliner_models rm
CROSS JOIN recliner_specific_attrs rsa;

-- Add category-specific attributes for HOME THEATER
WITH theater_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN categories c ON fm.category_id = c.id
  WHERE UPPER(c.name) = 'HOME THEATER'
),
theater_specific_attrs AS (
  SELECT id FROM attribute_types WHERE name IN ('theater_seating_type')
)
INSERT INTO model_attributes (id, model_id, attribute_type_id, is_required)
SELECT 
  gen_random_uuid(),
  tm.model_id,
  tsa.id,
  true
FROM theater_models tm
CROSS JOIN theater_specific_attrs tsa;

-- Add category-specific attributes for OTTOMAN
WITH ottoman_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN categories c ON fm.category_id = c.id
  WHERE UPPER(c.name) = 'OTTOMAN'
),
ottoman_specific_attrs AS (
  SELECT id FROM attribute_types WHERE name IN ('ottoman_shape', 'storage_ottoman_bed_cot')
)
INSERT INTO model_attributes (id, model_id, attribute_type_id, is_required)
SELECT 
  gen_random_uuid(),
  om.model_id,
  osa.id,
  true
FROM ottoman_models om
CROSS JOIN ottoman_specific_attrs osa;

-- Add category-specific attributes for BENCH
WITH bench_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN categories c ON fm.category_id = c.id
  WHERE UPPER(c.name) = 'BENCH'
),
bench_specific_attrs AS (
  SELECT id FROM attribute_types WHERE name IN ('bench_length')
)
INSERT INTO model_attributes (id, model_id, attribute_type_id, is_required)
SELECT 
  gen_random_uuid(),
  bm.model_id,
  bsa.id,
  true
FROM bench_models bm
CROSS JOIN bench_specific_attrs bsa;

-- Add category-specific attributes for DINING CHAIR
WITH chair_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN categories c ON fm.category_id = c.id
  WHERE UPPER(c.name) = 'DINING CHAIR'
),
chair_specific_attrs AS (
  SELECT id FROM attribute_types WHERE name IN ('chair_seat_type')
)
INSERT INTO model_attributes (id, model_id, attribute_type_id, is_required)
SELECT 
  gen_random_uuid(),
  cm.model_id,
  csa.id,
  true
FROM chair_models cm
CROSS JOIN chair_specific_attrs csa;

-- Add category-specific attributes for BED MATTRESS
WITH mattress_models AS (
  SELECT fm.id as model_id
  FROM furniture_models fm
  JOIN categories c ON fm.category_id = c.id
  WHERE UPPER(c.name) = 'BED MATTRESS'
),
mattress_specific_attrs AS (
  SELECT id FROM attribute_types WHERE name IN ('mattress_type', 'bed_size')
)
INSERT INTO model_attributes (id, model_id, attribute_type_id, is_required)
SELECT 
  gen_random_uuid(),
  mm.model_id,
  msa.id,
  true
FROM mattress_models mm
CROSS JOIN mattress_specific_attrs msa;