# National UFO Sightings Summary

This project was built for MPCS 53014: Big Data Application Architecture - Final Project

### Project Description



### Running Application Screenshots





### How to Run Deployed Application

The deployed web application can be found at http://ec2-52-14-115-151.us-east-2.compute.amazonaws.com:3008/sensor-readings.html, currently running in ```cwbryant/ui-layer/``` in a ```screen``` window. 

To initiate the speed layer streaming:
* ```cd``` into the ```/cwbryant/final_project directory```
* submit the spark job with command: 
```spark-submit --master local[2] --driver-java-options “-Dlog4j.configuration=file:///home/hadoop/ss.log4j.properties" --class StreamReadings /home/hadoop/cwbryant/final_project/uber-speed-update-views—1.0-SNAPSHOT.jar b-2.mpcs53014-kafka.198nfg.c7.kafka.us-east-2.amazonaws.com:9092,b-1.mpcs53014-kafka.198nfg.c7.kafka.us-east-2.amazonaws.com:9092```

New sensor reading data can be inputted in the web app at http://ec2-52-14-115-151.us-east-2.compute.amazonaws.com:3008/submit-reading.html. The data will be pushed onto the ```cwbryant_readings``` Kafka topic, and the spark job will increment the relevant view.


### Building the Application

#### Batch Layer


#### Serving Layer


#### Speed Layer


#### UI Layer

