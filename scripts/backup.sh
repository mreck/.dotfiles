#!/bin/sh

set -e

cfg_zip=false

for arg in "$@"; do
	case "$arg" in
		"--zip" )
			cfg_zip=true
			;;
		* )
			>&2 echo "ERROR: invalid argument: $arg"
			exit 1
			;;
	esac
done

mkdir -p "$BACKUP_DST"

IFS=:
for src in $BACKUP_SRCS; do
	if [ "$cfg_zip" = true ]; then
		fn="$(echo "$src.tar.gz" | sed -e 's|^/||' -e 's|/|__|g')"
		tar -cvf "$BACKUP_DST/$fn" "$src"
	else
		rsync -av --delete "$src" "$BACKUP_DST"
	fi
done

