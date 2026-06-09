-- ──────────────────────────────────────────
--  노아란 사이트 Supabase 초기 셋업
-- ──────────────────────────────────────────

-- 1. 방송 일정
CREATE TABLE IF NOT EXISTS public.schedules (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date        DATE NOT NULL UNIQUE,
  status      TEXT DEFAULT 'normal', -- normal | holiday | special | anniversary
  slot1_title TEXT,
  slot2_title TEXT,
  slot1_time  TEXT DEFAULT '22:00',
  slot2_time  TEXT,
  note        TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.schedules ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read schedules"  ON public.schedules FOR SELECT USING (true);
CREATE POLICY "auth insert schedules"  ON public.schedules FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "auth update schedules"  ON public.schedules FOR UPDATE TO authenticated USING (true);
CREATE POLICY "auth delete schedules"  ON public.schedules FOR DELETE TO authenticated USING (true);

-- 2. VOD 클립 (노래 커버 영상)
CREATE TABLE IF NOT EXISTS public.vod_clips (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title      TEXT NOT NULL,
  vod_id     TEXT NOT NULL,   -- SOOP VOD ID (embed URL용)
  thumb_url  TEXT DEFAULT NULL,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.vod_clips ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read vod_clips"  ON public.vod_clips FOR SELECT USING (true);
CREATE POLICY "auth all vod_clips"     ON public.vod_clips FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- 기존 테이블에 thumb_url 컬럼 추가 (이미 생성된 경우)
ALTER TABLE public.vod_clips ADD COLUMN IF NOT EXISTS thumb_url TEXT DEFAULT NULL;

-- 3. 방송 일정 이벤트 (냔냐 동일 구조)
CREATE TABLE IF NOT EXISTS public.schedule_events (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date        DATE NOT NULL,
  time        TEXT,
  title       TEXT NOT NULL,
  description TEXT,
  tags        TEXT[] DEFAULT '{}',
  is_special  BOOLEAN DEFAULT FALSE,
  is_hidden   BOOLEAN DEFAULT FALSE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_schedule_events_date ON public.schedule_events(date);
ALTER TABLE public.schedule_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read events"  ON public.schedule_events FOR SELECT USING (true);
CREATE POLICY "auth all events"     ON public.schedule_events FOR ALL TO authenticated USING (true) WITH CHECK (true);
