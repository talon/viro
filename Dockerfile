FROM alpine

# Update repositories to the edge branch and add testing
RUN sed -i 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories \
  && echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
  && apk update \
  && apk upgrade --update-cache --available

RUN apk add --no-cache curl fzf the_silver_searcher util-linux bat

COPY . /root/viro
ENV VIRO_SRC /root/viro/src
ENV VISUAL vi
RUN . /root/viro/src/core.sh && YORN=y viro install
ENTRYPOINT /bin/sh -l
