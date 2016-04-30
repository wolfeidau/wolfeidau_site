+++
date = "2015-08-08T17:56:00+10:00"
title = "Development with Webpack and Docker"
Categories = [ "Development", "CI", "docker" ]

+++

This describes how to develop front-end projects with [webpack](https://webpack.github.io/) inside a [docker](docker.com) container using [boot2docker](http://boot2docker.io/) on OSX.

## So firstly why would we even do this?

The main aim of using docker for development is:

1. Portable build environment
2. Simplified on-boarding of new developers
3. Consistency between development and continuous integration (CI)

In summary tools like docker make it very easy to package up a development environment and share it among a team of developers.

## Sharing folders

Within this setup we want the developer to choose what and how they code, on OSX
we need an environment where they can just keep using their current editor.

The `boot2docker` service configures a shared folder which mounts `/Users` folder on OSX within the virtual machine it provisions which easy to mount your project all the way through from OSX to your docker container. For more information on how this works see [VirtualBox Guest Additions](https://github.com/boot2docker/boot2docker/blob/master/README.md#virtualbox-guest-additions).

# Configuration

I typically start my webpack projects using [macropodhq/webpack-skel](https://github.com/macropodhq/webpack-skel) by the people at [Macropod](https://macropod.com/).

Once i have my project setup I add the following fragment to the webpack configuration.

```js
  watchOptions: {
    poll: 1000,
    aggregateTimeout: 1000
  },
```

Add a `Dockerfile` to the project which uses the official iojs images, note I am using 2.x as 3.x is still having issues with some native modules.

```
FROM iojs:2

# This will cd to the project root when docker starts in bash
CMD sh -c "cd ${PROJECT_PATH:-/}; exec /bin/bash"
```

Then build your docker container.

```
docker build -t iojsfsnotify .
```

Start the container passing in your current working directory as the path you want to change directory to when the container starts.

```
docker run -it -e PROJECT_PATH=$(pwd) -e DOCKER_IP=$(boot2docker ip) \
  -v "/Users:/Users" -p 8080:8080 -t iojsfsnotify
```

Then you can install your node modules.

```
npm install
```

Start the `webpack-dev-server`.

```
npm start
```

If you want to use the inline live reload mode you will need to use my fork of [webpack-dev-server](https://github.com/wolfeidau/webpack-dev-server) for the moment. I would love to get this change merged but I am guessing Tobias Koppers is pretty busy given how much of a runaway success webpack has been.

Below is the fragment from my package.json which points to my fork.

```
    "webpack-dev-server": "wolfeidau/webpack-dev-server"
```

A full example of this project is located at [wolfeidau/webpack-docker-example](https://github.com/wolfeidau/webpack-docker-example).
