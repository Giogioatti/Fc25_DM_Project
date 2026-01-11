-- =============================================
-- FC 25 BENCHMARK QUERIES (PostgreSQL)
-- =============================================


EXPLAIN ANALYZE
SELECT p.name, n.name as nation, t.name as team
FROM players p
JOIN nationalities n ON p.nationality_id = n.nation_id
JOIN teams t ON p.team_id = t.team_id
WHERE n.name = 'France'
AND t.name = 'Real Madrid';


EXPLAIN ANALYZE
SELECT n.name, COUNT(*) as total, ROUND(AVG(p.age), 1) as avg_age
FROM players p
JOIN nationalities n ON p.nationality_id = n.nation_id
GROUP BY n.name
HAVING COUNT(*) >= 30
ORDER BY avg_age ASC
LIMIT 5;

EXPLAIN ANALYZE
UPDATE player_stats
SET stamina = stamina + 1
FROM players p
WHERE player_stats.player_id = p.player_id
AND p.age > 30;

EXPLAIN ANALYZE
SELECT p.name, t.name as team
FROM players p
JOIN teams t ON p.team_id = t.team_id
WHERE p.name LIKE 'Ro%'
AND t.name LIKE '%United';

EXPLAIN ANALYZE
SELECT p.name, p.position, gs.gk_diving, ps.dribbling
FROM players p
LEFT JOIN goalkeeping_stats gs ON p.player_id = gs.player_id
LEFT JOIN player_stats ps ON p.player_id = ps.player_id
WHERE gs.gk_diving > 88
OR ps.dribbling > 90;

EXPLAIN ANALYZE
SELECT p.name
FROM players p
JOIN player_playstyles ps ON p.player_id = ps.player_id
WHERE ps.playstyle_name IN ('Flair', 'Rapid')
GROUP BY p.player_id, p.name
HAVING COUNT(DISTINCT ps.playstyle_name) = 2;

EXPLAIN ANALYZE
SELECT p.name, ps.passing, ps.shooting
FROM players p
JOIN player_stats ps ON p.player_id = ps.player_id
WHERE ps.passing > (ps.shooting + 15);

EXPLAIN ANALYZE
SELECT DISTINCT ON (l.name)
l.name as league, p.name as best_player, p.overall_rating
FROM players p
JOIN teams t ON p.team_id = t.team_id
JOIN leagues l ON t.league_id = l.league_id
ORDER BY l.name, p.overall_rating DESC;


ALTER TABLE players ADD COLUMN scouting_status VARCHAR(50);

EXPLAIN ANALYZE
UPDATE players
SET scouting_status = 'High Potential'
WHERE age < 21;

ALTER TABLE players DROP COLUMN scouting_status; 


CREATE TABLE player_timeline (
    event_id SERIAL PRIMARY KEY,
    player_id INT REFERENCES players(player_id),
    event_type VARCHAR(50),
    
    fee NUMERIC,
    from_team VARCHAR(100),
    
    diagnosis VARCHAR(100),
    recovery_weeks INT,
    
    award_name VARCHAR(100)
    
);

INSERT INTO player_timeline (player_id, event_type, fee, from_team)
VALUES (1, 'Transfer', 100000000, 'PSG');



EXPLAIN ANALYZE
SELECT DISTINCT 
    p.name AS player_name, 
    n.name AS nationality, 
    t.name AS team, 
    l.name AS league, 
    ps.dribbling, 
    pp.playstyle_name
FROM players p
JOIN nationalities n ON p.nationality_id = n.nation_id
JOIN teams t ON p.team_id = t.team_id
JOIN leagues l ON t.league_id = l.league_id
JOIN player_stats ps ON p.player_id = ps.player_id
JOIN player_playstyles pp ON p.player_id = pp.player_id
WHERE 
    n.name = 'Brazil'              
    AND l.name = 'Premier League'  
    AND pp.playstyle_name = 'Technical' 
    AND ps.dribbling > 85;         

