-- Выполни этот SQL в Supabase → SQL Editor → New query.
create table if not exists public.cinema_items (
  user_id uuid not null references auth.users(id) on delete cascade,
  media_id text not null,
  media_data jsonb not null,
  rating integer null check (rating between 1 and 10),
  created_at timestamptz not null default now(),
  primary key (user_id, media_id)
);

alter table public.cinema_items enable row level security;

create policy "Users can read their own collection"
on public.cinema_items for select
using (auth.uid() = user_id);

create policy "Users can add to their own collection"
on public.cinema_items for insert
with check (auth.uid() = user_id);

create policy "Users can update their own collection"
on public.cinema_items for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "Users can delete their own collection"
on public.cinema_items for delete
using (auth.uid() = user_id);
