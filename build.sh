#!/bin/bash -e

source ./variables.sh

for build in ${BUILDS[@]}; do
    tag=${CONTAINER}/${build}
    echo "building ${build} container with tag ${tag}"
	docker build -t ${tag} \
        -f Dockerfile \
        --target ${build} \
        .

    if [ "${LATEST}" = true ]; then
        echo "setting ${tag} to latest"
        docker tag ${tag} ${CONTAINER}/${build}:latest
    fi
done