#!/usr/bin/env bash
set -xe

rails_env=$1
curl https://cronitor.link/KuHCa7/run?msg="Daily clean started on: ${rails_env}" -m 10 || true

cd /app || exit
result=$(bundle exec thor clean:addresses)
status_code=$?
addresses=$(echo "${result}" | tail -n1 | cut -c26-27)

curl https://cronitor.link/KuHCa7/complete?msg="Daily clean completed on: ${rails_env}, Status: ${status_code}, Addresses Cleaned: ${addresses}" -m 10 || true
