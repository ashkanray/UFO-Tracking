DROP TABLE IF EXISTS arohani_ufo_usa_city_year_ext;
create external table arohani_ufo_usa_city_year_ext (
  state_city_year string,
    Total_Sightings bigint)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, ufo:Total_Sightings')
TBLPROPERTIES ('hbase.table.name' = 'arohani_ufo_usa_city_year');


insert overwrite table arohani_ufo_usa_city_year_ext
select concat(State, City, cast(Year as string)),
    Total_Sightings
 from arohani_ufo_usa_city_year
 WHERE State IS NOT NULL AND City IS NOT NULL AND Year IS NOT NULL;