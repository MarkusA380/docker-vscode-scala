FROM debian:buster

ARG SBT_VERSION=1.3.7

# TODO: Remove if not required anymore
ENV http_proxy "http://httpproxy.munich.munichre.com:3128"
ENV https_proxy "http://httpproxy.munich.munichre.com:3128"

### Install software

RUN apt update
# Install supervisor
RUN apt install -y supervisor
# Install some utils
RUN apt install -y rpl pwgen curl
# Install git
RUN apt install -y git
# Install OpenJDK 8 (Warning: If changed, do not forget to update JAVA_HOME below)
RUN apt install -y openjdk-11-jdk

### Install SBT (added to the repository before)

# Download SBT .deb
RUN curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb
# Add SBT .deb to repository
RUN dpkg -i sbt-$SBT_VERSION.deb
# Delete SBT .deb
RUN rm sbt-$SBT_VERSION.deb
# Re-run apt update to be able to install sbt
RUN apt update

RUN apt install -y sbt

# Run sbt so it installs
RUN sbt sbtVersion

# Install OpenSSH + utils
RUN apt install -y ca-certificates socat openssh-server

### Configure OpenSSH

# Create sshd configuration directory & file
RUN mkdir /var/run/sshd
ADD sshd.conf /etc/supervisor/conf.d/sshd.conf

# Permit root login using password
RUN rpl "#PermitRootLogin prohibit-password" "PermitRootLogin yes" /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN chmod o-rwx /root/.ssh

### Configure container startup

# Add start.sh & set executable
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

# Expose SSH port
EXPOSE 22

# Add JAVA_HOME variable
RUN echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> /etc/environment

# TODO: Remove if not required anymore
RUN echo 'http_proxy="http://httpproxy.munich.munichre.com:3128"' >> /etc/environment
RUN echo 'http_proxy="http://httpproxy.munich.munichre.com:3128"' >> /etc/environment

# Run start.sh (will start supervisor and OpenSSH server respectively)
CMD /start.sh
