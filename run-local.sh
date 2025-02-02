#!/bin/bash

base=$( realpath $(dirname $0) )

mkdir -p $base/venv
mkdir -p $base/src
touch $base/src/requirements.txt

echo "🐳 docker run"
docker run --rm -it \
  --name mardown-server \
  -v $base/src:/src \
  -p 8080:8080 \
  -w /src \
  markdown
