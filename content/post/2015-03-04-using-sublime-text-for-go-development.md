+++
date = "2015-03-05T00:10:18+11:00"
title = "Using Sublime Text for Go Development"
Categories = [ "sublime", "golang", "development" ]

+++

For the last 6 months I have been using [Go](http://golang.org) as my primary development language and for a large part of that I have been using [sublime text 3](http://www.sublimetext.com/3). Along the way the go developers have released quite a few handy and time saving tools which have all been supported by [GoSublime](https://github.com/DisposaBoy/GoSublime) with some assembly required. This post will provide a rundown on how to setup go-sublime and the array of tools which make golang development as productive as possible.

Once you have setup your `GOPATH` the way you like it you can install some tools.

```
go get -u golang.org/x/tools/cmd/goimports
go get -u golang.org/x/tools/cmd/vet
go get -u golang.org/x/tools/cmd/oracle
go get -u golang.org/x/tools/cmd/godoc
```

Then install [package control](https://packagecontrol.io/installation) in your Sublime editor and add the following plugins.

* [GoSublime](https://github.com/DisposaBoy/GoSublime)
* [GoOracle](https://github.com/waigani/GoOracle)

Then using update your GoSublime user configuration by opening Preferences -> Package Settings -> GoSublime -> Settings User which should open your `GoSublime.sublime-settings` file, below is the contents of mine.

{{< highlight javascript >}}
{

	// you may set specific environment variables here
	// e.g "env": { "PATH": "$HOME/go/bin:$PATH" }
	// in values, $PATH and ${PATH} are replaced with
	// the corresponding environment(PATH) variable, if it exists.
	"env": {"GOPATH": "$HOME/Code/go", "PATH": "$GOPATH/bin:$PATH" },

  "fmt_cmd": ["goimports"],

	// enable comp-lint, this will effectively disable the live linter
	"comp_lint_enabled": true,

	// list of commands to run
	"comp_lint_commands": [
	    // run `golint` on all files in the package
	    // "shell":true is required in order to run the command through your shell (to expand `*.go`)
	    // also see: the documentation for the `shell` setting in the default settings file ctrl+dot,ctrl+4
	    {"cmd": ["golint *.go"], "shell": true},

	    // run go vet on the package
	    {"cmd": ["go", "vet"]},

	    // run `go install` on the package. GOBIN is set,
	    // so `main` packages shouldn't result in the installation of a binary
	    {"cmd": ["go", "install"]}
	],

	"on_save": [
	    // run comp-lint when you save,
	    // naturally, you can also bind this command `gs_comp_lint`
	    // to a key binding if you want
	    {"cmd": "gs_comp_lint"}
	]
}
{{< /highlight >}}

Note: Ensure you update the `GOPATH` value to reflect where yours is located.

Once you restart sublime you should be ready to roll!

In addition to these plugins I also use [GitGutter](https://github.com/jisaacks/GitGutter) which provides some highlighting of changes for source code under `git`.