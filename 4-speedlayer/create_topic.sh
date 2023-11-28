#Hadoop Cluster
ssh -i Documents/MPCS/BDAA/arohani_mpcs53014.pem hadoop@ec2-3-131-137-149.us-east-2.compute.amazonaws.com

ssh -i ~/Documents/MPCS/BDAA/arohani_mpcs53014.pem -L 8070:ec2-3-131-137-149.us-east-2.compute.amazonaws.com:8070 hadoop@ec2-3-131-137-149.us-east-2.compute.amazonaws.com 

#Create the Topic (SSH into hadoop cluster)
kafka-topics.sh --create --zookeeper z-3.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:2181,z-1.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:2181,z-2.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:2181 --replication-factor 1 --partitions 1 --topic arohani_ufo_submissions

#Check topics (SSH into hadoop cluster)
kafka-topics.sh --list --zookeeper z-3.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:2181,z-1.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:2181,z-2.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:2181


#Run the Kafka Cluster
ec2-3-143-113-170.us-east-2.compute.amazonaws.com:3060/submit.html

ssh -i ~/Documents/MPCS/BDAA/arohani_mpcs53014.pem ec2-user@ec2-3-143-113-170.us-east-2.compute.amazonaws.com

node app.js 3060 ec2-3-131-137-149.us-east-2.compute.amazonaws.com 8070 b-2.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092,b-3.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092,b-1.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092


#Checking that UFO data is being sent to Kafka
kafka-console-consumer.sh --bootstrap-server b-1.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092,b-2.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092,b-3.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092 --topic arohani_ufo_submissions --from-beginning


#Delete topic if needed to reset queue
kafka-topics.sh --zookeeper z-3.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:2181,z-1.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:2181,z-2.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:2181 --delete --topic arohani_ufo_submissions

##Run the Spark Streaming Job
spark-submit --master local[2] --driver-java-options "-Dlog4j.configuration=file:///home/hadoop/ss.log4j.properties" --class KafkaUFO uber-UFO_speed_scala-1.0-SNAPSHOT.jar b2.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092,b1.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092,b3.mpcs53014kafka.o5ok5i.c4.kafka.us-east-2.amazonaws.com:9092