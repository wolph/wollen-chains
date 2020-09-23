# wollen-chains
Simple Socks proxy server that chains to other proxy servers such as Wollen-Socks: https://github.com/WoLpH/wollen-socks

Docker Hub link: https://hub.docker.com/repository/docker/wolph/wollen-chains

## Basic usage:

```
docker run \
  -p 1080:1080
  --env UPSTREAM_HOST=... \
  --env UPSTREAM_PORT=... \
  --env SOCKS_USER=... \
  --env SOCKS_PASS=... \
  wolph/wollen-socks
```

After that you can access the server through any client that supports socks:

    curl -vvv -x 'socks5h://127.0.0.1:1080' ifconfig.me 

- The `UPSTREAM_PORT` is optional and defaults to `1080`.
- The `SOCKS_USER` is `sockd` by default.
- The `SOCKS_PASS` is generated automatically by default and is shown in the logs.
