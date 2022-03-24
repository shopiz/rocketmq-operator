#!/bin/bash

cd $GOPATH/src/k8s.io/code-generator
chmod +x generate-groups.sh
bash generate-groups.sh "all" \
github.com/shopiz/rocketmq-operator/pkg/generated \
github.com/shopiz/rocketmq-operator/pkg/apis \
"rocketmq:v1alpha1"
