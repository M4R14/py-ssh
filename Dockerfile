FROM alpine:3.5

# base tool
RUN apk update \
  && apk add --no-cache curl\
  ca-certificates \
  ffmpeg \
  opus \
  python3 \
  openssh

# Install build dependencies
RUN apk add --no-cache --virtual .build-deps \
  gcc \
  git \
  openssl-dev \
  libffi-dev \
  libsodium-dev \
  make \
  musl-dev \
  python3-dev

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && python3 get-pip.py

# python lib
RUN pip install \
  paramiko \
  fire

WORKDIR /home/
