#!/usr/bin/env bash
set -x

rails_env=$1
curl https://cronitor.link/KuHCa7/run?msg="Weekly export started on: MN-${rails_env}" -m 10 || true

cd /app || exit
today=$(date +'%Y-%m-%d')
bundle exec thor clean:addresses \
  && bundle exec thor export:last_x_days 7 tmp/"${today}".csv \
  && bundle exec thor export:upload_export_to_aws tmp/"${today}".csv
status_code=$?

curl https://cronitor.link/KuHCa7/complete?msg="Weekly export completed on: MN-${rails_env}, Status: ${status_code}" -m 10 || true
