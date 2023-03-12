#!/bin/sh
#   Copyright 2023 Brian Stucker
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

set -e

# Check to see if the current user is root
if [ "$(id -u)" = '0' ]
then
    # They are, switch to our local user.
    exec su-exec $USER dumb-init "$@"
fi
exec dumb-init "$@"
