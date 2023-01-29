-- CREATE DATABASE project_2;
USE project_2;

# import raw tables from csv
# inpect raw tables & prepare for clean up 
SELECT * FROM air_pollution_raw;
SELECT * FROM biodiversity_raw;
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
			-- WHEN 'Argentina' THEN 'ARG'
			WHEN 'Australia' THEN 'AUS'
            -- when 'BRIICS economies - Brazil, Russia, India, Indonesia, China and South Africa' then 
            WHEN 'Canada' THEN 'CAN'
			WHEN 'France' THEN 'FRA'
            WHEN 'Germany' THEN 'DEU'
			WHEN 'Italy' THEN 'ITA'
            WHEN 'Japan' THEN 'JPN'
            WHEN 'Mexico' THEN 'MEX'
            WHEN 'Korea' THEN 'KOR'
            -- WHEN 'Russia' THEN 'RUS'
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


##### VEGETATION GAIN / LOSS TABLE #####

DROP TABLE vege_gain;
CREATE TABLE IF NOT EXISTS vege_gain
SELECT LOCATION AS location,
	   TIME AS year,
       Value AS value
FROM biodiversity_raw
WHERE (TIME = 2019)
AND location IN ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
AND subject = 'VEGEGAIN2004';


DROP TABLE vege_loss;
CREATE TABLE IF NOT EXISTS vege_loss
SELECT LOCATION AS location,
	   TIME AS year,
       Value AS value
FROM biodiversity_raw
WHERE (TIME = 2019)
AND location IN ('AUS' , 'CAN' , 'FRA' , 'DEU' , 'ITA' , 'JPN' , 'MEX' ,'KOR','TUR','GBR','USA')
AND subject = 'VEGELOSS2004';


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
select * from vege_gain order by 1; 
select * from vege_loss order by 1;
# for air_pollution, elec_output, env_pol we have data of 11 countries throughout 11 years
# for two vege tables , only yearly record for each of the 11 countries



######################################
############ BUILD QUERY #############
######################################
-- fir combine all tables without aggregation
WITH combination AS
(
SELECT ap.location, 
	   ap.year,
       COALESCE(ap.mortality_rate,0) AS ap_mortality,
	   COALESCE(eo.value,0) AS elec_output,
	   COALESCE(vg.value,0) AS vege_gain,
	   COALESCE(vl.value,0) AS vege_loss,
       COALESCE(ep.value,0) AS env_patents
FROM air_pollution ap
LEFT JOIN vege_gain vg
	ON ap.location = vg.location 
LEFT JOIN vege_loss vl
	ON vl.location = ap.location 
LEFT JOIN elec_output eo
	ON eo.location = ap.location 
    AND eo.year = ap.year
LEFT JOIN env_pol ep
	ON ep.location = ap.location 
    AND ep.year = ap.year
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
 MIN(vege_gain) AS vege_gain_min,
 MAX(vege_gain) AS vege_gain_max,
 MIN(vege_loss) AS vege_loss_min,
 MAX(vege_loss) AS vege_loss_max
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
vege_gain,
vege_gain_max,
vege_gain_min,
(vege_gain - vege_gain_min) / (vege_gain_max - vege_gain_min) AS vege_gain_index,
vege_loss,
vege_loss_max,
vege_loss_min,
(vege_loss - vege_loss_min) / (vege_loss_max - vege_loss_min) AS vege_loss_index
FROM combination c
LEFT JOIN min_max mm
	ON c.year = mm.year
    )
    

-- get columns needed and add total index
SELECT location,
	   year,
       ROUND(air_poll_mort_index,2) AS air_poll_mort_index,
       ROUND(elec_output_index,2) AS elec_output_index ,
       ROUND(env_patents_index,2) AS env_patents_index,
       ROUND(vege_gain_index,2) AS vege_gain_index,
       ROUND(vege_loss_index,2) AS vege_loss_index,
	   ROUND((air_poll_mort_index + elec_output_index + env_patents_index + vege_gain_index + vege_loss_index) / 5 ,2) AS total_index
FROM final;

    
