FROM mhart/alpine-node:9.2

RUN apk update && \
    apk add bash curl git perl util-linux bash coreutils && \
    rm -rf /var/cache/apk/*

ENV SHELL=/bin/bash
ENV NODE_PATH=/usr/lib/node_modules

# Declare Node Version
ENV BO_VERSION_NODE="9"

COPY install.sh install.sh

RUN ["/bin/bash", "install.sh"]

COPY test.sh test.sh
COPY script.sh script.sh

CMD ["/bin/bash", "test.sh"]
