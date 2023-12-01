+++
title = "Avoid accidental exposure of authenticated Amazon API Gateway resources"
date = "2023-11-12T08:55:22+10:00"
tags = [ "aws", "security", "api gateway", "api", "lambda", "iam"]
+++
I have been working with [Amazon API Gateway](https://aws.amazon.com/api-gateway/) for a while and one thing I noticed is there are a few options for authentication, which can be confusing to developers, and lead to security issues. This post will cover one of the common security pitfalls with API Gateway and how to mitigate it.

If your using `AWS_IAM` authentication on an API Gateway, then make sure you set the default authorizer for all API resources. This will avoid accidental exposing an API if you mis-configure, or omit an authentication method for an API resource as the default is `None`.

In addition to this there is a way to apply a resource policy to an API Gateway, which will enforce a specific iam access check on all API requests. Combining the override to default authorizer, and the resource policy allows us to apply multiply layers of protection to our API, allowing us to follow the principle of defense in depth.

So to summarise, to protect your API with IAM authentication is as follows:

1. Enable a default authorizer method on the API Gateway resource.
2. Enable an authentication method on the API.
3. Assign an API resource policy which requires IAM authentication to access the API.

Doing this with [AWS SAM](https://aws.amazon.com/serverless/sam/) is fairly straight forward, to read more about it see the [SAM ApiAuth documentation](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-property-api-apiauth.html).

```yaml
  AthenaWorkflowApi:
    Type: AWS::Serverless::Api
    Properties:
      ...
      Auth:
        # Specify a default authorizer for the API Gateway API to protect against missing configuration
        DefaultAuthorizer: AWS_IAM
        # Configure Resource Policy for all methods and paths on an API as an extra layer of protection
        ResourcePolicy:
          # The AWS accounts to allow
          AwsAccountWhitelist:
           - !Ref AWS::AccountId
```

Through the magic of AWS SAM this results in a resource policy which looks like the following, this results in all the API methods being protected and only accessible by users authenticated to this account, and only where they are granted access via an IAM policy.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:root"
      },
      "Action": "execute-api:Invoke",
      "Resource": "arn:aws:execute-api:us-west-2:123456789012:abc123abc1/Prod/POST/athena/run_s3_query_template"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:root"
      },
      "Action": "execute-api:Invoke",
      "Resource": "arn:aws:execute-api:us-west-2:123456789012:abc123abc1/Prod/POST/athena/run_query_template"
    }
  ]
}
```

I typically use an openapi spec to define the API, using the extensions provided by AWS such as `x-amazon-apigateway-auth` to define the authorisation.

With the default authentication set to `AWS_IAM` hitting an API which is missing `x-amazon-apigateway-auth` using curl returns the following error.

```json
{"message":"Missing Authentication Token"}
```

With default authentication disabled, and the resource policy enabled the API returns the following error, which illustrates the principle of defense in depth.

```json
{"Message":"User: anonymous is not authorized to perform: execute-api:Invoke on resource: arn:aws:execute-api:us-east-1:********9012:abc123abc1/Prod/POST/athena/run_query_template"}
```