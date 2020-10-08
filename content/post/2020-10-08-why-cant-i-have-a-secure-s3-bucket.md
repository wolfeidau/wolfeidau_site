+++
title = "Why isn't my s3 bucket secure?"
date = "2020-10-08T19:30:00+11:00"
tags = [ "AWS", "s3", "security", "serverless" ]
+++

We have all read horror stories of [Amazon Simple Storage Service](https://aws.amazon.com/s3/) (S3) buckets being “hacked” in the popular media, and we have seen lots of work by [Amazon Web Services](https://aws.amazon.com) (AWS) to tighten up controls and messaging around best practices. So how do the amazon tools help you avoid some of the pitfalls with S3?

Case in point, the [AWS CLI](https://aws.amazon.com/cli/) which a large number of engineers and developers rely on every day, the following command will create a bucket.

```
$ aws s3 mb s3://my-important-data
```

One would assume this commonly referenced example which is used in a lot of the resources provided by AWS would create a bucket following the best practices. But alas no…

The configuration which is considered best practice for an S3 bucket missing is:

- Enable Default Encryption
- Block Public access configuration
- Enforce HTTPS access to objects

## Why is this a Problem?

I personally have a lot of experience teaching developers how to get started in AWS, and time and time again it is lax defaults which let this cohort down. Of course this happens a lot while they are just getting started.

Sure there are “guard rails” pointing out issues left right and center, but these typically identity problems which wouldn't be there in the first place if the tools where providing better defaults.

Sure there is more advanced configuration but **encryption** and blocking **public access** by default seem like a good start, and would reduce the noise of these tools.

The key point here is it should be hard for new developers to avoid these recommended, and recognised best practices when creating an S3 bucket.

In addition to this, keeping up with the ever growing list of “best practice” configuration is really impacting both velocity and morale of both seasoned, and those new the platform. Providing some tools which help developers keep up, and provide some uplift when upgrading existing infrastructure would be a boon.

Now this is especially the case for developers building solutions using *serverless* as they tend to use more of the AWS native services, and in turn trigger more of these “guard rails”.

Lastly there are a lot of developers out there who just don't have time to "harden" their environments, teams who have no choice but to ignore "best practices" and may benefit a lot from some uplift in this area.

## What about Cloudformation?

To further demonstrate this issue this is s3 bucket creation in [cloudformation](https://aws.amazon.com/cloudformation/), which is the baseline orchestration tool for building resources, provided free of charge by AWS. This is a very basic example, as seen in a lot of projects on GitHub, and the [AWS cloudformation documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket.html#aws-properties-s3-bucket--examples). 

```yaml
      MyDataBucket:
        Type: AWS::S3::Bucket
          Properties:
            BucketName: MyDataBucket
```

Now you could argue that cloudformation is doing exactly what you tell it to do, it is just a primitive layer which translates YAML or JSON into API calls to AWS, but I think again this is really letting developers down.

Again this is missing default encryption, and public access safe guards. Now in addition to this a lot of quality tools also recommend the following:


- Explicit deny of Delete* operations, good practice for systems of record
- Enable Versioning, optional but good practice for systems of record
- Enable object access logging, which is omitted it to keep the example brief

So this is a basic example with most of these options enabled, this is quite a lot to fill in for yourself.

```yaml
     MyDataBucket:
        Type: AWS::S3::Bucket
        DeletionPolicy: Retain
        UpdateReplacePolicy: Retain
        Properties:
          BucketName: !Ref BucketName
          BucketEncryption:
            ServerSideEncryptionConfiguration:
              - ServerSideEncryptionByDefault:
                  SSEAlgorithm: AES256
          VersioningConfiguration:
            Status: Enabled
          PublicAccessBlockConfiguration:
            BlockPublicAcls: True
            BlockPublicPolicy: True
            IgnorePublicAcls: True
            RestrictPublicBuckets: True
    
      MyDataBucketPolicy:
        Type: AWS::S3::BucketPolicy
        Properties:
          Bucket: !Ref MyDataBucket
          PolicyDocument:
            Id: AccessLogBucketPolicy
            Version: "2012-10-17"
            Statement:
              - Sid: AllowSSLRequestsOnly
                Action:
                  - s3:*
                Effect: Deny
                Resource:
                  - !Sub "arn:aws:s3:::${MyDataBucket}/*"
                  - !Sub "arn:aws:s3:::${MyDataBucket}"
                Condition:
                  Bool:
                    "aws:SecureTransport": "false"
                Principal: "*"
              - Sid: Restrict Delete* Actions
                Action: s3:Delete*
                Effect: Deny
                Principal: "*"
                Resource: !Sub "arn:aws:s3:::${MyDataBucket}/*"
```

To do this with the AWS CLI in one command would require quite a few flags, and options, rather than including that here I will leave that exercise up to the reader.

Now some may say this is a great opportunity for consulting companies to endlessly uplift customer infrastructure. But this again begs the questions:

1. Why is this the case for customers using the recommended tools?
2. What about developers getting started on their first application?
3. Wouldn't be better to have these consultants building something new, rather than crafting reams of YAML?

## Why Provide Resources which are Secure by Default? 

So I have used S3 buckets as a very common example, but there is an ever growing list of services in the AWS that I think would benefit from better default configuration.

Just to summarise some of the points I have made above:

1. It would make it harder for those new to the cloud to do the wrong thing when following examples.
2. The cost of building and maintaining infrastructure would be reduced over time as safer defaults would remove the need for pages of code to deploy “secure” s3 buckets.
3. For new and busy developers things would be mostly right from the beginning, and likewise update that baseline even just for new applications, leaving them more time to do the actual work they should be doing.

So anyone who is old enough to remember [Sun Solaris](https://en.wikipedia.org/wiki/Solaris_(operating_system)) will recall the “secure by default” effort launched with Solaris 10 around 2005, this also came with “self healing” (stretch goal for AWS?), so security issues around defaults is not a new problem, but has been addressed before!

## Follow Up Q&A

I have added some of the questions I received while reviewing this article, with some answers I put together.

#### Will CDK help with this problem of defaults?

So as it stands now I don't believe the default s3 bucket construct has any special default settings, there is certainly room for someone to make "secure" versions of the constructs but developers would need to search for them and that kind of misses the point of helping wider AWS user community.

#### Why don't you just write your own CLI to create buckets?

This is a good suggestion, however I already have my fair share of side projects, if I was to do this it would need to be championed by a orginisation, and team that got value from the effort. But again, needing to tell every new engineer to ignore the default AWS CLI as it isn't "secure" seems to be less than ideal, I really want everyone to be "secure".

#### How did you come up with this topic?

Well I am currently working through "retrofitting" best practices (the latest ones) on a bunch of aws serverless stacks which I helped build a year or so ago, this is when I asked the question why am I searching then helping to document what is "baseline" configuration for s3 buckets?!

#### Won't this make the tools more complicated adding all these best practices?

I think any uplift at all would be a bonus at the moment, I don't think it would be wise to take on every best practice out there, but surely the 80/20 rule would apply here. Anything to reduce the amount of retro fitting we need to do would be a good thing in my view. 