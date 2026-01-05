[private]
default:
  @just --list --unsorted

tag:
  #!/bin/bash
  version="$(head Dockerfile -n 1 | cut -d':' -f2)"
  git tag -a ${version} -m ${version}

build:
  docker build . -t clux/renovate:local
