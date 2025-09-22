/*======================================================================
 * 
 *  NAME:    David Sosa 
 *  ASSIGN:  HW-2, Question 3
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Implementation of Question 2 
 * 
 *======================================================================*/


-- TODO:
--   * Fill in your name above and a brief description.
--   * Implement the question 1 schema as per the homework instructions.
--   * Populate each table according to the homework instructions.
--   * Be sure each table has a comment describing its purpose.
--   * Be sure to add comments as needed for attributes.
--   * Be sure your SQL code is well formatted (according to the style guides).
--   * Add two INSERT statements per table that violate constraints and
--     comment these out for the final submission

-- dropping tables
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

CREATE TABLE music_group (
    name VARCHAR(40) NOT NULL,
    yr_formed SMALLINT NOT NULL,

    PRIMARY KEY (name)
);

CREATE TABLE album (
    title VARCHAR(40) NOT NULL,
    yr_recorded SMALLINT NOT NULL,
    group_name VARCHAR(40) NOT NULL,
    record_label VARCHAR(40) NOT NULL,

    PRIMARY KEY (title, group_name),
    FOREIGN KEY (group_name) REFERENCES music_group(name)
);

-- create junction table

CREATE TABLE genre (
    name VARCHAR(40) NOT NULL,
    description TEXT NOT NULL,

    PRIMARY KEY (name)
);

CREATE TABLE group_genre (
    group_name VARCHAR(40) NOT NULL,
    genre_name VARCHAR(40) NOT NULL,

    PRIMARY KEY (group_name, genre_name),
    FOREIGN KEY (group_name) REFERENCES music_group(name),
    FOREIGN KEY (genre_name) REFERENCES genre(name)
);

CREATE TABLE musician (
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    stage_name VARCHAR(40),
    yr_born SMALLINT,

    PRIMARY KEY (first_name, last_name)
);

CREATE TABLE musician_group (
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    group_name VARCHAR(40) NOT NULL,
    start_yr SMALLINT NOT NULL,
    end_yr SMALLINT,

    PRIMARY KEY (first_name, last_name, group_name),
    FOREIGN KEY (first_name, last_name) REFERENCES musician(first_name, last_name),
    FOREIGN KEY (group_name) REFERENCES music_group(name)
);

-- influencing
CREATE TABLE influence (
    influencer VARCHAR(40),
    influenced VARCHAR(40),

    PRIMARY KEY (influencer, influenced),
    FOREIGN KEY (influencer) REFERENCES music_group(name),
    FOREIGN KEY (influenced) REFERENCES music_group(name)
);

-- tracks & songs
CREATE TABLE song (
    title VARCHAR(40) UNIQUE NOT NULL,
    yr_written SMALLINT NOT NULL,

    PRIMARY KEY (title)
);

CREATE TABLE track (
    id INT NOT NULL,
    song_title VARCHAR(40) NOT NULL,
    yr_recorded SMALLINT NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (song_title) REFERENCES song(title)
);

-- musicians that contributed to a track
CREATE TABLE musician_track (
    track_id INT NOT NULL,
    musician_first_name VARCHAR(40) NOT NULL,
    musician_last_name VARCHAR(40) NOT NULL,
    
    PRIMARY KEY (track_id, musician_first_name, musician_last_name),
    FOREIGN KEY (track_id) REFERENCES track(id),
    FOREIGN KEY (musician_first_name, musician_last_name) REFERENCES musician(first_name, last_name)
);

-- tracks can appear on different albums
CREATE TABLE album_track (
    album_title VARCHAR(40) NOT NULL,
    group_name VARCHAR(40) NOT NULL,
    track_id INT NOT NULL,

    PRIMARY KEY (album_title, group_name, track_id),
    FOREIGN KEY (album_title, group_name) REFERENCES album(title, group_name),
    FOREIGN KEY (track_id) REFERENCES track(id)
);

