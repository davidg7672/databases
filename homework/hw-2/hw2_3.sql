/*======================================================================
 * 
 *  NAME:    David Sosa 
 *  ASSIGN:  HW-2, Question 3
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Implementation of Question 2 
 * 
 *======================================================================*/

-- Dropping Tables
DROP TABLE IF EXISTS album_track;
DROP TABLE IF EXISTS musician_track;
DROP TABLE IF EXISTS track;
DROP TABLE IF EXISTS song;
DROP TABLE IF EXISTS influence;
DROP TABLE IF EXISTS musician_group;
DROP TABLE IF EXISTS musician;
DROP TABLE IF EXISTS group_genre;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS album;
DROP TABLE IF EXISTS music_group;

-- ======================================================================
-- Table: music_group
-- Purpose: Represents a musical group (band,artist collective).
-- ======================================================================
CREATE TABLE music_group (
    name VARCHAR(40) NOT NULL,
    yr_formed SMALLINT NOT NULL CHECK (yr_formed >= 1900),

    PRIMARY KEY (name)
);
-- Violating INSERTs:
-- INSERT INTO music_group VALUES ('', 1990);              -- empty name not allowed
-- INSERT INTO music_group VALUES ('The Beatles', 1800);   -- too early

-- ======================================================================
-- table: album
-- Purpose: Represents an album created by a music group
-- ======================================================================
CREATE TABLE album (
    title VARCHAR(40) NOT NULL,
    yr_recorded SMALLINT NOT NULL CHECK (yr_recorded >= 1900),
    group_name VARCHAR(40) NOT NULL,
    record_label VARCHAR(40) NOT NULL,

    PRIMARY KEY (title, group_name),
    FOREIGN KEY (group_name) REFERENCES music_group(name)
);
-- Violating INSERTs:
-- INSERT INTO album VALUES ('Abbey Road', 1890, 'The Beatles', 'EMI'); -- bad year
-- INSERT INTO album VALUES ('Nevermind', 1991, 'NonExistentBand', 'DGC'); -- FK violation

-- ======================================================================
-- Table: genre
-- Purpose: Represents a musical genre
-- ======================================================================
CREATE TABLE genre (
    name VARCHAR(40) NOT NULL,
    description TEXT NOT NULL,

    PRIMARY KEY (name)
);
-- Violating INSERTs:
-- INSERT INTO genre VALUES (NULL, 'Genre with null name'); -- null name
-- INSERT INTO genre VALUES ('Rock', NULL); -- null description

-- ======================================================================
-- Table: group_genre
-- Purpose: Junction table mapping groups to genre
-- ======================================================================
CREATE TABLE group_genre (
    group_name VARCHAR(40) NOT NULL,
    genre_name VARCHAR(40) NOT NULL,

    PRIMARY KEY (group_name, genre_name),
    FOREIGN KEY (group_name) REFERENCES music_group(name),
    FOREIGN KEY (genre_name) REFERENCES genre(name)
);
-- Violating INSERTs:
-- INSERT INTO group_genre VALUES ('n/a band', 'Rock'); -- fk violation
-- INSERT INTO group_genre VALUES ('The Beatles', 'n/a genre'); -- fk violation

-- ======================================================================
-- Table: musician
-- Purpose: Purpose: Represent an individual musician
-- ======================================================================
CREATE TABLE musician (
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    stage_name VARCHAR(40),
    yr_born SMALLINT CHECK (yr_born >= 1900),

    PRIMARY KEY (first_name, last_name),
);
-- Violating INSERTs:
-- INSERT INTO musician VALUES ('Ringo', 'Starr', 'Ringo', 1899); -- too early
-- INSERT INTO musician VALUES (NULL, 'Lennon', 'JD', 1950); -- null first name

-- ======================================================================
-- Table: musician_group
-- Purpose: Junction table that maps musicians to groups they played in
-- ======================================================================
CREATE TABLE musician_group (
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    group_name VARCHAR(40) NOT NULL,
    start_yr SMALLINT NOT NULL,
    end_yr SMALLINT CHECK (end_yr IS NULL OR end_yr >= start_yr),

    PRIMARY KEY (first_name, last_name, group_name),
    FOREIGN KEY (first_name, last_name) REFERENCES musician(first_name, last_name),
    FOREIGN KEY (group_name) REFERENCES music_group(name)
);
-- Violating INSERTs:
-- INSERT INTO musician_group VALUES ('John', 'Lennon', 'The Beatles', 1800, 1970); -- bad year
-- INSERT INTO musician_group VALUES ('John', 'Lennon', 'The Beatles', 1960, 1949); -- year before

-- ======================================================================
-- Table: influence
-- Purpose: Captures influence relationships between groups (e.g. Arctic Monkeys Influenced by The Strokes)
-- ======================================================================
CREATE TABLE influence (
    influencer VARCHAR(40) NOT NULL,
    influenced VARCHAR(40) NOT NULL,

    PRIMARY KEY (influencer, influenced),
    FOREIGN KEY (influencer) REFERENCES music_group(name),
    FOREIGN KEY (influenced) REFERENCES music_group(name)
    CONSTRAINT no_self_influence CHECK (influencer <> influenced) -- making sure the influencer isn't themselves
);
-- INSERT INTO influence VALUES ('The Beatles', 'The Beatles') -- influencer influencing himself, can't be true
-- INSERT INTO influence VALUES ('The Beatles', NULL) -- can't be null

-- tracks & songs
-- ======================================================================
-- Table: song
-- Purpose: Represents a song and when it was written
-- ======================================================================
CREATE TABLE song (
    title VARCHAR(40) UNIQUE NOT NULL,
    yr_written SMALLINT NOT NULL CHECK (yr_written >= 1900),

    PRIMARY KEY (title)
);
-- INSERT INTO song VALUES ('Don't Let Me Down', 1899) -- invalid year
-- INSERT INTO song VALUES (NULL, 1899) -- can't be null

-- ======================================================================
-- Table: track
-- Purpose: Represents a track, when it was made, and it's unique identified
-- ======================================================================
CREATE TABLE track (
    id INT NOT NULL,
    song_title VARCHAR(40) NOT NULL,
    yr_recorded SMALLINT NOT NULL CHECK (yr_recorded >= 1900),

    PRIMARY KEY (id),
    FOREIGN KEY (song_title) REFERENCES song(title)
);
-- INSERT INTO track VALUES (1, 'Don't Let Me Down', 1899) -- year not valid
-- INSERT INTO track VALUES (NULL, 'Don't Let Me Down', 1970) -- can't be null

-- ======================================================================
-- flight(airline, flight_number, departure, arrival, flights_per_wk)
-- Stores information about flights.
-- ======================================================================
CREATE TABLE musician_track (
    track_id INT NOT NULL,
    musician_first_name VARCHAR(40) NOT NULL,
    musician_last_name VARCHAR(40) NOT NULL,
    
    PRIMARY KEY (track_id, musician_first_name, musician_last_name),
    FOREIGN KEY (track_id) REFERENCES track(id),
    FOREIGN KEY (musician_first_name, musician_last_name) REFERENCES musician(first_name, last_name)
);

--- 
-- INSERT INTO musician_track VALUES (1, 'Don't Let Me Down', 1899) -- year not valid
-- INSERT INTO musician_track VALUES (NULL, 'Don't Let Me Down', 1970) -- can't be null

-- musicians that wrote a song
-- very similar to musician_track
-- ======================================================================
-- flight(airline, flight_number, departure, arrival, flights_per_wk)
-- Stores information about flights.
-- ======================================================================
CREATE TABLE musician_song (
    song_title VARCHAR(40) NOT NULL,
    musician_first_name VARCHAR(40) NOT NULL,
    musician_last_name VARCHAR(40) NOT NULL,

    PRIMARY KEY (song_title, musician_first_name, musician_last_name),
    FOREIGN KEY (song_title) REFERENCES song(title),
    FOREIGN KEY (musician_first_name, musician_last_name) REFERENCES musician(first_name, last_name)
);

-- tracks can appear on different albums
-- ======================================================================
-- flight(airline, flight_number, departure, arrival, flights_per_wk)
-- Stores information about flights.
-- ======================================================================
CREATE TABLE album_track (
    album_title VARCHAR(40) NOT NULL,
    group_name VARCHAR(40) NOT NULL,
    track_id INT NOT NULL,

    PRIMARY KEY (album_title, group_name, track_id),
    FOREIGN KEY (album_title, group_name) REFERENCES album(title, group_name),
    FOREIGN KEY (track_id) REFERENCES track(id)
);

