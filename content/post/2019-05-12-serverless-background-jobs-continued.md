+++
title = "Serverless Background jobs part 2"
date = "2019-05-12T12:00:47+10:00"
tags = [ "serverless", "development", "aws", "step functions" ]
draft = false
+++

Step Functions allow you to build pipelines involving one or more amazon, or external service. Some examples of this are:

* complex customer on boarding processes jobs which provision resources then send a welcome email
* billing jobs where you may need wait for payment authorisation
* provisioning users and setup of any resources each user may need

## pipeline

> In software engineering, a pipeline consists of a chain of processing elements (processes, threads, coroutines, functions, etc.), arranged so that the output of each element is the input of the next; the name is by analogy to a physical pipeline.

The term pipeline is used a lot in building of software, but can refer to any chain of tasks. 

Over the last couple of years I have used Step Functions in a range of business applications, initially with mixed success due to service limitations and trying to fit complex "new requirements" into the model. Over time this changed as I better understand where step functions start and end. 

I have put together a list of tips and recommendations for those using step functions.

### Start Small

Practice with a few small workflows to get started, avoid building a [Rube Goldberg machine](https://en.wikipedia.org/wiki/Rube_Goldberg_machine). This means starting with something you already know and refactoring it to incorporate a step function, get used to tracing issues and make sure you have all the tools and experience to operate a serverless application.

### Track Executions

Include a correlation id in all flow execution payloads, this could be seeded from Amazon correlation id included with all API gateway calls. This correlation id may be used for reruns of the state machine so don't use it as the execution name.

### Naming Things

Execution name should include some hints to why the flow is running, with a unique id or timestamp appended.

Step names should clearly indicate what this step does as this will enable devs or operations identify where errors or mistakes are occurring.

### Exception Handling

When using [Lambda](https://aws.amazon.com/lambda/) functions make sure you use an exception tracker such as [bugsnag](https://www.bugsnag.com/) or [sentry](https://sentry.io/welcome/) to make fault finding easier. This allows you to track issues over time and avoids sifting through logs looking for errors.

Use the retry backoff built into each step to make your flows more robust.

### Logging

Emit structured logs with key start and end information and use [cloudwatch](https://aws.amazon.com/cloudwatch/) to search capture metrics, and trigger alerts based on them.

### Infrastructure Automation

As an infrastructure engineer I use Step Functions to build and deploy a number of different applications, this is mainly where:

1. The task happens often
2. Someone owns the infrastructure and integration is required to orchestrate with external systems
3. There are a lot of "services" of a similar shape which need to be deployed the same way

When using cloudformation make sure you use change sets, this will allow you to:

1. Print a nice list of what will change before performing a change or create.
2. Rollback in a nicer way

When cloudformation changes fail try to collect the tail of the execution events to simplify fault finding.

When designing flows make sure they aren't too generic, their structure should reflect what your automating, similar to an [ansible](https://www.ansible.com/) playbook.

Build up a task modules to interface with cloudformation, and whenever possible just use that with custom cloud formation tasks.

Build up a library of common tasks, which can be used by lambdas. Test these thoroughly using unit and integration tests.

Use common sense when managing common code, don't dump everything in there, keep to just the most important tasks. This just results in a teams or systems having a massive boat anchor holding back, and contributing to the fragility of the entire platform.