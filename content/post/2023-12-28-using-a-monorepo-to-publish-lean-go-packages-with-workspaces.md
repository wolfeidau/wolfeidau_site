+++
title = "Using a Monorepo to publish Lean Go Packages with Workspaces"
date = "2023-12-28T08:55:22+10:00"
tags = ["golang", "monorepo", "software development", "developer tools", "Go"]
+++

As a developer who works with Go in my day-to-day development, I constantly struggle with third party packages or tools which bring in a lot of dependencies. This is especially true when you're trying to keep your project dependencies up to date, while [dependabot](https://github.com/dependabot), and other security software, is screaming about vulnerabilities in dependencies of dependencies. 

This is especially a problem with two common packages I use:

1. Any HTTP adaptor package, which ships with integrations for multiple server packages, such as Gin, Echo, and others.
2. Any package which uses docker to test with containers.
3. Projects which include examples with their own dependencies.

To break this cycle in my own projects, and packages I publish privately in work projects, I have adopted the use of [Go workspaces](https://go.dev/ref/mod#workspaces), which allows me to create a monorepo broken up into multiple packages, and then publish one or more of these packages.

So to understand how this helps, let's provide an example. I have a project called [s3iofs](https://github.com/wolfeidau/s3iofs) which provides an s3 based [io/fs](https://pkg.go.dev/io/fs) adaptor, and within this project I have integrations tests which use docker and [minio](https://min.io/) server to test it. 

Before I started using workspaces, if you added this package to your project you would have the docker client added to your dependencies, which in turn would add its dependencies, resulting in a lot of bloat in your project.

This is best illustrated by the following dependency count, which is from my `github.com/wolfeidau/s3iofs` package.

```
cat go.sum| wc -l
65
```

By comparison my `github.com/wolfeidau/s3iofs/integration` package has the following dependency count.

```
cat go.sum| wc -l
185
```

This is a rather simplistic comparison, but you can see that the integration tests have a lot more dependencies.

Because I have isolated the docker based integration tests in their own package, within this workspace, I can develop away happily, not needing to micromanage these modules, while you as the consumer of my package get a lean secure package.

## How to use workspaces
 
To get started with workspaces I recommend a couple of tutorials, the [Getting started with multi-module workspaces](https://go.dev/doc/tutorial/workspaces), then.

Once you have read through the getting started guide, you can publish your packages with the following commands.

* First we should initialise our go project, this is done from an empty folder with the same name as the project, this will create a go.mod file.

```
mkdir s3backend
cd s3backend
go mod init github.com/wolfeidau/s3backend
```

* Now once we have written some code and added some dependencies, we can set up some integration tests, to do this we will initialise another go project in a subfolder called `integration`. In the case of `s3iofs` the only code in this folder are test files.

```
mkdir integration
cd integration
go mod init github.com/wolfeidau/s3backend/integration
```

* Now we can add initialise our workspace and add the two packages, being our library in the root, and the integration tests.

```
go work init
go work use .
go work use ./integration
```

* Now we can run the tests in the integration folder, note I have included 

```
cd integration
go test -covermode=atomic -coverpkg=github.com/wolfeidau/s3iofs -v ./...
```

* This will provide the test results as follows, note how I am able to provide test coverage across module boundaries using the `-coverpkg` flag which was introduced in Go 1.20 and is explained in [Coverage profiling support for integration tests](https://go.dev/doc/build-cover).

```
PASS
coverage: 70.2% of statements in github.com/wolfeidau/s3iofs
2023/12/28 12:58:43 code 0
ok  	github.com/wolfeidau/s3iofs/integration	1.225s	coverage: 70.2% of statements in github.com/wolfeidau/s3iofs
```

If you need this `-coverpkg` option to work in vscode, you will need to add the following to your `.vscode/settings.json` file in your project.

```json
{
    "go.testFlags": [
        "-v",
        "-coverpkg=github.com/wolfeidau/s3iofs"
    ]
}
```

This is just one use case for using workspaces in a monorepo, but it is a very useful tool for managing dependencies you use in your project, and how you keep what you provide to others as lean and secure as possible.

I recommend you clone the [s3iofs](https://github.com/wolfeidau/s3iofs) and dig into how it works locally, open it in your editor of choice and run the tests, then try it out in your own project.