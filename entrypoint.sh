#!/bin/bash

set -e

# set a default for backwards compatibility
DOMAIN_NAME="${DOMAIN_NAME:-demo.mac}"

# if the sql file exists; let's do our customizations
if [ -f "/data/gogs/data/gogs.sql" ]
then
  # make sure DOMAIN_NAME is set
  if [ -z "${DOMAIN_NAME}" ]
  then
    echo "Missing DOMAIN_NAME"
    exit 1
  fi

  # update the sqlite dump with the proper domain name
  echo -n "Replacing 'DOMAIN_NAME' with '${DOMAIN_NAME}'..."
  sed -i "s/DOMAIN_NAME/${DOMAIN_NAME}/g" /data/gogs/data/gogs.sql

  # import to file
  sqlite3 /data/gogs/data/gogs.db < /data/gogs/data/gogs.sql

  # update the gogs config ini file
  sed -i "s/DOMAIN_NAME/${DOMAIN_NAME}/g" /data/gogs/conf/app.ini

  # remove the .sql file so this doesn't run again
  rm /data/gogs/data/gogs.sql
  echo "done"
else
  echo "Skipping DOMAIN_NAME replacement; already complete"
fi

# execute old entrypoint
exec /app/gogs/docker/start.sh
