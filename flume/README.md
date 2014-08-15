# Spark Streaming Sample Projects for Starters
This repository contains sample starter Spark Streaming projects for various input sources like Kafka, Flume, etc. Each of the subdirectories are SBT projects (Maven project coming soon) with the following structure.

* *README.md* - Instruction to run the project, specific to each input source / project
* *build.sbt* - Project definition, specifying the dependencies (Spark Streaming, etc.)
* *src* - Contains the source code of the project
* *bin* - Contains scripts to setup and run the project
	* *run-spark.sh* - Script to run the Spark Streaming example program
	* *run-<input-source>.sh* - Script to run the corresponding input source to generate data for the Spark Streaming program
	* *setup.sh* - Script to download the tarballs (Spark, Kafka, etc.) necessary to run the Spark Streaming program
		 
See the README in the subdirectories to find more information relevant to your input source.

