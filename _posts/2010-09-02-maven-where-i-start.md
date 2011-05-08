--- 
layout:   post
title:    Maven, where I start
category: Apache Maven
---
More often than not today I start my Java projects using an [Apache Maven](http://maven.apache.org) archetype. Whether it be for an [Apache CXF](http://cxf.apache.org) based web service, a simple web application or some sort of service most are started from an archetype.

However pretty much every project I need to add my secret project ingredients, this typically starts with a couple of key plug-ins:
* [maven-checkstyle-plugin](http://maven.apache.org/plugins/maven-checkstyle-plugin/) – I really like to know when my code is a mess, even if it does annoy some people.
* [maven-license-plugin](http://code.google.com/p/maven-license-plugin/) – Again I like stuff neat so getting everything tagged under a license is pretty important.

I have extracted a sample of my default configuration to illustrate how these plug-ins are configured in the pom.xml.

{% highlight xml %}
<build>
    <plugins>
      <plugin>
        <groupId>com.mycila.maven-license-plugin</groupId>
        <artifactId>maven-license-plugin</artifactId>
        <configuration>
          <properties>
            <owner>Mark Wolfe</owner>
            <year>${project.inceptionYear}</year>
            <email>mark.wolfe@wolfe.id.au</email>
          </properties>
          <header>${basedir}/src/main/etc/header.txt</header>
        </configuration>
      </plugin>
    </plugins>
  </build>
  <reporting>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-checkstyle-plugin</artifactId>
        <configuration>
          <consoleOutput>true</consoleOutput>
          <configLocation>${basedir}/src/main/etc/checkstyle.xml</configLocation>
          <enableRulesSummary>true</enableRulesSummary>
        </configuration>
      </plugin>
    </plugins>
  </reporting>
{% endhighlight %}

At a minimum that gets me up and running with plug-ins, next thing I like to tidy up is the header of the pom file. This typically starts by updating all the developer information setting my website URL and adding my details.

{% highlight xml %}
<inceptionYear>2010</inceptionYear>
<organization>
  <name>Mark Wolfe</name>
  <url>http://www.wolfe.id.au/</url>
</organization>
<developers>
  <developer>
    <name>Mark Wolfe</name>
    <email>mark@wolfe.id.au</email>
    <timezone>+10</timezone>
    <roles>
      <role>architect</role>
      <role>developer</role>
    </roles>
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
  
So that pretty much completes my maven kick start configuration post, for more detailed example see my [fxAssetman](https://github.com/wolfeidau/fxAssetman) muck around project on github.