#!/bin/bash

docker run -v ${PWD}:/scripts --rm -it rhardih/stand:r10e--android-21--arm-linux-androideabi-4.9 /scripts/build_docker.sh
