-- Create a Supabase auth user for staff@estre.in and link it to the existing staff record
-- This will be done by inserting directly into auth.users (this requires admin privileges)

-- First, let's check if the staff record exists and get its ID
DO $$
DECLARE
    staff_record_id UUID;
    new_auth_user_id UUID;
BEGIN
    -- Get the existing staff record ID
    SELECT id INTO staff_record_id 
    FROM public.staff 
    WHERE email = 'staff@estre.in';
    
    IF staff_record_id IS NOT NULL THEN
        -- Generate a new UUID for the auth user
        new_auth_user_id := gen_random_uuid();
        
        -- Insert into auth.users table (this creates a Supabase auth user)
        INSERT INTO auth.users (
            id,
            instance_id,
            aud,
            role,
            email,
            encrypted_password,
            email_confirmed_at,
            recovery_sent_at,
            last_sign_in_at,
            raw_app_meta_data,
            raw_user_meta_data,
            created_at,
            updated_at,
            confirmation_token,
            email_change,
            email_change_token_new,
            recovery_token
        ) VALUES (
            new_auth_user_id,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'staff@estre.in',
            crypt('staff123', gen_salt('bf')), -- Hash the password
            now(),
            null,
            null,
            '{"provider": "email", "providers": ["email"]}',
            '{"user_type": "staff", "full_name": "Staff User"}',
            now(),
            now(),
            '',
            '',
            '',
            ''
        );
        
        -- Now update the staff record to link it with the auth user
        UPDATE public.staff 
        SET user_id = new_auth_user_id 
        WHERE id = staff_record_id;
        
        RAISE NOTICE 'Staff user created and linked successfully';
    ELSE
        RAISE EXCEPTION 'Staff record with email staff@estre.in not found';
    END IF;
END $$;