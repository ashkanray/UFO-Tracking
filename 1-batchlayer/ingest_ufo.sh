#!/bin/bash

#Make the directories to house the sh files and the data
hdfs dfs -mkdir /arohani/project
hdfs dfs -mkdir /arohani/project/ufo

#Copy the csv data and the hive files to Hadoop cluster
scp -i ~/Documents/MPCS/BDAA/arohani_mpcs53014.pem nuforc_clean.csv hadoop@ec2-3-131-137-149.us-east-2.compute.amazonaws.com:~/arohani/ufo  
scp -i ~/Documents/MPCS/BDAA/arohani_mpcs53014.pem hive_ufo.hql hadoop@ec2-3-131-137-149.us-east-2.compute.amazonaws.com:~/arohani/ufo/hive_files

#Remove the column headers
tail -n +2 nuforc_clean.csv > nuforc_final.csv
rm nuforc_clean.csv

#Add the CSV data to hdfs
hdfs dfs -put nuforc_final.csv /arohani/project/ufo
hdfs dfs -ls /arohani/project/ufo

rm nuforc_final.csv