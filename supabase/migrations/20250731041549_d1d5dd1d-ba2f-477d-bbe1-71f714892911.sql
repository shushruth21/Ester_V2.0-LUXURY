-- Move all models from the typo category to the correct category
UPDATE public.furniture_models 
SET category_id = (SELECT id FROM public.categories WHERE slug = 'dining-chair')
WHERE category_id = (SELECT id FROM public.categories WHERE slug = 'dinning-chair');

-- Delete the typo category
DELETE FROM public.categories WHERE slug = 'dinning-chair';