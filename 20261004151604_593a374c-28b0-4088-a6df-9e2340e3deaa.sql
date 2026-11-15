CREATE TABLE public.library_sync (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  data jsonb NOT NULL,
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.library_sync TO authenticated;
GRANT ALL ON public.library_sync TO service_role;
ALTER TABLE public.library_sync ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view own library" ON public.library_sync FOR SELECT TO authenticated USING (auth.uid() = user_id);