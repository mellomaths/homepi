# HomePi 🏠

A comprehensive home server setup running on Raspberry Pi 5, featuring a complete stack of services for home automation, monitoring, and development.

## 🚀 Features

### Core Services
- **Pi-Hole** - DNS server that blocks ads and trackers
- **Cockpit** - Web-based system administration interface
- **Portainer** - Docker container management
- **Grafana** - Monitoring and analytics dashboard
- **Glance** - Home dashboard with service monitoring

### Database & Storage
- **PostgreSQL** - Primary database
- **Redis** - Caching and session storage
- **PGAdmin** - PostgreSQL administration interface

### APIs & Gateway
- **API Gateway** - Centralized API routing
- **Health Check API** - Service monitoring endpoints
- **Football Fan API** - Custom application API

### Infrastructure
- **Nginx** - Reverse proxy and load balancer
- **Kafka** - Message streaming platform
- **Docker** - Container orchestration
- **Docker Registry** - Private image registry on the LAN (`apps/registry`)

## 🛠️ Quick Start

### Prerequisites
- Raspberry Pi 5
- Docker and Docker Compose installed
- Just command runner (`just`)

### Connect to Your Pi

Connect to your Raspberry Pi from your local network:

```bash
just connect
# This executes ./connect.sh
```

**Note**: Update the connection details in `connect.sh` if needed:
- `URL`: Your Pi's IP address (default: 192.168.1.100)
- `USERNAME`: Your Pi username (default: homepi)

### Available Commands

The project uses [Just](https://github.com/casey/just) for task management. See all available commands:

```bash
just --list
```

#### Service Management
```bash
# Install a service
just install <service-name>

# Start a service
just start <service-name>

# Stop a service
just stop <service-name>

# Restart a service
just restart <service-name>

# Check service status
just status <service-name>

# Deploy a service
just deploy <service-name>
```

#### Network Management
```bash
# Enable remote access
just enable-remote-access

# Disable remote access
just disable-remote-access

# List WiFi networks
just wifi-list

# Connect to WiFi
just wifi-connect "SSID" "password" "connection-name"

# List network priorities
just network-priority-list

# Set network priority
just set-priority "connection-name" priority-number
```

## 📱 Dashboard Access

Once services are running, access them through the Glance dashboard at `http://192.168.1.100` or via the configured domain:

### Service URLs
- **Cockpit**: `http://cockpit.homepi.net/`
- **Pi-Hole**: `http://pihole.homepi.net/admin`
- **Portainer**: `http://portainer.homepi.net/`
- **Grafana**: `http://grafana.homepi.net/`
- **API Gateway**: `http://api.homepi.net/`
- **PGAdmin**: `http://pgadmin.homepi.net/`

## 🔧 Configuration

### Static IP Setup
The Pi is configured with a static IP address (192.168.1.100). To modify this:

1. Edit `/etc/dhcpcd.conf`:
```bash
sudo nano /etc/dhcpcd.conf
```

2. Update the interface configuration:
```bash
# For wireless connection
interface wlan0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=127.0.0.1 1.1.1.1
```

3. Restart the service:
```bash
sudo systemctl restart dhcpcd
```

### Domain Configuration
Update your router's DNS settings to point `homepi.net` to `192.168.1.100` for local domain access.

## 📁 Project Structure

```
homepi/
├── apps/                    # Individual service configurations
│   ├── api-gateway/        # API routing service
│   ├── cockpit/            # System administration
│   ├── glance/             # Home dashboard
│   ├── grafana/            # Monitoring dashboard
│   ├── kafka/              # Message streaming
│   ├── nginx/              # Reverse proxy
│   ├── pgadmin/            # PostgreSQL admin
│   ├── pihole/             # DNS ad blocker
│   ├── portainer/          # Docker management
│   ├── postgres/           # Database
│   ├── redis/              # Cache storage
│   └── registry/           # Private Docker image registry
├── connect.sh              # SSH connection script
├── Justfile                # Task definitions
└── README.md               # This file
```

## 🔒 Security Notes

- Change default passwords for all services
- Configure firewall rules as needed
- Keep the system and Docker images updated
- Use strong passwords for database access

## 📚 Documentation

Each service includes its own documentation in the respective `apps/<service>/README.md` files.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is for personal use. Please respect the licenses of individual services and components.

