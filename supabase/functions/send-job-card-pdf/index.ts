import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { Resend } from "npm:resend@2.0.0";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.7';

const resend = new Resend(Deno.env.get("RESEND_API_KEY"));

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// Initialize Supabase client
const supabaseUrl = Deno.env.get('SUPABASE_URL') as string;
const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') as string;
const supabase = createClient(supabaseUrl, supabaseKey);

// Generate PDF content as HTML (will be converted to PDF)
const generateJobCardHTML = (jobCard: any, customerDetails: any, productDetails: any, configurationDetails: any) => {
  const currentDate = new Date().toLocaleDateString('en-IN');
  
  return `
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Job Card - ${jobCard.job_number}</title>
        <style>
            body { 
                font-family: 'Arial', sans-serif; 
                margin: 0; 
                padding: 20px; 
                background-color: #f8f9fa;
                color: #333;
            }
            .container { 
                max-width: 800px; 
                margin: 0 auto; 
                background: white; 
                padding: 40px; 
                border-radius: 10px; 
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }
            .header { 
                text-align: center; 
                border-bottom: 3px solid #3498db; 
                padding-bottom: 20px; 
                margin-bottom: 30px; 
            }
            .company-name { 
                font-size: 32px; 
                font-weight: bold; 
                color: #2c3e50; 
                margin-bottom: 5px; 
            }
            .company-tagline { 
                color: #7f8c8d; 
                font-size: 16px; 
                margin-bottom: 10px; 
            }
            .job-number { 
                background: #3498db; 
                color: white; 
                padding: 10px 20px; 
                border-radius: 25px; 
                font-weight: bold; 
                font-size: 18px; 
                display: inline-block; 
                margin-top: 10px; 
            }
            .section { 
                margin-bottom: 25px; 
                padding: 20px; 
                background: #f8f9fa; 
                border-radius: 8px; 
                border-left: 4px solid #3498db; 
            }
            .section-title { 
                font-size: 20px; 
                font-weight: bold; 
                color: #2c3e50; 
                margin-bottom: 15px; 
                text-transform: uppercase; 
                letter-spacing: 1px; 
            }
            .detail-row { 
                display: flex; 
                justify-content: space-between; 
                padding: 8px 0; 
                border-bottom: 1px solid #eee; 
            }
            .detail-row:last-child { 
                border-bottom: none; 
            }
            .label { 
                font-weight: bold; 
                color: #555; 
                flex: 1; 
            }
            .value { 
                color: #333; 
                flex: 2; 
            }
            .configuration-item { 
                background: white; 
                padding: 10px; 
                margin: 8px 0; 
                border-radius: 5px; 
                border: 1px solid #e1e5e9; 
            }
            .price-highlight { 
                color: #27ae60; 
                font-weight: bold; 
                font-size: 18px; 
            }
            .status-badge { 
                background: #f39c12; 
                color: white; 
                padding: 5px 15px; 
                border-radius: 20px; 
                font-size: 12px; 
                font-weight: bold; 
                text-transform: uppercase; 
            }
            .footer { 
                text-align: center; 
                margin-top: 40px; 
                padding-top: 20px; 
                border-top: 1px solid #eee; 
                color: #7f8c8d; 
                font-size: 14px; 
            }
            .contact-info { 
                background: #ecf0f1; 
                padding: 15px; 
                border-radius: 8px; 
                margin-top: 20px; 
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <div class="company-name">ESTRE FURNITURE</div>
                <div class="company-tagline">Premium Custom Furniture Manufacturing</div>
                <div class="job-number">Job Card: ${jobCard.job_number}</div>
                <div style="margin-top: 10px; color: #7f8c8d;">
                    Generated on: ${currentDate} | Status: <span class="status-badge">${jobCard.status}</span>
                </div>
            </div>

            <div class="section">
                <div class="section-title">Customer Information</div>
                <div class="detail-row">
                    <div class="label">Name:</div>
                    <div class="value">${customerDetails.name}</div>
                </div>
                <div class="detail-row">
                    <div class="label">Email:</div>
                    <div class="value">${customerDetails.email}</div>
                </div>
                <div class="detail-row">
                    <div class="label">Phone:</div>
                    <div class="value">${customerDetails.phone}</div>
                </div>
            </div>

            <div class="section">
                <div class="section-title">Product Details</div>
                <div class="detail-row">
                    <div class="label">Model:</div>
                    <div class="value">${productDetails.model_name}</div>
                </div>
                <div class="detail-row">
                    <div class="label">Base Price:</div>
                    <div class="value">₹${Number(productDetails.base_price).toLocaleString()}</div>
                </div>
                <div class="detail-row">
                    <div class="label">Total Price:</div>
                    <div class="value price-highlight">₹${Number(productDetails.total_price).toLocaleString()}</div>
                </div>
            </div>

            <div class="section">
                <div class="section-title">Configuration Specifications</div>
                ${Object.entries(configurationDetails.attributes || {}).map(([key, value]: [string, any]) => `
                    <div class="configuration-item">
                        <div class="detail-row">
                            <div class="label">${value.display_name}:</div>
                            <div class="value">${value.selected_value}</div>
                        </div>
                        ${value.price_modifier !== 0 ? `
                            <div class="detail-row">
                                <div class="label">Price Adjustment:</div>
                                <div class="value" style="color: ${value.price_modifier > 0 ? '#27ae60' : '#e74c3c'}">
                                    ${value.price_modifier > 0 ? '+' : ''}₹${Number(value.price_modifier).toLocaleString()}
                                </div>
                            </div>
                        ` : ''}
                    </div>
                `).join('')}
                
                ${configurationDetails.remarks ? `
                    <div class="configuration-item">
                        <div class="label" style="margin-bottom: 8px;">Special Requirements:</div>
                        <div class="value" style="background: #fff3cd; padding: 10px; border-radius: 5px; border-left: 4px solid #ffc107;">
                            ${configurationDetails.remarks}
                        </div>
                    </div>
                ` : ''}
            </div>

            <div class="section">
                <div class="section-title">Production Schedule</div>
                <div class="detail-row">
                    <div class="label">Priority:</div>
                    <div class="value" style="text-transform: capitalize;">${jobCard.priority}</div>
                </div>
                <div class="detail-row">
                    <div class="label">Estimated Completion:</div>
                    <div class="value">${jobCard.estimated_completion_date ? new Date(jobCard.estimated_completion_date).toLocaleDateString('en-IN') : 'To be determined'}</div>
                </div>
                <div class="detail-row">
                    <div class="label">Order Created:</div>
                    <div class="value">${new Date(jobCard.created_at).toLocaleDateString('en-IN')}</div>
                </div>
            </div>

            <div class="contact-info">
                <div class="section-title">Contact Information</div>
                <p><strong>Email:</strong> production@estre.in | <strong>Phone:</strong> +91-8087-ESTRE</p>
                <p><strong>Address:</strong> Estre Furniture Manufacturing, Industrial Area, India</p>
                <p><em>This is an automated job card. Please keep this for your records.</em></p>
            </div>

            <div class="footer">
                <p>Thank you for choosing Estre Furniture. We're committed to delivering exceptional quality.</p>
                <p>© ${new Date().getFullYear()} Estre Furniture. All rights reserved.</p>
            </div>
        </div>
    </body>
    </html>
  `;
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { jobCardId, customerEmail } = await req.json();

    if (!jobCardId || !customerEmail) {
      throw new Error("Missing required fields: jobCardId or customerEmail");
    }

    console.log('Fetching job card:', jobCardId);

    // Fetch job card details
    const { data: jobCard, error: jobCardError } = await supabase
      .from('job_cards')
      .select('*')
      .eq('id', jobCardId)
      .single();

    if (jobCardError || !jobCard) {
      throw new Error(`Failed to fetch job card: ${jobCardError?.message}`);
    }

    console.log('Job card fetched successfully:', jobCard.job_number);

    // Generate PDF content as HTML
    const htmlContent = generateJobCardHTML(
      jobCard,
      jobCard.customer_details,
      jobCard.product_details,
      jobCard.configuration_details
    );

    // Send email with job card details (HTML email for now, can be enhanced with actual PDF generation)
    const emailResponse = await resend.emails.send({
      from: "Estre Production <production@estre.in>",
      to: [customerEmail],
      subject: `Job Card Confirmation - ${jobCard.job_number}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
          <div style="text-align: center; margin-bottom: 30px;">
            <h1 style="color: #2c3e50; margin-bottom: 10px;">Estre Furniture</h1>
            <p style="color: #7f8c8d; font-size: 16px;">Premium Custom Furniture</p>
          </div>
          
          <div style="background-color: #f8f9fa; padding: 30px; border-radius: 10px;">
            <h2 style="color: #2c3e50; margin-bottom: 20px;">Your Order is Confirmed!</h2>
            <p style="color: #555; font-size: 16px; margin-bottom: 20px;">
              Thank you for your order! Your custom furniture is now in production.
            </p>
            
            <div style="background-color: #fff; border: 2px solid #3498db; border-radius: 8px; padding: 20px; margin: 20px 0;">
              <h3 style="color: #2c3e50; margin-bottom: 15px;">Job Details</h3>
              <p><strong>Job Number:</strong> ${jobCard.job_number}</p>
              <p><strong>Product:</strong> ${jobCard.product_details.model_name}</p>
              <p><strong>Total Price:</strong> ₹${Number(jobCard.product_details.total_price).toLocaleString()}</p>
              <p><strong>Estimated Completion:</strong> ${jobCard.estimated_completion_date ? new Date(jobCard.estimated_completion_date).toLocaleDateString('en-IN') : 'To be determined'}</p>
              <p><strong>Priority:</strong> ${jobCard.priority}</p>
            </div>
            
            <div style="background-color: #e8f5e8; border: 1px solid #27ae60; border-radius: 8px; padding: 15px; margin: 20px 0;">
              <p style="color: #27ae60; font-weight: bold; margin: 0;">✅ Email Verification Complete</p>
              <p style="color: #555; margin: 5px 0 0 0; font-size: 14px;">Your account has been verified and your order is confirmed.</p>
            </div>
          </div>
          
          <div style="margin-top: 30px; padding: 20px; border-top: 1px solid #eee;">
            <h3 style="color: #2c3e50;">What happens next?</h3>
            <ul style="color: #555; line-height: 1.6;">
              <li>Our production team will begin crafting your custom furniture</li>
              <li>You'll receive updates on production progress</li>
              <li>We'll notify you when your order is ready for delivery</li>
              <li>Our team will coordinate white-glove delivery to your location</li>
            </ul>
            
            <div style="background-color: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: 20px;">
              <p style="color: #555; font-size: 14px; margin: 0;">
                <strong>Questions?</strong> Contact us at production@estre.in or +91-8087-ESTRE
              </p>
            </div>
          </div>
        </div>
      `,
    });

    console.log('Email sent successfully:', emailResponse.data?.id);

    return new Response(
      JSON.stringify({ 
        success: true, 
        messageId: emailResponse.data?.id,
        jobNumber: jobCard.job_number 
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    console.error('Error sending job card PDF:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 500,
      }
    );
  }
});