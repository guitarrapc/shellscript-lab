#!/bin/bash
set -eu

# declare before trap
_tmp_file=$(mktemp)

# trap caught exit/error and remove tmp file.
function cleanup() {
  foo=foobar
  echo "$foo"
}
trap cleanup ERR

ls /tmp/tttttttttttttttttmmmmmmmmmmmmmmmmpppppppppppppp
