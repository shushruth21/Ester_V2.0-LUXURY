-- Add RLS policy for customers to delete their own pending orders
CREATE POLICY "Customers can delete their own pending orders" 
ON public.orders 
FOR DELETE 
USING (
  customer_email = ((current_setting('request.jwt.claims'::text, true))::json ->> 'email'::text)
  AND status = 'pending'
);