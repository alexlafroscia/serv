#!/bin/sh

function parse_git_hash() {
  git rev-parse HEAD 2> /dev/null
}

docker build -f "apps/serv_web/Dockerfile" -t "gcr.io/serv-179106/api-server:$(parse_git_hash)" .
docker build -f "apps/file_server/Dockerfile" -t "gcr.io/serv-179106/file-server:$(parse_git_hash)" .
