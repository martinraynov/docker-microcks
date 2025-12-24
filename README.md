# Microcks Application (Under Docker)

A complete Microcks mocking ecosystem running under Docker. Microcks is an open-source Kubernetes-native tool for API mocking and testing.

## Overview

This Docker Compose setup provides a fully functional Microcks environment with all required dependencies:

- **Microcks App** - Main application for API mocking and testing
- **Keycloak** - Authentication and authorization server
- **MongoDB** - Database for Microcks data storage
- **MariaDB** - Database for Keycloak
- **Postman Runtime** - Runtime environment for Postman collections

## Prerequisites

- Docker and Docker Compose installed
- Traefik v3 container running (required for routing)
- Root/sudo access for host file modifications

## Quick Start

### 1. Configure Local Hosts

Add the required localhost entries to your `/etc/hosts` file:

```bash
sudo make add_localhost
```

This adds the following entries:
- `microcks.local.io` - Main Microcks application
- `microcks-kc.local.io` - Keycloak authentication server
- `microcks-postman.local.io` - Postman runtime
- `microcks-mariadb.local.io` - MariaDB database
- `microcks-mongodb.local.io` - MongoDB database

**Manual alternative:** Add this line to `/etc/hosts`:
```
127.0.0.1 microcks.local.io microcks-kc.local.io microcks-postman.local.io microcks-mariadb.local.io microcks-mongodb.local.io
```

To remove these entries later:
```bash
sudo make remove_localhost
```

### 2. Start Services

```bash
make start
```

This will start all containers in detached mode.

### 3. Access the Application

Once started, access the services at:

- **Microcks UI**: http://microcks.local.io
- **Keycloak Admin Console**: http://microcks-kc.local.io
  - Username: `admin`
  - Password: `admin`

## Available Commands

### Main Commands

- `make start` - Start all Microcks containers
- `make stop` - Stop all running Microcks containers
- `make help` - Display all available commands

### Installation Commands

- `make install` - Install Microcks as an executable command at `/usr/local/bin/microcks`
- `make remove` - Remove the Microcks executable

### Host Configuration

- `make add_localhost` - Add required entries to `/etc/hosts` (requires sudo)
- `make remove_localhost` - Remove entries from `/etc/hosts` (requires sudo)

### CLI Access

- `make cli` - Access the Microcks CLI in an interactive container

## Service Details

### Microcks App
- **Image**: `quay.io/microcks/microcks:1.10.1`
- **Port**: 8080 (internal)
- **URL**: http://microcks.local.io
- **Database**: MongoDB
- **Configuration**: `./docker/config/application.properties`

### Keycloak
- **Image**: `quay.io/keycloak/keycloak:26.0`
- **Port**: 8080 (internal)
- **URL**: http://microcks-kc.local.io
- **Database**: MariaDB
- **Admin Credentials**: admin/admin
- **Realm**: Pre-configured with `microcks-realm-sample.json`

### MongoDB
- **Image**: `mongo:3.6.23`
- **Port**: 27017
- **Data Volume**: `./docker/data/mongodb`

### MariaDB
- **Image**: `mariadb:12.0`
- **Port**: 3306
- **Database**: `keycloak`
- **Credentials**: admin/admin
- **Data Volume**: `./docker/data/mariadb`

### Postman Runtime
- **Image**: `quay.io/microcks/microcks-postman-runtime:latest`
- **Port**: 3000 (internal)
- **Health Check**: http://localhost:3000/health

## Project Structure

```
.
├── docker/
│   ├── config/              # Application configuration files
│   ├── data/                # Persistent data volumes
│   ├── docker-compose.yml   # Docker Compose configuration
│   ├── keycloak-realm/      # Keycloak realm configuration
│   └── keycloak-theme/      # Custom Keycloak theme
├── scripts/
│   └── run.sh               # Executable script
├── Makefile                 # Make commands
└── README.md               # This file
```

## Notes

- All services are configured to work with Traefik v3 as a reverse proxy
- Services use Sablier middleware for on-demand container startup
- Health checks are configured for all services
- Data persistence is ensured through Docker volumes
- The setup uses the `lb-common` external network for Traefik integration

## Troubleshooting

- Ensure Traefik v3 is running before starting services
- Check container logs: `docker-compose -f ./docker/docker-compose.yml logs`
- Verify hosts file entries are correct
- Ensure ports 8080, 3306, and 27017 are not in use by other services

## Author

**Martin Raynov**
