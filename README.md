# docker-vscode-scala
Dockerfile for Visual Studio Code Remote Development via SSH for Scala & SBT

## Building

To build:

    docker build --tag markusa380/vscode-scala:latest --no-cache .

To push:
    
    docker push markusa380/vscode-scala:latest


## Usage

### Starting the container

To start the container, run the following command from any CLI:

    docker run -d \
        --name map-scala-ide \
        --env ROOT_PASSWORD=123456 \
        -v map-scala-ide-project:/root/project/ \
        -v map-scala-ide-extensions:/root/.vscode-server/extensions \
        -p 50022:22 \
        --restart unless-stopped \
        markusa380/vscode-scala:latest

Note:
* CMD does not support line breaks. Remove the trailing `\` and run the command as a single line
* Replace `map-scala-ide` with custom container name
* Replace `map-scala-ide-project` and `map-scala-ide-extensions` with custom volume names
* Replace `123456` with custom root password
* Replace `50022` with custom port

### Connecting Visual Studio Code to container

In Visual Studio Code, run the command `Remote-SSH: Add new SSH Host...` and enter:

    ssh root@localhost -p 50022

Then run the command `Remote-SSH: Connect to Host...`, select the created host and enter the root password configured earlier.

Note:
* Replace `localhost` with correct IP
* Replace `50022` with custom port defined during start
* Note: You might need to set the environment variables `HTTP_PROXY` and `HTTPS_PROXY` in your container

### Suggested Visual Studio Code extensions

* **[Scala (Metals)](https://marketplace.visualstudio.com/items?itemName=scalameta.metals)** - A lightweight Scala language server