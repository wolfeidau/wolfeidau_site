+++
date = "2016-08-12T03:38:17+10:00"
title = "bootstrap a golang project"
tags = [ "Development", "golang" ]

+++

I have been helping a few people get up and running with [golang](http://golang.org) lately and thought it was about time to post a brief getting started. This is primarily for OSX as this is what most of my colleagues use.

Firstly you will need to install golang and setup your GOPATH. If your on OSX you can just install [homebrew](http://brew.sh/) and use it to install golang.

```
brew install go
```

Then in OSX I append a couple of lines to my `$HOME/.bash_profile` and source the file to update my current environment. On Linux you typically modify your .bashrc.

```
echo 'export GOPATH=$HOME/Code/go' >> ~/.bash_profile
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bash_profile
source ~/.bash_profile
```

Now `go env` should look like.

```
go env | grep GOPATH
GOPATH="/Users/markw/Code/go"
```

We can now bootstrap your workspace to do this we are going to create a tree of folders which match the URL of your [github](https://github.com) projects. Note that you will need to change `name_here` to your github username.

```
mkdir -p $GOPATH/src/github.com/name_here
cd $GOPATH/src/github.com/name_here
```

Now in our workspace create a project folder and setup a sub folder for commands.

```
mkdir -p testproject/cmds/testproject
cd testproject
```

The `cmds` folder enables us to easily override the names of the golang applications we build, these inherit the name of the parent folder. So rather than just having a `testproject` command, I can make sub folders in the cmds directory for testproject-ui, testproject-server and so on.

Lets add a main entry point file to `cmds`.

```
touch testproject/cmds/testproject/main.go
```

Add the following code to our file using an editor.

```go
package main

import fmt

func main() {
    fmt.Println("Hello World!")
}
```

Now you can create a `README.md` and init your git project.

```
touch README.md .gitignore
git init
```

Next steps I recommend getting yourself setup with an editor such as [sublime text](https://www.sublimetext.com/3) which I documented here [Using Sublime Text for Go Development](https://www.wolfe.id.au/2015/03/05/using-sublime-text-for-go-development/).

Once you have an editor you can dig into:

* [How to Write Go Code](https://golang.org/doc/code.html)
* [Go Resources](https://www.golang-book.com/)
