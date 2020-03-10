+++
title = "Starting a Go Project"
date = "2020-03-10T04:00:00+11:00"
tags = [ "Go", "Golang", "development" ]
+++

Given the changes with [Go Modules](https://blog.golang.org/using-go-modules) I wanted to document a brief getting started for Go projects, this will focus on building a minimal web service.

Before you start you will need to install Go, I recommend using [homebrew](https://brew.sh/) or for ubuntu users [Golang Backports](https://launchpad.net/~longsleep/+archive/ubuntu/golang-backports), or as last resort grab it from the [Go Downloads](https://golang.org/dl/) page.

So this looks like this for OSX.

```
brew install go
```

Or for [ubuntu](https://ubuntu.com/) we add the PPA, then install golang 1.14 and update our path.

```
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt-get update
sudo install golang-1.14
echo 'export PATH=$PATH:/usr/lib/go-1.14/bin' >> ~/.bashrc
source ~/.bashrc
```

Now we should be able to run.

```
go version
```

Now navigate to where you build your projects, for me this is `~/Code/goprojects` and make a folder.

```
cd ~/Code/goprojects
mkdir simple-go-service
cd  simple-go-service
```

Before we start adding code lets initiliase our project, you should replace *USERNAME* with your github username, for me it is [wolfeidau](https://github.com/wolfeidau).

```
github.com/USERNAME/simple-go-service
```

Now for me I follow a pattern of storing the entry point in a `cmd` folder, this is done so I can easily customise the name of the binary as `go` uses the parent folder name executables.

```
mkdir -p cmd/simple-service
touch cmd/simple-service/main.go
```

Now add some code to the `main.go` you created in the previous command, this will listen on port `:8000` for web requests.

```go
package main

import (
	"io"
	"log"
	"net/http"
)

func main() {
	// Hello world, the web server

	helloHandler := func(w http.ResponseWriter, req *http.Request) {
		io.WriteString(w, "Hello, world!\n")
	}

	http.HandleFunc("/hello", helloHandler)
    log.Println("Listing for requests at http://localhost:8000/hello")
	log.Fatal(http.ListenAndServe(":8000", nil))
}
```

Now run this with the following command.

```
go run cmd/simple-service/main.go
```

This should print out a URL you can navigate to in your browser and see the classic `Hello, world!`.

Now from here you will want to setup an editor, I personnally use [vscode](https://code.visualstudio.com/) which has really good support for golang once you add the [go plugin](https://github.com/Microsoft/vscode-go).

From here I would recommend looking at something like [echo](https://echo.labstack.com/) which is a great web framework, it is well documented and has lots of great [examples](https://github.com/labstack/echox/tree/master/cookbook).

To add this library either just add the import in your editor, vscode will automatically trigger a download of libraries or run.

```
go get -u -v github.com/labstack/echo/v4
```

**NOTE:** We are using the `v4` tagged import as we are using Go Modules, also I have also ensure this v4 tag is in the imports in the following example.

And update the `main.go` to use this great little REST crud example.

```go
package main

import (
	"net/http"
	"strconv"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

type (
	user struct {
		ID   int    `json:"id"`
		Name string `json:"name"`
	}
)

var (
	users = map[int]*user{}
	seq   = 1
)

//----------
// Handlers
//----------

func createUser(c echo.Context) error {
	u := &user{
		ID: seq,
	}
	if err := c.Bind(u); err != nil {
		return err
	}
	users[u.ID] = u
	seq++
	return c.JSON(http.StatusCreated, u)
}

func getUser(c echo.Context) error {
	id, _ := strconv.Atoi(c.Param("id"))
	return c.JSON(http.StatusOK, users[id])
}

func updateUser(c echo.Context) error {
	u := new(user)
	if err := c.Bind(u); err != nil {
		return err
	}
	id, _ := strconv.Atoi(c.Param("id"))
	users[id].Name = u.Name
	return c.JSON(http.StatusOK, users[id])
}

func deleteUser(c echo.Context) error {
	id, _ := strconv.Atoi(c.Param("id"))
	delete(users, id)
	return c.NoContent(http.StatusNoContent)
}

func main() {
	e := echo.New()

	// Middleware
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	// Routes
	e.POST("/users", createUser)
	e.GET("/users/:id", getUser)
	e.PUT("/users/:id", updateUser)
	e.DELETE("/users/:id", deleteUser)

	// Start server
	e.Logger.Fatal(e.Start(":1323"))
}
```

Now run this with the following command.

```
go run cmd/simple-service/main.go
```

Hopefully you have managed to get this service running and started testing it with something like [postman](https://www.postman.com/) :tada:.

For next steps I recommend reading [How do I Structure my Go Project?]({{< ref "2020-03-11-how-do-i-structure-my-go-project.md" >}}).