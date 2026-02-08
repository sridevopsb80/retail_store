# Run Docker Container with Retail Store Image


1. Pull Retail store Docker image and run it as a container

    ```bash
    docker pull ghcr.io/stacksimplify/retail-store-sample-ui:1.0.0
    docker run --name retail-store -p 8888:80 -d ghcr.io/stacksimplify/retail-store-sample-ui:1.0.0
    ```

2. Connect to Docker Terminal

    ```bash
    docker exec -it retail-store /bin/sh
    ```

3. Check Basic OS Info

    ```bash
    uname -a                    # Kernel version and system details
    cat /etc/os-release         # Check base OS details
    whoami                      # See current user (usually 'root')
    ```

4. Check Java Runtime

    ```bash
    java --version
    ```

5. Test application from inside Container

    ```bash
    curl http://localhost:8080
    ```

6. Exit Container Shell

    ```bash
    exit
    ```
