#!/bin/bash
set -euo pipefail

script_dir=$(dirname "$0")

docker build -t simulator:1.0 -f ${script_dir}/Dockerfile ${script_dir}/../../
