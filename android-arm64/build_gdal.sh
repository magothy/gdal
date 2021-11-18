#!/bin/bash

docker run -v ${PWD}:/scripts --rm -it rhardih/stand:r17c--android-21--aarch64-linux-android-4.9 /scripts/build_docker.sh
