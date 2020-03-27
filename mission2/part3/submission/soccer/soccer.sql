CREATE TABLE Country (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT    UNIQUE
);

CREATE TABLE League (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    country_id INTEGER,
    name       TEXT    UNIQUE,
    FOREIGN KEY (
        country_id
    )
    REFERENCES country (id) 
);

CREATE TABLE Team (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    team_api_id      INTEGER UNIQUE,
    team_fifa_api_id INTEGER,
    team_long_name   TEXT,
    team_short_name  TEXT
);

CREATE TABLE Team_Attributes (
    id                             INTEGER PRIMARY KEY AUTOINCREMENT,
    team_fifa_api_id               INTEGER,
    date                           TEXT,
    buildUpPlaySpeed               INTEGER,
    buildUpPlaySpeedClass          TEXT,
    buildUpPlayDribbling           INTEGER,
    buildUpPlayDribblingClass      TEXT,
    buildUpPlayPassing             INTEGER,
    buildUpPlayPassingClass        TEXT,
    buildUpPlayPositioningClass    TEXT,
    chanceCreationPassing          INTEGER,
    chanceCreationPassingClass     TEXT,
    chanceCreationCrossing         INTEGER,
    chanceCreationCrossingClass    TEXT,
    chanceCreationShooting         INTEGER,
    chanceCreationShootingClass    TEXT,
    chanceCreationPositioningClass TEXT,
    defencePressure                INTEGER,
    defencePressureClass           TEXT,
    defenceAggression              INTEGER,
    defenceAggressionClass         TEXT,
    defenceTeamWidth               INTEGER,
    defenceTeamWidthClass          TEXT,
    defenceDefenderLineClass       TEXT,
    FOREIGN KEY (
        team_fifa_api_id
    )
    REFERENCES Team (team_fifa_api_id)
);

CREATE TABLE Player (
    id                 INTEGER PRIMARY KEY AUTOINCREMENT,
    player_api_id      INTEGER UNIQUE,
    player_name        TEXT,
    player_fifa_api_id INTEGER UNIQUE,
    birthday           TEXT,
    height             INTEGER,
    weight             INTEGER
);

CREATE TABLE Player_Attributes (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    player_fifa_api_id  INTEGER,
    date                TEXT,
    overall_rating      INTEGER,
    potential           INTEGER,
    preferred_foot      TEXT,
    attacking_work_rate TEXT,
    defensive_work_rate TEXT,
    crossing            INTEGER,
    finishing           INTEGER,
    heading_accuracy    INTEGER,
    short_passing       INTEGER,
    volleys             INTEGER,
    dribbling           INTEGER,
    curve               INTEGER,
    free_kick_accuracy  INTEGER,
    long_passing        INTEGER,
    ball_control        INTEGER,
    acceleration        INTEGER,
    sprint_speed        INTEGER,
    agility             INTEGER,
    reactions           INTEGER,
    balance             INTEGER,
    shot_power          INTEGER,
    jumping             INTEGER,
    stamina             INTEGER,
    strength            INTEGER,
    long_shots          INTEGER,
    aggression          INTEGER,
    interceptions       INTEGER,
    positioning         INTEGER,
    vision              INTEGER,
    penalties           INTEGER,
    marking             INTEGER,
    standing_tackle     INTEGER,
    sliding_tackle      INTEGER,
    gk_diving           INTEGER,
    gk_handling         INTEGER,
    gk_kicking          INTEGER,
    gk_positioning      INTEGER,
    gk_reflexes         INTEGER,
    FOREIGN KEY (
        player_fifa_api_id
    )
    REFERENCES Player (player_fifa_api_id)
);

CREATE TABLE [Match] (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    country_id       INTEGER,
    league_id        INTEGER,
    season           TEXT,
    stage            INTEGER,
    date             TEXT,
    match_api_id     INTEGER UNIQUE,
    home_team_api_id INTEGER,
    away_team_api_id INTEGER,
    home_team_goal   INTEGER,
    away_team_goal   INTEGER,
    goal             TEXT,
    shoton           TEXT,
    shotoff          TEXT,
    foulcommit       TEXT,
    card             TEXT,
    [cross]          TEXT,
    corner           TEXT,
    possession       TEXT,
    B365H            NUMERIC,
    B365D            NUMERIC,
    B365A            NUMERIC,
    BWH              NUMERIC,
    BWD              NUMERIC,
    BWA              NUMERIC,
    IWH              NUMERIC,
    IWD              NUMERIC,
    IWA              NUMERIC,
    LBH              NUMERIC,
    LBD              NUMERIC,
    LBA              NUMERIC,
    PSH              NUMERIC,
    PSD              NUMERIC,
    PSA              NUMERIC,
    WHH              NUMERIC,
    WHD              NUMERIC,
    WHA              NUMERIC,
    SJH              NUMERIC,
    SJD              NUMERIC,
    SJA              NUMERIC,
    VCH              NUMERIC,
    VCD              NUMERIC,
    VCA              NUMERIC,
    GBH              NUMERIC,
    GBD              NUMERIC,
    GBA              NUMERIC,
    BSH              NUMERIC,
    BSD              NUMERIC,
    BSA              NUMERIC,
    FOREIGN KEY (
        country_id
    )
    REFERENCES Country (id),
    FOREIGN KEY (
        league_id
    )
    REFERENCES League (id),
    FOREIGN KEY (
        home_team_api_id
    )
    REFERENCES Team (team_api_id),
    FOREIGN KEY (
        away_team_api_id
    )
    REFERENCES Team (team_api_id)
);

CREATE TABLE [Player_in_Match] (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    match_api_id     INTEGER,
    away_or_home     TEXT,
    player_id        INTEGER,
    player_X         INTEGER,
    player_Y         INTEGER,
    FOREIGN KEY (
        player_id
    )
    REFERENCES Player (player_api_id),
    FOREIGN KEY (
        match_api_id
    )
    REFERENCES Match (match_api_id)
);