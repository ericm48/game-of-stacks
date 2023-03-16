#!/usr/bin/env bash
set -e

alias k=kubectl

export KPACK_VERSION=$1
k apply -f https://github.com/pivotal/kpack/releases/download/v$KPACK_VERSION/release-$KPACK_VERSION.yaml

sleep 10

export RUN_IMAGE=$2
k apply -f ./kpack-resources/cluster-stack.yaml

k apply -f ./kpack-resources/cluster-store.yaml

k apply -f ./kpack-resources/cluster-builder.yaml

sleep 10

export APP_NAME=$3
export APP_REPO=$4
k apply -f ./kpack-resources/image.yaml