---
title: "Diving into AWS Billing Data"
date: 2022-07-05T22:47:59+10:00
tags: [ "AWS", "Athena", "data science" ]
draft: false
---

Billing is an integral part of day to day [AWS](https://aws.amazon.com/) account operation, and to most it seems like a chore, however there is a lot to be learnt interacting with [AWS Billing](https://aws.amazon.com/aws-cost-management/aws-billing/) data. 

So why would you ever want to dive into AWS Billing data in the first place?

1. It is pretty easy for both novices, and experience developers to rack up a sizable bill in AWS, part of the learning experience is figuring out how this happened.
2. The billing data itself is available in [parquet format](https://parquet.apache.org/), which is a great format to query and dig into with services such as Athena.
3. This billing data is the only way of figuring out how much a specific AWS resource costs, this again is helpful for the learning experience.

These points paired with the fact that a basic understanding of data wrangling in AWS is an invaluable skill to have in your repertoire.

## Recommended CUR Solution

I have put together an automated solution which uses [AWS CloudFormation](https://aws.amazon.com/cloudformation/) to create a [Cost and Usage Reports](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html) (CUR) in your billing account with a [Glue](https://aws.amazon.com/glue/) Table enabling querying of the latest data for each month in [Amazon Athena](https://aws.amazon.com/athena/). This project is on github at https://github.com/wolfeidau/aws-billing-store, follow the `README.md` to get it setup.

In summary it deploys:

1. Creates the CUR in the billing service and the bucket which receives the reports.
2. Configures a Glue Database and Table for use by Athena.
3. Deploys a Lambda function to manage the partitions using  [Amazon EventBridge](https://aws.amazon.com/eventbridge/) [S3 events](https://docs.aws.amazon.com/AmazonS3/latest/userguide/EventBridge.html).

Once deployed all you need to do is wait till AWS pushes the first report to the solution, this can take up to 8 hours in my experience, then you should be able to log into Athena and start querying the data.

{{< figure src="/images/2022-07-02_cur_managment_diagram.png" title="CUR Solution Diagram" >}}

## Next Steps

Once you have the solution in place there are some great resources with queries which provide insights from your CUR data, one of the best is [Level 300: AWS CUR Query Library](https://wellarchitectedlabs.com/cost/300_labs/300_cur_queries/) from the [The Well-Architected Labs website](https://wellarchitectedlabs.com/).

The standout queries for me are:

1. [Amazon GuardDuty](https://wellarchitectedlabs.com/cost/300_labs/300_cur_queries/queries/security_identity__compliance/#amazon-guardduty) - This query provides daily unblended cost and usage information about Amazon GuardDuty Usage. The usage amount and cost will be summed.
2. [Amazon S3](https://wellarchitectedlabs.com/cost/300_labs/300_cur_queries/queries/storage/#amazon-s3) - This query provides daily unblended cost and usage information for Amazon S3. The output will include detailed information about the resource id (bucket name), operation, and usage type. The usage amount and cost will be summed, and rows will be sorted by day (ascending), then cost (descending).