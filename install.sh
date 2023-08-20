#!/usr/bin/env bash

set_suffix() {
	echo "$(date +%s).bak"
}

backup_file() {
	local file="$1"
	local suffix="${2:-$(date +%s).bak}"
	local backup="${file}-${suffix}"
	if [[ -h "$file" ]] ; then
		echo "${file} is a symlink to $(readlink $file)"
		mv -v "$file" "$backup"
	elif [[ -f "$file" ]] ; then
		echo "${file} is a file; back it up -> ${file}-${suffix}"
		mv -v "$file" "$backup"
	elif [[ -d "$file" ]] ; then
		echo "${file} is a directory; back it up -> ${file}-${suffix}"
		mv -v "$file" "$backup"
	else
		echo "${file} does not exist yet"
	fi
}

main() {
	local suffix=$(set_suffix)
	local source_file
	local target

	for file in dotfiles/* ; do
		source_file="$(pwd -P)/${file}"
		target="$HOME/.$(basename $file)"
		echo "$file -> $target"
		if [[ -a "$target" ]] ; then
			# Target exists.
			backup_file "$target" "$suffix"
		fi
		ln -s "$source_file" "$target"
	done
}

main
