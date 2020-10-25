#!/usr/bin/env bash
BRANCH=$1
ADDONS="$HOME/src/odoo/$BRANCH/addons"
WORKER_ADDONS=web

for entry in "$HOME/src"/*
do
  if [ -d "$entry/$BRANCH" ] && [ $entry != "$HOME/src/odoo" ]; then
        ADDONS="$entry/$BRANCH,$ADDONS"
        # each addons ending with '_worker' is considered as a worker to load
        WORKER_ADDONS="$WORKER_ADDONS"$(find "$entry/$BRANCH" -maxdepth 1 -type d -name '*_worker' -printf ',%f')
    fi;
done;
