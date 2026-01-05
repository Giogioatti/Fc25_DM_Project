
DROP TABLE IF EXISTS raw_players_data CASCADE;

CREATE TABLE raw_players_data (
    import_id SERIAL PRIMARY KEY,
    original_id INT,
    rank INT,
    player_name VARCHAR(200),
    ovr INT,
    pac NUMERIC, sho NUMERIC, pas NUMERIC, dri NUMERIC, def NUMERIC, phy NUMERIC,
    acceleration NUMERIC, sprint_speed NUMERIC, positioning NUMERIC, finishing NUMERIC,
    shot_power NUMERIC, long_shots NUMERIC, volleys NUMERIC, penalties NUMERIC,
    vision NUMERIC, crossing NUMERIC, free_kick_accuracy NUMERIC, short_passing NUMERIC,
    long_passing NUMERIC, curve NUMERIC, dribbling NUMERIC, agility NUMERIC, balance NUMERIC,
    reactions NUMERIC, ball_control NUMERIC, composure NUMERIC, interceptions NUMERIC,
    heading_accuracy NUMERIC, def_awareness NUMERIC, standing_tackle NUMERIC, sliding_tackle NUMERIC,
    jumping NUMERIC, stamina NUMERIC, strength NUMERIC, aggression NUMERIC,
    position VARCHAR(10),
    weak_foot INT, skill_moves INT, preferred_foot VARCHAR(10),
    height VARCHAR(20), weight VARCHAR(20),
    alternative_positions TEXT,
    age INT,
    nation VARCHAR(100),
    league VARCHAR(100),
    team VARCHAR(100),
    play_style TEXT,
    url VARCHAR(255),
    gk_diving NUMERIC, gk_handling NUMERIC, gk_kicking NUMERIC, gk_positioning NUMERIC, gk_reflexes NUMERIC
);

-- (raw_players_data -> Import/Export Data)

--FIX ID
UPDATE raw_players_data
SET original_id = original_id + 1000000
WHERE import_id >= 16161;