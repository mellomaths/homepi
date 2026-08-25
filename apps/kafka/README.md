# Kafka (KRaft) and Kafka UI

Slim Docker Compose stack for HomePi: a single Apache Kafka broker in KRaft mode (no ZooKeeper) plus Kafbat UI (maintained fork of Provectus Kafka UI).

## Services

- **kafka-broker** (`apache/kafka:4.3.1`): combined broker + controller
- **kafka-ui** (`kafbat/kafka-ui:v1.5.0`): web UI for topics, messages, and consumer groups

## Quick start

```bash
just start kafka
just status kafka
just stop kafka
```

Or from this directory:

```bash
./start.sh
./status.sh
./stop.sh
```

### First start after the old Confluent stack

ZooKeeper / Schema Registry / Connect volumes are incompatible with KRaft. If that stack ever ran on this Pi, remove it once before the first new start:

```bash
just stop kafka
cd apps/kafka && docker compose --env-file kafka.env down -v
just start kafka
```

Do not change `CLUSTER_ID` in `kafka.env` after `kafka-data` exists; a new id with old data will prevent the broker from starting.

## Configuration

Edit [`kafka.env`](kafka.env), then restart:

| Variable | Default | Purpose |
|----------|---------|---------|
| `KAFKA_ADVERTISED_HOST` | `192.168.1.100` | Host LAN clients use in broker metadata |
| `KAFKA_BROKER_HOST_PORT` | `9092` | Host port for the Kafka protocol |
| `KAFKA_UI_HOST_PORT` | `8004` | Host port for Kafka UI (not 8080; Glance uses 8080 inside its container) |
| `CLUSTER_ID` | (fixed id) | KRaft cluster id; keep stable |
| `KAFKA_HEAP_OPTS` | `-Xmx512M -Xms256M` | JVM heap cap for the Pi |

`start.sh` / `stop.sh` pass this file as `docker compose --env-file kafka.env`.

## Endpoints

| Service | URL | Notes |
|---------|-----|--------|
| Kafka broker | `192.168.1.100:9092` | LAN producers/consumers |
| Kafka UI | `http://192.168.1.100:8004/` | Direct host port |
| Kafka UI (nginx) | `http://kafka.homepi.net/` | After `just deploy nginx` |

Inside Docker, Kafka UI and other compose services must bootstrap at `kafka:29092` (not published on the host). The KRaft controller listens on `29093` inside the network only.

Auto topic creation is disabled. Create topics explicitly.

## Examples

Create a topic:

```bash
docker compose --env-file kafka.env exec kafka \
  /opt/kafka/bin/kafka-topics.sh --create \
  --topic my-topic \
  --bootstrap-server localhost:9092 \
  --partitions 3 \
  --replication-factor 1
```

Produce:

```bash
docker compose --env-file kafka.env exec kafka \
  /opt/kafka/bin/kafka-console-producer.sh \
  --topic my-topic \
  --bootstrap-server localhost:9092
```

Consume:

```bash
docker compose --env-file kafka.env exec kafka \
  /opt/kafka/bin/kafka-console-consumer.sh \
  --topic my-topic \
  --bootstrap-server localhost:9092 \
  --from-beginning
```

LAN clients on other machines should use `192.168.1.100:9092` (the advertised `PLAINTEXT_HOST` listener). Using `localhost:9092` from another host will fail.

## Data

Broker logs persist in the Docker volume `kafka-data`. Removing it (`docker compose --env-file kafka.env down -v`) deletes all topics and messages.
