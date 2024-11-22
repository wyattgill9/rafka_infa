# Infrastructure
This folder contains Kubernetes (`k8s`) manifests for deploying ScyllaDB, Redis, and Etcd, aswell as scripts for automatic cluster scaling and deployment.

## Folder Structure

(Note: Basic for now)

```
infra/
│
├── k8s/                          # Kubernetes manifests
│   ├── rafka/                     # Rafka service resources
│   │   ├── deployment.yaml       # Rafka deployment manifest
│   │   ├── service.yaml          # Rafka service manifest
│   │   └── configmap.yaml        # Rafka config map
│   ├── scylladb/                  # ScyllaDB service resources
│   │   ├── statefulset.yaml      # ScyllaDB statefulset manifest
│   │   ├── service.yaml          # ScyllaDB service manifest
│   │   └── pvc.yaml              # ScyllaDB PVC manifest
│   ├── etcd/                     # Etcd service resources
│   │   ├── statefulset.yaml      # Etcd statefulset manifest
│   │   ├── service.yaml          # Etcd service manifest
│   ├── namespace.yaml            # Kubernetes namespace for all services
├── configs/                      # Placeholder config files
│   ├── scylladb.conf             # ScyllaDB config file
│   ├── etcd.conf                 # Etcd config file
│   ├── rafka.conf                # Rafka config file
├── scripts/                      # Automation scripts
│   ├── deploy-all.sh             # Deploys all services to Kubernetes
├── .gitignore                    # Git ignore file
├── setup-infra.sh                # Setup script for infrastructure (ignored by Git)
└── README.md                     # Basic project documentation

```

## Build

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd rafka_infra/infra
   ```

2. Run the setup script to initialize the infrastructure:
   ```bash
   bash setup-infra.sh
   ```

3. Deploy the services using the `deploy-all.sh` script:
   ```bash
   ./scripts/deploy-all.sh
   ```

4. Check the Kubernetes services:
   ```bash
   kubectl get services -n rakfa-test
   ```

## Notes

- The infrastructure is deployed to the `rakfa-test` namespace.
- Configuration files are placeholders (Change later)