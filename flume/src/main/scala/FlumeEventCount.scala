import org.apache.spark.SparkConf
import org.apache.spark.rdd.RDD
import org.apache.spark.storage.StorageLevel
import org.apache.spark.streaming._
import org.apache.spark.streaming.flume._

/**
 *  Produces a count of events received from Flume.
 *
 *  This should be used in conjunction with an AvroSink in Flume. It will start
 *  an Avro server on at the request host:port address and listen for requests.
 *  Your Flume AvroSink should be pointed to this address.
 *
 *  Usage: FlumeEventCount <host> <port>
 *    <host> is the host the Flume receiver will be started on - a receiver
 *           creates a server and listens for flume events.
 *    <port> is the port the Flume receiver will listen on.
 *
 */
object FlumeEventCount {
  def main(args: Array[String]) {
    if (args.length < 2) {
      System.err.println(
        "Usage: FlumeEventCount <host> <port>")
      System.exit(1)
    }

    val host = args(0)
    val port = args(1).toInt
    val batchInterval = 2
    var totalCount = 0L

    // Create the context and set the batch size
    val sparkConf = new SparkConf().setMaster("local[4]").setAppName("FlumeEventCount")
    val ssc = new StreamingContext(sparkConf, Seconds(batchInterval))

    // Create a flume stream
    val stream = FlumeUtils.createStream(ssc, host, port, StorageLevel.MEMORY_ONLY_SER)

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

