# Spark Streaming + Flume Starter Project

This project contains an example Spark Streaming application that consumes data from Flume. Follow the steps to download and run this example.

1. Download the repository

		> git clone git@github.com:tdas/spark-streaming-external-projects.git
	
1. Enter the directory, and run Flume locally.
	
		> cd flume
		> bin/run-flume.sh
		
	If you are running this for the first time, then it will first download and setup Spark and Flume locally, which may take some amount of time.
	
1. In another terminal, run the example.

		> bin/run-spark.sh
		
	You should soon see that the Spark Streaming program will start reporting the number of events received in each batch. This should run for 10s of seconds before quitting.
	
The source code of the application is in the `src/main/scala` directory. The configuration used to run Flume is present in `conf/flume-conf.properties`.

Please see the [Spark Streaming Programming Guide](http://spark.apache.org/docs/latest/streaming-programming-guide.html) for more information about Spark Streaming.


