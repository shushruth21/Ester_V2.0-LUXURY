import nodemailer from 'nodemailer';

export default async function handler(req, res) {
  if (req.method !== "POST") return res.status(405).end();

  const { email, pdfBase64, orderId } = req.body;

  const transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: 465, // Or 587 if you use TLS
    secure: true, // true for 465, false for 587
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASS,
    },
  });

  try {
    await transporter.sendMail({
      from: '"Estre Orders" <orders@estre.in>',
      to: email,
      subject: 'Your Estre Order Confirmation',
      html: `<p>Thank you for your order!<br>Click to <a href="https://YOUR_APP_URL/verify?orderId=${orderId}">verify your email and confirm order</a>.</p>`,
      attachments: [
        {
          filename: 'Estre-Order-Summary.pdf',
          content: pdfBase64,
          encoding: 'base64',
          contentType: 'application/pdf'
        }
      ],
    });

    res.status(200).json({ ok: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ ok: false, error: err.message });
  }
}

