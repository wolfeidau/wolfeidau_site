+++
title = "How do I Structure my Go Project?"
date = "2020-03-10T04:00:00+11:00"
tags = [ "Go", "Golang", "development" ]
+++

Assuming you read my [Starting a Go Project]({{< ref "2020-03-10-starting-a-go-project.md" >}}) post you should have the starting point for a minimal go web service. For your first project it is easier to keep all your code in one folder, in the base of your project, but at some point you will want to restructure things, this is done for a few of reasons:

* Having everything in one folder results in a lot of inter dependencies in the code.
* Reuse outside the project can be difficult as the code is only designed to be used in one package.
* It is impossible to have more than one binary, as you can have only one `main` method.

This post will provide an overview of the structure I follow in my Go projects when building web services.

**Note:** If your just building a library to use in your services, or share with others, it is OK to put everything in the base folder of your project, an example of this is my [dynastore](https://github.com/wolfeidau/dynastore) library.

## /cmd

This folder contains the main application entry point files for the project, with the directory name matching the name for the binary. So for example `cmd/simple-service` meaning that the binary we publish will be `simple-service`.

## /internal

This package holds the private library code used in your service, it is specific to the function of the service and not shared with other services. One thing to note is this privacy is enforced by the compiler itself, see the [Go 1.4 release notes](https://golang.org/doc/go1.4##internalpackages) for more details.

## /pkg 

This folder contains code which is OK for other services to consume, this may include API clients, or utility functions which may be handy for other projects but don't justify their own project. Personally I prefer to use this over `internal`, mainly as I like to keep things open for reuse in most of projects.

## Project Structure

As you build out your project there are some very important goals you should consider when it comes to how you structure your packages:

* Keep things consistent
* Keep things as simple as possible, but no simpler
* Loosely couple sections of the service or application
* Aim to ensure it is easy to navigate your way around

Overall when getting started you should experiment a bit, try a few different ideas when building out your first and get some feedback on based on the above goals.

The number one objective is to you build easy to maintain, consistent and reliable software.

## Example

I recommend taking a look at [exitus](https://github.com/wolfeidau/exitus) to see how I structure my projects, most of the code is under the `pkg` folder with each sub folder having one or more files. From the top level it is pretty clear what each package relates to, and although lean on tests it has a few examples. 

```
$ tree exitus/
 exitus/
├── cmd
│   ├── authtest
│   │   └── main.go
│   ├── backend
│   │   └── main.go
│   └── client
│       └── main.go
├── dev
│   ├── add_migration.sh
│   └── docker-compose.yml
├── Dockerfile
├── go.mod
├── go.sum
│   ├── 20190721131113_extensions.down.sql
│   ├── 20190721131113_extensions.up.sql
│   ├── 20190723044115_customer_projects.down.sql
│   ├── 20190723044115_customer_projects.up.sql
│   ├── 20190726175158_issues.down.sql
│   ├── 20190726175158_issues.up.sql
│   ├── 20190726201649_comments.down.sql
│   ├── 20190726201649_comments.up.sql
│   ├── bindata.go
│   ├── gen.go
│   ├── migrations_test.go
│   └── README.md
├── pkg
│   ├── api
│   │   ├── exitus.gen.go
│   │   ├── exitus.yml
│   │   └── gen.go
│   ├── auth
│   │   ├── scopes.go
│   │   └── user.go
│   ├── conf
│   │   ├── conf.go
│   │   └── conf_test.go
│   ├── db
│   │   ├── db.go
│   │   ├── dbtesting.go
│   │   ├── migrate.go
│   │   ├── sqlhooks.go
│   │   └── transactions.go
│   ├── env
│   │   └── env.go
│   ├── healthz
│   │   ├── healthz.go
│   │   └── healthz_test.go
│   ├── jwt
│   │   └── jwt.go
│   ├── metrics
│   │   └── metrics.go
│   ├── middleware
│   │   ├── jwt.go
│   │   └── middleware.go
│   ├── oidc
│   │   └── client.go
│   ├── server
│   │   ├── reflect.go
│   │   └── server.go
│   └── store
│       ├── comments.go
│       ├── comments_test.go
│       ├── customers.go
│       ├── customers_test.go
│       ├── issues.go
│       ├── issues_test.go
│       ├── migrate_test.go
│       ├── projects.go
│       ├── projects_test.go
│       └── store.go
└── README.md
```

The aim here is to illustrate how you grow your project from a couple of files, to a larger web service. I encourage you to trawl through github projects and dig into how other developers have structured theirs, and most of all try it out yourself!

# References 

* [GopherCon EU 2018: Peter Bourgon - Best Practices for Industrial Programming](https://www.youtube.com/watch?v=PTE4VJIdHPg)
* [Standard Go Project Layout](https://github.com/golang-standards/project-layout)
* [GopherCon 2018: Kat Zien - How Do You Structure Your Go Apps](https://www.youtube.com/watch?v=oL6JBUk6tj0)

