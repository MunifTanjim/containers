# From https://github.com/dnsforge-repo/xteve/tree/master/bin

FROM ghcr.io/elfhosted/alpine:rolling@sha256:672b59dc4580b8aaae42e839c878501109ed7a810072c872363250930899bf16 

RUN apk update
RUN apk upgrade
RUN apk add --no-cache ca-certificates


ARG BUILD_DATE
ARG VCS_REF
ARG XTEVE_VERSION

LABEL org.label-schema.build-date="{$BUILD_DATE}" \
      org.label-schema.name="xTeVe Docker Edition" \
      org.label-schema.description="Latest Dockerized xTeVe v2.1.x IPTV proxy with Guide2go, zap2XML, Crond & Perl Support." \
      org.label-schema.url="https://xteve.dnsforge.net/" \
      org.label-schema.vcs-ref="{$VCS_REF}" \
      org.label-schema.vcs-url="https://github.com/dnsforge-repo/xteve" \
      org.label-schema.vendor="Dnsforge Internet Inc" \
      org.label-schema.version="{$XTEVE_VERSION}" \
      org.label-schema.schema-version="1.0" \
      MAINTAINER="hostmaster@dnsforge.com" \
      DISCORD_URL="https://discord.gg/Up4ZsV6"

ENV XTEVE_USER=xteve
ENV XTEVE_UID=31337
ENV XTEVE_GID=31337
ENV XTEVE_HOME=/home/xteve
ENV XTEVE_TEMP=/tmp/xteve
ENV XTEVE_BIN=/home/xteve/bin
ENV XTEVE_CACHE=/home/xteve/cache
ENV XTEVE_CONF=/home/xteve/conf
ENV XTEVE_PORT=34400
ENV XTEVE_LOG=/var/log/xteve.log
ENV XTEVE_BRANCH=master
ENV XTEVE_DEBUG=0
ENV XTEVE_API=1
ENV XTEVE_URL=https://github.com/xteve-project/xTeVe-Downloads/blob/master/xteve_linux_amd64.tar.gz?raw=true
ENV XTEVE_VERSION=1.0.9
ENV GUIDE2GO_HOME=/home/xteve/guide2go
ENV GUIDE2GO_CONF=/home/xteve/guide2go/conf

ENV PERL_MM_USE_DEFAULT=1
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$XTEVE_BIN

# Set working directory
WORKDIR $XTEVE_HOME

# Add Bash shell & dependancies
RUN apk add --no-cache bash busybox-suid curl su-exec

# Timezone (TZ):  Add the tzdata package and configure for EST timezone.
# This will override the default container time in UTC.
RUN apk update && apk add --no-cache tzdata
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add VideoLAN & ffmpeg support
RUN apk add --no-cache vlc ffmpeg

# Install Perl Dependancies
RUN apk add --no-cache \
    perl-dev \
    build-base \
    perl-html-parser \
    perl-http-cookies \
    perl-json \
    perl-lwp-protocol-https \
    perl-lwp-useragent-determined \
    perl-digest-sha1


# Pull the required binaries for xTeVe, Guide2go and Zap2XML from the repos.
ADD ./apps/xteve/xteve_starter.pl $XTEVE_BIN/xteve_starter.pl
RUN wget $XTEVE_URL -O xteve_linux_amd64.tar.gz \
&& tar zxfvp xteve_linux_amd64.tar.gz -C $XTEVE_BIN && rm -f $XTEVE_HOME/xteve_linux_amd64.tar.gz
ADD ./apps/xteve/guide2go $XTEVE_BIN/guide2go
ADD ./apps/xteve/guide2conf $XTEVE_BIN/guide2conf
ADD ./apps/xteve/zap2xml.pl $XTEVE_BIN/zap2xml.pl

# Create XML cache directory
RUN mkdir $XTEVE_HOME/cache && mkdir $XTEVE_HOME/cache/guide2go

# Set binary executable permissions.
RUN chmod +x $XTEVE_BIN/xteve_starter.pl && \
    chmod +rx $XTEVE_BIN/xteve && \
    chmod +rx $XTEVE_BIN/guide2go && \
    chmod +rx $XTEVE_BIN/guide2conf && \
    chmod +rx $XTEVE_BIN/zap2xml.pl

# Configure container volume mappings
VOLUME $XTEVE_CONF
VOLUME $XTEVE_TEMP
VOLUME $GUIDE2GO_CONF

# Set default container port 
EXPOSE $XTEVE_PORT

# Run the xTeVe init script
ENTRYPOINT $XTEVE_BIN/xteve_starter.pl

USER 568

EXPOSE 34400

COPY ./apps/xteve/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]