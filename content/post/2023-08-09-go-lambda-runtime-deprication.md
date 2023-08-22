+++
title = "RIP AWS Go Lambda Runtime"
date = "2023-08-09T08:55:22+10:00"
tags = [ "aws", "cloud", "docker" ]
draft = false
+++

[Amazon Web Services (AWS)](https://aws.amazon.com/) is [deprecating the `go1.x` runtime on Lambda](https://aws.amazon.com/blogs/compute/migrating-aws-lambda-functions-from-the-go1-x-runtime-to-the-custom-runtime-on-amazon-linux-2/), this is currently scheduled for December 31, 2023. Customers need to migrate their Go based lambda functions to the `al2.provided` runtime, which uses [Amazon Linux 2](https://aws.amazon.com/amazon-linux-2/) as the execution environment. I think this is a bad thing for a couple of reasons:

1. There is no automated migration path from existing [Go](https://go.dev) Lambda functions to the new custom runtime. Customers will need to manually refactor and migrate each function to this new runtime, which this is time-consuming and error-prone.
2. This will remove `Go1.x` name from the lambda console, Go will now just be another "custom" runtime instead of a first class supported language. This makes Go development on Lambda seem less official/supported compared to other languages like Node, Python, Java etc.

Case in point, try searching for "al2.provided lambda" on Google and see how little documentation comes up compared to "go1.x lambda". The migration essentially removes the branding and discoverability of Go as a Lambda language, I am sure this will improve over time, but it is still ambiguous.

There are articles on the advantages of the `al2.provided` runtime, including how to migrate functions over to it, such as https://www.capitalone.com/tech/cloud/custom-runtimes-for-go-based-lambda-functions/.

# Why is this hard?

The main reason migrating Go Lambda functions to the new runtime is difficult is because:

1. Unlike the runtime provided for other languages, the custom runtime doesn't use the `Handler` parameter to determine the function entry point, this value is ignored, but still required. This is a subtle difference can cause issues if developers are unaware or don't read the documentation closely. 
2. The lambda service doesn't check if the bootstrap entry point exists in the archive, so customers may deploy broken functions if they don't validate this. Sadly, this is NOT very intuitive, and often leads to confusion and errors.

**Note:** As pointed out by [@Aidan W Steele](https://twitter.com/__steele) some deployment tools upload empty archives, then later replace them with an updated archive containing the deployed code, so this could be problematic.

For those interested in what the error looks like if you're missing the bootstrap file, it will return:

```
{"errorType":"Runtime.InvalidEntrypoint","errorMessage":"RequestId: d604d105-51be-49ce-8457-eee1641398eb Error: Couldn't find valid bootstrap(s): [/var/task/bootstrap /opt/bootstrap]"}
```

If you see this, you need to validate your deployment package contains the required `bootstrap` file in the root of the zip archive.

# Why is removing Go 1.x a bad idea?

There will be no `Go` Lambda runtime available after this date, this will be more of an issue for developers who have never used AWS and expect lambda to have a Go runtime available out of the box. This is a change that will require some education and guidance for new developers.

Some of the drawbacks of this are:

1. You won't be able to see Go functions directly in the Lambda console anymore. Go will just be another "custom" runtime instead of a first class supported language like Node, Python, Java etc. This makes Go development on Lambda seem less official/supported.
2. Developers will find samples or projects using the old Go 1.x runtime that no longer work out of the box. This will lead to confusion as they try to migrate those functions over to the new runtime.
3. Listing lambda functions by runtime used will no longer show "Go1.x" making it less clear if a function was written for Go or another language like Rust or Nim that also use the custom runtime.
4. Finding code samples for Go lambda functions on GitHub or tutorials will need to specify if they are using the old or new runtime. A lot of existing content will be outdated immediately.

# What can AWS do better?

So what could AWS do to mitigate some of these issues? Here are a few suggestions:

1. Provide an updated `go1.al2`, which would match the pattern of Java [update `java8.al2` runtime announced a few years ago](https://aws.amazon.com/blogs/compute/migrating-aws-lambda-functions-to-al2/). This updated runtime would use the same entry point convention as the other languages like Node, Python etc and retain the existing user experience, avoiding the hard coded `bootstrap` file which is not very intuitive.
2. Add validation to the deployment process to check for the required bootstrap file, and prevent deployment of invalid archives. This would avoid broken functions being deployed.

I am disappointed that AWS did not invest a bit more time in listening to customers around the usability of the `al2.provided` runtime. Customers are used to compiling applications to a binary with a descriptive name, then deploying that binary to AWS, having to output a specific file called `bootstrap` is not very intuitive or discoverable.

# Examples

To illustrate the differences I have included some examples, hopefully this helps those not familiar with lambda see the challenges.

## Building

This is an example compile command for go based function prior to migration, this will build all commands using the name of the directory as their binary name, then zip up all the binaries with a name ending in `-lambda`.

```
build:
  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -trimpath -o dist ./cmd/...

archive:
  cd dist && zip -X -9 ./deploy.zip *-lambda
```

With this migration, developers will need to package each of their functions to include a bootstrap file, and upload each archive to s3 individually rather than zipping multiple binaries together.

## Deployment Configuration Examples

This is an example sam template for a go based function prior to migration:

```yaml
  ExampleFunction:
    Type: AWS::Serverless::Function
    Properties:
      Runtime: go1.x
      # this is a example archive containing one or more go binary files
      CodeUri: ../../dist/deploy.zip  
      # note example is the name of the compiled go binary file
      Handler: example-lambda
```

This is an example sam template for a go based function after migration:

```yaml
  ExampleFunction:
    Type: AWS::Serverless::Function
    Properties:
      Runtime: provided.al2
      # example archive which must contain a file named bootstrap, 
      # which is not referenced or checked during deploy.
      CodeUri: ../../dist/example_Linux_arm64.zip
      # unused by this runtime but still required and can 
      # cause some confusion with developers if not aware
      Handler: nope 
```

# Closing Thoughts

While the custom runtime provides better performance, and an updated operating system, the change will require effort for many Go developers on AWS Lambda. Some automated assistance and validation from AWS could help reduce friction and issues from this change.

Personally I am sad to see AWS lambda remove Go as a first class language, as an early adopter of serverless it felt great to have Go supported out of the box. I will miss seeing the gopher logo when browsing functions! 😞🪦

Overall, I think this will negatively the adoption of Go in AWS lambda, at least in the short term, as a lot of developers will find the custom runtime requirements unfamiliar and confusing compared to other runtimes.

As is often the case, new developers will likely struggle most with the `provided.al2`, then most likely give up and use another language instead of taking the time to understand the custom runtime complexities. 

What are your thoughts on the migration and how AWS could improve the experience?

# Updates

Thanks to [@Aidan W Steele](https://twitter.com/__steele) for the feedback on my `go2.x` suggestion with a much better one of `go1.al2` which would match the pattern of `java8.al2`, and reminder of the various empty zip file shenanigans used in some deployment tools.