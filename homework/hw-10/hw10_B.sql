/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-10, Part B
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Advanced SQL Queries
 * 
 *======================================================================*/

-- (5)
-- Recursive CTE to find all ancestors of Zia Simpson and Bart Simpson Jr.
DROP TABLE IF EXISTS parent_child;

CREATE TABLE parent_child (
    parent_name VARCHAR(40) NOT NULL,
    child_name VARCHAR(40) NOT NULL
);

INSERT INTO parent_child (parent_name, child_name) VALUES
('Abraham Simpson', 'Homer Simpson'),
('Monica Simpson', 'Homer Simpson'),
('Homer Simpson', 'Bart Simpson'),
('Homer Simpson', 'Lisa Simpson'),
('Homer Simpson', 'Maggie Simpson'),
('Marge Simpson', 'Bart Simpson'),
('Marge Simpson', 'Lisa Simpson'),
('Marge Simpson', 'Maggie Simpson'),
('Bart Simpson', 'Bart Simpson Jr.'),
('Lisa Simpson', 'Zia Simpson');

WITH RECURSIVE ancestors AS (
    -- Base case: Direct parents of Zia and Bart Jr
    SELECT 
        parent_name AS ancestor,
        child_name AS descendent,
        1 AS dist,
        parent_name || ' <- ' || child_name AS path
    FROM parent_child
    WHERE child_name IN ('Zia Simpson', 'Bart Simpson Jr.')
    -- union all for column connection
    UNION ALL
    SELECT 
        pc.parent_name AS ancestor,
        a.descendent AS descendent,
        a.dist + 1 AS dist,
        pc.parent_name || ' <- ' || a.path AS path 
    FROM parent_child pc  
        JOIN ancestors a ON pc.child_name = a.ancestor
)
SELECT ancestor, descendent, dist, path
FROM ancestors
ORDER BY descendent, dist, ancestor;

-- (6)
-- Find shortest distance flight routes between all pairs of cities
DROP TABLE IF EXISTS flight;

CREATE TABLE flight (
    flight_start VARCHAR(40) NOT NULL,
    flight_end VARCHAR(40) NOT NULL,
    flight_dist INTEGER NOT NULL
);

INSERT INTO flight (flight_start, flight_end, flight_dist) VALUES
('Seattle', 'San Francisco', 800),
('Seattle', 'Denver', 1300),
('San Francisco', 'Dallas', 1700),
('San Francisco', 'Denver', 900),
('Denver', 'Dallas', 800),
('Denver', 'Chicago', 1000),
('Dallas', 'Chicago', 900),
('Dallas', 'New York', 1500),
('Chicago', 'New York', 800),
('Seattle', 'Portland', 150),
('Portland', 'San Francisco', 650),
('Denver', 'Kansas City', 600),
('Kansas City', 'Chicago', 500),
('Dallas', 'Atlanta', 700),
('Atlanta', 'New York', 850);

-- Recursive CTE to find all routes
WITH RECURSIVE full_route (route_start, route_end, route_dist, detailed_path) AS (
    SELECT 
        flight_start,
        flight_end,
        flight_dist,
        flight_start || ' -> ' || flight_end
    FROM flight
    UNION ALL
    SELECT
        f.flight_start,
        r.route_end,
        f.flight_dist + r.route_dist,
        f.flight_start || ' -> ' || r.detailed_path
    FROM flight f
        JOIN full_route r ON f.flight_end = r.route_start
),
shortest_routes AS (
    SELECT 
        route_start,
        route_end,
        MIN(route_dist) AS min_dist
    FROM full_route
    GROUP BY route_start, route_end
)

-- return only shortest routes
SELECT 
    r.route_start,
    r.route_end,
    r.route_dist,
    r.detailed_path
FROM full_route r
    JOIN shortest_routes sr ON
        r.route_start = sr.route_start AND
        r.route_end = sr.route_end AND
        r.route_dist = sr.min_dist
ORDER BY r.route_start, r.route_end, r.detailed_path;