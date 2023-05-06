#!/usr/bin/env bash

function yq() {
    docker run --rm -i -v "${PWD}":/workdir mikefarah/yq "$@"
}
