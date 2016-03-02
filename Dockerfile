FROM debian

# TODO(hkjn): Use hkjn/arch as base.

MAINTAINER Henrik Jonsson <me@hkjn.me>

ENV TOR_VERSION 6.0a1-hardened
ENV LANG C.UTF-8
ENV RELEASE_FILE tor-browser-linux64-${TOR_VERSION}_ALL.tar.xz
ENV RELEASE_KEY 0x4E2C6E8793298290
ENV CHECKSUMS_FILE sha256sums-unsigned-build.txt
ENV CHECKSUMS_URL https://dist.torproject.org/torbrowser/${TOR_VERSION}/${CHECKSUMS_FILE}
ENV RELEASE_URL https://dist.torproject.org/torbrowser/${TOR_VERSION}/${RELEASE_FILE}

RUN apt-get update && \
    apt-get install -y \
      ca-certificates \
      curl \
      libasound2 \
      libdbus-glib-1-2 \
      libgtk2.0-0 \
      libxrender1 \
      libxt6 \
      xz-utils && \
    rm -rf /var/lib/apt/lists/*

ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user && \
    chown -R user:user $HOME

WORKDIR /usr/local/bin
# TODO(hkjn): Actually check ${CHECKSUMS_FILE}.asc against release binary.
RUN gpg --keyserver pgp.mit.edu --recv-keys $RELEASE_KEY
RUN curl --fail -O -sSL ${RELEASE_URL} && \
    curl --fail -O -sSL ${RELEASE_URL}.asc && \
    curl --fail -O -sSL ${CHECKSUMS_URL} && \
    curl --fail -O -sSL ${CHECKSUMS_URL}.asc && \
    gpg --verify ${RELEASE_FILE}.asc && \
    gpg --verify ${CHECKSUMS_FILE}.asc && \
    tar --strip-components=1 -vxJf ${RELEASE_FILE} && \
    rm -v ${RELEASE_FILE}*

WORKDIR /usr/local/bin/Browser/Downloads
USER user

COPY [ "start.sh", "/usr/local/bin/" ]

CMD [ "start.sh" ]