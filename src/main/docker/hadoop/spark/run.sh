#!/bin/bash

/usr/sbin/sshd
/usr/local/bin/init.sh

chmod +x /etc/hadoop/spark-env.sh
/etc/hadoop/spark-env.sh

LOCK_FILE='/tmp/lock'
if [ -f "$LOCK_FILE" ]; then
  echo "Skip initialisation."
else
  echo "Init database and hadoop dirs"
  echo "kinit hdfs/spark-submit.df.cluster@DF.CLUSTER"

  su hdfs -c "kinit -k -t /opt/hadoop-3.1.2/keytabs/hdfs.keytab hdfs/spark-submit.df.cluster@DF.CLUSTER";

  echo "Creation HDFS dirs"
  su hdfs -c "hadoop fs -mkdir /data";
  su hdfs -c "hadoop fs -mkdir /user";
  su hdfs -c "hadoop fs -mkdir /user/hdfs";
  su hdfs -c "hadoop fs -mkdir /user/hive";
  su hdfs -c "hadoop fs -mkdir /user/hive/warehouse";
  su hdfs -c "hadoop fs -mkdir /user/spark";
  su hdfs -c "hadoop fs -mkdir /user/hive/warehouse/dev_lab_yvn.db";
  su hdfs -c "hadoop fs -chmod -R 777 /user/hive/warehouse";

  su hdfs -c "hadoop fs -chown spark:spark /user/spark";

  su hdfs -c "hadoop fs -mkdir /user/tuz_yvn";

  echo "Copy dict csv to HDFS"

  su hdfs -c "hadoop fs -chown -R tuz_yvn:tuz_yvn /user/tuz_yvn";

  su hdfs -c "hadoop fs -chmod -R 777 /tmp";
  su hdfs -c "hadoop fs -chmod -R 666 /data";

  su hdfs -c "hadoop fs -mkdir /tmp/warehouse";
  su hdfs -c "hadoop fs -chmod -R 777 /tmp/warehouse";

  echo "Create HIVE DATABASE dev_lab_yvn"
  su hdfs -c "beeline -u 'jdbc:hive2://hive-server.df.cluster:10000/;principal=hive/_HOST@DF.CLUSTER' -e 'CREATE DATABASE dev_lab_yvn;'";

  touch "$LOCK_FILE"
fi
chmod +x /opt/yvn/*.sh
chmod 666 /opt/hadoop-3.1.2/keytabs/*

echo "success" > /tmp/success.log
tail -f /tmp/success.log