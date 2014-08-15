# Spark Streaming Starter Projects
This repository contains sample starter Spark Streaming projects for various input sources like Kafka, Flume, etc. 

Each of the subdirectories are SBT projects (Maven definitions coming soon) with the following structure.

* `README.md` - Instruction to run the project, specific to each input source / project
* `build.sbt` - Project definition, specifying the dependencies (Spark Streaming, etc.)
* `src` - Contains the source code of the project
* `bin` - Contains scripts to setup and run the project
	* `run-spark.sh` - Script to run the Spark Streaming example program
	* `run-<input-source>.sh` - Script to run the corresponding input source to generate data for the Spark Streaming program
	* `setup.sh` - Script to download the tarballs (Spark, Kafka, etc.) necessary to run the Spark Streaming program
	* `env.sh` - Script containing the configuration (versions, etc.) relevant to input source
		 
See the README in the subdirectories to find more information relevant to your input source. 

Additionally, you will also find `bin` directory in the root of the project, that contains scripts that download and configure Spark for running the examples.

Note that these examples assumes that you are running a Linux / Mac OSX operating system and have Bash installed.

Please see the [Spark Streaming Programming Guide](http://spark.apache.org/docs/latest/streaming-programming-guide.html) for more information about Spark Streaming.

