FROM ubuntu:16.04
# FROM node:alpine
MAINTAINER Alexander Bleissem <alexander@bleissem.com>

# RUN apk --update add openssl ca-certificates


ENV DEBIAN_FRONTEND noninteractive

RUN apt-get clean && apt-get update
RUN apt-get install -qy apt-utils
RUN apt-get clean && apt-get update
RUN apt-get -qy dist-upgrade

RUN apt-get -qy install locales
RUN locale-gen --no-purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8


# Base build dependencies.
RUN apt-get install -qy \
	openssl \
    npm \
	nodejs 

# ENV PATH="/usr/local/bin/:${PATH}"
RUN ln -fs /usr/bin/nodejs /usr/local/bin/node

RUN npm install -g node-gyp@3.6.2
RUN npm install -g getconfig@2.1.0
RUN npm install -g node-uuid@1.2.0
RUN npm install -g utf-8-validate@1.2.2
RUN npm install -g bufferutil@1.2.1
RUN npm install -g socket.io@1.3.7
RUN npm install -g yetify@0.0.1


RUN npm install

COPY . /

RUN ["/bin/sh", "./scripts/generate-ssl-certs.sh"]

EXPOSE 443, 80, 8888

ENTRYPOINT ["/usr/local/bin/node", "./server.js"]
