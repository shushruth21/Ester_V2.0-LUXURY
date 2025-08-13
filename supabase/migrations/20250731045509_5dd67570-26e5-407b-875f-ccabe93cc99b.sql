-- Just assign staff role to existing user
INSERT INTO public.user_roles (user_id, role)
SELECT id, 'staff'::app_role
FROM auth.users 
WHERE email = 'staff@estre.in'
ON CONFLICT (user_id, role) DO NOTHING;