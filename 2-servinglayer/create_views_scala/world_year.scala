import org.apache.spark.sql.SaveMode

val ufo = spark.table("arohani_ufo")

ufo.createOrReplaceTempView("ufo")

val world_ufo = spark.sql("""select Year, Country, count(1) as Total_Sightings
  from ufo
  where Country != 'USA'
  group by Year, Country
  ORDER by Total_Sightings DESC;""")

world_ufo.createOrReplaceTempView("world_ufo")

spark.sql("DROP TABLE IF EXISTS arohani_ufo_world_year")

world_ufo.write.mode(SaveMode.Overwrite).saveAsTable("arohani_ufo_world_year")
