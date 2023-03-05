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
#
#   This is a base image that is used to set up the pre-requisites for the 
#   subsequent configuraiton and application layers to be added to create the
#   final Docker image.

FROM alpine:latest

ARG USER=${USER:-1000}
ARG GROUP=${GROUP:-251}
ENV USER=$USER
ENV GROUP=$GROUP
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
RUN addgroup -g $GROUP spider && \
    adduser --shell /sbin/nolin --disabled-password \
    --no-create-home --uid $USER --ingroup spider sysop && \
    apk update && \
    apk upgrade && \
    apk add su-exec && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

RUN apk add \
    build-base \
    dumb-init \
    gcc \
    git \
    make \
    musl-dev \
    nano \
    perl-app-cpanminus \
    perl-curses \
    perl-db_file \
    perl-dev \
    perl-digest-sha1 \
    perl-io-socket-ssl \
    perl-json \
    perl-json-xs \
    perl-math-round \
    perl-mojolicious \
    perl-net-telnet \
    perl-timedate \
    perl-yaml-libyaml

RUN cpanm --no-wget Data::Structure::Util Net::CIDR::Lite EV Math::Round && \
    apk del --purge \
    perl-app-cpanminus && \
    rm -rf /var/cache/apk
