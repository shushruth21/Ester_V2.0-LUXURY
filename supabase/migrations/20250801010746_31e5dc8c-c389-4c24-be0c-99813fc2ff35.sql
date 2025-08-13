-- Remove the problematic dev policy that's causing conflicts
DROP POLICY IF EXISTS "Allow all inserts for dev" ON public.job_cards;

-- Create proper policies for authenticated users and service role operations
CREATE POLICY "Allow authenticated job card inserts" 
ON public.job_cards 
FOR INSERT 
TO authenticated 
WITH CHECK (true);

CREATE POLICY "Allow service role operations" 
ON public.job_cards 
FOR ALL 
TO service_role 
WITH CHECK (true);

CREATE POLICY "Allow authenticated users to view job cards" 
ON public.job_cards 
FOR SELECT 
TO authenticated 
USING (true);