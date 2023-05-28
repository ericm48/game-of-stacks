#!/bin/bash
set -e

kubectl apply -f https://github.com/pivotal/kpack/releases/download/v$KPACK_VERSION/release-$KPACK_VERSION.yaml

sleep 10

export STACK_ID=$2
export RUN_IMAGE=$3
export BUILD_IMAGE=${RUN_IMAGE/run/build}
stack_name=$(echo "$RUN_IMAGE" | cut -d ":" -f 2)
export STACK_NAME=$stack_name

yq e -i '.metadata.name = env(STACK_NAME)' ./kpack-resources/clusterstack.yaml
yq e -i '.spec.id = env(STACK_ID)' ./kpack-resources/clusterstack.yaml
yq e -i '.spec.runImage.image = env(RUN_IMAGE)' ./kpack-resources/clusterstack.yaml
yq e -i '.spec.buildImage.image = env(BUILD_IMAGE)' ./kpack-resources/clusterstack.yaml
kubectl apply -f ./kpack-resources/clusterstack.yaml

kubectl apply -f ./kpack-resources/clusterstore.yaml

kubectl apply -f ./kpack-resources/serviceaccount.yaml
sleep 10

yq e -i '.metadata.name = env(STACK_NAME)' ./kpack-resources/clusterbuilder.yaml
yq e -i '.spec.stack.name = env(STACK_NAME)' ./kpack-resources/clusterbuilder.yaml
kubectl apply -f ./kpack-resources/clusterbuilder.yaml
sleep 10

export APP_NAME=semmet95/kpack-image:"$stack_name"
export IMAGE_NAME=app-image-"$stack_name"

yq e -i '.metadata.name = env(IMAGE_NAME)' ./kpack-resources/image.yaml
yq e -i '.spec.tag = env(APP_NAME)' ./kpack-resources/image.yaml
yq e -i '.spec.builder.name = env(STACK_NAME)' ./kpack-resources/image.yaml
kubectl apply -f ./kpack-resources/image.yaml