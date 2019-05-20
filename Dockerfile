ARG alpine=3.8
ARG go=1.11.0

FROM golang:$go-alpine$alpine AS build

WORKDIR /build
COPY scripts/* ./
RUN chmod +x *.sh
RUN set -ex && apk --update --no-cache add \
        bash \
        make \
        cmake \
        autoconf \
        automake \
        curl \
        tar \
        libtool \
        g++ \
        git \
        openjdk8-jre \
        libstdc++ \
        ca-certificates \
        nss

RUN make init

FROM alpine:$alpine AS main-build

RUN set -ex && apk --update --no-cache add \
    bash \
    libstdc++ \
    libc6-compat \
    ca-certificates


COPY --from=build /usr/local/lib/* /usr/local/lib/
COPY --from=build /usr/local/bin/* /usr/local/bin/
COPY --from=build /usr/local/lib/* /usr/local/lib/
COPY --from=build /build/* /build/

WORKDIR /main

# protoc
FROM main-build AS protoc
ENTRYPOINT [ "protoc", "-I/opt/include" ]

# prototool
FROM main-build AS prototool
ENTRYPOINT [ "prototool" ]

# bash
FROM main-build AS bash
ENTRYPOINT [ "bash", "-c" ]
