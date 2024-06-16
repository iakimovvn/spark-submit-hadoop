#!/bin/bash

/usr/sbin/sshd
/usr/local/bin/init.sh
su hdfs -c "kinit -k -t /opt/hadoop-3.1.2/keytabs/hdfs.keytab hdfs/resourcemanager.df.cluster@DF.CLUSTER"
su hdfs -c "hadoop fs -chmod -R 777 /"

chmod -R 777 /opt/hadoop-3.1.2/logs

mv /tmp/hive_conf/* $HIVE_HOME/conf/
su - yarn -c "$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR resourcemanager"