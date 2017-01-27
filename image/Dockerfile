# @see https://github.com/mhart/alpine-node
FROM mhart/alpine-node:7

MAINTAINER bash.origin.workspace <bash.origin.workspace@bashorigin.org>

# @see https://github.com/AlDemion/torrentmonitor-alpine/blob/master/Dockerfile
RUN apk update \
    && apk upgrade \
    && apk --no-cache add bash curl git unzip tar grep perl sed \
    && apk del --purge deps; rm -rf /tmp/* /var/cache/apk/*

#RUN curl -s -o ".bash.origin" "https://raw.githubusercontent.com/bash-origin/bash.origin/master/bash.origin?t=$(date +%s)" \
#    && chmod u+x ./.bash.origin \
#    && BO_VERBOSE=1 ./.bash.origin BO install

COPY . .

ARG VERBOSE=
ENV VERBOSE ${VERBOSE}

ARG BO_VERBOSE=
ENV BO_VERBOSE ${BO_VERBOSE}

ENV BO_VERSION_NVM_NODE=7

RUN ./bash.origin BO install

RUN printenv

RUN ["bash", "stack.sh"]

CMD ["bash", "shell.sh"]
