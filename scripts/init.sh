#!/bin/bash -e

curl -sSL https://github.com/gflags/gflags/archive/v2.2.1.tar.gz -o gflags.tar.gz && tar -xzvf gflags.tar.gz
cd gflags-2.2.1/
cmake .
make
make install

cd /build

echo "cloning grpc repo"
git clone -b v1.21.x --recursive -j8 https://github.com/grpc/grpc
cd /build/grpc
echo "building grpc packages"
make
make install

cp /build/grpc/bins/opt/protobuf/protoc /usr/local/bin/

echo "building grpc third-party packages"
cd /build/grpc/third_party/protobuf
make
make install

#swift
echo "installing grpc-swift"
cd /build
git clone https://github.com/grpc/grpc-swift
cd grpc-swift
make plugin
chmod +x protoc-gen-swiftgrpc
chmod +x protoc-gen-swift
mv protoc-gen-swiftgrpc /usr/local/bin/protoc-gen-swiftgrpc
mv protoc-gen-swift /usr/local/bin/protoc-gen-swift


echo "installing grpc-java"
cd /build
git clone -b v1.21.x --recursive https://github.com/grpc/grpc-java.git
cd /build/grpc-java/compiler
../gradlew java_pluginExecutable


echo "installing prototool"
cd /build
curl -sSL https://github.com/uber/prototool/releases/download/v1.3.0/prototool-$(uname -s)-$(uname -m) \
    -o /usr/local/bin/prototool && \
    chmod +x /usr/local/bin/prototool

echo "installing grpc-web"
cd /build
curl -sSL https://github.com/grpc/grpc-web/releases/download/1.0.3/protoc-gen-grpc-web-1.0.3-linux-x86_64 \
    -o /usr/local/bin/grpc_web_plugin && \
    chmod +x /usr/local/bin/grpc_web_plugin


echo "installing googleapis"
cd /build
git clone https://github.com/googleapis/googleapis


echo "installing golang plugins"
cd /build
go get -u \
    google.golang.org/grpc \
    github.com/myitcv/gobin

gobin \
    github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway \
    github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
    github.com/golang/protobuf/protoc-gen-go \
    github.com/gogo/protobuf/protoc-gen-gogo \
    github.com/gogo/protobuf/protoc-gen-gogofast \
    github.com/gogo/protobuf/protoc-gen-gogoslick \
    github.com/ckaznocha/protoc-gen-lint \
    github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc \
    github.com/fiorix/protoc-gen-cobra \
    github.com/golang/lint/golint \
    golang.org/x/tools/cmd/goimports \
    github.com/kisielk/errcheck \
    github.com/golang/mock/mockgen \
    github.com/google/wire/cmd/wire \
    github.com/golangci/golangci-lint/cmd/golangci-lint \
    github.com/hashicorp/go-getter/cmd/go-getter \
    github.com/spf13/cobra \
    github.com/jteeuwen/go-bindata/go-bindata


##/usr/local/bin
mv /go/bin/* /usr/local/bin/
mv /build/grpc/bins/opt/grpc_*  /usr/local/bin/
mv /build/grpc/bins/opt/protobuf/protoc  /usr/local/bin/
mv /build/grpc-java/compiler/build/exe/java_plugin/protoc-gen-grpc-java /usr/local/bin/

##/usr/local/lib
mv /build/grpc/libs/opt/  /usr/local/lib/


