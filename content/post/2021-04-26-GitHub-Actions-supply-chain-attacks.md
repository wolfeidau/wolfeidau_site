+++
title = "GitHub Actions supply chain attacks"
date = "2021-04-26T19:30:00+11:00"
tags = [ "GitHub", "CI", "security" ]
+++
There has been a lot of press about supply chain attacks recently, these type of attacks are nothing new and understanding them is really important for developers using services such as [GitHub Actions](https://github.com/features/actions), given Continuos integration (CI) tools are a critical part of supply chain used in software projects.

A supply chain attack targets less secure parts of the development process, this could be the tools and services you depend on, or the docker containers you host your software in. These attacks come in different forms but some examples are:

* Extract credentials from your CI services like the [Codecov security incident](https://about.codecov.io/security-update/).
* Seed malware for an attack down stream on your customers like the [solarwinds breach](https://krebsonsecurity.com/tag/solarwinds-breach/).

In this post I am going to dive into an example of an attack that affected a lot of projects using GitHub Actions recently, but this could be applied more broadly to any CI tool or service relying on third party services or code.

# Why is the Codecov security incident interesting?

The [Codecov security incident](https://about.codecov.io/security-update/) involved an attacker modifying a bash coverage uploader script hosted on the Codecov website. This script was used in a few of the CI integrations including the [GitHub](https://github.com) action provided by Codecov. Critically the release checksum for the downloaded script was not being verified after download, so projects using this action were exposed to the exploit embedded in it for at least 4 months. 

When the GitHub Action ran this modified coverage uploader script it submitted all environment variables used in that pipeline to a website operated by the attacker. Given these variables are often used to pass in the credentials for other services such as [Docker Hub](https://hub.docker.com
), [NPM](https://www.npmjs.com/), cloud storage buckets and other software distribution services this could have been used to exploit users of these packages. Even more concerning is this could lead to a chain of further exploits, extending the footprint of this attack.

In summary due to an honest mistake in a vendor supported action all your secrets in that pipeline were exposed.

**Note:** It is worth reading the [security update](https://about.codecov.io/security-update/) posted by Codecov as it highlights some of the steps you need to take if you are effected by this sort of attack.

# What can you do to mitigate these sorts of attacks?

To ensure your GitHub actions secure I recommend:

1. Read the [GitHub actions hardening](https://docs.github.com/en/actions/learn-github-actions/security-hardening-for-github-actions) documentation.
2. Limit exposure of secrets to only the projects and repositories which need these values by implementing [least privilege for secrets in GitHub Actions](https://github.blog/2021-04-13-implementing-least-privilege-for-secrets-in-github-actions/).
3. Read about [Keeping your GitHub Actions and workflows secure: Untrusted input](https://securitylab.github.com/research/github-actions-untrusted-input/).
4. Regularly rotate the credentials used in your GitHub actions. this helps mitigate historical backups or logs being leaked by a service.
5. If an action is supplied and supported by a vendor, ensure emails or advisories are sent to a shared email box, and not attached to a personal email. This will enable monitoring by more than one person, and enable you to go on holidays.

For actions which have access to important secrets, like those used to upload your software libraries and releases, or deploying your services, you may want to fork them and add security scanning. This is more important if there are no vendor supported alternatives, or it is a less widely supported technology. 

# Reviewing your actions

Given we all still want the benefits of services such as GitHub Actions while also managing the risks we need to maintain a balance between getting the most out of the service and limiting possible exploits.

The first step is to review the GitHub actions your using in your workflows, just like you would for open source libraries:

* How active are these projects? Are PRs merged / reviewed in a timely manner?
* Is the author known for building good quality software and build automation?
* Are these actions supported by a company or service?
* Does the project have a security policy? 

When it comes to open source GitHub Actions you need to be aware that most open source licenses limit liability for the author, this means you as a consumer need to actively manage some of the risks running this software. Performing maintenance, bug fixes and contributing to the upkeep of the software is key to ensuring the risk of exploits is minimized.

Lastly run some internal training or workshops around supply chain attacks in your company, this could involve running a scenario like the Codecov incident as a [table top exercise](https://blog.rsisecurity.com/how-to-perform-a-security-incident-response-tabletop-exercise/).  

