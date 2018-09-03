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

RUN git clone https://github.com/M4R14/py-ssh.git && \
  pip install -r ./py-ssh/requirements.txt && \
  cp ./py-ssh/py-ssh /usr/bin/

WORKDIR /py-ssh
COPY ./py-ssh.json /py-ssh/py-ssh.json

CMD \
  git pull && \
  pip install -r requirements.txt && \
  cp py-ssh /usr/bin