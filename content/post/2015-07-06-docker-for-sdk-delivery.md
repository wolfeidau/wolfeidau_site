+++
date = "2015-07-06T17:56:00+10:00"
title = "IoT Development with Docker Containers"
Categories = [ "Development", "embedded", "CI", "docker" ]

+++

With the almost continuous release of new Internet of Things (IoT) hardware platforms and development boards it is not surprising that SDK delivery has seen a shift to piecemeal and "some assembly required" solutions. The majority of hardware companies have trouble delivering Software Development Kits (SDKs) which just work.

Docker presents an opportunity to really make a big leap forward in providing a simple to deploy packaged SDK environments for hardware platforms. It is the first portable package format which works across operating systems, with consistent tooling and a mechanism to share changes with others.

For a more in depth run down on Docker and IoT see [Rapidly develop Internet of Things apps with Docker Containers](http://www.ibm.com/developerworks/mobile/library/iot-docker-containers/index.html) by [@AnnaGerber](https://twitter.com/AnnaGerber)

## So how would this work? 

To illustrate how docker simplifies delivery of these environments lets look at the Docker container I have built for development of esp8266 projects. This container is shared on docker hub [esp8266-dev](https://registry.hub.docker.com/u/wolfeidau/esp8266-dev/). To illustrate how this SDK environment is built take a look at the [ansible-esp8266-role](https://github.com/wolfeidau/ansible-esp8266-role/blob/master/tasks/main.yml) which is used to bootstrap it.

To get started you will need to setup docker on your system, in my case I am using [boot2docker](http://boot2docker.io/) which works on OSX and Windows.

The first thing to understand with boot2docker is that your `/User` folder on OSX is configured as a shared folder in boot2docker virtual machine. This makes it easy to import data all the way through from OSX to your docker container. For more information on how this works see [VirtualBox Guest Additions](https://github.com/boot2docker/boot2docker/blob/master/README.md#virtualbox-guest-additions) in the boot2docker project.

In my case I am using a project based on the [esp8266/source-code-examples](https://github.com/esp8266/source-code-examples/tree/master/basic_example) basic example.

So lets add a `Dockerfile` to this project, note that I have updated the `WORKDIR` to match the path to my ESP project.

```
FROM wolfeidau/esp8266-dev:1.1.0

# add all the SDK stuff to the PATH
ENV PATH=$PATH:/opt/Espressif/crosstool-NG/builds/xtensa-lx106-elf/bin

# Path which contains your esp8266 project source code
WORKDIR /Users/markw/Code/Systems/esp8266-led-lamp

# pass -v /Users:/Users to ensure your shared folder is available within 
# the container for builds.
VOLUME /Users

USER ubuntu
```

Then to build your container just run.

```
docker build -t esp8266-build .
```

And when you want to do a build run the following:

```
docker run -v /Users:/Users -i -t esp8266-build make
```

Now if you check in your `firmware` directory you should have the files required to flash your esp2866 project!

If we want to mess around inside the container we can run.

```
docker run -v /Users:/Users -i -t esp8266-build bash
```

This project is something I am working on at the moment [esp8266-led-lamp](https://github.com/wolfeidau/esp8266-led-lamp).

So in summary we have installed boot2docker and built an esp8266 project with little or on messing around with complex SDK setup. In my view this is a big step forward in shortening the time to build for hardware projects, and simplifying delivery of complex SDK environments.

Hopefully the likes of [Atmel](http://www.atmel.com/) and [Texus Instruments](http://www.ti.com/) look at using Docker in the future.


