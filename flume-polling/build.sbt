import AssemblyKeys._ 

name := "flume-app"

scalaVersion := "2.10.4"

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-streaming" % System.getenv.get("SPARK_VERSION") % "provided",
  "org.slf4j" % "slf4j-api" % "1.6.1",  // Workaround for bug IVY-987
  "org.apache.spark" %% "spark-streaming-flume" % System.getenv.get("SPARK_VERSION")
)

assemblySettings

mergeStrategy in assembly := {
  case m if m.toLowerCase.endsWith("manifest.mf")          => MergeStrategy.discard
  case m if m.toLowerCase.matches("meta-inf.*\\.sf$")      => MergeStrategy.discard
  case "log4j.properties"                                  => MergeStrategy.discard
  case m if m.toLowerCase.startsWith("meta-inf/services/") => MergeStrategy.filterDistinctLines
  case "reference.conf"                                    => MergeStrategy.concat
  case _                                                   => MergeStrategy.first
}

