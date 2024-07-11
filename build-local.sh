#!/bin/bash

base=$( realpath $(dirname $0) )

mkdir -p $base/venv
mkdir -p $base/src
touch $base/src/requirements.txt

echo "🐳 docker build"
docker build -t markdown $base

echo "🔧 genstyles"
docker run --rm -it \
  --name mardown-server \
  --user python \
  -v $base/src:/src \
  -w /src \
  markdown /usr/local/bin/genstyles.sh
