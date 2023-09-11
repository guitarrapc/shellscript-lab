#!/bin/bash
set -eu -o pipefail

## Dynamic Points
# Post time-series data that can be graphed on Datadog’s dashboards.
#
# REF: https://docs.datadoghq.com/api/latest/metrics/#submit-metrics
#
# SAMPLE: ./dd_metrics_api.sh --dd-api-key xxxx --metrics-name foo --metrics-value 1 --metrics-tags "env:bar,app:baz"

while [ $# -gt 0 ]; do
    case $1 in
        --dd-api-key) _DD_API_KEY=$2; shift 2; ;;
        # gauge, rate, count
        --metrics-type) _METRICS_TYPE=$2; shift 2; ;;
        --metrics-name) _METRICS_NAME=$2; shift 2; ;;
        --metrics-value) _METRICS_VALUE=$2; shift 2; ;;
        --metrics-tags) _TAGS=$2; shift 2; ;;
        --dry-run) _DRY_RUN=$2; shift 2; ;;
        *) shift ;;
    esac
done

# make array to single string
# join_by , a b c => a,b,c
function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

# generate `"a,b" -> a","b`
tag_array=("${_TAGS//,/ }")
tags=$(join_by '","' ${tag_array})

# generate metrics points `1694402473 10 -> 1694402473,10`
points=$(join_by ',' $(date +%s) ${_METRICS_VALUE})

# generate request body
body=$(cat <<EOF
{
  "series": [
    {
      "metric": "${_METRICS_NAME}",
      "points": [[${points}]],
      "type": "${_METRICS_TYPE:=gauge}",
      "tags": ["${tags}"]
    }
  ]
}
EOF
)

if [[ "${_DRY_RUN:=""}" == "" ]]; then
  curl -sS -X POST "https://api.datadoghq.com/api/v1/series" \
  -H "Accept: application/json" \
  -H "Content-Type: text/json" \
  -H "DD-API-KEY: ${_DD_API_KEY}" \
  -d "${body}"
else
  echo "curl -sS -X POST \"https://api.datadoghq.com/api/v1/series\" \
  -H \"Accept: application/json\" \
  -H \"Content-Type: text/json\" \
  -H \"DD-API-KEY: ${_DD_API_KEY}\" \
  -d \"${body}\""
fi

echo "Complete sent metrics to Datadog."
