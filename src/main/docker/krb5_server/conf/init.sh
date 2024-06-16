#!/bin/bash

cp /tmp/krb5/krb5.conf /etc/krb5.conf
cp /tmp/krb5/kdc.conf /var/kerberos/krb5kdc/kdc.conf
cp /tmp/krb5/kadm5.acl /var/kerberos/krb5kdc/kadm5.acl
cp /tmp/krb5/httpd.conf /etc/httpd/conf/httpd.conf

kdb5_util create -s -P masterkey

kadmin.local -q "addprinc -pw 123456 root/admin@DF.CLUSTER"
kadmin.local -q "addprinc -pw 123456 root@DF.CLUSTER"

/usr/sbin/krb5kdc
/usr/sbin/kadmind
/usr/sbin/httpd

mkdir /opt/keytabs

kadmin -w 123456 -q "addprinc -randkey proxy_user"
kadmin -w 123456 -q "ktadd -k /opt/keytabs/proxy_user.keytab proxy_user@DF.CLUSTER"

kadmin -w 123456 -q "addprinc -randkey tuz_yvn"
kadmin -w 123456 -q "ktadd -k /opt/keytabs/tuz_yvn.keytab tuz_yvn@DF.CLUSTER"

kadmin -w 123456 -q "addprinc -pw 123456 user_r1@DF.CLUSTER"
kadmin -w 123456 -q "ktadd -k /opt/keytabs/user_r1.keytab user_r1@DF.CLUSTER"

kadmin -w 123456 -q "addprinc -pw 123456 user_r2@DF.CLUSTER"
kadmin -w 123456 -q "ktadd -k /opt/keytabs/user_r2.keytab user_r2@DF.CLUSTER"

kadmin -w 123456 -q "addprinc -pw 123456 ivan@DF.CLUSTER"
kadmin -w 123456 -q "ktadd -k /opt/keytabs/ivan.keytab ivan@DF.CLUSTER"

kadmin -w 123456 -q "addprinc -pw 123456 petr@DF.CLUSTER"
kadmin -w 123456 -q "ktadd -k /opt/keytabs/petr.keytab petr@DF.CLUSTER"

kadmin -w 123456 -q "addprinc -randkey om"
kadmin -w 123456 -q "ktadd -k /opt/keytabs/om.keytab om@DF.CLUSTER"
kadmin -w 123456 -q "addprinc -randkey scm"
kadmin -w 123456 -q "ktadd -k /opt/keytabs/scm.keytab scm@DF.CLUSTER"
kadmin -w 123456 -q "addprinc -randkey dn"
kadmin -w 123456 -q "ktadd -k /opt/keytabs/dn.keytab dn@DF.CLUSTER"
kadmin -w 123456 -q "addprinc -randkey recon"
kadmin -w 123456 -q "ktadd -k /opt/keytabs/recon.keytab recon@DF.CLUSTER"

groupadd g_tuz_yvn_allowed
usermod -a -G g_tuz_yvn_allowed tuz_yvn
usermod -a -G g_tuz_yvn_allowed hdfs

/usr/sbin/sshd
echo -e "123456\n123456\n" | passwd root
/usr/sbin/sshd
sleep 5
echo "Log"  > /tmp/logfile.log
tail -f /tmp/logfile.log




