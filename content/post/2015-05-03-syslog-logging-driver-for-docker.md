+++
date = "2015-05-03T20:18:23+10:00"
title = "syslog logging driver for Docker"
Categories = [ "docker", "logging", "syslog" ]

+++

This post will illustrate how to use the new [syslog logging driver](https://docs.docker.com/reference/run/#logging-drivers-log-driver) for [Docker](http://docker.com), along with some notes on using [docker-machine](https://docs.docker.com/machine/). 

The first thing to be clear on is the syslog logging driver enables you to relay the log messages written to stdout/stderr within a container, to syslog service on the host machine.

For this example I am going to do this for an agent of the [buildkite](https://buildkite.com) continuous integration (CI) service running inside a Docker container. 

To ensure these logs are only retained on the host for a short time [logrotate](http://linuxcommand.org/man_pages/logrotate8.html) will be imployed to rotate and delete aging logs.

Firstly to use the new log drivers you need Docker 1.6, in my case I used `docker-machine` to spin up a new system on [digital ocean](https://www.digitalocean.com/) as follows.

```
docker-machine create -d digitalocean \
	--digitalocean-access-token XXXXX \ 
	--digitalocean-image 'ubuntu-14-04-x64' \
	--digitalocean-region 'sfo1' \
	--digitalocean-size '1gb' buildkite01
```

Note: You will need to grab your access token from the digital ocean dashboard.

Once the system is up and running use `docker-machine` to log into the host.

```
docker-machine ssh buildkite01
```

Configure rsyslog to isolate the Docker logs into their own file. To do this create `/etc/rsyslog.d/10-docker.conf` and copy the following content into the file using your favorite text editor.

```
# Docker logging
daemon.* {
 /var/log/docker.log
 stop
}
```

In summary this will write all logs for the daemon category to `/var/log/docker.log` then stop processing that log entry so it isn't written to the systems default syslog file.

Now we configure `logrotate` to roll and archive these files. Create the `/etc/logrotate.d/docker` file and again copy the content as follows to it.

```
/var/log/docker.log {
    size 100M
    rotate 2
    missingok
    compress
}
```

This entry will roll the `docker.log` when it gets above 100MB and retain two of these files. 

Note: The `logrotate` cron job only runs daily by default, so this check will only be done at the end of the day.

Now restart the [rsyslog](http://www.rsyslog.com/) service.

```
service rsyslog restart
```

Now build your Docker container on your Docker machine from your laptop as follows. This will transfer the contents of `.` to the remote system and build your Docker container there, then tag it.

```
docker $(docker-machine config buildkite01) build -t buildkite/wolfeidau-golang:latest .
```

Then launch a named container, in this case we are passing `--log-driver=syslog` along with other buildkite agent specific information, and the tag we just built.

```
docker $(docker-machine config buildkite01) run \
	-d --rm --name buildkite-golang --log-driver=syslog \
	-e BUILDKITE_AGENT_TOKEN=XXX \
	-e BUILDKITE_AGENT_META_DATA="golang=1.4.2" \
	buildkite/wolfeidau-golang:latest
```

Then we ssh into the remote system and tail the `/var/log/docker.log` log file we can see output from the buildkite agent.

```
$ docker-machine ssh buildkite01
# tail /var/log/docker.log
May  3 05:53:56 buildkite01 docker/7ebdb2baff9c[3207]: 2015-05-03 09:53:56 INFO   Registering agent with Buildkite...
May  3 05:53:57 buildkite01 docker/7ebdb2baff9c[3207]: 2015-05-03 09:53:57 INFO   Successfully registred agent "7ebdb2baff9c" with meta-data [golang=1.4.2]
```

So at the moment some things are on the horizon for this driver including [changing the tag](https://github.com/docker/docker/pull/12668) and possibly remote server configuration.

That is the end of this brief post, hopefully it helps others get started with this new feature, and provides some tips on how to configure the rsyslog service to work with it.

Lastly I typically use [ansible](http://www.ansible.com/home) to automate this sort of thing, but it is nice to walk through it at least once.

