#!/bin/bash
set -e


# FOR FUTURE WAIT

# # Deploy etcd
# kubectl apply -f kubernetes/etcd/manifests/etcd-deployment.yaml
# kubectl apply -f kubernetes/etcd/config/etcd-config.yaml

# # Deploy SyllaDB
# kubectl apply -f kubernetes/sylladb/manifests/sylladb-deployment.yaml
# kubectl apply -f kubernetes/sylladb/config/sylladb-config.yaml

# # Deploy Rafka
# kubectl apply -f kubernetes/rafka/manifests/rafka-deployment.yaml
# kubectl apply -f kubernetes/rafka/config/rafka-config.yaml

# # Deploy monitoring stack
# kubectl apply -f monitoring/prometheus/prometheus-deployment.yaml
# kubectl apply -f monitoring/grafana/grafana-deployment.yaml
# kubectl apply -f monitoring/alertmanager/alertmanager-deployment.yaml

kubectl apply -f ../kubernetes/deployment.yaml
kubectl apply -f ../kubernetes/service.yaml

echo "Deployment completed successfully!"

# Wait for all pods to be ready
kubectl wait --for=condition=ready pod --all --timeout=300s

echo "All pods are ready. Rafka system is up and running!"