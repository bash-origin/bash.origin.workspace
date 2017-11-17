# @see https://github.com/tutumcloud/lamp
FROM tutum/lamp:latest

MAINTAINER bash.origin.workspace <bash.origin.workspace@bashorigin.org>

# @see https://hub.docker.com/r/leoliew/docker-ubuntu/~/dockerfile/

RUN apt-get update
#RUN apt-get upgrade -y
RUN apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        unzip \
        openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN rm /bin/sh && ln -s /bin/bash /bin/sh


# @see https://github.com/tutumcloud/tutum-ubuntu/blob/master/trusty/Dockerfile
# TODO: Lock down more: http://www.ibm.com/developerworks/aix/library/au-sshlocks/
RUN mkdir -p /var/run/sshd && \
    sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation yes/g" /etc/ssh/sshd_config && \
    sed -i "s/StrcitModes.*/StrcitModes yes/g" /etc/ssh/sshd_config && \
    sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config


ARG AUTHORIZED_KEYS=**None**
ENV AUTHORIZED_KEYS ${AUTHORIZED_KEYS}


# @see https://ubuntuforums.org/showthread.php?t=1346581
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8



# Define nodejs env
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 7

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH



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

EXPOSE 80 22

CMD ["bash", "shell.sh"]
