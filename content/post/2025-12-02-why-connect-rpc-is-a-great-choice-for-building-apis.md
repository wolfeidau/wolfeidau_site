+++
title = "Why Connect RPC is a great choice for building APIs"
date = "2025-12-02T08:55:22+10:00"
tags = [ "gRPC", "authentication", "security", "software development", "developer tools", "apis"]
+++

[Connect RPC](https://connectrpc.com/) is a suite of libraries which enable you to build HTTP based APIs which are gRPC compatible. It provides a bridge between [gRPC](https://grpc.io/) and HTTP/1.1, allowing you to use the best of both worlds. This makes it a great solution for teams looking to get the performance benefits of gRPC, while still being able to support HTTP/1.1 clients.

Connect RPC can be used to build both internal and external APIs, powering frontends, mobile apps, CLIs, agents and more. See the list of [supported languages](https://github.com/connectrpc).

Connect RPC provides a number of features out of the box, such as:

- Authentication, which is achieved using [Connect RPC interceptors](https://connectrpc.com/docs/go/interceptors) that make it easy to implement different authentication mechanisms.
- [Serialization & compression](https://connectrpc.com/docs/go/serialization-and-compression), with pluggable serializers, and support for asymmetric compression reducing the amount of data that needs to be transmitted, or received.
- [Error handling](https://connectrpc.com/docs/go/errors), with a standard error format, with support for custom error codes to allow for more granular error handling.
- [Observability](https://connectrpc.com/docs/go/observability), with in built support for OpenTelemetry enabling you to easily add tracing, or metrics to your APIs.
- [Streaming](https://connectrpc.com/docs/go/streaming), which provides a very efficient way to push or pull data without polling.
- [Schemas](https://connectrpc.com/docs/protocol/#summary), which enable you to define and validate your API schemas, and generate code from them.
- [Code generation](https://connectrpc.com/docs/web/generating-code/#local-generation) for [Go](https://go.dev), [TypeScript](https://www.typescriptlang.org/), [Kotlin](https://kotlinlang.org/), [Swift](https://developer.apple.com/swift/) and [Java](https://www.java.com/en/).

In addition to these features, Connect RPC is built on top of the Buf ecosystem, which offers notable benefits:

- [Connect RPC joins CNCF](https://buf.build/blog/connect-rpc-joins-cncf), entering the cloud-native ecosystem, which is great for the long term sustainability of the project.
- [Buf Schema Registry](https://buf.build/product/bsr), which is a great tool for managing, sharing and versioning your API schemas.
- [Buf CLI](https://buf.build/product/cli), a handy all in one tool for managing your APIs, generating code and linting.

## Summary

1. Connect RPC provides a paved and well maintained path to building gRPC compatible APIs, while maintaining compatibility for HTTP/1.1 clients. This is invaluable for product teams that need to support multiple client types without building custom compatibility layers.

2. Using a mature library like Connect RPC, you get to benefit from all the prebuilt integrations, and the added capabilities of the Buf ecosystem. This makes publishing and consuming APIs a breeze.

3. Protobuf schemas, high performance serialisation and compression ensure you get robust and efficient APIs.

## Conclusion

Connect RPC makes it easy to build high-performance, robust APIs with gRPC compatibility, while avoiding the complexity of building and maintaining custom compatibility layers.
