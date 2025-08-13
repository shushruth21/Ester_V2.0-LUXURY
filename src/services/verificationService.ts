import { supabase } from "@/integrations/supabase/client";

export interface CreateVerificationData {
  orderId: string;
  email: string;
  ipAddress?: string;
  userAgent?: string;
}

export interface VerificationResult {
  success: boolean;
  verificationCode?: string;
  message: string;
}

// Generate a unique verification code
export const generateVerificationCode = (): string => {
  const timestamp = Date.now().toString(36);
  const randomString = Math.random().toString(36).substring(2, 15);
  return `ESTRE-${timestamp}-${randomString}`.toUpperCase();
};

// Create order verification record
export const createOrderVerification = async (data: CreateVerificationData): Promise<VerificationResult> => {
  try {
    const verificationCode = generateVerificationCode();
    
    // Update the order with verification details
    const { error: orderUpdateError } = await supabase
      .from('orders')
      .update({
        verification_code: verificationCode,
        verification_email: data.email,
        verified_at: new Date().toISOString(),
        status: 'verified'
      })
      .eq('id', data.orderId);

    if (orderUpdateError) {
      throw new Error(`Failed to update order: ${orderUpdateError.message}`);
    }

    // Create verification audit record
    const { error: verificationError } = await supabase
      .from('order_verifications')
      .insert({
        order_id: data.orderId,
        verification_code: verificationCode,
        verification_email: data.email,
        ip_address: data.ipAddress,
        user_agent: data.userAgent
      });

    if (verificationError) {
      throw new Error(`Failed to create verification record: ${verificationError.message}`);
    }

    return {
      success: true,
      verificationCode,
      message: 'Order successfully verified'
    };
  } catch (error) {
    console.error('Error creating order verification:', error);
    return {
      success: false,
      message: error instanceof Error ? error.message : 'Failed to verify order'
    };
  }
};

// Get order by verification code
export const getOrderByVerificationCode = async (orderId: string, verificationCode: string) => {
  try {
    const { data, error } = await supabase
      .from('orders')
      .select('*')
      .eq('id', orderId)
      .eq('verification_code', verificationCode)
      .single();

    if (error) {
      throw new Error('Order not found or verification code invalid');
    }

    return data;
  } catch (error) {
    console.error('Error fetching order by verification code:', error);
    throw error;
  }
};

// Get verification details
export const getVerificationDetails = async (orderId: string, verificationCode: string) => {
  try {
    const { data, error } = await supabase
      .from('order_verifications')
      .select('*')
      .eq('order_id', orderId)
      .eq('verification_code', verificationCode)
      .single();

    if (error) {
      throw new Error('Verification details not found');
    }

    return data;
  } catch (error) {
    console.error('Error fetching verification details:', error);
    throw error;
  }
};

// Send verification confirmation email
export const sendVerificationConfirmationEmail = async (
  orderId: string, 
  verificationCode: string, 
  customerEmail: string
): Promise<boolean> => {
  try {
    const { error } = await supabase.functions.invoke('send-verification-confirmation', {
      body: {
        orderId,
        verificationCode,
        customerEmail,
        verificationUrl: `${window.location.origin}/order-verification?orderId=${orderId}&code=${verificationCode}`
      }
    });

    if (error) {
      throw new Error(`Failed to send verification email: ${error.message}`);
    }

    return true;
  } catch (error) {
    console.error('Error sending verification confirmation email:', error);
    return false;
  }
};