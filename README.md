# docker-vscode-scala
Dockerfile for Visual Studio Code Remote Development via SSH for Scala

## Building

To build:

    docker build --tag markusa380/scala-ide:latest --no-cache .

To push:
    
    docker push markusa380/scala-ide:latest

To run:

    docker run -d \
        --name map-scala-ide \
        --env ROOT_PASSWORD=123456 \
        -v map-scala-ide-project:/root/project/ \
        -v map-scala-ide-extensions:/root/.vscode-server/extensions \
        -p 50022:22 \
        --restart unless-stopped \
        markusa380/scala-ide:latest

Note:
* Replace `map-scala-ide` with custom container name
* Replace `map-scala-ide-project` and `map-scala-ide-extensions` with custom volume names
* Replace `123456` with custom root password
* Replace `50022` with custom port

To connect using SSH:

    ssh root@0.0.0.0 -p 50022

Note:
* Replace `0.0.0.0` with correct IP
* Replace `50022` with custom port defined during start
* Note: You might need to set the environment variables `HTTP_PROXY` and `HTTPS_PROXY` in your container