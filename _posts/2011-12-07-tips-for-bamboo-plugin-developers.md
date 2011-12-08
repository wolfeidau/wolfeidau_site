---
layout: post
title: Tips for bamboo plugin developers
category: Atlassian, Bamboo, Java, Ruby
---

Having recently developed a plugin ([Ruby Rake Plugin](https://plugins.atlassian.com/plugin/details/770964)) for Atlassian's [Bamboo](http://www.atlassian.com/software/bamboo/overview) continuous integration (CI) server I thought I would put together a list of tips for those looking to do the same. As there are some great documents provided by Atlassain on how to get started with plugin development I am not going to go into a lot of detail in this area, it is assumed you already messed around a bit with the [Plugin SDK](https://developer.atlassian.com/display/DOCS/Developer+Quick+Start).

So to start with there are some things you should learn before beginning:

# Maven

The entire plugin development kit revolves around it so you need to understand it. 

The first thing I do when coming back to maven is practice the release process, for most developers this is one of the most frustrating and complicated areas of maven so practice it. 

Generate a fictional Java project using the basic archetype, and push it up to my version control site of choice which is either [bitbucket](http://bitbucket.org/) or [github](http://github.com) and work through the development cycle. Make a few changes check them in and then perform a release, this process normally takes me a few goes to get all the settings right in maven but eventually I get back into the swing of it. I recommend you use this project to familiarise yourself with the release process after any long breaks as well, this will ensure maven hasn't change since you last did it.

Once you have created your plugin project ensure you fill out all the relevant meta information in your maven pom file, as seen in the sample below. In addition to it being a good practice to do so this information can be used by maven plugins you may include in your project in the future.

{% highlight xml %}

    <description>This is the ruby rake plugin for Atlassian Bamboo.</description>

    <organization>
        <name>Mark Wolfe</name>
        <url>http://www.wolfe.id.au/</url>
    </organization>

    <developers>
        <developer>
            <name>Mark Wolfe</name>
            <email>mark@wolfe.id.au</email>
        </developer>
    </developers>

    <licenses>
        <license>
            <name>Apache 2</name>
            <url>http://www.apache.org/licenses/LICENSE-2.0.txt</url>
            <distribution>repo</distribution>
            <comments>A business-friendly OSS license</comments>
        </license>
    </licenses>

{% endhighlight %}

Next thing I do is run a few maven commands on my newly minted plugin project to pull down the internet, this involves running the following commands and going to get lunch. Note as I do all my development on Unix systems the command will only work in those environments.

{% highlight bash %}
atlas-mvn clean && atlas-mvn test && atlas-mvn integration-test && atlas-mvn install
{% endhighlight %}

Once completed you should have most of the stuff you need.

# The Java Ecosystem

A small part of which maven has downloaded to your system is what your will be using to do most of the work in your plugin. So you should do a little bit of reading on the libraries which you will be using in this project.

* [Google Collections](http://code.google.com/p/guava-libraries/), in my view one of the core libraries which a Java developer should know.
* [SLF4J](http://www.slf4j.org/), one of the many logging abstractions which are used in Java projects but the one I tend to prefer.
* [Apache Commons Lang](http://commons.apache.org/lang/), this library has quite a few utility classes for manipulating strings as well as builders for toString and equals methods in classes.
* [Spring Framework](http://www.springframework.org), most of the Atlassian products are built using this dependency injection framework so it is handy to understand a bit of how this works.
* [JUnit](http://junit.org), this unit testing framework has been around for a long time for good reason, learn how to use it.
* [Mockito](http://code.google.com/p/mockito/), because mocking is a BIG must when building something in a large application so learn this API and ensure it is included in your plugin project from the start.

I myself are a big proponent of the old saying "When in Rome, do as the Romans do", for this reason I will always try and use the libraries which are already in the SDK.

# Development process

This is one of the areas which is often left up to the developers themselves to manage so for this reason I typically follow a simple process, especially when I am working on open source projects.

1. Before you start write down what you want to achieve, keep things simple and don't plan world domination at this stage.
2. Build a first release focusing on the goals more than the method, the goal is to prove the concept and most important *ship it*.
3. Do some research now that you know what you looking for, read other peoples code and hack on your initial release a bit.
4. Delete your code, start the whole thing again, this sounds nuts but your proof of concept code is probably best left behind (see [Corey Haines Code Retreat](http://coderetreat.com/)).
5. Build a new release from scratch with more of a focus on structure, testing and extensibility, and again *ship it*.


