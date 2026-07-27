# Project 5.4 -- Scaling Monitoring Infrastructure using Thanos

## Objective

Build a highly available monitoring stack using Prometheus, Thanos,
MinIO, and Grafana with Docker Compose.

------------------------------------------------------------------------

# Architecture

``` text
Prometheus A ─┐
              │
Prometheus B ─┼──► Thanos Sidecars ───► MinIO (Object Storage)
              │            │
Prometheus C ─┘            │
                           ▼
                    Thanos Store Gateway
                           │
                           ▼
                      Thanos Query
                           │
                           ▼
                         Grafana
```

------------------------------------------------------------------------

# Components

  -----------------------------------------------------------------------
  Component                               Purpose
  --------------------------------------- -------------------------------
  Prometheus A/B/C                        Collect metrics independently

  Thanos Sidecar                          Connects Prometheus to Thanos
                                          and uploads TSDB blocks

  MinIO                                   S3-compatible object storage

  Thanos Store                            Reads historical blocks from
                                          MinIO

  Thanos Query                            Aggregates data from Sidecars +
                                          Store

  Grafana                                 Visualization
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# Project Structure

``` text
ScalingMonitoring/
├── docker-compose.yml
├── thanos/
│   └── bucket.yml
├── prometheus-a/
│   └── prometheus.yml
├── prometheus-b/
│   └── prometheus.yml
├── prometheus-c/
│   └── prometheus.yml
```

------------------------------------------------------------------------

# Docker Services

-   MinIO
-   Prometheus A
-   Prometheus B
-   Prometheus C
-   Thanos Sidecar A
-   Thanos Sidecar B
-   Thanos Sidecar C
-   Thanos Store Gateway
-   Thanos Query
-   Grafana

Verify:

``` bash
docker ps
```

------------------------------------------------------------------------

# Prometheus Configuration

Important flags:

``` text
--storage.tsdb.path=/prometheus
--storage.tsdb.retention.time=15d
--storage.tsdb.min-block-duration=2h
--storage.tsdb.max-block-duration=2h
```

> For demos only, temporarily use 1 minute block duration to quickly
> generate blocks:
>
>     --storage.tsdb.min-block-duration=1m
>     --storage.tsdb.max-block-duration=1m

Each `prometheus.yml` must contain:

``` yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

external_labels:
  replica: prometheus-a
```

(Change replica label appropriately for B and C.)

------------------------------------------------------------------------

# bucket.yml

``` yaml
type: S3

config:
  bucket: thanos
  endpoint: minio:9000
  access_key: admin
  secret_key: admin123
  insecure: true
```

------------------------------------------------------------------------

# Deployment

``` bash
docker compose up -d
```

Verify:

``` bash
docker ps
```

------------------------------------------------------------------------

# Validation

## MinIO

-   Login: http://`<EC2-IP>`{=html}:9001
-   User: admin
-   Password: admin123

Create bucket:

    thanos

Uploaded TSDB block folders indicate successful uploads.

------------------------------------------------------------------------

## Thanos Query

Open:

    http://<EC2-IP>:9095/stores

Expected:

-   Sidecar A -- UP
-   Sidecar B -- UP
-   Sidecar C -- UP
-   Store -- UP

------------------------------------------------------------------------

## Grafana

Login:

-   admin
-   admin

Datasource:

    http://thanos-query:9090

Test query:

``` promql
up
```

Expected:

Three series:

-   prometheus-a
-   prometheus-b
-   prometheus-c

------------------------------------------------------------------------

# Troubleshooting Notes

## 1. Sidecar Restart

Error:

    Compaction needs to be disabled

Fix:

    --storage.tsdb.min-block-duration=2h
    --storage.tsdb.max-block-duration=2h

------------------------------------------------------------------------

## 2. Store Permission Denied

Error:

    mkdir /data/meta-syncer: permission denied

Fix:

``` yaml
user: "0:0"
```

------------------------------------------------------------------------

## 3. Sidecar Permission Denied

Error:

    open /prometheus/thanos.shipper.json.tmp: permission denied

Fix:

``` yaml
user: "0:0"
```

for all three Sidecars.

------------------------------------------------------------------------

## 4. Bucket Does Not Exist

Error:

    The specified bucket does not exist

Fix:

Create the `thanos` bucket in MinIO.

------------------------------------------------------------------------

## 5. Grafana Shows No Data

Checklist:

-   Datasource points to `http://thanos-query:9090`
-   Query is `up`
-   Stores page shows all components UP
-   Sidecars are uploading blocks
-   MinIO bucket contains blocks

------------------------------------------------------------------------

# Useful Commands

``` bash
docker compose up -d
docker compose down
docker ps
docker logs thanos-sidecar-a --tail=50
docker logs thanos-store --tail=50
docker exec thanos-query wget -qO- http://thanos-store:10902/-/healthy
```

------------------------------------------------------------------------

# Deliverables

-   docker-compose.yml
-   bucket.yml
-   prometheus.yml (A/B/C)
-   Docker running containers
-   MinIO bucket and uploaded blocks
-   Thanos Stores page
-   Grafana datasource
-   Grafana `up` query
-   Prometheus A/B/C query pages

------------------------------------------------------------------------

# Final Success Checklist

-   [x] All containers running
-   [x] Sidecars connected
-   [x] Store Gateway healthy
-   [x] Query healthy
-   [x] Grafana connected
-   [x] MinIO bucket created
-   [x] Blocks uploaded
-   [x] Grafana returns metrics from all three Prometheus instances

This project demonstrates a production-style monitoring architecture
using Prometheus + Thanos for highly available metrics collection and
long-term storage.
