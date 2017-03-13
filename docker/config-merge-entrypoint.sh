#!/bin/sh
set -e

/config-merge.sh

/docker-entrypoint.sh "$@"
