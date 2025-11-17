FROM golang

ENV HUGO_VERSION=0.152.2

# Detect architecture and download the appropriate Hugo binary
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        HUGO_ARCH="linux-amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        HUGO_ARCH="linux-arm64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    curl -sLJO "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_${HUGO_ARCH}.tar.gz" && \
    tar -xzf "hugo_extended_${HUGO_VERSION}_${HUGO_ARCH}.tar.gz" && \
    mv hugo /usr/local/bin/hugo && \
    rm -rf "hugo_extended_${HUGO_VERSION}_${HUGO_ARCH}.tar.gz" LICENSE README.md

RUN hugo version

WORKDIR /src

ENTRYPOINT [ "hugo" ]