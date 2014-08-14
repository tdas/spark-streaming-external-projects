import java.util.Properties

import kafka.producer._

import org.apache.spark.rdd.RDD
import org.apache.spark.SparkConf
import org.apache.spark.streaming._
import org.apache.spark.streaming.StreamingContext._
import org.apache.spark.streaming.kafka._

/**
 * Consumes messages from one or more topics in Kafka and does wordcount.
 * Usage: KafkaWordCount <zkQuorum> <group> <topics> <numThreads>
 *   <zkQuorum> is a list of one or more zookeeper servers that make quorum
 *   <group> is the name of kafka consumer group
 *   <topics> is a list of one or more kafka topics to consume from
 *   <numThreads> is the number of threads the kafka consumer should use
 *
 * Example:
 *    `$ bin/run-example \
 *      org.apache.spark.examples.streaming.KafkaWordCount zoo01,zoo02,zoo03 \
 *      my-consumer-group topic1,topic2 1`
 */
object KafkaEventCount {
  def main(args: Array[String]) {
    if (args.length < 4) {
      System.err.println("Usage: KafkaWordCount <zkQuorum> <group> <topics> <numThreads>")
      System.exit(1)
    }

    val Array(zkQuorum, group, topics, numThreads) = args
    var totalCount = 0L

    val sparkConf = new SparkConf().setAppName("KafkaEventCount")
    val ssc =  new StreamingContext(sparkConf, Seconds(2))
    ssc.checkpoint("checkpoint")

    val topicpMap = topics.split(",").map((_,numThreads.toInt)).toMap
    val stream = KafkaUtils.createStream(ssc, zkQuorum, group, topicpMap).map(_._2)

    // Print out the count of events received from this server in each batch
    stream.foreachRDD((rdd: RDD[_], time: Time) => { 
      val count = rdd.count()
      println("\n-------------------")
      println("Time: " + time)
      println("-------------------")
      println("Received " + count + " events\n")
      totalCount += count 
    })
    ssc.start()
    Thread.sleep(20 * 1000)
    ssc.stop()

    if (totalCount > 0) {
      println("PASSED")
    } else {
      println("FAILED")
    }
  }
}
