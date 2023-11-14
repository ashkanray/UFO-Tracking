-- This file will create an ORC table with flight ontime arrival data

-- First, map the CSV data we downloaded in Hive

DROP TABLE IF EXISTS arohani_ufo_csv;
create external table arohani_ufo_csv(
  Occurred date,
  City string,
  State string,
  Country string,
  Shape string,
  Summary string,
  Reported string,
  Posted string,
  Year bigint,
  Month tinyint,
  Day tinyint)
  row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'

WITH SERDEPROPERTIES (
   "separatorChar" = "\,",
   "quoteChar"     = "\""
)
STORED AS TEXTFILE
  location '/arohani/project/ufo';


-- Create an ORC table for ontime data (Note "stored as ORC" at the end)
DROP TABLE IF EXISTS arohani_ufo;
create table arohani_ufo(
  Occurred date,
  City string,
  State string,
  Country string,
  Shape string,
  Summary string,
  Reported string,
  Posted string,
  Year bigint,
  Month tinyint,
  Day tinyint)
  stored as orc;

-- Copy the CSV table to the ORC table
insert overwrite table arohani_ufo 
select * from arohani_ufo_csv
where NOT (Country IS NULL OR State = '-' OR City = '');
