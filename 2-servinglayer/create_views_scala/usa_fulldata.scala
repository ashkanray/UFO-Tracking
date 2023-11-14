import org.apache.spark.sql.SaveMode

val ufo = spark.table("arohani_ufo")

ufo.createOrReplaceTempView("ufo")

val usa_ufo = spark.sql("""select Occurred, Year, Month, Day, State, City, Shape, Summary
  from ufo
  where Country = 'USA'
  ORDER by Occurred DESC;""")

usa_ufo.createOrReplaceTempView("usa_ufo")

spark.sql("DROP TABLE IF EXISTS arohani_ufo_usa_full")

usa_ufo.write.mode(SaveMode.Overwrite).saveAsTable("arohani_ufo_usa_full")
