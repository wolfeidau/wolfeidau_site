+++
title = "My Development Environment"
date = "2022-07-23T22:00:00+10:00"
tags = [ "golang", "development", "aws", "vscode" ]
+++

I was inspired by others to document the tools I use working as a software developer professionally, and hacking on side projects out side of work.

One thing to note is in my day job I work on an Apple Mac, but my personal machine is a Linux laptop running [PopOS](https://pop.system76.com/). I find using Linux as a desktop works as most software I use is web based or supported on linux. I also use it for IoT development as pretty much all the tool chains I use supports it.

On a whole over the years I have moved to a more minimal setup, primarily to keep things simple, **less** is easier to maintain, easier to share, and more likely to be adopted by others.

The stack I work with professionally is pretty varied, but can be summarized as:

* [Amazon Web Services (AWS)](https://aws.amazon.com/), I work primarily this cloud platform in my day job
* [Cloudformation](https://aws.amazon.com/cloudformation/), native AWS infrastructure deployment
* [Go](https://go.dev), great language for building tools, apis, and backend services
* [Python](https://www.python.org/), used for cloud orchestration, scripting and machine learning
* [NodeJS](https://nodejs.org/en/) often using [Typescript](https://www.typescriptlang.org/), for frontend development
* [Git](https://git-scm.com/), used for all things source code

## CLI Tools

I primarily use zsh as my shell, sticking to a pretty minimal setup tools wise. 

* [Docker](https://www.docker.com/) for containers which I mainly for testing.
* [direnv](https://direnv.net/) which is used to change environment settings in projects.
* [The Silver Searcher](https://github.com/ggreer/the_silver_searcher) a faster search tool for the cli, `ag` is my goto for locating stuff in files when developing.
* [Git Hub CLI](https://github.com/cli/cli), makes working with GitHub from the CLI a dream.
* [AWS CLI](https://awscli.amazonaws.com/v2/documentation/api/latest/index.html) is used to write scripts and diagnosing what is up with my cloud.
* [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html) for deploying cloudformation in a semi sane way.
* [nvm](https://github.com/nvm-sh/nvm), nodejs changes a lot so I often need a couple of versions installed to support both new and old software.
* [Git Prompt](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh) for a dash more information in my shell about the current trees Git status.
* [gnupg](https://gnupg.org/), which I mostly use for Signing of Git commits and software, and a bit of data encryption.

Most of my builds done using the good old `Makefile` so I always have [make](https://www.gnu.org/software/make/) installed.

## Editor

Currently I use [vscode](https://code.visualstudio.com/) when developing, it is one of the first things I open each day. I was a vim user but moved to vscode as I prefer to use a more approachable editor, especially as I work with developers and "non tech" people and they find it less daunting to learn.

I am trying to help **everyone** code, so using an approachable editor is **really** helpful!

To support the stack I use the following plugins:

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