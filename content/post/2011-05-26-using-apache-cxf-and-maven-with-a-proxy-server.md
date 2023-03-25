+++
date = "2011-05-26T00:00:00+11:00"
draft = false
title = "Using Apache CXF And Maven With a Proxy Server"
categories = [ "Apache CXF", "Java", "Proxy", "Web Services" ]

+++

I discovered a couple of interesting issues when using [Apache CXF](http://cxf.apache.org) and [Maven](http://maven.apache.org) behind a proxy this week. It started when I sent out a package of stubs in a Maven project I had built to enable developers of integration systems to regenerate there own stubs from the live WSDL. This project uses the [wsdl2java](http://cxf.apache.org/docs/wsdl-to-java.html) tool from Apache CXF to generate some JAX-WS based SOAP stubs from the WSDL hosted on a staging server on the internet. When run on one of the developers sites it became apparent that the Maven [cxf-codegen-plugin](http://cxf.apache.org/docs/maven-cxf-codegen-plugin-wsdl-to-java.html) doesn't pass through the already configured Maven proxy settings to wsdl2java, this was a bit annoying.


So being a happy consumer of open source software, I had a browse over the sources to Apache CXF tools and discovered the method for retrieval of the WSDL files was using `java.net.URL`. To enable a proxy server for use by this class is as simple as passing some extra switches to the _mvn_ command as in the following example.

```
$ mvn -Dhttp.proxyHost=proxy -Dhttp.proxyPort=8080 package
```

Once we had overcome this issue we hit another interesting hurdle. My integration tests in this Maven project were using the spring configuration method, these were also failing. Turns out we also needed to set the proxy in the Apache CXF configuration as well. This was done using a conduit as follows.

```xml
<http-conf:conduit name="*.http-conduit">
    <http-conf:client ProxyServer="squid.wolfe.id.au" ProxyServerPort="3128"/>
</http-conf:conduit>
```

So in summary if your working behind a proxy server building web services projects using Maven and Apache CXF you will need to do the following.

Configure a proxy in your Maven configuration so that assets can be retrieved, this is done as follows in your `settings.xml`.

```xml
     <proxy>
       <id>optional</id>
       <active>true</active>
       <protocol>http</protocol>
       <host>squid.wolfe.id.au</host>
       <port>3128</port>
       <nonProxyHosts></nonProxyHosts>
     </proxy>
```

Whenever you invoke any tests or calls which invoke `wsdl2java` you will need to pass the proxy settings in as previously described.

```bash
$ mvn -Dhttp.proxyHost=proxy -Dhttp.proxyPort=8080 package
```

When running any tests or routines which use Apache CXF driven web services you will need the conduit configured, in this example it is global and applies to all http connections.

```xml
<http-conf:conduit name="*.http-conduit">
    <http-conf:client ProxyServer="squid.wolfe.id.au" ProxyServerPort="3128"/>
</http-conf:conduit>
```

So there is no confusion about which libraries I am they are:
* Maven 2.2.1
* Apache CXF 2.4.0
* Sun\Oracle Java 1.6_24

So overall a frustrating day, but I won in the end, now all i need to do is incorporate all this information in my project so the onsite developer can work. Hopefully this post helps someone people that run into the same issues.
