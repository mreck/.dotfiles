#!/bin/sh

set -xe

mkdir -p "$BACKUP_DST"

IFS=:
for src in $BACKUP_SRCS; do
	rsync -av --delete "$src" "$BACKUP_DST"
done

