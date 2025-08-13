-- Create OTP codes table for email verification during checkout
CREATE TABLE public.otp_codes (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT NOT NULL,
  otp_code TEXT NOT NULL,
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  verified_at TIMESTAMP WITH TIME ZONE,
  attempts INTEGER NOT NULL DEFAULT 0,
  is_used BOOLEAN NOT NULL DEFAULT false
);

-- Enable Row Level Security
ALTER TABLE public.otp_codes ENABLE ROW LEVEL SECURITY;

-- Create policies for OTP codes
CREATE POLICY "Anyone can create OTP codes" 
ON public.otp_codes 
FOR INSERT 
WITH CHECK (true);

CREATE POLICY "Anyone can verify OTP codes" 
ON public.otp_codes 
FOR SELECT 
USING (true);

CREATE POLICY "Anyone can update OTP verification" 
ON public.otp_codes 
FOR UPDATE 
USING (true);

-- Create index for faster lookups
CREATE INDEX idx_otp_codes_email_code ON public.otp_codes(email, otp_code);
CREATE INDEX idx_otp_codes_expires_at ON public.otp_codes(expires_at);

-- Create function to clean up expired OTP codes
CREATE OR REPLACE FUNCTION public.cleanup_expired_otp_codes()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  DELETE FROM public.otp_codes 
  WHERE expires_at < now() AND created_at < now() - INTERVAL '24 hours';
END;
$$;