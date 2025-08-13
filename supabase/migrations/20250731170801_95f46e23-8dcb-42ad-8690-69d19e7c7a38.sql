-- Create customers table
CREATE TABLE public.customers (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  full_name TEXT NOT NULL,
  mobile TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create staff table
CREATE TABLE public.staff (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  full_name TEXT NOT NULL,
  department TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.staff ENABLE ROW LEVEL SECURITY;

-- Create policies for customers
CREATE POLICY "Customers can view their own data" 
ON public.customers 
FOR SELECT 
USING (auth.uid()::text = id::text);

CREATE POLICY "Customers can update their own data" 
ON public.customers 
FOR UPDATE 
USING (auth.uid()::text = id::text);

-- Create policies for staff
CREATE POLICY "Staff can view their own data" 
ON public.staff 
FOR SELECT 
USING (auth.uid()::text = id::text);

CREATE POLICY "Staff can update their own data" 
ON public.staff 
FOR UPDATE 
USING (auth.uid()::text = id::text);

CREATE POLICY "Staff can view all customer data" 
ON public.customers 
FOR SELECT 
USING (EXISTS (SELECT 1 FROM public.staff WHERE auth.uid()::text = id::text));

-- Create function to update timestamps
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for automatic timestamp updates
CREATE TRIGGER update_customers_updated_at
  BEFORE UPDATE ON public.customers
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_staff_updated_at
  BEFORE UPDATE ON public.staff
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- Insert default staff user
INSERT INTO public.staff (id, email, password_hash, full_name, department)
VALUES (
  gen_random_uuid(),
  'staff@estre.in',
  crypt('staff123', gen_salt('bf')),
  'Staff User',
  'Administration'
);