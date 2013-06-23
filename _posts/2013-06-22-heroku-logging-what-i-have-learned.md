---
layout: post
title: Heroku logging what I have Learned
tags:
 - Ruby
 - NodeJS
 - DevOps
---

For the last month I have been working with an array of applications hosted on [Heroku](heroku.com), having been
employed to take over operations my first task was to build up a picture of these services. I quickly became
aware of some of the challenges posed when monitoring services hosted in Heroku, and have subsequently become
more reliant on their logging feature to do so. To this end I put together some observations and ideas so others
may learn, and indeed critique them, hopefully enabling others to avoid the issues I encountered.


Being a big fan of the measure everything ideology I suggested my first task would be to gather an array of metrics from
these applications to understand more of what they actually do with the aim of:

1. Helping the business understand what our customers use the most.
2. Enable us to focus on and scale the important parts of our service.

The types of metrics I was intent on gathering are:

* guages, typically a measurement of CPU, Memory usage
* counters, typically things like requests serviced by a rest end point, or emails sent

This was going great till I ran afoul of the process container, the challenge with services like Heroku, is
measurements within environment are difficult as the anonymous nature of their `process` containers.

The environment which hosts your app is designed to abstract the user away from knowing exactly what is going on with their `process`.
From the outside of the container we see a nice `web.1` or `worker.1`, inside the container all our `process` is exposed to is a
random hostname, which is changed each time it is restarted. If we transmit metrics directly from within this
environment we will to find some way of identifying which worker the metric originated from, otherwise we have a constantly growing
list of hosts which have submitted metrics for our app.

My original plan was to emit a range of metrics via [node-statsd-client](https://github.com/msiebuhr/node-statsd-client), this would
enable us to provide detailed information in realtime from within the hosted `processes`.

This plan came unstuck when we realised that the hostname we were using was changing each time our `process` was migrated within heroku.
For those not familiar with [statsd](https://github.com/etsy/statsd/), it relies on you building a structure of metrics based on a typically dotted prefix, in our case this was comprised of:

* environment, being either development staging or production
* hostname, for host level metrics we include the hostname
* application, which represents the service component of our system

So as an example.

> prod.a1ad1f1111a1111db111e1baab111e11.app

In practice this resulted in us drowning an endless list of metrics, this is because as mentioned above this hostname changes every
time your process is restarted, either by you or by Heroku.

To help identify a messages from a `process` we log the ip and hostname of the container on startup of our application, this
enables us to not only deduce the source of metrics but also gives us an audit trail of which IPs should be connecting to
our database services.

If I was to continue to use statsd to acquire metrics from within my application, say for instance the number of requests I make
to an external service api, I really have two options:

1. Emit them via a logger and read them on the other side, as these could be at quite a high rate I may need to do this based on a timer.
2. Queue and rewrite them once I have pieced together the identity of the container using information acquired from the log messages.

Now at this point most people would point to the wide array of metric services integrated with Heroku, in my view this is may
be a good route for some, however as we are using self hosted and heroku hosted services I was interested in a more flexible approach.
We are currently trialing [librato metrics](http://librato.com) but I wanted more control on the integration between the two services,
mainly to avoid being tide directly to Heroku.

Now as mentioned above Heroku does have a way of getting information out of these process containers, this is done via provisioning
a [Logplex](https://devcenter.heroku.com/articles/logging#syslog-drains). This feature allows you to forward your Heroku logs to an
external Syslog server, running in `us-east` and is for long-term archiving. The key thing Heroku doesn't mention in this documentation,
is this is pretty much the only way to get information out of their process container with a context of which dyno is logging it.

Some things to note are, when you configure the Logplex it will assign it a unique Logplex id, this can be used to identify
messages for an application so you should keep a record of it as it can be used as a way of organising your logs if you
have more than one application sending Syslog messages to your server.

So lets look at the actual log messages as logged by [wireshark](http://wireshark.org), each consists of a date a Logplex id,
then Heroku and the worker, then finally the message.

In this case of this example it is a state change message which gives us information about the operational status of our dyno.

> 2013-06-22T09:45:44.830805+00:00 d.8e08d1f6-67a7-47e0-bdb0-7a756d548708 heroku web.1 - - State changed from down to starting\n

These state messages allow us deduce how many dynos we have running for a given application, of which type and their current state.

When I started one of my coworkers mentioned that he was currently logging metrics using a feature available via the Heroku labs options.
Initially I thought this was a bit limited, however since trying a number of other metric gathering mechanisms inside our application
I have come to the conclusion it is probably the most accurate and practical option available. This is based on what I have observed
in the values coming out of statsd, paired with my knowledge of process containers such as lxc which come with there own instrumentation
which in our case is only available to Heroku.

To enable this feature in your Heroku application run.

{% highlight bash %}
heroku labs:enable log-runtime-metrics
{% endhighlight %}

This feature will then log messages containing:

* load_avg_1m Load average for the last minute
* load_avg_5m Load average for the 5 minutes
* load_avg_15m Load average for the 15 minute
* memory_total Total Memory in Megabytes
* memory_rss Resident Set Size in Megabytes
* memory_cache Cache Memory used in Megabytes
* memory_swap swap used in Megabytes
* memory_pgpgin Pages Written to Disk
* memory_pgpgout Pages Read from Disk

For a more detailed description see the [Heroku labs log-runtime-metrics](https://devcenter.heroku.com/articles/log-runtime-metrics) page.

So the `log-runtime-metrics` feature covers my requirement for gathering metrics which gauge the performance of our services, but what
we also need is a method of emitting counters. In statsd counters are sent as a metric and a value to increment it by, now as we want
to keep the logging to a reasonable rate we are going to need a mechanism similar to what is provided by statsd itself.

Internally in statsd it has a metric container which it uses to keep trace of all the counters and guages which it is controlling.
When you configure a backend you have the option of specifying an interval to push a snapshot of these values to a monitoring
service such as librato or graphite.





