+++
date = "2011-05-22T00:00:00+11:00"
draft = false
title = "Using Jackson with Apache CXF"
categories = [ "Apache CXF", "JSON", "Data Mapping" ]

+++

Whilst working on my Javascript, [ExtJS 4](http://www.sencha.com/products/extjs/) and [Apache CXF](http://cxf.apache.org) skills I came across a solution to a problem I encountered getting ExtJS to talk to Apache CXF using JSON. 

The basis for this issue revolves around "wrapping" in JSON and two different schools on what is correct way to encode it. As far as I can see there is the more verbose version which Jettison, the default JSON serialiser in Apache CXF produces, then there is the "unwrapped" version which the alternate serialiser [Jackson](http://jackson.codehaus.org/) produces.


In my case I chose Jackson the more terse version, this is good for a couple of reasons:
* It is compatible with ExtJS without any modifications
* It is smaller and therefore produces less data on the wire.

Also I like the annotations that Jackson comes with, and find it a bit easier to work with than Jettison.

So to enable Jackson I modify my projects [Maven](http://maven.apache.org) pom file I add the following dependency.

{{< highlight xml >}}
<dependency>
    <groupId>org.codehaus.jackson</groupId>
    <artifactId>jackson-jaxrs</artifactId>
    <version>1.5.7</version>
</dependency>
{{< /highlight >}}

In addition to this some changes are required in the spring configuration which houses our RESTful services. In the following excerpt from my spring configuration, I have declared the _jsonProvider_ then set it as one of the providers _jaxrs:server_.

{{< highlight xml >}}
<bean id="jsonProvider" class="org.codehaus.jackson.jaxrs.JacksonJsonProvider"/>

<jaxrs:server id="restServices" address="/">
        <jaxrs:serviceBeans>
            <ref bean="projectService"/>
        </jaxrs:serviceBeans>
        <jaxrs:providers>
            <ref bean="jsonProvider"/>
        </jaxrs:providers>
        <jaxrs:features>
            <cxf:logging/>
        </jaxrs:features>
</jaxrs:server>
{{< /highlight >}}

Once Jackson was enabled my ExtJS JSON driven data stores were functioning perfectly, aside from dates. Jackson's default behaviour for serialisation of a _java.util.Date_ is to convert it to milliseconds since EPOC. To do this I used a feature in spring known as compound property names, this enabled me to instantiate an instance of the mapper, then override the _serializationConfig.dateFormat_ to configure the mapper to produce ISO 8601 dates. This shown in the following excerpt which illustrates the updated _jsonProvider_ using the reconfigured _jacksonMapper_.

{{< highlight xml >}}
<bean id="jacksonMapper" class="org.codehaus.jackson.map.ObjectMapper">
  <property name="serializationConfig.dateFormat">
    <bean class="java.text.SimpleDateFormat">
      <constructor-arg value="yyyy-MM-dd'T'HH:mm:ss.SZ"/>
    </bean>
  </property>
</bean>

<bean id="jsonProvider" class="org.codehaus.jackson.jaxrs.JacksonJsonProvider"
    p:mapper-ref="jacksonMapper"/>
{{< /highlight >}}

The result of this is shown in the following JSON sample which illustrates how a project object containing some dates is encoded.

{{< highlight javascript >}}
{
    success: true
    message: "Project found."
    data: {
        artifactId: "bobtheapp"
        groupId: "au.id.wolfe.bta"
        inceptionYear: "2011"
        organization: null
        developers: null
        dateAdded: "2011-05-21T20:34:15.862+1000"
        dateUpdated: "2011-05-21T20:34:15.862+1000"
        version: "1.0.0"
    }
}
{{< /highlight >}}

So after another journey off track back to hacking on my project.
