#!/bin/sh
set -e

if ! getent passwd "$(id -u)" > /dev/null 2>&1; then
  echo "builder:x:$(id -u):$(id -g):Artifact Builder:/tmp:/bin/sh" >> /etc/passwd
fi

exec "$@"
