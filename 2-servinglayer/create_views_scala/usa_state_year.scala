import org.apache.spark.sql.SaveMode

val ufo = spark.table("arohani_ufo")

ufo.createOrReplaceTempView("ufo")

val usa_ufo = spark.sql("""select Year, State, count(1) as Total_Sightings
  from ufo
  where Country = 'USA'
  group by Year, State
  ORDER by Total_Sightings DESC;""")

usa_ufo.createOrReplaceTempView("usa_ufo")

spark.sql("DROP TABLE IF EXISTS arohani_ufo_usa_state_year")

usa_ufo.write.mode(SaveMode.Overwrite).saveAsTable("arohani_ufo_usa_state_year")