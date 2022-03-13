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
DOCKERHUB_REPO=yeehawmars/rocketmq
IMAGE_NAME=${DOCKERHUB_REPO}:${ROCKETMQ_VERSION}

checkVersion $ROCKETMQ_VERSION

docker build -t $IMAGE_NAME --build-arg version=${ROCKETMQ_VERSION} .
if [ $? -eq 0 ]; then
    docker push $IMAGE_NAME
fi
