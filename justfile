[private]
default:
  @just --list --unsorted

tag:
  #!/bin/bash
  version="$(head Dockerfile -n 1 | cut -d':' -f2)"
  echo git tag -v "${version}" -a "${version}"
