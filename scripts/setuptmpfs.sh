#!/bin/sh

TMPFS=/mnt/pmemdir
sudo mkdir $TMPFS
sudo chown -R $USER $TMPFS
sudo mount -t tmpfs -o size=$1M tmpfs $TMPFS
