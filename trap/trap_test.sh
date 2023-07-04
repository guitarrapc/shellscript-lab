#!/bin/bash
set -eu

# declare before trap
_tmp_file=$(mktemp)

# trap caught exit/error and remove tmp file.
cleanup() {
  if [[ -f "${_tmp_file}" ]]; then
    rm "${_tmp_file}"
  fi
}
trap cleanup EXIT

# do any....
echo "$_tmp_file" > $_tmp_file
ls /tmp/tmp*

echo "${foo}" # unbound variable
