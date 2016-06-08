#!/bin/sh

set -e

cd /etc/fastd/backbone
/usr/bin/git pull
systemctl reload fastd.service
