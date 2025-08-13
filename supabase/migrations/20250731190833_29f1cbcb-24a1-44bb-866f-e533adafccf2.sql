-- Add user_id column to staff table to link with Supabase auth users
ALTER TABLE public.staff ADD COLUMN user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

-- Create a proper Supabase auth user for staff and link it to existing staff record
-- First, we need to update the staff table to allow the email to be used for auth
-- Insert a staff user record that will be linked after Supabase auth user creation
UPDATE public.staff 
SET user_id = NULL 
WHERE email = 'staff@estre.in';

-- Update RLS policies to use user_id instead of id for staff authentication
DROP POLICY IF EXISTS "Staff can update their own data" ON public.staff;
DROP POLICY IF EXISTS "Staff can view their own data" ON public.staff;

-- Create new RLS policies using user_id
CREATE POLICY "Staff can update their own data" 
ON public.staff 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Staff can view their own data" 
ON public.staff 
FOR SELECT 
USING (auth.uid() = user_id);

-- Keep the policy that allows staff authentication by email
-- This is needed for the initial login process