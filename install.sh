#!/usr/bin/env bash

set -e

declare dry_run


run() {
	local command=("$@")
	if [[ $dry_run == true ]] ; then
		echo "[DRYRUN] ${command[@]}"
	else
		"${command[@]}"
	fi
}


backup_file() {
	local file="$1"
	local suffix="${2:-$(date +%s).bak}"
	local backup="${file}-${suffix}"
	if [[ -h "$file" ]] ; then
		echo "${file} is a symlink to $(readlink $file)"
		# mv -v "$file" "$backup"
		run mv -iv "$file" "$backup"
	elif [[ -f "$file" ]] ; then
		echo "${file} is a file; back it up -> ${file}-${suffix}"
		# mv -v "$file" "$backup"
		run mv -iv "$file" "$backup"
	elif [[ -d "$file" ]] ; then
		echo "${file} is a directory; back it up -> ${file}-${suffix}"
		# mv -v "$file" "$backup"
		run mv -iv "$file" "$backup"
	fi
}


link_file() {
	run ln -s "$source_file" "$target"
}


main() {
	while getopts 'n' opt; do
		case "$opt" in
			n) dry_run=true ;;
			*) echo 'error in command line parsing' >&2
			   exit 1
		esac
	done

	local file
	local source_file
	local target

	# Set the suffix here so all files will have the same suffix.
	local suffix="$(date +%s).bak"

	for file in dotfiles/* ; do
		source_file="$(pwd -P)/${file}"
		target="$HOME/.$(basename $file)"
		echo "$file -> $target"
		backup_file "$target" "$suffix"
		link_file "$file" "$target"
	done
}


main "$@"


exit 0
