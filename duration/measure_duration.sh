#!/bin/bash
set -eu

echo "begin measure duration."
start=$(date +%s)

# any thing
sleep 2

end=$(date +%s)
duration=$((end-start))
echo "Duration: ${duration}sec"

# begin measure duration.
# Duration: 2sec
