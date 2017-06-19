#!/bin/bash

rm -rf /download/*
cd /app

xvfb-run --server-args="-screen 0 1024x768x24" ./bundle_exec.sh $@

cd /download
[ -f *.zip ] && unzip *.zip
