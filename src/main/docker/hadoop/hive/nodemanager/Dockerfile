FROM hadoop-base:3.1.2

RUN mkdir -p /opt/hive/conf
ENV HIVE_HOME /opt/hive
RUN mkdir -p /tmp/hive_conf
COPY ./conf/* /tmp/hive_conf/

# SPARK WORKER
ENV DAEMON_RUN=true
ENV SPARK_VERSION=3.1.1
ENV HADOOP_VERSION=3.1.2
ENV SCALA_VERSION=2.12.3
ENV SCALA_HOME=/opt/scala

ENV SPARK_HOME=/opt/spark
ENV SPARK_CONF_DIR=/etc/hadoop
ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip

ENV PATH $PATH:$SCALA_HOME/bin:$SPARK_HOME/bin

# Install Scala
RUN curl -fsL https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /tmp \
    && mv /tmp/scala-$SCALA_VERSION $SCALA_HOME

# Install spark https://archive.apache.org/dist/spark/spark-3.1.1/spark-3.1.1-bin-hadoop3.2.tgz
RUN mkdir $SPARK_HOME
RUN wget -O spark.tgz https://archive.apache.org/dist/spark/spark-3.1.1/spark-3.1.1-bin-hadoop3.2.tgz \
    && tar -xf spark.tgz -C /tmp \
    && mv /tmp/spark-3.1.1-bin-hadoop3.2/* $SPARK_HOME \
    && rm spark.tgz

ADD ./nodemanager/run.sh /usr/local/bin/run.sh
RUN chmod a+x /usr/local/bin/run.sh && dos2unix /usr/local/bin/run.sh
# CMD ["/usr/local/bin/run.sh"]