FROM hadoop-base:3.1.2
ENV HADOOP_VERSION 3.1.2
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION

#RUN mkdir -p $HADOOP_DATA_DIR/name && mkdir -p $HADOOP_DATA_DIR/data

ADD ./run.sh /usr/local/bin/run.sh
ADD ./conf/* /tmp/
RUN chmod a+x /usr/local/bin/run.sh && dos2unix /usr/local/bin/run.sh
#CMD ["/run.sh"]