#!/bin/bash
set -e

kubectl apply -f https://github.com/pivotal/kpack/releases/download/v$KPACK_VERSION/release-$KPACK_VERSION.yaml

sleep 10

export RUN_IMAGE=$2
export BUILD_IMAGE=${RUN_IMAGE/run/build}
yq e -i '.spec.runImage.image = env(RUN_IMAGE)' ./kpack-resources/clusterstack.yaml
yq e -i '.spec.buildImage.image = env(BUILD_IMAGE)' ./kpack-resources/clusterstack.yaml
kubectl apply -f ./kpack-resources/clusterstack.yaml

kubectl apply -f ./kpack-resources/clusterstore.yaml

kubectl apply -f ./kpack-resources/serviceaccount.yaml
sleep 10

kubectl apply -f ./kpack-resources/clusterbuilder.yaml
sleep 10

export APP_NAME=semmet95/kpack-image:$(echo "$RUN_IMAGE" | cut -d ":" -f 2)
yq e -i '.spec.tag = env(APP_NAME)' ./kpack-resources/image.yaml
kubectl apply -f ./kpack-resources/image.yaml