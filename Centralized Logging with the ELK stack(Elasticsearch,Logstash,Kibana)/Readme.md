# Project 5.2 -- Centralized Logging with the ELK Stack (Elasticsearch, Logstash, Kibana)

## Objective

Implement a centralized logging solution on an Ubuntu EC2 instance using
Docker Compose. Logs flow through:

``` text
Application Logs
      │
      ▼
  Filebeat
      │
      ▼
  Logstash
(Parse & Transform)
      │
      ▼
Elasticsearch
(Store & Index)
      │
      ▼
    Kibana
(Search & Visualize)
```

------------------------------------------------------------------------

# Tools Required

-   Ubuntu EC2
-   Docker
-   Docker Compose
-   Elasticsearch
-   Logstash
-   Kibana
-   Filebeat

------------------------------------------------------------------------

# Project Structure

``` text
Project5.2-ELK/
├── docker-compose.yml
├── filebeat/
│   └── filebeat.yml
├── logstash/
│   └── logstash.conf
└── logs/
    └── application.log
```

------------------------------------------------------------------------

# Step 1 -- Install Docker

``` bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker

docker --version

sudo apt install docker-compose-v2 -y
docker compose version
```

------------------------------------------------------------------------

# Step 2 -- docker-compose.yml

Create a Docker Compose file containing:

-   Elasticsearch
-   Logstash
-   Kibana
-   Filebeat

Use version **8.13.4** for all Elastic components.

Purpose:

-   Elasticsearch stores logs.
-   Logstash parses logs.
-   Filebeat ships logs.
-   Kibana visualizes logs.

------------------------------------------------------------------------

# Step 3 -- Configure Logstash

`logstash/logstash.conf`

Pipeline:

-   Input → Beats (port 5044)
-   Filter → Grok parser
-   Output → Elasticsearch

Example Grok pattern:

``` conf
%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:loglevel} %{GREEDYDATA:message}
```

Creates:

-   timestamp
-   loglevel
-   message

------------------------------------------------------------------------

# Step 4 -- Configure Filebeat

`filebeat/filebeat.yml`

Input:

``` text
/var/log/app/application.log
```

Output:

``` text
logstash:5044
```

Purpose:

Continuously reads application logs and sends them to Logstash.

------------------------------------------------------------------------

# Step 5 -- Sample Logs

``` text
2026-07-27 10:00:00 INFO Application Started Successfully
2026-07-27 10:01:05 INFO User Login Successful
2026-07-27 10:02:14 WARN Disk Usage Above 70 Percent
2026-07-27 10:03:48 ERROR Database Connection Failed
2026-07-27 10:05:10 INFO Background Job Started
2026-07-27 10:06:33 WARN High CPU Usage Detected
2026-07-27 10:07:50 ERROR Unable to Connect Payment Gateway
```

------------------------------------------------------------------------

# Step 6 -- Start ELK

``` bash
docker compose up -d

docker ps

docker logs elasticsearch
docker logs logstash
docker logs kibana
docker logs filebeat
```

------------------------------------------------------------------------

# Step 7 -- Verify Elasticsearch

``` bash
curl http://localhost:9200

curl http://localhost:9200/_cat/indices?v
```

Expected index:

``` text
application-logs-YYYY.MM.DD
```

------------------------------------------------------------------------

# Step 8 -- Configure Kibana

Open:

``` text
http://<EC2-PUBLIC-IP>:5601
```

Create a Data View:

``` text
application-logs-*
```

Open **Discover** and verify that logs are visible.

------------------------------------------------------------------------

# Step 9 -- Create Visualizations

## Log Levels

-   Lens
-   Pie Chart
-   Breakdown by `loglevel`
-   Save as **Log Levels**

## Log Count Over Time

-   Lens
-   Count of Records
-   X-axis → `@timestamp`
-   Save as **Log Count Over Time**

## Error Count

Filter:

``` text
loglevel = ERROR
```

Visualization:

``` text
Metric
```

Metric:

``` text
Count of Records
```

Save as **Error Count**

## Warning Count

Filter:

``` text
loglevel = WARN
```

Visualization:

``` text
Metric
```

Metric:

``` text
Count of Records
```

Save as **Warning Count**

------------------------------------------------------------------------

# Step 10 -- Create Dashboard

Dashboard → Create Dashboard

Add:

-   Log Levels
-   Log Count Over Time
-   Error Count
-   Warning Count

Suggested layout:

``` text
+----------------------------------------------------+
|            ELK Monitoring Dashboard                |
+----------------------------------------------------+
| Log Levels | Error Count | Warning Count           |
+----------------------------------------------------+
|             Log Count Over Time                    |
+----------------------------------------------------+
```

Dashboard Name:

``` text
ELK Monitoring Dashboard
```

------------------------------------------------------------------------

# Useful Commands

``` bash
docker ps
docker compose up -d
docker compose down

docker logs elasticsearch
docker logs logstash
docker logs kibana
docker logs filebeat

curl http://localhost:9200
curl http://localhost:9200/_cat/indices?v
```

------------------------------------------------------------------------

# Troubleshooting

## Kibana cannot connect

Verify Elasticsearch is running.

``` bash
docker ps
```

## No logs in Discover

-   Check Filebeat logs.
-   Check Logstash logs.
-   Verify Elasticsearch index exists.

## Dashboard Library Empty

Depending on the Kibana version, save visualizations before adding them
to a dashboard.

## Elasticsearch Not Starting

Reduce Java heap size or use a larger EC2 instance.

------------------------------------------------------------------------

# Cleanup

``` bash
docker compose down

docker compose down -v

docker volume prune -f

docker network prune -f
```

------------------------------------------------------------------------

# Deliverables

-   Project structure
-   docker compose up -d
-   docker ps
-   Elasticsearch indices
-   Kibana Data View
-   Discover page
-   Log Levels visualization
-   Log Count Over Time visualization
-   Error Count
-   Warning Count
-   ELK Monitoring Dashboard

------------------------------------------------------------------------

# Concepts Learned

-   ELK Stack
-   Docker Compose
-   Filebeat
-   Logstash
-   Grok Filters
-   Elasticsearch
-   Kibana
-   Discover
-   Dashboards
-   Centralized Logging
