/*======================================================================
 * 
 *  NAME:    David Sosa 
 *  ASSIGN:  HW-2, Question 3
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Implementation of Question 2
 *           Schema Diagram
 * 
 *======================================================================*/

-- Dropping Tables (order matters: child → parent)
DROP TABLE IF EXISTS album_track CASCADE;
DROP TABLE IF EXISTS musician_track CASCADE;
DROP TABLE IF EXISTS musician_song CASCADE;
DROP TABLE IF EXISTS track CASCADE;
DROP TABLE IF EXISTS song CASCADE;
DROP TABLE IF EXISTS influence CASCADE;
DROP TABLE IF EXISTS musician_group CASCADE;
DROP TABLE IF EXISTS musician CASCADE;
DROP TABLE IF EXISTS group_genre CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS album CASCADE;
DROP TABLE IF EXISTS music_group CASCADE;

-- ======================================================================
-- Table: music_group
-- Purpose: Represents a musical group (band,artist collective).
-- ======================================================================
CREATE TABLE music_group (
    name VARCHAR(40) NOT NULL,
    yr_formed SMALLINT NOT NULL CHECK (yr_formed >= 1900),

    PRIMARY KEY (name)
);
INSERT INTO music_group (name, yr_formed) VALUES
('The Beatles', 1960),
('Led Zeppelin', 1968),
('Pink Floyd', 1965),
('The Rolling Stones', 1962),
('Queen', 1970);

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
INSERT INTO album (title, yr_recorded, group_name, record_label) VALUES
('Abbey Road', 1969, 'The Beatles', 'Apple Records'),
('Sgt. Pepper''s Lonely Hearts Club Band', 1967, 'The Beatles', 'Parlophone'),
('Led Zeppelin IV', 1971, 'Led Zeppelin', 'Atlantic Records'),
('The Dark Side of the Moon', 1973, 'Pink Floyd', 'Harvest Records'),
('Exile on Main St.', 1972, 'The Rolling Stones', 'Rolling Stones Records'),
('A Night at the Opera', 1975, 'Queen', 'EMI');

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
INSERT INTO genre (name, description) VALUES
('Rock', 'A broad genre of popular music that originated as "rock and roll" in the United States in the late 1940s and early 1950s'),
('Progressive Rock', 'A broad subgenre of rock music that developed in the United Kingdom and United States throughout the mid- to late 1960s'),
('Psychedelic Rock', 'A diverse style of rock music inspired by psychedelic culture'),
('Blues Rock', 'A fusion genre combining elements of blues and rock music'),
('Hard Rock', 'A loosely defined subgenre of rock music that began in the mid-1960s');

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
INSERT INTO group_genre (group_name, genre_name) VALUES
('The Beatles', 'Rock'),
('The Beatles', 'Psychedelic Rock'),
('Led Zeppelin', 'Hard Rock'),
('Led Zeppelin', 'Blues Rock'),
('Pink Floyd', 'Progressive Rock'),
('Pink Floyd', 'Psychedelic Rock'),
('The Rolling Stones', 'Rock'),
('The Rolling Stones', 'Blues Rock'),
('Queen', 'Rock'),
('Queen', 'Hard Rock');

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

    PRIMARY KEY (first_name, last_name)
);
INSERT INTO musician (first_name, last_name, stage_name, yr_born) VALUES
('John', 'Lennon', 'John Lennon', 1940),
('Paul', 'McCartney', 'Paul McCartney', 1942),
('George', 'Harrison', 'George Harrison', 1943),
('Ringo', 'Starr', 'Ringo Starr', 1940),
('Robert', 'Plant', 'Robert Plant', 1948),
('Jimmy', 'Page', 'Jimmy Page', 1944),
('Roger', 'Waters', 'Roger Waters', 1943),
('David', 'Gilmour', 'David Gilmour', 1946),
('Mick', 'Jagger', 'Mick Jagger', 1943),
('Keith', 'Richards', 'Keith Richards', 1943),
('Freddie', 'Mercury', 'Freddie Mercury', 1946),
('Brian', 'May', 'Brian May', 1947);

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
INSERT INTO musician_group (first_name, last_name, group_name, start_yr, end_yr) VALUES
('John', 'Lennon', 'The Beatles', 1960, 1970),
('Paul', 'McCartney', 'The Beatles', 1960, 1970),
('George', 'Harrison', 'The Beatles', 1960, 1970),
('Ringo', 'Starr', 'The Beatles', 1962, 1970),
('Robert', 'Plant', 'Led Zeppelin', 1968, 1980),
('Jimmy', 'Page', 'Led Zeppelin', 1968, 1980),
('Roger', 'Waters', 'Pink Floyd', 1965, 1985),
('David', 'Gilmour', 'Pink Floyd', 1968, 1995),
('Mick', 'Jagger', 'The Rolling Stones', 1962, NULL),
('Keith', 'Richards', 'The Rolling Stones', 1962, NULL),
('Freddie', 'Mercury', 'Queen', 1970, 1991),
('Brian', 'May', 'Queen', 1970, NULL);

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
    FOREIGN KEY (influenced) REFERENCES music_group(name),
    CONSTRAINT no_self_influence CHECK (influencer <> influenced) -- making sure the influencer isn't themselves
);
INSERT INTO influence (influencer, influenced) VALUES
('The Beatles', 'Led Zeppelin'),
('The Beatles', 'Pink Floyd'),
('The Beatles', 'Queen'),
('Led Zeppelin', 'Pink Floyd'),
('The Rolling Stones', 'Led Zeppelin');

-- INSERT INTO influence VALUES ('The Beatles', 'The Beatles'); -- influencer influencing himself, can't be true
-- INSERT INTO influence VALUES ('The Beatles', NULL); -- can't be null

-- tracks & songs
-- ======================================================================
-- Table: song
-- Purpose: Represents a song and when it was written
-- ======================================================================
CREATE TABLE song (
    title VARCHAR(40) NOT NULL,
    yr_written SMALLINT NOT NULL CHECK (yr_written >= 1900),

    PRIMARY KEY (title)
);
INSERT INTO song (title, yr_written) VALUES
('Come Together', 1969),
('A Day in the Life', 1967),
('Stairway to Heaven', 1971),
('Money', 1973),
('Brown Sugar', 1972),
('Bohemian Rhapsody', 1975),
('Hey Jude', 1968),
('Black Dog', 1971),
('Comfortably Numb', 1979),
('Satisfaction', 1965);

-- INSERT INTO song VALUES ('Come Together', 1899); -- invalid year
-- INSERT INTO song VALUES (NULL, 1899); -- can't be null

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
INSERT INTO track (id, song_title, yr_recorded) VALUES
(1, 'Come Together', 1969),
(2, 'A Day in the Life', 1967),
(3, 'Stairway to Heaven', 1971),
(4, 'Money', 1973),
(5, 'Brown Sugar', 1972),
(6, 'Bohemian Rhapsody', 1975),
(7, 'Hey Jude', 1968),
(8, 'Black Dog', 1971),
(9, 'Comfortably Numb', 1979),
(10, 'Satisfaction', 1965);

-- INSERT INTO track VALUES (1, 'Come Together', 1899) -- year not valid
-- INSERT INTO track VALUES (NULL, 'Come Together', 1970) -- can't be null

-- ======================================================================
-- Table: musician_track
-- Purpose: musician who contributed to a track
-- ======================================================================
CREATE TABLE musician_track (
    track_id INT NOT NULL,
    musician_first_name VARCHAR(40) NOT NULL,
    musician_last_name VARCHAR(40) NOT NULL,
    
    PRIMARY KEY (track_id, musician_first_name, musician_last_name),
    FOREIGN KEY (track_id) REFERENCES track(id),
    FOREIGN KEY (musician_first_name, musician_last_name) REFERENCES musician(first_name, last_name)
);
INSERT INTO musician_track (track_id, musician_first_name, musician_last_name) VALUES
(1, 'John', 'Lennon'),
(1, 'Paul', 'McCartney'),
(2, 'John', 'Lennon'),
(2, 'Paul', 'McCartney'),
(3, 'Robert', 'Plant'),
(3, 'Jimmy', 'Page'),
(4, 'Roger', 'Waters'),
(4, 'David', 'Gilmour'),
(5, 'Mick', 'Jagger'),
(5, 'Keith', 'Richards'),
(6, 'Freddie', 'Mercury'),
(6, 'Brian', 'May'),
(7, 'John', 'Lennon'),
(7, 'Paul', 'McCartney'),
(8, 'Robert', 'Plant'),
(8, 'Jimmy', 'Page'),
(9, 'Roger', 'Waters'),
(9, 'David', 'Gilmour'),
(10, 'Mick', 'Jagger'),
(10, 'Keith', 'Richards');

-- Violating INSERTs
-- INSERT INTO musician_track VALUES (1, 'John', 'Lennon'); -- duplicate PK (already inserted above)
-- INSERT INTO musician_track VALUES (999, 'John', 'Lennon'); -- invalid track FK (track 999 doesn't exist)

-- ======================================================================
-- Table: musician_song
-- PUrpose: Musician who wrote the wong.
-- ======================================================================
CREATE TABLE musician_song (
    song_title VARCHAR(40) NOT NULL,
    musician_first_name VARCHAR(40) NOT NULL,
    musician_last_name VARCHAR(40) NOT NULL,

    PRIMARY KEY (song_title, musician_first_name, musician_last_name),
    FOREIGN KEY (song_title) REFERENCES song(title),
    FOREIGN KEY (musician_first_name, musician_last_name) REFERENCES musician(first_name, last_name)
);
INSERT INTO musician_song (song_title, musician_first_name, musician_last_name) VALUES
('Come Together', 'John', 'Lennon'),
('A Day in the Life', 'John', 'Lennon'),
('A Day in the Life', 'Paul', 'McCartney'),
('Stairway to Heaven', 'Robert', 'Plant'),
('Stairway to Heaven', 'Jimmy', 'Page'),
('Money', 'Roger', 'Waters'),
('Brown Sugar', 'Mick', 'Jagger'),
('Brown Sugar', 'Keith', 'Richards'),
('Bohemian Rhapsody', 'Freddie', 'Mercury'),
('Hey Jude', 'Paul', 'McCartney'),
('Black Dog', 'Robert', 'Plant'),
('Black Dog', 'Jimmy', 'Page'),
('Comfortably Numb', 'Roger', 'Waters'),
('Comfortably Numb', 'David', 'Gilmour'),
('Satisfaction', 'Mick', 'Jagger'),
('Satisfaction', 'Keith', 'Richards');

-- Violating INSERTs
-- INSERT INTO musician_song VALUES ('n/a song', 'john', 'lennon'); -- invalid fk
-- INSERT INTO musician_song VALUES ('Imagine', 'n', 'a'); -- invalid musician

-- ======================================================================
-- Table: album_track
-- Purpose: tracks that appear on an album
-- ======================================================================
CREATE TABLE album_track (
    album_title VARCHAR(40) NOT NULL,
    group_name VARCHAR(40) NOT NULL,
    track_id INT NOT NULL,

    PRIMARY KEY (album_title, group_name, track_id),
    FOREIGN KEY (album_title, group_name) REFERENCES album(title, group_name),
    FOREIGN KEY (track_id) REFERENCES track(id)
);
INSERT INTO album_track (album_title, group_name, track_id) VALUES
('Abbey Road', 'The Beatles', 1),
('Sgt. Pepper''s Lonely Hearts Club Band', 'The Beatles', 2),
('Sgt. Pepper''s Lonely Hearts Club Band', 'The Beatles', 7),
('Led Zeppelin IV', 'Led Zeppelin', 3),
('Led Zeppelin IV', 'Led Zeppelin', 8),
('The Dark Side of the Moon', 'Pink Floyd', 4),
('The Dark Side of the Moon', 'Pink Floyd', 9),
('Exile on Main St.', 'The Rolling Stones', 5),
('Exile on Main St.', 'The Rolling Stones', 10),
('A Night at the Opera', 'Queen', 6);

-- Violating INSERTs
-- INSERT INTO album_track VALUES ('n/a album', 'n/a group', 1);-- invalid fk
-- INSERT INTO album_track VALUES ('Abbey Road', 'The Beatles', -999); -- invalid track FK