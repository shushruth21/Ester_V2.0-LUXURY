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
    const { orderId, verificationCode, customerEmail, verificationUrl } = await req.json();

    if (!orderId || !verificationCode || !customerEmail) {
      throw new Error("Missing required fields: orderId, verificationCode, or customerEmail");
    }

    const emailResponse = await resend.emails.send({
      from: "Estre <orders@estre.in>",
      to: [customerEmail],
      subject: `Order Verification Confirmed - ${verificationCode}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
          <div style="text-align: center; margin-bottom: 30px;">
            <h1 style="color: #2c3e50; margin-bottom: 10px;">Estre Furniture</h1>
            <p style="color: #7f8c8d; font-size: 16px;">Premium Custom Furniture</p>
          </div>
          
          <div style="background-color: #f8f9fa; padding: 30px; border-radius: 10px; text-align: center;">
            <div style="background-color: #22c55e; color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
              <h2 style="margin: 0; font-size: 24px;">✓ Order Verified Successfully!</h2>
            </div>
            
            <p style="color: #555; font-size: 16px; margin-bottom: 30px;">
              Thank you for verifying your order. Your custom furniture order is now confirmed and will proceed to production.
            </p>
            
            <div style="background-color: #fff; border: 2px solid #22c55e; border-radius: 8px; padding: 20px; margin: 20px 0; display: inline-block;">
              <p style="margin: 0; color: #666; font-size: 14px;">Verification Code</p>
              <span style="font-size: 20px; font-weight: bold; color: #2c3e50; letter-spacing: 2px;">
                ${verificationCode}
              </span>
            </div>
            
            <div style="margin: 30px 0;">
              <a href="${verificationUrl}" style="background-color: #3498db; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;">
                View Order Details
              </a>
            </div>
          </div>
          
          <div style="margin-top: 30px; padding: 20px; border-top: 1px solid #eee;">
            <h3 style="color: #2c3e50; margin-bottom: 15px;">What Happens Next?</h3>
            <ol style="color: #666; line-height: 1.6;">
              <li><strong>Production Planning:</strong> Our team will create a detailed production plan for your custom furniture</li>
              <li><strong>Manufacturing:</strong> Skilled craftsmen will begin creating your furniture with attention to every detail</li>
              <li><strong>Quality Check & Delivery:</strong> Final quality inspection and scheduled delivery to your location</li>
            </ol>
            
            <div style="background-color: #e3f2fd; padding: 15px; border-radius: 5px; margin: 20px 0;">
              <p style="margin: 0; color: #1976d2; font-weight: bold;">📅 Estimated Timeline: 4-6 weeks</p>
              <p style="margin: 5px 0 0 0; color: #666; font-size: 14px;">You'll receive regular updates via email and SMS</p>
            </div>
          </div>
          
          <div style="margin-top: 30px; padding: 20px; border-top: 1px solid #eee;">
            <h3 style="color: #2c3e50; margin-bottom: 15px;">Important Information</h3>
            <ul style="color: #666; line-height: 1.6;">
              <li><strong>Order Reference:</strong> ${verificationCode}</li>
              <li><strong>Verification Status:</strong> Confirmed ✓</li>
              <li><strong>Customer Support:</strong> orders@estre.in or +91-8087-ESTRE</li>
            </ul>
            
            <p style="color: #e74c3c; font-size: 14px; margin-top: 20px; padding: 15px; background-color: #fdf2f2; border-radius: 5px;">
              <strong>Important:</strong> This verification confirms your order commitment. Please save this email for your records. 
              Any changes to your order must be requested within 24 hours of verification.
            </p>
          </div>
          
          <div style="margin-top: 30px; padding: 20px; border-top: 1px solid #eee; text-align: center;">
            <p style="color: #7f8c8d; font-size: 14px; margin: 0;">
              Thank you for choosing Estre Furniture. We're excited to create your custom furniture!
            </p>
            <p style="color: #7f8c8d; font-size: 12px; margin-top: 10px;">
              If you have any questions, reply to this email or contact us at orders@estre.in
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
    console.error('Error sending verification confirmation email:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 500,
      }
    );
  }
});