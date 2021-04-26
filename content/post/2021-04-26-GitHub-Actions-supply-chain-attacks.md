+++
title = "GitHub Actions supply chain attacks"
date = "2021-04-26T19:30:00+11:00"
tags = [ "GitHub", "CI", "security" ]
+++

A supply chain attack looks to target less secure parts of the development process, this could be the tools and services you depend on, or the docker containers you host your software in. This could be to extract credentials from your CI services like the [Codecov security incident](https://about.codecov.io/security-update/), or to seed malware for an attack down stream on your customers like the [solarwinds breach](https://krebsonsecurity.com/tag/solarwinds-breach/).

# Why is the Codecov security incident interesting?

The [Codecov security incident](https://about.codecov.io/security-update/) involved an attacker modifying a bash uploader script which is hosted on the Codecov website. This script was used in the [GitHub](https://github.com) action provided by Codecov. Unfortunately checksum for the downloaded script was not being verified so projects using this action were exposed to the exploit for at least 4 months. 

The action ran this modified script in each build and uploaded environment variables used to a website presumably operated by the attacker. Given these variables are often used to pass in the credentials for other services such as [Docker Hub](https://hub.docker.com
), [NPM](https://www.npmjs.com/), cloud storage buckets and other software distribution services which could lead to further exploits, extending the footprint of this attack.

# What can you do to mitigate these sorts of attacks?

Given we all still want the benefits of services such as GitHub actions while also managing the risks we need to maintain a balance between getting the most out of the service and limiting possible exploits.

There are a few things we can do though:


1. Read the [GitHub actions hardening](https://docs.github.com/en/actions/learn-github-actions/security-hardening-for-github-actions) documentation.
2. Limit exposure of secrets to only the projects and repositories which need these values by implementing [least privilege for secrets in GitHub Actions](https://github.blog/2021-04-13-implementing-least-privilege-for-secrets-in-github-actions/).
3. Review the GitHub actions your using in your workflows, like you would for opensource libraries:
    1. How active are these projects? Are PRs merged / reviewed in a timely manner?
    2. Is the author known for building good quality software and build automation?
    3. Are these actions supported by a company or service?
    4. Does the project have a security policy? 
4. Regularly rotate the credentials used in your GitHub actions. this helps mitigate historical backups or logs being leaked by a service.
5. If an action is supplied and supported by a vendor, ensure emails or advisories are sent to a shared email box, and not attached to a personal email. This will enable monitoring by more than one person, and enable you to go on holidays.

For actions which have access to important secrets, like those used to upload your software libraries and releases, or deploying your services, you may want to fork them and add security scanning. This is more important if there are no vendor supported alternatives, or it is a less widely supported technology. 

When it comes to opensource GitHub actions you need to be aware that most licenses limit liability for the author, this means you as a consumer need to actively manage some of the risks running this software. Performing maintenance, bug fixes and upkeep of the software is key to ensuring the risk of exploits is minimized.

Lastly run some internal training or workshops around supply chain attacks in your company, this could involve running a scenario like the Codecov incident as a [table top exercise](https://blog.rsisecurity.com/how-to-perform-a-security-incident-response-tabletop-exercise/).  

