## Prerequisites
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
* Access to a kubernetes cluster (could use [minikube](https://minikube.sigs.k8s.io/docs/start/) for this)

## Execution
Run the script as follows
```
chmod +x ./kpack-setup.sh
./kpack-setup.sh \
    0.10.1 \
    paketobuildpacks/run:base-cnb \
    https://github.com/spring-io/initializr \
    spring-io-initialzr
```