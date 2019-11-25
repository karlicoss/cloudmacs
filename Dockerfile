FROM silex/emacs:master-alpine AS emacs
# TODO 218 Mb. hmm wonder if building without GUI would help?

### configure locales for proper unicode display
# Borrowed from https://gist.github.com/Herz3h/0ffc2198cb63949a20ef61c1d2086cc0
# TODO add other locales..
ENV MUSL_LOCPATH=/usr/local/share/i18n/locales/musl

RUN apk --no-cache add git cmake make musl-dev gcc gettext-dev libintl \
 && git clone https://github.com/rilian-la-te/musl-locales.git /tmp/musl-locales \
 && cd /tmp/musl-locales \
 && cmake . && make && make install \
 && rm -rf /tmp/musl-locales \
 && apk del git cmake make musl-dev gcc gettext-dev libintl
 ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
### 


### configure gotty
# TODO extract in a separate image?
# based on https://github.com/dit4c/dockerfile-gotty
# Unfortunately, it's got fixed alpine version and missing dependency so easiest was just to copy it
RUN apk add --no-cache go git build-base && \
  mkdir -p /tmp/gotty && \
  GOPATH=/tmp/gotty go get github.com/yudai/gotty && \
  mv /tmp/gotty/bin/gotty /usr/local/bin/ && \
  apk del go git build-base && \
  rm -rf /tmp/gotty
# binary takes about 14 Mb
### 


### configure asEnvUser, tool to run emacs in docker with user's permissions rather than root
# borrowed from https://github.com/JAremko/docker-emacs/blob/master/Dockerfile.alpine
COPY asEnvUser /usr/local/sbin/

# only allow root to run it
RUN chown root /usr/local/sbin/asEnvUser \
 && chmod 700  /usr/local/sbin/asEnvUser

# su-exec
RUN apk --no-cache add git build-base bash \
    && git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
    && cd /tmp/su-exec \
    && make \
    && chmod 770 su-exec \
    && mv ./su-exec /usr/local/sbin/ \
    && apk del git build-base

### 


ENV WORKSPACE="/mnt/workspace" \
    SHELL="/bin/bash"

# gotty default
EXPOSE 8080

WORKDIR "${WORKSPACE}"

ENTRYPOINT ["asEnvUser"]
# -a options connects to existing emacs session or starts a new one if there is no Emacs running
# see https://www.gnu.org/software/emacs/manual/html_node/emacs/emacsclient-Options.html
CMD ["gotty", "--permit-write", "--reconnect", "emacsclient", "--tty", "-a", ""]
