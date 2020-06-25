#!/usr/bin/env bash
set -xe

rails_env=$1
curl https://cronitor.link/yITppB/run?msg="Run started on: ${rails_env}" -m 10 || true

cd /app || exit
today=$(date +'%Y-%m-%d')
bundle exec thor export:last_x_days 1 tmp/"${today}".csv
bundle exec thor export:upload_export_to_aws tmp/"${today}".csv

curl https://cronitor.link/yITppB/complete?msg="Run completed on: ${rails_env}" -m 10 || true
