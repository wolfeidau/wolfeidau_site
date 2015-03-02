+++
date = "2011-10-16T00:00:00+11:00"
draft = false
title = "Monitoring the OpenJDK from the CLI"
categories = [ "Java", "Performance", "Tuning" ]

+++

Currently I do quite a bit of work in and around the [Java virtual machine](http://openjdk.java.net/) \(JVM), most of the time on Linux. When things go awry and I am trying to establish why, I reach for the Java performance analysis tools. These tools come in two forms, the wonderful GUI known as [visualvm](http://visualvm.java.net/), which I use when I am working on my local machine, and the cli tools packaged with the Java Development Kit (JDK), which I use when working remotely.


The CLI tools I am referring to are:

* [jps - JVM Process Status Tool](http://download.oracle.com/javase/6/docs/technotes/tools/share/jps.html)
* [jstat - JVM Statistics Monitoring Tool](http://download.oracle.com/javase/6/docs/technotes/tools/share/jstat.html)
* [jhat - Java Heap Analysis Tool](http://download.oracle.com/javase/6/docs/technotes/tools/share/jhat.html)
* [jstack - Java Stack Trace Tool](http://download.oracle.com/javase/6/docs/technotes/tools/share/jstack.html)

The tools I use most commonly are jps, jstat and jstack, the jhat tool is also very handy but really needs an entire blog post to itself as it crazy what you can do with it. In this post I have put together some tips, observations and sample outputs to illustrate how I use them.

As I am using [ubuntu](http://www.ubuntu.com/) 11.10, which only installs the Java runtime environment (JRE) I will need to install the JDK. In my case I decided to give openjdk 7 a shot, but version 6 would work just fine.

{{< highlight bash >}}
root@oneric:~# apt-get install openjdk-7-jdk
{{< /highlight >}}

To try out these commands I have installed tomcat7 this can be done through apt on ubuntu, again the previous version being tomcat 6 would be fine.

{{< highlight bash >}}
root@oneric:~# apt-get install tomcat7
{{< /highlight >}}

Now that I have tomcat installed I want to list the Java processes, note that it is best to assume the same user account as the service when doing this. On ubuntu I would su to the user account, as the tomcat7 user is a system account I have to override the shell as it is _/bin/nologin_ by default, I can then run jps as this user.

The _jps_ command outputs the PID of the java process along with the main class name and the argument(s) passed to it on startup.

{{< highlight bash >}}
root@oneric:~# su - tomcat7 -s /bin/bash 
tomcat7@oneric:~$ jps -ml
12728 org.apache.catalina.startup.Bootstrap start
13926 sun.tools.jps.Jps -ml
tomcat7@oneric:~$ 
{{< /highlight >}}

Now that we have the PID of these processes we can run jstat, the first switch I use is _-gcutil_ this gives me an overview of the heap use within the jvm. In cases where there are pauses or performance degradation I will look at the last two columns. These contain the garbage collection time (GCT) and full garbage collection time (FGCT). If the FGCT column is increasing every second then it is likely we have an issue.

The following example I am running _jstat_ against the PID of tomcat. I have also instructed the command to display the table headers every 20 rows and print the statistics continuously with an interval of 1000 milliseconds, as normal control C with end the output.

This sample shows a newly started tomcat 7 with very little happening, this is clear from the values in the full garbage collection time(FGCT) and garbage collection time(GCT) columns. 

Also of note is the permgen space (P) which is currently sitting at 70%. The permgen space is an important area of the heap as it holds user classes, method names and internal jvm objects. If you have used tomcat for a while you will have seen the _java.lang.OutOfMemoryError: PermGen space_ error wich indicates when this space fills up and cannot be garbage collected. This frequently happened when redeploying large web applications.

Also in the sample we can see that the Survivor 0 (S0), Survivor 1 (S1), Eden and Old spaces have quite a bit of free space which is good. 

{{< highlight bash >}}
tomcat7@oneric:~$ jstat -gcutil -h20 12728 1000
  S0     S1     E      O      P     YGC     YGCT    FGC    FGCT     GCT   
  0.00  17.90  32.12   4.81  71.41      5    0.009     1    0.023    0.032
  0.00  17.90  32.12   4.81  71.41      5    0.009     1    0.023    0.032
  0.00  17.90  32.12   4.81  71.41      5    0.009     1    0.023    0.032
{{< /highlight >}}

To illustrate what a tomcat under load looks like in comparison we can install a tool called Apache bench.

{{< highlight bash >}}
root@oneric:~# apt-get install apache2-utils
{{< /highlight >}}

And run the following command to hit the base page with a large number of requests concurrently.

{{< highlight bash >}}
markw@oneric:~$ ab -n 1000000 -c 100 http://localhost:8080/
{{< /highlight >}}

Below is the output after this test was run for a bit, as we can see there has been considerable growth of the survivor 1, eden and old space, however the server hasn't spent a lot of time doing full garbage collects as indicated by the value of the full garbage collection count(FGC) which is only 10, most of the work is in the young generation as seen by the increase in the young generation collection count (YGC). 

Also to note here is that there wasn't a lot of change in the permgen space, it actually went down, this was due to an increase in size of heap.

{{< highlight bash >}}
tomcat7@oneric:~$ jstat -gcutil -h20 12728 1000
  S0     S1     E      O      P     YGC     YGCT    FGC    FGCT     GCT   
  0.00 100.00  52.02  81.84  59.62    117    1.176    10    0.074    1.250
  0.00 100.00  52.02  81.84  59.62    117    1.176    10    0.074    1.250
  0.00 100.00  52.02  81.84  59.62    117    1.176    10    0.074    1.250
  0.00 100.00  52.02  81.84  59.62    117    1.176    10    0.074    1.250
{{< /highlight >}}

To look deeper into the cause of garbage collection we use the _jstat_ command with the _-gccause_ option, this displays the same columns as the previous command but with two extras which supply the reasons for GC.

In the following example we can see an example of an allocation failure, this indicates that a full gc is being performed because the heap is too small.

{{< highlight bash >}}
tomcat7@oneric:~$ jstat -gccause -h20 12728 1000
100.00   0.00   0.00  78.91  59.67    168    1.680    14    0.083    1.763 unknown GCCause      No GC               
100.00   0.00  72.61  83.73  59.67    170    1.698    14    0.083    1.781 unknown GCCause      No GC               
  0.00 100.00  46.24  91.83  59.67    173    1.729    14    0.083    1.811 unknown GCCause      No GC               
100.00   0.00  11.39  29.80  59.67    176    1.759    16    0.086    1.846 unknown GCCause      No GC               
100.00   0.00  92.41  35.30  59.67    179    1.777    16    0.086    1.864 unknown GCCause      Allocation Failure  
  0.00 100.00  62.58  43.05  59.67    181    1.803    16    0.086    1.889 unknown GCCause      No GC               
{{< /highlight >}}

Another area which I like to look into when diagnosing performance issues is the threads running in the vm. This can help me undertand if any component is overloaded and therefore operating a lot of threads trying to catch up. This is mostly only applicable to async processes like messaging, or scheduling routines.

To dump a list of threads and their current stack us the _jstack_ command as illustrated by the sample below, again I normally run this as the owner of the process.

{{< highlight bash >}}
tomcat7@oneric:~$ jstack 12728
2011-10-16 14:53:58
Full thread dump OpenJDK 64-Bit Server VM (20.0-b11 mixed mode):

"Attach Listener" daemon prio=10 tid=0x00000000015be800 nid=0x4004 waiting on condition [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

"http-bio-8080-exec-182" daemon prio=10 tid=0x00007f9d84274800 nid=0x3cd3 waiting on condition [0x00007f9d7a0df000]
   java.lang.Thread.State: WAITING (parking)
        at sun.misc.Unsafe.park(Native Method)
        - parking to wait for  <0x00000000ef16da38> (a java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject)
        at java.util.concurrent.locks.LockSupport.park(LockSupport.java:186)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.await(AbstractQueuedSynchronizer.java:2043)
        at java.util.concurrent.LinkedBlockingQueue.take(LinkedBlockingQueue.java:386)
        at org.apache.tomcat.util.threads.TaskQueue.take(TaskQueue.java:104)
        at org.apache.tomcat.util.threads.TaskQueue.take(TaskQueue.java:32)
        at java.util.concurrent.ThreadPoolExecutor.getTask(ThreadPoolExecutor.java:1043)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1103)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:603)
        at java.lang.Thread.run(Thread.java:679)
...
{{< /highlight >}}

I plan on doing a bit of work on some visualisation tools, in [jruby](http://jruby.org/) of course, however that can be the focus of my next post. In the process of writing this post I located some interesting articles, these are linked below:

* [Chuk-Munn Lee of Sun Microsystems Troubleshoots Java SE 6 Deployment](http://java.sun.com/developer/technicalArticles/javase/troubleshoot/)
* [Explaining java.lang.OutOfMemoryError: PermGen space](http://www.freshblurbs.com/explaining-java-lang-outofmemoryerror-permgen-space)

