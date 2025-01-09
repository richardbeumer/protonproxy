# ProtonVPN Privoxy Docker

Docker container for setting up a [Privoxy](https://www.privoxy.org/) proxy that pushes traffic over a
[ProtonVPN](https://protonvpn.com/) connection.

Build Docker image:
```
docker build -t proton-privoxy .
```

Run Docker container:

```
docker run -d \
     --network=host \
     --device=/dev/net/tun --cap-add=NET_ADMIN \
     -v /etc/localtime:/etc/localtime:ro \
     -p 8888:8080 \
     -e PVPN_USERNAME=my_protonvpn_openvpn_username \
     -e PVPN_PASSWORD=my_protonvpn_openvpn_password \
     --name proton-privoxy moolehsacat/proton-privoxy
```

Or with this `docker-compose.yml`:

```yaml
---
version: "3"
services:
  proton-privoxy:
    image: moolehsacat/proton-privoxy
    container_name: proton-privoxy
    environment:
      - PVPN_USERNAME=xxxxxxxxxxxxxxxxxxxxxxxx
      - PVPN_PASSWORD=xxxxxxxxxxxxxxxxxxxxxxxx
    volumes:
      - /etc/localtime:/etc/localtime:ro
    ports:
      - 8888:8080
    restart: unless-stopped
    devices:
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
```

This will start a Docker container that

1. sets up an OpenVPN connection to ProtonVPN with your ProtonVPN account details, and
2. starts a Privoxy server, accessible at http://127.0.0.1:8888, that directs traffic over your VPN connection.

Test:

```
curl --proxy http://127.0.0.1:8888 https://ipinfo.io/ip
```

## Configuration

You can set any of the following container environment variables with
`docker run`'s `-e` options.

### `PVPN_USERNAME` and `PVPN_PASSWORD`

**Required.** This is your ProtonVPN OpenVPN username and password. It's the
username and password you would normally provide to `protonvpn init`.

If you're using [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/#build-support-for-docker-secrets-into-your-images), you can use `PVPN_USERNAME_FILE` and
`PVPN_PASSWORD_FILE` instead.

### `PVPN_SERVER_IP`
Alternative IP address for a protonVPN server to connect to.

Default: `149.36.51.3` #nl-free-2

### `DNS_SERVERS_OVERRIDE`

Comma-separated list of DNS servers to use, overriding whatever was set by
ProtonVPN. For example, to use Quad9 DNS servers, set
`DNS_SERVERS_OVERRIDE=9.9.9.9,149.112.112.112`.

Default: `8.8.8.8`

