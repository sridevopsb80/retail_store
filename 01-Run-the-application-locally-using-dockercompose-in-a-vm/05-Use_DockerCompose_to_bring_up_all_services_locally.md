# Use Docker Compose to bring up all services locally

Create an EC2 Instance and Install Docker. Refer first file in this folder for instructions.

## Install Docker Compose

Create the CLI plugin directory
```bash
sudo mkdir -p /usr/local/lib/docker/cli-plugins
```

Download the latest Docker Compose v2 binary (always pulls the newest release)
```bash
wget https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -O docker-compose
```

Make it executable
```bash
chmod +x docker-compose
```

Move it to the CLI plugins directory
```bash
sudo mv docker-compose /usr/local/lib/docker/cli-plugins/docker-compose
```

Verify install
```bash
docker compose version
```

## Bring up all services using Compose Up

Create a Directory to host Docker Compose file
```bash
mkdir demo-compose
cd demo-compose
```

Download the Docker Compose file
```bash
wget https://github.com/aws-containers/retail-store-sample-app/releases/download/v1.3.0/docker-compose.yaml
```

Set environment variable
```bash
export DB_PASSWORD='mydb101'
```

Start all services in detached mode
```bash
docker compose -f <file.yaml> up -d
docker compose up -d
```
Note: If your file name is docker-compose.yaml, you don't need to specify -f with file. docker compose up command will work by default.

## Check if the application works end to end in browser

```bash
http://<EC2-Instance-Public-IP>:8888
http://<EC2-Instance-Public-IP>:8888/topology # shows topology of connected services
```

## Optional-Docker compose commands for verification

```bash
# List Services 
docker compose ps

# Verify Docker images 
docker images

# Stop a Service
docker compose stop orders

# Verify if service is stopped
docker compose ps
docker compose ps -a

# Start a Service
docker compose start orders

# Restart a Service
docker compose restart cart

# Verify if service restarted
docker compose ps

# Logs for all services
docker compose logs

# Logs for a specific service
docker compose logs checkout

# Follow logs
docker compose logs -f checkout

# Connect to a Container
docker compose exec ui sh

# Commands to run in container
ls
id
uname -m
uname -n
env
cat /etc/hostname
cat /etc/os-release 
cat /etc/os-release | sed -n '1,6p' 
curl http://localhost:8080
curl http://localhost:8080/topology
curl http://localhost:8080/actuator/health
exit
```

## Docker compose Stats

```bash
# Stats - Resource usage per container
docker compose stats

# Specific Containers
docker compose stats ui
```

## Display running processes in a container 

```bash
# Display processes inside all containers
docker compose top

# Specific containers
docker compose top ui
docker compose top checkout
```

## Make changes to UI service

```bash

# Connect to UI Container 
docker compose exec ui sh

# Verify Environment Variables in UI Container
env | grep RETAIL

# Add RETAIL_UI_THEME env variable to UI Service in docker-compose.yaml. 
# This will change the theme of UI Service from default color icon to green icon.

vi docker-compose.yaml

    environment:
      - JAVA_OPTS=-XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/urandom
      - SERVER_TOMCAT_ACCESSLOG_ENABLED=true
      - RETAIL_UI_ENDPOINTS_CATALOG=http://catalog:8080
      - RETAIL_UI_ENDPOINTS_CARTS=http://carts:8080
      - RETAIL_UI_ENDPOINTS_ORDERS=http://orders:8080
      - RETAIL_UI_ENDPOINTS_CHECKOUT=http://checkout:8080
      - RETAIL_UI_THEME=green

# Recreate UI Service
docker compose up -d --force-recreate ui
```

## Verify UI Service after change

```bash
# Connect to UI Container 
docker compose exec ui sh

# Verify Environment Variables in UI Container
env | grep RETAIL_UI_THEME

# Exit from UI Container
exit
```
You can alse check the change by reloading the URL: http://<EC2-Instance-Public-IP>:8888. 

## Bring down all services using compose down
```bash
    docker compose down
```

## Docker prune
```bash
# Prune unused Docker objects
docker system prune -a 
```