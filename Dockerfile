# This Dockerfile has two required ARGs to determine which base image
# to use for the JDK and which sbt version to install.

ARG OPENJDK_TAG=8u232
FROM openjdk:${OPENJDK_TAG}

ARG SBT_VERSION=1.3.7

ENV http_proxy "http://httpproxy.munich.munichre.com:3128"
ENV https_proxy "http://httpproxy.munich.munichre.com:3128"

RUN curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb
RUN dpkg -i sbt-$SBT_VERSION.deb
RUN rm sbt-$SBT_VERSION.deb
RUN apt-get update
RUN apt-get install sbt

RUN apt-get -y install sbt ca-certificates socat openssh-server supervisor rpl pwgen

RUN mkdir /var/run/sshd
ADD sshd.conf /etc/supervisor/conf.d/sshd.conf

# Permit root login using password
RUN rpl "#PermitRootLogin prohibit-password" "PermitRootLogin yes" /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN chmod o-rwx /root/.ssh

EXPOSE 22

# Called on first run of docker - will run supervisor
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD /start.sh
