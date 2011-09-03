---
layout: post
title: JIRA and the not so great new installer
category: JIRA Linux Packaging
---
The following post is a review of the new installer added in 4.4 of Atlassian JIRA. It details my experience with this installer and provides some advice on how to improve it.

Since it's recent release I have seen quite a few posts praising the new JIRA installer so I decided to give it a try at work. First thing that struck me when I went to download it was the linux version was a single file, no deb or RPM(s).

I copied the file to the Linux server and logged in as the jira user I wanted to run the service under, and ran the installer. The first thing the installer did was inform me I wasn't running as an administrator, and as such it wouldn't install a startup file for the JIRA. As this was a VM I took a snapshot and decided to try running it as root. When I did it asked me a couple of questions about where I would to put parts of the installation and then went off and did it's thing. Once it completed I examined what it had done, these were the results:

1. Created a jira1 user.
2. Installed a startup script in _/etc/init.d_.
3. Installed a version of tomcat.
4. Installed a version of Java.

The first point is quite amusing as I already had a user called jira on the system and rather than ask me whether it should use it, it went and created jira1. Now most installers I have run recently at least had the decency of telling me before adding a user to my system, especially when they discover their preferred user id is currently in use. I also noted rather than set the user's home directory to the location of the services working data it had just used the default add user leaving a pretty much unused home directory in _/home_. Overall user creation and use could be much better.

The second point was fine until I opened the script, when I did I was astounded to find a very brief script as follows:

{% highlight bash %}
#!/bin/bash

# JIRA Linux service controller script
cd "/opt/atlassian/jira/bin"

case "$1" in
    start)
        ./start-jira.sh
        ;;
    stop)
        ./stop-jira.sh
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
{% endhighlight %}

Now there are a numerous issues with this init script, firstly changing directory within a startup script and then running a script in the current working directory is a big no no, not only is it a potential security hole waiting to happen, it is also just plain bad form. In the case of tomcat itself there are a couple of system variables which instruct it where it's base files are and where it's working data is located. Using these variables removes the need for change directory (CD) in scripts and is much safer.

This script also not using any of the nice shell functions present in most linux distributions, for instances the linux standard base (LSB) functions which identify the distribution of Linux this script is running on, or the daemon functions which help run your service. Even worse is the fact this init script also calls another script which changes user context, then calls another script which starts the JVM. The tragedy of this multilayered shell abomination is further compounded by the fact the last script in the chain is just the default tomcat _catalina.sh_ script.

The _catalina.sh_ this script is a good script, however it is quite a generalised script primarily designed for use during development. All that is really required to start tomcat correctly is a small piece at the end of this script with paths configured based on the installation, along with some tuning for the application and the user it is to run under. As previously mentioned this is all typically available in shell functions within the init system.

The third point is a one of the ones I really have an issue with, the installer has put an unknown version of tomcat onto my system. As tomcat is a web server it is unfortunately targeted for exploitation, and does have the odd security issue. This would be ok if you ensured I had a method of updating said tomcat but alas you just dump it in your location of choice and leave me holding the baby. Note upon searching I noted tomcat bundled with JIRA, which is version 6.0.32, does indeed have a few [security advisories](http://tomcat.apache.org/security-6.html), not a good start.

And lastly this installer has gone and dumped another copy of java on my system, again with no information on what version this is, and again no way of upgrading it if there is any security exploit for it. So overall not very impressed at all with this new installer.

Overall I think what astounds me most is that a company of this size is completely ignoring recognised best practices when packing software for Linux. Considering the customers who know least about linux are most likely to use this installer blissfully unaware of the traps it has dragged them into I am very disappointed.

Now as I am continually reminded by my boss, if I am going to take the time to present issues I should always accompany it with some suggested solutions to them. So my suggestions are as follows:

1. Work out what linux distributions your customers are running.
2. Review how each of these distributions package their software, in general be a good citizen in these operating systems.
3. Set up a couple of repositories for packages tuned for ease of deployment on the main couple of distributions. Essentially make it as easy as possible for a novice user to deploy and *update* your products using these distribution points.
4. Write a nice init script following the best practices promoted by each distribution.
5. Break your system into it's distinct components, in a similar way to how you modularise your software, pull the system down to a few discreet packages, ideally with upstream version numbers.
6. Offer updates to these packages to ensure your customers data is secure.

One of things I respect about Microsoft and Apple is they have a *keen* focus on ensuring people who deploy their products look like wizards, a few clicks and everything is up and running. In my opinion the user experience for the person installing and maintaining this software is as important as the end user. In a lot of cases this person has the potential to be one of Atlassian's greatest assets, so please don't mess them around.

As Atlassian has had some quite high profile compromises, for example the [Apache foundations JIRA](https://blogs.apache.org/infra/entry/apache_org_04_09_2010) incident I would have assumed that providing a secure method to install and operate their software would be at the top of their priority list.

Lastly I am always happy to sit down and have a chat with anyone from Atlassian, preferably over a cold beer. I have been using their products for 8 or 9 years, yes I even had a support request responded to by one of the founders. Atlassian's products have served me and my customers well so this is the least I could do.