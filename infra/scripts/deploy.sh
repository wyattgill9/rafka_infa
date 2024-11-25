# FUTURE

# #!/bin/bash
# set -euo pipefail

# # Base Path
# BASE_PATH="../k8s/base"

# echo "Applying Kubernetes configurations for ScyllaDB and Rafka..."

# # Apply Rafka Deployment and Service
# echo "Applying Rafka Deployment and Service..."
# kubectl apply -f "$BASE_PATH/rafka/deployment.yaml"
# kubectl apply -f "$BASE_PATH/rafka/service.yaml"

# # Wait for pods to be ready
# echo "Waiting for all pods to be ready..."
# kubectl wait --for=condition=ready pod --selector=app=rafka --timeout=300s

# # Verify + Display status
# echo "Checking Deployment and Pod status..."
# kubectl get deployments -l app=rafka
# kubectl get pods -l app=rafka

# echo "All pods are ready. Rafka and Scylla systems are up and running!"



#!/bin/bash
set -e

# Base Path
BASE_PATH="../k8s/base"

kubectl apply -f "$BASE_PATH/rafka/deployment.yaml"
kubectl apply -f "$BASE_PATH/rafka/service.yaml"

echo "Deployment completed successfully!"

# Wait for all pods to be ready
kubectl wait --for=condition=ready pod --all --timeout=300s

echo "All pods are ready. Rafka system is up and running!"
