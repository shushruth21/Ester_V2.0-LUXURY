-- Fix the category slug typo from "dinning-chair" to "dining-chair"
UPDATE public.categories 
SET slug = 'dining-chair' 
WHERE slug = 'dinning-chair';