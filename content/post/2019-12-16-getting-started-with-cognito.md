+++
title = "Getting started with Cognito?"
date = "2019-12-16T10:46:00+10:00"
tags = [ "cloudformation", "development", "aws", "cognito", "authentication" ]
+++

The AWS [Cognito](https://aws.amazon.com/cognito/) product enables developers to build web or API based applications without worrying about authentication and authorisation.

When setting up an applications authentication I try to keep in mind a few goals:

1. Keep my users data as safe as possible.
2. Try and find something which is standards based, or supports integrating with standard protocols such as [openid](https://openid.net/), [oauth2](https://oauth.net/2/) and [SAML](https://en.wikipedia.org/wiki/Security_Assertion_Markup_Language).
2. Evaluate the authentication flows I need and avoid increasing scope and risk.
3. Try to use a service to start with, or secondarily, an opensource project with a good security process and a healthy community.
4. Limit any custom development to extensions, rather than throwing out the baby with the bath water.

As you can probably tell, my primary goal is to keep authentication out of my applications, I really don't have the time or inclination to manage a handcrafted authentication solution.

### What does AWS Cognito provide out of the box?

Lets look at what we get out of the box:

* Storing and protecting your users data with features such as [Secure Remote Password Protocol (SRP)](https://en.wikipedia.org/wiki/Secure_Remote_Password_protocol).
* Signing up for an account with email / sms verification
* Signing in, optionally with Multi Factor Authentication (MFA)
* Password change and recovery
* A number of triggers which can be used to extend the product

### What is great about Cognito?

Where AWS Cognito really shines is:

* Out of the box security and compliance features
* Integration with a range of platform identity providers, such as Google, Apple and Amazon
* Support for standards such as OpenID and SAML.
* Really easy to integrate into your application using libraries such as [AmplifyJS](https://github.com/aws-amplify/amplify-js).
* AWS is managing it for a minimal cost

### What is not so great about Cognito?

Where AWS Cognito can be a challenge for developers:

* Can be difficult to setup, and understand some of the settings which can only be updated during creation, changing these requires you to delete and recreate your pool.
* Per account quotas on API calls
* A lack of search
* No inbuilt to backup and restore the user data in your pool

So how do we address some of these challenges, while still getting the value provided and being able to capitalise on it's security and compliance features.

### What is the best way to setup Cognito?

Personally I normally use one of the many open source [cloudformation](https://aws.amazon.com/cloudformation/) templates hosted on [GitHub](https://github.com/). I crafted this template some time ago [cognito.yml](https://gist.github.com/wolfeidau/70531fc1a593c0bad7fb9ebc9ae82580), it supports login using `email` address and domain white listing for sign up.

As a follow on from this I built a serverless application [serverless-cognito-auth](https://github.com/wolfeidau/serverless-cognito-auth) which encapsulates a lot of the standard functionality I use in applications.

You can also use [AWS Mobile Hub](https://docs.aws.amazon.com/aws-mobile/latest/developerguide/mobile-hub-features.html) or [AWS Amplify](https://aws.amazon.com/amplify/) to bootstrap a Cognito pool for you. 

Overall recommendations are:

1. If your new to Cognito and want things to just work then use [AWS Amplify](https://aws.amazon.com/amplify/).
2. If you are an old hand and just want Cognito the way you like it, then use one of the many prebuilt templates.

### How do I avoid quota related issues?

Firstly I recommend familiarising yourself with the [AWS Cognito Limits Page](https://docs.aws.amazon.com/cognito/latest/developerguide/limits.html).

I haven't seen an application hit request rate this more than a couple of times, and both those were related to UI bugs which continuously polled the Cognito API.

The one limit I have seen hit is the sign up emails per day limit, this can be a pain on launch days for apps, or when there is a spike in signups. If your planning to use Cognito in a startup you will need to integrate with [SES](https://aws.amazon.com/ses/).

### How do I work around searching my user database?

Out of the box cognito will only allow you to list and filter users by a list of common attributes, this doesn't include custom attributes, so if you add something like customerId as an attribute you won't be able to find all users with a given value.

So in summary this makes it difficult to replace an internal database driven authentication with just the cognito service, so for this reason I recommend adding a DynamoDB table to your application and integrating this with cognito using hooks to provide your own global user store.

### How do I back up my user pool?

So firstly backing up user accounts in any system is something you need to consider carefully, as this information typically includes credentials, as well as data used as a second factor such as mobile number.

Currently Cognito doesn't provide a way of exporting user data, the service does however have an import function which will import users in from a CSV file. 

**Note:** AWS cognito doesn't support export user passwords, these will need to be reset after restore.

For some examples of tooling see [cognito-backup-restore](https://www.npmjs.com/package/cognito-backup-restore).

# Conclusion

If you really care about security and compliance then cognito is a great solution, it has some limitations, and gaps but these can be worked around if you want to focus your effort somewhere else.

Personally I think it is really important that as a developer I pick solutions which ensure my customers data is locked away as securely as possible, and ideally using a managed service. 

You could totally roll your own authentication solution, and manage all the patching and challenges which go with that but that makes very little sense when you should probably be solving the original problem you had.

Authentication is a [yak I am willing to let someone else ~~shave~~](https://americanexpress.io/yak-shaving/)  manage, and so should you, if not for your own sanity, then that of your users.

Lastly if your building out a web application use [amplify-js](https://aws-amplify.github.io/amplify-js/api/), this library makes it so easy to add Cognito authentication to your web application. I used it on [cognito-vue-bootstrap](https://github.com/wolfeidau/cognito-vue-bootstrap) which you can also check out.