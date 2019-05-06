#!/bin/bash
#
# This script backs up your "SOURCE" directory incrementally generating
#   "NUM_BACKUPS" backups as "BACKUP.0", ..., "BACKUP.(NUM_BACKUPS - 1)"
#
# The first time the script runs, it will generate a copy of your "SOURCE"
#   directory as "BACKUP.0". The next time the script runs, each old backup
#   will get its index increased ("BACKUP.i" -> "BACKUP.(i+1)"),
#   "BACKUP.(NUM_BACKUPS-1)" will be deleted. The trick to make it incremental
#   is that any unchanged from the previous backup won't be copied but rather
#   be hard-linked. That way each "BACKUP.i" has the full contents, while
#   preventing redundancy and therefore saving disk space.
#
# Schedule this script to run with crontab or similar with the desired period
#
# CONFIGURATION: Set all 3 variables below to your desired values
#
SOURCE=/var/lib/docker/volumes/nextcloud_data/_data
BACKUP=/media/backups/nextcloud_volume
NUM_BACKUPS=10

if [ "$NUM_BACKUPS" -lt "2" ]; then
  rsync -avh --delete $SOURCE $BACKUP.0/
else
  i=$((NUM_BACKUPS - 1))

  # Delete the last copy "BACKUP.(NUM_BACKUPS - 1)"
  rm -rf $BACKUP.$i

  # Increase the index "BACKUP.i" -> "BACKUP.(i+1)"
  while [ "$i" -gt "0" ]; do
    mv $BACKUP.$((i - 1)) $BACKUP.$i
    i=$((i - 1))
  done

  # Generate new backup, hard-linking from "BACKUP.1" unchanged files
  rsync -avh --delete --link-dest=$BACKUP.1/ $SOURCE $BACKUP.0/
fi
