#!/bin/bash

docker build -t yeehawmars/rocketmq-operator:0.1.3 .
docker push yeehawmars/rocketmq-operator:0.1.3
