-- Duplikate löschen: Identische Einträge (gleicher User, Datum, Zeit, Kunde, Aufgabe)
-- Behält jeweils den ÄLTESTEN Eintrag (kleinste ID) und löscht alle Kopien.
-- Einfach komplett im Supabase SQL Editor ausführen.

-- Schritt 1: VORSCHAU - zeigt was gelöscht wird
SELECT
  e.id,
  e.user_id,
  p.name AS user_name,
  e.date,
  e.from_time,
  e.to_time,
  e.customer_name,
  e.task
FROM entries e
JOIN profiles p ON p.id = e.user_id
WHERE e.deleted = false
  AND e.id NOT IN (
    SELECT MIN(e2.id)
    FROM entries e2
    WHERE e2.deleted = false
    GROUP BY e2.user_id, e2.date, e2.from_time, e2.to_time,
             COALESCE(e2.customer_name, ''), COALESCE(e2.task, '')
  )
ORDER BY e.date DESC, e.from_time;

-- Schritt 2: LÖSCHEN - entfernt alle Duplikate (soft-delete)
-- WICHTIG: Erst Schritt 1 prüfen, dann diesen Block ausführen!
/*
UPDATE entries SET deleted = true
WHERE deleted = false
  AND id NOT IN (
    SELECT MIN(e2.id)
    FROM entries e2
    WHERE e2.deleted = false
    GROUP BY e2.user_id, e2.date, e2.from_time, e2.to_time,
             COALESCE(e2.customer_name, ''), COALESCE(e2.task, '')
  );
*/
