/*======================================================================
 * 
 *  NAME:    David Sosa 
 *  ASSIGN:  HW-2, Question 3
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Implementatino of Question 2 
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

CREATE TABLE album (
    title VARCHAR(40) NOT NULL,
    yr_recorded SMALLINT NOT NULL,
    group VARCHAR(40) NOT NULL,
    PRIMARY KEY (title, group)
);

CREATE TABLE group (
    name VARCHAR(40) NOT NULL,
    yr_formed SMALLINT NOT NULL,
    genre VARCHAR(40) NOT NULL,
);

CREATE TABLE genre (
    name VARCHAR(40) NOT NULL,
    description TEXT NOT NULL,
);

CREATE TABLE musician (

);
