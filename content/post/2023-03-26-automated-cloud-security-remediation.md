+++
title = "Automated Cloud Security Remediation"
date = "2023-02-19T11:00:00+10:00"
tags = [ "aws", "cloud", "security" ]
+++

Recently I have been looking into automated security remediation to understand its impacts, positive and negative. As I am a user of AWS, as well other cloud services, I was particularly interested in how it helped maintain security in these environments. As with anything, it is good to understand what problem it is trying to solve and why it exists in the first place.

## So firstly what does automated security remediation for a cloud service do? 

This is software which detects threats, more specifically misconfigurations of services, and automatically remediates problems.

## How does automated security remediation work?

Typically, security remediation tools take a feed of events from a service such as [AWS CloudTrail](https://aws.amazon.com/cloudtrail/) (audit logging service) and checks the configuration of the resources being modified. This is typically paired with regular scheduled scans to ensure nothing is missed in the case of dropped or missing events.

## Can you use IAM to avoid security misconfigurations in the first place?

Cloud services, such as AWS, have fairly complex [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/) services which provide course grained security policy language called IAM policies. These policies are hard to fine tune for the myriad of security misconfigurations deployed by the people working on in these cloud services.

Everyone has seen something like the following administrator policy allowing all permissions for administrators of an AWS environments, this is fine for a "sandbox" learning account, but is far too permissive for production accounts.

```yaml
Version: "2012-10-17"
Statement:
    - Sid: AdminAccess
    Effect: Allow
    Action: '*'
    Resource: '*'
```

That said, authoring IAM policies following the least privilege to cover current requirements, new services coming online and keeping up with emerging threats can be a significant cost in time and resources, and like at some point provide diminishing returns.

## Can you use AWS service control polices (SCP) to avoid security misconfigurations?

In AWS there is another way to deny specific operations, this comes in the for of service control policies (SCP). These policies are a part of AWS Organizations and provide another layer of control above an account's IAM policies, allowing administrators to target specific operations and protect common resources. Again, these are also very complex to configure and maintain, as they use the same course grained security layer.

Below is an example SCP which prevents any VPC that doesn't already have internet access from getting it.

```yaml
Version: '2012-10-17'
Statement:
- Effect: Deny
  Action:
  - ec2:AttachInternetGateway
  - ec2:CreateInternetGateway
  - ec2:CreateEgressOnlyInternetGateway
  - ec2:CreateVpcPeeringConnection
  - ec2:AcceptVpcPeeringConnection
  - globalaccelerator:Create*
  - globalaccelerator:Update*
  Resource: "*"
```

Investment in SCPs is important for higher level controls, such as disabling the modification of security services such as [Amazon GuardDuty](https://aws.amazon.com/guardduty/), [AWS Config](https://aws.amazon.com/config/) and [AWS CloudTrail](https://aws.amazon.com/cloudtrail/) as changes to these services may result in data loss. That said, SCPs are still dependent on IAMs course grained policy language, which in turn is limited by the service's integration with IAM.

A note about SCPs, often you will see exclusions for roles which enable administrators, or continuous integration and delivery (CI\CD) systems to bypass these policies. These should be used for exceptional situations, for example bootstrapping of services, or incidents. So, using these roles should be gated via some sort incident response process.

### So why does automated security remediation exist?

Given the complexity of managing fine-grained security policies, organizations implement a more reactive solution, which is often in the form of automated security remediation services.
### What are some of disadvantages of these automated security remediation tools?

* False positives and false negatives: They may generate false positives, where legitimate actions are flagged as security threats, or false negatives, where actual security issues are missed.
* Over-reliance on automation: Organizations may become over-reliant on tools, potentially leading to complacency or a lack of human oversight, which can create new risks and vulnerabilities.
* Limited scope: They may not be able to detect or remediate all types of security issues or vulnerabilities, especially those that are highly complex or require a more nuanced approach.
* Compliance and regulatory issues: Some compliance and regulatory frameworks may require manual security review or approval for certain types of security incidents, which can be challenging to reconcile with automated processes.
* Cultural resistance: Some organizations may experience cultural resistance to automated remediation, as it may be perceived as a threat to job security or the role of security professionals.
* Delayed or dropped trigger events: Automated remediation typically primarily depend on triggers from audit events provided, these events can be delayed in large AWS environments, or by a flood of activity.

## What are some of the positive impacts automated remediation tools?

* Increased efficiency: Can reduce the time and resources required to respond to security incidents, allowing security teams to focus on higher-value tasks.
* Improved collaboration: Can help break down silos between different teams, as it often requires cross-functional collaboration between security, operations, and development teams.
* Reduced burnout: By automating repetitive and time-consuming tasks, automated remediation can help reduce burnout among security people, who may otherwise be overwhelmed by the volume of security incidents they need to respond to manually.
* Skills development: As organizations adopt these tools and processes, security teams may need to develop new skills and competencies in areas such as automation, scripting, and orchestration, which can have positive impacts on employee development and job satisfaction.
* Cultural shift towards proactive security: They can help shift the culture of security within an organization from reactive to proactive, by enabling security teams to identify and remediate potential security risks before they become actual security incidents.

# Summary

Overall, while automated security remediation can have some cultural and productivity impacts that need to be managed, it can also bring significant benefits to organizations by enabling more efficient, collaborative, and proactive security practices.

That said, automated security remediation really needs to be part of a three-pronged approach:

1. Ensure people are working in cloud environments with only the privileges they require to do their work. There are of course exceptions to this, but they should be covered with a process which allows users to request more access when required.
2. SCPs should be used to protect security and governance services, and implement core restrictions within a collection of AWS accounts, depending on your business. 
3. Automated security remediation should be used to cover all the edge cases, again this should be used only where necessary, and with the understanding it may take a period of time to fix.

One thing to note is we are working in an environment with a lot of smart and resourceful people, so organizations need to watch for situations complex workarounds evolve to mitigate ineffective or complex controls otherwise they may impact morale, onboarding of staff and overall success of a business. 

Security works best when it balances threats and usability!