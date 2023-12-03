# National UFO Sightings Summary

This project was built for MPCS 53014: Big Data Application Architecture - Final Project

### Project Description
This project was built using data from the National UFO Registry (https://nuforc.org/) and a lambda architecture (shown in diagram below).
The project aims to summarize total UFO sightings per state. The batch layer pulls in the total dataset, which may further be summarized
by City, UFO Shape, or even Text recognition in the summary. 


Technologies used: 
- Hadoop DFS, HiveQL (HQL), HBase, Apache Spark, Apache Kafka, Scala, Node.js, Mustache, Shell, AWS EMR & EC2

<img width="790" alt="Screenshot 2023-11-21 at 12 19 28 PM" src="https://github.com/ashkanray/UFO-Tracking/assets/49113488/62649944-d039-4f62-b30d-b0f2c73734b6">


### Running Application Screenshots

<img width="1139" alt="Screenshot 2023-11-21 at 11 20 57 AM" src="https://github.com/ashkanray/UFO-Tracking/assets/49113488/656b9ab6-1d87-41b5-a712-840579df5341">


<img width="1053" alt="Screenshot 2023-11-21 at 1 15 24 PM" src="https://github.com/ashkanray/UFO-Tracking/assets/49113488/2a27a74f-6445-4632-be02-f220c7e324a9">


### How to Run Deployed Application

The deployed web application can be found at http://ec2-52-14-115-151.us-east-2.compute.amazonaws.com:3060/index.html, currently running in ```arohani/3-webapp/```. More details for deployment can be found below, and additional commands will be found in the shell scripts within the folders (.sh)

A user submission form will be used for the kafka streaming layer, and can be accessed a http://ec2-52-14-115-151.us-east-2.compute.amazonaws.com:3060/submit.html

To initiate the speed layer, you must: 
* ssh into the kafka ec2 cluster and ```cd``` into the project folder
* submit the spark job:  
```spark-submit --master local[2] --driver-java-options "-Dlog4j.configuration=file:///home/hadoop/ss.log4j.properties" --class KafkaUFO uber-UFO_speed_scala-1.0-SNAPSHOT.jar b2.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092,b1.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092,b3.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092```


### Building the Application

#### Batch Layer
We scrape data from the National UFO site using the ```clean_ufo.py``` file - this outputs and saves the data to a csv within the ```/1-batchlayer/scrape_data``` folder. The scrape can be used at any time to create a new batch file.

We then ingest the data into hdfs using the ```ingest_ufo.sh``` file. The data csv was saved locally and ```scp```'d into the hadoop cluster (```/home/hadoop/arohani/ufo```)

The hql tables are created using the create_hql.sh. This shell script calls on the hql files found inside /1-batchlayer/hive to to create the relevant Hive/ORC tables.

The csv is first mapped to a hive table called arohani_ufo_csv, and an ORC table is created after called arohani_ufo.


#### Serving Layer
The serving layer we use computes the batch views and stores them in HBase for more scalable serving. We do the following: 

Inside the ```/2-servinglayer/``` folder, we find three things:
- /create_views_scala/
- /hBase/
- ```serving.sh```

The serving.sh file is used to create the views, but a few steps were followed. The tables were first created in hbase with column key 'ufo'.

The files in create_views_scala create various views in Hive, all based on the batch tables arohani_ufo. Following the table creations, the files in ```/2-servinglayer/hbase/``` will then transfer the data in the hive views to hbase.

The specific methods used can be found in ```serving.sh``` (including all table creation)


#### Speed Layer
The speed layer streams in data in real-time; however, in our case, the uber-jar and spark query we use only updates and streams data that comes from a user submitted form on the webapp. This method can be updated to stream new data in real-time from a website, if this exists.

The current code tracks inputted data to a kafka topic ```arohani_ufo_submissions``` - this topic tracks three things (state, city, summary) and  saves the current date / year upon submission. The uber-jar found in ```/4-speedlayer/UFO_speed_scala/``` is responsible for linking the data in the kafka topic back to our hbase table, incrementing the summarization column specified by 1. 

For example, if a user submits a new sighting in Texas, this will save a new key as TX2023 and map it to our hbase table, incrementing the total count by 1.

The spark streaming job is triggered by calling this in the project folder of our kafka cluster: 
```spark-submit --master yarn --deploy-mode client --driver-java-options "-Dlog4j.configuration=file:///home/hadoop/ss.log4j.properties" --class StreamReports uber-UFO_speed_scala-1.0-SNAPSHOT.jar b-2.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092,b-3.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092,b-1.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092```

#### UI Layer
We use a few items to display our webpage, including javascript and mustache templates. We have two webpages, index.html and submit.html,
that display our results and user-submission forms.

The app can be run with two different methods: 
1. Local Host on Cluster: (accesible at localhost:3000)
    - cd into the ```/3-webapp/``` folder and run ```npm install```
    - SSH into the cluster
    - Run node app.js on the specified port 
    ```ssh -i 'PEM_file' -L 8070:ec2-3-131-137-149.us-east-2.compute.amazonaws.com:8070 hadoop@ec2-3-131-137-149.us-east-2.compute.amazonaws.com```

2. Port Specified Kafka Cluster (accesible at ec2-3-143-113-170.us-east-2.compute.amazonaws.com:3060/submit.html)
    - cd into the ```/3-webapp/``` folder and run ```npm install```
    - SSH into the Kafka cluster
    - Run the app
    ```node app.js 3060 ec2-3-131-137-149.us-east-2.compute.amazonaws.com 8070 b-2.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092,b-3.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092,b-1.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092```
