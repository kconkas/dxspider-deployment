#!/bin/bash

#   Copyright 2018 Kristijan Conkas
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


DEFAULT_PARAMS_ENV=${PWD}/default.env
ARM_PARAMS_ENV=${PWD}/arm.env
TAG=

print_help() {
	echo "Usage: $0 -t <image tag>"
}

while getopts ":ht:" opt; do
  case $opt in
    h)  print_help
        exit 0
        ;;
    t)  TAG=$OPTARG
        ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

[ -z "${TAG}" ] &&  {
    echo "No parameters specified. Use \"$0 -h\" for usage instructions."
    exit 2
}

case $(uname -m) in
	armv*)
		. ${ARM_PARAMS_ENV}
		;;
	*)
		. ${DEFAULT_PARAMS_ENV}
		;;
esac

docker build -t ${TAG} -f Dockerfile --build-arg IMAGE=${IMAGE} --build-arg IMAGE_TAG=${IMAGE_TAG} .
