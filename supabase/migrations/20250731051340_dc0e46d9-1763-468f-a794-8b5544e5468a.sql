-- Make invoice_id nullable in job_cards table since it will be set later when invoice is created
ALTER TABLE job_cards ALTER COLUMN invoice_id DROP NOT NULL;