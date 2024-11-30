## INFRA LAYOUT



```bash
infra/
├── k8s/
│   ├── base/                      # Base manifests for shared configurations
│   │   ├── scylla/                # ScyllaDB manifests
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
|      Kubernetes Cluster     |
+----------------------------+
             |
 +-------------------------------+
 |                               |
 |  +---------------------+      +----------------------+
 |  |    Rafka Pods       |      |     Skytable Cluster  |
 |  |  (Horizontal Scale) |      |   (Horizontal Scale)  |
 |  |                     |      |                       |
 |  |  +-------------+    |      |   +-------------+     |
 |  |  |  rafka-0   |    |      |   |  skytable-0 |     |
 |  |  +-------------+    |      |   +-------------+     |
 |  |  +-------------+    |      |   +-------------+     |
 |  |  |  rafka-1   |    |      |   |  skytable-1 |     |
 |  |  +-------------+    |      |   +-------------+     |
 |  |  +-------------+    |      |   +-------------+     |
 |  |  |  rafka-2   |    |      |   |  skytable-2 |     |
 |  |  +-------------+    |      |   +-------------+     |
 |  +---------------------+      +----------------------+
             |
   +-------------------------------+
   |    Rafka Service (LB)         |
   |  (Load Balancer for Consumers) |
   +-------------------------------+
             |
   +----------------------------+
   |   External Consumers       |
   +----------------------------+
             |
   +-------------------------------+
   |   ScyllaDB Cluster (Replicated)|
   |    (Cold Storage/Long-term)    |
   +-------------------------------+

```