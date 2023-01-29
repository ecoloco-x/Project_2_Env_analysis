-- CREATE DATABASE project_2;
USE project_2;

# import raw tables from csv
# inpect raw tables & prepare for clean up 
SELECT * FROM air_pollution_raw;
SELECT * FROM protected_areas_raw;
SELECT * FROM energy_raw;
SELECT * FROM environmental_policy_raw;

# define timespan & countries
# 2005 - 2015
# 11 countries from G20 with that have complete data


/*------------------------------------------*/
# create corresponding clean tables for analylsis
/*------------------------------------------*/

##### AIR POLLUTION TABLE #####

# clean up country code in raw table
# add new col for country_code
ALTER TABLE air_pollution_raw
ADD COLUMN country_code VARCHAR(255);

# convert country name to code for G20 countries

UPDATE air_pollution_raw
SET country_code =  CASE country
			WHEN 'Argentina' THEN 'ARG'
			WHEN 'Australia' THEN 'AUS'
            -- when 'BRIICS economies - Brazil, Russia, India, Indonesia, China and South Africa' then 
            WHEN 'Canada' THEN 'CAN'
			WHEN 'France' THEN 'FRA'
            WHEN 'Germany' THEN 'DEU'
			WHEN 'Italy' THEN 'ITA'
            WHEN 'Japan' THEN 'JPN'
            WHEN 'Mexico' THEN 'MEX'
            WHEN 'Korea' THEN 'KOR'
			WHEN 'Russia' THEN 'RUS'
            WHEN 'T?kiye' THEN 'TUR'
            WHEN 'United Kingdom' THEN 'GBR'
            WHEN 'United States' THEN 'USA'
            ELSE country
            END;
	
# create new table with country code and transposed format
DROP TABLE air_pollution;
CREATE TABLE IF NOT EXISTS air_pollution
SELECT country_code AS location, '2005' AS year,  REPLACE(`2005`,',','.') AS mortality_rate FROM air_pollution_raw
WHERE country_code IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT country_code AS location, '2006' AS year,  REPLACE(`2006`,',','.') AS mortality_rate FROM air_pollution_raw
WHERE country_code IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT country_code AS location, '2007' AS year,  REPLACE(`2007`,',','.') AS mortality_rate FROM air_pollution_raw
WHERE country_code IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT country_code AS location, '2008' AS year,  REPLACE(`2008`,',','.') AS mortality_rate FROM air_pollution_raw
WHERE country_code IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT country_code AS location, '2009' AS year,  REPLACE(`2009`,',','.') AS mortality_rate FROM air_pollution_raw
WHERE country_code IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT country_code AS location, '2010' AS year,  REPLACE(`2010`,',','.') AS mortality_rate FROM air_pollution_raw
WHERE country_code IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT country_code AS location, '2011' AS year,  REPLACE(`2011`,',','.') AS mortality_rate FROM air_pollution_raw
WHERE country_code IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT country_code AS location, '2012' AS year,  REPLACE(`2012`,',','.') AS mortality_rate FROM air_pollution_raw
WHERE country_code IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT country_code AS location, '2013' AS year,  REPLACE(`2013`,',','.') AS mortality_rate FROM air_pollution_raw
WHERE country_code IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT country_code AS location, '2014' AS year,  REPLACE(`2014`,',','.') AS mortality_rate FROM air_pollution_raw
WHERE country_code IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT country_code AS location, '2015' AS year,  REPLACE(`2015`,',','.') AS mortality_rate FROM air_pollution_raw 
WHERE country_code IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA');


# convert string into values
ALTER TABLE air_pollution
MODIFY mortality_rate DOUBLE;


##### PROTECTED AREAS TABLE #####

DROP TABLE protected_areas;
CREATE TABLE IF NOT EXISTS protected_areas
SELECT COU AS location,
	   Year AS year,
       Value AS value
FROM protected_areas_raw
WHERE year >= 2005 and year <= 2015
AND COU IN ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA');


##### ENERGY TABLE #####

# remove the header row in csv file
DELETE FROM energy_raw WHERE economy = 'economy';

# create new table and transpose cols to rows
DROP TABLE elec_output;
CREATE TABLE IF NOT EXISTS elec_output
SELECT economy AS location, '2005' AS year, `2005` AS value FROM energy_raw
WHERE economy IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT economy AS location, '2006' AS year, `2006` AS value FROM energy_raw
WHERE economy IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT economy AS location, '2007' AS year, `2007` AS value FROM energy_raw
WHERE economy IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT economy AS location, '2008' AS year, `2008` AS value FROM energy_raw
WHERE economy IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT economy AS location, '2009' AS year, `2009` AS value FROM energy_raw
WHERE economy IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT economy AS location, '2010' AS year, `2010` AS value FROM energy_raw
WHERE economy IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT economy AS location, '2011' AS year, `2011` AS value FROM energy_raw
WHERE economy IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT economy AS location, '2012' AS year, `2012` AS value FROM energy_raw
WHERE economy IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT economy AS location, '2013' AS year, `2013` AS value FROM energy_raw
WHERE economy IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT economy AS location, '2014' AS year, `2014` AS value FROM energy_raw
WHERE economy IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
UNION ALL
SELECT economy AS location, '2015' AS year, `2015` AS value FROM energy_raw
WHERE economy IN  ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA');


##### ENVIRONMENTAL POLICY TABLE #####

DROP TABLE env_pol;
CREATE TABLE env_pol
SELECT location, time AS year, value FROM environmental_policy_raw
WHERE time >=2005 AND time <= 2015
AND location IN ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA');


# sanity check 
-- before combining tables, check available datapoints in each table
select location, count(*) from air_pollution
group by 1 order by 1;
select location, count(*) from elec_output
group by 1 order by 1;
select location, count(*) from env_pol
group by 1 order by 1;
select location, count(*) from protected_areas
group by 1 order by 1;

# since we have no data in protected_areas for Turkey, we will be analyzing 10 G20 countries during 2005 - 2015

######################################
############ BUILD QUERY #############
######################################

-- first combine all tables without aggregation
WITH combination AS
(
SELECT ap.location, 
	   ap.year,
       ap.mortality_rate AS ap_mortality,
	   eo.value AS elec_output,
	   pa.value AS protected_areas,
       ep.value AS env_patents
FROM air_pollution ap
LEFT JOIN protected_areas pa
	ON ap.location = pa.location
    AND ap.year = pa.year
LEFT JOIN elec_output eo
	ON eo.location = ap.location 
    AND eo.year = ap.year
LEFT JOIN env_pol ep
	ON ep.location = ap.location 
    AND ep.year = ap.year
WHERE ap.location IN ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','GBR','USA') -- remove turkey from the list
ORDER BY 2, 1
    ),

-- based on combined data, find yearly min and max value for each criteria
min_max AS (
SELECT year, 
 MIN(ap_mortality) AS ap_mort_min,
 MAX(ap_mortality) AS ap_mort_max,
 MIN(elec_output) AS elec_output_min, 
 MAX(elec_output) AS elec_output_max,
 MIN(env_patents) AS env_patents_min,
 MAX(env_patents) AS env_patents_max,
 MIN(protected_areas) AS protected_areas_min,
 MAX(protected_areas) AS protected_areas_max
FROM combination com
GROUP BY 1
)
 ,

-- join the two tables to have everything and calculate index
final AS (
SELECT 
location,
c.year,
ap_mortality,
ap_mort_max,
ap_mort_min,
(ap_mortality - ap_mort_min) / (ap_mort_max - ap_mort_min) AS air_poll_mort_index,
elec_output,
elec_output_max,
elec_output_min,
(elec_output - elec_output_min) / (elec_output_max - elec_output_min) AS elec_output_index,
env_patents,
env_patents_max,
env_patents_min,
(env_patents -env_patents_min) / (env_patents_max - env_patents_min) AS env_patents_index,
protected_areas,
protected_areas_max,
protected_areas_min,
(protected_areas - protected_areas_min) / (protected_areas_max - protected_areas_min) AS protected_areas_index,
(-(ap_mortality - ap_mort_min) / (ap_mort_max - ap_mort_min) * 0.2 + (elec_output - elec_output_min) / (elec_output_max - elec_output_min) * 0.4 + 
(env_patents -env_patents_min) / (env_patents_max - env_patents_min) * 0.2 + (protected_areas - protected_areas_min) / (protected_areas_max - protected_areas_min) * 0.2) AS total_index
FROM combination c
LEFT JOIN min_max mm
	ON c.year = mm.year
    ),

total_index_range AS 
(
SELECT year, 
    MIN(total_index) AS total_index_min,
    MAX(total_index) AS total_index_max 
    FROM final
		GROUP BY 1)
        
-- select * from total_index_range;
SELECT location,
	   f.year,
       ROUND(air_poll_mort_index,2) AS air_poll_mort_index,
       ROUND(elec_output_index,2) AS elec_output_index ,
       ROUND(env_patents_index,2) AS env_patents_index,
       ROUND(protected_areas_index,2) AS protected_areas_index,
	   ROUND((total_index - total_index_min) / (total_index_max - total_index_min),2) AS total_index_norm
FROM final f
LEFT JOIN total_index_range tir
	ON f.year = tir.year
       

;

    
