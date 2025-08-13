-- Update staff user password to match the expected 'staff123'
UPDATE auth.users 
SET encrypted_password = crypt('staff123', gen_salt('bf'))
WHERE email = 'staff@estre.in';