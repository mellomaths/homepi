# Grafana

Monitoring stack on the Pi: Grafana dashboards, Loki logs, Grafana Alloy (log collector), Prometheus metrics, node-exporter, and cAdvisor.

Promtail is end of life (March 2026). This stack uses [Grafana Alloy](https://grafana.com/docs/alloy/latest/) instead, collecting host logs from `/var/log` and Docker container logs via the Docker socket. Alloy does **not** bind-mount `/var/lib/docker/containers`, which is missing under rootless Docker and caused `permission denied` on start.

`./start.sh` uses `docker compose up -d --remove-orphans` so the old `grafana-promtail-1` container is removed.

## Start and stop

From the repo root:

```bash
just start grafana
just stop grafana
just status grafana
```

Or from this directory: `./start.sh` / `./stop.sh` / `./status.sh`.

After changing nginx site config, reload the reverse proxy:

```bash
just deploy nginx
```

## URLs

| Service | URL |
| --- | --- |
| Grafana (domain) | http://grafana.homepi.net/ |
| Grafana (LAN) | http://192.168.1.100:3000/ |
| Prometheus (LAN only, no nginx site) | http://192.168.1.100:3003/ |

Default Grafana login is `admin` / `admin`. Change it in the UI on first login, or set `GF_SECURITY_ADMIN_USER` and `GF_SECURITY_ADMIN_PASSWORD` in a `.env` file next to `docker-compose.yml` (see `.env.example`). Do not commit `.env`.

Datasources are provisioned: **Prometheus** (`http://prometheus:9090`) and **Loki** (`http://loki:3100`). Import dashboards from Grafana.com if you want a starting layout:

- Node Exporter Full: [1860](https://grafana.com/grafana/dashboards/1860)
- Docker: [193](https://grafana.com/grafana/dashboards/193)
- Loki: [13639](https://grafana.com/grafana/dashboards/13639)

## Host ports

Only two host ports are published so existing HomePi services are not displaced:

| Host port | Container | Notes |
| --- | --- | --- |
| 3000 | Grafana | Already used by Glance and nginx |
| 3003 | Prometheus (container 9090) | Next free port in the 300x range |

Loki (3100), Alloy (12345), node-exporter (9100), and cAdvisor (8080) stay on the compose network. Prometheus is not bound to host 9090 (Cockpit default). cAdvisor is not bound to host 8080 (Kafka UI).

## Image pins

- `grafana/grafana:13.1`
- `grafana/loki:3.5`
- `grafana/alloy:v1.10.0`
- `prom/prometheus:v3.4.2`
- `prom/node-exporter:v1.9.1`
- `gcr.io/cadvisor/cadvisor:v0.52.1`

All of these publish ARM64 manifests for Raspberry Pi 5.
