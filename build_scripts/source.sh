#!/usr/bin/bash

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
	echo >&2 "This file can only be sourced"
	exit 1
fi

# Trap hook that displays an error and skip a step successfully.
# Meant to be used within steps.
skip_on_err() {
	local msg="$1"
	echo "::warning::$msg. Skipping..."
	exit 0
}

export -f skip_on_err

