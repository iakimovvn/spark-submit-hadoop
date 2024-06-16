#!/bin/bash

build_test_containers() {
  echo "build krb5 container"
  docker-compose -f docker-vm.yml build krb5 && \
    echo "build core container" && \
    docker-compose -f docker-vm.yml build core && \
    echo "build hadoop-base container"  &&  \
    docker-compose -f docker-vm.yml build hadoop-base &&  \
    echo "build HDFS containers"  &&  \
    docker-compose -f docker-vm.yml build hadoop-namenode hadoop-datanode &&  \
    echo "build HIVE containers"  &&  \
    docker-compose -f docker-vm.yml build hadoop-hive &&  \
    echo "build YARN containers"  &&  \
    docker-compose -f docker-vm.yml build hadoop-nodemanager hadoop-resourcemanager hadoop-historyserver &&  \
    echo "build SPARK container"  &&  \
    docker-compose -f docker-vm.yml build spark-submit

  if [ $? -ne 0 ]; then
    TEST_CONTAINERS_BUILT_SUCCESSFULLY=1
    echo "error build test containers"
  fi
}

launch_test_containers() {
  echo "Start HADOOP 3.1.2 cluster"

  echo "Starting KRB5-SERVER"
  docker-compose -f docker-compose.yml up -d krb5-server
  sleep 10
  docker-compose logs hdfs-dn | tail -n20

  echo "Starting HDFS NAME_NODE"
  docker-compose -f docker-compose.yml up -d hdfs-nn
  sleep 10
  docker-compose logs hdfs-nn | tail -n20

  echo "Starting HDFS DATA_NODE"
  docker-compose -f docker-compose.yml up -d hdfs-dn
  sleep 10
  docker-compose logs hdfs-dn | tail -n20

  echo "Starting HIVE METASTORE DB"
  docker-compose -f docker-compose.yml up -d hive-metastore-db
  sleep 10
  docker-compose logs hive-metastore-db | tail -n20

  echo "Starting HIVE METASTORE "
  docker-compose -f docker-compose.yml up -d hive-metastore
  sleep 10
  docker-compose logs hive-metastore | tail -n20

  echo "Starting YARN RESOURCE MANAGER"
  docker-compose -f docker-compose.yml up -d resourcemanager
  sleep 10
  docker-compose logs resourcemanager | tail -n20

  echo "Starting YARN NODE MANAGER"
  docker-compose -f docker-compose.yml up -d nodemanager
  sleep 10
  docker-compose logs nodemanager | tail -n20

  echo "Starting YARN TIMELINE HISTORY SERVER"
  docker-compose -f docker-compose.yml up -d historyserver
  sleep 10
  docker-compose logs historyserver | tail -n20

  echo "Starting HIVE server" # HIVE METASTORE MUST BE STARTED
  docker-compose -f docker-compose.yml up -d hive-server
  sleep 10
  docker-compose logs hive-server | tail -n20

  echo "Starting SPARK"
  docker-compose -f docker-compose.yml up -d spark-submit
  sleep 10
  docker-compose logs spark-submit | tail -n20

  echo "All components are started."
}

export TEST_CONTAINERS_BUILT_SUCCESSFULLY=0

build_test_containers

if [ $TEST_CONTAINERS_BUILT_SUCCESSFULLY -eq 0 ]; then
  launch_test_containers
fi