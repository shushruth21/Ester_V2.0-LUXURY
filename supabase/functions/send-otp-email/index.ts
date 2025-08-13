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
    const { email, otpCode, invoiceNumber } = await req.json();

    if (!email || !otpCode || !invoiceNumber) {
      throw new Error("Missing required fields: email, otpCode, or invoiceNumber");
    }

    const emailResponse = await resend.emails.send({
      from: "Estre <orders@estre.in>",
      to: [email],
      subject: `Your OTP Code for Invoice ${invoiceNumber}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
          <div style="text-align: center; margin-bottom: 30px;">
            <h1 style="color: #2c3e50; margin-bottom: 10px;">Estre Furniture</h1>
            <p style="color: #7f8c8d; font-size: 16px;">Premium Custom Furniture</p>
          </div>
          
          <div style="background-color: #f8f9fa; padding: 30px; border-radius: 10px; text-align: center;">
            <h2 style="color: #2c3e50; margin-bottom: 20px;">Email Verification Required</h2>
            <p style="color: #555; font-size: 16px; margin-bottom: 30px;">
              Please use the following OTP code to verify your email for invoice ${invoiceNumber}:
            </p>
            
            <div style="background-color: #fff; border: 2px solid #3498db; border-radius: 8px; padding: 20px; margin: 20px 0; display: inline-block;">
              <span style="font-size: 32px; font-weight: bold; color: #2c3e50; letter-spacing: 8px;">
                ${otpCode}
              </span>
            </div>
            
            <p style="color: #e74c3c; font-size: 14px; margin-top: 20px;">
              ⏰ This code expires in 10 minutes
            </p>
          </div>
          
          <div style="margin-top: 30px; padding: 20px; border-top: 1px solid #eee;">
            <p style="color: #7f8c8d; font-size: 14px; text-align: center;">
              If you didn't request this verification, please ignore this email.
            </p>
            <p style="color: #7f8c8d; font-size: 14px; text-align: center;">
              Need help? Contact us at support@estre.in or +91-8087-ESTRE
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
    console.error('Error sending OTP email:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 500,
      }
    );
  }
});