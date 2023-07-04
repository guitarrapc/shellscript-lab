#!/bin/bash
set -eu

# declare before trap
_tmp_file=$(mktemp)

# trap caught exit/error and remove tmp file.
function cleanup() {
  if [[ -f "${_tmp_file}" ]]; then
    rm "${_tmp_file}"
  fi
}

function run() {
  trap cleanup RETURN

  # do any....
  echo "$_tmp_file" > $_tmp_file
  ls /tmp/tmp*
}

run
echo "${foo}" # unbound variable
