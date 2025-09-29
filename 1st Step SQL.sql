-- ====================================================================================
--                      UK Energy Consumption Data Processing Project
-- ====================================================================================
-- Author       : Mohammed Gafoor Patel 
-- University   : Salford University, Manchester
-- Description  : Full SQL script for preprocessing, EDA, statistical analysis, 
--                and preparation for Power BI and Machine Learning.
-- ====================================================================================

-- =======================================================
-- Step 1: Create Database
-- =======================================================
-- First, we create the database where we will store our data.
-- This ensures that all data operations happen in the correct database.

create database UK_ENERGY;

-- Use the database to make sure all queries are executed within it.
use UK_ENERGY;

-- =======================================================
-- Step 2: Create Table for Data Storage
-- =======================================================
-- Now, we create a table that will store the energy consumption data.
-- Initially, all numeric columns are stored as VARCHAR to avoid errors when importing data.
CREATE TABLE EnergyConsumption (
    ID INT IDENTITY(1,1) PRIMARY KEY,  -- Unique identifier for each record

    -- Year Column (Stored as VARCHAR for now)
    Year VARCHAR(10) NOT NULL,  -- Represents the year of the data entry

    -- Regional Information
    Region VARCHAR(100) NOT NULL,  -- Represents the name of the region
    LA VARCHAR(100) NOT NULL,  -- Represents the Local Authority (City)

    -- Energy Consumption by Fuel Type (Stored as VARCHAR for now)
    All_fuels_Domestic VARCHAR(50),  
    All_fuels_Transport VARCHAR(50),  
    All_fuels_Industrial_Commercial_and_other VARCHAR(50),  
    All_fuels_Total VARCHAR(50),  

    -- Energy Consumption from Coal
    Coal_Industrial VARCHAR(50),  
    Coal_Commercial VARCHAR(50),  
    Coal_Domestic VARCHAR(50),  
    Coal_Rail VARCHAR(50),  
    Coal_Public_sector VARCHAR(50),  
    Coal_Agriculture VARCHAR(50),  
    Coal_Total VARCHAR(50),  

    -- Energy Consumption from Manufactured Fuels
    Manufactured_fuels_Industrial VARCHAR(50),  
    Manufactured_fuels_Domestic VARCHAR(50),  
    Manufactured_fuels_Total VARCHAR(50),  

    -- Energy Consumption from Petroleum
    Petroleum_Industrial VARCHAR(50),  
    Petroleum_Commercial VARCHAR(50),  
    Petroleum_Domestic VARCHAR(50),  
    Petroleum_Road_transport VARCHAR(50),  
    Petroleum_Rail VARCHAR(50),  
    Petroleum_Public_sector VARCHAR(50),  
    Petroleum_Agriculture VARCHAR(50),  
    Petroleum_Total VARCHAR(50),  

    -- Energy Consumption from Gas
    Gas_Domestic VARCHAR(50),  
    Gas_Industrial_Commercial_and_other VARCHAR(50),  
    Gas_Total VARCHAR(50),  

    -- Energy Consumption from Electricity
    Electricity_Domestic VARCHAR(50),  
    Electricity_Industrial_Commercial_and_other VARCHAR(50),  
    Electricity_Total VARCHAR(50),  

    -- Energy Consumption from Bioenergy & Waste
    Bioenergy_and_wastes_Domestic VARCHAR(50),  
    Bioenergy_and_wastes_Road_transport VARCHAR(50),  
    Bioenergy_and_wastes_Industrial_and_Commercial VARCHAR(50),  
    Bioenergy_and_wastes_Total VARCHAR(50)  
);
--checking the energyconsumption table that successfully create or not
use UK_ENERGY
exec sp_columns EnergyConsumption

--we create our table as compared to imported CSV file.

-- =======================================================
-- Step 3: Verify Data Import (Checking Imported CSV Table)
-- =======================================================
-- After importing data, we check if the import was successful.

-- Check the total number of rows in the imported dataset
SELECT COUNT(*) FROM Final_energy_consumption_2020;

-- Check the first 10 rows to ensure data is correctly imported
SELECT TOP 10 * FROM Final_energy_consumption_2020;

-- =======================================================
-- Step 4: Check for NULL or Empty Values
-- =======================================================
-- Some categorical columns (Year, Region, LA) must not have NULL or empty values.
-- We check for both NULL and empty string values.

-- Check for NULL values in key columns
SELECT * FROM Final_energy_consumption_2020
WHERE Year IS NULL OR Region IS NULL OR LA IS NULL;

-- Check for empty string values (because VARCHAR columns may have empty strings instead of NULL)
SELECT * FROM Final_energy_consumption_2020
WHERE LTRIM(RTRIM(Year)) = '' 
   OR LTRIM(RTRIM(Region)) = '' 
   OR LTRIM(RTRIM(LA)) = '';
   -- There is no empty strings or null values in the columns.

-- =======================================================
-- Step 5: Identify Non-Numeric Values in Numeric Columns
-- =======================================================
-- Since numeric columns were imported as VARCHAR, we need to identify any text values.
-- This query finds rows where numeric fields contain non-numeric values.

SELECT * 
FROM Final_energy_consumption_2020
WHERE 
    TRY_CAST(All_fuels_Domestic AS FLOAT) IS NULL AND All_fuels_Domestic IS NOT NULL
    OR TRY_CAST(All_fuels_Transport AS FLOAT) IS NULL AND All_fuels_Transport IS NOT NULL
    OR TRY_CAST(All_fuels_Industrial_Commercial_and_other AS FLOAT) IS NULL AND All_fuels_Industrial_Commercial_and_other IS NOT NULL
    OR TRY_CAST(All_fuels_Total AS FLOAT) IS NULL AND All_fuels_Total IS NOT NULL
    OR TRY_CAST(Coal_Industrial AS FLOAT) IS NULL AND Coal_Industrial IS NOT NULL
    OR TRY_CAST(Coal_Commercial AS FLOAT) IS NULL AND Coal_Commercial IS NOT NULL
    OR TRY_CAST(Coal_Domestic AS FLOAT) IS NULL AND Coal_Domestic IS NOT NULL
    OR TRY_CAST(Coal_Rail AS FLOAT) IS NULL AND Coal_Rail IS NOT NULL
    OR TRY_CAST(Coal_Public_sector AS FLOAT) IS NULL AND Coal_Public_sector IS NOT NULL
    OR TRY_CAST(Coal_Agriculture AS FLOAT) IS NULL AND Coal_Agriculture IS NOT NULL
    OR TRY_CAST(Coal_Total AS FLOAT) IS NULL AND Coal_Total IS NOT NULL
    OR TRY_CAST(Manufactured_fuels_Industrial AS FLOAT) IS NULL AND Manufactured_fuels_Industrial IS NOT NULL
    OR TRY_CAST(Manufactured_fuels_Domestic AS FLOAT) IS NULL AND Manufactured_fuels_Domestic IS NOT NULL
    OR TRY_CAST(Manufactured_fuels_Total AS FLOAT) IS NULL AND Manufactured_fuels_Total IS NOT NULL
    OR TRY_CAST(Petroleum_Industrial AS FLOAT) IS NULL AND Petroleum_Industrial IS NOT NULL
    OR TRY_CAST(Petroleum_Commercial AS FLOAT) IS NULL AND Petroleum_Commercial IS NOT NULL
    OR TRY_CAST(Petroleum_Domestic AS FLOAT) IS NULL AND Petroleum_Domestic IS NOT NULL
    OR TRY_CAST(Petroleum_Road_transport AS FLOAT) IS NULL AND Petroleum_Road_transport IS NOT NULL
    OR TRY_CAST(Petroleum_Rail AS FLOAT) IS NULL AND Petroleum_Rail IS NOT NULL
    OR TRY_CAST(Petroleum_Public_sector AS FLOAT) IS NULL AND Petroleum_Public_sector IS NOT NULL
    OR TRY_CAST(Petroleum_Agriculture AS FLOAT) IS NULL AND Petroleum_Agriculture IS NOT NULL
    OR TRY_CAST(Petroleum_Total AS FLOAT) IS NULL AND Petroleum_Total IS NOT NULL
    OR TRY_CAST(Gas_Domestic AS FLOAT) IS NULL AND Gas_Domestic IS NOT NULL
    OR TRY_CAST(Gas_Industrial_Commercial_and_other AS FLOAT) IS NULL AND Gas_Industrial_Commercial_and_other IS NOT NULL
    OR TRY_CAST(Gas_Total AS FLOAT) IS NULL AND Gas_Total IS NOT NULL
    OR TRY_CAST(Electricity_Domestic AS FLOAT) IS NULL AND Electricity_Domestic IS NOT NULL
    OR TRY_CAST(Electricity_Industrial_Commercial_and_other AS FLOAT) IS NULL AND Electricity_Industrial_Commercial_and_other IS NOT NULL
    OR TRY_CAST(Electricty_Total AS FLOAT) IS NULL AND Electricty_Total IS NOT NULL
    OR TRY_CAST(Bioenergy_and_wastes_Domestic AS FLOAT) IS NULL AND Bioenergy_and_wastes_Domestic IS NOT NULL
    OR TRY_CAST(Bioenergy_and_wastes_Road_transport AS FLOAT) IS NULL AND Bioenergy_and_wastes_Road_transport IS NOT NULL
    OR TRY_CAST(Bioenergy_and_wastes_Industrial_and_Commercial AS FLOAT) IS NULL AND Bioenergy_and_wastes_Industrial_and_Commercial IS NOT NULL
    OR TRY_CAST(Bioenergy_and_wastes_Total AS FLOAT) IS NULL AND Bioenergy_and_wastes_Total IS NOT NULL;


-- Now the main thing is to converting columns from VARCHAR to FLOAT to ensure correct data types
-- When importing data from CSV, all numeric values were treated as text (VARCHAR) by default.
-- This happened because the import wizard reads empty/null values as text.
-- However, for accurate calculations, comparisons, and aggregations in SQL and further process in Power BI, 
-- So we need numerical values in FLOAT format.

-- =======================================================
-- Step 6: Cleaning Non-Numeric Values (Replacing them with NULL)
-- =======================================================
-- Now, we replace all non-numeric values (like 'NULL', 'N/A', or empty strings) with NULL.

UPDATE Final_energy_consumption_2020
SET All_fuels_Domestic = NULL
WHERE TRY_CAST(All_fuels_Domestic AS FLOAT) IS NULL 
AND All_fuels_Domestic NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET All_fuels_Transport = NULL
WHERE TRY_CAST(All_fuels_Transport AS FLOAT) IS NULL 
AND All_fuels_Transport NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET All_fuels_Industrial_Commercial_and_other = NULL
WHERE TRY_CAST(All_fuels_Industrial_Commercial_and_other AS FLOAT) IS NULL 
AND All_fuels_Industrial_Commercial_and_other NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET All_fuels_Total = NULL
WHERE TRY_CAST(All_fuels_Total AS FLOAT) IS NULL 
AND All_fuels_Total NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Coal_Industrial = NULL
WHERE TRY_CAST(Coal_Industrial AS FLOAT) IS NULL 
AND Coal_Industrial NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Coal_Commercial = NULL
WHERE TRY_CAST(Coal_Commercial AS FLOAT) IS NULL 
AND Coal_Commercial NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Coal_Domestic = NULL
WHERE TRY_CAST(Coal_Domestic AS FLOAT) IS NULL 
AND Coal_Domestic NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Coal_Rail = NULL
WHERE TRY_CAST(Coal_Rail AS FLOAT) IS NULL 
AND Coal_Rail NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Coal_Public_sector = NULL
WHERE TRY_CAST(Coal_Public_sector AS FLOAT) IS NULL 
AND Coal_Public_sector NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Coal_Agriculture = NULL
WHERE TRY_CAST(Coal_Agriculture AS FLOAT) IS NULL 
AND Coal_Agriculture NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Coal_Total = NULL
WHERE TRY_CAST(Coal_Total AS FLOAT) IS NULL 
AND Coal_Total NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Manufactured_fuels_Industrial = NULL
WHERE TRY_CAST(Manufactured_fuels_Industrial AS FLOAT) IS NULL 
AND Manufactured_fuels_Industrial NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Manufactured_fuels_Domestic = NULL
WHERE TRY_CAST(Manufactured_fuels_Domestic AS FLOAT) IS NULL 
AND Manufactured_fuels_Domestic NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Manufactured_fuels_Total = NULL
WHERE TRY_CAST(Manufactured_fuels_Total AS FLOAT) IS NULL 
AND Manufactured_fuels_Total NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Petroleum_Industrial = NULL
WHERE TRY_CAST(Petroleum_Industrial AS FLOAT) IS NULL 
AND Petroleum_Industrial NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Petroleum_Commercial = NULL
WHERE TRY_CAST(Petroleum_Commercial AS FLOAT) IS NULL 
AND Petroleum_Commercial NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Petroleum_Domestic = NULL
WHERE TRY_CAST(Petroleum_Domestic AS FLOAT) IS NULL 
AND Petroleum_Domestic NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Petroleum_Road_transport = NULL
WHERE TRY_CAST(Petroleum_Road_transport AS FLOAT) IS NULL 
AND Petroleum_Road_transport NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Petroleum_Rail = NULL
WHERE TRY_CAST(Petroleum_Rail AS FLOAT) IS NULL 
AND Petroleum_Rail NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Petroleum_Public_sector = NULL
WHERE TRY_CAST(Petroleum_Public_sector AS FLOAT) IS NULL 
AND Petroleum_Public_sector NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Petroleum_Agriculture = NULL
WHERE TRY_CAST(Petroleum_Agriculture AS FLOAT) IS NULL 
AND Petroleum_Agriculture NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Petroleum_Total = NULL
WHERE TRY_CAST(Petroleum_Total AS FLOAT) IS NULL 
AND Petroleum_Total NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Gas_Domestic = NULL
WHERE TRY_CAST(Gas_Domestic AS FLOAT) IS NULL 
AND Gas_Domestic NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Gas_Industrial_Commercial_and_other = NULL
WHERE TRY_CAST(Gas_Industrial_Commercial_and_other AS FLOAT) IS NULL 
AND Gas_Industrial_Commercial_and_other NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Gas_Total = NULL
WHERE TRY_CAST(Gas_Total AS FLOAT) IS NULL 
AND Gas_Total NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Electricity_Domestic = NULL
WHERE TRY_CAST(Electricity_Domestic AS FLOAT) IS NULL 
AND Electricity_Domestic NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Electricity_Industrial_Commercial_and_other = NULL
WHERE TRY_CAST(Electricity_Industrial_Commercial_and_other AS FLOAT) IS NULL 
AND Electricity_Industrial_Commercial_and_other NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Electricty_Total = NULL
WHERE TRY_CAST(Electricty_Total AS FLOAT) IS NULL 
AND Electricty_Total NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Bioenergy_and_wastes_Domestic = NULL
WHERE TRY_CAST(Bioenergy_and_wastes_Domestic AS FLOAT) IS NULL 
AND Bioenergy_and_wastes_Domestic NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Bioenergy_and_wastes_Road_transport = NULL
WHERE TRY_CAST(Bioenergy_and_wastes_Road_transport AS FLOAT) IS NULL 
AND Bioenergy_and_wastes_Road_transport NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Bioenergy_and_wastes_Industrial_and_Commercial = NULL
WHERE TRY_CAST(Bioenergy_and_wastes_Industrial_and_Commercial AS FLOAT) IS NULL 
AND Bioenergy_and_wastes_Industrial_and_Commercial NOT IN ('NULL', 'N/A', '');

UPDATE Final_energy_consumption_2020
SET Bioenergy_and_wastes_Total = NULL
WHERE TRY_CAST(Bioenergy_and_wastes_Total AS FLOAT) IS NULL 
AND Bioenergy_and_wastes_Total NOT IN ('NULL', 'N/A', '');

-- =======================================================
-- Step 7: Verifying NULL Counts in Numeric Columns
-- =======================================================
-- After replacing non-numeric values with NULL, we check how many NULL values exist in each column.
-- This helps verify that all invalid values were successfully removed.

SELECT 
    -- Checking NULL Values Separately
    SUM(CASE WHEN All_fuels_Domestic IS NULL THEN 1 ELSE 0 END) AS Null_All_fuels_Domestic,
    SUM(CASE WHEN All_fuels_Transport IS NULL THEN 1 ELSE 0 END) AS Null_All_fuels_Transport,
    SUM(CASE WHEN All_fuels_Industrial_Commercial_and_other IS NULL THEN 1 ELSE 0 END) AS Null_All_fuels_Industrial_Commercial_and_other,
    SUM(CASE WHEN All_fuels_Total IS NULL THEN 1 ELSE 0 END) AS Null_All_fuels_Total,
    
    SUM(CASE WHEN Coal_Industrial IS NULL THEN 1 ELSE 0 END) AS Null_Coal_Industrial,
    SUM(CASE WHEN Coal_Commercial IS NULL THEN 1 ELSE 0 END) AS Null_Coal_Commercial,
    SUM(CASE WHEN Coal_Domestic IS NULL THEN 1 ELSE 0 END) AS Null_Coal_Domestic,
    SUM(CASE WHEN Coal_Rail IS NULL THEN 1 ELSE 0 END) AS Null_Coal_Rail,
    SUM(CASE WHEN Coal_Public_sector IS NULL THEN 1 ELSE 0 END) AS Null_Coal_Public_sector,
    SUM(CASE WHEN Coal_Agriculture IS NULL THEN 1 ELSE 0 END) AS Null_Coal_Agriculture,
    SUM(CASE WHEN Coal_Total IS NULL THEN 1 ELSE 0 END) AS Null_Coal_Total,

    SUM(CASE WHEN Manufactured_fuels_Industrial IS NULL THEN 1 ELSE 0 END) AS Null_Manufactured_fuels_Industrial,
    SUM(CASE WHEN Manufactured_fuels_Domestic IS NULL THEN 1 ELSE 0 END) AS Null_Manufactured_fuels_Domestic,
    SUM(CASE WHEN Manufactured_fuels_Total IS NULL THEN 1 ELSE 0 END) AS Null_Manufactured_fuels_Total,

    SUM(CASE WHEN Petroleum_Industrial IS NULL THEN 1 ELSE 0 END) AS Null_Petroleum_Industrial,
    SUM(CASE WHEN Petroleum_Commercial IS NULL THEN 1 ELSE 0 END) AS Null_Petroleum_Commercial,
    SUM(CASE WHEN Petroleum_Domestic IS NULL THEN 1 ELSE 0 END) AS Null_Petroleum_Domestic,
    SUM(CASE WHEN Petroleum_Road_transport IS NULL THEN 1 ELSE 0 END) AS Null_Petroleum_Road_transport,
    SUM(CASE WHEN Petroleum_Rail IS NULL THEN 1 ELSE 0 END) AS Null_Petroleum_Rail,
    SUM(CASE WHEN Petroleum_Public_sector IS NULL THEN 1 ELSE 0 END) AS Null_Petroleum_Public_sector,
    SUM(CASE WHEN Petroleum_Agriculture IS NULL THEN 1 ELSE 0 END) AS Null_Petroleum_Agriculture,
    SUM(CASE WHEN Petroleum_Total IS NULL THEN 1 ELSE 0 END) AS Null_Petroleum_Total,

    SUM(CASE WHEN Gas_Domestic IS NULL THEN 1 ELSE 0 END) AS Null_Gas_Domestic,
    SUM(CASE WHEN Gas_Industrial_Commercial_and_other IS NULL THEN 1 ELSE 0 END) AS Null_Gas_Industrial_Commercial_and_other,
    SUM(CASE WHEN Gas_Total IS NULL THEN 1 ELSE 0 END) AS Null_Gas_Total,

    SUM(CASE WHEN Electricity_Domestic IS NULL THEN 1 ELSE 0 END) AS Null_Electricity_Domestic,
    SUM(CASE WHEN Electricity_Industrial_Commercial_and_other IS NULL THEN 1 ELSE 0 END) AS Null_Electricity_Industrial_Commercial_and_other,
    SUM(CASE WHEN Electricty_Total IS NULL THEN 1 ELSE 0 END) AS Null_Electricity_Total,

    SUM(CASE WHEN Bioenergy_and_wastes_Domestic IS NULL THEN 1 ELSE 0 END) AS Null_Bioenergy_and_wastes_Domestic,
    SUM(CASE WHEN Bioenergy_and_wastes_Road_transport IS NULL THEN 1 ELSE 0 END) AS Null_Bioenergy_and_wastes_Road_transport,
    SUM(CASE WHEN Bioenergy_and_wastes_Industrial_and_Commercial IS NULL THEN 1 ELSE 0 END) AS Null_Bioenergy_and_wastes_Industrial_and_Commercial,
    SUM(CASE WHEN Bioenergy_and_wastes_Total IS NULL THEN 1 ELSE 0 END) AS Null_Bioenergy_and_wastes_Total

FROM Final_energy_consumption_2020;


-- =======================================================
-- Step 8: Convert VARCHAR Columns to FLOAT
-- =======================================================
-- Now that all non-numeric values have been removed, we can safely convert these columns to FLOAT.

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN All_fuels_Domestic FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN All_fuels_Transport FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN All_fuels_Industrial_Commercial_and_other FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN All_fuels_Total FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Coal_Industrial FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Coal_Commercial FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Coal_Domestic FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Coal_Rail FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Coal_Public_sector FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Coal_Agriculture FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Coal_Total FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Manufactured_fuels_Industrial FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Manufactured_fuels_Domestic FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Manufactured_fuels_Total FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Petroleum_Industrial FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Petroleum_Commercial FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Petroleum_Domestic FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Petroleum_Road_transport FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Petroleum_Rail FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Petroleum_Public_sector FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Petroleum_Agriculture FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Petroleum_Total FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Gas_Domestic FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Gas_Industrial_Commercial_and_other FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Gas_Total FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Electricity_Domestic FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Electricity_Industrial_Commercial_and_other FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Electricty_Total FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Bioenergy_and_wastes_Domestic FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Bioenergy_and_wastes_Road_transport FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Bioenergy_and_wastes_Industrial_and_Commercial FLOAT;

ALTER TABLE Final_energy_consumption_2020 
ALTER COLUMN Bioenergy_and_wastes_Total FLOAT;

-- =======================================================
-- Step 9: Final Data Verification
-- =======================================================
-- After completing cleaning columns let's check if everything is correct.

SELECT TOP 10 * FROM Final_energy_consumption_2020;

use UK_ENERGY
exec sp_columns Final_energy_consumption_2020;


-- =======================================================
-- Step 10: Transfer Cleaned Data into `EnergyConsumption` Table
-- =======================================================
-- Before transferring, first we have to change all numeric column from varchar to float in EnergyConsumption table

ALTER TABLE EnergyConsumption ALTER COLUMN All_fuels_Domestic FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN All_fuels_Transport FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN All_fuels_Industrial_Commercial_and_other FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN All_fuels_Total FLOAT;

ALTER TABLE EnergyConsumption ALTER COLUMN Coal_Industrial FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Coal_Commercial FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Coal_Domestic FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Coal_Rail FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Coal_Public_sector FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Coal_Agriculture FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Coal_Total FLOAT;

ALTER TABLE EnergyConsumption ALTER COLUMN Manufactured_fuels_Industrial FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Manufactured_fuels_Domestic FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Manufactured_fuels_Total FLOAT;

ALTER TABLE EnergyConsumption ALTER COLUMN Petroleum_Industrial FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Petroleum_Commercial FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Petroleum_Domestic FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Petroleum_Road_transport FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Petroleum_Rail FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Petroleum_Public_sector FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Petroleum_Agriculture FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Petroleum_Total FLOAT;

ALTER TABLE EnergyConsumption ALTER COLUMN Gas_Domestic FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Gas_Industrial_Commercial_and_other FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Gas_Total FLOAT;

ALTER TABLE EnergyConsumption ALTER COLUMN Electricity_Domestic FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Electricity_Industrial_Commercial_and_other FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Electricity_Total FLOAT;

ALTER TABLE EnergyConsumption ALTER COLUMN Bioenergy_and_wastes_Domestic FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Bioenergy_and_wastes_Road_transport FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Bioenergy_and_wastes_Industrial_and_Commercial FLOAT;
ALTER TABLE EnergyConsumption ALTER COLUMN Bioenergy_and_wastes_Total FLOAT;

--Checking the table structure 

EXEC sp_columns EnergyConsumption;

-- Now, we insert the cleaned data into EnergyConsumption

INSERT INTO EnergyConsumption (
    Year, Region, LA, 
    All_fuels_Domestic, All_fuels_Transport, All_fuels_Industrial_Commercial_and_other, All_fuels_Total,
    Coal_Industrial, Coal_Commercial, Coal_Domestic, Coal_Rail, Coal_Public_sector, Coal_Agriculture, Coal_Total,
    Manufactured_fuels_Industrial, Manufactured_fuels_Domestic, Manufactured_fuels_Total,
    Petroleum_Industrial, Petroleum_Commercial, Petroleum_Domestic, Petroleum_Road_transport, Petroleum_Rail, 
    Petroleum_Public_sector, Petroleum_Agriculture, Petroleum_Total,
    Gas_Domestic, Gas_Industrial_Commercial_and_other, Gas_Total,
    Electricity_Domestic, Electricity_Industrial_Commercial_and_other, Electricity_Total,
    Bioenergy_and_wastes_Domestic, Bioenergy_and_wastes_Road_transport, 
    Bioenergy_and_wastes_Industrial_and_Commercial, Bioenergy_and_wastes_Total
)
SELECT 
    Year, Region, LA, 
    All_fuels_Domestic, All_fuels_Transport, All_fuels_Industrial_Commercial_and_other, All_fuels_Total,
    Coal_Industrial, Coal_Commercial, Coal_Domestic, Coal_Rail, Coal_Public_sector, Coal_Agriculture, Coal_Total,
    Manufactured_fuels_Industrial, Manufactured_fuels_Domestic, Manufactured_fuels_Total,
    Petroleum_Industrial, Petroleum_Commercial, Petroleum_Domestic, Petroleum_Road_transport, Petroleum_Rail, 
    Petroleum_Public_sector, Petroleum_Agriculture, Petroleum_Total,
    Gas_Domestic, Gas_Industrial_Commercial_and_other, Gas_Total,
    Electricity_Domestic, Electricity_Industrial_Commercial_and_other, Electricty_Total,
    Bioenergy_and_wastes_Domestic, Bioenergy_and_wastes_Road_transport, 
    Bioenergy_and_wastes_Industrial_and_Commercial, Bioenergy_and_wastes_Total
FROM Final_energy_consumption_2020;

--verifying that the transfer is successful.
SELECT TOP 10 * FROM EnergyConsumption;


-- **Data Preprocessing Completed Successfully!**

-- The dataset is now cleaned and structured correctly.
-- We can now proceed to Exploratory Data Analysis (EDA) and visualization in Power BI.

-- =======================================================
-- **Exploratory Data Analysis(EDA)**
-- =======================================================
-- Objective: Analyze trends, distributions, and regional differences 
--            in energy consumption for better insights before visualization.


--1. Yearly Total Energy Consumption Trend
-- Shows the change in national energy use over time.
SELECT Year, SUM(All_fuels_Total) AS Total_Energy_Consumption
FROM EnergyConsumption
GROUP BY Year
ORDER BY Year;

--2. Energy Consumption by Fuel Type Over Time
-- Breaks down fuel categories by year for trend comparison.
SELECT Year, 
       SUM(Coal_Total) AS Coal_Consumption,
       SUM(Petroleum_Total) AS Petroleum_Consumption,
       SUM(Gas_Total) AS Gas_Consumption,
       SUM(Electricity_Total) AS Electricity_Consumption,
       SUM(Bioenergy_and_wastes_Total) AS Bioenergy_Consumption
FROM EnergyConsumption
GROUP BY Year
ORDER BY Year;

--3. Top 10 Regions by Total Energy Consumption
-- Identifies the highest energy-consuming areas.
SELECT TOP 10 Region, SUM(All_fuels_Total) AS Total_Consumption
FROM EnergyConsumption
GROUP BY Region
ORDER BY Total_Consumption DESC;

--4. Yearly Energy Consumption by Region
-- Shows which regions consumed the most energy each year
SELECT Year, Region, SUM(All_fuels_Total) AS Total_Energy
FROM EnergyConsumption
GROUP BY Year, Region
ORDER BY Year, Total_Energy DESC;

--5. Sector-wise Energy Consumption Over Time
-- Visualizes energy usage patterns across domestic, transport, and industrial sectors. 
SELECT Year, 
       SUM(All_fuels_Domestic) AS Domestic_Consumption,
       SUM(All_fuels_Transport) AS Transport_Consumption,
       SUM(All_fuels_Industrial_Commercial_and_other) AS Industrial_Consumption
FROM EnergyConsumption
GROUP BY Year
ORDER BY Year;

-- =======================================================
-- Descriptive Statistical Summary
-- ======================================================= 
-- Get basic statistical insights (min, max, avg, std dev) 
-- for each major fuel type and total energy. These values help understand before applying Power BI and ML models.

--1 Summary Statistics of Total Energy Consumption
SELECT 
    MIN(All_fuels_Total) AS Min_Total_Consumption,
    MAX(All_fuels_Total) AS Max_Total_Consumption,
    AVG(All_fuels_Total) AS Avg_Total_Consumption,
    STDEV(All_fuels_Total) AS StdDev_Total_Consumption
FROM EnergyConsumption
WHERE All_fuels_Total IS NOT NULL;

--2 Summary Statistics of Coal Consumption
SELECT 
    MIN(Coal_Total) AS Min_Coal,
    MAX(Coal_Total) AS Max_Coal,
    AVG(Coal_Total) AS Avg_Coal,
    STDEV(Coal_Total) AS StdDev_Coal
FROM EnergyConsumption
WHERE Coal_Total IS NOT NULL;

--3 Summary Statistics of Gas Consumption
SELECT 
    MIN(Gas_Total) AS Min_Gas,
    MAX(Gas_Total) AS Max_Gas,
    AVG(Gas_Total) AS Avg_Gas,
    STDEV(Gas_Total) AS StdDev_Gas
FROM EnergyConsumption
WHERE Gas_Total IS NOT NULL;

--4 Summary Statistics of Electricity Consumption
SELECT 
    MIN(Electricity_Total) AS Min_Electricity,
    MAX(Electricity_Total) AS Max_Electricity,
    AVG(Electricity_Total) AS Avg_Electricity,
    STDEV(Electricity_Total) AS StdDev_Electricity
FROM EnergyConsumption
WHERE Electricity_Total IS NOT NULL;

--5 Summary Statistics of Petroleum Consumption
SELECT 
    MIN(Petroleum_Total) AS Min_Petroleum,
    MAX(Petroleum_Total) AS Max_Petroleum,
    AVG(Petroleum_Total) AS Avg_Petroleum,
    STDEV(Petroleum_Total) AS StdDev_Petroleum
FROM EnergyConsumption
WHERE Petroleum_Total IS NOT NULL;

--6 Summary Statistics of Bioenergy Consumption
SELECT 
    MIN(Bioenergy_and_wastes_Total) AS Min_Bioenergy,
    MAX(Bioenergy_and_wastes_Total) AS Max_Bioenergy,
    AVG(Bioenergy_and_wastes_Total) AS Avg_Bioenergy,
    STDEV(Bioenergy_and_wastes_Total) AS StdDev_Bioenergy
FROM EnergyConsumption
WHERE Bioenergy_and_wastes_Total IS NOT NULL;

-- =======================================================
-- Correlation Analysis Between Fuel Types
-- =======================================================
-- Objective: Analyze the relationship between different fuel types 
-- using Pearson correlation formula. This helps understand how 
-- consumption patterns of one fuel relate to others.

--1 Correlations of Coal vs Gas 
-- Analyzing whether regions/years with high coal usage also use high gas.
SELECT 
    (SUM(CAST(Coal_Total AS FLOAT) * CAST(Gas_Total AS FLOAT)) 
     - (SUM(CAST(Coal_Total AS FLOAT)) * SUM(CAST(Gas_Total AS FLOAT)) / COUNT(*))) /
    (SQRT(SUM(CAST(Coal_Total AS FLOAT) * CAST(Coal_Total AS FLOAT)) 
     - (SUM(CAST(Coal_Total AS FLOAT)) * SUM(CAST(Coal_Total AS FLOAT)) / COUNT(*))) *
     SQRT(SUM(CAST(Gas_Total AS FLOAT) * CAST(Gas_Total AS FLOAT)) 
     - (SUM(CAST(Gas_Total AS FLOAT)) * SUM(CAST(Gas_Total AS FLOAT)) / COUNT(*)))
    ) AS Coal_Gas_Correlation
FROM EnergyConsumption;

--2 Correlation of Coal vs Electricity
-- Helps check if coal use impacts electricity usage (e.g., power plants)
SELECT 
    (SUM(CAST(Coal_Total AS FLOAT) * CAST(Electricity_Total AS FLOAT)) 
     - (SUM(CAST(Coal_Total AS FLOAT)) * SUM(CAST(Electricity_Total AS FLOAT)) / COUNT(*))) /
    (SQRT(SUM(CAST(Coal_Total AS FLOAT) * CAST(Coal_Total AS FLOAT)) 
     - (SUM(CAST(Coal_Total AS FLOAT)) * SUM(CAST(Coal_Total AS FLOAT)) / COUNT(*))) *
     SQRT(SUM(CAST(Electricity_Total AS FLOAT) * CAST(Electricity_Total AS FLOAT)) 
     - (SUM(CAST(Electricity_Total AS FLOAT)) * SUM(CAST(Electricity_Total AS FLOAT)) / COUNT(*)))
    ) AS Coal_Electricity_Correlation
FROM EnergyConsumption;

--3 Correlation of Gas vs Electricity
-- Checking if gas-heavy regions also consume more electricity.
SELECT 
    (SUM(CAST(Gas_Total AS FLOAT) * CAST(Electricity_Total AS FLOAT)) 
     - (SUM(CAST(Gas_Total AS FLOAT)) * SUM(CAST(Electricity_Total AS FLOAT)) / COUNT(*))) /
    (SQRT(SUM(CAST(Gas_Total AS FLOAT) * CAST(Gas_Total AS FLOAT)) 
     - (SUM(CAST(Gas_Total AS FLOAT)) * SUM(CAST(Gas_Total AS FLOAT)) / COUNT(*))) *
     SQRT(SUM(CAST(Electricity_Total AS FLOAT) * CAST(Electricity_Total AS FLOAT)) 
     - (SUM(CAST(Electricity_Total AS FLOAT)) * SUM(CAST(Electricity_Total AS FLOAT)) / COUNT(*)))
    ) AS Gas_Electricity_Correlation
FROM EnergyConsumption;

--4 Correlation of Petroleum vs Bioenergy
-- This explores if petroleum and bioenergy are used together or as alternatives.
SELECT 
    (SUM(CAST(Petroleum_Total AS FLOAT) * CAST(Bioenergy_and_wastes_Total AS FLOAT)) 
     - (SUM(CAST(Petroleum_Total AS FLOAT)) * SUM(CAST(Bioenergy_and_wastes_Total AS FLOAT)) / COUNT(*))) /
    (SQRT(SUM(CAST(Petroleum_Total AS FLOAT) * CAST(Petroleum_Total AS FLOAT)) 
     - (SUM(CAST(Petroleum_Total AS FLOAT)) * SUM(CAST(Petroleum_Total AS FLOAT)) / COUNT(*))) *
     SQRT(SUM(CAST(Bioenergy_and_wastes_Total AS FLOAT) * CAST(Bioenergy_and_wastes_Total AS FLOAT)) 
     - (SUM(CAST(Bioenergy_and_wastes_Total AS FLOAT)) * SUM(CAST(Bioenergy_and_wastes_Total AS FLOAT)) / COUNT(*)))
    ) AS Petroleum_Bioenergy_Correlation
FROM EnergyConsumption;

-- =======================================================
-- Average Energy Consumption by Region
-- =======================================================
-- Find out which regions, on average, consume the most energy.
-- This is helpful to rank regions based on their long-term demand.
SELECT Region, AVG(All_fuels_Total) AS Avg_Energy_Consumption
FROM EnergyConsumption
GROUP BY Region
ORDER BY Avg_Energy_Consumption DESC;

-- =======================================================
-- Top 5 Years by Total Energy Consumption
-- =======================================================
-- Identify the years where overall UK energy consumption was highest.
-- Helps reveal peak demand periods or major energy usage trends.
SELECT TOP 5 Year, SUM(All_fuels_Total) AS Total_Consumption
FROM EnergyConsumption
GROUP BY Year
ORDER BY Total_Consumption DESC;

-- =======================================================
-- Step 6: Identify NULL or Zero Energy Consumption Records
-- =======================================================
-- Detect rows where energy data is missing or zero.
SELECT * FROM EnergyConsumption
WHERE All_fuels_Total IS NULL OR All_fuels_Total <= 0;



