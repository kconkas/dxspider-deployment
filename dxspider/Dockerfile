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

FROM alpine:latest

ARG SPIDER_GIT_REPOSITORY=git://scm.dxcluster.org/scm/spider
# SPIDER_VERSION can be "mojo" or "master"
ARG SPIDER_VERSION=master

ENV SPIDER_INSTALL_DIR=${SPIDER_INSTALL_DIR:-/spider}
ENV SPIDER_USERNAME=${SPIDER_USERNAME:-sysop}
ENV SPIDER_UID=${SPIDER_UID:-1000}

COPY entrypoint.sh /entrypoint.sh

RUN apk update
RUN apk add gcc git make musl-dev \
    ncurses-libs ncurses-dev \
    nano
RUN apk add perl-db_file perl-dev perl-digest-sha1 perl-io-socket-ssl
RUN apk add perl-net-telnet perl-timedate perl-yaml-libyaml
RUN apk add perl-test-simple perl-app-cpanminus
RUN apk add perl-curses perl-mojolicious
RUN apk add perl-math-round perl-json
RUN cpanm --no-wget Data::Structure::Util
RUN adduser -D -u ${SPIDER_UID} -h ${SPIDER_INSTALL_DIR} ${SPIDER_USERNAME}
RUN git config --global --add safe.directory ${SPIDER_INSTALL_DIR}
RUN git clone -b ${SPIDER_VERSION} ${SPIDER_GIT_REPOSITORY} ${SPIDER_INSTALL_DIR}
RUN mkdir -p ${SPIDER_INSTALL_DIR}/local ${SPIDER_INSTALL_DIR}/local_cmd \
    ${SPIDER_INSTALL_DIR}/local_data
RUN find ${SPIDER_INSTALL_DIR}/. -type d -exec chmod 2775 {} \; && \
    find ${SPIDER_INSTALL_DIR}/. -type f -name '*.pl' -exec chmod 775 {} \;
RUN (cd ${SPIDER_INSTALL_DIR}/src && make)
RUN chown -R ${SPIDER_USERNAME}:${SPIDER_USERNAME} ${SPIDER_INSTALL_DIR}/.
RUN apk del --purge gcc git make \
    musl-dev ncurses-dev perl-app-cpanminus perl-dev
RUN rm -rf /var/cache/apk/*

USER ${SPIDER_UID}
ENTRYPOINT ["/bin/sh"]
CMD ["/entrypoint.sh"]
