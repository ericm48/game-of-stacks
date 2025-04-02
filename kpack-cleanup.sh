#!/bin/bash
#set -e

echo "Deleting: svc-petclinic..."
kubectl delete -f ./examples/svc-petclinic.yaml

echo "Deleting: pod-petclinic..."
kubectl delete -f ./examples/pod-petclinic.yaml

echo "Deleting: image..."
kp image delete app-image-full-cnb
kubectl delete -f ./kpack-resources/image.yaml

echo "Deleting: clusterstack..."
kubectl delete -f ./kpack-resources/clusterstack.yaml

echo "Deleting: clusterstore..."
kubectl delete -f ./kpack-resources/clusterstore.yaml

echo "Deleting: clusterbuilder..."
kubectl delete -f ./kpack-resources/clusterbuilder.yaml

echo "Deleting: serviceaccount..."
kubectl delete -f ./kpack-resources/serviceaccount.yaml

echo "Deleting: Done!"
