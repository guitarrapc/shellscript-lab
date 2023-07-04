# man

```
$ tldr trap

trap

Automatically execute commands after receiving signals by processes or the operating system.
Can be used to perform cleanups for interruptions by the user or other actions.
More information: <https://manned.org/trap>.

(Use arrows to move, type to search or ctrl+c to return. ? for more)

- List available signals to set traps for
  trap -l

  List active traps for the current shell
  trap -p

  Set a trap to execute commands when one or more signals are detected
  trap 'echo "Caught signal SIGHUP"' SIGHUP

  Remove active traps
  trap - SIGHUP SIGINT
```

# TIPS

## unbound variable can't caught by trap

Workaround, use `EXIT` instead of `ERR` to caught unbound variable.

```sh
#!/bin/bash
set -eu

# declare before trap
_tmp_file=$(mktemp)

# trap caught exit/error and remove tmp file.
function cleanup() {
  foo=foobar
  echo "$foo"
}
trap cleanup ERR # bad. use EXIT instead of ERR

echo "${foo}" # unbound variable won't catch error. see https://unix.stackexchange.com/questions/208112/correct-behavior-of-exit-and-err-traps-when-using-set-eu
```

## expression or function call

function call is better to handle multiple line of execution. Below examples are equivalent and will output the tmp file like `file: /tmp/tmp.IQga703pbI`.

**expression**

```sh
#!/bin/bash
set -eu
_temp_file=$(mktemp)
trap 'echo "file: $_temp_file"' EXIT
```

**function call**

```sh
#!/bin/bash
set -eu
_temp_file=$(mktemp)
function cleanup() {
  echo "file: $_temp_file"
}
trap cleanup EXIT
```
