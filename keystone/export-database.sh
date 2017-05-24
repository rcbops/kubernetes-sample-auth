#!/bin/bash

set -ueo pipefail

function usage() {
    echo "usage: export-database.sh <container_name_or_id>"
    exit 1
}

db_container=""

if [[ "${1:-""}" == "" ]]; then
  usage
else
  db_container=${1}
fi

docker exec ${db_container} mysqldump -ppassword --skip-extended-insert --single-transaction --no-data keystone > ./keystone.sql
docker exec ${db_container} mysqldump -ppassword --skip-extended-insert --no-create-info --ignore-table=keystone.token --ignore-table=keystone.revocation_event --ignore-table=keystone.request_token keystone >> ./keystone.sql