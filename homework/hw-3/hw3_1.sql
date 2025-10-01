/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-3, Part 1
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Table definition for part one. All tables defined and data
 *           inserted to those tables. 
 * 
 *======================================================================*/


-- TODO:
--   * Fill in your name above and a brief description.
--   * Implement the Part 1 schema as per the homework instructions.
--   * Populate each table according to the homework instructions.
--   * Be sure each table has a comment describing its purpose.
--   * Be sure to add comments as needed for attributes.
--   * Be sure your SQL code is well formatted (according to the style guides).

-- dropping tables
DROP TABLE IF EXISTS border CASCADE;
DROP TABLE IF EXISTS city CASCADE;
DROP TABLE IF EXISTS province CASCADE;
DROP TABLE IF EXISTS country CASCADE;

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
INSERT INTO country (country_code, country_name, gdp, inflation) VALUES 
('US', 'United States of America', 21433, 1.8),
('MX', 'Mexico', 12600, 4.2),
('CA', 'Canada', 17364, 2.1),
('TH', 'Thailand', 5437, 1.0);


/*======================================================================
*   Table: province
*   Purpose: represents a province
*======================================================================*/
CREATE TABLE province (
    province_name VARCHAR(40) NOT NULL, 
    country_code CHAR(2) NOT NULL,
    area INT NOT NULL,

    PRIMARY KEY (province_name, country_code),
    FOREIGN KEY (country_code) REFERENCES country(country_code)
);

INSERT INTO province (province_name, country_code, area) VALUES
-- US (4 provinces)
('California', 'US', 423967),
('Texas', 'US', 695662),
('New York', 'US', 141297),
('Florida', 'US', 170312),
-- MX (4 provinces)
('Jalisco', 'MX', 78599),
('Nuevo Leon', 'MX', 64555),
('Estado de Mexico', 'MX', 22357),
('Puebla', 'MX', 34306),
-- CA (4 provinces)
('Ontario', 'CA', 1076395),
('Quebec', 'CA', 1542056),
('British Columbia', 'CA', 944735),
('Alberta', 'CA', 661848),
-- TH (4 provinces)
('Bangkok', 'TH', 1569),
('Chiang Mai', 'TH', 20107),
('Phuket', 'TH', 576),
('Chonburi', 'TH', 4536);

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

INSERT INTO city (city_name, province_name, country_code, population) VALUES
-- US: California (4)
('Los Angeles', 'California', 'US', 3970000),
('San Diego', 'California', 'US', 1420000),
('San Jose', 'California', 'US', 1035000),
('San Francisco', 'California', 'US', 884000),
-- US: Texas (4)
('Houston', 'Texas', 'US', 2320000),
('Dallas', 'Texas', 'US', 1340000),
('Austin', 'Texas', 'US', 964000),
('San Antonio', 'Texas', 'US', 1547000),
-- US: New York (4)
('New York City', 'New York', 'US', 8330000),
('Buffalo', 'New York', 'US', 256000),
('Rochester', 'New York', 'US', 205000),
('Syracuse', 'New York', 'US', 142000),
-- US: Florida (4)
('Jacksonville', 'Florida', 'US', 903000),
('Miami', 'Florida', 'US', 470000),
('Tampa', 'Florida', 'US', 399000),
('Orlando', 'Florida', 'US', 287000),
-- MX: Jalisco (4)
('Guadalajara', 'Jalisco', 'MX', 1495000),
('Zapopan', 'Jalisco', 'MX', 1240000),
('Tlaquepaque', 'Jalisco', 'MX', 664000),
('Tonalá', 'Jalisco', 'MX', 600000),
-- MX: Nuevo Leon (4)
('Monterrey', 'Nuevo Leon', 'MX', 1135000),
('Guadalupe', 'Nuevo Leon', 'MX', 673000),
('San Nicolás', 'Nuevo Leon', 'MX', 444000),
('Apodaca', 'Nuevo Leon', 'MX', 656000),
-- MX: Estado de Mexico (4)
('Ecatepec', 'Estado de Mexico', 'MX', 1655000),
('Naucalpan', 'Estado de Mexico', 'MX', 833000),
('Tlalnepantla', 'Estado de Mexico', 'MX', 715000),
('Toluca', 'Estado de Mexico', 'MX', 910000),
-- MX: Puebla (4)
('Puebla', 'Puebla', 'MX', 1434000),
('Tehuacán', 'Puebla', 'MX', 319000),
('San Martín Texmelucan', 'Puebla', 'MX', 155000),
('Atlixco', 'Puebla', 'MX', 140000),
-- CA: Ontario (4)
('Toronto', 'Ontario', 'CA', 2930000),
('Ottawa', 'Ontario', 'CA', 1010000),
('Mississauga', 'Ontario', 'CA', 721000),
('Brampton', 'Ontario', 'CA', 656000),
-- CA: Quebec (4)
('Montreal', 'Quebec', 'CA', 1780000),
('Quebec City', 'Quebec', 'CA', 542000),
('Laval', 'Quebec', 'CA', 438000),
('Gatineau', 'Quebec', 'CA', 287000),
-- CA: British Columbia (4)
('Vancouver', 'British Columbia', 'CA', 675000),
('Victoria', 'British Columbia', 'CA', 92000),
('Surrey', 'British Columbia', 'CA', 518000),
('Burnaby', 'British Columbia', 'CA', 249000),
-- CA: Alberta (4)
('Calgary', 'Alberta', 'CA', 1239000),
('Edmonton', 'Alberta', 'CA', 981000),
('Red Deer', 'Alberta', 'CA', 106000),
('Lethbridge', 'Alberta', 'CA', 101000),
-- TH: Bangkok (4)
('Bangkok', 'Bangkok', 'TH', 10539000),
('Bang Kapi', 'Bangkok', 'TH', 150000),
('Lat Krabang', 'Bangkok', 'TH', 94000),
('Thon Buri', 'Bangkok', 'TH', 120000),
-- TH: Chiang Mai (4)
('Chiang Mai', 'Chiang Mai', 'TH', 1270000),
('Hang Dong', 'Chiang Mai', 'TH', 85000),
('San Sai', 'Chiang Mai', 'TH', 100000),
('Mae Rim', 'Chiang Mai', 'TH', 95000),
-- TH: Phuket (4)
('Phuket City', 'Phuket', 'TH', 80000),
('Patong', 'Phuket', 'TH', 25000),
('Karon', 'Phuket', 'TH', 20000),
('Kata', 'Phuket', 'TH', 18000),
-- TH: Chonburi (4)
('Chonburi', 'Chonburi', 'TH', 350000),
('Pattaya', 'Chonburi', 'TH', 320000),
('Si Racha', 'Chonburi', 'TH', 300000),
('Bang Saen', 'Chonburi', 'TH', 150000);

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

INSERT INTO border (country_code_1, country_code_2, border_length) VALUES
('US', 'CA', 8893),
('US', 'MX', 3145);
