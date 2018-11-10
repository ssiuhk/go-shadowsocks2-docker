FROM alpine:latest

ENV LANG=C.UTF-8

ARG ALPINE_GLIBC_PACKAGE_VERSION
ARG GO_SOURCE_URL
ARG SHADOWSOCKS_SOURCE_URL 
ARG USERNAME
ARG GROUPNAME
ARG UID
ARG GID


RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates git tini && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    wget ${GO_SOURCE_URL} -O /tmp/go.linux-amd64.tar.gz && \
    apk add --no-cache wget git tini && \
    cd /usr/local/ && tar zxvf /tmp/go.linux-amd64.tar.gz && \
    rm -rf /tmp/go.linux-amd64.tar.gz && \
    addgroup -g $GID $GROUPNAME && \
    adduser -D -G $GROUPNAME -u $UID $USERNAME

COPY entrypoint.sh /entrypoint.sh
COPY Dockerfile /Dockerfile


USER $USERNAME
WORKDIR /home/${USERNAME}

RUN /usr/local/go/bin/go get -u -v ${SHADOWSOCKS_SOURCE_URL}

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

HEALTHCHECK CMD pidof go-shadowsocks2 > /dev/null || exit 1


