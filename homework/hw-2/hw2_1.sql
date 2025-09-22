/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-2, Question 1
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Airport, Airline, Flight, and Segment Schemas
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

-- ======================================================================
-- airport(id, name, city, state, elevation)
-- Stores information about airports.
-- ======================================================================
CREATE TABLE airport (
    id CHAR(3),
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state CHAR(2) NOT NULL,
    elevation INT NOT NULL,
    PRIMARY KEY (id)
);
INSERT INTO airport (id, name, city, state, elevation)
VALUES
('JFK', 'John F. Kennedy International Airport', 'New York', 'NY', 13),
('ORD', 'O\' Hare International Airport, 'Chicago', 'IL', 668),
('ATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'GA', 1026);


-- ======================================================================
-- airport(code, name, main_hub, yr_founded)
-- Stores information about airlines.
-- ======================================================================
CREATE TABLE airline (
    code CHAR(2),
    name VARCHAR(100) NOT NULL,
    main_hub VARCHAR(3) NOT NULL,
    yr_founded SMALLINT CHECK (yr_founded > 1900) NOT NULL,
    PRIMARY KEY (code),
    FOREIGN KEY (main_hub) REFERENCES airport(id)
);
INSERT INTO airline (code, name, main_hub, yr_founded)
VALUES
('AS', 'Alaska Airlines', 'SEA', 1932)
('WN', 'Southwest Airlines', 'DAL', 1967)
('UA', 'United Airlines', 'ORD', 1926);

-- ======================================================================
-- flight(airline, flight_number, departure, arrival, flights_per_wk)
-- Stores information about flights.
-- ======================================================================
CREATE TABLE flight(
    airline CHAR(2),
    flight_number INT NOT NULL,
    departure CHAR(3) NOT NULL,
    arrival CHAR(3) NOT NULL,
    flights_per_wk INT CHECK (flights_per_wk >= 0),
    PRIMARY KEY (airline, flight_number),
    FOREIGN KEY (airline) REFERENCES airline(code),
    FOREIGN KEY (departure) REFERENCES airport(id),
    FOREIGN KEY (arrival) REFERENCES airport(id)
);
INSERT INTO flight (airline, flight_number, departure, arrival, flights_per_wk)
VALUES
('AS', 123, 'SEA', 'LAX', 14),
('WN', 250, 'DAL' , 'LAX', 21),
('UA', 1, 'ORD', 'HNL', 21);

-- ======================================================================
-- segment(airline, flight_number, segment_offset, start_airport, end_airport)
-- Stores information about flight segments.
-- ======================================================================
CREATE TABLE segment (
    airline CHAR(2),
    flight_number INT NOT NULL,
    segment_offset INT NOT NULL,
    start_airport CHAR(3) NOT NULL,
    end_airport CHAR(3) NOT NULL,
    PRIMARY KEY (airline, flight_number, segment_offset),
    FOREIGN KEY (airline) REFERENCES airline(code),
    FOREIGN KEY (flight_number) REFERENCES flight(flight_number)
);

INSERT INTO segment (airline, flight_number, segment_offset, start_airport, end_airport) VALUES
('UA', 1, 1, 'ORD', 'SFO'),
('UA', 1, 2, 'SFO', 'HNL'),
('WN', 250, 1, 'DAL', 'PHX');
