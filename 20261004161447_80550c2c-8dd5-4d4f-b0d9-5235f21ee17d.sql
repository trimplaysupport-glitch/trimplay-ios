create type public.app_role as enum ('admin', 'user');
create table public.user_roles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  role app_role not null,
  unique (user_id, role)
);
grant select on public.user_roles to authenticated;
grant all on public.user_roles to service_role;
alter table public.user_roles enable row level security;
create policy "Users view own roles" on public.user_roles for select to authenticated using (auth.uid() = user_id);

create or replace function public.has_role(_user_id uuid, _role app_role)
returns boolean language sql stable security definer set search_path = public
as $$ select exists (select 1 from public.user_roles where user_id = _user_id and role = _role) $$;

create table public.payment_events (
  id uuid primary key default gen_random_uuid(),
  event_id text not null unique,
  event_type text not null,
  environment text not null,
  user_id uuid,
  customer_email text,
  product_id text,
  paddle_ref text,
  amount numeric,
  currency text,
  status text,
  occurred_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);
create index idx_payment_events_env_time on public.payment_events(environment, occurred_at desc);
grant select on public.payment_events to authenticated;
grant all on public.payment_events to service_role;
alter table public.payment_events enable row level security;
create policy "Admins view payment events" on public.payment_events for select to authenticated using (public.has_role(auth.uid(), 'admin'));

insert into public.user_roles (user_id, role) values
  ('af28f8fe-ed42-4379-98d6-eacd7b308865', 'admin'),
  ('441cded5-d653-4ee9-8bfd-acc7e792693c', 'admin')
on conflict do nothing;