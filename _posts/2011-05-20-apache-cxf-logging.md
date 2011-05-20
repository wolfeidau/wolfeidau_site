--- 
layout:   post
title:    Apache CXF Logging Configuration
category: Apache CXF, Logging
---

Configuring logging in [Apache CXF](http://cxf.apache.org) can be confusing at first, in my view this is further compounded by Apache Tomcat's logging architecture. 

When I want to set up logging in a Apache CXF application my basic configuration is:

In addition to this is required configuration at the operating system level to roll, compress and archive these log file.

In my cxf based projects the first step is to use the [logging configuration available in 2.2.8 or later](http://cxf.apache.org/docs/debugging-and-logging.html#DebuggingandLogging-UsingSLF4JInsteadofjava.util.logging%28since2.2.8%29). This enables you to configure your logger of choice for the entire CXF stack. Needless to say I really like this feature as I am not a big fan of java.util.logging as it's configuration is not very intuitive.

First step is to change all logging in CXF to my logging stack of choice which is [sl4j](http://www.slf4j.org/) and [logback](http://logback.qos.ch/). As per the CXF documentation I added a file named _org.apache.cxf.Logger_ in my maven web application project located at _src/main/resources/META-INF/cxf_. This file contained just the following string.
{% highlight text %}
org.apache.cxf.common.logging.Slf4jLogger 
{% endhighlight %}

I also add the following dependencies to my maven projects _pom.xml_.

{% highlight xml %}
<!-- This is to override spring's dependence on apache commons logging -->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>jcl-over-slf4j</artifactId>
    <version>1.5.11</version>
</dependency>

<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
    <version>1.5.11</version>
</dependency>

<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-core</artifactId>
    <version>0.9.19</version>
</dependency>

<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
    <version>0.9.19</version>
</dependency>
{% endhighlight %}

And I configure a basic logback configuration within in _logback.xml_ located in my web projects _src/main/resources_ directory.

The main aims of this are:
* Summary log file with only warnings and errors.
* Trace file containing all web service messages.

The main reason for separating WS messages into a trace file is to keep the application log file down to an easy to handle size. This is especially helpful for systems which handle large web service messages. Also you may want to roll the trace file at a different interval than the application log.

{% highlight xml %}
<configuration>

    <!-- Just used while running in process while developing -->
    <appender name="STDOUT"
              class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>
                %d{HH:mm:ss.SSS} [%thread] %-5level %logger{5} - %msg%n
            </pattern>
        </encoder>
    </appender>

    <!-- This is just for contents of web service operations and can get quite large -->
    <appender name="WSLOGFILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${catalina.home}/logs/mpw-message-trace.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- daily rollover -->
            <fileNamePattern>${catalina.home}/logs/mpw-message-trace.%d{yyyy-MM-dd}.log</fileNamePattern>
        </rollingPolicy>
        <encoder>
            <pattern>
                %d{HH:mm:ss.SSS} [%thread] %-5level %logger{5} - %msg%n
            </pattern>
        </encoder>
    </appender>

    <!-- Used for application logging to which when deployed is quite terse and restricted to warnings typically -->
    <appender name="APPLOGFILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${catalina.home}/logs/mpw.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- daily rollover -->
            <fileNamePattern>${catalina.home}/logs/mpw.%d{yyyy-MM-dd}.log</fileNamePattern>
        </rollingPolicy>
        <encoder>
            <pattern>
                %d{HH:mm:ss.SSS} [%thread] %-5level %logger{5} - %msg%n
            </pattern>
        </encoder>
    </appender>

    <logger name="org.apache.cxf" level="INFO"/>
    <logger name="org.springframework" level="INFO"/>

    <!-- Set additivity to false when deployed -->
    <logger name="org.apache.cxf.interceptor" additivity="true">
        <appender-ref ref="WSLOGFILE"/>
      </logger>

    <root level="INFO">
        <!-- STDOUT is normally this is removed when deployed as it ends up in tomcat server logs -->
        <appender-ref ref="STDOUT"/>
        <appender-ref ref="APPLOGFILE"/>
    </root>

</configuration>
{% endhighlight %}

For a more complete sample you can look over the sources to [maven-project-wizard](https://github.com/wolfeidau/mvn-project-wizard/) on [github](http://github.com).