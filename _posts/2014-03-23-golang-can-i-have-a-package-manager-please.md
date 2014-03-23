---
layout: post
title: Golang can I have a package manager please?
tags:
  - golang
  - versioning
---

Currently [golang](http://golang.org) has no *standard* package manager; this in my view makes it a ton harder for those new to the language. golang has for the most part been a pleasure to use, built-in features are well thought out and help new users get started fast. Dependency management is by contrast a jarring and painful experience for those starting with golang. To understand why I believe this is the case I have put together a proposal of sorts for a package manager.

## What does a package manager do?

A package manager's core **job** is to:

* Provide a simple method of retrieving a snapshot of upstream libraries.
* Enable reproducible build results; this is done by enabling a user to retrieve the same, or a compatible upstream version of a dependency.

## The current solution

Firstly `go get` is a simple solution to decentralised retrieval of dependencies, without much grief a developer can pull down and maintain a copy of upstream libraries. The main issue is that this currently only solves half of the problem, developers are left to `manage` these dependencies themselves, including vetting all changes upstream.

This is an issue because:

* Developers assume this is a solved problem, not something they have to deal with while also learning a new language.
* Those new to development get the double whammy of having no idea where to even start with this problem.

Now on the other side of the fence, as a library writer I have no standard way to communicate massive breaks in API compatibility. Again this disregards many years of learning/development of things like semantic versioning.

From what I have observed this has led most larger projects to naturally limit the number of external dependencies in use.

Lastly without a nice solution for modularising software most developers won't bother.

## Can it be done using a decentralised model?

So this raises the question of whether or not versioning can be added to go without introducing a central package management system.

It is my opinion that simply encouraging people to manage their project using a standard versioning scheme, with a standard method for tagging their versions would be a good starting point.

At some point it would be helpful to have:

1. A central meta data store for download statistics, this is helpful to package maintainers to raise awareness of the impact of change on others. This would really fill the gaps in existing systems such as [github](http://github.com) around exposing download counts for a given project.
2. A distributed snapshot repository of packages, just to avoid the inevitable deletion or reorganisation of repositories (YES THIS HAPPENS).

Note: I don't think github should have to provide this by the way.

## What is the shortest path to easing pain for new users?

Based on my review **tool** just needs to do the following:

1. Simple command line tool, one entry point and minimal options.
2. The ability to manage versioning of my project using the same tool.
3. A method of retrieving different versions of a dependency with an option to save this to a file.
4. Automatic upgrades of dependencies based on a known standard versioning scheme such as [semver](http://semver.org/).
5. Fall back to the existing `go get` model with an obvious report at the end indicating this dependency doesn't provide versions.
6. Provide an idiomatic way to store this version information, based on reflection on existing features for maintaining meta data. My view is this should be a `version.go` in each project.

This is in response to a [gist](https://gist.github.com/davecheney/9716518) posted by [Dave Cheany](https://twitter.com/davecheney) after a [discussion](https://twitter.com/davecheney/status/447497663609450496) on twitter with [Mitchell Hashimoto](https://twitter.com/mitchellh).
