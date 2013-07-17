---
layout: post
title: Heroku logging what I have Learned
tags:
 - Librato
 - Heroku
 - DevOps
---

Recently I started work for a new employer who runs has a number of applications hosted on [Heroku](heroku.com), my
typical strategy when faced with a new environment and systems is try and get some monitoring in place as soon as
possible. I do this for a few reasons:

1. It enables me to establish a baseline for performance and behavior of the system.
2. It lets me quickly zero on any areas I can help with.
3. It makes it easier for me to see when I get things wrong while I am still learning the ropes.

So when I talk about monitoring I am mainly talking about collecting some basic performance and health related metrics
which fall into two different types:

* `gauges`, typically a measurement of the current CPU, Memory usage and latency of upstream APIs, which is typically averaged over a period.
* `counters`, typically things like a count requests serviced by a particular rest end point, or emails sent by a background job.

So when I have been managing systems in the past I have typically been very careful to follow a neat and clear naming standard
for metrics such as:

* region, the physical location or region the data center hosting this server is located.
* environment, being either development staging or production.
* hostname, for host level metrics we include the hostname.
* application, which represents the service component of our system.
* label, a label for the data being gathered.
* metric, the metric which has been gathered over the configured time period.

So below we have an example of a gauge of the applications RSS memory captured on a production server hosted in us-east.

> us-east.prod.a1ad1f1111a1111db111e1baab111e11.app.memory_rss.median

So armed with [statsd](https://github.com/etsy/statsd) and [Librato](http://librato.com) I started adding monitoring to the
system, unfortunately this is where things went a bit pear shaped. Having been used to monitoring static
environments I was not prepared for the changing and in some ways obfuscated world of fully isolated process containers.

In these process containers things like hostnames and IP addresses change each time your service is moved within
the environment, this makes correlating metrics emitted from statsd very difficult. On the outside of Heroku we get a picture of dynos web.1 and web.2,
but inside the container your processes are unable to access these labels, the are essentially just anonymous process tasked with doing a particular job.

So this resulted in an endlessly growing list of metrics, every time your process is restarted, I would get a new hostname and a whole new group of metrics. One thing
to note is Heroku restarts your process at least once per day.

So how do you monitor stuff housed in Heroku? The answer to this is logging, the Heroku gives you the ability to provision
log drains, these endpoints are sent a copy of all messages written STDOUT and STDERR by your application. When configured the
logdrain transports your logs via either syslog or HTTP(S) to an external server, running in the same AWS as Heroku.
Most importantly, these logs include a context of which `dyno` is emitting the information. To read more about this feature take a look at [Logplex](https://devcenter.heroku.com/articles/logging#syslog-drains) documentation.

When I started my new role one of my
coworkers mentioned that he was currently logging metrics using a feature called `log-runtime-metrics` available via the Heroku labs.
Initially I thought this was a bit limited, however on further examination this is actually an extremely reliable measure of the
processes resource utilisation. For more information on this feature [Heroku Labs: log-runtime-metrics](https://devcenter.heroku.com/articles/log-runtime-metrics).

So just for clarity this is what these runtime metrics look like, note the reference to the dyno in the source along with the metric name, value and units.

> source=heroku.2808254.web.1.d97d0ea7-cf3d-411b-b453-d2943a50b456 measure=memory_rss val=21.22 units=MB

So now that I had metrics, with context in a stream coming in via logs I needed a way of getting this data to Librato having already had contact with [Nik Wekwerth](https://twitter.com/nwekwerth)
I decided to ask whether he had any suggestions. After a few emails I was very fortunate enough to be passed onto the CTO [Joseph Ruscio](https://twitter.com/josephruscio) who after a few questions
suggested I try out [l2met](http://r.32k.io/l2met-introduction), a project by [Ryan Smith](https://twitter.com/ryandotsmith)
an engineer at Heroku. This service acts as a bridge between the two services filtering the metrics out of the log messages and send them off to librato at a configurable interval.

After learning a bit of [golang](http://golang.org/) I was able to add support for the Heroku labs runtime metrics
feature and tune a few things for my requirements. This was helped along by some good high level tests and a few helpful tips from the author.

An example of my new log based metrics is as follows:

> us-east.prod.app.load_avg_5m.median

The missing piece here is the `dyno`, fortunately l2met sends this in an optional `source` property enabling me to use aggregate,
or per `dyno` level metrics in my dashboard. For more information on the attributes supported by Librato see their
[API documentation](http://dev.librato.com/v1/metrics).

One bonus from this is that when dynos are added or removed the graphs in Librato automatically reflect this without requiring
any configuration.

Now some key take points on this:

* Although Heroku appears to hide a lot information from you at first, it does provide some very good instrumentation as long as you understand how to tap into it.
* Logging is the primary source of information about the state of your hosted applications, use it as much as possible.
* [Measure Anything, Measure Everything](http://codeascraft.com/2011/02/15/measure-anything-measure-everything/) have a read of this if you haven't before it is a great post.

Note, I am still using statsd for some of my counters, this is due to the frequency they change, I am hoping to implement
a scheduled emitter for them in the future which I can pass through via logs. To remedy the amount of logging I am not
including the hostname in the metrics anymore and just acquiring the aggregate value across all processes.

I plan to follow this up with a post containing some notes on how I configured l2met, hopefully I can get this out in the next couple of weeks.




