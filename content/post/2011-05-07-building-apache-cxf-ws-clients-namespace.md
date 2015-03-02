+++
date = "2011-05-07T00:00:00+11:00"
draft = false
title = "Building Apache CXF web service clients namespace mapping"
categories = [ "Apache CXF" ]

+++

Recently I have been doing quite a bit of work around [Apache CXF](http://cxf.apache.org/), both on the server side and the client side. Over the next few weeks I will post some of the tricks I have learnt.


In this post I will summarise one of the [cxf-codegen-plugin](http://cxf.apache.org/docs/maven-cxf-codegen-plugin-wsdl-to-java.html) options I used to assist me while consuming WCF web services using Apache CXF. When dealing with WCF based services, and indeed any WSDL which uses more than one namespace it is handy knowing how to control name spaces and how these translate into packages in your java stubs.

When consuming WCF services you may encounter either the default namespace for services which is _tempura.org_, or more commonly, one more custom name spaces configured by the developer. 

Below is an example of using selective namespace mappings by specifying the -p option in the cxf-codegen-plugin. This switch instructs wsdl2java to map all xml objects in a given namespace into the java package supplied.

So if we had a WCF based registration service which included the following namespaces:
* http://schemas.datacontract.org/2004/07/System
* http://schemas.datacontract.org/2004/07/Wolfeidau.Model
* http://wolfe.id.au/services/

Only the  http://wolfe.id.au/services/ would be mapped into _au.id.wolfe.services.registration_ java package.

The reason this is done is typically to avoid name clashes and issues with overlapping data objects used by more than one service in the one namespace.

{{< highlight xml >}}
<!-- Generate client using WSDL -->
<plugin>
  <groupId>org.apache.cxf</groupId>
  <artifactId>cxf-codegen-plugin</artifactId>
  <version>2.4.0</version>
  <executions>
    <execution>
      <id>generate-sources</id>
      <phase>generate-sources</phase>
        <configuration>
        <sourceRoot>${basedir}/target/generated/src/main/java</sourceRoot>
          <wsdlOptions>
            <wsdlOption>
              <wsdl>http://wolfe.id.au/services/registration?WSDL</wsdl>
              <serviceName>RegistrationService</serviceName>
              <extraargs>
                <extraarg>-client</extraarg>
                <extraarg>-verbose</extraarg>
                <extraarg>-p</extraarg>
                <extraarg>http://wolfe.id.au/services/=au.id.wolfe.services.registration</extraarg>
              </extraargs>
            </wsdlOption>
          </wsdlOptions>
        </configuration>
        <goals>
          <goal>wsdl2java</goal>
        </goals>
    </execution>
  </executions>
</plugin>
{{< /highlight >}}

As most of the samples on the Apache CXF website are in opinion way to simplistic, I am putting together some more extensive client and server samples which I will post up on [wolfeidau Github](http://github.com/wolfeidau) soon.