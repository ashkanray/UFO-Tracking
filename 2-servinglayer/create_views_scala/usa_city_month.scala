import org.apache.spark.sql.SaveMode

val ufo = spark.table("arohani_ufo")

ufo.createOrReplaceTempView("ufo")

val usa_ufo = spark.sql("""select Year, Month, State, City, count(1) as Total_Sightings
  from ufo
  where Country = 'USA'
  group by Year, Month, State, City
  ORDER by Total_Sightings DESC;""")

usa_ufo.createOrReplaceTempView("usa_ufo")

spark.sql("DROP TABLE IF EXISTS arohani_ufo_usa_city_month")

usa_ufo.write.mode(SaveMode.Overwrite).saveAsTable("arohani_ufo_usa_city_month")
