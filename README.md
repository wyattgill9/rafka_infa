# Kubernetes Infrastructure
This folder contains Kubernetes (`k8s`) manifests for deploying ScyllaDB, Redis, and Etcd.


```
rakfa/
├── infrastructure/
│   ├── k8s/                          # Kubernetes manifests
│   │   ├── deployments/              # All tightly coupled services
│   │   │   ├── scylladb.yaml         # ScyllaDB StatefulSet with scaling configs
│   │   │   ├── redis.yaml            # Redis StatefulSet with scaling configs
│   │   │   ├── etcd.yaml             # Etcd StatefulSet with scaling configs
│   │   │   ├── raft.yaml             # Deployment for Raft-based logic
│   │   │   └── rafka.yaml            # Core Rafka service deployment
│   │   ├── common/                   # Shared resources (e.g., RBAC, storage classes)
│   │   │   ├── namespace.yaml        # Namespace for all services
│   │   │   ├── storage.yaml          # Persistent storage configs (PVC, StorageClass)
│   │   │   └── rbac.yaml             # Role-based access control
│   │   └── scaling.yaml              # Horizontal Pod Autoscaler and Cluster Autoscaler configs
│   │
│   ├── configs/                      # Centralized configuration files
│   │   ├── scylladb.conf             # ScyllaDB config
│   │   ├── redis.conf                # Redis config
│   │   ├── etcd.conf                 # Etcd config
│   │   ├── raft.toml                 # Raft-specific configs
│   │   └── scaling.json              # Unified scaling parameters
│   │
│   ├── monitoring/                   # Monitoring setup (Prometheus/Grafana)
│   │   ├── prometheus.yaml           # Prometheus config for all components
│   │   ├── grafana-dashboards/       # Grafana dashboard definitions
│   │   │   ├── scylladb.json
│   │   │   ├── redis.json
│   │   │   └── etcd.json
│   │   └── alerts.yaml               # AlertManager configuration
│   │
│   ├── scripts/                      # Automation scripts
│   │   ├── deploy-all.sh             # Deploy all services together
│   │   ├── scale-all.sh              # Scale all services together
│   │   └── monitor.sh                # Monitoring setup script
│   │
│   ├── terraform/                    # Infrastructure as code for cloud resources
│   │   ├── cluster.tf                # Kubernetes cluster provisioning
│   │   ├── networking.tf             # VPCs and networking setup
│   │   ├── storage.tf                # Persistent storage provisioning
│   │   └── scaling.tf                # Cloud autoscaler configurations
│   │
│   └── README.md                     # Infrastructure documentation

```