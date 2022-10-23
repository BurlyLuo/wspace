kind create  cluster --name=kind-calico --config=./kind-calico.yaml --image=kindest/node:v1.23.4
kubectl apply -f ./calico.yaml
kubectl config set-context kind-kind-calico
