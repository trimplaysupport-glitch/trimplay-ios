CREATE TABLE public.purchases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  kind text NOT NULL,
  product_id text NOT NULL,
  price_id text NOT NULL,
  paddle_ref text NOT NULL UNIQUE,
  paddle_customer_id text,
  status text NOT NULL DEFAULT 'active',
  current_period_end timestamptz,
  environment text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_purchases_user ON public.purchases(user_id, environment);
GRANT SELECT ON public.purchases TO authenticated;
GRANT ALL ON public.purchases TO service_role;
ALTER TABLE public.purchases ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view own purchases" ON public.purchases FOR SELECT TO authenticated USING (auth.uid() = user_id);

CREATE TABLE public.ai_usage (
  user_id uuid NOT NULL,
  month text NOT NULL,
  count int NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, month)
);
GRANT SELECT ON public.ai_usage TO authenticated;
GRANT ALL ON public.ai_usage TO service_role;
ALTER TABLE public.ai_usage ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view own ai usage" ON public.ai_usage FOR SELECT TO authenticated USING (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION public.get_tier(_user uuid, _env text)
RETURNS text LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT CASE
    WHEN EXISTS (SELECT 1 FROM purchases WHERE user_id=_user AND environment=_env AND kind='subscription'
      AND status IN ('active','trialing','past_due') AND (current_period_end IS NULL OR current_period_end > now())) THEN 'premium'
    WHEN EXISTS (SELECT 1 FROM purchases WHERE user_id=_user AND environment=_env AND kind='one_time' AND status='completed') THEN 'standard'
    ELSE 'free' END
$$;
REVOKE EXECUTE ON FUNCTION public.get_tier(uuid, text) FROM anon, public;
GRANT EXECUTE ON FUNCTION public.get_tier(uuid, text) TO authenticated, service_role;

ALTER PUBLICATION supabase_realtime ADD TABLE public.purchases;