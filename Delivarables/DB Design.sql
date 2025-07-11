--  Ensure you are connected to your `disease_surveillance` database

-- 1️ District Mapping Table
CREATE TABLE IF NOT EXISTS district_mapping (
    district_code VARCHAR(10) PRIMARY KEY,
    district_name VARCHAR(255) NOT NULL
);

-- 2️ Cases Table (only required fields)
CREATE TABLE IF NOT EXISTS cases_table (
    district_code VARCHAR(10),
    week INT,
    year INT,
    disease VARCHAR(100),
    cases_reported INT,
    FOREIGN KEY (district_code) REFERENCES district_mapping(district_code)
);

-- 3️ Vaccination Table
CREATE TABLE IF NOT EXISTS vaccination_table (
    district_code VARCHAR(10) PRIMARY KEY,
    vaccination_coverage FLOAT,
    FOREIGN KEY (district_code) REFERENCES district_mapping(district_code)
);

-- 4️ Population Table
CREATE TABLE IF NOT EXISTS population_table (
    district_code VARCHAR(10) PRIMARY KEY,
    population BIGINT,
    FOREIGN KEY (district_code) REFERENCES district_mapping(district_code)
);

-- 5️ Weather Table
CREATE TABLE IF NOT EXISTS weather_table (
    district_code VARCHAR(10),
    week INT,
    rainfall_mm FLOAT,
    humidity FLOAT,
    FOREIGN KEY (district_code) REFERENCES district_mapping(district_code)
);



SELECT * FROM weather_table;