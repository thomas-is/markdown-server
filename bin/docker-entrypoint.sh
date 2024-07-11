#!/bin/sh

if [ "$(whoami)" = "root" ]; then
  echo "🚀 nginx"
  /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;" &
else
  echo "⚠️  nginx not started"
fi

echo "🚀 $*"
exec $@
