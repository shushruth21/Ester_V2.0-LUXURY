import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

// Helper function for logging
const logStep = (step: string, details?: any) => {
  const detailsStr = details ? ` - ${JSON.stringify(details)}` : '';
  console.log(`[CREATE-JOB-CARD] ${step}${detailsStr}`);
};

// Generate job number in format JOB-YYYY-NNNN
const generateJobNumber = (): string => {
  const year = new Date().getFullYear();
  const random = Math.floor(Math.random() * 9999).toString().padStart(4, '0');
  return `JOB-${year}-${random}`;
};

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    logStep("Function started");

    // Initialize Supabase client with service role for database operations
    const supabaseService = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
      { auth: { persistSession: false } }
    );

    // Get request body
    const { orderId } = await req.json();
    if (!orderId) {
      throw new Error("Order ID is required");
    }
    logStep("Processing order", { orderId });

    // Fetch the order details
    const { data: order, error: orderError } = await supabaseService
      .from('orders')
      .select('*')
      .eq('id', orderId)
      .single();

    if (orderError || !order) {
      throw new Error(`Order not found: ${orderError?.message}`);
    }
    logStep("Order fetched", { orderId: order.id, status: order.status });

    // Check if job card already exists for this order
    const { data: existingJobCard } = await supabaseService
      .from('job_cards')
      .select('id')
      .eq('order_id', orderId)
      .single();

    if (existingJobCard) {
      logStep("Job card already exists", { jobCardId: existingJobCard.id });
      return new Response(JSON.stringify({ 
        success: true, 
        message: "Job card already exists",
        jobCardId: existingJobCard.id 
      }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      });
    }

    // Get furniture model details
    const { data: model, error: modelError } = await supabaseService
      .from('furniture_models')
      .select('name, category_id, categories(name)')
      .eq('id', order.model_id)
      .single();

    if (modelError || !model) {
      throw new Error(`Model not found: ${modelError?.message}`);
    }

    // Generate job number
    const jobNumber = generateJobNumber();

    // Prepare job card data
    const jobCardData = {
      job_number: jobNumber,
      order_id: orderId,
      invoice_id: null, // Will be updated when invoice is created
      customer_details: {
        name: order.customer_name,
        email: order.customer_email,
        phone: order.customer_phone
      },
      product_details: {
        model_name: model.name,
        category: model.categories?.name,
        base_price: order.configuration?.base_price || 0,
        total_price: order.total_price
      },
      configuration_details: order.configuration,
      status: 'pending',
      priority: 'normal',
      estimated_completion_date: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000).toISOString().split('T')[0], // 14 days from now
      notes: order.remarks || null
    };

    logStep("Creating job card", { jobNumber, customerName: order.customer_name });

    // Create the job card
    const { data: jobCard, error: jobCardError } = await supabaseService
      .from('job_cards')
      .insert(jobCardData)
      .select('*')
      .single();

    if (jobCardError) {
      throw new Error(`Failed to create job card: ${jobCardError.message}`);
    }

    // Update order status to confirmed if it's pending
    if (order.status === 'pending') {
      const { error: updateError } = await supabaseService
        .from('orders')
        .update({ status: 'confirmed' })
        .eq('id', orderId);

      if (updateError) {
        logStep("Warning: Failed to update order status", { error: updateError.message });
      } else {
        logStep("Order status updated to confirmed");
      }
    }

    logStep("Job card created successfully", { 
      jobCardId: jobCard.id, 
      jobNumber: jobCard.job_number 
    });

    return new Response(JSON.stringify({
      success: true,
      message: "Job card created successfully",
      jobCard: {
        id: jobCard.id,
        job_number: jobCard.job_number,
        status: jobCard.status,
        priority: jobCard.priority,
        estimated_completion_date: jobCard.estimated_completion_date
      }
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 200,
    });

  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    logStep("ERROR", { message: errorMessage });
    
    return new Response(JSON.stringify({ 
      success: false, 
      error: errorMessage 
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 500,
    });
  }
});