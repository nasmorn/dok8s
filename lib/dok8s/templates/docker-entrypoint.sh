#! /bin/bash
set -e

# Create the standard pid directory if missing
mkdir -p tmp/pids/

if [ -z "$1" ]; then
  set -- bundle exec puma -C config/puma.rb "$@"
fi

exec "$@"
