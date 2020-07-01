#!/usr/bin/env bash
set -x

rails_env=$1
curl https://cronitor.link/KuHCa7/run?msg="Weekly export started on: MN-${rails_env}" -m 10 || true

cd /app || exit
today=$(date +'%Y-%m-%d')
launch_day='2020-06-03'
bundle exec thor clean:addresses \
  && bundle exec thor export:children -a "${launch_day}" -b "${today}" tmp/"${today}".csv \
  && bundle exec thor export:upload_export_to_aws tmp/"${today}".csv
status_code=$?

request_type='complete'
if [ "${status_code}" != '0' ]; then
  request_type='fail'
fi

curl https://cronitor.link/KuHCa7/${request_type}?msg="Weekly export completed on: MN-${rails_env}, Status: ${status_code}" -m 10 || true
