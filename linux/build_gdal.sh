#!/bin/bash

docker run -v ${PWD}:/scripts --rm -it mavlink/qgc-build-linux /scripts/build_docker.sh
