/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-3, Part 1
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    ... description ....
 * 
 *======================================================================*/


-- TODO:
--   * Fill in your name above and a brief description.
--   * Implement the Part 1 schema as per the homework instructions.
--   * Populate each table according to the homework instructions.
--   * Be sure each table has a comment describing its purpose.
--   * Be sure to add comments as needed for attributes.
--   * Be sure your SQL code is well formatted (according to the style guides).

/*======================================================================
*   Table: country
*   Purpose: represents a country
*======================================================================*/
CREATE TABLE country (
    country_code CHAR(2) NOT NULL,
    country_name VARCHAR(40) NOT NULL,
    gdp INT NOT NULL,
    inflation NUMERIC(2, 1) NOT NULL,

    PRIMARY KEY (country_code)
);

/*======================================================================
*   Table: province
*   Purpose: represents a province
*======================================================================*/
CREATE TABLE province (
    province_name VARCHAR(40) NOT NULL, 
    country_code CHAR(2) NOT NULL,
    already INT NOT NULL,

    PRIMARY KEY (province_name, country_code),
    FOREIGN KEY (country_code) REFERENCES country(country_code)
);

/*======================================================================
*   Table: city
*   Purpose: represents a city
*======================================================================*/
CREATE TABLE city (
    city_name VARCHAR(40) NOT NULL,
    province_name VARCHAR(40) NOT NULL,
    country_code CHAR(2) NOT NULL,
    population INT NOT NULL,

    PRIMARY KEY (city_name, province_name, country_code),
    FOREIGN KEY (province_name, country_code) REFERENCES province(province_name, country_code)
);

/*======================================================================
*   Table: border
*   Purpose: represents a border
*======================================================================*/
CREATE TABLE border (
    country_code_1 CHAR(2) NOT NULL,
    country_code_2 CHAR(2) NOT NULL,
    border_length INT NOT NULL,
    
    PRIMARY KEY (country_code_1, country_code_2),
    FOREIGN KEY (country_code_1) REFERENCES country(country_code),
    FOREIGN KEY (country_code_2) REFERENCES country(country_code),
    CONSTRAINT country_code_not_same CHECK (country_code_1 <> country_code_2) -- country can't border itself in this case
);
