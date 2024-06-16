FROM hadoop-base:3.1.2

#RUN mkdir -p $HADOOP_DATA_DIR/name && mkdir -p $HADOOP_DATA_DIR/edits && mkdir -p $HADOOP_DATA_DIR/data

ADD ./run.sh /usr/local/bin/run.sh
RUN chmod a+x /usr/local/bin/run.sh && dos2unix /usr/local/bin/run.sh
#CMD ["/run.sh"]