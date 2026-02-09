# Create EC2 Instance and Install Docker

Create an EC2 Instance and Install Docker on it. 
This is going to be used as a build server where all the services can be run locally.

## Step-1: Create an EC2 Instance

1. Create an EC2 instance with the following Configuration:

    AMI: Amazon Linux
    Insance Type: t3.large
    Storage: 16 GB+
    Key Pair: Select or Create One using ssh-keygen
    Security Group: Allow ports 22, 443, 80, 8080
    Region: Any

## Step-2: Setup Instructions

1. Launch EC2 Instances with the above config.

2. Connect via SSH.

3. Install Docker on Amazon Linux.

    ```bash
    sudo dnf update -y
    sudo dnf install docker -y
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker ec2-user
    ```

    Logout and reconnect to apply docker group permissions.

4. Optional: Test if Docker installed correctly by running a Hello-world container.

    ```bash
    docker version

    # check for existing images
    docker images

    # use a simple image to run a container
    docker run hello-world
    docker images
    docker ps -a
    ```

5. Optional: Remove the container and image.

    ```bash
    docker rm $(docker ps -aq)
    docker rmi hello-world
    ```





