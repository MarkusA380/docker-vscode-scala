# docker-vscode-scala
Dockerfile for Visual Studio Code Remote Development via SSH for Scala

## Building

To build:

    docker build --tag markusa380/scala-ide:latest .

To push:
    
    docker push markusa380/scala-ide:latest

To run locally:

    docker run -d --name map-scala-ide -v map-scala-ide-project:/root/project/ -p 50022:22 --rm markusa380/scala-ide:latest