DROP TABLE IF EXISTS arohani_ufo_usa_summary_ext;
create external table arohani_ufo_usa_summary_ext (
  state_year string,
    Occurred date,
    Summary string)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, ufo:Occurred, ufo:Summary')
TBLPROPERTIES ('hbase.table.name' = 'arohani_ufo_usa_full');


insert overwrite table arohani_ufo_usa_summary_ext
select concat(State, City, cast(Occurred as string)),
    Occurred, Summary
 from arohani_ufo
 WHERE Country = "USA" AND State IS NOT NULL AND Year IS NOT NULL
 ORDER by Occurred DESC;