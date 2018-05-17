#!/usr/bin/env bash

set -x
docker build -t leaf_app $@ .
