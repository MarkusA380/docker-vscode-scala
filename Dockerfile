FROM debian:buster

ARG SBT_VERSION=1.3.7

### Install software

RUN apt-get update > /dev/null
# Install supervisor
RUN apt-get install -y supervisor > /dev/null
# Install some utils
RUN apt-get install -y rpl pwgen curl > /dev/null
# Install git
RUN apt-get install -y git > /dev/null
# Install OpenJDK 8 (Warning: If changed, do not forget to update JAVA_HOME below)
RUN apt-get install -y openjdk-11-jdk > /dev/null

### Install SBT (added to the repository before)

# Download SBT .deb
RUN curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb
# Add SBT .deb to repository
RUN dpkg -i sbt-$SBT_VERSION.deb
# Delete SBT .deb
RUN rm sbt-$SBT_VERSION.deb
# Re-run apt-get update to be able to install sbt
RUN apt-get update > /dev/null

RUN apt-get install -y sbt > /dev/null

# Run sbt, will run some installation
RUN sbt sbtVersion

# Install OpenSSH + utils
RUN apt-get install -y ca-certificates openssh-server > /dev/null

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

# Add JAVA_HOME to /etc/environment so SSH sessions pick it up
RUN echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> /etc/environment

# Run start.sh (will start supervisor and OpenSSH server respectively)
CMD ["/start.sh"]
