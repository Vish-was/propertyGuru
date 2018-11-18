#!/bin/sh
set -e

# Render /inpharmics/config file
#sed -e "s/password:/password: $DBPASSWORD\n  host: $DBLOCATION/g" config/database.example.yml > config/database.yml

#bundle exec rake assets:precompile >/dev/null 2>&1

exec "$@"
