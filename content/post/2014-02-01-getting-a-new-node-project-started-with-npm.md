+++
date = "2014-02-01T00:00:00+11:00"
draft = false
title = "Getting a new node project started with npm"
categories = [ "NodeJS", "npm", "git" ]

+++

The aim of this guide is to get people getting started with [Node.js](http://nodejs.org) and [npm](http://npmjs.org/), while also showing some of the handy commands I use to bootstrap my projects.

Create your project directory.

```
mkdir npmtest
```

Change to the directory you just created.

```
cd !$
```

Tell git to make a repo.

```
git init
```

Pull down a preconfigured `.gitignore` file for node projects from github.

```
wget https://raw.githubusercontent.com/github/gitignore/master/Node.gitignore -O .gitignore
```

Pull down a basic `Makefile` I use for my projects.

```
wget https://gist.github.com/wolfeidau/8748317/raw/172a6adb79777676a8815da5719ef659fb66a35b/Makefile
```

This make file contains a few handy targets, these are:

* `test` runs tests in the `test` folder using the [mocha](http://visionmedia.github.io/mocha/) test framework.
* `jshint` uses [jshint](http://www.jshint.com/) to check over the code.
* `skel` generates a basic structure for my project creating `index.js` and, `lib`, `example` and `test` directories and installs mocha and [chai](http://chaijs.com) the BDD / TDD assertion library.
* The default target which is invoked by just running `make`, this runs the `jshint` and `test` targets.

*Note:* You will need to install jshint globally using `npm install -g jshint`.

Now we will use the `skel` target to generate our project structure.

```
make skel
```

Create a project on github using [hub](https://github.com/github/hub), if your on osx you can install this with [homebrew](https://github.com/Homebrew/homebrew). We do this sooner rather than later so npm can pick this information up when building the `package.json`.

```
hub create
```

Now initialise your project.

```
npm init
```

This should ask for a bunch of information, note leave the version 0.0.0 we will change this later. For those interested this is driven by [init-package-json](https://github.com/npm/init-package-json).

```
...
name: (npmtest)
version: (0.0.0)
description: Some NPM test.
entry point: (index.js)
test command: make test
git repository: (git://github.com/wolfeidau/npmtest.git)
keywords: npm
author: Mark Wolfe <mark@wolfe.id.au>
license: (ISC) MIT
About to write to /Users/markw/Code/Javascript/npmtest/package.json:

{
  "name": "npmtest",
  "version": "0.0.0",
  "description": "Some NPM test.",
  "main": "index.js",
  "scripts": {
    "test": "make test"
  },
  "repository": {
    "type": "git",
    "url": "git://github.com/wolfeidau/npmtest.git"
  },
  "keywords": [
    "npm"
  ],
  "author": "Mark Wolfe <mark@wolfe.id.au>",
  "license": "MIT",
  "bugs": {
    "url": "https://github.com/wolfeidau/npmtest/issues"
  },
  "homepage": "https://github.com/wolfeidau/npmtest"
}

Is this ok? (yes) yes
```

Once you have added some code to `index.js` and some tests of course, add and commit your code.

```
git add .
git commit -a 'Initial release'
```

Now your ready to release use npm to update the version. There are three options for this command being `major`, `minor` and `patch` each of which increments the version numbers in that order. In the example below we should go from `0.0.0` to `0.1.0`.

```
npm version minor
```

Run your tests!

```
npm test
```

Push to github, the version command automatically tags your project so we can check it out if we need!

```
git push origin master --tags
```

Ship it.

```
npm publish
```
