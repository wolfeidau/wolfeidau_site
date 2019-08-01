+++
title = "Serverless Background jobs part 1"
date = "2019-05-11T12:00:47+10:00"
tags = [ "serverless", "development", "aws", "step functions" ]
draft = false
+++

Background jobs form the backbone of a lot of modern applications, they are used to perform a range of asynchronous tasks, from image processing through to order processing, fulfillment and shipping. Wherever there is a need to dispatch some sort of task, then monitor or wait for it's result.

In the serverless space AWS Step Functions play a similar role to projects such as [delayed job](https://github.com/collectiveidea/delayed_job) or [resque](https://github.com/resque/resque) in ruby, [celery](http://www.celeryproject.org/) in python, but with the following differences:

* Built on a flexible flow definition language called [Amazon States Language](https://states-language.net/spec.html) which is written in JSON
* Powered by lambda, with native integration to SNS, SQS, Kinesis and API Gateway
* Fully Managed by AWS

# Step Functions?

AWS Step Functions provides a way of executing flows you have defined, and provides a visual representation, like a CI pipeline, showing the current state of the execution. 

A simple task management example which polls the status of a task, and reports completion status can be seen as follows:

![Step Function Example](/images/2019-05-11_stepfunction.png)

# Why Step Functions?

So this is great but why should we decompose our workflows into functions and glue them together using a managed service? 

There are a number of things to be gained by moving to Step Functions:

1. Testing, you will be able to test each element in the chain and make sure it performs it's discreet task.
2. Decoupling, you will have broken things down into pieces of code which can be refactored, or replaced independent of each other.
3. Monitoring, given the visual nature of these pipelines you will be able to zero in on failures faster.

Step Functions aren't the answer to every problem, but for multi step, long running jobs they are a great solution, if your fluent in the AWS ecosystem.

