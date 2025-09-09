# Kafka with Avro Schema Registry - Production Setup

This directory contains a production-ready Docker Compose setup for Apache Kafka with Confluent Schema Registry for Avro schema management.

## Services Included

- **Zookeeper**: Coordination service for Kafka
- **Kafka**: Message broker with production configurations
- **Schema Registry**: Avro schema management and validation
- **Kafka Connect**: Framework for connecting Kafka with external systems
- **Kafka UI**: Web-based management interface

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- At least 4GB RAM available
- Ports 9092, 8080, 8081, 8083 available

### Starting the Cluster

```bash
# Make scripts executable
chmod +x start.sh stop.sh

# Start the cluster
./start.sh
```

### Stopping the Cluster

```bash
# Stop the cluster
./stop.sh

# Stop and remove all data
docker-compose down -v
```

## Configuration

### Environment Variables

Copy `kafka.env` to `.env.local` and modify as needed:

```bash
cp kafka.env .env.local
```

### Key Configuration Files

- `config/server.properties`: Kafka broker configuration
- `config/schema-registry.properties`: Schema Registry settings
- `config/connect.properties`: Kafka Connect configuration

## Service Endpoints

| Service | URL | Description |
|---------|-----|-------------|
| Kafka | `localhost:9092` | Message broker |
| Schema Registry | `http://localhost:8081` | Avro schema management |
| Kafka Connect | `http://localhost:8083` | Connect framework |
| Kafka UI | `http://localhost:8080` | Web management interface |

## Production Features

### Security
- Disabled auto-topic creation
- Proper network isolation
- Health checks for all services

### Monitoring
- JMX metrics enabled on port 9101
- Comprehensive logging configuration
- Health check endpoints

### Performance
- Optimized for single-node deployment
- Configurable retention policies
- Proper partition and replication settings

### Schema Management
- Avro schema validation
- Backward compatibility mode
- Schema evolution support

## Usage Examples

### Creating a Topic

```bash
docker-compose exec kafka kafka-topics --create \
  --topic my-topic \
  --bootstrap-server localhost:9092 \
  --partitions 3 \
  --replication-factor 1
```

### Producing Messages with Avro

```bash
# Using kafka-avro-console-producer
docker-compose exec schema-registry kafka-avro-console-producer \
  --topic my-topic \
  --bootstrap-server kafka:29092 \
  --property value.schema='{"type":"record","name":"User","fields":[{"name":"name","type":"string"}]}'
```

### Consuming Messages

```bash
# Using kafka-console-consumer
docker-compose exec kafka kafka-console-consumer \
  --topic my-topic \
  --bootstrap-server localhost:9092 \
  --from-beginning
```

## Troubleshooting

### Check Service Health

```bash
# View all service status
docker-compose ps

# Check logs
docker-compose logs -f [service-name]

# Health check specific service
docker-compose exec kafka kafka-broker-api-versions --bootstrap-server localhost:9092
```

### Common Issues

1. **Port conflicts**: Ensure ports 9092, 8080, 8081, 8083 are available
2. **Memory issues**: Increase Docker memory allocation
3. **Permission issues**: Ensure Docker has proper permissions

### Data Persistence

Data is persisted in Docker volumes:
- `kafka-data`: Kafka log data
- `zookeeper-data`: Zookeeper data
- `kafka-connect-data`: Connect state

## Monitoring and Management

### Kafka UI
Access the web interface at `http://localhost:8080` to:
- View topics and messages
- Monitor consumer groups
- Manage schemas
- View cluster health

### JMX Metrics
Kafka JMX metrics are available on port 9101 for monitoring tools like Prometheus.

## Schema Registry API

The Schema Registry provides REST APIs for schema management:

```bash
# List subjects
curl http://localhost:8081/subjects

# Get schema by ID
curl http://localhost:8081/schemas/ids/1

# Get latest schema for subject
curl http://localhost:8081/subjects/my-topic-value/versions/latest
```

## Scaling Considerations

For production scaling:
1. Increase replication factors
2. Add more Kafka brokers
3. Configure proper retention policies
4. Set up monitoring and alerting
5. Implement proper security (SASL/SSL)
