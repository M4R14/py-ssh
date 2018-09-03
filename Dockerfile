FROM python:3-alpine3.8

# base tool
RUN apk update \
  && apk add --no-cache curl\
  ca-certificates \
  ffmpeg \
  opus \
  openssh

RUN apk add --no-cache --virtual .build-deps \
  gcc \
  git \
  openssl-dev \
  libffi-dev \
  libsodium-dev \
  make \
  musl-dev 

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD "sh"