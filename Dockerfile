FROM ubuntu

ENV 
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y wget openjdk-7-jre-headless
RUN mkdir -p /opt/kafka
RUN wget -q -O /opt/kafka/0.8.1.tgz http://mirror.ventraip.net.au/apache/kafka/0.8.1/kafka_2.9.2-0.8.1.tgz
RUN wget -q -O /opt/kafka/KEYS http://www.us.apache.org/dist/kafka/KEYS
RUN wget -q -O /opt/kafka/0.8.1.tgz.asc http://www.us.apache.org/dist/kafka/0.8.1/kafka_2.9.2-0.8.1.tgz.asc
RUN gpg --import /opt/kafka/KEYS
RUN gpg --verify /opt/kafka/0.8.1.tgz.asc
RUN tar -xzf /opt/kafka/0.8.1.tgz -C /opt/kafka/
ADD config /opt/kafka/config
ADD env_template.py /opt/kafka/
RUN python env_template.py /opt/kafka/config

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

USER daemon

EXPOSE 2181 2888 3888

ENTRYPOINT ["/opt/kafka/kafka_2.9.2-0.8.1/bin/kafka-server-start.sh"]
CMD ["/opt/kafka/config/server.properties"]

