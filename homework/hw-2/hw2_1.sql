/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-2, Question 1
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Airport, Airline, Flight, and Segment Schemas
 * 
 *======================================================================*/

-- Dropping Tables
DROP TABLE IF EXISTS segment;
DROP TABLE IF EXISTS flight;
DROP TABLE IF EXISTS airline;
DROP TABLE IF EXISTS airport;

-- ======================================================================
-- airport(id, name, city, state, elevation)
-- Stores information about airports.
-- ======================================================================
CREATE TABLE airport (
    id CHAR(3),
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state CHAR(2) NOT NULL,
    elevation INT NOT NULL CHECK (elevation >= 0),
    PRIMARY KEY (id)
);

INSERT INTO airport (id, name, city, state, elevation) VALUES
('JFK', 'John F. Kennedy International Airport', 'New York', 'NY', 13),
('ORD', 'O''Hare International Airport', 'Chicago', 'IL', 668),
('ATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'GA', 1026),
('SEA', 'Seattle-Tacoma International Airport', 'Seattle', 'WA', 433),
('DAL', 'Dallas Love Field', 'Dallas', 'TX', 487),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'CA', 125),
('HNL', 'Daniel K. Inouye International Airport', 'Honolulu', 'HI', 13),
('SFO', 'San Francisco International Airport', 'San Francisco', 'CA', 13),
('PHX', 'Phoenix Sky Harbor International Airport', 'Phoenix', 'AZ', 1135),
('DFW', 'Dallas/Fort Worth International Airport', 'Dallas-Fort Worth', 'TX', 607);
-- Violating INSERTs:
-- INSERT INTO airport VALUES ('SEA', 'Duplicate SEA', 'Seattle', 'WA', 433); -- duplicate PK
-- INSERT INTO airport VALUES ('XXX', 'Invalid Elevation Test', 'Nowhere', 'ZZ', -50); -- bad elevation


-- ======================================================================
-- airline(code, name, main_hub, yr_founded)
-- Stores information about airlines.
-- ======================================================================
CREATE TABLE airline (
    code CHAR(2),
    name VARCHAR(100) NOT NULL,
    main_hub CHAR(3) NOT NULL,
    yr_founded SMALLINT NOT NULL CHECK (yr_founded > 1900),
    PRIMARY KEY (code),
    FOREIGN KEY (main_hub) REFERENCES airport(id)
);

INSERT INTO airline (code, name, main_hub, yr_founded) VALUES
('AS', 'Alaska Airlines', 'SEA', 1932),
('WN', 'Southwest Airlines', 'DAL', 1967),
('UA', 'United Airlines', 'ORD', 1926),
('DL', 'Delta Airlines', 'ATL', 1924),
('AA', 'American Airlines', 'DFW', 1930);
-- Violating INSERTs:
-- INSERT INTO airline VALUES ('UA', 'Duplicate United', 'ORD', 2000); -- duplicate PK
-- INSERT INTO airline VALUES ('ZZ', 'Ghost Airline', 'XXX', 2020); -- invalid hub airport

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
    FOREIGN KEY (arrival) REFERENCES airport(id),
    CONSTRAINT no_self_flight CHECK (departure <> arrival)
);
INSERT INTO flight (airline, flight_number, departure, arrival, flights_per_wk) VALUES
('AS', 123, 'SEA', 'LAX', 14),
('WN', 250, 'DAL', 'LAX', 21),
('UA', 1, 'ORD', 'HNL', 21),
('DL', 85, 'ATL', 'JFK', 35),
('AA', 100, 'DFW', 'PHX', 28);
-- Violating INSERTs:
INSERT INTO flight VALUES ('UA', 1, 'ORD', 'HNL', 10); -- duplicate PK
INSERT INTO flight VALUES ('AS', 200, 'SEA', 'SEA', 7); -- departure = arrival (not allowed)

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
    FOREIGN KEY (airline, flight_number) REFERENCES flight(airline, flight_number),
    FOREIGN KEY (start_airport) REFERENCES airport(id),
    FOREIGN KEY (end_airport) REFERENCES airport(id),
    CONSTRAINT no_self_segment CHECK (start_airport <> end_airport)
);

INSERT INTO segment (airline, flight_number, segment_offset, start_airport, end_airport) VALUES
('UA', 1, 1, 'ORD', 'SFO'),
('UA', 1, 2, 'SFO', 'HNL'),
('WN', 250, 1, 'DAL', 'PHX'),
('WN', 250, 2, 'PHX', 'LAX'),
('DL', 85, 1, 'ATL', 'JFK');
-- Violating INSERTs:
INSERT INTO segment VALUES ('UA', 1, 1, 'ORD', 'SFO'); -- duplicate PK
INSERT INTO segment VALUES ('UA', 1, 3, 'SFO', 'SFO'); -- start=end not allowed