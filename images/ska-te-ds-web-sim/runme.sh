#!/bin/bash
set -euo pipefail
source ${script_dir}/version.txt
docker run --rm -it -p 8090:8090 -p 4840:4840 -p 5005:5005 --name simulator simulator:${version}
