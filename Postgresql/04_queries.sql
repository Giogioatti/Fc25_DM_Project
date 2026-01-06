-- =============================================
-- FC 25 BENCHMARK QUERIES (PostgreSQL)
-- =============================================

-- 1. Incrocio Dimensionale (Join su Tabelle Indipendenti)
EXPLAIN ANALYZE
SELECT p.name, n.name as nation, t.name as team
FROM players p
JOIN nationalities n ON p.nationality_id = n.nation_id
JOIN teams t ON p.team_id = t.team_id
WHERE n.name = 'France'
AND t.name = 'Real Madrid';

-- 2. Aggregazione Statistica (Analisi Dati)
EXPLAIN ANALYZE
SELECT n.name, COUNT(*) as total, ROUND(AVG(p.age), 1) as avg_age
FROM players p
JOIN nationalities n ON p.nationality_id = n.nation_id
GROUP BY n.name
HAVING COUNT(*) >= 30
ORDER BY avg_age ASC
LIMIT 5;

-- 3. Aggiornamento Annidato (Scrittura)
EXPLAIN ANALYZE
UPDATE player_stats
SET stamina = stamina + 1
FROM players p
WHERE player_stats.player_id = p.player_id
AND p.age > 30;

-- 4. Ricerca Testuale (Pattern Matching)
EXPLAIN ANALYZE
SELECT p.name, t.name as team
FROM players p
JOIN teams t ON p.team_id = t.team_id
WHERE p.name LIKE 'Ro%'
AND t.name LIKE '%United';

-- 5. Polimorfismo e Schema Flessibile
EXPLAIN ANALYZE
SELECT p.name, p.position, gs.gk_diving, ps.dribbling
FROM players p
LEFT JOIN goalkeeping_stats gs ON p.player_id = gs.player_id
LEFT JOIN player_stats ps ON p.player_id = ps.player_id
WHERE gs.gk_diving > 88
OR ps.dribbling > 90;

-- 6. Gestione Array e Liste
EXPLAIN ANALYZE
SELECT p.name
FROM players p
JOIN player_playstyles ps ON p.player_id = ps.player_id
WHERE ps.playstyle_name IN ('Flair', 'Rapid')
GROUP BY p.player_id, p.name
HAVING COUNT(DISTINCT ps.playstyle_name) = 2;

-- 7. Confronto tra Campi (Intra-row Comparison)
EXPLAIN ANALYZE
SELECT p.name, ps.passing, ps.shooting
FROM players p
JOIN player_stats ps ON p.player_id = ps.player_id
WHERE ps.passing > (ps.shooting + 15);

-- 8. Window Functions (Analisi Avanzata)
EXPLAIN ANALYZE
SELECT DISTINCT ON (l.name)
l.name as league, p.name as best_player, p.overall_rating
FROM players p
JOIN teams t ON p.team_id = t.team_id
JOIN leagues l ON t.league_id = l.league_id
ORDER BY l.name, p.overall_rating DESC;

-- 9. Schema Evolution
-- Passo A
ALTER TABLE players ADD COLUMN scouting_status VARCHAR(50);

-- Passo B
EXPLAIN ANALYZE
UPDATE players
SET scouting_status = 'High Potential'
WHERE age < 21;

ALTER TABLE players DROP COLUMN scouting_status; --(Optional Cleanup)