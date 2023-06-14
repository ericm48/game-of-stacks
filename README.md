## Prerequisites
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
* Access to a kubernetes cluster (could use [minikube](https://minikube.sigs.k8s.io/docs/start/) for this)
* Two dockerhub repos to push the kpack resource images to, **kpack-image** and **kpack-builder**
* `trivy` to scan the built OCI images. Installation [instructions](https://aquasecurity.github.io/trivy/v0.41/getting-started/installation/).

## Execution

* Replace every occurence of `semmet95` with your dockerhub username in the repo.
* Create a secret on the cluster with your dockerhub credentials to enable pushing images.
```
kubectl create secret docker-registry dockerhub-creds --docker-username=<dockerhub-username> --docker-password=<dockerhub-psword>
```

* Set the version of kpack to install
```
export KPACK_VERSION=0.10.1
```

* Run the script as follows
```
chmod +x ./kpack-setup.sh
./kpack-setup.sh \
    $KPACK_VERSION \
    io.paketo.stacks.tiny \
    paketobuildpacks/run:tiny-cnb
```

### Cleanup
```
kubectl delete image --all \
&& kubectl delete clusterbuilder --all \
&& kubectl delete clusterstore buildpack-store \
&& kubectl delete clusterstack --all \
&& kubectl delete -f https://github.com/pivotal/kpack/releases/download/v$KPACK_VERSION/release-$KPACK_VERSION.yaml \
&& minikube stop \
&& minikube delete
```