USE california

-- data exploring
SELECT * FROM raw --raw data

SELECT 
    MIN(Area_Burned_Acres) AS Min_Area, 
    MAX(Area_Burned_Acres) AS Max_Area, 
    AVG(Area_Burned_Acres) AS Avg_Area
    FROM raw

--checking for duplicates
SELECT Incident_ID, COUNT(*) AS Duplicate_Count
FROM raw
GROUP BY Incident_ID
HAVING COUNT(*) > 1; --returns zero rows (no duplicates)

-- adding new columns for year, month, day
ALTER TABLE raw 
ADD year INT, 
    month INT, 
    day INT

UPDATE raw 
SET 
    year = YEAR(date),
    month = MONTH(date),
    day = DAY(date)

ALTER TABLE raw 
ADD Season VARCHAR(10);

UPDATE raw
SET Season =
    CASE 
        WHEN (month = 12 AND day >= 21) OR (month IN (1, 2)) OR (month = 3 AND day < 20) THEN 'Winter'
        WHEN (month = 3 AND day >= 20) OR (month IN (4, 5)) OR (month = 6 AND day < 21) THEN 'Spring'
        WHEN (month = 6 AND day >= 21) OR (month IN (7, 8)) OR (month = 9 AND day < 23) THEN 'Summer'
        ELSE 'Fall'
    END

SELECT * FROM raw  --Changes done


-- Get range of years analyzed
SELECT MIN(year) AS Start_Year, MAX(year) AS End_Year FROM raw

-- Unique locations in California analyzed
SELECT DISTINCT Location FROM raw

-- Unique causes in California analyzed
SELECT DISTINCT Cause FROM raw

-- Temporal analysis
SELECT
    year,
    COUNT(*) AS num_of_incidents,
    SUM(Estimated_Financial_Loss_Million) AS Financial_Loss_Million,
    SUM(Homes_Destroyed) AS Homes_Destroyed,
    SUM(Businesses_Destroyed) AS Businesses_Destroyed,
    SUM(Area_Burned_Acres) AS Area_Burned_Acres
FROM raw
GROUP BY year
ORDER BY year

-- Geographical impact
SELECT 
    Location, 
    COUNT(Incident_ID) AS number_of_incidents,
    SUM(Area_Burned_Acres) AS Area_Burned_Acres,
    SUM(Estimated_Financial_Loss_Million) AS Financial_Loss_Million,
    SUM(Injuries) AS Injuries,
    SUM(Fatalities) AS Fatalities,
    SUM(Homes_Destroyed) AS Homes_Destroyed,
    SUM(Vehicles_Damaged) AS Vehicles_Damaged,
	SUM(Businesses_Destroyed) AS total_businesses_destroyed
FROM raw
GROUP BY Location
ORDER BY number_of_incidents DESC

-- Geographical impact over time
SELECT
    year, Location, 
    SUM(Injuries) AS injuries, 
    SUM(Fatalities) AS Fatalities, 
    SUM(Businesses_Destroyed) AS Businesses_Destroyed,
    SUM(Homes_Destroyed) AS Homes_Destroyed,
    SUM(Area_Burned_Acres) AS Area_Burned_Acres
FROM raw
GROUP BY year, Location
ORDER BY year, Location

-- Top 5 locations by area burned
SELECT TOP 5 Location, SUM(Area_Burned_Acres) AS Area_Burned_Acres 
FROM raw
GROUP BY Location
ORDER BY Area_Burned_Acres DESC

-- Cause analysis
SELECT 
    Cause, 
    SUM(Estimated_Financial_Loss_Million) AS Financial_Loss_Million,
    SUM(Area_Burned_Acres) AS Area_Burned_Acres,
    SUM(Homes_Destroyed) AS Homes_Destroyed,
    SUM(Businesses_Destroyed) AS Businesses_Destroyed,
    SUM(Vehicles_Damaged) AS Vehicles_Damaged,
    SUM(Injuries) AS Injuries,
    SUM(Fatalities) AS Fatalities
FROM raw
GROUP BY Cause
ORDER BY Financial_Loss_Million DESC

-- Cause analysis by location
SELECT
    Location, Cause, 
    SUM(Homes_Destroyed) AS Homes_Destroyed,
    SUM(Fatalities) AS Fatalities,
    SUM(Estimated_Financial_Loss_Million) AS Financial_Loss_Million,
    SUM(Injuries) AS Injuries,
    SUM(Businesses_Destroyed) AS Businesses_Destroyed,
    SUM(Vehicles_Damaged) AS Vehicles_Damaged
FROM raw
GROUP BY Cause, Location
ORDER BY Location ASC, Financial_Loss_Million DESC

-- Seasonal trends
SELECT 
    Season, 
    COUNT(Incident_ID) AS Incident_Count,
    SUM(Fatalities) AS Total_Fatalities,
    SUM(Injuries) AS Total_Injuries,
    SUM(Homes_Destroyed) AS Total_Homes_Destroyed,
    SUM(Businesses_Destroyed) AS Total_Businesses_Destroyed,
    SUM(Estimated_Financial_Loss_Million) AS Total_Financial_Loss
FROM raw
GROUP BY Season
ORDER BY Incident_Count DESC
