#!/bin/bash

docker build -t yeehawmars/rocketmq-broker-k8s:4.9.3 .
docker push yeehawmars/rocketmq-broker-k8s:4.9.3
