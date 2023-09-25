#!/bin/bash
set -e

# New lined string. You can pass "foo bar baz" and get same result.
foo="foo
bar
baz"

# spaced delimited string to array. "foo bar baz" -> (foo bar baz)
IFS=" " read -r -a myarray <<< "${foo//$'\n'/ }"
for item in "${myarray[@]}"; do
  echo "hello, $item";
done
# hello, foo
# hello, bar
# hello, baz
