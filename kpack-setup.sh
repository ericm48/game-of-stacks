#!/bin/bash
set -eu

export KPACK_VERSION=$1
kubectl apply -f https://github.com/pivotal/kpack/releases/download/v$KPACK_VERSION/release-$KPACK_VERSION.yaml

sleep 10

export RUN_IMAGE=$2
kubectl apply -f ./kpack-resources/cluster-stack.yaml

kubectl apply -f ./kpack-resources/cluster-store.yaml

kubectl apply -f ./kpack-resources/cluster-builder.yaml

sleep 10

export APP_NAME=$3
export APP_REPO=$4
kubectl apply -f ./kpack-resources/image.yaml