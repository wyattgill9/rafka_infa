#!/bin/bash

# Root directory (assumes current directory is infra)
ROOT_DIR="$(pwd)"
K8S_DIR="$ROOT_DIR/k8s"
CONFIGS_DIR="$ROOT_DIR/configs"
SCRIPTS_DIR="$ROOT_DIR/scripts"

echo "Setting up Kubernetes infrastructure..."

# Create directories
mkdir -p "$K8S_DIR/rafka" "$K8S_DIR/scylladb" "$K8S_DIR/etcd" "$CONFIGS_DIR" "$SCRIPTS_DIR"

# Namespace YAML
cat <<EOF > "$K8S_DIR/namespace.yaml"
apiVersion: v1
kind: Namespace
metadata:
  name: rakfa-test
EOF

# Rafka manifests
cat <<EOF > "$K8S_DIR/rafka/deployment.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rafka
  namespace: rakfa-test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: rafka
  template:
    metadata:
      labels:
        app: rafka
    spec:
      containers:
      - name: rafka
        image: rafka:latest
        ports:
        - containerPort: 8080
EOF

cat <<EOF > "$K8S_DIR/rafka/service.yaml"
apiVersion: v1
kind: Service
metadata:
  name: rafka
  namespace: rakfa-test
spec:
  selector:
    app: rafka
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
  type: ClusterIP
EOF

cat <<EOF > "$K8S_DIR/rafka/configmap.yaml"
apiVersion: v1
kind: ConfigMap
metadata:
  name: rafka-config
  namespace: rakfa-test
data:
  RAKFA_ENV: "testing"
  LOG_LEVEL: "debug"
EOF

# ScyllaDB manifests
cat <<EOF > "$K8S_DIR/scylladb/statefulset.yaml"
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: scylladb
  namespace: rakfa-test
spec:
  serviceName: "scylladb"
  replicas: 1
  selector:
    matchLabels:
      app: scylladb
  template:
    metadata:
      labels:
        app: scylladb
    spec:
      containers:
      - name: scylladb
        image: scylladb/scylla:latest
        ports:
        - containerPort: 9042
EOF

cat <<EOF > "$K8S_DIR/scylladb/service.yaml"
apiVersion: v1
kind: Service
metadata:
  name: scylladb
  namespace: rakfa-test
spec:
  selector:
    app: scylladb
  ports:
    - protocol: TCP
      port: 9042
      targetPort: 9042
  type: ClusterIP
EOF

cat <<EOF > "$K8S_DIR/scylladb/pvc.yaml"
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: scylladb-pvc
  namespace: rakfa-test
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
EOF

# Etcd manifests
cat <<EOF > "$K8S_DIR/etcd/statefulset.yaml"
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: etcd
  namespace: rakfa-test
spec:
  serviceName: "etcd"
  replicas: 1
  selector:
    matchLabels:
      app: etcd
  template:
    metadata:
      labels:
        app: etcd
    spec:
      containers:
      - name: etcd
        image: quay.io/coreos/etcd:latest
        ports:
        - containerPort: 2379
        - containerPort: 2380
EOF

cat <<EOF > "$K8S_DIR/etcd/service.yaml"
apiVersion: v1
kind: Service
metadata:
  name: etcd
  namespace: rakfa-test
spec:
  selector:
    app: etcd
  ports:
    - protocol: TCP
      port: 2379
      targetPort: 2379
    - protocol: TCP
      port: 2380
      targetPort: 2380
  type: ClusterIP
EOF

# Configs directory placeholders
echo "Creating placeholder configuration files..."
touch "$CONFIGS_DIR/scylladb.conf"
touch "$CONFIGS_DIR/etcd.conf"
touch "$CONFIGS_DIR/rafka.conf"

# Scripts directory placeholders
echo "Creating placeholder scripts..."
cat <<EOF > "$SCRIPTS_DIR/deploy-all.sh"
#!/bin/bash
kubectl apply -f $K8S_DIR/namespace.yaml
kubectl apply -f $K8S_DIR/scylladb/
kubectl apply -f $K8S_DIR/etcd/
kubectl apply -f $K8S_DIR/rafka/
EOF

chmod +x "$SCRIPTS_DIR/deploy-all.sh"

echo "Infrastructure setup complete!"
