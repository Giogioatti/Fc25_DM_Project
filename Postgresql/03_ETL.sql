
INSERT INTO nationalities (name)
SELECT DISTINCT nation FROM raw_players_data WHERE nation IS NOT NULL ON CONFLICT DO NOTHING;

INSERT INTO leagues (name)
SELECT DISTINCT league FROM raw_players_data WHERE league IS NOT NULL ON CONFLICT DO NOTHING;

INSERT INTO teams (name, league_id)
SELECT DISTINCT r.team, l.league_id
FROM raw_players_data r
JOIN leagues l ON r.league = l.name
WHERE r.team IS NOT NULL ON CONFLICT DO NOTHING;


INSERT INTO players (
    player_id, name, age, height_cm, weight_kg, 
    nationality_id, team_id, position, preferred_foot, 
    overall_rating, weak_foot, skill_moves
)
SELECT 
    r.original_id,
    r.player_name,
    r.age,
    CAST(SUBSTRING(r.height FROM '[0-9]+') AS INT), -- "182cm" -> 182
    CAST(SUBSTRING(r.weight FROM '[0-9]+') AS INT), -- "80kg" -> 80
    n.nation_id,
    t.team_id,
    r.position,
    r.preferred_foot,
    r.ovr,
    r.weak_foot,
    r.skill_moves
FROM raw_players_data r
LEFT JOIN nationalities n ON r.nation = n.name
LEFT JOIN teams t ON r.team = t.name 
    AND t.league_id = (SELECT league_id FROM leagues WHERE name = r.league)
ON CONFLICT (player_id) DO NOTHING;


INSERT INTO player_stats (
    player_id, pace, shooting, passing, dribbling, defending, physical,
    acceleration, sprint_speed, positioning, finishing, shot_power,
    long_shots, volleys, penalties, vision, crossing, free_kick_accuracy,
    short_passing, long_passing, curve, agility, balance, reactions,
    ball_control, composure, interceptions, heading_accuracy, def_awareness,
    standing_tackle, sliding_tackle, jumping, stamina, strength, aggression
)
SELECT 
    original_id,
    CAST(pac AS INT), CAST(sho AS INT), CAST(pas AS INT), CAST(dri AS INT), CAST(def AS INT), CAST(phy AS INT),
    CAST(acceleration AS INT), CAST(sprint_speed AS INT), CAST(positioning AS INT), CAST(finishing AS INT),
    CAST(shot_power AS INT), CAST(long_shots AS INT), CAST(volleys AS INT), CAST(penalties AS INT),
    CAST(vision AS INT), CAST(crossing AS INT), CAST(free_kick_accuracy AS INT), CAST(short_passing AS INT),
    CAST(long_passing AS INT), CAST(curve AS INT), CAST(agility AS INT), CAST(balance AS INT), 
    CAST(reactions AS INT), CAST(ball_control AS INT), CAST(composure AS INT), CAST(interceptions AS INT),
    CAST(heading_accuracy AS INT), CAST(def_awareness AS INT), CAST(standing_tackle AS INT), CAST(sliding_tackle AS INT),
    CAST(jumping AS INT), CAST(stamina AS INT), CAST(strength AS INT), CAST(aggression AS INT)
FROM raw_players_data r
WHERE EXISTS (SELECT 1 FROM players p WHERE p.player_id = r.original_id)
ON CONFLICT DO NOTHING;


INSERT INTO goalkeeping_stats (
    player_id, gk_diving, gk_handling, gk_kicking, gk_positioning, gk_reflexes
)
SELECT 
    original_id,
    CAST(gk_diving AS INT), CAST(gk_handling AS INT), CAST(gk_kicking AS INT), 
    CAST(gk_positioning AS INT), CAST(gk_reflexes AS INT)
FROM raw_players_data r
WHERE position = 'GK' 
AND EXISTS (SELECT 1 FROM players p WHERE p.player_id = r.original_id)
ON CONFLICT DO NOTHING;


INSERT INTO player_playstyles (player_id, playstyle_name)
SELECT DISTINCT
    r.original_id,
    TRIM(unnested_style)
FROM raw_players_data r,
     LATERAL regexp_split_to_table(r.play_style, ',') AS unnested_style
WHERE r.play_style IS NOT NULL 
  AND r.play_style != ''
  AND LENGTH(TRIM(unnested_style)) > 0
  AND EXISTS (SELECT 1 FROM players p WHERE p.player_id = r.original_id)
ON CONFLICT DO NOTHING;

INSERT INTO player_alt_positions (player_id, position_code)
SELECT DISTINCT
    r.original_id,
    TRIM(unnested_pos)
FROM raw_players_data r,
     LATERAL regexp_split_to_table(r.alternative_positions, ',') AS unnested_pos
WHERE r.alternative_positions IS NOT NULL 
  AND r.alternative_positions != ''
  AND LENGTH(TRIM(unnested_pos)) > 0
  AND EXISTS (SELECT 1 FROM players p WHERE p.player_id = r.original_id)
ON CONFLICT DO NOTHING;