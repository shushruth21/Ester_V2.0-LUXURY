-- Remove password_hash column from customers table since we're using Supabase Auth only
ALTER TABLE public.customers DROP COLUMN password_hash;