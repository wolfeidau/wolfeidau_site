---
layout: post
title: Getting a new node project started with npm
tags:
 - NodeJS
 - npm
 - git
 --
This guide will hopefully help those getting started with node use npm to kickstart their projects.

Create your project directory.

{% highlight bash %}
mkdir npmtest
{% endhighlight %}

Change to the directory you just created.

{% highlight bash %}
cd !$ 
{% endhighlight %}

Tell git to make a repo.

{% highlight bash %}
git init
{% endhighlight %}

Pull down a git ignore file from github.

{% highlight bash %}
wget https://raw2.github.com/github/gitignore/master/Node.gitignore -O .gitignore
{% endhighlight %}

Pull down a basic Makefile I use for my projects.

{% highlight bash %}
wget https://gist.github.com/wolfeidau/8748317/raw/172a6adb79777676a8815da5719ef659fb66a35b/Makefile
{% endhighlight %}

Use the make file to generate a skeleton project.

{% highlight bash %}
make skel
{% endhighlight %}

Create a project on github using [hub](https://github.com/github/hub), if your on osx you can install this with [homebrew](https://github.com/Homebrew/homebrew).

{% highlight bash %}
hub create
{% endhighlight %}

Now initialise your project.

{% highlight bash %}
npm init
{% endhighlight %}

This should ask for a bunch of information, note leave the version 0.0.0 we will change this later. For those interested this is driven by [init-package-json](https://github.com/npm/init-package-json).

{% highlight bash %}
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
{% endhighlight %}

Once you have added some code to `index.js` and some tests of course, add and commit your code.

{% highlight bash %}
git add .
git commit -a 'Initial release'
{% endhighlight %}

Now your ready to release use npm to update the version. There are three options for this command being `major`, `minor` and `patch` each of which increments the version numbers in that order. In the example below we should go from `0.0.0` to `0.1.0`.

{% highlight bash %}
npm version minor
{% endhighlight %}

Run your tests!

{% highlight bash %}
npm test
{% endhighlight %}

Push to github, the version command automatically tags your project so we can check it out if we need!

{% highlight bash %}
git push origin master --tags
{% endhighlight %}

Ship it.

{% highlight bash %}
npm publish
{% endhighlight %}
