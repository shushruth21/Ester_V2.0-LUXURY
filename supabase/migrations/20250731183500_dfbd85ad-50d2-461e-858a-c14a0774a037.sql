-- Add RLS policy to allow staff authentication queries
-- This allows SELECT on the staff table for authentication purposes
CREATE POLICY "Allow staff authentication" 
ON public.staff 
FOR SELECT 
USING (true);