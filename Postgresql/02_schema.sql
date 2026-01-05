DROP TABLE IF EXISTS player_playstyles, player_alt_positions, goalkeeping_stats, player_stats, players, teams, leagues, nationalities CASCADE;

CREATE TABLE nationalities (
    nation_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);

CREATE TABLE leagues (
    league_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);

CREATE TABLE teams (
    team_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    league_id INT REFERENCES leagues(league_id),
    CONSTRAINT unique_team_league UNIQUE (name, league_id)
);

CREATE TABLE players (
    player_id INT PRIMARY KEY, 
    name VARCHAR(200),
    age INT,
    height_cm INT,
    weight_kg INT,
    nationality_id INT REFERENCES nationalities(nation_id),
    team_id INT REFERENCES teams(team_id),
    position VARCHAR(10),
    preferred_foot VARCHAR(10),
    overall_rating INT,
    weak_foot INT,
    skill_moves INT
);

CREATE TABLE player_stats (
    player_id INT PRIMARY KEY REFERENCES players(player_id),
    pace INT, shooting INT, passing INT, dribbling INT, defending INT, physical INT,
    acceleration INT, sprint_speed INT, positioning INT, finishing INT,
    shot_power INT, long_shots INT, volleys INT, penalties INT,
    vision INT, crossing INT, free_kick_accuracy INT, short_passing INT,
    long_passing INT, curve INT, agility INT, balance INT, reactions INT,
    ball_control INT, composure INT, interceptions INT, heading_accuracy INT,
    def_awareness INT, standing_tackle INT, sliding_tackle INT,
    jumping INT, stamina INT, strength INT, aggression INT
);

CREATE TABLE goalkeeping_stats (
    player_id INT PRIMARY KEY REFERENCES players(player_id),
    gk_diving INT, gk_handling INT, gk_kicking INT, gk_positioning INT, gk_reflexes INT
);

CREATE TABLE player_playstyles (
    id SERIAL PRIMARY KEY,
    player_id INT REFERENCES players(player_id),
    playstyle_name VARCHAR(100),
    CONSTRAINT unique_player_style UNIQUE (player_id, playstyle_name)
);

CREATE TABLE player_alt_positions (
    id SERIAL PRIMARY KEY,
    player_id INT REFERENCES players(player_id),
    position_code VARCHAR(10),
    CONSTRAINT unique_player_pos UNIQUE (player_id, position_code)
);