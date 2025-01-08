FROM alpine:3.21.1
LABEL maintainer="Richard Beumer"
LABEL version="0.1.0"

EXPOSE 8080

ARG PVPN_CLI_VER=2.2.12
ENV PVPN_USERNAME= \
    PVPN_USERNAME_FILE= \
    PVPN_PASSWORD= \
    PVPN_PASSWORD_FILE= \
    PVPN_TIER=2 \
    PVPN_PROTOCOL=tcp \
    HOST_NETWORK= \
    DNS_SERVERS_OVERRIDE="8.8.8.8"

COPY app /app

RUN apk --update add bash openvpn privoxy runit \
    && wget "https://raw.githubusercontent.com/ProtonVPN/scripts/master/update-resolv-conf.sh" -O "/etc/openvpn/update-resolv-conf" \
    && chmod +x "/etc/openvpn/update-resolv-conf"

CMD ["runsvdir", "/app"]
