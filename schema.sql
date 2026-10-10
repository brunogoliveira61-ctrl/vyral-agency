-- VYRAL: esquema inicial. Revise e teste antes de usar com dados reais.
create extension if not exists pgcrypto;

create type public.user_role as enum ('admin', 'manager', 'creator');
create type public.application_status as enum ('pending', 'approved', 'rejected');
create type public.video_status as enum ('submitted', 'in_review', 'changes_requested', 'approved', 'published', 'rejected');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  role public.user_role not null default 'creator',
  created_at timestamptz not null default now()
);

create table public.creator_applications (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  email text not null,
  social_handle text not null,
  niche text not null,
  experience text not null,
  status public.application_status not null default 'pending',
  created_at timestamptz not null default now()
);

create table public.creators (
  id uuid primary key default gen_random_uuid(),
  user_id uuid unique references public.profiles(id) on delete set null,
  display_name text not null,
  social_handle text not null,
  niche text,
  status text not null default 'pending' check (status in ('pending','active','paused','rejected')),
  created_at timestamptz not null default now()
);

create table public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  product_url text,
  seller_name text,
  listed_price numeric(12,2),
  stated_commission numeric(12,2),
  commission_type text not null default 'unknown' check (commission_type in ('fixed','percentage','unknown')),
  stock_status text,
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);

create table public.videos (
  id uuid primary key default gen_random_uuid(),
  creator_id uuid not null references public.creators(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  title text not null,
  asset_url text,
  individual_post_url text,
  agency_post_url text,
  status public.video_status not null default 'submitted',
  brief text,
  review_notes text,
  submitted_at timestamptz not null default now(),
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz,
  published_at timestamptz
);

create table public.performance (
  id uuid primary key default gen_random_uuid(),
  video_id uuid not null references public.videos(id) on delete cascade,
  recorded_by uuid references public.profiles(id),
  period_end date not null default current_date,
  views bigint not null default 0 check (views >= 0),
  product_clicks bigint not null default 0 check (product_clicks >= 0),
  attributed_orders bigint not null default 0 check (attributed_orders >= 0),
  cancelled_orders bigint not null default 0 check (cancelled_orders >= 0),
  estimated_commission numeric(12,2) not null default 0 check (estimated_commission >= 0),
  settled_commission numeric(12,2) not null default 0 check (settled_commission >= 0),
  notes text,
  created_at timestamptz not null default now(),
  unique(video_id, period_end)
);

create or replace function public.current_role()
returns public.user_role
language sql stable security definer
set search_path = public
as $$
  select role from public.profiles where id = auth.uid()
$$;

alter table public.profiles enable row level security;
alter table public.creator_applications enable row level security;
alter table public.creators enable row level security;
alter table public.products enable row level security;
alter table public.videos enable row level security;
alter table public.performance enable row level security;

-- Profiles: users can read/update only their own profile; admin/manager can read all.
create policy "profile self read" on public.profiles for select to authenticated
using (id = auth.uid() or public.current_role() in ('admin','manager'));
create policy "profile self update" on public.profiles for update to authenticated
using (id = auth.uid()) with check (id = auth.uid());

-- Public application form: allow submission only. Do not expose public SELECT.
-- Prefer a server-side endpoint with rate limiting/CAPTCHA before enabling anonymous inserts.
create policy "public application submission" on public.creator_applications
for insert to anon, authenticated with check (status = 'pending');
create policy "staff manage applications" on public.creator_applications
for all to authenticated using (public.current_role() in ('admin','manager'))
with check (public.current_role() in ('admin','manager'));

create policy "staff manage creators" on public.creators for all to authenticated
using (public.current_role() in ('admin','manager'))
with check (public.current_role() in ('admin','manager'));
create policy "creator read own record" on public.creators for select to authenticated
using (user_id = auth.uid());

create policy "authenticated read products" on public.products for select to authenticated using (true);
create policy "staff manage products" on public.products for all to authenticated
using (public.current_role() in ('admin','manager'))
with check (public.current_role() in ('admin','manager'));

create policy "staff manage videos" on public.videos for all to authenticated
using (public.current_role() in ('admin','manager'))
with check (public.current_role() in ('admin','manager'));
create policy "creator read own videos" on public.videos for select to authenticated
using (exists (select 1 from public.creators c where c.id = videos.creator_id and c.user_id = auth.uid()));
create policy "creator submit own videos" on public.videos for insert to authenticated
with check (exists (select 1 from public.creators c where c.id = videos.creator_id and c.user_id = auth.uid()) and status = 'submitted');

create policy "staff manage performance" on public.performance for all to authenticated
using (public.current_role() in ('admin','manager'))
with check (public.current_role() in ('admin','manager'));
create policy "creator read own performance" on public.performance for select to authenticated
using (exists (select 1 from public.videos v join public.creators c on c.id = v.creator_id where v.id = performance.video_id and c.user_id = auth.uid()));

-- Important:
-- 1) Create the first admin securely using a trusted server-side process; never allow public role escalation.
-- 2) Test every policy with separate accounts and Supabase's policy tester.
-- 3) Add rate limiting/CAPTCHA to public applications.
-- 4) Restrict file uploads using private Storage buckets and short-lived signed URLs.
-- 5) This schema is a starter and requires a security review before production.
