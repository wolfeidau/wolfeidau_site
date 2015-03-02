+++
date = "2011-05-24T00:00:00+11:00"
draft = false
title = "How to build server with Bamboo and Ubuntu"
categories = [ "Atlassian Bamboo", "Continuous Integration", "Java", "Ubuntu" ]

+++

Recently I have been looking into setting up my own build server, having used Cruisecontrol, Hudson, Teamcity in the passed I wanted to give something new a try. With the recent release of [Bamboo](http://www.atlassian.com/software/bamboo/) 3.1.1 I thought I would see what all the fuss is about. I logged onto [Atlassian's site](http://www.atlassian.com/) and payed my 10 bucks, which much to my delight and respect, goes to charity.


I then spun up a clean [Ubuntu](http://www.ubuntu.com/) server running 10.04.02, yes old trusty Long Term Support release, and ran through the following steps.

First install the Sun Java development kit, I use this in preference over OpenJDK at the moment for QA as it is what I normally deploy to for customers. To install this package we need to modify the `/etc/apt/sources.list` and remove the comments at the start of the lines which include the partner repositories. These look as follows

{{< highlight bash >}}
deb http://archive.canonical.com/ubuntu lucid partner
deb-src http://archive.canonical.com/ubuntu lucid partner
{{< /highlight >}}

Run _apt-get_ to update the cache of packages.

{{< highlight bash >}}
$ sudo apt-get update
{{< /highlight >}}

Then install the dpkg for Sun\Oracle JDK.

{{< highlight bash >}}
$ sudo apt-get install sun-java-jdk
{{< /highlight >}}

I will be using [PostgreSQL](http://www.postgresql.org/) for my database follow the configuration process described in [Ubuntu PostgreSQL Installation Howto](https://help.ubuntu.com/community/PostgreSQL).

Now create a PostgreSQL user and database, note you will be prompted to enter a password for the bamboo user.

{{< highlight bash >}}
$ sudo -u postgres createuser -R -D -S -P -e bamboo
$ sudo -u postgres createdb -O bamboo bamboo_db
{{< /highlight >}}

To test this is login will work fine I use the `psql` command and pass it a hostname to connect to using TCP/IP, this is to ensure our JDBC driver will connect fine.

{{< highlight bash >}}
$ psql -h localhost -U bamboo bamboo_db
Password for user bamboo: 
psql (9.0.4)
SSL connection (cipher: DHE-RSA-AES256-SHA, bits: 256)
Type "help" for help.

bamboo_db=> \q
{{< /highlight >}}

Install tomcat6 using apt, the reason I am using this package rather than the all in from Atlassian is I like my tomcat maintained. Dumping a tomcat in your OS with no one watching your ass is unwise in my opinion.

{{< highlight bash >}}
$ sudo apt-get install tomcat6
{{< /highlight >}}

Rather than just popping the war file into `/var/lib/tomcat6/webapps`, I prefer to externalise the application by extracting the archive into it's own directory under `/var/lib`. I then configure tomcat to load the application from this location. This is done so that I can guarantee tomcat upgrade won't nuke or otherwise disturb my Bamboo installation.

{{< highlight bash >}}
$ sudo mkdir /usr/share/atlassian-bamboo-3.1.1
$ cd /usr/share/atlassian-bamboo-3.1.1
$ sudo jar xvf ~/atlassian-bamboo-3.1.1.war
{{< /highlight >}}

Before we start ensure tomcat is shut down, otherwise it mite go and deploy bamboo before we are ready!

{{< highlight bash >}}
$ sudo /etc/init.d/tomcat6 stop
{{< /highlight >}}

Next we need to configure tomcat to use load this web application, to do this we create navigate to the tomcat configuration directory.

{{< highlight bash >}}
$ cd /var/lib/tomcat6/conf/Catalina/localhost
{{< /highlight >}}

Backup the original `ROOT.xml`, being careful to preserve the permissions.

{{< highlight bash >}}
$ sudo cp -ipv ROOT.xml ROOT.bak
{{< /highlight >}}

Edit file named `ROOT.xml` as root, I will be making my bamboo the ROOT application in this tomcat, in other words served at `http://myserver.com/`. Put the following content in this file. Note you also need to generate a password for your DB login and enter it where the XXXXXXXX is.

{{< highlight xml >}}
<Context path="/" docBase="/usr/share/atlassian-bamboo-3.1.1">

  <Resource name="jdbc/BambooDS" auth="Container" type="javax.sql.DataSource"
            username="bamboo"
            password="XXXXXXXX"
            driverClassName="org.postgresql.Driver"
            url="jdbc:postgresql://localhost:5432/bamboo_db"
            />

</Context>
{{< /highlight >}}

Make the `ROOT.xml` file only readable by the tomcat user to protect the plain text password located within.


{{< highlight bash >}}
$ sudo chmod 600 ROOT.xml
{{< /highlight >}}

Remove the current root web application from tomcats `/var/lib/tomcat6/webapps` directory.


{{< highlight bash >}}
$ sudo rm -r /var/lib/tomcat6/webapps/ROOT
{{< /highlight >}}

Create a data location for bamboo, and change the file permissions so that tomcat6 can write to this location.

{{< highlight bash >}}
$ sudo mkdir /var/lib/atlassian-bamboo
$ sudo chown tomcat6:tomcat6 /var/lib/atlassian-bamboo
{{< /highlight >}}

Now install the PostgreSQL driver in tomcat, to do this first download it to your home directory then copy it to `/usr/share/tomcat6/lib` as follows.

{{< highlight bash >}}
$ cd ~/
$ wget http://jdbc.postgresql.org/download/postgresql-9.0-801.jdbc4.jar
$ sudo cp postgresql-9.0-801.jdbc4.jar /usr/share/tomcat6/lib
{{< /highlight >}}

Modify the `/usr/share/atlassian-bamboo-3.1.1/WEB-INF/classes/log4j.properties` as root, to correct the location of the log file. This in my opinion needs to be a MUST configure item during there installation process otherwise the log file could end up anywhere, for example the PWD of the executing start up script.

Navigate to the line that looks like this.
{{< highlight text >}}
log4j.appender.filelog.File=atlassian-bamboo.log
{{< /highlight >}}

And change it to this.
{{< highlight text >}}
log4j.appender.filelog.File=${catalina.base}/logs/atlassian-bamboo.log
{{< /highlight >}}

Also you will need to configure the bamboo.home in `/usr/share/atlassian-bamboo-3.1.1/WEB-INF/classes/bamboo-init.properties`. This should be changed to the following value. Again this will need to be done as root.
{% highlight text %}
bamboo.home=/var/lib/atlassian-bamboo
{{< /highlight >}}

Before we start tomcat we need to increase the amount of memory available to tomcat as well as some other params. This is done by editing `/etc/default/tomcat6`.

Open the file as root and edit to the following line.
{% highlight text %}
JAVA_OPTS="-Djava.awt.headless=true -Xmx128m"
{{< /highlight >}}

Change it to the following value.
{% highlight text %}
JAVA_OPTS="-server -XX:MaxPermSize=256m -Djava.awt.headless=true -Xmx512m"
{{< /highlight >}}

Now start tomcat and then tail the server log file.

{{< highlight bash >}}
$ sudo /etc/init.d/tomcat6 start
$ tail -f /var/log/tomcat6/atlassian-bamboo.log
{{< /highlight >}}

Now open your browser and to `http://servername:8080/` and follow the prompts.

When prompted for data base, select use datasource and specify the following value.
{% highlight text %}
java:comp/env/jdbc/BambooDS
{{< /highlight >}}

Now I have a nice new [Atlassian](http://atlassian.com) Bamboo server ready to build my software, more on how that goes in future posts.
