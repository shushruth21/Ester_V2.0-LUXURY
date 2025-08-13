-- Create storage buckets for furniture images
INSERT INTO storage.buckets (id, name, public) VALUES 
('furniture-images', 'furniture-images', true),
('category-images', 'category-images', true);

-- Create storage policies for furniture images bucket
CREATE POLICY "Public Access for furniture images" ON storage.objects FOR SELECT USING (bucket_id = 'furniture-images');
CREATE POLICY "Allow authenticated uploads for furniture images" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'furniture-images' AND auth.role() = 'authenticated');
CREATE POLICY "Allow authenticated updates for furniture images" ON storage.objects FOR UPDATE USING (bucket_id = 'furniture-images' AND auth.role() = 'authenticated');
CREATE POLICY "Allow authenticated deletes for furniture images" ON storage.objects FOR DELETE USING (bucket_id = 'furniture-images' AND auth.role() = 'authenticated');

-- Create storage policies for category images bucket
CREATE POLICY "Public Access for category images" ON storage.objects FOR SELECT USING (bucket_id = 'category-images');
CREATE POLICY "Allow authenticated uploads for category images" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'category-images' AND auth.role() = 'authenticated');
CREATE POLICY "Allow authenticated updates for category images" ON storage.objects FOR UPDATE USING (bucket_id = 'category-images' AND auth.role() = 'authenticated');
CREATE POLICY "Allow authenticated deletes for category images" ON storage.objects FOR DELETE USING (bucket_id = 'category-images' AND auth.role() = 'authenticated');

-- Create images table for managing multiple images per product
CREATE TABLE public.images (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    filename TEXT NOT NULL,
    storage_path TEXT NOT NULL,
    alt_text TEXT,
    display_order INTEGER DEFAULT 0,
    is_primary BOOLEAN DEFAULT false,
    model_id UUID REFERENCES public.furniture_models(id) ON DELETE CASCADE,
    category_id UUID REFERENCES public.categories(id) ON DELETE CASCADE,
    file_size INTEGER,
    mime_type TEXT,
    width INTEGER,
    height INTEGER,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT images_model_or_category_check CHECK (
        (model_id IS NOT NULL AND category_id IS NULL) OR 
        (model_id IS NULL AND category_id IS NOT NULL)
    )
);

-- Enable RLS on images table
ALTER TABLE public.images ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for images
CREATE POLICY "Public read access for images" ON public.images FOR SELECT USING (true);
CREATE POLICY "Allow authenticated users to manage images" ON public.images FOR ALL USING (auth.role() = 'authenticated');

-- Create indexes for better performance
CREATE INDEX idx_images_model_id ON public.images(model_id);
CREATE INDEX idx_images_category_id ON public.images(category_id);
CREATE INDEX idx_images_display_order ON public.images(display_order);
CREATE INDEX idx_images_is_primary ON public.images(is_primary);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_images_updated_at
    BEFORE UPDATE ON public.images
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- Create image_uploads table for tracking upload sessions
CREATE TABLE public.image_uploads (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL,
    upload_session_id TEXT NOT NULL,
    total_files INTEGER NOT NULL DEFAULT 0,
    completed_files INTEGER NOT NULL DEFAULT 0,
    failed_files INTEGER NOT NULL DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS on image_uploads table
ALTER TABLE public.image_uploads ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for image_uploads
CREATE POLICY "Users can manage their own uploads" ON public.image_uploads FOR ALL USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_image_uploads_updated_at
    BEFORE UPDATE ON public.image_uploads
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();