FROM alpine

# Update repositories to the edge branch and add the testing repo
RUN sed -i 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories \
  && echo http://dl-cdn.alpine-linux.org/alpine/edge/testing \
  && apk update \
  && apk upgrade --update-cache --available

RUN apk add man man-pages curl fzf the_silver_searcher util-linux
