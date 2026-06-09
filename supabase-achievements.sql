-- 업적 카테고리
CREATE TABLE IF NOT EXISTS public.achievement_categories (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name       TEXT NOT NULL,           -- 노래대회, 섭종콘, 마크서버 등
  color      TEXT DEFAULT '#E6B84A',  -- 형광펜 색상
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.achievement_categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read ach_cat"  ON public.achievement_categories FOR SELECT USING (true);
CREATE POLICY "auth all ach_cat"     ON public.achievement_categories FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- 업적 항목
CREATE TABLE IF NOT EXISTS public.achievements (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id UUID REFERENCES public.achievement_categories(id) ON DELETE SET NULL,
  year        INT,                     -- 연도 (2024, 2025 등)
  date_label  TEXT,                    -- 표시 날짜 (01.22, 02.15 등)
  content     TEXT NOT NULL,           -- 업적 내용
  sort_order  INT DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_achievements_year ON public.achievements(year);
CREATE INDEX IF NOT EXISTS idx_achievements_cat  ON public.achievements(category_id);
ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read ach"  ON public.achievements FOR SELECT USING (true);
CREATE POLICY "auth all ach"     ON public.achievements FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- 기본 카테고리 삽입
INSERT INTO public.achievement_categories (name, color, sort_order) VALUES
  ('노래대회', '#FF5C8A', 0),
  ('섭종콘',   '#9F7AEA', 1),
  ('마크서버', '#3BAD7A', 2),
  ('컨텐츠',  '#4299E1', 3),
  ('커버곡',  '#E6B84A', 4),
  ('기념일',  '#ED8936', 5)
ON CONFLICT DO NOTHING;
