-- Find the existing auth user for staff@estre.in and link it to the staff table
DO $$
DECLARE
    staff_record_id UUID;
    existing_auth_user_id UUID;
BEGIN
    -- Get the existing staff record ID
    SELECT id INTO staff_record_id 
    FROM public.staff 
    WHERE email = 'staff@estre.in';
    
    -- Get the existing auth user ID
    SELECT id INTO existing_auth_user_id 
    FROM auth.users 
    WHERE email = 'staff@estre.in';
    
    IF staff_record_id IS NOT NULL AND existing_auth_user_id IS NOT NULL THEN
        -- Update the staff record to link it with the existing auth user
        UPDATE public.staff 
        SET user_id = existing_auth_user_id 
        WHERE id = staff_record_id;
        
        RAISE NOTICE 'Staff user linked successfully with existing auth user';
    ELSE
        RAISE EXCEPTION 'Staff record or auth user not found for staff@estre.in';
    END IF;
END $$;