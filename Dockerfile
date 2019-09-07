FROM silex/emacs:master-alpine AS emacs

### handle gotty
# based on https://github.com/dit4c/dockerfile-gotty
# Unfortunately, it's got fixed alpine version and missing dependency so easies was just to copy it
RUN apk add --update go git build-base && \
  mkdir -p /tmp/gotty && \
  GOPATH=/tmp/gotty go get github.com/yudai/gotty && \
  mv /tmp/gotty/bin/gotty /usr/local/bin/ && \
  apk del go git build-base && \
  rm -rf /tmp/gotty /var/cache/apk/*

EXPOSE 8080
### 

# TODO FIXME not sure if xclip is necessary
# TODO I guess it should be a separate script so it's not bundled?
RUN apk add --no-cache git xclip 


# TODO FIXME need to run single daemon I guess?
ENTRYPOINT ["gotty"]
CMD ["--permit-write", "--reconnect", "emacs"]