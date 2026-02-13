# Build Docker Image and Push it to DockerHub

## 1. Log in to Docker via CLI

    ```bash
    docker login
    ```

## 2. Download Code for which Docker Image is to be built

### Create a Folder

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

### Make changes to file

    ```bash
    cd /home/ec2-user/demo-docker-build/retail-store-sample-app-1.2.4/src/ui/src/main/resources/templates
    sed -i 's/Secret Shop<\/span>/Secret Shop - V2 Version<\/span>/' home.html
    ```

### Build Docker Image

    ```bash
    cd /home/ec2-user/demo-docker-build/retail-store-sample-app-1.2.4/src/ui
    docker build -t retail-store-sample-ui:2.0.0 .
    ```

### Run Container with the new image 

    ```bash
    docker run --name retail-store-v2 -p 8889:8080 -d retail-store-sample-ui:2.0.0
    ```

You can access the application in the browser using the link: 
http://<EC2-Instance-Public-IP>:8889

Make sure that AWS SG allows port 8889.

### Tag and push the image to DockerHub

    ```bash
    docker tag retail-store-sample-ui:2.0.0 <dockerhub_user_name>/retail-store-sample-ui:2.0.0
    docker push <dockerhub_user_name>/retail-store-sample-ui:2.0.0
    ```

### Remove unused images and containers

    ```bash
    docker system prune 
    ```

