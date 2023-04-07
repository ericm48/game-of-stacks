#!/bin/bash
set -eux

#docker login
#eval $(minikube -p minikube docker-env)

export KPACK_VERSION=$1
kubectl apply -f https://github.com/pivotal/kpack/releases/download/v$KPACK_VERSION/release-$KPACK_VERSION.yaml

sleep 10

export RUN_IMAGE=$2
yq e -i '.spec.runImage.image = env(RUN_IMAGE)' ./kpack-resources/cluster-stack.yaml
kubectl apply -f ./kpack-resources/cluster-stack.yaml

kubectl apply -f ./kpack-resources/cluster-store.yaml
sleep 10

kubectl apply -f ./kpack-resources/cluster-builder.yaml
sleep 10

export APP_NAME=$3
export APP_REPO=$4
yq e -i '.spec.tag = env(APP_NAME)' ./kpack-resources/image.yaml
yq e -i '.spec.source.git.url = env(APP_REPO)' ./kpack-resources/image.yaml
kubectl apply -f ./kpack-resources/image.yaml