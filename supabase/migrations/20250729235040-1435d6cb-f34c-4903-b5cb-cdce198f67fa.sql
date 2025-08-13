-- Create categories table
CREATE TABLE public.categories (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE,
  description TEXT,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create furniture_models table
CREATE TABLE public.furniture_models (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  category_id UUID NOT NULL REFERENCES public.categories(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT,
  base_price DECIMAL(10,2) NOT NULL DEFAULT 0,
  default_image_url TEXT,
  is_featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create attribute_types table (color, fabric, size, etc.)
CREATE TABLE public.attribute_types (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  display_name TEXT NOT NULL,
  input_type TEXT NOT NULL DEFAULT 'select', -- select, color, range
  is_required BOOLEAN DEFAULT false,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create attribute_values table (specific values for each attribute type)
CREATE TABLE public.attribute_values (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  attribute_type_id UUID NOT NULL REFERENCES public.attribute_types(id) ON DELETE CASCADE,
  value TEXT NOT NULL,
  display_name TEXT NOT NULL,
  hex_color TEXT, -- for color attributes
  price_modifier DECIMAL(8,2) DEFAULT 0,
  image_suffix TEXT, -- for image naming convention
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create model_attributes table (which attributes are available for each model)
CREATE TABLE public.model_attributes (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  model_id UUID NOT NULL REFERENCES public.furniture_models(id) ON DELETE CASCADE,
  attribute_type_id UUID NOT NULL REFERENCES public.attribute_types(id) ON DELETE CASCADE,
  is_required BOOLEAN DEFAULT false,
  default_value_id UUID REFERENCES public.attribute_values(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(model_id, attribute_type_id)
);

-- Create attribute_dependencies table (conditional attributes)
CREATE TABLE public.attribute_dependencies (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  model_id UUID NOT NULL REFERENCES public.furniture_models(id) ON DELETE CASCADE,
  dependent_attribute_id UUID NOT NULL REFERENCES public.attribute_types(id) ON DELETE CASCADE,
  required_attribute_id UUID NOT NULL REFERENCES public.attribute_types(id) ON DELETE CASCADE,
  required_value_id UUID NOT NULL REFERENCES public.attribute_values(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.furniture_models ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attribute_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attribute_values ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.model_attributes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attribute_dependencies ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access (no authentication required)
CREATE POLICY "Public read access for categories" ON public.categories FOR SELECT USING (true);
CREATE POLICY "Public read access for furniture_models" ON public.furniture_models FOR SELECT USING (true);
CREATE POLICY "Public read access for attribute_types" ON public.attribute_types FOR SELECT USING (true);
CREATE POLICY "Public read access for attribute_values" ON public.attribute_values FOR SELECT USING (true);
CREATE POLICY "Public read access for model_attributes" ON public.model_attributes FOR SELECT USING (true);
CREATE POLICY "Public read access for attribute_dependencies" ON public.attribute_dependencies FOR SELECT USING (true);

-- Create function to update timestamps
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for automatic timestamp updates
CREATE TRIGGER update_categories_updated_at
  BEFORE UPDATE ON public.categories
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_furniture_models_updated_at
  BEFORE UPDATE ON public.furniture_models
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- Insert sample data
INSERT INTO public.categories (name, slug, description, image_url) VALUES
('Sofas', 'sofas', 'Comfortable and stylish sofas for every living space', '/src/assets/sofa-product-1.jpg'),
('Chairs', 'chairs', 'Elegant chairs for dining and living rooms', '/src/assets/sofa-product-2.jpg'),
('Tables', 'tables', 'Beautiful tables for any occasion', '/src/assets/hero-luxury-sofa.jpg');

-- Insert attribute types
INSERT INTO public.attribute_types (name, display_name, input_type, is_required, sort_order) VALUES
('fabric', 'Fabric', 'select', true, 1),
('color', 'Color', 'color', true, 2),
('size', 'Size', 'select', true, 3),
('finish', 'Wood Finish', 'select', false, 4),
('cushions', 'Cushion Type', 'select', false, 5);

-- Insert sample furniture models
INSERT INTO public.furniture_models (category_id, name, slug, description, base_price, default_image_url, is_featured)
SELECT 
  c.id,
  'Luxury Sectional Sofa',
  'luxury-sectional-sofa',
  'A premium sectional sofa with customizable fabric and color options',
  2499.00,
  '/src/assets/hero-luxury-sofa.jpg',
  true
FROM public.categories c WHERE c.slug = 'sofas';

INSERT INTO public.furniture_models (category_id, name, slug, description, base_price, default_image_url, is_featured)
SELECT 
  c.id,
  'Modern 3-Seater Sofa',
  'modern-3-seater-sofa',
  'Contemporary design meets comfort in this modern sofa',
  1899.00,
  '/src/assets/sofa-product-1.jpg',
  true
FROM public.categories c WHERE c.slug = 'sofas';

-- Insert attribute values for fabric
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, price_modifier, image_suffix, sort_order)
SELECT 
  at.id,
  'leather',
  'Premium Leather',
  500.00,
  '_leather',
  1
FROM public.attribute_types at WHERE at.name = 'fabric';

INSERT INTO public.attribute_values (attribute_type_id, value, display_name, price_modifier, image_suffix, sort_order)
SELECT 
  at.id,
  'fabric',
  'High-Quality Fabric',
  0.00,
  '_fabric',
  2
FROM public.attribute_types at WHERE at.name = 'fabric';

INSERT INTO public.attribute_values (attribute_type_id, value, display_name, price_modifier, image_suffix, sort_order)
SELECT 
  at.id,
  'velvet',
  'Luxury Velvet',
  300.00,
  '_velvet',
  3
FROM public.attribute_types at WHERE at.name = 'fabric';

-- Insert attribute values for color
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, hex_color, price_modifier, image_suffix, sort_order)
SELECT 
  at.id,
  'charcoal',
  'Charcoal Gray',
  '#36454f',
  0.00,
  '_charcoal',
  1
FROM public.attribute_types at WHERE at.name = 'color';

INSERT INTO public.attribute_values (attribute_type_id, value, display_name, hex_color, price_modifier, image_suffix, sort_order)
SELECT 
  at.id,
  'navy',
  'Navy Blue',
  '#000080',
  0.00,
  '_navy',
  2
FROM public.attribute_types at WHERE at.name = 'color';

INSERT INTO public.attribute_values (attribute_type_id, value, display_name, hex_color, price_modifier, image_suffix, sort_order)
SELECT 
  at.id,
  'cream',
  'Cream White',
  '#f5f5dc',
  0.00,
  '_cream',
  3
FROM public.attribute_types at WHERE at.name = 'color';

-- Insert attribute values for size
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, price_modifier, image_suffix, sort_order)
SELECT 
  at.id,
  'small',
  'Small (2-Seater)',
  -200.00,
  '_small',
  1
FROM public.attribute_types at WHERE at.name = 'size';

INSERT INTO public.attribute_values (attribute_type_id, value, display_name, price_modifier, image_suffix, sort_order)
SELECT 
  at.id,
  'medium',
  'Medium (3-Seater)',
  0.00,
  '_medium',
  2
FROM public.attribute_types at WHERE at.name = 'size';

INSERT INTO public.attribute_values (attribute_type_id, value, display_name, price_modifier, image_suffix, sort_order)
SELECT 
  at.id,
  'large',
  'Large (4-Seater)',
  400.00,
  '_large',
  3
FROM public.attribute_types at WHERE at.name = 'size';