-- Add plan_type column to subscriptions table
ALTER TABLE public.subscriptions 
ADD COLUMN IF NOT EXISTS plan_type text DEFAULT 'monthly';