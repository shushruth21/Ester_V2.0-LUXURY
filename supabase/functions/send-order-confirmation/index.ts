import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { Resend } from "npm:resend@2.0.0";

const resend = new Resend(Deno.env.get("RESEND_API_KEY"));

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { customerEmail, orders, jobCards } = await req.json();

    if (!customerEmail || !orders || !jobCards) {
      throw new Error("Missing required fields");
    }

    const totalAmount = orders.reduce((sum: number, order: any) => sum + order.total_price, 0);
    const orderItems = orders.map((order: any) => `
      <tr>
        <td style="padding: 10px; border-bottom: 1px solid #eee;">
          ${order.configuration?.modelName || 'Custom Furniture'}
        </td>
        <td style="padding: 10px; border-bottom: 1px solid #eee; text-align: center;">
          ${order.configuration?.quantity || 1}
        </td>
        <td style="padding: 10px; border-bottom: 1px solid #eee; text-align: right;">
          ₹${order.total_price.toLocaleString()}
        </td>
      </tr>
    `).join('');

    const jobCardDetails = jobCards.map((jobCard: any) => `
      <div style="background-color: #f8f9fa; padding: 15px; border-radius: 8px; margin: 10px 0;">
        <h4 style="color: #2c3e50; margin: 0 0 10px 0;">Job Card: ${jobCard.job_number}</h4>
        <p style="color: #555; margin: 5px 0; font-size: 14px;">
          Priority: <strong>${jobCard.priority}</strong>
        </p>
        ${jobCard.estimated_completion_date ? `
          <p style="color: #555; margin: 5px 0; font-size: 14px;">
            Estimated Completion: <strong>${new Date(jobCard.estimated_completion_date).toLocaleDateString()}</strong>
          </p>
        ` : ''}
      </div>
    `).join('');

    console.log('Attempting to send email to:', customerEmail);
    
    const emailResponse = await resend.emails.send({
      from: "Estre <onboarding@resend.dev>", // Temporary: using verified domain
      to: [customerEmail],
      subject: "Order Confirmation - Your Custom Furniture is Being Crafted",
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
          <div style="text-align: center; margin-bottom: 30px;">
            <h1 style="color: #2c3e50; margin-bottom: 10px;">Estre Furniture</h1>
            <p style="color: #7f8c8d; font-size: 16px;">Premium Custom Furniture</p>
          </div>
          
          <div style="background-color: #e8f5e8; padding: 20px; border-radius: 10px; text-align: center; margin-bottom: 30px;">
            <h2 style="color: #27ae60; margin: 0;">✅ Order Confirmed!</h2>
            <p style="color: #555; margin: 10px 0 0 0;">
              Thank you for choosing Estre. Your custom furniture is now in production.
            </p>
          </div>
          
          <div style="margin-bottom: 30px;">
            <h3 style="color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px;">
              Order Summary
            </h3>
            <table style="width: 100%; border-collapse: collapse; margin: 20px 0;">
              <thead>
                <tr style="background-color: #f8f9fa;">
                  <th style="padding: 12px; text-align: left; border-bottom: 2px solid #dee2e6;">Item</th>
                  <th style="padding: 12px; text-align: center; border-bottom: 2px solid #dee2e6;">Qty</th>
                  <th style="padding: 12px; text-align: right; border-bottom: 2px solid #dee2e6;">Price</th>
                </tr>
              </thead>
              <tbody>
                ${orderItems}
                <tr style="background-color: #f8f9fa; font-weight: bold;">
                  <td style="padding: 12px; border-top: 2px solid #dee2e6;" colspan="2">Total</td>
                  <td style="padding: 12px; text-align: right; border-top: 2px solid #dee2e6;">
                    ₹${totalAmount.toLocaleString()}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          
          <div style="margin-bottom: 30px;">
            <h3 style="color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px;">
              Production Details
            </h3>
            ${jobCardDetails}
          </div>
          
          <div style="background-color: #fff3cd; padding: 20px; border-radius: 10px; margin-bottom: 30px;">
            <h4 style="color: #856404; margin: 0 0 15px 0;">📋 What Happens Next?</h4>
            <ul style="color: #856404; padding-left: 20px; margin: 0;">
              <li>Our craftsmen will begin working on your custom pieces</li>
              <li>You'll receive regular updates on production progress</li>
              <li>We'll contact you to schedule delivery when ready</li>
              <li>Free white-glove delivery and setup included</li>
            </ul>
          </div>
          
          <div style="text-align: center; padding: 20px; border-top: 1px solid #eee;">
            <p style="color: #7f8c8d; font-size: 14px; margin: 0 0 10px 0;">
              Questions? We're here to help!
            </p>
            <p style="color: #7f8c8d; font-size: 14px; margin: 0;">
              📞 +91-8087-ESTRE | 📧 support@estre.in
            </p>
          </div>
        </div>
      `,
    });

    console.log('Email sent successfully:', emailResponse);
    
    return new Response(
      JSON.stringify({ success: true, messageId: emailResponse.data?.id }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    console.error('Detailed error sending order confirmation:', {
      error: error.message,
      stack: error.stack,
      resendError: error.cause || error.details
    });
    
    // Return success even if email fails - don't block order creation
    return new Response(
      JSON.stringify({ 
        success: true, 
        emailError: error.message,
        message: "Order processed successfully, email notification failed"
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  }
});