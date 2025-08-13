import { createContext, useContext, useEffect, useState } from 'react';
import { User, Session } from '@supabase/supabase-js';
import { supabase } from '@/integrations/supabase/client';
import { authService, CustomerData, StaffData } from '@/services/authService';

interface AuthContextType {
  user: User | null;
  session: Session | null;
  userType: 'customer' | 'staff' | null;
  userData: CustomerData | StaffData | null;
  loading: boolean;
  signInCustomer: (email: string, password: string) => Promise<{ error: any }>;
  signInStaff: (email: string, password: string) => Promise<{ error: any }>;
  signUpCustomer: (email: string, password: string, fullName: string, mobile?: string) => Promise<{ error: any }>;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [userType, setUserType] = useState<'customer' | 'staff' | null>(null);
  const [userData, setUserData] = useState<CustomerData | StaffData | null>(null);
  const [loading, setLoading] = useState(true);

  const determineUserType = async (userId: string) => {
    try {
      // Check if user is staff first
      const staff = await authService.getCurrentStaff(userId);
      if (staff) {
        setUserType('staff');
        setUserData(staff);
        return;
      }

      // Check if user is a customer
      const customer = await authService.getCurrentCustomer(userId);
      if (customer) {
        setUserType('customer');
        setUserData(customer);
        return;
      }

      // If user is authenticated but no profile exists, create customer profile
      if (session?.user) {
        const userEmail = session.user.email;
        const userFullName = session.user.user_metadata?.full_name || 'New User';
        
        console.log('Creating customer profile for authenticated user:', userEmail);
        
        try {
          const { data: newCustomer, error: createError } = await supabase
            .from('customers')
            .insert({
              user_id: userId,
              email: userEmail!,
              full_name: userFullName,
              mobile: session.user.user_metadata?.mobile || null
            })
            .select()
            .single();

          if (createError) {
            console.error('Error creating customer profile:', createError);
            setUserType(null);
            setUserData(null);
            return;
          }

          console.log('Successfully created customer profile:', newCustomer);
          setUserType('customer');
          setUserData(newCustomer);
          return;
        } catch (createProfileError) {
          console.error('Failed to create customer profile:', createProfileError);
        }
      }

      // User not found in either table and couldn't create profile
      setUserType(null);
      setUserData(null);
    } catch (error) {
      console.error('Error determining user type:', error);
      setUserType(null);
      setUserData(null);
    }
  };

  useEffect(() => {
    // Set up auth state listener
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        setSession(session);
        setUser(session?.user ?? null);
        
        if (session?.user) {
          // Get user type and data from custom tables
          const customId = session.user.user_metadata?.custom_id;
          if (customId) {
            setTimeout(async () => {
              await determineUserType(customId);
            }, 0);
          } else {
            // Fallback: try to find user by auth ID
            setTimeout(async () => {
              await determineUserType(session.user.id);
            }, 0);
          }
        } else {
          setUserType(null);
          setUserData(null);
        }
        
        setLoading(false);
      }
    );

    // Check for existing session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setUser(session?.user ?? null);
      
      if (session?.user) {
        const customId = session.user.user_metadata?.custom_id;
        if (customId) {
          setTimeout(async () => {
            await determineUserType(customId);
          }, 0);
        } else {
          setTimeout(async () => {
            await determineUserType(session.user.id);
          }, 0);
        }
      }
      
      setLoading(false);
    });

    return () => subscription.unsubscribe();
  }, []);

  const signInCustomer = async (email: string, password: string) => {
    return await authService.signInCustomer(email, password);
  };

  const signInStaff = async (email: string, password: string) => {
    return await authService.signInStaff(email, password);
  };

  const signUpCustomer = async (email: string, password: string, fullName: string, mobile?: string) => {
    return await authService.signUpCustomer(email, password, fullName, mobile);
  };

  const signOut = async () => {
    await authService.signOut();
    setUserType(null);
    setUserData(null);
  };

  const value = {
    user,
    session,
    userType,
    userData,
    loading,
    signInCustomer,
    signInStaff,
    signUpCustomer,
    signOut,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};