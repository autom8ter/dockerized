#!/bin/bash -e

DOCKER_REPO=${DOCKER_REPO}
NAMESPACE=${NAMESPACE:-colemanword}
CONTAINER=${DOCKER_REPO}${NAMESPACE}
LATEST=${1:false}
BUILDS=("bash" "protoc" "prototool")