#!/bin/bash

#Creates the hive table using the hive_ufo.hql file
beeline -u jdbc:hive2://localhost:10000/default -n hadoop -d org.apache.hive.jdbc.HiveDriver -f hive_files/hive_ufo.hql