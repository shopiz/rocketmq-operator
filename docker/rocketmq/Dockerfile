FROM openjdk:8-alpine
RUN rm -f /etc/localtime \
&& ln -sv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone

ENV LANG en_US.UTF-8

ARG version

# Rocketmq version
ENV ROCKETMQ_VERSION ${version}

# Rocketmq home
ENV ROCKETMQ_HOME  /opt/rocketmq-${version}

WORKDIR  ${ROCKETMQ_HOME}

# Install
RUN set -eux; \
    apk add --virtual .build-deps curl gnupg unzip; \
    apk add --no-cache bash gettext nmap-ncat openssl busybox-extras; \
    curl https://archive.apache.org/dist/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip -o rocketmq.zip; \
    curl https://archive.apache.org/dist/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip.asc -o rocketmq.zip.asc; \
        curl -L https://www.apache.org/dist/rocketmq/KEYS -o KEYS; \
        gpg --import KEYS; \
    gpg --batch --verify rocketmq.zip.asc rocketmq.zip; \
    unzip rocketmq.zip; \
        mv rocketmq-*/* . ; \
        rmdir rocketmq-* ; \
        rm rocketmq.zip ; \
    rm rocketmq.zip.asc KEYS; \
        apk del .build-deps ; \
    rm -rf /var/cache/apk/* ; \
    rm -rf /tmp/*





# ADD rocketmq-all-4.9.3-bin-release.tar.gz /opt/
# RUN mv /opt/rocketmq-all-4.9.3-bin-release /opt/rocketmq-4.9.3 \
# && mkdir -p /data/rocketmq/store

WORKDIR ${ROCKETMQ_HOME}/bin

CMD ["/bin/bash"]
