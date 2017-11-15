FROM appcontainers/jenkins:debian
RUN  \
  export DEBIAN_FRONTEND=noninteractive && \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y vim wget curl git nano mongodb tar

RUN dpkg-query -W -f='${binary:Package}\n' | \
    grep -E -e '^(ia32-)?(sun|oracle)-java' -e '^openjdk-' -e '^icedtea' -e '^(default|gcj)-j(re|dk)' -e '^gcj-(.*)-j(re|dk)' -e '^java-common' | \
    xargs sudo apt-get -y remove

RUN dpkg -l | grep ^rc | awk '{print($2)}' | \
    xargs sudo apt-get -y purge


RUN apt-get purge openjdk-\* -y

RUN set -ex && \
    echo 'deb http://deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list && \
    apt-get update && \
    apt-get install -t \
      jessie-backports \
      openjdk-8-jre-headless \
      ca-certificates-java -y

WORKDIR /usr/bin
RUN wget http://www-eu.apache.org/dist/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz && \
    tar xzf apache-maven-3.5.0-bin.tar.gz && \
    ln -s apache-maven-3.5.0 apache-maven && \
    ln -s apache-maven/bin/mvn mvn

RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 && \
    export M2_HOME=/usr/local/apache-maven && \
    export MAVEN_HOME=/usr/local/apache-maven && \
    export PATH=${M2_HOME}/bin:${PATH}

RUN rm -f apache-maven-3.5.0-bin.tar.gz

WORKDIR /usr/bin

RUN sudo apt-get install openjdk-8-jdk
RUN export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
RUN update-java-alternatives --set java-1.8.0-openjdk-amd64

COPY start.sh /root/start.sh
RUN chmod u+x /root/start.sh
RUN mkdir -p /var/lib/mongo/data

CMD ["sh", "/root/start.sh"]
