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

FROM ubuntu:latest

ENV SPIDER_INSTALL_DIR=${SPIDER_INSTALL_DIR:-/spider}
ENV SPIDER_USERNAME=${SPIDER_USERNAME:-sysop} SPIDER_UID=${SPIDER_UID:-1000}

COPY scripts/entrypoint.sh /entrypoint.sh

RUN export SPIDER_GIT_REPOSITORY=${SPIDER_GIT_REPOSITORY:-git://scm.dxcluster.org/scm/spider} && \
    export SPIDER_VERSION=${SPIDER_VERSION:-HEAD} && \
    apt-get update && \
    apt-get install -y gcc make git \
        libcpanplus-perl libdigest-sha-perl libio-socket-ssl-perl libnet-telnet-perl libtimedate-perl \
        libyaml-perl libtest-simple-perl libcurses-perl vim-tiny && \
    useradd -u $SPIDER_UID -m $SPIDER_USERNAME && \
    mkdir $SPIDER_INSTALL_DIR && \
    git clone $SPIDER_GIT_REPOSITORY ${SPIDER_INSTALL_DIR} &&  \
    (cd $SPIDER_INSTALL_DIR && git reset --hard $SPIDER_VERSION) && \
    mkdir ${SPIDER_INSTALL_DIR}/local ${SPIDER_INSTALL_DIR}/local_cmd && \
    find ${SPIDER_INSTALL_DIR}/. -type d -exec chmod 2775 {} \; && \
    find ${SPIDER_INSTALL_DIR}/. -type f -name '*.pl' -exec chmod 775 {} \; && \
    (cd ${SPIDER_INSTALL_DIR}/src && make) && \
    chown -R ${SPIDER_USERNAME}:${SPIDER_USERNAME} ${SPIDER_INSTALL_DIR}/. && \
    apt-get -y purge gcc make git && \
    apt -y autoremove && \
    unset SPIDER_GIT_REPOSITORY SPIDER_VERSION TMPDIR

USER $SPIDER_UID
ENTRYPOINT ["/entrypoint.sh"]
