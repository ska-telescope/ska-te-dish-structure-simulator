#!/bin/bash
set -euo pipefail

script_dir=$(dirname "$0")
source ${script_dir}/version.txt
docker build -t simulator:${version} -f ${script_dir}/Dockerfile ${script_dir}/../../
