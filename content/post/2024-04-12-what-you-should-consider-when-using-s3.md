+++
title = "What you should consider when storing datasets s3"
date = "2024-04-11T22:07:22+10:00"
tags = ["AWS", "s3", "Cloud", "Data Engineering"]
+++

As an [Amazon Web Services (AWS)](https://aws.amazon.com) developer I am often asked what is the best way to organise datasets in [S3](https://aws.amazon.com/s3/), this could be data exported by business systems, or data emitted by AWS services.

Way to often I have seen data just dumped in one massive S3 bucket, and left for someone else to tidy up later, however with a little consideration, and empathy for those dealing with this in the future, we can do better than this.

# Start By Asking a few questions

When I am planning to store a dataset in s3 I typically ask a few questions, one thing to note is I am focusing on the semantics of the data, and the business, not just the bucket(s) configuration!

## Who will consume this information?

What I am trying to understand here is whether this dataset has any known consumers, with the AWS logs example, this may be an ingestion tool like splunk, which is easier to integrate with if there a few aggregate buckets. 

For datasets which are exported from other systems, or transformed for use in an application, or with an integration it may be easier to combine them one bucket, especially if other factors I cover in the next few questions aren't a concern.

## What is the classification for the data?

My goal here is to consider the sensitivity of the data, and how it could affect who is granted access. 

Keeping sensitive datasets isolated in their own bucket makes it easier to add controls, and simplifies auditing as there is only one top level identifier, i.e. the bucket name. 

One thing to avoid is mixing different data classifications in one bucket, as you then you need to tag all data in that bucket at the highest classification, which could complicate granting access to the data.

For an example of data classifications, this is a five-tiered commercial data classification approach provided in this book [CISSP Security Management and Practices](https://www.pearsonitcertification.com/articles/article.aspx?p=30287&seqNum=9):
- Sensitive
- Confidential
- Private
- Proprietary
- Public

These classifications would be assigned to a tag, such named `Classification` on your bucket, for more on this see [Categorizing your storage using tags](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-tagging.html).

In general I recommend keeping different classifications of data separated, for example having raw data and anonymised, or summarised data in the same bucket is **not** a good idea.

## What are the cost implications for keeping this dataset?

The aim with this question is to understand how cost will be managed for a dataset, there are a couple of factors here, the size of the data, and how much churn will occur for the dataset, either in the form of reads or updates to the data.

For datasets which grow quickly, it may be easier to isolate them in their own bucket, as reporting cost for this dataset is easier, and cost control mechanisms such as lifecycle policies, or disabling/enabling versioning simpler to apply.

For more information on optimising storage costs, see [Optimizing costs for Amazon S3](https://aws.amazon.com/s3/cost-optimization/).

## What is the likely growth of this dataset in 6 to 12 months?

This question is related to the previous cost question, but I am trying to understand how challenging the dataset will be to handle over time. External factors such as traffic spikes for log datasets, which are often outside your control, should be taken into consideration as well.

There are two dimensions to this, being size of the data, and the number of objects in the dataset, both can have an impact on how difficult to wrangle dataset will be in the future, and how much it will cost to move, or backup.

For more information on how you monitor and manage dataset growth in Amazon S3 I recommend digging into [Amazon S3 Storage Lens](https://aws.amazon.com/s3/storage-lens/).

# Summary

As a general rule I would recommend keeping datasets in separate buckets, with each bucket containing data of a single classification, and ideally a single purpose. This will help to simplify cost control, and make it easier to manage the data in the future.

Getting things right from the start will enable you to make the most of your datasets which is a potential differentiator for your business in this new era of cloud computing, data engineering and AI.