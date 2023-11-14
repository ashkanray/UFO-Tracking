Steps for Project:

1. What are we comparing UFO data with?

Batch Layer
- Scrape data using Python
- Save data as CSV
- Run the ingest file (ingest_ufo.sh) to upload the CSV to HDFS DFS / use SCP 
- Run the HQL code (create_hql.sh) to create the HQL table in the cluster using the CSV file

- Addtional data source to be added**


Serving Layer
- Use SCALA to create new views with existing hive tables
- Can join the hive tables / create new calculations / etc.
- Transfer new views via Scala to HBASE


Speed Layer
- TBD



UI 
- Use a dropdown to search for events by country, and if needed, state / city
- Output a graph of all events by year for a specified country or city
    - Only for the US can you specify by state then city
    - Checks for just country, and then state, and then city - if all three are populated, it obviously checks the data and narrows it down
- Graph for month by month view of a location, if year is specified?
- Input new findings as needed for speed layer
- Compare UFO sightings with release of movies? weather events? flight / military planes?