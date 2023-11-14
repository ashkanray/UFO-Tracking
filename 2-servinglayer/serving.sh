#!bin/bash
scp -r -i ~/Documents/MPCS/BDAA/arohani_mpcs53014.pem create_views_scala hadoop@ec2-3-131-137-149.us-east-2.compute.amazonaws.com:~/arohani/ufo  

spark-shell -i create_views_scala/arohani_usa_city_month.scala
spark-shell -i create_views_scala/arohani_usa_city_year.scala
spark-shell -i create_views_scala/arohani_usa_state_month.scala
spark-shell -i create_views_scala/arohani_usa_state_year.scala
spark-shell -i create_views_scala/arohani_world_year.scala
spark-shell -i create_views_scala/arohani_world_month.scala
spark-shell -i create_views_scala/arohani_usa_fulldata.scala

#Create tables in hbase
hbase shell create "arohani_ufo_usa_state_year", "ufo"
hbase shell create "arohani_ufo_usa_city_year", "ufo"
hbase shell create "arohani_ufo_usa_full", "ufo"


#Moving view tables to hbase
scp -i ~/Documents/MPCS/BDAA/arohani_mpcs53014.pem hbase/usa_city_year_hbase.hql hadoop@ec2-3-131-137-149.us-east-2.compute.amazonaws.com:~/arohani/ufo/hbase_files  
scp -i ~/Documents/MPCS/BDAA/arohani_mpcs53014.pem hbase/usa_state_year_hbase.hql hadoop@ec2-3-131-137-149.us-east-2.compute.amazonaws.com:~/arohani/ufo/hbase_files
scp -i ~/Documents/MPCS/BDAA/arohani_mpcs53014.pem hbase/usa_summary.hql hadoop@ec2-3-131-137-149.us-east-2.compute.amazonaws.com:~/arohani/ufo/hbase_files  


beeline -u jdbc:hive2://localhost:10000/default -n hadoop -d org.apache.hive.jdbc.HiveDriver -f hbase_files/usa_city_year_hbase.hql
beeline -u jdbc:hive2://localhost:10000/default -n hadoop -d org.apache.hive.jdbc.HiveDriver -f hbase_files/usa_state_year_hbase.hql
beeline -u jdbc:hive2://localhost:10000/default -n hadoop -d org.apache.hive.jdbc.HiveDriver -f hbase_files/usa_summary.hql