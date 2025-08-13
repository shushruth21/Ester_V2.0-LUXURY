import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { Resend } from "npm:resend@2.0.0";

const resend = new Resend(Deno.env.get("RESEND_API_KEY"));

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// Staff notification email - replace with actual staff emails
const STAFF_EMAILS = ["production@estre.in", "manager@estre.in"];

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { orders, jobCards, customerDetails } = await req.json();

    if (!orders || !jobCards || !customerDetails) {
      throw new Error("Missing required fields");
    }

    const totalAmount = orders.reduce((sum: number, order: any) => sum + order.total_price, 0);
    const orderItems = orders.map((order: any) => `
      <tr>
        <td style="padding: 8px; border-bottom: 1px solid #eee;">
          ${order.configuration?.modelName || 'Custom Furniture'}
        </td>
        <td style="padding: 8px; border-bottom: 1px solid #eee; text-align: center;">
          ${order.configuration?.quantity || 1}
        </td>
        <td style="padding: 8px; border-bottom: 1px solid #eee; text-align: right;">
          ₹${order.total_price.toLocaleString()}
        </td>
      </tr>
    `).join('');

    const jobCardsList = jobCards.map((jobCard: any) => `
      <li style="margin: 10px 0; padding: 10px; background-color: #f8f9fa; border-radius: 5px;">
        <strong>${jobCard.job_number}</strong> - 
        Priority: ${jobCard.priority} - 
        ${jobCard.estimated_completion_date ? `Due: ${new Date(jobCard.estimated_completion_date).toLocaleDateString()}` : 'No due date set'}
      </li>
    `).join('');

    const emailResponse = await resend.emails.send({
      from: "Estre System <system@estre.in>",
      to: STAFF_EMAILS,
      subject: `🚨 New Paid Order - ${customerDetails.name} - ₹${totalAmount.toLocaleString()}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
          <div style="background-color: #d4edda; padding: 20px; border-radius: 10px; text-align: center; margin-bottom: 30px;">
            <h2 style="color: #155724; margin: 0;">💰 New Paid Order Received!</h2>
            <p style="color: #155724; margin: 10px 0 0 0; font-size: 18px;">
              Order Value: <strong>₹${totalAmount.toLocaleString()}</strong>
            </p>
          </div>
          
          <div style="margin-bottom: 25px;">
            <h3 style="color: #2c3e50; border-bottom: 2px solid #e74c3c; padding-bottom: 10px;">
              👤 Customer Information
            </h3>
            <div style="background-color: #f8f9fa; padding: 15px; border-radius: 8px;">
              <p style="margin: 5px 0;"><strong>Name:</strong> ${customerDetails.name}</p>
              <p style="margin: 5px 0;"><strong>Email:</strong> ${customerDetails.email}</p>
              <p style="margin: 5px 0;"><strong>Phone:</strong> ${customerDetails.phone}</p>
            </div>
          </div>
          
          <div style="margin-bottom: 25px;">
            <h3 style="color: #2c3e50; border-bottom: 2px solid #e74c3c; padding-bottom: 10px;">
              📦 Order Details
            </h3>
            <table style="width: 100%; border-collapse: collapse; margin: 15px 0;">
              <thead>
                <tr style="background-color: #f8f9fa;">
                  <th style="padding: 10px; text-align: left; border-bottom: 2px solid #dee2e6;">Item</th>
                  <th style="padding: 10px; text-align: center; border-bottom: 2px solid #dee2e6;">Qty</th>
                  <th style="padding: 10px; text-align: right; border-bottom: 2px solid #dee2e6;">Price</th>
                </tr>
              </thead>
              <tbody>
                ${orderItems}
                <tr style="background-color: #fff3cd; font-weight: bold;">
                  <td style="padding: 10px; border-top: 2px solid #dee2e6;" colspan="2">Total Amount</td>
                  <td style="padding: 10px; text-align: right; border-top: 2px solid #dee2e6;">
                    ₹${totalAmount.toLocaleString()}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          
          <div style="margin-bottom: 25px;">
            <h3 style="color: #2c3e50; border-bottom: 2px solid #e74c3c; padding-bottom: 10px;">
              🔨 Job Cards Created
            </h3>
            <ul style="list-style: none; padding: 0;">
              ${jobCardsList}
            </ul>
          </div>
          
          <div style="background-color: #fff3cd; padding: 20px; border-radius: 10px; text-align: center;">
            <h4 style="color: #856404; margin: 0 0 10px 0;">⚡ Action Required</h4>
            <p style="color: #856404; margin: 0;">
              Please review and assign these job cards in the staff dashboard.
              Production should begin within 24 hours of payment confirmation.
            </p>
          </div>
          
          <div style="text-align: center; padding: 20px; border-top: 1px solid #eee; margin-top: 30px;">
            <p style="color: #7f8c8d; font-size: 12px; margin: 0;">
              This is an automated notification from the Estre Production System
            </p>
          </div>
        </div>
      `,
    });

    return new Response(
      JSON.stringify({ success: true, messageId: emailResponse.data?.id }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    console.error('Error sending staff notification:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 500,
      }
    );
  }
});