+++
date = "2015-05-06T16:56:00+10:00"
title = "Github Security"
Categories = [ "Github", "security", "CI", "docker" ]

+++

Having worked with [Github](https://github.com) for the last six years, commercially for the last three I thought I would do a post on security, or more specifically, protecting your projects, and the ones you work on for others, this may be friends, or it could be a company. Either way the aim of this post is to encourage you to review the security of your account.

## SSH Keys

Firstly please go to your [Github SSH Keys Page](https://github.com/settings/ssh) and take a look at the number of SSH keys you have, either you can click the link or login to your Github account and select the settings icon in the top right hand corner.

* Are they all currently being used? 
* Do you know where they all are?

Ideally use the key finger print to work out which ones you are using, and clear out any old ones. Most importantly, locate and verify where the all are, these keys are a gateway into all your stuff, make sure you keep them safe.

If your on OSX or Linux, you can see all the finger prints for your SSH keys by run the following command.

```
find ~/.ssh -name \*.pub | xargs -n1 ssh-keygen -lf
```

## Third Party Applications

Next, lets talk about third party applications, I am not sure about you but as time goes on I seem to be getting access to an increasing tail of projects and organizations. Now in doing so, I also share that access with some third party services. This is especially the case with some of the early ones as their level of access was quite broad.

So how about we visit the [Github Applications Page](https://github.com/settings/applications) and clear out any you currently don't use, I am especially talking about services that have access to ALL your repositories such as [travis](https://travis-ci.org/), [drone](https://drone.io/).

Now there is nothing wrong with these specific services, however the level of access they require to operate is typically "all the things".

## Continious Integration Services

So if your using Github for a few personal projects, most of which are open source then services such as travis and drone are fantastic. But if your like me and work on Github for a living then you probably have access to code that belongs to someone else. If this is the case I recommend being a bit more careful about who and what you give access to all your repositories.

So how do we solve this problem, getting the most out of these services, while also controlling what they have access to see and possibly modify?

Rather than using your account as a gateway into the miriad of projects you have access too, how about creating a build user for that task? Given how easy it is to manage a variety of logins with services such as [1password](https://agilebits.com/onepassword) and the like, maintaining an extra account is pretty simple.

So what other advantages are their to using a separate user for this?

* Lets you tightly control what services can access, for example only giving CI services read access to projects which need builds run. 
* If you go on holidays, or change roles, other team members can take over responsibility for this account and things will continue to function.
* Enables you to centralise all ssh-keys used for builds or deployments.

The way this works is you setup a CI user add it to the organisation, then setup a CI team in Github which to manage this users access to projects. If necessary the credentials can be shared by a couple of key people within the team, so you can actually have a holiday in peace.

When keys are required for automation, or a service requires access to repositories, you login as that user and set them up, likewise all SSH keys used for automation go on this account.

Once setup you have essentially sandboxed access by external services to an account which has only what it needs to operate. This in turn leaves your account with as few links to external services as possible.

## Summary

So by the end we should have:

* Done a cleanup of our SSH keys and worked out where they all are stored.
* Cleared out unused third party applications.
* Reconfigured continuous integration services to use a separate user in your organisation and restricted that to the bare minimum access.

## Closing Thoughts

I hope I have at least encouraged you to review your github account and give it a bit of a spring clean. I am sure there are a few other things you can do to tighten up access to the things you work on, your welcome to leave a comment if you have any other ways to improve the security of your Github account.
