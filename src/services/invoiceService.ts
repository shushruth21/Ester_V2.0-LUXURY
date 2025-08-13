import { supabase } from "@/integrations/supabase/client";
import { Order } from "./orderService";

export interface Invoice {
  id: string;
  order_id: string;
  invoice_number: string;
  amount: number;
  status: string;
  otp_code?: string;
  otp_expires_at?: string;
  authorized_email?: string;
  authorized_at?: string;
  created_at: string;
  updated_at: string;
}

export interface CreateInvoiceData {
  orderId: string;
  amount: number;
  customerEmail: string;
}

const generateInvoiceNumber = (): string => {
  const timestamp = Date.now().toString();
  const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
  return `INV-${timestamp}-${random}`;
};

const generateOTP = (): string => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

export const createInvoice = async (data: CreateInvoiceData): Promise<Invoice> => {
  const invoiceNumber = generateInvoiceNumber();
  const otpCode = generateOTP();
  const otpExpiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes from now

  const invoiceData = {
    order_id: data.orderId,
    invoice_number: invoiceNumber,
    amount: data.amount,
    status: 'pending',
    otp_code: otpCode,
    otp_expires_at: otpExpiresAt.toISOString(),
    authorized_email: data.customerEmail
  };

  const { data: invoice, error } = await supabase
    .from('invoices')
    .insert(invoiceData)
    .select()
    .single();

  if (error) {
    throw new Error(`Failed to create invoice: ${error.message}`);
  }

  return invoice;
};

export const verifyOTP = async (invoiceId: string, otpCode: string): Promise<boolean> => {
  const { data: invoice, error } = await supabase
    .from('invoices')
    .select('*')
    .eq('id', invoiceId)
    .single();

  if (error || !invoice) {
    return false;
  }

  // Check if OTP matches and hasn't expired
  const now = new Date();
  const expiresAt = new Date(invoice.otp_expires_at);

  if (invoice.otp_code !== otpCode || now > expiresAt) {
    return false;
  }

  // Mark as authorized
  const { error: updateError } = await supabase
    .from('invoices')
    .update({
      status: 'authorized',
      authorized_at: now.toISOString(),
      updated_at: now.toISOString()
    })
    .eq('id', invoiceId);

  return !updateError;
};

export const getInvoiceById = async (invoiceId: string): Promise<Invoice | null> => {
  const { data, error } = await supabase
    .from('invoices')
    .select('*')
    .eq('id', invoiceId)
    .single();

  if (error) {
    console.error('Error fetching invoice:', error);
    return null;
  }

  return data;
};

export const updateInvoiceStatus = async (invoiceId: string, status: string): Promise<boolean> => {
  const { error } = await supabase
    .from('invoices')
    .update({
      status,
      updated_at: new Date().toISOString()
    })
    .eq('id', invoiceId);

  if (error) {
    console.error('Error updating invoice status:', error);
    return false;
  }

  return true;
};

export const getInvoicesForOrders = async (orderIds: string[]): Promise<Invoice[]> => {
  const { data, error } = await supabase
    .from('invoices')
    .select('*')
    .in('order_id', orderIds)
    .order('created_at', { ascending: false });

  if (error) {
    console.error('Error fetching invoices:', error);
    return [];
  }

  return data || [];
};