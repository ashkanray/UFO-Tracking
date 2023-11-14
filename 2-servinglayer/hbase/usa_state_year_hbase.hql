DROP TABLE IF EXISTS arohani_ufo_usa_state_year_ext;
create external table arohani_ufo_usa_state_year_ext (
  state_year string,
    Total_Sightings bigint)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, ufo:Total_Sightings')
TBLPROPERTIES ('hbase.table.name' = 'arohani_ufo_usa_state_year');


insert overwrite table arohani_ufo_usa_state_year_ext
select concat(State, cast(Year as string)),
    Total_Sightings
  from arohani_ufo_usa_state_year
  WHERE State IS NOT NULL AND Year IS NOT NULL
  ORDER BY Year DESC;