# Project 5.1 -- Implementing Comprehensive Monitoring with Prometheus and Grafana

## Objective

Implement a complete monitoring solution on an existing AWS EKS cluster
using Prometheus and Grafana. Configure monitoring targets, visualize
metrics, and explore PromQL queries.

------------------------------------------------------------------------

# Project Architecture

``` text
Infrastructure (EKS Nodes & Applications)
                │
                ▼
      Node Exporter + kube-state-metrics
                │
                ▼
          Prometheus Server
      (Collects & Stores Metrics)
                │
                ▼
             Grafana
    (Dashboards & Visualization)
                │
                ▼
      End User / Operations Team
```

------------------------------------------------------------------------

# Prerequisites

-   Existing AWS EKS cluster (Terraform)
-   kubectl configured
-   AWS CLI configured
-   Helm installed
-   Internet access

------------------------------------------------------------------------

# Step 1 -- Verify the EKS Cluster

``` bash
aws eks list-clusters
aws eks update-kubeconfig --region ap-south-2 --name Monitoring-Kubernetes-eks
kubectl get nodes
kubectl get pods -A
```

Purpose: - Ensure the cluster is running. - Confirm worker nodes are
Ready. - Verify Kubernetes system pods.

------------------------------------------------------------------------

# Step 2 -- Install Prometheus

Add Helm repositories:

``` bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

Create namespace:

``` bash
kubectl create namespace monitoring
```

Install Prometheus:

``` bash
helm install prometheus prometheus-community/prometheus -n monitoring
```

Verify:

``` bash
kubectl get pods -n monitoring
```

Explanation: Prometheus collects metrics from Kubernetes targets and
stores them as time-series data.

------------------------------------------------------------------------

# Step 3 -- Configure Monitoring Targets

The Helm chart automatically installs:

-   Prometheus Server
-   Node Exporter
-   kube-state-metrics
-   Alertmanager
-   Pushgateway

Verify:

``` bash
kubectl get pods -n monitoring
```

Node Exporter collects: - CPU - Memory - Disk - Network

kube-state-metrics collects: - Deployments - Pods - ReplicaSets -
Nodes - Namespaces

------------------------------------------------------------------------

# Step 4 -- Verify Prometheus Targets

Port-forward:

``` bash
kubectl port-forward svc/prometheus-server 9090:80 -n monitoring
```

Open:

http://localhost:9090

Navigate to:

Status → Targets

Expected: All targets should show **UP**.

------------------------------------------------------------------------

# Step 5 -- Install Grafana

``` bash
helm install grafana grafana/grafana -n monitoring
```

Get password:

``` bash
kubectl get secret grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode && echo
```

Username:

``` text
admin
```

Port-forward:

``` bash
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

Open:

http://localhost:3000

------------------------------------------------------------------------

# Step 6 -- Connect Grafana to Prometheus

Go to:

Connections → Data Sources → Prometheus

Datasource URL:

``` text
http://prometheus-server.monitoring.svc.cluster.local
```

Click **Save & Test**

Expected:

    Successfully queried the Prometheus API

Explanation: Grafana reads metrics from Prometheus rather than
collecting metrics itself.

------------------------------------------------------------------------

# Step 7 -- Import Dashboards

Recommended IDs:

  Dashboard                ID
  ------------------------ -------
  Kubernetes Cluster       6417
  Node Exporter Full       1860
  Kubernetes Views Nodes   15759

Import process:

1.  Dashboards
2.  Import
3.  Enter ID
4.  Load
5.  Select Prometheus datasource
6.  Import

------------------------------------------------------------------------

# Step 8 -- Install Metrics Server

Initially:

``` bash
kubectl top nodes
```

returned:

``` text
error: Metrics API not available
```

Install:

``` bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Verify:

``` bash
kubectl get pods -n kube-system | grep metrics-server
kubectl top nodes
kubectl top pods -A
```

Purpose: Metrics Server enables Kubernetes resource metrics used by
kubectl top and some dashboards.

------------------------------------------------------------------------

# Step 9 -- Explore PromQL

Useful queries:

CPU

``` promql
rate(node_cpu_seconds_total{mode!="idle"}[5m])
```

Memory

``` promql
node_memory_MemAvailable_bytes
```

Disk

``` promql
node_filesystem_avail_bytes
```

Targets

``` promql
up
```

Running Pods

``` promql
kube_pod_status_phase{phase="Running"}
```

Node Count

``` promql
count(up)
```

------------------------------------------------------------------------

# Useful Commands

``` bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
kubectl get pvc -n monitoring
kubectl get storageclass
kubectl top nodes
kubectl top pods -A
helm list -n monitoring
```

------------------------------------------------------------------------

# Troubleshooting

## Prometheus Pending

``` bash
kubectl describe pod <pod> -n monitoring
kubectl get pvc -n monitoring
kubectl get storageclass
```

## Grafana cannot connect

Correct datasource:

``` text
http://prometheus-server.monitoring.svc.cluster.local
```

Do not use localhost because Grafana runs inside Kubernetes.

## Metrics API not available

Install Metrics Server.

## Dashboard shows N/A

Some dashboards expect kubelet/cAdvisor metrics or kube-prometheus-stack
metrics. Basic monitoring can still function correctly.

------------------------------------------------------------------------

# Deliverables

Capture screenshots of:

1.  kubectl get nodes
2.  kubectl get pods -n monitoring
3.  Prometheus Targets (UP)
4.  Grafana datasource success
5.  Imported dashboard
6.  PromQL query results
7.  kubectl top nodes
8.  kubectl top pods -A

------------------------------------------------------------------------

# Cleanup

``` bash
helm uninstall prometheus -n monitoring
helm uninstall grafana -n monitoring
kubectl delete namespace monitoring
kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

cd terraform
terraform destroy
```

------------------------------------------------------------------------

# Concepts Learned

-   Prometheus architecture
-   Grafana visualization
-   Node Exporter
-   kube-state-metrics
-   Alertmanager
-   PromQL
-   Metrics Server
-   Helm
-   Kubernetes monitoring
-   AWS EKS monitoring
