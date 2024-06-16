#!/bin/bash

/usr/sbin/sshd
/usr/local/bin/init.sh

# yarn mapred
mkdir -p /tmp/hadoop-yarn/nm-local-dir/usercache/yarn/
mkdir -p /tmp/hadoop-yarn/container-logs
chown yarn:yarn /tmp/hadoop-yarn/nm-local-dir
chown yarn:yarn /tmp/hadoop-yarn/container-logs
chown yarn:yarn /tmp/hadoop-yarn/nm-local-dir/usercache/yarn/
chown -R yarn:yarn /opt/hadoop-3.1.2/logs

# container executor
chown root:yarn /opt/hadoop-3.1.2/etc/hadoop/container-executor.cfg
chown root:yarn /opt/hadoop-3.1.2/etc/hadoop
chown root:yarn /opt/hadoop-3.1.2/etc
chown root:yarn /opt/hadoop-3.1.2
chown root:yarn /opt/hadoop-3.1.2/logs
chown root:yarn /opt
chmod -R 555 /opt/hadoop-3.1.2
chown root:yarn /opt/hadoop-3.1.2/bin/container-executor
chmod 6050 /opt/hadoop-3.1.2/etc/hadoop/container-executor.cfg
chmod 6050 /opt/hadoop-3.1.2/bin/container-executor
chmod 666 /opt/hadoop-3.1.2/logs
chmod -R 777 /opt/hadoop-3.1.2/logs

cp /tmp/hive_conf/* $HIVE_HOME/conf/

su - yarn -c "$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR nodemanager"