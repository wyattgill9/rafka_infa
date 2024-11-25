## INFRA LAYOUT



```bash
infra/
├── k8s/
│   ├── base/                      # Base manifests for shared configurations
│   │   ├── scylla/                # ScyllaDB manifests
│   │   │   ├── statefulset.yaml
│   │   │   ├── service.yaml
│   │   │   ├── storageclass.yaml  # Optional if using custom storage classes
│   │   │   ├── configmap.yaml     # Optional ScyllaDB configs (e.g., cassandra.yaml)
│   │   │   └── secrets.yaml       # Secrets (API keys, passwords)
│   │   ├── rafka/                 # Rafka-specific infra manifests
│
│   ├── overlays/                  # Environment-specific configurations (blank)
│   │   ├── dev/
│   │   ├── prod/
│
├── helm/                          # Helm charts (if using Helm for ScyllaDB)
│   ├── scylla/
│   └── rafka/
│
└── scripts/                       # Scripts for auto deployment and scaling of the cluster
    ├── deploy.sh
    └── hpa.sh                    
```


## Diagram of what it does 
```
                    +----------------------------+
                    |     Kubernetes Cluster     |
                    +----------------------------+
                             |
          +-----------------------------------------------+
          |                                               |
  +----------------------+                        +----------------------+
  |    Rafka Pods        |                        |    Scylla Pods       |
  |  (Horizontal Scale)  |                        |  (Horizontal Scale)  |
  |                      |                        |                      |
  |   +-------------+    |                        |   +-------------+    |
  |   |  rafka-0   |    |                        |   |  scylla-0  |    |
  |   +-------------+    |                        |   +-------------+    |
  |   +-------------+    |                        |   |  scylla-1  |    |
  |   |  rafka-1   |    |                        |   +-------------+    |
  |   +-------------+    |                        |   +-------------+    |
  |   +-------------+    |                        |   |  scylla-2  |    |
  |   |  rafka-2   |    |                        |   +-------------+    |
  |   +-------------+    |                        |                      |
  +----------------------+                        +----------------------+
          |                                               |
          +-----------------------------------------------+
                             |
                +----------------------------+
                |      Rafka Service (LB)    |
                |     (Horizontal Scale)     |
                +----------------------------+
                             |
                 +--------------------------+
                 |    External Clients      |
                 +--------------------------+
                             |
                +----------------------------+
                |    Scylla Service (Cluster)|
                |     (Cluster IP)           |
                +----------------------------+
                             |
        +-------------------------------------------+
        |                                           |
+----------------------++                +-----------------------+
|   Scylla Cluster      |                |   Scylla Cluster      |
| (Replicated, sharded) |                | (Replicated, sharded) |
+-----------------------+                +-----------------------+
```