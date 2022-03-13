#!/bin/bash

./brokerGenConfig.sh
./mqbroker -n $NAMESRV_ADDRESS -c $ROCKETMQ_HOME/conf/broker.conf
