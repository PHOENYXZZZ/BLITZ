-- ============================================================
--  BLITZ v60 – Individuelle Wochenstunden pro Benutzer
-- ============================================================
--  ANLEITUNG: Im Supabase Dashboard → SQL Editor → Neue Query →
--  Diesen GESAMTEN Inhalt einfügen → Run klicken.
--
--  Was dieses Update macht:
--  1. Neue Spalte weekly_hours in profiles (Standard: 39)
--  2. Login-RPC gibt weekly_hours zurück
--  3. Admin-RPCs geben weekly_hours zurück / akzeptieren es
--  4. Neue RPC: admin_update_user_hours
-- ============================================================


-- ─────────────────────────────────────────────────
--  SCHRITT 1: Spalte hinzufügen
-- ─────────────────────────────────────────────────

ALTER TABLE profiles ADD COLUMN IF NOT EXISTS weekly_hours numeric DEFAULT 39;

-- Bestehende Benutzer auf 39h setzen (falls NULL)
UPDATE profiles SET weekly_hours = 39 WHERE weekly_hours IS NULL;


-- ─────────────────────────────────────────────────
--  SCHRITT 2: login_with_code – weekly_hours zurückgeben
-- ─────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION login_with_code(p_code text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_profile profiles%ROWTYPE;
BEGIN
  SELECT * INTO v_profile FROM profiles WHERE code = lower(trim(p_code));
  IF v_profile IS NULL THEN
    RETURN NULL;
  END IF;
  RETURN jsonb_build_object(
    'id',           v_profile.id,
    'name',         v_profile.name,
    'role',         v_profile.role,
    'code',         v_profile.code,
    'weekly_hours', COALESCE(v_profile.weekly_hours, 39)
  );
END;
$$;


-- ─────────────────────────────────────────────────
--  SCHRITT 3: get_all_users_admin – weekly_hours zurückgeben
-- ─────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION get_all_users_admin(p_admin_code text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_role text;
BEGIN
  SELECT role INTO v_role FROM profiles WHERE code = p_admin_code;
  IF v_role IS NULL OR v_role != 'admin' THEN
    RAISE EXCEPTION 'Keine Admin-Berechtigung';
  END IF;
  RETURN COALESCE((
    SELECT jsonb_agg(jsonb_build_object(
      'id', p.id, 'name', p.name, 'code', p.code, 'role', p.role,
      'weekly_hours', COALESCE(p.weekly_hours, 39)
    ) ORDER BY p.name)
    FROM profiles p
  ), '[]'::jsonb);
END;
$$;


-- ─────────────────────────────────────────────────
--  SCHRITT 4: admin_create_user – weekly_hours akzeptieren
-- ─────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION admin_create_user(p_admin_code text, p_code text, p_name text, p_role text, p_weekly_hours numeric DEFAULT 39)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_role text;
  v_new_id uuid;
BEGIN
  SELECT role INTO v_role FROM profiles WHERE code = p_admin_code;
  IF v_role IS NULL OR v_role != 'admin' THEN
    RAISE EXCEPTION 'Keine Admin-Berechtigung';
  END IF;

  INSERT INTO profiles (code, name, role, weekly_hours)
  VALUES (lower(trim(p_code)), trim(p_name), p_role, COALESCE(p_weekly_hours, 39))
  RETURNING id INTO v_new_id;

  RETURN jsonb_build_object('id', v_new_id, 'code', p_code, 'name', p_name, 'role', p_role, 'weekly_hours', COALESCE(p_weekly_hours, 39));
END;
$$;


-- ─────────────────────────────────────────────────
--  SCHRITT 5: admin_update_user_hours – Wochenstunden ändern
-- ─────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION admin_update_user_hours(p_admin_code text, p_user_id uuid, p_weekly_hours numeric)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_role text;
BEGIN
  SELECT role INTO v_role FROM profiles WHERE code = p_admin_code;
  IF v_role IS NULL OR v_role != 'admin' THEN
    RAISE EXCEPTION 'Keine Admin-Berechtigung';
  END IF;

  UPDATE profiles SET weekly_hours = p_weekly_hours WHERE id = p_user_id;
END;
$$;


-- ─────────────────────────────────────────────────
--  SCHRITT 6: get_team_entries_admin – weekly_hours zurückgeben
-- ─────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION get_team_entries_admin(p_admin_code text, p_month text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_role text;
BEGIN
  SELECT role INTO v_role FROM profiles WHERE code = p_admin_code;
  IF v_role IS NULL OR v_role != 'admin' THEN
    RAISE EXCEPTION 'Keine Admin-Berechtigung';
  END IF;
  RETURN COALESCE((
    SELECT jsonb_agg(jsonb_build_object(
      'id', e.id, 'date', e.date, 'from_time', e.from_time, 'to_time', e.to_time,
      'break_min', e.break_min, 'customer_name', e.customer_name,
      'transferred', e.transferred, 'user_name', p.name,
      'weekly_hours', COALESCE(p.weekly_hours, 39)
    ))
    FROM entries e
    JOIN profiles p ON p.id = e.user_id
    WHERE e.deleted = false
      AND e.date >= (p_month || '-01')::date
      AND e.date <= (p_month || '-31')::date
  ), '[]'::jsonb);
END;
$$;
