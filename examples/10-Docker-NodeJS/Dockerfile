# @see https://github.com/mhart/alpine-node
FROM mhart/alpine-node:latest

MAINTAINER bash.origin.workspace <bash.origin.workspace@bashorigin.org>

# @see https://github.com/AlDemion/torrentmonitor-alpine/blob/master/Dockerfile
RUN apk update \
    && apk upgrade \
    && apk --no-cache add bash curl git unzip tar grep perl sed \
    && apk del --purge deps; rm -rf /tmp/* /var/cache/apk/*

#RUN curl -s -o ".bash.origin" "https://raw.githubusercontent.com/bash-origin/bash.origin/master/bash.origin?t=$(date +%s)" \
#    && chmod u+x ./.bash.origin \
#    && BO_VERBOSE=1 ./.bash.origin BO install

ARG VERBOSE=
ENV VERBOSE ${VERBOSE}

ARG BO_VERBOSE=
ENV BO_VERBOSE ${BO_VERBOSE}

ENV BO_VERSION_NVM_NODE=7

COPY .bash.origin .bash.origin
RUN ./.bash.origin BO install

RUN printenv

COPY stack.sh stack.sh
RUN ["bash", "stack.sh"]

ENV PORT=80
EXPOSE 80

CMD ["bash", "shell.sh"]
