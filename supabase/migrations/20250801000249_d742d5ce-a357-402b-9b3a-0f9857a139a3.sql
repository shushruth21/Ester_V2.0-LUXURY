-- Fix the customer record with proper name
UPDATE public.customers 
SET full_name = 'Sushruth Estre'
WHERE email = 'sushruth@estre.in' AND full_name = 'Ghost';