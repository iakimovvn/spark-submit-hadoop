FROM core:0.1

ENV HADOOP_VERSION 3.1.2
ENV HADOOP_URL https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN echo "JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")" | tee -a /etc/profile && source /etc/profile && echo $JAVA_HOME
ENV JAVA_HOME=/etc/alternatives/jre/
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV HADOOP_DATA_DIR=$HADOOP_HOME/data
ENV MULTIHOMED_NETWORK=1
ENV HADOOP_ROOT_LOGGER=INFO,console
ENV USER=root
ENV PATH $HADOOP_HOME/bin/:$PATH
ENV YARN_HOME=$HADOOP_HOME

#RUN set -x \
#    && curl -Ok https://dist.apache.org/repos/dist/release/hadoop/common/KEYS \
#    && gpg --import KEYS \
#    && curl -fkSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
#    && curl -fkSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
#    && gpg --verify /tmp/hadoop.tar.gz.asc \
#    && tar -xvf /tmp/hadoop.tar.gz -C /tmp/ \
#    && rm /tmp/hadoop.tar.gz*

#COPY ./hadoop-$HADOOP_VERSION.tar.gz /tmp/hadoop.tar.gz
RUN wget --no-check-certificate -O /tmp/hadoop.tar.gz $HADOOP_URL

RUN tar -xvf /tmp/hadoop.tar.gz -C /tmp/ \
    && rm /tmp/hadoop.tar.gz*

RUN  mkdir -p /tmp/conf
COPY ./conf/* /tmp/conf/
RUN dos2unix /tmp/conf/*

COPY ./entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh && dos2unix /usr/local/bin/entrypoint.sh
COPY ./init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh && dos2unix /usr/local/bin/init.sh
ENTRYPOINT ["entrypoint.sh"]