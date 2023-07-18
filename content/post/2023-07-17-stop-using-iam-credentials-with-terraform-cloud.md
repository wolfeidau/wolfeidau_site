+++
title = "Stop using IAM User Credentials with Terraform Cloud"
date = "2023-07-17T07:55:22+10:00"
tags = [ "aws", "cloud", "security", "terraform" ]
draft = false
+++

I recently started using [Terraform Cloud](https://www.terraform.io/) but discovered that the [getting started tutorial](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-create-variable-set#create-a-variable-set) which describes how to integrate it with [Amazon Web Services (AWS)](https://aws.amazon.com/) suggested using [IAM user credentials](https://aws.amazon.com/iam/features/managing-user-credentials/). This is not ideal as these credentials are long-lived and can lead to security issues.

## What is the problem with IAM User Credentials?

- IAM User Credentials are long lived, meaning once compromised they allow access for a long time
- They are static, so if leaked it is difficult to revoke access immediately 

But there are better alternatives, the one I recommend is [OpenID Connect (OIDC)](https://openid.net/developers/how-connect-works/), which if you dig deep into the Terraform Cloud docs is a supported approach. This has a few benefits:

1. Credentials are dynamically created for each run, so if one set is compromised it does not affect other runs.
2. When Terraform Cloud authenticates with AWS using OIDC it will pass information about the project and run, so you can enforce IAM policies based on this context.
3. Credentials are short lived, expiring after the Terraform run completes.
4. You can immediately revoke access by removing the OIDC provider from AWS.
5. You don’t need to export credentials from AWS and manage their rotation. 

Overall this allows for a more secure and scalable approach to integrating Terraform Cloud with AWS. If you are just starting out, I would recommend setting up OpenID Connect integration instead of using IAM credentials.

## AWS Deployment

To setup the resources on the AWS side required to link AWS to Terraform Cloud we need to deploy some resources, in my case I am using a Cloudformation Template which deploy manually. You can find the source code to this template in my [GitHub Repo](https://github.com/wolfeidau/terraform-cloud-aws-blog) along with a Terraform example to deploy the resources.

Using the Cloudformation template as the example for this post, it creates:

1. IAM Role, which assumed by Terraform Cloud when deploying
2. Open ID Connect Provider, which is used to connect Terraform Cloud to AWS

The Terraform Deployment role is as follows:

```yaml
  TerraformDeploymentRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Statement:
          - Effect: Allow
            Action: sts:AssumeRoleWithWebIdentity
            Principal:
              Federated: !Ref TerraformOIDCProvider
            Condition:
              StringEquals:
                app.terraform.io:aud: "aws.workload.identity"
              StringLike:
                app.terraform.io:sub: !Sub organization:${OrganizationName}:project:${ProjectName}:workspace:${WorkspaceName}:run_phase:*
```

**Note:**

* The IAM role allows Terraform Cloud to assume the role using the OIDC provider, and limits it to the given organization, project and workspace names.
* The policy attached to this role, in my example, only allows Terraform to list s3 buckets; you should customise this based on your needs.

The Open ID Connect Provider is created as follows:

```yaml
  TerraformOIDCProvider:
    Type: AWS::IAM::OIDCProvider
    Properties:
      Url: https://app.terraform.io
      ClientIdList:
        - aws.workload.identity
      ThumbprintList:
        - 9e99a48a9960b14926bb7f3b02e22da2b0ab7280
```

Once deployed this template will provide two outputs:

1. The role ARN for the Terraform Deployment role.
2. An Optional Audience value, this is only needed if you want to customise this value.

## Terraform Cloud Configuration

You’ll need to set a couple of environment variables in your Terraform Cloud workspace in order to authenticate with AWS using OIDC. You can set these as workspace variables, or if you’d like to share one AWS role across multiple workspaces, you can use a variable set.

| Variable      | Value |
| ----------- | ----------- |
| TFC_AWS_PROVIDER_AUTH  | `true`       |
| TFC_AWS_RUN_ROLE_ARN   | The role ARN from the cloudformation stack outputs |
| TFC_AWS_WORKLOAD_IDENTITY_AUDIENCE   | The optional audience value from the stack outputs. Defaults to `aws.workload.identity`. |

Note for more advanced configuration options please refer to [Terraform Cloud - Dynamic Credentials with the AWS Provider](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration).

That is it, your now ready to run plans in your Terraform Cloud workspace!

## Auditing

Once you have setup both side of this solution you should be able to see events in [AWS CloudTrail](https://aws.amazon.com/cloudtrail/), filter by service `sts.amazonaws.com` and look at the `AssumeRoleWithWebIdentity` events. Each event will contain a record of the Terraform Cloud run, and the name of the project and workspace.

This is a cut down cloudtrail event showing the key information:
```json
{
    "userIdentity": {
        "type": "WebIdentityUser",
        "principalId": "arn:aws:iam::12121212121212:oidc-provider/app.terraform.io:aws.workload.identity:organization:test-organization:project:Default Project:workspace:test-terraform-cloud:run_phase:plan",
        "userName": "organization:test-organization:project:Default Project:workspace:test-terraform-cloud:run_phase:plan",
        "identityProvider": "arn:aws:iam::12121212121212:oidc-provider/app.terraform.io"
    },
    "eventTime": "2023-07-18T00:08:34Z",
    "eventSource": "sts.amazonaws.com",
    "eventName": "AssumeRoleWithWebIdentity",
    "awsRegion": "ap-southeast-2",
    "sourceIPAddress": "x.x.x.x",
    "userAgent": "APN/1.0 HashiCorp/1.0 Terraform/1.5.2 (+https://www.terraform.io) terraform-provider-aws/5.7.0 (+https://registry.terraform.io/providers/hashicorp/aws) aws-sdk-go-v2/1.18.1 os/linux lang/go/1.20.5 md/GOOS/linux md/GOARCH/amd64 api/sts/1.19.2",
    "requestParameters": {
        "roleArn": "arn:aws:iam::12121212121212:role/terraform-cloud-oidc-acces-TerraformDeploymentRole-NOPE",
        "roleSessionName": "terraform-run-abc123"
    },
    "responseElements": {
        "subjectFromWebIdentityToken": "organization:test-organization:project:Default Project:workspace:test-terraform-cloud:run_phase:plan",
        "assumedRoleUser": {
            "assumedRoleId": "CDE456:terraform-run-abc123",
            "arn": "arn:aws:sts::12121212121212:assumed-role/terraform-cloud-oidc-acces-TerraformDeploymentRole-NOPE/terraform-run-abc123"
        },
        "provider": "arn:aws:iam::12121212121212:oidc-provider/app.terraform.io",
        "audience": "aws.workload.identity"
    },
    "readOnly": true,
    "eventType": "AwsApiCall",
    "recipientAccountId": "12121212121212"
}
```

## Links

* [How to get rid of AWS access keys - Part 1: The easy wins](https://www.wiz.io/blog/how-to-get-rid-of-aws-access-keys-part-1-the-easy-wins)
* [Terraform Cloud - Dynamic Credentials with the AWS Provider](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration)
* [AWS Partner Network (APN) Blog - Simplify and Secure Terraform Workflows on AWS with Dynamic Provider Credentials](https://aws.amazon.com/blogs/apn/simplify-and-secure-terraform-workflows-on-aws-with-dynamic-provider-credentials/)

So instead of using IAM User credentials, this approach uses IAM Roles and OpenID Connect to dynamically assign credentials to Terraform Cloud runs which is a big win from a security perspective!