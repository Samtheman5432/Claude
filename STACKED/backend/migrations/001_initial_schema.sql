-- ============================================================
-- STACKED - Initial Database Schema
-- Supabase PostgreSQL Migration 001
-- ============================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- ============================================================
-- PROFILES
-- ============================================================
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT UNIQUE NOT NULL,
    email TEXT NOT NULL,
    avatar_url TEXT,
    money_iq INTEGER NOT NULL DEFAULT 500 CHECK (money_iq >= 0 AND money_iq <= 1000),
    level INTEGER NOT NULL DEFAULT 1 CHECK (level >= 1),
    xp INTEGER NOT NULL DEFAULT 0 CHECK (xp >= 0),
    xp_to_next_level INTEGER NOT NULL DEFAULT 500,
    current_streak INTEGER NOT NULL DEFAULT 0 CHECK (current_streak >= 0),
    longest_streak INTEGER NOT NULL DEFAULT 0 CHECK (longest_streak >= 0),
    last_active_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    financial_goals TEXT[] DEFAULT '{}',
    experience_level TEXT NOT NULL DEFAULT 'beginner',
    interests TEXT[] DEFAULT '{}',
    subscription_tier TEXT NOT NULL DEFAULT 'free' CHECK (subscription_tier IN ('free', 'premium', 'annual')),
    total_challenges_completed INTEGER NOT NULL DEFAULT 0,
    total_simulations_run INTEGER NOT NULL DEFAULT 0,
    financial_archetype TEXT NOT NULL DEFAULT 'curious',
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT username_length CHECK (char_length(username) >= 3 AND char_length(username) <= 30),
    CONSTRAINT username_format CHECK (username ~ '^[a-zA-Z0-9_]+$')
);

-- ============================================================
-- CHALLENGES
-- ============================================================
CREATE TABLE challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    scenario TEXT NOT NULL,
    options JSONB NOT NULL,
    correct_index INTEGER NOT NULL CHECK (correct_index >= 0),
    explanation TEXT NOT NULL,
    category TEXT NOT NULL,
    difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard', 'expert')),
    xp_reward INTEGER NOT NULL DEFAULT 75 CHECK (xp_reward > 0),
    money_iq_gain INTEGER NOT NULL DEFAULT 3,
    estimated_seconds INTEGER NOT NULL DEFAULT 60,
    image_url TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- CHALLENGE ATTEMPTS
-- ============================================================
CREATE TABLE challenge_attempts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    challenge_id UUID NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    selected_index INTEGER NOT NULL,
    is_correct BOOLEAN NOT NULL,
    xp_earned INTEGER NOT NULL DEFAULT 0,
    completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    time_spent_seconds INTEGER NOT NULL DEFAULT 0,
    UNIQUE(challenge_id, user_id, DATE(completed_at))  -- one attempt per challenge per day
);

-- ============================================================
-- STREAKS
-- ============================================================
CREATE TABLE streaks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE UNIQUE,
    current_streak INTEGER NOT NULL DEFAULT 0,
    longest_streak INTEGER NOT NULL DEFAULT 0,
    last_completed_date DATE,
    streak_started_at DATE,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- ACHIEVEMENTS
-- ============================================================
CREATE TABLE achievements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    emoji TEXT NOT NULL,
    category TEXT NOT NULL,
    requirement JSONB NOT NULL,
    xp_reward INTEGER NOT NULL DEFAULT 100,
    rarity TEXT NOT NULL CHECK (rarity IN ('common', 'rare', 'epic', 'legendary')),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- USER ACHIEVEMENTS
-- ============================================================
CREATE TABLE user_achievements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    achievement_id UUID NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
    unlocked_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, achievement_id)
);

-- ============================================================
-- SIMULATIONS
-- ============================================================
CREATE TABLE simulations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    prompt TEXT NOT NULL,
    result JSONB NOT NULL,
    tokens_used INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- COACH SESSIONS
-- ============================================================
CREATE TABLE coach_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    messages JSONB NOT NULL DEFAULT '[]',
    title TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- SUBSCRIPTIONS
-- ============================================================
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE UNIQUE,
    tier TEXT NOT NULL CHECK (tier IN ('free', 'premium', 'annual')),
    revenue_cat_customer_id TEXT,
    is_active BOOLEAN NOT NULL DEFAULT false,
    expires_at TIMESTAMPTZ,
    trial_ends_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- FRIENDSHIPS
-- ============================================================
CREATE TABLE friendships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    friend_user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'blocked')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, friend_user_id),
    CHECK (user_id != friend_user_id)
);

-- ============================================================
-- LEADERBOARD SCORES
-- ============================================================
CREATE TABLE leaderboard_scores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    week_start DATE NOT NULL,
    weekly_xp INTEGER NOT NULL DEFAULT 0,
    money_iq INTEGER NOT NULL DEFAULT 500,
    rank_position INTEGER,
    rank_change INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, week_start)
);

-- ============================================================
-- ANALYTICS EVENTS
-- ============================================================
CREATE TABLE analytics_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    event_name TEXT NOT NULL,
    properties JSONB DEFAULT '{}',
    session_id TEXT,
    app_version TEXT,
    platform TEXT DEFAULT 'ios',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX idx_challenge_attempts_user_id ON challenge_attempts(user_id);
CREATE INDEX idx_challenge_attempts_challenge_id ON challenge_attempts(challenge_id);
CREATE INDEX idx_challenge_attempts_completed_at ON challenge_attempts(completed_at);
CREATE INDEX idx_simulations_user_id ON simulations(user_id);
CREATE INDEX idx_coach_sessions_user_id ON coach_sessions(user_id);
CREATE INDEX idx_user_achievements_user_id ON user_achievements(user_id);
CREATE INDEX idx_leaderboard_week ON leaderboard_scores(week_start, money_iq DESC);
CREATE INDEX idx_analytics_events_user_id ON analytics_events(user_id);
CREATE INDEX idx_analytics_events_event_name ON analytics_events(event_name);
CREATE INDEX idx_analytics_events_created_at ON analytics_events(created_at);
CREATE INDEX idx_friendships_user_id ON friendships(user_id);
CREATE INDEX idx_friendships_friend_id ON friendships(friend_user_id);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

-- Profiles
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update their own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Public profiles are viewable" ON profiles FOR SELECT USING (true);

-- Challenge Attempts
ALTER TABLE challenge_attempts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own attempts" ON challenge_attempts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own attempts" ON challenge_attempts FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Streaks
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own streak" ON streaks FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update their own streak" ON streaks FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own streak" ON streaks FOR INSERT WITH CHECK (auth.uid() = user_id);

-- User Achievements
ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own achievements" ON user_achievements FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own achievements" ON user_achievements FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Simulations
ALTER TABLE simulations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own simulations" ON simulations FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own simulations" ON simulations FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Coach Sessions
ALTER TABLE coach_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own sessions" ON coach_sessions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage their own sessions" ON coach_sessions FOR ALL USING (auth.uid() = user_id);

-- Leaderboard (public read)
ALTER TABLE leaderboard_scores ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Leaderboard is publicly viewable" ON leaderboard_scores FOR SELECT USING (true);
CREATE POLICY "Users can update their own scores" ON leaderboard_scores FOR ALL USING (auth.uid() = user_id);

-- Friendships
ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own friendships" ON friendships FOR SELECT USING (auth.uid() = user_id OR auth.uid() = friend_user_id);
CREATE POLICY "Users can manage their own friendships" ON friendships FOR ALL USING (auth.uid() = user_id);

-- Analytics (insert only)
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can insert analytics" ON analytics_events FOR INSERT WITH CHECK (auth.uid() = user_id OR user_id IS NULL);

-- Challenges (public read)
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Challenges are publicly readable" ON challenges FOR SELECT USING (is_active = true);

-- Achievements (public read)
ALTER TABLE achievements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Achievements are publicly readable" ON achievements FOR SELECT USING (is_active = true);

-- ============================================================
-- FUNCTIONS & TRIGGERS
-- ============================================================

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger AS $$
BEGIN
    INSERT INTO public.profiles (id, username, email)
    VALUES (
        new.id,
        COALESCE(new.raw_user_meta_data->>'username', 'User' || substring(new.id::text, 1, 6)),
        new.email
    );

    INSERT INTO public.streaks (user_id)
    VALUES (new.id);

    INSERT INTO public.subscriptions (user_id, tier, is_active)
    VALUES (new.id, 'free', true);

    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Update streak function
CREATE OR REPLACE FUNCTION update_user_streak(p_user_id UUID)
RETURNS void AS $$
DECLARE
    v_last_date DATE;
    v_current_streak INTEGER;
    v_longest_streak INTEGER;
BEGIN
    SELECT last_completed_date, current_streak, longest_streak
    INTO v_last_date, v_current_streak, v_longest_streak
    FROM streaks WHERE user_id = p_user_id;

    IF v_last_date = CURRENT_DATE THEN
        -- Already completed today
        RETURN;
    ELSIF v_last_date = CURRENT_DATE - INTERVAL '1 day' THEN
        -- Consecutive day
        v_current_streak := v_current_streak + 1;
    ELSE
        -- Streak broken
        v_current_streak := 1;
    END IF;

    v_longest_streak := GREATEST(v_longest_streak, v_current_streak);

    UPDATE streaks SET
        current_streak = v_current_streak,
        longest_streak = v_longest_streak,
        last_completed_date = CURRENT_DATE,
        updated_at = NOW()
    WHERE user_id = p_user_id;

    UPDATE profiles SET
        current_streak = v_current_streak,
        longest_streak = v_longest_streak,
        last_active_date = NOW()
    WHERE id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Award XP function
CREATE OR REPLACE FUNCTION award_xp(p_user_id UUID, p_xp INTEGER, p_money_iq_gain INTEGER DEFAULT 0)
RETURNS void AS $$
DECLARE
    v_new_xp INTEGER;
    v_current_level INTEGER;
    v_xp_to_next INTEGER;
BEGIN
    SELECT xp, level, xp_to_next_level
    INTO v_new_xp, v_current_level, v_xp_to_next
    FROM profiles WHERE id = p_user_id;

    v_new_xp := v_new_xp + p_xp;

    -- Level up check
    WHILE v_new_xp >= v_xp_to_next LOOP
        v_new_xp := v_new_xp - v_xp_to_next;
        v_current_level := v_current_level + 1;
        v_xp_to_next := FLOOR(v_current_level * 500 * POWER(1.3, v_current_level - 1));
    END LOOP;

    UPDATE profiles SET
        xp = v_new_xp,
        level = v_current_level,
        xp_to_next_level = v_xp_to_next,
        money_iq = LEAST(1000, money_iq + p_money_iq_gain),
        updated_at = NOW()
    WHERE id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS trigger AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_streaks_updated_at BEFORE UPDATE ON streaks FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_subscriptions_updated_at BEFORE UPDATE ON subscriptions FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_leaderboard_updated_at BEFORE UPDATE ON leaderboard_scores FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- WEEKLY LEADERBOARD REFRESH
-- This should be called via a cron job every Monday
-- ============================================================
CREATE OR REPLACE FUNCTION refresh_weekly_leaderboard()
RETURNS void AS $$
DECLARE
    v_week_start DATE := DATE_TRUNC('week', CURRENT_DATE);
BEGIN
    INSERT INTO leaderboard_scores (user_id, week_start, weekly_xp, money_iq)
    SELECT id, v_week_start, 0, money_iq
    FROM profiles
    ON CONFLICT (user_id, week_start) DO NOTHING;

    -- Update ranks
    WITH ranked AS (
        SELECT id, money_iq,
               ROW_NUMBER() OVER (ORDER BY money_iq DESC, current_streak DESC) as rank
        FROM profiles
    )
    UPDATE leaderboard_scores ls SET
        rank_position = r.rank,
        money_iq = r.money_iq
    FROM ranked r
    WHERE ls.user_id = r.id AND ls.week_start = v_week_start;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
