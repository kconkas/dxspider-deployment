FROM ubuntu:latest

ENV SPIDER_INSTALL_DIR=${SPIDER_INSTALL_DIR:-/spider}
ENV SPIDER_USERNAME=${SPIDER_USERNAME:-sysop} SPIDER_UID=${SPIDER_UID:-1000}

COPY scripts/entrypoint.sh /entrypoint.sh

RUN export SPIDER_GIT_REPOSITORY=${SPIDER_GIT_REPOSITORY:-git://scm.dxcluster.org/scm/spider} && \
    export SPIDER_VERSION=${SPIDER_VERSION:-HEAD} && \
    apt-get update && \
    apt-get install -y gcc make git \
        libcpanplus-perl libdigest-sha-perl libio-socket-ssl-perl \
        libnet-telnet-perl libtimedate-perl libyaml-perl libtest-simple-perl libcurses-perl && \
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
