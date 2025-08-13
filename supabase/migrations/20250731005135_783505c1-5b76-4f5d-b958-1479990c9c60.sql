-- Create tables for order management system

-- Create orders table
CREATE TABLE public.orders (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_email TEXT NOT NULL,
  customer_name TEXT,
  customer_phone TEXT,
  model_id UUID NOT NULL,
  total_price NUMERIC NOT NULL DEFAULT 0,
  remarks TEXT,
  configuration JSONB NOT NULL DEFAULT '{}',
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create invoices table
CREATE TABLE public.invoices (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  order_id UUID NOT NULL,
  invoice_number TEXT NOT NULL,
  amount NUMERIC NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  otp_code TEXT,
  otp_expires_at TIMESTAMP WITH TIME ZONE,
  authorized_at TIMESTAMP WITH TIME ZONE,
  authorized_email TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create job_cards table for staff dashboard
CREATE TABLE public.job_cards (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  order_id UUID NOT NULL,
  invoice_id UUID NOT NULL,
  job_number TEXT NOT NULL,
  customer_details JSONB NOT NULL DEFAULT '{}',
  product_details JSONB NOT NULL DEFAULT '{}',
  configuration_details JSONB NOT NULL DEFAULT '{}',
  status TEXT NOT NULL DEFAULT 'pending',
  assigned_staff_id UUID,
  priority TEXT NOT NULL DEFAULT 'normal',
  estimated_completion_date DATE,
  actual_completion_date DATE,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Add foreign key constraints
ALTER TABLE public.invoices 
ADD CONSTRAINT fk_invoices_order_id 
FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;

ALTER TABLE public.job_cards 
ADD CONSTRAINT fk_job_cards_order_id 
FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;

ALTER TABLE public.job_cards 
ADD CONSTRAINT fk_job_cards_invoice_id 
FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON DELETE CASCADE;

-- Add indexes for performance
CREATE INDEX idx_orders_customer_email ON public.orders(customer_email);
CREATE INDEX idx_orders_status ON public.orders(status);
CREATE INDEX idx_invoices_order_id ON public.invoices(order_id);
CREATE INDEX idx_invoices_status ON public.invoices(status);
CREATE INDEX idx_job_cards_order_id ON public.job_cards(order_id);
CREATE INDEX idx_job_cards_status ON public.job_cards(status);
CREATE INDEX idx_job_cards_assigned_staff_id ON public.job_cards(assigned_staff_id);

-- Create unique constraints
ALTER TABLE public.invoices ADD CONSTRAINT unique_invoice_number UNIQUE (invoice_number);
ALTER TABLE public.job_cards ADD CONSTRAINT unique_job_number UNIQUE (job_number);

-- Enable Row Level Security
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.job_cards ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for orders
CREATE POLICY "Anyone can create orders" 
ON public.orders 
FOR INSERT 
WITH CHECK (true);

CREATE POLICY "Customers can view their own orders" 
ON public.orders 
FOR SELECT 
USING (customer_email = current_setting('request.jwt.claims', true)::json->>'email');

CREATE POLICY "Staff can view all orders" 
ON public.orders 
FOR SELECT 
USING (has_role(auth.uid(), 'staff'::app_role));

CREATE POLICY "Staff can update orders" 
ON public.orders 
FOR UPDATE 
USING (has_role(auth.uid(), 'staff'::app_role));

-- Create RLS policies for invoices
CREATE POLICY "Staff can manage invoices" 
ON public.invoices 
FOR ALL 
USING (has_role(auth.uid(), 'staff'::app_role));

CREATE POLICY "Customers can view their invoices via orders" 
ON public.invoices 
FOR SELECT 
USING (
  EXISTS (
    SELECT 1 FROM public.orders o 
    WHERE o.id = invoices.order_id 
    AND o.customer_email = current_setting('request.jwt.claims', true)::json->>'email'
  )
);

-- Create RLS policies for job cards
CREATE POLICY "Staff can manage job cards" 
ON public.job_cards 
FOR ALL 
USING (has_role(auth.uid(), 'staff'::app_role));

-- Create triggers for updated_at
CREATE TRIGGER update_orders_updated_at
BEFORE UPDATE ON public.orders
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_invoices_updated_at
BEFORE UPDATE ON public.invoices
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_job_cards_updated_at
BEFORE UPDATE ON public.job_cards
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();