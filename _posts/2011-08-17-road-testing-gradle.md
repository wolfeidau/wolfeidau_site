---
layout: post
title: Road Testing Gradle
category: Java Groovy Gradle
---
For a while I have been tempted to stray from the relative safety of [Maven](http://maven.apache.org) and [Ant](http://ant.apache.org). Every time I fight with these tools, or in the case of maven am stunned and amazed out how simple things can require so much xml, I look over the alternatives wondering if it could be easier. 

After quite a bitter fight with ant at work I decided it was time to give one of thes new contenders a try. As I had recently tinkered on a project which used [Gradle](http://gradle.org/) and found it quite easy to use it seemed like as good a candidate as any.

My road test involved building a multi module project with a sample shared common library, a server library and a REST service. The results of my experiment are located in [agent-manager](https://github.com/wolfeidau/agent-manager) up on github. Overall I found building this project quite enjoyable and using code, albeit groovy which I am not that familiar with, quite refreshing.

After a bit of consideration I would list the pros as follows:

* Good overall documentation
* Dependency management was a breeze
* Great support for generating IDEA projects, and some great options for customising them.
* Nice terse syntax with the ability to follow the Don't Repeat Yourself Mantra(DRY).
* Very flexible build and test configuration, in my example I added a new integration test scope which was completely isolated from the existing unit tests. 
* Very little code required to get a nice project build running.

The cons are as follows:

* Not a lot of plugins, in my case none of the major web service runtimes have a gradle plugin. To be honest I didn't find a lot outside of this projects default ones.
* Some of the syntax errors can be cryptic, especially when you are missing a parameter to a closure.
* Not a lot of good examples.

So overall quite an interesting exercise, in my case I will keep at it as the cons were well and truly outweighed by the pros. I would be happy to recommend Gradle to anyone who is looking for something new, especially on simple java projects. 

If your interested in learning more then have a look over my sample and make sure you checkout the following projects for inspiration.

* [Hibernate Core](https://github.com/hibernate/hibernate-core)
* [Spring Integration](https://github.com/SpringSource/spring-integration)
* [Groovy](http://git.codehaus.org/gitweb.cgi?p=groovy-git.git;a=tree;h=refs/heads/trunk;hb=trunk)
