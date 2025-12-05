+++
title = "Why Connect RPC is a great choice for building APIs"
date = "2025-12-02T08:55:22+10:00"
tags = [ "gRPC", "authentication", "security", "software development", "developer tools", "apis"]
+++

[Connect RPC](https://connectrpc.com/) is a suite of libraries which enable you to build HTTP based APIs which are gRPC compatible. It provides a bridge between [gRPC](https://grpc.io/) and HTTP/1.1, letting you leverage HTTP/2's multiplexing and performance benefits while still supporting HTTP/1.1 clients. This makes it a great solution for teams looking to get the performance benefits of gRPC, while maintaining broad client compatibility.

HTTP/2's multiplexing and binary framing make it significantly more efficient than HTTP/1.1, reducing latency and improving throughput. Connect RPC lets you harness these benefits while maintaining broad client compatibility for services that can't yet support HTTP/2.

Connect RPC can be used to build both internal and external APIs, powering frontends, mobile apps, CLIs, agents and more. See the list of [supported languages](https://github.com/connectrpc).

## Core Features

Connect RPC provides a number of features out of the box, such as:

- [Interceptors](https://connectrpc.com/docs/go/interceptors) which make it easy to extend Connect RPC and are used to add authentication, logging, metrics, tracing and retries.
- [Serialization & compression](https://connectrpc.com/docs/go/serialization-and-compression), with pluggable serializers, and support for asymmetric compression reducing the amount of data that needs to be transmitted, or received.
- [Error handling](https://connectrpc.com/docs/go/errors), with a standard error format, with support for custom error codes to allow for more granular error handling.
- [Observability](https://connectrpc.com/docs/go/observability), with in built support for OpenTelemetry enabling you to easily add tracing, or metrics to your APIs.
- [Streaming](https://connectrpc.com/docs/go/streaming), which provides a very efficient way to push or pull data without polling.
- [Schemas](https://connectrpc.com/docs/protocol/#summary), which enable you to define and validate your API schemas, and generate code from them.
- [Code generation](https://connectrpc.com/docs/web/generating-code/#local-generation) for [Go](https://go.dev), [TypeScript](https://www.typescriptlang.org/), [Kotlin](https://kotlinlang.org/), [Swift](https://developer.apple.com/swift/) and [Java](https://www.java.com/en/).

## Ecosystem

In addition to these features, Connect RPC is built on top of the Buf ecosystem, which offers notable benefits:

- [Connect RPC joins CNCF](https://buf.build/blog/connect-rpc-joins-cncf), entering the cloud-native ecosystem, which is great for the long term sustainability of the project.
- [Buf Schema Registry](https://buf.build/product/bsr), which is a great tool for managing, sharing and versioning your API schemas.
- [Buf CLI](https://buf.build/product/cli), a handy all in one tool for managing your APIs, generating code and linting.

## Recommended Interceptor Packages

Some handy Go packages that provide pre-built Connect RPC interceptors worth exploring or using as a starting point:

- [authn-go](https://github.com/connectrpc/authn-go), provides a rebuilt authentication middleware library for Go. It works with any authentication scheme (including HTTP basic authentication, cookies, bearer tokens, and mutual TLS).
- [validate-go](https://github.com/connectrpc/validate-go) provides a Connect RPC interceptor that takes the tedium out of data validation. This package is powered by [protovalidate](https://github.com/bufbuild/protovalidate-go)
and the [Common Expression Language](https://github.com/google/cel-spec).
- [rpclog](https://github.com/mdigger/rpclog) provides a structured logging interceptor for Connect RPC with support for both unary and streaming RPCs.

## Summary

1. Connect RPC provides a paved and well maintained path to building gRPC compatible APIs, while maintaining compatibility for HTTP/1.1 clients. This is invaluable for product teams that need to support multiple client types without building custom compatibility layers.

2. Using a mature library like Connect RPC, you get to benefit from all the prebuilt integrations, and the added capabilities of the Buf ecosystem. This makes publishing and consuming APIs a breeze.

3. Protobuf schemas, high performance serialisation and compression ensure you get robust and efficient APIs.

## Conclusion

Connect RPC makes it easy to build high-performance, robust APIs with gRPC compatibility, while avoiding the complexity of building and maintaining custom compatibility layers.
