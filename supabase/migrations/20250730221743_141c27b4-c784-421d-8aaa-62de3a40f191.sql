-- Create enum for app roles
CREATE TYPE public.app_role AS ENUM ('customer', 'staff');

-- Create categories table
CREATE TABLE public.categories (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
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
    is_featured BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create attribute_types table
CREATE TABLE public.attribute_types (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    display_name TEXT NOT NULL,
    description TEXT,
    input_type TEXT NOT NULL DEFAULT 'select',
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create attribute_values table
CREATE TABLE public.attribute_values (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    attribute_type_id UUID NOT NULL REFERENCES public.attribute_types(id) ON DELETE CASCADE,
    value TEXT NOT NULL,
    display_name TEXT NOT NULL,
    price_modifier DECIMAL(10,2) NOT NULL DEFAULT 0,
    hex_color TEXT,
    image_url TEXT,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    UNIQUE(attribute_type_id, value)
);

-- Create model_attributes table (junction table)
CREATE TABLE public.model_attributes (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    model_id UUID NOT NULL REFERENCES public.furniture_models(id) ON DELETE CASCADE,
    attribute_type_id UUID NOT NULL REFERENCES public.attribute_types(id) ON DELETE CASCADE,
    default_value_id UUID REFERENCES public.attribute_values(id),
    is_required BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    UNIQUE(model_id, attribute_type_id)
);

-- Create images table
CREATE TABLE public.images (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    filename TEXT NOT NULL,
    storage_path TEXT NOT NULL UNIQUE,
    alt_text TEXT,
    display_order INTEGER NOT NULL DEFAULT 0,
    is_primary BOOLEAN NOT NULL DEFAULT false,
    model_id UUID REFERENCES public.furniture_models(id) ON DELETE CASCADE,
    category_id UUID REFERENCES public.categories(id) ON DELETE CASCADE,
    file_size INTEGER,
    mime_type TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CHECK ((model_id IS NOT NULL) OR (category_id IS NOT NULL))
);

-- Create user_roles table
CREATE TABLE public.user_roles (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role app_role NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    UNIQUE(user_id, role)
);

-- Create image_upload_sessions table
CREATE TABLE public.image_upload_sessions (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    upload_session_id TEXT NOT NULL,
    total_files INTEGER NOT NULL DEFAULT 0,
    completed_files INTEGER NOT NULL DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'pending',
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS on all tables
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.furniture_models ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attribute_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attribute_values ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.model_attributes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.images ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.image_upload_sessions ENABLE ROW LEVEL SECURITY;

-- Create security definer function for role checking
CREATE OR REPLACE FUNCTION public.has_role(_user_id UUID, _role app_role)
RETURNS BOOLEAN
LANGUAGE SQL
STABLE
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.user_roles
    WHERE user_id = _user_id
      AND role = _role
  )
$$;

-- Create RLS policies for public read access (no auth required for browsing)
CREATE POLICY "Anyone can view categories" ON public.categories FOR SELECT USING (true);
CREATE POLICY "Anyone can view furniture models" ON public.furniture_models FOR SELECT USING (true);
CREATE POLICY "Anyone can view attribute types" ON public.attribute_types FOR SELECT USING (true);
CREATE POLICY "Anyone can view attribute values" ON public.attribute_values FOR SELECT USING (true);
CREATE POLICY "Anyone can view model attributes" ON public.model_attributes FOR SELECT USING (true);
CREATE POLICY "Anyone can view images" ON public.images FOR SELECT USING (true);

-- Staff can manage all content
CREATE POLICY "Staff can manage categories" ON public.categories FOR ALL USING (public.has_role(auth.uid(), 'staff'));
CREATE POLICY "Staff can manage furniture models" ON public.furniture_models FOR ALL USING (public.has_role(auth.uid(), 'staff'));
CREATE POLICY "Staff can manage attribute types" ON public.attribute_types FOR ALL USING (public.has_role(auth.uid(), 'staff'));
CREATE POLICY "Staff can manage attribute values" ON public.attribute_values FOR ALL USING (public.has_role(auth.uid(), 'staff'));
CREATE POLICY "Staff can manage model attributes" ON public.model_attributes FOR ALL USING (public.has_role(auth.uid(), 'staff'));
CREATE POLICY "Staff can manage images" ON public.images FOR ALL USING (public.has_role(auth.uid(), 'staff'));

-- User roles policies
CREATE POLICY "Users can view their own roles" ON public.user_roles FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Staff can manage user roles" ON public.user_roles FOR ALL USING (public.has_role(auth.uid(), 'staff'));

-- Image upload sessions policies
CREATE POLICY "Users can manage their own upload sessions" ON public.image_upload_sessions FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Staff can view all upload sessions" ON public.image_upload_sessions FOR SELECT USING (public.has_role(auth.uid(), 'staff'));

-- Create update triggers for updated_at columns
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_furniture_models_updated_at BEFORE UPDATE ON public.furniture_models FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_attribute_types_updated_at BEFORE UPDATE ON public.attribute_types FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_attribute_values_updated_at BEFORE UPDATE ON public.attribute_values FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_model_attributes_updated_at BEFORE UPDATE ON public.model_attributes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_images_updated_at BEFORE UPDATE ON public.images FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_image_upload_sessions_updated_at BEFORE UPDATE ON public.image_upload_sessions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Insert sample data
INSERT INTO public.categories (name, slug, description) VALUES
('Armchairs', 'armchairs', 'Comfortable and stylish armchairs for your living space'),
('Sofas', 'sofas', 'Luxurious sofas that combine comfort with elegant design'),
('Chairs', 'chairs', 'Stylish dining and accent chairs for every room'),
('Tables', 'tables', 'Functional and beautiful tables for dining and living'),
('Storage', 'storage', 'Smart storage solutions with style and functionality'),
('Lighting', 'lighting', 'Elegant lighting fixtures to illuminate your space');

-- Insert attribute types
INSERT INTO public.attribute_types (name, display_name, description, sort_order) VALUES
('color', 'Color', 'Choose your preferred color option', 1),
('material', 'Material', 'Select the material finish', 2),
('size', 'Size', 'Pick the perfect size for your space', 3),
('finish', 'Finish', 'Choose the surface finish', 4),
('style', 'Style', 'Select the design style', 5);

-- Insert attribute values
WITH attribute_lookup AS (
  SELECT id, name FROM public.attribute_types
)
INSERT INTO public.attribute_values (attribute_type_id, value, display_name, price_modifier, hex_color, sort_order)
SELECT 
  al.id,
  data.value,
  data.display_name,
  data.price_modifier,
  data.hex_color,
  data.sort_order
FROM attribute_lookup al
CROSS JOIN (VALUES
  -- Colors
  ('color', 'charcoal', 'Charcoal Gray', 0, '#36454F', 1),
  ('color', 'navy', 'Navy Blue', 0, '#000080', 2),
  ('color', 'cream', 'Cream White', 0, '#F5F5DC', 3),
  ('color', 'sage', 'Sage Green', 50, '#9CAF88', 4),
  ('color', 'burgundy', 'Burgundy Red', 100, '#800020', 5),
  ('color', 'camel', 'Camel Brown', 75, '#C19A6B', 6),
  
  -- Materials
  ('material', 'leather', 'Premium Leather', 300, NULL, 1),
  ('material', 'fabric', 'High-Quality Fabric', 0, NULL, 2),
  ('material', 'velvet', 'Luxury Velvet', 200, NULL, 3),
  ('material', 'linen', 'Natural Linen', 100, NULL, 4),
  ('material', 'wood', 'Solid Wood', 150, NULL, 5),
  ('material', 'metal', 'Premium Metal', 125, NULL, 6),
  
  -- Sizes
  ('size', 'small', 'Small', 0, NULL, 1),
  ('size', 'medium', 'Medium', 100, NULL, 2),
  ('size', 'large', 'Large', 200, NULL, 3),
  ('size', 'xl', 'Extra Large', 300, NULL, 4),
  
  -- Finishes
  ('finish', 'matte', 'Matte Finish', 0, NULL, 1),
  ('finish', 'satin', 'Satin Finish', 50, NULL, 2),
  ('finish', 'gloss', 'High Gloss', 100, NULL, 3),
  ('finish', 'distressed', 'Distressed Finish', 75, NULL, 4),
  ('finish', 'natural', 'Natural Finish', 25, NULL, 5),
  
  -- Styles
  ('style', 'modern', 'Modern', 0, NULL, 1),
  ('style', 'classic', 'Classic', 50, NULL, 2),
  ('style', 'industrial', 'Industrial', 75, NULL, 3),
  ('style', 'minimalist', 'Minimalist', 25, NULL, 4),
  ('style', 'vintage', 'Vintage', 100, NULL, 5)
) AS data(attr_name, value, display_name, price_modifier, hex_color, sort_order)
WHERE al.name = data.attr_name;

-- Insert furniture models
WITH category_lookup AS (
  SELECT id, name FROM public.categories
)
INSERT INTO public.furniture_models (category_id, name, slug, description, base_price, is_featured)
SELECT 
  cl.id,
  data.name,
  data.slug,
  data.description,
  data.base_price,
  data.is_featured
FROM category_lookup cl
CROSS JOIN (VALUES
  -- Armchairs
  ('Armchairs', 'Executive Leather Armchair', 'executive-leather-armchair', 'Premium leather executive armchair with ergonomic design', 1299.99, true),
  ('Armchairs', 'Modern Fabric Armchair', 'modern-fabric-armchair', 'Contemporary fabric armchair perfect for any living space', 899.99, false),
  ('Armchairs', 'Vintage Wing Chair', 'vintage-wing-chair', 'Classic wing-back armchair with timeless appeal', 1099.99, false),
  
  -- Sofas
  ('Sofas', 'Luxury 3-Seater Sofa', 'luxury-3-seater-sofa', 'Spacious and comfortable 3-seater sofa for family gatherings', 2499.99, true),
  ('Sofas', 'Modern Sectional Sofa', 'modern-sectional-sofa', 'L-shaped sectional sofa perfect for large living rooms', 3299.99, true),
  ('Sofas', 'Compact 2-Seater Sofa', 'compact-2-seater-sofa', 'Perfect for smaller spaces without compromising on comfort', 1799.99, false),
  
  -- Chairs
  ('Chairs', 'Dining Chair Set', 'dining-chair-set', 'Set of elegant dining chairs with premium upholstery', 599.99, false),
  ('Chairs', 'Accent Chair', 'accent-chair', 'Statement accent chair to complement your decor', 449.99, false),
  ('Chairs', 'Office Ergonomic Chair', 'office-ergonomic-chair', 'Professional office chair with full ergonomic support', 799.99, true),
  
  -- Tables
  ('Tables', 'Dining Table', 'dining-table', 'Solid wood dining table for family meals', 1299.99, true),
  ('Tables', 'Coffee Table', 'coffee-table', 'Modern coffee table with storage compartments', 699.99, false),
  ('Tables', 'Side Table', 'side-table', 'Compact side table perfect for any room', 299.99, false),
  
  -- Storage
  ('Storage', 'Wardrobe System', 'wardrobe-system', 'Modular wardrobe system with customizable compartments', 1899.99, true),
  ('Storage', 'Bookshelf Unit', 'bookshelf-unit', 'Tall bookshelf unit with adjustable shelves', 799.99, false),
  ('Storage', 'Storage Ottoman', 'storage-ottoman', 'Multi-functional ottoman with hidden storage', 349.99, false),
  
  -- Lighting
  ('Lighting', 'Pendant Light', 'pendant-light', 'Modern pendant light for dining areas', 399.99, false),
  ('Lighting', 'Floor Lamp', 'floor-lamp', 'Elegant floor lamp with adjustable brightness', 499.99, true),
  ('Lighting', 'Table Lamp', 'table-lamp', 'Stylish table lamp for accent lighting', 199.99, false)
) AS data(category_name, name, slug, description, base_price, is_featured)
WHERE cl.name = data.category_name;

-- Create model attributes relationships (every model gets color, material, size)
WITH 
  models AS (SELECT id FROM public.furniture_models),
  color_attr AS (SELECT id FROM public.attribute_types WHERE name = 'color'),
  material_attr AS (SELECT id FROM public.attribute_types WHERE name = 'material'),
  size_attr AS (SELECT id FROM public.attribute_types WHERE name = 'size'),
  charcoal_color AS (SELECT id FROM public.attribute_values WHERE value = 'charcoal'),
  fabric_material AS (SELECT id FROM public.attribute_values WHERE value = 'fabric'),
  medium_size AS (SELECT id FROM public.attribute_values WHERE value = 'medium')
INSERT INTO public.model_attributes (model_id, attribute_type_id, default_value_id, is_required)
SELECT 
  m.id,
  attr.id,
  CASE 
    WHEN attr.id = (SELECT id FROM color_attr) THEN (SELECT id FROM charcoal_color)
    WHEN attr.id = (SELECT id FROM material_attr) THEN (SELECT id FROM fabric_material)
    WHEN attr.id = (SELECT id FROM size_attr) THEN (SELECT id FROM medium_size)
  END,
  true
FROM models m
CROSS JOIN (
  SELECT id FROM color_attr
  UNION ALL
  SELECT id FROM material_attr
  UNION ALL
  SELECT id FROM size_attr
) attr;