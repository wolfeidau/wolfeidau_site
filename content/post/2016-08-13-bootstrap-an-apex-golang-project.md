+++
Categories = [ "Development", "golang", "serverless", "apex" ]
date = "2016-08-13T18:30:47+10:00"
draft = true
title = "bootstrap an apex golang project"

+++

Lately I have been using [apex](http://apex.run) to build a side project, this tool stream lines building and deploying serverless applications using [lambda](https://aws.amazon.com/lambda/). While working on this project I have helped others get started with [golang](http://golang.org) at the same time as apex.

My general strategy for building apex applications is to build a standalone version of the functionality on my machine, typically in a way which makes the code reusable, then I import and use that in apex. This post will run through how I do this.

Firstly you will need to setup golang, I have documented how [bootstrap a golang project](https://www.wolfe.id.au/2016/08/12/bootstrap-a-golang-project/).

Lets go ahead and make a project, this will hold our reusable code and a test command line tool. Note that `wolfeidau` needs to be changed to your github login.

```text
mkdir -p $GOPATH/src/github.com/wolfeidau/shorten
cd !$
```

Now create a project folder and setup a sub folder for commands and create the main test program file.

```text
mkdir -p cmds/shorten
touch cmds/shorten/main.go
```

Next we create a file in the base of project which will contain the reusable parts of our application. I normally use the project name for the first file I create and pull things out into other `.go` files as it grows.

```text
touch shorten.go shorten_test.go
```

Add a package declaration file and some code as follows.

```go
// Package shorten contains utility functions for shortening a URL.
package shorten

import (
    "fmt"
    "math/rand"
)

var letters = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-.")

func init() {
    rand.Seed(time.Now().UnixNano())
}

func RandSeq(n int) string {
    b := make([]rune, n)
    for i := range b {
        b[i] = letters[rand.Intn(len(letters))]
    }
    return string(b)
}
```

Now copy the following test into the `shorten_test.go` file.

```go
package shorten

import (
    "testing"

    "github.com/stretchr/testify/assert"
)

func TestRandSeq(t *testing.T) {
    v := RandSeq(12)

    assert.Equal(t, 12, len(v))
}
```

Now lets add some code to `cmds/shorten/main.go` to call this function. I am going to use [github.com/alecthomas/kingpin](https://github.com/alecthomas/kingpin) to manage parsing command line flags.

```go
package main

import (
  "fmt"

  "gopkg.in/alecthomas/kingpin.v2"
  "github.com/wolfeidau/shorten"
)

var (
  length = kingpin.Arg("length", "Length of random string").Int()
)

func main() {
  kingpin.Version("0.0.1")
  kingpin.Parse()
  fmt.Println("Random String:", shorten.RandSeq(*length))
}
```

Pull your depdencies into the local `GOPATH` using `go get` and run the test.

```text
go get -uv ./...
go test -v ./...
```

Test output should be as follows.

```text
=== RUN   TestRandSeq
--- PASS: TestRandSeq (0.00s)
PASS
ok      github.com/wolfeidau/shorten    0.011s
?       github.com/wolfeidau/shorten/cmd/shorten    [no test files]
```

Run the test program.
```text
go run cmd/shorten/main.go 23
```

With the response something like.
```text
Random String: YFynJVJYSJqsFejIGWGbEPF
```

Now we can build an apex project using the same method.

```
cd $GOPATH/src/github.com/wolfeidau
mkdir shorten-apex
cd !$
```

Next we initialise the apex project and remove the example function. Note this will setup an environment in AWS Sydney region using your default AWS profile.

```
apex init --region ap-southeast-2
rm -rf functions/hello
```

Create a function and go file.

```
mkdir functions/shorten
touch functions/shorten/main.go
echo '*.go' >> functions/shorten/.apexignore
```

Copy the following code into your `main.go`.

```go
package main

import (
    "encoding/json"
    "fmt"
    "net/url"
    "time"

    "github.com/apex/go-apex"
    "github.com/wolfeidau/shorten"
)

const (
    domain = "https://s.example.com/"

    // ~83733937890625 should be enough random values
    // this assumes 55^8
    length = 8
)

type message struct {
    ShortURL  string `json:"shortUrl"`
    URL       string `json:"url"`
    Timestamp int64  `json:"timestamp"`
}

func main() {
    apex.HandleFunc(func(event json.RawMessage, ctx *apex.Context) (interface{}, error) {
        var m message

        if err := json.Unmarshal(event, &m); err != nil {
            return nil, err
        }

        m.ShortURL = domain + shorten.RandSeq(length)
        m.Timestamp = time.Now().UnixNano()

        return m, nil
    })
}
```

Now you can deploy your application.

```text
apex deploy --region ap-southeast-2
```

To test out the deployed application create a sample `event.json` in the project directory containing the following JSON.

```json
{"url": "https://www.wolfe.id.au/2016/08/12/bootstrap-an-apex-golang-project/"}
```

Then invoke your function.

```text
apex invoke shorten --region ap-southeast-2 < event.json
```

You now have a modular lambda function deployed using apex and golang 🎉🚀.

