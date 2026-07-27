# Project 5.1 -- Comprehensive Monitoring with Prometheus & Grafana

## Objective

Build a monitoring solution using **Prometheus**, **Node Exporter**, and
**Grafana** with Docker Compose.

## Architecture

``` text
Linux Server/Applications
        │
        ▼
 Node Exporter
        │
        ▼
   Prometheus
(Time-Series Database)
        │
        ▼
    Grafana
        │
        ▼
 Operations Team
```

## Components

### Prometheus

-   Collects metrics from configured targets.
-   Stores metrics as time-series data.
-   Provides PromQL query engine.
-   Default Port: **9090**

### Node Exporter

-   Exposes Linux system metrics.
-   Metrics: CPU, Memory, Disk, Network, Filesystem, Load.
-   Default Port: **9100**

### Grafana

-   Visualizes Prometheus metrics.
-   Creates dashboards and alerts.
-   Default Port: **3000**
-   Default Login: admin / admin

## Folder Structure

``` text
ComprehensiveMonitoringWithPrometheusAndGrafana/
├── docker-compose.yml
├── prometheus/
│   └── prometheus.yml
├── Screenshots/
└── README.md
```

## docker-compose.yml Overview

-   Prometheus service with persistent storage.
-   Node Exporter for host metrics.
-   Grafana with persistent dashboards.
-   Shared Docker bridge network.

## prometheus.yml

``` yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
- job_name: prometheus
  static_configs:
    - targets: ['prometheus:9090']

- job_name: node-exporter
  static_configs:
    - targets: ['node-exporter:9100']
```

### Explanation

-   **scrape_interval**: Metric collection frequency.
-   **evaluation_interval**: Rule evaluation frequency.
-   **job_name**: Logical monitoring target.
-   **targets**: Endpoints to scrape.

## Deployment

Start:

``` bash
docker compose up -d
```

Verify:

``` bash
docker ps
```

Stop:

``` bash
docker compose down
```

## URLs

-   Prometheus: http://`<EC2-IP>`{=html}:9090
-   Node Exporter: http://`<EC2-IP>`{=html}:9100/metrics
-   Grafana: http://`<EC2-IP>`{=html}:3000

## Configure Grafana

1.  Login (admin/admin).
2.  Connections → Data Sources.
3.  Add Prometheus.
4.  URL: `http://prometheus:9090`
5.  Save & Test.

## Recommended Dashboard

Import Dashboard ID **1860** (Node Exporter Full).

## Useful PromQL

``` promql
up
```

``` promql
100-(node_filesystem_avail_bytes/node_filesystem_size_bytes*100)
```

``` promql
(node_memory_MemTotal_bytes-node_memory_MemAvailable_bytes)
/node_memory_MemTotal_bytes*100
```

## Troubleshooting

-   Target DOWN → Check Node Exporter and `prometheus.yml`.
-   Grafana connection failed → Verify datasource URL.
-   No metrics → Visit `http://<EC2-IP>:9100/metrics`.

## Deliverables

-   docker-compose.yml
-   prometheus.yml
-   Docker containers screenshot
-   Prometheus targets screenshot
-   Node Exporter metrics screenshot
-   Grafana dashboard screenshot

## Skills Learned

-   Docker Compose
-   Prometheus
-   Grafana
-   Node Exporter
-   PromQL
-   Infrastructure Monitoring

## Summary

This project introduces infrastructure monitoring using Prometheus and
Grafana and forms the foundation for advanced monitoring, alerting,
logging, and scalable observability projects.
