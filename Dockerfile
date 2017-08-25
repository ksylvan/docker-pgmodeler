FROM debian:stretch-slim

LABEL maintainer "Kayvan Sylvan <kayvansylvan@gmail.com>"

RUN apt-get update \
  && apt-get -y install pgmodeler \
  && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/pgmodeler"]
