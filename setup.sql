-- Incolla questo in Supabase > SQL Editor > Run
create table public.years (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  year int not null check (year between 1990 and 2100),
  created_at timestamptz default now(),
  unique (user_id, year)
);
alter table public.years enable row level security;
create policy "ognuno vede e modifica solo i suoi anni" on public.years
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Dati del patrimonio: una riga per utente e per anno
create table public.year_data (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  year int not null,
  data jsonb not null default '{"items":[]}',
  updated_at timestamptz default now(),
  primary key (user_id, year)
);
alter table public.year_data enable row level security;
create policy "ognuno vede e modifica solo i suoi dati" on public.year_data
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Impostazioni dell'utente valide per tutti gli anni: dizionario delle parole, categorie entrate, spese ricorrenti
create table public.user_settings (
  user_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  data jsonb not null default '{}',
  updated_at timestamptz default now()
);
alter table public.user_settings enable row level security;
create policy "ognuno vede e modifica solo le sue impostazioni" on public.user_settings
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
