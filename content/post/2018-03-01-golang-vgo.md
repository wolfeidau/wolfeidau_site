+++
title = "Diving into vgo from the Golang project"
date = "2018-03-01T21:02:47+10:00"
tags = [ "Go", "versioning", "vendoring" ]
+++

I have been looking into the new [vgo project](https://github.com/golang/vgo) which was released recently by [Russ Cox](https://twitter.com/_rsc). In summary this project is a pretty rethink of how golang retrieves and stores packages used to build applications, and more specifically how versioned modules are introduced while retaining reproducible builds.

The highlights, and standout features for me are as follows:

* Adds intrinsic support for versioning into the go command.
* Includes a few new sub commands such as `vendor` and `verify`
* Incorporates a lot of new ideas around the storage and management of golang modules, which seems to correlate to something akin to a github project. Note there is support for more than one module in a repository but the general idea is one.
* Adds a new mechanism to retrieve and cache modules in zip files, which will supersede the current source repository.
* Adds a new proxy mechanism, enabling organisations to provide a mediated, verified module server to developers.

But probably the biggest change is the move away from the much maligned `$GOPATH`, this will as far as I can tell be deprecated over time. Developers will create their projects outside of the `$GOPATH`, using a file named `go.mod` to provide a pointer to the projects namespace.

If your interested the full background take a look at [Go & Versioning](https://research.swtch.com/vgo), it is quite a long read.

So what does this look like in practice?

To illustrate how `vgo` works in practice lets create a project outside my `$GOPATH`, in my case I create a folder called `~/Code/hacking/golang-lambda-func` and add a `main.go` containing code for a simple lambda API GW program. This code is copied directly from [Announcing Go Support for AWS Lambda
](https://aws.amazon.com/blogs/compute/announcing-go-support-for-aws-lambda/).

```go
package main // import "github.com/wolfeidau/golang-lambda-func"

import (
	"log"

	"github.com/pkg/errors"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

var (
	// ErrNameNotProvided is thrown when a name is not provided
	ErrNameNotProvided = errors.New("no name was provided in the HTTP body")
)

// Handler is your Lambda function handler
// It uses Amazon API Gateway request/responses provided by the aws-lambda-go/events package,
// However you could use other event sources (S3, Kinesis etc), or JSON-decoded primitive types such as 'string'.
func Handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	// stdout and stderr are sent to AWS CloudWatch Logs
	log.Printf("Processing Lambda request %s\n", request.RequestContext.RequestID)

	// If no name is provided in the HTTP request body, throw an error
	if len(request.Body) < 1 {
		return events.APIGatewayProxyResponse{}, ErrNameNotProvided
	}

	return events.APIGatewayProxyResponse{
		Body:       "Hello " + request.Body,
		StatusCode: 200,
	}, nil

}

func main() {
	lambda.Start(Handler)
}
```

Firstly note the addition of `// import "github.com/wolfeidau/golang-lambda-func"` indicates where our `module` is located, being the current equivalent of creating that structure in our `$GOPATH`.

This depends on a bunch a few projects hosted on github, which translate into modules in vgo. To build the project we run `vgo`. If you want to try this just run `go get -u golang.org/x/vgo` to install it.

```
$ vgo build
vgo: resolving import "github.com/aws/aws-lambda-go/events"
vgo: finding github.com/aws/aws-lambda-go (latest)
vgo: adding github.com/aws/aws-lambda-go v1.1.0
vgo: resolving import "github.com/pkg/errors"
vgo: finding github.com/pkg/errors (latest)
vgo: adding github.com/pkg/errors v0.8.0
vgo: finding github.com/pkg/errors v0.8.0
vgo: finding github.com/aws/aws-lambda-go v1.1.0
vgo: finding github.com/urfave/cli v1.20.0
vgo: downloading github.com/aws/aws-lambda-go v1.1.0
vgo: downloading github.com/pkg/errors v0.8.0
```

Once completed a `go.mod` file is created which stores our modules package, and it's dependencies. This content of this is as follows:

```
module "github.com/wolfeidau/golang-lambda-func"

require (
	"github.com/aws/aws-lambda-go" v1.1.0
	"github.com/pkg/errors" v0.8.0
)
```

Now what is also interesting is that `vgo` has created a cache in `$GOPATH/src/v` which looks something like. The following find command just lists the directories under this path.

```
$ find /Users/markw/go/src/v -type d
/Users/markw/go/src/v
/Users/markw/go/src/v/cache
/Users/markw/go/src/v/cache/github.com
/Users/markw/go/src/v/cache/github.com/urfave
/Users/markw/go/src/v/cache/github.com/urfave/cli
/Users/markw/go/src/v/cache/github.com/urfave/cli/@v
/Users/markw/go/src/v/cache/github.com/aws
/Users/markw/go/src/v/cache/github.com/aws/aws-lambda-go
/Users/markw/go/src/v/cache/github.com/aws/aws-lambda-go/@v
/Users/markw/go/src/v/cache/github.com/pkg
/Users/markw/go/src/v/cache/github.com/pkg/errors
/Users/markw/go/src/v/cache/github.com/pkg/errors/@v
/Users/markw/go/src/v/github.com
/Users/markw/go/src/v/github.com/aws
/Users/markw/go/src/v/github.com/aws/aws-lambda-go@v1.1.0
/Users/markw/go/src/v/github.com/aws/aws-lambda-go@v1.1.0/cmd
/Users/markw/go/src/v/github.com/aws/aws-lambda-go@v1.1.0/cmd/build-lambda-zip
/Users/markw/go/src/v/github.com/aws/aws-lambda-go@v1.1.0/lambda
/Users/markw/go/src/v/github.com/aws/aws-lambda-go@v1.1.0/lambda/messages
/Users/markw/go/src/v/github.com/aws/aws-lambda-go@v1.1.0/lambdacontext
/Users/markw/go/src/v/github.com/aws/aws-lambda-go@v1.1.0/events
/Users/markw/go/src/v/github.com/aws/aws-lambda-go@v1.1.0/events/testdata
/Users/markw/go/src/v/github.com/aws/aws-lambda-go@v1.1.0/events/test
/Users/markw/go/src/v/github.com/pkg
/Users/markw/go/src/v/github.com/pkg/errors@v0.8.0
```

So what it has created is a versioned cache under `$GOPATH/src/v` with a few notible features:

* No `.git` directories, this code is cloned and stored without version information.
* It has some interesting folders ending in `@v` which contain other files.

```
$ ls -1 pkg/errors/@v
v0.8.0.info
v0.8.0.mod
v0.8.0.zip
v0.8.0.ziphash
```

So as mentioned above this is an example of the new compressed module packaging which is being introduced.

Well hopefully that shines a bit more light on what `vgo` does behind the scenes, and some of the notable differences between it and how the `go` command currently works. I really like where `vgo` is going, overall it feels like a really good preview of things to come in a post `$GOPATH` world. I will endeavour to dig into some other the new features as I discover more.

If your after a better explanation of how to get up and running with vgo make sure you watch [Using vgo for Go Dependency Management](https://www.gophersnacks.com/programs/using-vgo-for-go-dependency-management) by [@bketelsen](https://twitter.com/bketelsen).