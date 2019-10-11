FROM alpine

# Update repositories to the edge branch
RUN sed -i 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories \
  && apk update \
  && apk upgrade --update-cache --available

RUN apk add --no-cache man man-pages curl fzf the_silver_searcher util-linux

COPY . /root/viro
ENV VIRO_SRC /root/viro/src
ENV VISUAL vi
RUN . /root/viro/src/core.sh && YORN=y viro install
ENTRYPOINT /bin/sh -l
