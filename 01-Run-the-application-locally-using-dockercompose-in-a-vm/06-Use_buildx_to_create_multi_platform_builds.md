# Multi-architecture build using Buildx on Amazon Linux VM

Create and push a single tag that contains AMD64 + ARM64 images for Retail Store UI microservice using Buildx + QEMU on an x86_64 (amd64) EC2 with Amazon Linux VM. Publish them to Docker Hub.

Create an EC2 Instance and Install Docker. Refer first file in this folder for instructions.

## Ensure Buildx is available

```bash
export DOCKER_BUILDKIT=1
docker buildx version
```

## Install binfmt/QEMU emulators for cross-arch builds
binfmt allows Linux to run binaries made for other CPU architectures by automatically using a translator like QEMU.

```bash
# Reinstall QEMU binfmt handlers

docker run --privileged --rm tonistiigi/binfmt --install all

# Or explicitly install arm64 + amd64
docker run --privileged --rm tonistiigi/binfmt --install arm64,amd64
```
Registers binfmt handlers.
Enables running/building multi-arch images.

## Create a containerized Buildx builder (multi-arch)

```bash
# Create a new multiarch builder that uses BuildKit in a container
docker buildx create --name multiarch --driver docker-container --use

# Expected Output: 

# docker buildx ls
# NAME/NODE    DRIVER/ENDPOINT             STATUS   BUILDKIT PLATFORMS
# multiarch *  docker-container
# multiarch0 unix:///var/run/docker.sock inactive
# default      docker
# default    default                     running  v0.12.5  linux/amd64, linux/amd64/v2, linux/amd64/v3, linux/amd64/v4, linux/386

# Bootstrap to detect all supported platforms
docker buildx inspect --bootstrap

# List Buildx Builders
docker buildx ls
```

## Login to Dockerhub

```bash
# ---- CONFIG  ----
export DOCKERHUB_USER="srikvp"     # use your username
export DH_REPO="retail-ui-multiarch" 
export TAG="1.0.0"       

# confirm Image info
export IMAGE="${DOCKERHUB_USER}/${DH_REPO}:${TAG}"
echo $IMAGE

# Login to Docker Hub (will prompt for password or PAT)
docker login -u "${DOCKERHUB_USER}"
```

## Use Dockerfile for UI service

```bash
# Create a Folder
mkdir demo-multiarch
cd demo-multiarch

# Download the Application Source
wget https://github.com/aws-containers/retail-store-sample-app/archive/refs/tags/v1.3.0.zip

# Unzip Application Source
unzip v1.3.0.zip

# Change Directory to UI Source folder
cd retail-store-sample-app-1.3.0/src/ui
cat Dockerfile
```

## Build and push multi-platform images (AMD64 & ARM64)

```bash
DOCKER_BUILDKIT=1 docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t "${IMAGE}" \
  --push .
```

## Verify the built manifest

```bash
# Look for entries for linux/amd64 and linux/arm64
docker buildx imagetools inspect "${IMAGE}"
```

## Run and test the containers in AMD64 and ARM64 VMs

Run AMD64 image
```bash
# List Docker Containers
docker ps

# Run Docker Container using new Docker Image 
docker run --name retail-amd64 -p 8888:8080 -d ${IMAGE}

# List Docker Images
docker images

# List Docker Containers
docker ps

# Verify Container info
docker exec retail-amd64 uname -m

# Access in browser
http://<EC2-Public-IP>:8888
```

# Run ARM64 image

Create a VM with Amazon Linux ARM64 platform (Ex: t4g instance).

```bash

# Check machine info
cat /etc/os-release | sed -n '1,6p'     # Amazon Linux 
uname -m                                # expect: aarch64

# Install Docker - Refer File 1.

# Run and test ARM64 based container

docker run --name retail-arm64 -p 8889:8080 -d ${IMAGE}

# List Docker Images
docker images

# List Docker Containers
docker ps

# Access in browser
http://<EC2-Public-IP>:8889
```