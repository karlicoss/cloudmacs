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


# TODO check if git is necessary for emacs init..
# TODO FIXME not sure if xclip is necessary
# TODO I guess it should be a separate script so it's not bundled?
RUN apk add --no-cache git bash


# TODO su-exec??

RUN apk --no-cache add build-base

COPY asEnvUser /usr/local/sbin/

# su-exec
RUN git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
    && cd /tmp/su-exec \
    && make \
    && chmod 770 su-exec \
    && mv ./su-exec /usr/local/sbin/



RUN chown root /usr/local/sbin/asEnvUser \
 && chmod 700  /usr/local/sbin/asEnvUser


# TODO https://gist.github.com/Herz3h/0ffc2198cb63949a20ef61c1d2086cc0
# TODO FIXME add other locales..
ENV MUSL_LOCPATH=/usr/local/share/i18n/locales/musl
RUN apk add --update git cmake make musl-dev gcc gettext-dev libintl
RUN cd /tmp && git clone https://github.com/rilian-la-te/musl-locales.git
RUN cd /tmp/musl-locales && cmake . && make && make install


# TODO remove this step
RUN locale -a
# TODO locale-gen??


ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'


### TODO comment why is that necessary
# TODO eh, what does uid here mean? try changing it to 1001?..
ENV UNAME="emacser" \
    GNAME="emacs" \
    UHOME="/home/emacs" \
    UID="1000" \
    GID="1000" \
    WORKSPACE="/mnt/workspace" \
    SHELL="/bin/bash"




WORKDIR "${WORKSPACE}"

# TODO FIXME collapse commands
# TODO FIXME need to run single daemon I guess?
ENTRYPOINT ["asEnvUser"]
CMD ["gotty", "--permit-write", "--reconnect", "emacs"]