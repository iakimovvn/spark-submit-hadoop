FROM centos:7
USER root

RUN yum install -y dos2unix less telnet net-tools bind-utils java-1.8.0-openjdk java-1.8.0-openjdk-devel nc \
    which unzip krb5-workstation git maven wget netcat tar openssh-server python3 sshpass python3.x86_64-python-pip \
    && yum clean all \
    && rm -rf /var/cache/yum

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install jinja-cli
# https://github.com/kolypto/j2cli
RUN ln -fs /usr/bin/python3.6 /usr/bin/python \
    && curl -k https://bootstrap.pypa.io/pip/3.6/get-pip.py -o get-pip.py \
    && python get-pip.py --trusted-host pypi.org --trusted-host files.pythonhosted.org \
    && pip3 --trusted-host pypi.org --trusted-host files.pythonhosted.org install j2cli[yaml];


# Install parquet-tools
RUN mkdir /opt/pt &&  \
    wget --no-check-certificate https://repo1.maven.org/maven2/org/apache/parquet/parquet-tools/1.9.0/parquet-tools-1.9.0.jar -O /opt/pt/parquet-tools.jar;


COPY ./yq_linux_amd64.tar.gz /tmp
RUN cd /tmp \
    && tar -xzf yq_linux_amd64.tar.gz ./yq_linux_amd64 \
    && mv yq_linux_amd64 /usr/bin/yq \
    && rm -rf /tmp/yq_linux_amd64.tar.gz

COPY ./conf/jattach /usr/local/bin/jattach
RUN  chmod +x /usr/local/bin/jattach
# Install Krb5 && sshd
COPY ./conf/krb5.conf /etc/
RUN cd /etc/ssh \
    && ssh-keygen -A \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Add users
RUN echo -e "123456\n123456\n" | passwd root \
    && echo "echo '123456' | kinit" >> ~/.bashrc \
    && ssh-keygen -f "/root/.ssh/id_rsa" -q -P "" \
    && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys \
    && chmod 600 ~/.ssh/*

COPY ./wait-for-it.sh /usr/bin
RUN chmod +x /usr/bin/wait-for-it.sh && dos2unix /usr/bin/wait-for-it.sh