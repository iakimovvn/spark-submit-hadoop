#!/bin/bash

HOST=$(cat /etc/hostname)

cp -r /tmp/hadoop-$HADOOP_VERSION $HADOOP_HOME
mkdir -p $HADOOP_HOME/logs
mkdir -p $HADOOP_DATA_DIR
mkdir $HADOOP_HOME/keytabs
ln -s $HADOOP_HOME/etc/hadoop /etc/hadoop
cp /tmp/conf/* $HADOOP_CONF_DIR/

kadmin -w 123456 -q "addprinc -randkey HTTP/$HOST"
kadmin -w 123456 -q "ktadd -k $HADOOP_HOME/keytabs/hdfs.keytab HTTP/$HOST@DF.CLUSTER"
kadmin -w 123456 -q "addprinc -randkey hdfs/$HOST"
kadmin -w 123456 -q "ktadd -k $HADOOP_HOME/keytabs/hdfs.keytab hdfs/$HOST@DF.CLUSTER"
adduser hdfs
echo -e "123456\n123456\n" | passwd hdfs
chown hdfs:hdfs $HADOOP_HOME/keytabs/hdfs.keytab

kadmin -w 123456 -q "ktadd -k $HADOOP_HOME/keytabs/yarn.keytab HTTP/$HOST@DF.CLUSTER"
kadmin -w 123456 -q "addprinc -randkey yarn/$HOST"
kadmin -w 123456 -q "ktadd -k $HADOOP_HOME/keytabs/yarn.keytab yarn/$HOST@DF.CLUSTER"
adduser yarn
echo -e "123456\n123456\n" | passwd yarn
chown yarn:yarn $HADOOP_HOME/keytabs/yarn.keytab

kadmin -w 123456 -q "addprinc -randkey hive/$HOST"
kadmin -w 123456 -q "ktadd -k $HADOOP_HOME/keytabs/hive.keytab hive/$HOST@DF.CLUSTER"
adduser hive
echo -e "123456\n123456\n" | passwd hive
chown hive:hive $HADOOP_HOME/keytabs/hive.keytab

kadmin -w 123456 -q "ktadd -k $HADOOP_HOME/keytabs/spark.keytab HTTP/$HOST@DF.CLUSTER"
kadmin -w 123456 -q "addprinc -randkey spark/$HOST"
kadmin -w 123456 -q "ktadd -k $HADOOP_HOME/keytabs/spark.keytab spark/$HOST@DF.CLUSTER"
adduser spark
echo -e "123456\n123456\n" | passwd spark
chown spark:spark $HADOOP_HOME/keytabs/spark.keytab

# init users_with_groups
sshpass -p '123456' scp -o StrictHostKeyChecking=no root@krb5.df.cluster:/opt/keytabs/user_r*.keytab /opt/hadoop-3.1.2/keytabs/
sshpass -p '123456' scp -o StrictHostKeyChecking=no root@krb5.df.cluster:/opt/keytabs/tuz*.keytab /opt/hadoop-3.1.2/keytabs/

adduser user_r1
echo -e "123456\n123456\n" | passwd user_r1
groupadd r1_tech
usermod -a -G r1_tech user_r1
chown user_r1:user_r1 /opt/hadoop-3.1.2/keytabs/user_r1.keytab

adduser user_r2
echo -e "123456\n123456\n" | passwd user_r2
groupadd r2_tech
usermod -a -G r2_tech user_r2
chown user_r2:user_r2 /opt/hadoop-3.1.2/keytabs/user_r2.keytab

sshpass -p '123456' scp -o StrictHostKeyChecking=no root@krb5.df.cluster:/opt/*.keytab /opt/hadoop-3.1.2/keytabs/

adduser ivan
echo -e "123456\n123456\n" | passwd ivan
usermod -a -G g_tuz_yvn_allowed ivan
chown ivan:ivan /opt/hadoop-3.1.2/keytabs/ivan.keytab

adduser petr
echo -e "123456\n123456\n" | passwd petr
usermod -a -G g_tuz_yvn_allowed petr
chown petr:petr /opt/hadoop-3.1.2/keytabs/petr.keytab

adduser tuz_yvn
echo -e "123456\n123456\n" | passwd tuz_yvn
usermod -a -G g_tuz_yvn_allowed tuz_yvn
chown tuz_yvn:tuz_yvn /opt/hadoop-3.1.2/keytabs/tuz_yvn.keytab

keytool -genkey -noprompt -dname "CN=$HOSTNAME, OU=AA, O=AA, L=AA, S=AA, C=AA" -alias "$HOSTNAME" -keystore "keystore.jks" -storepass "12345678" -keypass "12345678"
cp $HADOOP_HOME/keytabs/hdfs.keytab /root/hadoop.keytab
cp keystore.jks /root/.keystore
echo "12345678" > /root/hadoop-http-auth-signature-secret
chmod -R 777 /root


cp $HADOOP_CONF_DIR/yarn-site.xml.template_yarn $HADOOP_CONF_DIR/yarn-site.xml;
cp $HADOOP_CONF_DIR/mapred-site.xml.template_yarn $HADOOP_CONF_DIR/mapred-site.xml