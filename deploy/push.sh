#!/bin/sh

function parse_git_hash() {
  git rev-parse HEAD 2> /dev/null
}

docker push "gcr.io/serv-179106/api-server:$(parse_git_hash)"
docker push "gcr.io/serv-179106/file-server:$(parse_git_hash)"
