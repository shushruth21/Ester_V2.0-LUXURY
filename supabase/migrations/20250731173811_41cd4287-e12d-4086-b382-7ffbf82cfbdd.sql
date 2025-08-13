-- Add user_id column to customers table
ALTER TABLE public.customers 
ADD COLUMN user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

-- Create index for better performance
CREATE INDEX idx_customers_user_id ON public.customers(user_id);

-- Drop existing RLS policies
DROP POLICY IF EXISTS "Customers can update their own data" ON public.customers;
DROP POLICY IF EXISTS "Customers can view their own data" ON public.customers;
DROP POLICY IF EXISTS "Staff can view all customer data" ON public.customers;

-- Create new RLS policies
CREATE POLICY "Allow customer registration"
ON public.customers
FOR INSERT
WITH CHECK (true);

CREATE POLICY "Customers can view their own data"
ON public.customers
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Customers can update their own data"
ON public.customers
FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Staff can view all customer data"
ON public.customers
FOR SELECT
USING (has_role(auth.uid(), 'staff'::app_role) OR auth.uid() = user_id);