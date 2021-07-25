#!/bin/bash

# Get absolute path and basename of this repo
repo_path="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
project_name="$(basename "$repo_path")"

# Build the ISO image
build_iso() {
    if findmnt | grep "$project_name" ; then
        err_bind_mounts
    else
        sudo rm -rf "$repo_path"/{work,out} &> /dev/null
        sudo mkarchiso -v \
            -w "$repo_path/work" \
            -o "$repo_path/out" \
            "$repo_path" || err_build_fail
        exit 0
    fi
}

err_bind_mounts() {
    printf "\nERROR: There are bind mounts remaining from a failed build process.\n"
    printf "       Please manually unmount them and try again.\n"
    exit 2
}

err_build_fail() {
    printf "\nERROR: The ISO build was unsuccessful.\n"
    printf "       Find leftover bind mounts with { \$ findmnt | grep arch-grit }.\n"
    exit 2
}

build_iso "$@"
