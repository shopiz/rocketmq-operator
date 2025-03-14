#!/bin/bash

BROKER_CONFIG_FILE="/opt/rocketmq-$ROCKETMQ_VERSION/conf/broker.conf"
echo $BROKER_CONFIG_FILE

BROKER_ID=$(cat /etc/hostname | grep -o '[^-]*$')

BROKER_ROLE="SLAVE"

ACL_ENABLE=${ACL_ENABLE:-false}
DELAY_LEVEL=${DELAY_LEVEL:-6s 3s 3s 5s 5s 10s 10s 30s 30s 1m 2m 5m 10m 30m 1h 2h 4h 8h}

if [ $BROKER_ID = 0 ];then
    if [ $REPLICATION_MODE = "SYNC" ];then
      BROKER_ROLE="SYNC_MASTER"
    else
      BROKER_ROLE="ASYNC_MASTER"
    fi
fi

function create_config() {
    rm -f $BROKER_CONFIG_FILE
    echo "Creating broker configuration."
    echo "#This file was auto generated by rocketmq-operator. DO NOT EDIT." >> $BROKER_CONFIG_FILE
    echo "brokerClusterName=DefaultCluster" >> $BROKER_CONFIG_FILE
    echo "brokerName=$BROKER_NAME" >> $BROKER_CONFIG_FILE
    echo "brokerId=$BROKER_ID" >> $BROKER_CONFIG_FILE
    echo "deleteWhen=$DELETE_WHEN" >> $BROKER_CONFIG_FILE
    echo "fileReservedTime=$FILE_RESERVED_TIME" >> $BROKER_CONFIG_FILE
    echo "brokerRole=$BROKER_ROLE" >> $BROKER_CONFIG_FILE
    echo "flushDiskType=$FLUSH_DISK_TYPE" >> $BROKER_CONFIG_FILE
    echo "aclEnable=$ACL_ENABLE" >> $BROKER_CONFIG_FILE
    echo "messageDelayLevel=$DELAY_LEVEL" >> $BROKER_CONFIG_FILE
    echo "Wrote broker configuration file to $BROKER_CONFIG_FILE"
}


create_config
