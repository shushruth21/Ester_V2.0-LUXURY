-- Update orders table to add verification fields and remove payment references
ALTER TABLE public.orders 
ADD COLUMN verified_at TIMESTAMP WITH TIME ZONE,
ADD COLUMN verification_code TEXT UNIQUE,
ADD COLUMN verification_email TEXT;

-- Update order status enum to replace 'paid' with 'verified'
-- Note: We'll keep existing statuses and add 'verified' as an option
-- The application logic will handle the transition from 'pending' to 'verified'

-- Add verification audit trail
CREATE TABLE public.order_verifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
  verification_code TEXT NOT NULL,
  verified_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  verification_email TEXT NOT NULL,
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS on verification table
ALTER TABLE public.order_verifications ENABLE ROW LEVEL SECURITY;

-- Create policies for order verifications
CREATE POLICY "Customers can view their own verifications" 
ON public.order_verifications 
FOR SELECT 
USING (EXISTS (
  SELECT 1 FROM public.orders 
  WHERE orders.id = order_verifications.order_id 
  AND orders.customer_email = ((current_setting('request.jwt.claims'::text, true))::json ->> 'email'::text)
));

CREATE POLICY "Staff can view all verifications" 
ON public.order_verifications 
FOR SELECT 
USING (has_role(auth.uid(), 'staff'::app_role));

CREATE POLICY "Anyone can create verifications" 
ON public.order_verifications 
FOR INSERT 
WITH CHECK (true);