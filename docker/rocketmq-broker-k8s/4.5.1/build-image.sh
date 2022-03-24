#!/bin/bash

checkVersion()
{
    echo "Version = $1"
        echo $1 |grep -E "^[0-9]+\.[0-9]+\.[0-9]+" > /dev/null
    if [ $? = 0 ]; then
        return 1
    fi

        echo "Version $1 illegal, it should be X.X.X format(e.g. 4.5.0), please check released versions in 'https://dist.apache.org/repos/dist/release/rocketmq/'"
    exit 2
}

if [ $# -lt 1 ]; then
    echo -e "Usage: sh $0 Version"
    exit 2
fi

ROCKETMQ_VERSION=$1

docker build --build-arg ROCKETMQ_VERSION=${ROCKETMQ_VERSION} -t yeehawmars/rocketmq-broker-k8s:$ROCKETMQ_VERSION .
docker push yeehawmars/rocketmq-broker-k8s:$ROCKETMQ_VERSION
