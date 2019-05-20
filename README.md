# Dockerized

This repo is used to build docker containers loaded with common dependencies that may be used as command line interfaces.

Current Containers:
    colemanword/bash
    colemanword/prototool 
    colemanword/protoc
    
    
    docker run -v `pwd`:/build colemanword/bash
    docker run -v `pwd`:/build colemanword/prototool
    docker run -v `pwd`:/build colemanword/protoc