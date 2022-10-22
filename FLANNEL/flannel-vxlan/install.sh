#!/bin/bash

set -x

kind create cluster --name=flannel-vxlan --config=./kind-flannel.yaml --image=kindest/node:v1.23.4

controller_node=$(kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane)
kubectl taint nodes $controller_node node-role.kubernetes.io/master:NoSchedule-

for i in $(docker ps  -a --format "table {{.Names}}"|grep flannel-vxlan );do echo $i;docker cp /usr/bin/calicoctl $i:/usr/bin/calicoctl;docker cp ./bridge $i:/opt/cni/bin/;docker cp /usr/bin/ping $i:/usr/bin/ping;docker exec -it $i  bash -c "sed -i -e 's/jp.archive.ubuntu.com\|archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list";done

kubectl apply -f ./flannel.yaml


