-- Fix the function search path security issue
CREATE OR REPLACE FUNCTION public.cleanup_expired_otp_codes()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $$
BEGIN
  DELETE FROM public.otp_codes 
  WHERE expires_at < now() AND created_at < now() - INTERVAL '24 hours';
END;
$$;