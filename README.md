## Overview
This project provisions a one master one worker Kubernetes using RancherOS, vagrant, and VirtualBox.

## Prerequisites
* [RKE](https://github.com/rancher/rke/releases/tag/v1.0.0)

## Quickstart
Linux
```
$ vagrant up  # wait for all nodes to come up
$ wget https://github.com/rancher/rke/releases/download/v1.0.0/rke_linux-amd64
$ chmod +x rke_linux-amd64
$ ./rke_linux-amd64 up
$ export KUBECONFIG=$(pwd)/kube_config_cluster.yml
$ kubectl get node -o wide
```

# Cleanup
```
$ ./rke_linux-amd64 remove --force
```

