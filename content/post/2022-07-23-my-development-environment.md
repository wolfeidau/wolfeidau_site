+++
title = "My Development Environment"
date = "2022-07-23T22:00:00+10:00"
tags = [ "golang", "development", "aws", "vscode" ]
+++

I was inspired by others to capture some of the tools I use working as a software developer professionally, along with a healthy dash of out of work time hacking.

One thing which is maybe a little unusual is I work on an Apple Mac, but my personal machine which I often develop out of hours is a Linux laptop running [PopOS](https://pop.system76.com/). I find using Linux as a desktop ensures I have a good feel for the operating system I use most in production, and I like using it for IoT development as pretty much everything works on it.

On a whole over the years I have moved to a more minimal setup, primarily to keep things simple, less is easier to maintain and also easier to share with colleagues.

The stack I work with professionally is pretty varied, but can be summarized as:

* [Amazon Web Services (AWS)](https://aws.amazon.com/), I work primarily this cloud platform in my day job
* [Cloudformation](https://aws.amazon.com/cloudformation/), native AWS infrastructure deployment
* [Go](https://go.dev), tooling and apis, backend services
* [Python](https://www.python.org/), used for cloud orchestration, scripting and machine learning
* [NodeJS](https://nodejs.org/en/) using [Typescript](https://www.typescriptlang.org/), for web development
* [Git](https://git-scm.com/), used for all things source code

## CLI Tools

I primarily use zsh as my shell, sticking to a pretty minimal setup tools wise. 

* [Git Prompt](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh) for a dash more information in my shell about the current trees Git status.
* [direnv](https://direnv.net/) which is used to change environment settings in projects.
* [The Silver Searcher](https://github.com/ggreer/the_silver_searcher) a faster search tool for the cli, `ag` is my goto for locating stuff in files when developing.
* [Git Hub CLI](https://github.com/cli/cli), makes working with GitHub from the CLI a dream.
* [AWS CLI](https://awscli.amazonaws.com/v2/documentation/api/latest/index.html) is used to write scripts and diagnosing what is up with my cloud.
* [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html) for deploying cloudformation in a semi sane way.

Most of my builds done using the good old `Makefile`.

## Editor

I use [vscode](https://code.visualstudio.com/) when developing, it is one of the first things I open each day. I was a vim user but have moved to vscode as I prefer a more out of the box editor, especially as I work a lot of other developers and non tech people and they find it less daunting to learn.

I am trying to help **everyone** code, so using an out of the box tool is **really** helpful when collaborating with people.

To support this stack I use the following plugins:

* [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker), I really hate misspelling words in my code.
* [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig), handy way to keep things consistently formatted across editors when working in a team.
* [GitLens — Git supercharged](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens), helps me figure out what changed and who changed it without leaving my editor.
* [Go](https://marketplace.visualstudio.com/items?itemName=golang.Go), primary language I develop in.
* [indent-rainbow](https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow), this addon keeps me sane when editing whitespace sensitive languages such as python and YAML!
* [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python), tons of stuff uses this language so I always end up using it.
* [vscode-cfn-lint](https://marketplace.visualstudio.com/items?itemName=kddejong.vscode-cfn-lint), avoiding obvious errors and typos in my cloudformation templates saves a ton of time and frustration.
* [TODO Highlight](https://marketplace.visualstudio.com/items?itemName=wayou.vscode-todo-highlight), I always try and add information and notes to my code, this helps highlight the important stuff.
* [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml), most of the tools I deploy with use it for configuration so I need a good linter.
* [GitHub Theme](https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme), I use the dimmed dark mode which is really nice comfortable coding theme.