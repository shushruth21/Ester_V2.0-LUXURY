import { supabase } from "@/integrations/supabase/client";

export interface JobCard {
  id: string;
  order_id: string;
  invoice_id: string;
  job_number: string;
  customer_details: any;
  product_details: any;
  configuration_details: any;
  status: string;
  priority: string;
  estimated_completion_date?: string;
  actual_completion_date?: string;
  assigned_staff_id?: string;
  notes?: string;
  created_at: string;
  updated_at: string;
}

export interface CreateJobCardData {
  orderId: string;
  invoiceId: string;
  customerDetails: any;
  productDetails: any;
  configurationDetails: any;
  priority?: string;
  estimatedDays?: number;
}

const generateJobNumber = (): string => {
  const timestamp = Date.now().toString();
  const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
  return `JOB-${timestamp}-${random}`;
};

// Create job card from order using edge function
export const createJobCardFromOrder = async (orderId: string): Promise<{ success: boolean; jobCard?: any; error?: string }> => {
  try {
    const { data, error } = await supabase.functions.invoke('create-job-card', {
      body: { orderId }
    });

    if (error) {
      console.error('Error creating job card:', error);
      return { success: false, error: error.message };
    }

    return { success: true, jobCard: data.jobCard };
  } catch (error) {
    console.error('Error calling create-job-card function:', error);
    return { 
      success: false, 
      error: error instanceof Error ? error.message : 'Unknown error occurred' 
    };
  }
};

export const createJobCard = async (data: CreateJobCardData): Promise<JobCard> => {
  const jobNumber = generateJobNumber();
  const estimatedCompletionDate = data.estimatedDays 
    ? new Date(Date.now() + data.estimatedDays * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
    : null;

  const jobCardData = {
    order_id: data.orderId,
    invoice_id: data.invoiceId,
    job_number: jobNumber,
    customer_details: data.customerDetails,
    product_details: data.productDetails,
    configuration_details: data.configurationDetails,
    status: 'pending',
    priority: data.priority || 'normal',
    estimated_completion_date: estimatedCompletionDate
  };

  const { data: jobCard, error } = await supabase
    .from('job_cards')
    .insert(jobCardData)
    .select()
    .single();

  if (error) {
    throw new Error(`Failed to create job card: ${error.message}`);
  }

  return jobCard;
};

export const getJobCardById = async (jobCardId: string): Promise<JobCard | null> => {
  const { data, error } = await supabase
    .from('job_cards')
    .select('*')
    .eq('id', jobCardId)
    .single();

  if (error) {
    console.error('Error fetching job card:', error);
    return null;
  }

  return data;
};

export const updateJobCardStatus = async (jobCardId: string, status: string, notes?: string): Promise<boolean> => {
  const updateData: any = {
    status,
    updated_at: new Date().toISOString()
  };

  if (notes) {
    updateData.notes = notes;
  }

  if (status === 'completed') {
    updateData.actual_completion_date = new Date().toISOString().split('T')[0];
  }

  const { error } = await supabase
    .from('job_cards')
    .update(updateData)
    .eq('id', jobCardId);

  if (error) {
    console.error('Error updating job card:', error);
    return false;
  }

  return true;
};

export const getAllJobCards = async (): Promise<JobCard[]> => {
  const { data, error } = await supabase
    .from('job_cards')
    .select('*')
    .order('created_at', { ascending: false });

  if (error) {
    console.error('Error fetching job cards:', error);
    return [];
  }

  return data || [];
};

export const assignJobCard = async (jobCardId: string, staffId: string): Promise<boolean> => {
  const { error } = await supabase
    .from('job_cards')
    .update({
      assigned_staff_id: staffId,
      updated_at: new Date().toISOString()
    })
    .eq('id', jobCardId);

  if (error) {
    console.error('Error assigning job card:', error);
    return false;
  }

  return true;
};