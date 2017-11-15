FROM appcontainers/jenkins:debian

RUN  \
  export DEBIAN_FRONTEND=noninteractive && \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y vim wget curl git maven nano

RUN sudo apt-get install openjdk-8-jdk

RUN export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
RUN update-java-alternatives --set java-1.8.0-openjdk-amd64

COPY start.sh /root/start.sh
RUN chmod u+x /root/start.sh
RUN mkdir -p /var/lib/mongo/data

CMD ["sh", "/root/start.sh"]