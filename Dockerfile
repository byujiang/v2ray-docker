#
# Builder
#
# update to go1.13
FROM darkshell/caddy:builder as builder

LABEL maintainer "sebs sebsclub@outlook.com"

### caddy version
ARG version="1.0.4"
ARG plugins="git,cors,realip,expires,cache"
ARG TZ="Asia/Shanghai"
LABEL caddy_version="$version"

RUN go get -v github.com/abiosoft/parent
RUN VERSION=${version} PLUGINS=${plugins} ENABLE_TELEMETRY=false /bin/sh /usr/bin/builder.sh

#
# Final stage
#
FROM alpine:latest

# V2RAY
ENV TZ ${TZ}
ENV V2RAY_VER v4.23.0
ENV V2RAY_URL https://github.com/v2ray/v2ray-core/releases/download/${V2RAY_VER}/v2ray-linux-64.zip

WORKDIR /srv
ADD ./srv /srv


### nodejs v2ray git &&& openssh
RUN apk upgrade --update \
    && apk add --no-cache\
        bash \
        tzdata \
        curl \
		openssh-client \
		git\
		util-linux \
		nodejs nodejs-npm \
	&& cd /srv/ && npm install --save \
    && mkdir -p \
        /etc/log/v2ray \
        /etc/v2ray/ \
        /tmp/v2ray \
    && curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip ${V2RAY_URL} \
    && pwd \
    && unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray/ \
    && mv /tmp/v2ray/v2ray /usr/bin \
    && mv /tmp/v2ray/v2ctl /usr/bin \
    && mv /tmp/v2ray/vpoint_vmess_freedom.json /etc/v2ray/config.json \
    && chmod +x /usr/bin/v2ray \
    && chmod +x /usr/bin/v2ctl \
    && apk del curl \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && rm -rf /tmp/v2ray /var/cache/apk/*

# ADD entrypoint.sh /entrypoint.sh

# Let's Encrypt Agreement
ENV ACME_AGREE="false"

# Telemetry Stats
ENV ENABLE_TELEMETRY="false"

# install caddy
COPY --from=builder /install/caddy /usr/bin/caddy

# validate install
RUN /usr/bin/caddy -version && /usr/bin/caddy -plugins

VOLUME /root/.caddy /srv

COPY Caddyfile /etc/Caddyfile

# install process wrapper
COPY --from=builder /go/bin/parent /bin/parent
ADD caddy.sh /caddy.sh

EXPOSE 443 80
ENTRYPOINT ["/caddy.sh"]
# CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=$ACME_AGREE"]
