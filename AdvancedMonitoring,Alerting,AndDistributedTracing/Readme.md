# Project 5.3 – Advanced Monitoring, Alerting and Distributed Tracing

This guide documents the complete setup performed during Project 5.3.


## Objective
- Deploy Prometheus
- Configure Recording Rules
- Configure Alert Rules
- Deploy Alertmanager
- Deploy Jaeger
- Monitor a Spring Boot application
- (Optional) Send alerts to Slack

## Architecture

```text
User
  |
  v
Spring Boot App
 | Metrics          | Traces
 v                  v
Prometheus ------> Jaeger
    |
    v
Alertmanager
    |
    +--> Slack (#alerts)
```

## Folder Structure

```text
Project5.3-Monitoring/
├── docker-compose.yml
├── prometheus/
│   ├── prometheus.yml
│   ├── recording_rules.yml
│   └── alert_rules.yml
├── alertmanager/
│   └── alertmanager.yml
└── app/
```

## docker-compose.yml Notes

- Prometheus on port 9090
- Alertmanager on port 9093
- Jaeger UI on port 16686
- Spring Boot on port 8080

## prometheus.yml

```yaml
# Scrape every 15 seconds
global:
  scrape_interval: 15s

# Load rule files
rule_files:
  - recording_rules.yml
  - alert_rules.yml

# Alertmanager target
alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - alertmanager:9093

# Scrape targets
scrape_configs:
  # Prometheus
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090

  # Spring Boot
  - job_name: springboot
    metrics_path: /actuator/prometheus
    static_configs:
      - targets:
          - app:8080
```

## recording_rules.yml

```yaml
groups:
- name: recording_rules
  rules:
  # Pre-compute sum(up)
  - record: job:up:sum
    expr: sum(up)
```

## alert_rules.yml

```yaml
groups:
- name: alert_rules
  rules:
  # Fire when application is down
  - alert: InstanceDown
    expr: up == 0
    for: 1m
    labels:
      severity: critical
    annotations:
      summary: "Instance Down"
      description: "Prometheus target is unreachable."
```

## alertmanager.yml (Slack)

```yaml
route:
  receiver: slack-notifications

receivers:
- name: slack-notifications
  slack_configs:
  - api_url: "REPLACE_WITH_YOUR_WEBHOOK"
    channel: "#alerts"
    send_resolved: true
```

## Build

```bash
cd app
./mvnw clean package
cd ..
docker compose up --build -d
```

## Verification

- http://<EC2-IP>:8080
- http://<EC2-IP>:8080/actuator/prometheus
- http://<EC2-IP>:9090
- http://<EC2-IP>:9093
- http://<EC2-IP>:16686

Check:
- Status -> Targets
- Status -> Rules
- Alerts

## Trigger Alert

```bash
docker stop springboot-app
```

Wait one minute until InstanceDown becomes FIRING.

Restart:

```bash
docker start springboot-app
```

## Slack Integration

1. Create Slack workspace.
2. Create channel #alerts.
3. Install Incoming Webhooks.
4. Copy webhook URL.
5. Update alertmanager.yml.
6. Restart Alertmanager:
```bash
docker compose restart alertmanager
```
7. Stop springboot-app.
8. Verify notification in Slack.

## Cleanup

```bash
docker compose down
docker compose down -v
```

## Deliverables

- docker ps
- Prometheus Targets
- Recording Rules
- Alert Rules
- FIRING Alert
- Alertmanager
- Jaeger
- Spring Boot metrics
- Slack alert (optional)

## Interview Questions

- What is Prometheus?
- What is Alertmanager?
- What are Recording Rules?
- What is Jaeger?
- Difference between Metrics and Traces?
