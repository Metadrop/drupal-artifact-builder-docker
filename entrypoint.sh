#!/bin/sh
set -e

if [ -n "$RUN_AS_UID" ]; then
  if ! getent passwd "$RUN_AS_UID" > /dev/null 2>&1; then
    echo "builder:x:${RUN_AS_UID}:${RUN_AS_GID:-$RUN_AS_UID}:Artifact Builder:/tmp:/bin/sh" >> /etc/passwd
  fi
  exec su-exec "${RUN_AS_UID}:${RUN_AS_GID:-$RUN_AS_UID}" "$@"
fi

exec "$@"
