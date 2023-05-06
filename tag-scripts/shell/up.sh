#!/usr/bin/env bash

function up() {
    count=$1

    while [ "$count" -gt 0 ]; do
        cd ..
        count=$(( count - 1 ))
    done
}

