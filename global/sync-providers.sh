#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
rsync -av --copy-links --delete "$SCRIPT_DIR/providers-src/" "$SCRIPT_DIR/traefik/providers/"
