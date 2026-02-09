# Use Multi-Stage Dockerfile to build and package Java Microservice (UI Service only)

## 1. Log in to Docker via CLI

    ```bash
    docker login
    ```

## 2. Download Code for which Docker Image is to be built

### Create a Folder to operate in

    ```bash
    mkdir demo-docker-build
    cd demo-docker-build
    ```

### Download the Application Source

    ```bash
    wget https://github.com/aws-containers/retail-store-sample-app/archive/refs/tags/v1.2.4.zip
    ```

### Unzip Application Source

    ```bash
    unzip v1.2.4.zip
    ```

### Build the Docker Image using the Dockerfile

Go to the folder with the Dockerfile for UI service and build the image there.

    ```bash
    cd retail-store-sample-app-1.2.4/src/ui
    docker builder prune --all
    docker build -t retail-ui:9.0.0 .
    ```

### Run the Container for UI Service

    ```bash
    docker run -d --name retail-ui -p 8080:8080 retail-ui:9.0.0
    ```

### Verify that the container is running

Check Running containers
    ```bash
    docker ps
    ```

Do a healthcheck
    ```bash
    http://<EC2-Instance-Public-Ip>:8080/actuator/health
    ```

### Cleanup

    ```bash
    docker stop retail-ui
    docker rm retail-ui
    docker rmi retail-ui:9.0.0
    ```

Alternatively, you can use docker prune.

Cleanup build cache.
    ```bash
    docker builder prune --all
    ```bash

Cleanup Docker resources (Stopped Containers, Unused networks, images and build cache)
    
    ```bash
    docker system prune
    ```bash

Cleanup Docker resources including Volumes 
    
    ```bash
    docker system prune --volumes
    ```bash
    
Note: This cleans up all resources mentioned in the prior command + unused volumes. Be careful when deleting volumes and make sure that the data is not important.

To check volumes before cleanup:

    ```bash
    docker volume ls
    docker volume inspect <volume-name>
    ```



