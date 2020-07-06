#!/usr/bin/env bash
set -x

rails_env=$1
curl https://cronitor.link/KuHCa7/run?msg="Daily clean started on: MN-${rails_env}" -m 10 || true

cd /app || exit
result=$(bundle exec thor clean:addresses)
status_code=$?
addresses=$(echo "${result}" | tail -n1)

request_type='complete'
if [ "${status_code}" != '0' ]; then
  request_type='fail'
fi

curl https://cronitor.link/KuHCa7/${request_type}?msg="Daily clean completed on: MN-${rails_env}, Status: ${status_code}, Result: ${addresses}" -m 10 || true
