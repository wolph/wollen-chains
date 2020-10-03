#!/usr/bin/env zsh

# Fetch base IP before initializing OpenVPN
. ./get_ip.sh

echo '############# ENV ################'
env
echo '############# ENV ################'

# Generate random passwords if not given through environment
if [ "$SOCKS_PASS" = 'GENERATE_RANDOM' ]; then
  SOCKS_PASS=$(pwgen -s 32 1)
fi

if [ -n "$SOCKS_PASS" ]; then
  echo "$SOCKS_USER password: $SOCKS_PASS"
  echo "proxy url: socks5h://$SOCKS_USER:$SOCKS_PASS@127.0.0.1:1080"

  adduser "$SOCKS_USER"
  echo "$SOCKS_USER:$SOCKS_PASS" | chpasswd

  envsubst < /etc/sockd.conf.template > /etc/sockd.conf
else
  echo "proxy url: socks5h://127.0.0.1:1080"

  envsubst < /etc/sockd_no_auth.conf.template > /etc/sockd.conf
fi

#for i in SOCKS_USER SOCKS_PASS UPSTREAM_HOST UPSTREAM_PORT; do
#  echo "Replacing $i with $$i"
#  sed -ie "s/\$$i/$i/g" /etc/sockd.conf
#done

cat /etc/sockd.conf

SOCKD_ARGS=${SOCKD_ARGS:-}
if [ "$SHELL" ]; then
  SOCKD_ARGS="${SOCKD_ARGS} -D"
fi

timeout $TIMEOUT sockd $SOCKD_ARGS

if [ "$SHELL" ]; then
  exec zsh
fi
