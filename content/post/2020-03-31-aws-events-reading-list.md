+++
title = "AWS Events reading list"
date = "2020-03-31T04:30:00+11:00"
tags = [ "AWS", "serverless", "events" ]
+++

For some time now I have been working on internal, and some product related services which use AWS events, some of this has been paired with [AppSync subscriptions](https://docs.aws.amazon.com/appsync/latest/devguide/real-time-data.html), [slack](https://slack.com/) and [AWS SNS](https://aws.amazon.com/sns/). To help everyone come up to speed with events, and async messaging in general in a world of REST and synchronous APIs I have been compiling a list of links, which I thought I would share in a post.

To start out it is helpful to have an overview, this post and the associated talk [Moving to event-driven architectures (SVS308-R1)](https://www.youtube.com/watch?v=h46IquqjF3E) are a good place to start.

* [Tim Bray - Eventing Facets](https://www.tbray.org/ongoing/When/202x/2020/03/07/Eventing-Facets)

Then for those that want to see some code, take a look at the analytics component in this project developed by the serverless team at AWS, there are tons of great infra examples in this project. Although the code is a bit complex there is a lot to garner even if your not a Java developer.

* [awslabs/realworld-serverless-application](https://github.com/awslabs/realworld-serverless-application)

This project uses a great reusable component which takes a [AWS DynamoDB](https://aws.amazon.com/dynamodb) stream and publishes it onto [AWS Eventbridge](https://aws.amazon.com/eventbridge), again if Java isn't your language of choice there are still some gems in here, such as the logic used to [retry submission of events to Eventbridge](https://github.com/awslabs/aws-dynamodb-stream-eventbridge-fanout/blob/master/src/main/java/com/amazonaws/dynamodb/stream/fanout/publisher/EventBridgeRetryClient.java).

* [awslabs/aws-dynamodb-stream-eventbridge-fanout](https://github.com/awslabs/aws-dynamodb-stream-eventbridge-fanout)

From the AWS Samples comes this project which is worth digging into, it has a bunch of simple examples with diagrams which are always a plus.

* [aws-samples/aws-serverless-ecommerce-platform](https://github.com/aws-samples/aws-serverless-ecommerce-platform/tree/master/orders)

To enable some experimentation and development this CLI tool is pretty handy.

* [spezam/eventbridge-cli](https://github.com/spezam/eventbridge-cli)

As I go I will add links and happy to take suggestions.