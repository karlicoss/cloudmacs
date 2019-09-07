FROM silex/emacs:master-alpine AS emacs


# based on https://github.com/dit4c/dockerfile-gotty
RUN apk add --update go git build-base && \
  mkdir -p /tmp/gotty && \
  GOPATH=/tmp/gotty go get github.com/yudai/gotty && \
  mv /tmp/gotty/bin/gotty /usr/local/bin/ && \
  apk del go git build-base && \
  rm -rf /tmp/gotty /var/cache/apk/*

EXPOSE 8080

# TODO FIXME not sure if xclip is necessary
RUN apk add --no-cache git xclip 


# TODO FIXME need to run single daemon I guess?
ENTRYPOINT ["gotty"]
CMD ["--permit-write", "--reconnect", "emacs"]