+++
title = "What you should consider when storing datasets s3"
date = "2024-04-11T22:07:22+10:00"
tags = ["AWS", "s3", "Cloud", "Data Engineering"]
+++

As an AWS developer I am often asked what is the best way to organise datasets in S3, this could be data exported by business systems, or data emitted by AWS services.

Way to often I have seen data just dumped in one massive S3 bucket, and left for someone else to tidy up later, however with a little consideration, and empathy for those dealing with this in the future, we can do better than this.

# Start By Asking a few questions

When I am planning to store a dataset in s3 I typically ask a few questions, one thing to note is I am focusing on the semantics of the data, and the business, not just the bucket(s) configuration!

## Who will consume this information?

What I am trying to understand here is whether this dataset has any known consumers, with the AWS logs example, this may be an ingestion tool like splunk, which is easier to integrate with if there a few aggregate buckets. 

For datasets which are exported from other systems, or transformed for use in an application, or with an integration it may be easier to combine them one bucket, especially if other factors I cover in the next few questions aren't a concern.

## What is the classification for the data?

My goal here is to consider the sensitivity of the data, and how it could affect who is granted access. 

Keeping sensitive datasets isolated in their own bucket makes it easier to add controls, and simplifies auditing as there is only top level identifier, i.e. the bucket name. 

One thing to consider is if you mix classifications in one bucket then you need to tag all data at the highest classification, which could complicate granting access to the data.

In general I recommend keeping different classifications of data separated, for example having raw data and anonymised, or summarised data in the same bucket is **not** a good idea.

## What are the cost implications for keeping this dataset?

The aim with this question is to understand how cost will be managed for a dataset, there are a couple of factors here, the size of the data, and how much churn will occur for the dataset, either in the form of reads or updates to the data.

For datasets which grow quickly, it may be easier to isolate them in their own bucket, as reporting cost for this dataset is easier, and cost control mechanisms such as lifecycle policies, or disabling/enabling versioning simpler to apply.

## What is the likely growth of this dataset in 6 to 12 months?

This question is related to the previous cost question, but I am trying to understand how challenging the dataset will be to handle over time. External factors such as traffic spikes for log datasets, which are often outside your control, should be taken into consideration as well.

There are two dimensions to this, being size of the data, and the number of objects in the dataset, both can have an impact on how difficult to wrangle dataset will be in the future, and how much it will cost to move, or backup.

# Summary

As a general rule I would recommend keeping datasets in separate buckets, with each bucket containing data of a single classification, and ideally a single purpose. This will help to simplify cost control, and make it easier to manage the data in the future.