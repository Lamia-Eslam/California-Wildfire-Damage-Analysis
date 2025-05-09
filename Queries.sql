USE california --Our database
GO
-- data exploring
SELECT * FROM raw --raw data file

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

--Business Questions:
--1. Temporal Analysis:

-- What is the range of years we are analysing?
SELECT MIN(year) AS Start_Year, MAX(year) AS End_Year FROM raw

-- What are the specific locations in California we are analyzing?
SELECT DISTINCT Location FROM raw

-- incidents over years
SELECT year, COUNT(*) AS num_of_incidents
FROM raw
GROUP BY year
ORDER BY year; -- ASC is the default

-- financial_loss over years
SELECT year, SUM(Estimated_Financial_Loss_Million) AS Financial_loss_in_millions
FROM raw
GROUP BY year
ORDER BY year;

-- homes_destroyed over years
SELECT year, SUM(Homes_Destroyed) AS Homes_Destroyed
FROM raw
GROUP BY year
ORDER BY year;

-- Businesses_destroyed over years
SELECT year, SUM(Businesses_Destroyed) AS Businesses_Destroyed
FROM raw
GROUP BY year
ORDER BY year;

-- Area_burnt over years
SELECT year, SUM(Area_Burned_Acres) AS Area_Burned_Acres
FROM raw
GROUP BY year
ORDER BY year;

--2. Geographical Impact

--Which counties experience the highest number of wildfire incidents?
SELECT Location, COUNT(Incident_ID) AS number_of_incidents
FROM raw
GROUP BY Location
ORDER BY number_of_incidents DESC

--Which counties suffer the most damage in terms of area burned?
SELECT Location, SUM(Area_Burned_Acres) AS Area_Burned_Acres
FROM raw
GROUP BY Location
ORDER BY Area_Burned_Acres DESC

--How do financial losses vary across different counties?
SELECT Location, SUM(Estimated_Financial_Loss_Million) AS Financial_Loss_Million
FROM raw
GROUP BY Location
ORDER BY Financial_Loss_Million DESC

--What is the geographical distribution of injuries caused by wildfires?
SELECT Location, SUM(Injuries) AS Injuries
FROM raw
GROUP BY Location
ORDER BY Injuries DESC

--What is the geographical distribution of fatalities caused by wildfires?
SELECT Location, SUM(Fatalities) AS Fatalities
FROM raw
GROUP BY Location
ORDER BY Fatalities DESC

--How many homes are destroyed in each location?
SELECT Location, SUM(Homes_Destroyed) AS Homes_Destroyed
FROM raw
GROUP BY Location
ORDER BY Homes_Destroyed DESC

--How many vehicles are damaged in each location?
SELECT Location, SUM(Vehicles_Damaged) AS Vehicles_Damaged
FROM raw
GROUP BY Location
ORDER BY Vehicles_Damaged DESC

--3. Geographical Impact over time

-- injuries per counties over years
SELECT year, Location, SUM(Injuries) AS injuries
FROM raw
GROUP BY year, Location

-- fatalities per counties over years
SELECT year, Location, SUM(Fatalities) AS Fatalities
FROM raw
GROUP BY year, Location

-- Businesses_Destroyed per counties over years
SELECT year, Location, SUM(Businesses_Destroyed) AS Businesses_Destroyed
FROM raw
GROUP BY year, Location

-- homes_Destroyed per counties over years
SELECT year, Location, SUM(Homes_Destroyed) AS Homes_Destroyed
FROM raw
GROUP BY year, Location

-- area_burnt per counties over years
SELECT year, Location, SUM(Area_Burned_Acres) AS Area_Burned_Acres
FROM raw
GROUP BY year, Location

-- top 5 locations per area_burnt
SELECT TOP 5 Location, SUM(Area_Burned_Acres) AS Area_Burned_Acres FROM raw
GROUP BY Location
ORDER BY Area_Burned_Acres DESC

--4. Cause Analysis

--What is the relationship between the cause of a wildfire and the Financial Loss?
SELECT Cause, SUM(Estimated_Financial_Loss_Million) AS Financial_Loss_Million
FROM raw
GROUP BY Cause
ORDER BY Financial_Loss_Million DESC

--What is the relationship between the cause of a wildfire and the area burned?
SELECT Cause, SUM(Area_Burned_Acres) AS Area_Burned_Acres
FROM raw
GROUP BY Cause
ORDER BY Area_Burned_Acres DESC

--How does the cause of a wildfire impact the number of homes destroyed?
SELECT Cause, SUM(Homes_Destroyed) AS Homes_Destroyed
FROM raw
GROUP BY Cause
ORDER BY Homes_Destroyed DESC

--How does the cause of a wildfire impact the number of businesses destroyed?
SELECT Cause, SUM(Businesses_Destroyed) AS Businesses_Destroyed
FROM raw
GROUP BY Cause
ORDER BY Businesses_Destroyed DESC

--How does the cause of a wildfire impact the number of vehicles damaged?
SELECT Cause, SUM(Vehicles_Damaged) AS Vehicles_Damaged
FROM raw
GROUP BY Cause
ORDER BY Vehicles_Damaged DESC

--How does the cause of a wildfire impact the number of injuries?
SELECT Cause, SUM(Injuries) AS Injuries
FROM raw
GROUP BY Cause
ORDER BY Injuries DESC

--How does the cause of a wildfire impact the number of fatalities?
SELECT Cause, SUM(Fatalities) AS fatalities
FROM raw
GROUP BY Cause
ORDER BY fatalities DESC

--5. Cause Analysis over locations

--How do homes destroyed vary by location and cause?
SELECT Location, Cause, SUM(Homes_Destroyed) AS Homes_Destroyed
FROM raw
GROUP BY Cause, Location
ORDER BY Location ASC, Homes_Destroyed DESC

--How do fatalities vary by location and cause?
SELECT Location, Cause, SUM(Fatalities) AS Fatalities
FROM raw
GROUP BY Cause, Location
ORDER BY Location ASC, Fatalities DESC

--How do financial losses vary by the cause of the wildfire?
SELECT Location, Cause, SUM(Estimated_Financial_Loss_Million) AS Financial_Loss_Million
FROM raw
GROUP BY Cause, Location
ORDER BY Location ASC, Financial_Loss_Million DESC

--How do injuries vary by location and cause?
SELECT Location, Cause, SUM(Injuries) AS Injuries
FROM raw
GROUP BY Cause, Location
ORDER BY Location ASC, Injuries DESC

--How do businesses destroyed vary by location and cause?
SELECT Location, Cause, SUM(Businesses_Destroyed) AS Businesses_Destroyed
FROM raw
GROUP BY Cause, Location
ORDER BY Location ASC, Businesses_Destroyed DESC

--How do vehicles damaged vary by location and cause?
SELECT Location, Cause, SUM(Vehicles_Damaged) AS Vehicles_Damaged
FROM raw
GROUP BY Cause, Location
ORDER BY Location ASC, Vehicles_Damaged DESC


--5. Seasonal Trends

--How do wildfire incidents vary by season?
SELECT season, COUNT(Incident_ID) AS Incident_Count
FROM raw
GROUP BY season
ORDER BY Incident_Count DESC

--How do different wildfire causes contribute to seasonal incident counts?
SELECT Cause, Season, COUNT(Incident_ID) AS Incident_Count
FROM raw
GROUP BY Cause, Season
ORDER BY Cause ASC, Incident_Count DESC

--What is the seasonal distribution of wildfire-related fatalities by cause?
SELECT Cause, Season, SUM(Fatalities) AS Total_Fatalities 
FROM raw
GROUP BY Cause, Season
ORDER BY Cause ASC, Total_Fatalities DESC

--How do injuries caused by wildfires vary by season and cause?
SELECT Cause, Season, SUM(Injuries) AS Total_Injuries
FROM raw
GROUP BY Cause, Season
ORDER BY Cause ASC, Total_Injuries DESC

--How do homes destroyed by wildfires vary by season and cause?
SELECT Cause, Season, SUM(Homes_Destroyed) AS Total_Homes
FROM raw
GROUP BY Cause, Season
ORDER BY Cause ASC, Total_Homes DESC

--How do businesses destroyed by wildfires vary by season and cause?
SELECT Cause, Season, SUM(Businesses_Destroyed) AS Total_Businesses_Destroyed
FROM raw
GROUP BY Cause, Season
ORDER BY Cause ASC, Total_Businesses_Destroyed DESC

--How do financial losses caused by wildfires vary by season and cause?
SELECT Cause, Season, SUM(Estimated_Financial_Loss_Million) AS Total_Financial_Loss
FROM raw
GROUP BY Cause, Season
ORDER BY Cause ASC, Total_Financial_Loss DESC

--5. Relationships Between Metrics

--How does the area burned change over time across different locations?
SELECT year, location, SUM(Area_Burned_Acres) AS Area_Burned_Acres
FROM raw
GROUP BY year, Location
ORDER BY year, Location

--How does the number of injuries change over time by location?
SELECT year, Location, SUM(Injuries) AS total_injuries
FROM raw
GROUP BY year, Location
ORDER BY year, Location

--How does fatalities change over time by location?
SELECT year, Location, SUM(Fatalities) AS fatalities
FROM raw
GROUP BY year, Location
ORDER BY year, Location

--How does financial loss vary by time and location?
SELECT year, Location, SUM(Estimated_Financial_Loss_Million) AS Financial_Loss_Million
FROM raw
GROUP BY year, Location
ORDER BY year, Location

--How does the number of businesses destroyed change over the years by location?
SELECT year, Location, SUM(businesses_destroyed) AS total_businesses_destroyed
FROM raw
GROUP BY year, Location
ORDER BY year, Location

--How does the number of fatalities correlate with the number of homes destroyed by location?
SELECT Location, SUM(Fatalities) AS total_fatalities, SUM(Homes_Destroyed) AS homes_destroyed
FROM raw
GROUP BY Location
ORDER BY total_fatalities DESC

--How do injuries correlate with the number of homes destroyed by location?
SELECT Location, SUM(Injuries) AS total_injuries, SUM(Homes_Destroyed) AS total_homes_destroyed
FROM raw
GROUP BY Location
ORDER BY total_injuries DESC

--What is the relationship between businesses destroyed and fatalities by location?
SELECT Location, SUM(Businesses_Destroyed) AS total_businesses_destroyed, SUM(Fatalities) AS total_fatalities
FROM raw
GROUP BY Location
ORDER BY total_businesses_destroyed DESC

--What is the relationship between financial loss and businesses destroyed by location?
SELECT location, SUM(Estimated_Financial_Loss_Million) AS total_loss, SUM(Businesses_Destroyed) AS total_businesses_destroyed
FROM raw
GROUP BY location
ORDER BY total_loss DESC

--What is the relationship between financial loss and area burned by location?
SELECT location, SUM(Estimated_Financial_Loss_Million) AS total_loss, SUM(Area_Burned_Acres) AS total_burned_area
FROM raw
GROUP BY location
ORDER BY total_loss DESC

--What is the relationship between financial loss and homes destroyed by location?
SELECT location, SUM(Estimated_Financial_Loss_Million) AS total_loss, SUM(Homes_Destroyed) AS total_homes_destroyed
FROM raw
GROUP BY location
ORDER BY total_loss DESC

--What is the relationship between financial loss and vehicles damaged by location?
SELECT location, SUM(Estimated_Financial_Loss_Million) AS total_loss, SUM(Vehicles_Damaged) AS total_vehicles_damaged
FROM raw
GROUP BY location
ORDER BY total_loss DESC
