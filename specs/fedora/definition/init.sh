#!/bin/bash

[ ! -z "$USER" ] || export USER=$(getent passwd $UID | cut -d: -f1)
[ ! -z "$HOME" ] || export HOME=$(getent passwd $UID | cut -d: -f6)
[ ! -z "$XDG_RUNTIME_DIR" ] || export XDG_RUNTIME_DIR=/run/user/$UID

$@
