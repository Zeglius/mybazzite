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

# Mount a bindfs in stateful dirs into /usr/share/factory.
# This is useful to allow writting in /var/opt or /var/home.
bind_state() {
	local -r NULL=/dev/null
	local -r FACTORY=/usr/share/factory
	declare -r _stateful_dirs=(
		/var/opt
		/var/home
	)

	echo >&2 "Checking if bindfs is available"
	if ! type -P bindfs >$NULL; then
		echo >&2 "bindfs is not available. Installing..."
		dnf5 install -yq bindfs && dnf5 mark dependency bindfs
	else
		echo >&2 "bindfs found at $(type -P bindfs)"
	fi

	local dir
	for dir in "${_stateful_dirs[@]}"; do
		[[ -L $dir ]] && {
			echo >&2 "::error::'$dir' must not be a symlink. Aborting..."
			exit 1
		}
		[[ ! -e $dir ]] && mkdir -p "$dir"
		[[ ! -e "$FACTORY/${dir##/}" ]] && mkdir -p "$FACTORY/${dir##/}"

		bindfs -o allow_other "$FACTORY/${dir##/}" "$dir"
	done

	# shellcheck disable=SC2317
	unbind_state() {
		unset -f unbind_state
		local dir
		for dir in "${_stateful_dirs[@]}"; do
			umount --recursive "$dir"
		done
		unset -v _stateful_dirs
	}
}

export -f bind_state
