FROM debian

ENV TOR_VERSION=11.5a1
# Via https://dist.torproject.org/torbrowser/$TOR_VERSION/sha256sums-signed-build.txt
ENV SHA256_CHECKSUM=63e9f5df83edfa1b20707a63c848486d370121a670e566c2cecb5dc0d281f14b
ENV LANG=C.UTF-8
ENV RELEASE_FILE=tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz
ENV RELEASE_KEY=0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290
ENV RELEASE_URL=https://dist.torproject.org/torbrowser/${TOR_VERSION}/${RELEASE_FILE}
ENV PATH=$PATH:/usr/local/bin/Browser

RUN apt-get update && \
    apt-get install -y \
      ca-certificates \
      curl \
      file \
      gpg \
      libx11-xcb1 \
      libasound2 \
      libdbus-glib-1-2 \
      libgtk-3-0 \
      libxrender1 \
      libxt6 \
      xz-utils && \
    rm -rf /var/lib/apt/lists/* && \
    useradd --create-home --home-dir /home/user user && \
    chown -R user:user /home/user

WORKDIR /usr/local/bin
COPY ["0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290.asc", "/tmp/"]
RUN gpg --import /tmp/0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290.asc

RUN echo "Downloading ${RELEASE_URL}.."
RUN curl --fail -O -sSL ${RELEASE_URL} && \
    curl --fail -O -sSL ${RELEASE_URL}.asc && \
    gpg --verify ${RELEASE_FILE}.asc && \
    echo "$SHA256_CHECKSUM $RELEASE_FILE" > sha256sums.txt && \
    sha256sum -c sha256sums.txt && \
    tar --strip-components=1 -vxJf ${RELEASE_FILE} && \
    rm -v ${RELEASE_FILE}* sha256sums.txt && \
    mkdir -p /usr/local/bin/Browser/Downloads && \
    chown -R user:user /usr/local/bin

WORKDIR /usr/local/bin/Browser/Downloads
USER user

COPY ["start", "/usr/local/bin/"]
ENTRYPOINT ["start"]
CMD [""]
