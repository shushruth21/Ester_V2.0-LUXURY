import { supabase } from "@/integrations/supabase/client";

export interface CustomerData {
  id: string;
  email: string;
  full_name: string;
  mobile?: string;
  created_at: string;
  updated_at: string;
}

export interface StaffData {
  id: string;
  email: string;
  full_name: string;
  department?: string;
  created_at: string;
  updated_at: string;
}

export const authService = {
  // Customer authentication
  async signUpCustomer(email: string, password: string, fullName: string, mobile?: string) {
    try {
      // Create Supabase auth user first
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email,
        password,
        options: {
          emailRedirectTo: `${window.location.origin}/`,
          data: {
            full_name: fullName,
            mobile,
            user_type: 'customer'
          }
        }
      });

      if (authError) {
        return { error: authError, customer: null };
      }

      // If auth user was created successfully, create customer record with user_id
      if (authData.user) {
        const { data: customer, error: customerError } = await supabase
          .from('customers')
          .insert({
            user_id: authData.user.id,
            email,
            full_name: fullName,
            mobile
          })
          .select()
          .single();

        if (customerError) {
          // Clean up auth user if customer creation fails
          await supabase.auth.admin.deleteUser(authData.user.id);
          return { error: customerError, customer: null };
        }

        return { error: null, customer, authData };
      }

      return { error: { message: 'Failed to create user' }, customer: null };
    } catch (error) {
      return { error, customer: null };
    }
  },

  async signInCustomer(email: string, password: string) {
    try {
      // Use Supabase Auth for authentication
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) {
        return { error, user: null };
      }

      // Get customer data after successful authentication
      const { data: customer, error: customerError } = await supabase
        .from('customers')
        .select('*')
        .eq('user_id', data.user.id)
        .single();

      if (customerError || !customer) {
        return { error: { message: 'Invalid customer credentials' }, user: null };
      }

      return { error: null, user: data.user, customer };
    } catch (error) {
      return { error, user: null };
    }
  },

  async signInStaff(email: string, password: string) {
    try {
      // Use Supabase Auth for authentication
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) {
        return { error, user: null };
      }

      // Get staff data after successful authentication
      const { data: staff, error: staffError } = await supabase
        .from('staff')
        .select('*')
        .eq('user_id', data.user.id)
        .single();

      if (staffError || !staff) {
        return { error: { message: 'Invalid staff credentials' }, user: null };
      }

      return { error: null, user: data.user, staff };
    } catch (error) {
      return { error, user: null };
    }
  },

  async getCurrentCustomer(userId: string): Promise<CustomerData | null> {
    try {
      const { data, error } = await supabase
        .from('customers')
        .select('*')
        .eq('user_id', userId)
        .single();

      if (error || !data) return null;
      return data;
    } catch {
      return null;
    }
  },

  async getCurrentStaff(userId: string): Promise<StaffData | null> {
    try {
      const { data, error } = await supabase
        .from('staff')
        .select('*')
        .eq('user_id', userId)
        .single();

      if (error || !data) return null;
      return data;
    } catch {
      return null;
    }
  },

  async signOut() {
    return await supabase.auth.signOut();
  }
};