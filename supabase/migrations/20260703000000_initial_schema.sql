-- DisciplineOS Database Schema
-- Initial migration with all tables, RLS policies, and triggers

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- 1. USER PROFILES TABLE
-- =====================================================
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  identity_level TEXT DEFAULT 'novice' CHECK (identity_level IN ('novice', 'practitioner', 'architect', 'master')),
  identity_score INTEGER DEFAULT 0 CHECK (identity_score >= 0 AND identity_score <= 100),
  timezone TEXT DEFAULT 'UTC',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_user_profiles_email ON user_profiles(email);
CREATE INDEX idx_user_profiles_identity_level ON user_profiles(identity_level);

-- =====================================================
-- 2. BEHAVIORAL LOGS TABLE
-- =====================================================
CREATE TABLE behavioral_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  log_type TEXT NOT NULL CHECK (log_type IN ('focus', 'distraction', 'reflection', 'habit', 'mood', 'energy')),
  score INTEGER CHECK (score >= 0 AND score <= 100),
  duration_minutes INTEGER CHECK (duration_minutes >= 0),
  metadata JSONB DEFAULT '{}',
  recorded_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_behavioral_logs_user_id ON behavioral_logs(user_id);
CREATE INDEX idx_behavioral_logs_log_type ON behavioral_logs(log_type);
CREATE INDEX idx_behavioral_logs_recorded_at ON behavioral_logs(recorded_at DESC);
CREATE INDEX idx_behavioral_logs_user_type_date ON behavioral_logs(user_id, log_type, recorded_at DESC);

-- =====================================================
-- 3. DAILY REFLECTIONS TABLE
-- =====================================================
CREATE TABLE daily_reflections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  reflection_type TEXT NOT NULL CHECK (reflection_type IN ('morning', 'evening')),
  mood TEXT CHECK (mood IN ('calm', 'stable', 'focused', 'high_energy', 'restless')),
  energy_level INTEGER CHECK (energy_level >= 0 AND energy_level <= 100),
  content TEXT,
  voice_url TEXT,
  ai_synthesis TEXT,
  recorded_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_daily_reflections_user_id ON daily_reflections(user_id);
CREATE INDEX idx_daily_reflections_type ON daily_reflections(reflection_type);
CREATE INDEX idx_daily_reflections_recorded_at ON daily_reflections(recorded_at DESC);

-- =====================================================
-- 4. AI INSIGHTS TABLE
-- =====================================================
CREATE TABLE ai_insights (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  insight_type TEXT NOT NULL CHECK (insight_type IN ('pattern', 'recommendation', 'challenge', 'summary', 'alert')),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  confidence_score FLOAT CHECK (confidence_score >= 0 AND confidence_score <= 1),
  metadata JSONB DEFAULT '{}',
  is_read BOOLEAN DEFAULT FALSE,
  is_dismissed BOOLEAN DEFAULT FALSE,
  generated_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_ai_insights_user_id ON ai_insights(user_id);
CREATE INDEX idx_ai_insights_type ON ai_insights(insight_type);
CREATE INDEX idx_ai_insights_unread ON ai_insights(user_id, is_read) WHERE is_read = FALSE;

-- =====================================================
-- 5. GOALS TABLE
-- =====================================================
CREATE TABLE goals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT CHECK (category IN ('focus', 'habit', 'reflection', 'identity')),
  target_value INTEGER,
  current_value INTEGER DEFAULT 0,
  unit TEXT,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'paused', 'abandoned')),
  deadline TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_goals_user_id ON goals(user_id);
CREATE INDEX idx_goals_status ON goals(user_id, status);
CREATE INDEX idx_goals_category ON goals(category);

-- =====================================================
-- 6. FOCUS SESSIONS TABLE
-- =====================================================
CREATE TABLE focus_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  title TEXT,
  protocol TEXT,
  duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
  actual_minutes INTEGER,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'paused', 'completed', 'cancelled')),
  score INTEGER CHECK (score >= 0 AND score <= 100),
  ambient_sound TEXT,
  distractions_count INTEGER DEFAULT 0,
  started_at TIMESTAMPTZ DEFAULT NOW(),
  ended_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_focus_sessions_user_id ON focus_sessions(user_id);
CREATE INDEX idx_focus_sessions_status ON focus_sessions(user_id, status);
CREATE INDEX idx_focus_sessions_started_at ON focus_sessions(started_at DESC);

-- =====================================================
-- 7. BEHAVIOR TIMELINE TABLE
-- =====================================================
CREATE TABLE behavior_timeline (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL CHECK (event_type IN ('peak', 'distraction', 'clarity', 'milestone', 'alert', 'reflection')),
  title TEXT NOT NULL,
  description TEXT,
  icon TEXT,
  color TEXT,
  metadata JSONB DEFAULT '{}',
  event_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_behavior_timeline_user_id ON behavior_timeline(user_id);
CREATE INDEX idx_behavior_timeline_type ON behavior_timeline(event_type);
CREATE INDEX idx_behavior_timeline_event_at ON behavior_timeline(event_at DESC);

-- =====================================================
-- 8. NOTIFICATIONS TABLE
-- =====================================================
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  notification_type TEXT CHECK (notification_type IN ('reminder', 'insight', 'challenge', 'alert', 'achievement')),
  is_read BOOLEAN DEFAULT FALSE,
  action_url TEXT,
  metadata JSONB DEFAULT '{}',
  scheduled_at TIMESTAMPTZ,
  sent_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read) WHERE is_read = FALSE;
CREATE INDEX idx_notifications_scheduled ON notifications(scheduled_at) WHERE scheduled_at IS NOT NULL;

-- =====================================================
-- 9. APP SETTINGS TABLE
-- =====================================================
CREATE TABLE app_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  setting_key TEXT NOT NULL,
  setting_value JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, setting_key)
);

-- Indexes
CREATE INDEX idx_app_settings_user_id ON app_settings(user_id);
CREATE INDEX idx_app_settings_key ON app_settings(user_id, setting_key);

-- =====================================================
-- 10. USER ACHIEVEMENTS TABLE
-- =====================================================
CREATE TABLE user_achievements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  achievement_type TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  icon TEXT,
  color TEXT,
  unlocked_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_user_achievements_user_id ON user_achievements(user_id);
CREATE INDEX idx_user_achievements_type ON user_achievements(achievement_type);

-- =====================================================
-- 11. AI COACH CONVERSATIONS TABLE
-- =====================================================
CREATE TABLE ai_coach_conversations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  title TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_ai_coach_conversations_user_id ON ai_coach_conversations(user_id);

-- =====================================================
-- 12. AI COACH MESSAGES TABLE
-- =====================================================
CREATE TABLE ai_coach_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID NOT NULL REFERENCES ai_coach_conversations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_ai_coach_messages_conversation_id ON ai_coach_messages(conversation_id);
CREATE INDEX idx_ai_coach_messages_user_id ON ai_coach_messages(user_id);

-- =====================================================
-- UPDATED_AT TRIGGER FUNCTION
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at trigger to all tables
CREATE TRIGGER update_user_profiles_updated_at
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_daily_reflections_updated_at
  BEFORE UPDATE ON daily_reflections
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_goals_updated_at
  BEFORE UPDATE ON goals
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_app_settings_updated_at
  BEFORE UPDATE ON app_settings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE behavioral_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_reflections ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_insights ENABLE ROW LEVEL SECURITY;
ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE focus_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE behavior_timeline ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_coach_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_coach_messages ENABLE ROW LEVEL SECURITY;

-- User Profiles RLS
CREATE POLICY "Users can view own profile"
  ON user_profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON user_profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON user_profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Behavioral Logs RLS
CREATE POLICY "Users can view own behavioral logs"
  ON behavioral_logs FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own behavioral logs"
  ON behavioral_logs FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own behavioral logs"
  ON behavioral_logs FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own behavioral logs"
  ON behavioral_logs FOR DELETE
  USING (auth.uid() = user_id);

-- Daily Reflections RLS
CREATE POLICY "Users can view own reflections"
  ON daily_reflections FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own reflections"
  ON daily_reflections FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own reflections"
  ON daily_reflections FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own reflections"
  ON daily_reflections FOR DELETE
  USING (auth.uid() = user_id);

-- AI Insights RLS
CREATE POLICY "Users can view own AI insights"
  ON ai_insights FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own AI insights"
  ON ai_insights FOR UPDATE
  USING (auth.uid() = user_id);

-- Goals RLS
CREATE POLICY "Users can view own goals"
  ON goals FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own goals"
  ON goals FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own goals"
  ON goals FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own goals"
  ON goals FOR DELETE
  USING (auth.uid() = user_id);

-- Focus Sessions RLS
CREATE POLICY "Users can view own focus sessions"
  ON focus_sessions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own focus sessions"
  ON focus_sessions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own focus sessions"
  ON focus_sessions FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own focus sessions"
  ON focus_sessions FOR DELETE
  USING (auth.uid() = user_id);

-- Behavior Timeline RLS
CREATE POLICY "Users can view own timeline"
  ON behavior_timeline FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own timeline events"
  ON behavior_timeline FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own timeline events"
  ON behavior_timeline FOR DELETE
  USING (auth.uid() = user_id);

-- Notifications RLS
CREATE POLICY "Users can view own notifications"
  ON notifications FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications"
  ON notifications FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own notifications"
  ON notifications FOR DELETE
  USING (auth.uid() = user_id);

-- App Settings RLS
CREATE POLICY "Users can view own settings"
  ON app_settings FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own settings"
  ON app_settings FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own settings"
  ON app_settings FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own settings"
  ON app_settings FOR DELETE
  USING (auth.uid() = user_id);

-- User Achievements RLS
CREATE POLICY "Users can view own achievements"
  ON user_achievements FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own achievements"
  ON user_achievements FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- AI Coach Conversations RLS
CREATE POLICY "Users can view own conversations"
  ON ai_coach_conversations FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own conversations"
  ON ai_coach_conversations FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own conversations"
  ON ai_coach_conversations FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own conversations"
  ON ai_coach_conversations FOR DELETE
  USING (auth.uid() = user_id);

-- AI Coach Messages RLS
CREATE POLICY "Users can view own messages"
  ON ai_coach_messages FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own messages"
  ON ai_coach_messages FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- =====================================================
-- STORAGE BUCKETS
-- =====================================================

-- Avatars bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true);

CREATE POLICY "Avatar images are publicly accessible"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'avatars');

CREATE POLICY "Anyone can upload an avatar"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'avatars');

CREATE POLICY "Users can update own avatar"
  ON storage.objects FOR UPDATE
  USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Voice recordings bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('voice-recordings', 'voice-recordings', false);

CREATE POLICY "Users can view own voice recordings"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'voice-recordings' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can upload own voice recordings"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'voice-recordings' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete own voice recordings"
  ON storage.objects FOR DELETE
  USING (bucket_id = 'voice-recordings' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Export data bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('exports', 'exports', false);

CREATE POLICY "Users can view own exports"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'exports' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can upload own exports"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'exports' AND auth.uid()::text = (storage.foldername(name))[1]);

-- =====================================================
-- USER PROFILE AUTO-CREATION TRIGGER
-- =====================================================
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO user_profiles (id, email, display_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'display_name');
  RETURN NEW;
END;
$$ language 'plpgsql' SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
