# Tutorial

## Prerequisites

* Kubernetes 1.9+, since StatefulSets are stable (GA) in 1.9.

## Installation 

### Create a namespace

```
kubectl create ns rocketmq-operator

```
### Deploy the cluster

#### 0) Create a name server cluster

Create a deployment for namesrv, and expose namesrv service with NodePort.

```
kubectl create -f deploy/00-namesrv.yaml

```

#### 1) Create the CRD with kind BrokerCluster.

```
kubectl create -f deploy/01-resources.yaml

```

#### 2) Create RBAC resources for Rocketmq Operator

```
kubectl create -f deploy/02-rbac.yaml

```

#### 3) Deploy Rocketmq Operator

```
kubectl create -f deploy/03-deploymentWithConfig.yaml

```

#### 4) Create a broker cluster

Create a cluster with 2 masters:

```
kubectl create -f deploy/04-cluster-2m.yaml

```

OR:

Create a cluster with 2 masters and 2 slaves:

```
kubectl create -f deploy/04-cluster-2m-2s.yaml

```

## Verify the cluster

Below is the command line output for a cluster with 2 masters and 2 slaves.
```
[root@k8s-master deploy]# kubectl get pods -n rocketmq-operator -owide
NAME                                READY     STATUS    RESTARTS   AGE       IP                NODE
mybrokercluster-0-0                 1/1       Running   0          38s       192.168.122.145   k8s-node4
mybrokercluster-0-1                 1/1       Running   0          33s       192.168.196.17    k8s-node5
mybrokercluster-1-0                 1/1       Running   0          38s       192.168.196.16    k8s-node5
mybrokercluster-1-1                 1/1       Running   0          34s       192.168.122.146   k8s-node4
rocketmq-namesrv-7d7df8c7d7-4t2g2   1/1       Running   2          10d       10.10.103.181     k8s-node4
rocketmq-namesrv-7d7df8c7d7-6x47m   1/1       Running   2          7d        10.10.101.98      k8s-node5
rocketmq-operator-d9dc87954-nw262   1/1       Running   0          6m        192.168.196.14    k8s-node5
[root@k8s-master deploy]# 
[root@k8s-master deploy]# kubectl exec -it mybrokercluster-0-0 -n rocketmq-operator bash
[root@mybrokercluster-0-0 bin]# cat ../conf/broker.conf
#This file was auto generated by rocketmq-operator. DO NOT EDIT.
brokerClusterName=DefaultCluster
brokerName=broker-0
brokerId=0
deleteWhen=04
fileReservedTime=48
brokerRole=SYNC_MASTER
flushDiskType=ASYNC_FLUSH
[root@mybrokercluster-0-0 bin]# exit
exit
[root@k8s-master deploy]# kubectl exec -it mybrokercluster-0-1 -n rocketmq-operator bash
[root@mybrokercluster-0-1 bin]# cat ../conf/broker.conf
#This file was auto generated by rocketmq-operator. DO NOT EDIT.
brokerClusterName=DefaultCluster
brokerName=broker-0
brokerId=1
deleteWhen=04
fileReservedTime=48
brokerRole=SLAVE
flushDiskType=ASYNC_FLUSH
[root@mybrokercluster-0-1 bin]# exit
exit
[root@k8s-master deploy]# kubectl exec -it mybrokercluster-1-0 -n rocketmq-operator bash
[root@mybrokercluster-1-0 bin]# cat ../conf/broker.conf
#This file was auto generated by rocketmq-operator. DO NOT EDIT.
brokerClusterName=DefaultCluster
brokerName=broker-1
brokerId=0
deleteWhen=04
fileReservedTime=48
brokerRole=SYNC_MASTER
flushDiskType=ASYNC_FLUSH
[root@mybrokercluster-1-0 bin]# exit
exit
[root@k8s-master deploy]# kubectl exec -it mybrokercluster-1-1 -n rocketmq-operator bash
[root@mybrokercluster-1-1 bin]# cat ../conf/broker.conf                                                                                                               
#This file was auto generated by rocketmq-operator. DO NOT EDIT.
brokerClusterName=DefaultCluster
brokerName=broker-1
brokerId=1
deleteWhen=04
fileReservedTime=48
brokerRole=SLAVE
flushDiskType=ASYNC_FLUSH
[root@mybrokercluster-1-1 bin]# ./mqadmin clusterList -n 10.10.103.181:9876 10.10.101.98:9876
OpenJDK 64-Bit Server VM warning: ignoring option PermSize=128m; support was removed in 8.0
OpenJDK 64-Bit Server VM warning: ignoring option MaxPermSize=128m; support was removed in 8.0
#Cluster Name     #Broker Name            #BID  #Addr                  #Version                #InTPS(LOAD)       #OutTPS(LOAD) #PCWait(ms) #Hour #SPACE
DefaultCluster    mybrokercluster-0-0     0     192.168.122.145:10911  V4_3_0                   0.00(0,0ms)         0.00(0,0ms)          0 426824.01 -1.0000
DefaultCluster    mybrokercluster-0-1     0     192.168.196.17:10911   V4_3_0                   0.00(0,0ms)         0.00(0,0ms)          0 426824.01 -1.0000
DefaultCluster    mybrokercluster-1-0     0     192.168.196.16:10911   V4_3_0                   0.00(0,0ms)         0.00(0,0ms)          0 426824.01 -1.0000
DefaultCluster    mybrokercluster-1-1     0     192.168.122.146:10911  V4_3_0                   0.00(0,0ms)         0.00(0,0ms)          0 426824.01 -1.0000

```

### Uninstall the RocketMQ cluster or destroy everything

```
kubectl delete -f deploy/04-cluster-2m-2s.yaml
kubectl delete -f deploy/03-deploymentWithConfig.yaml
kubectl delete -f deploy/02-rbac.yaml
kubectl delete -f deploy/01-resources.yaml
kubectl delete -f deploy/00-namesrv.yaml
kubectl delete ns rocketmq-operator
```

### Scale up/Scale down the RocketMQ broker Cluster

#### 1) For example, edit `deploy/04-cluster-2m-2s.yaml`, set `groupReplica` and `membersPerGroup` as 3, so totally the broker cluster will have 9 pods running.
```
groupReplica: 3
membersPerGroup: 3
```

#### 2) And replace the BrokerCluster resource:
```
kubectl replace -f deploy/04-cluster-2m-2s.yaml
```

#### 3) Check if the cluster scaled from 4 pods to 9 pods, and wait until it success:
```
watch kubectl -n rocketmq-operator get pods -owide
```

We can find the scaled result as following:

```
[root@k8s-master ~]# kubectl -n rocketmq-operator get pods -owide
NAME                                READY     STATUS    RESTARTS   AGE       IP                NODE
mybrokercluster-0-0                 1/1       Running   0          50m       192.168.122.145   k8s-node4
mybrokercluster-0-1                 1/1       Running   0          52m       192.168.169.203   k8s-node2
mybrokercluster-0-2                 1/1       Running   0          44m       192.168.196.41    k8s-node5
mybrokercluster-1-0                 1/1       Running   0          51m       192.168.122.146   k8s-node4
mybrokercluster-1-1                 1/1       Running   0          52m       192.168.196.2     k8s-node5
mybrokercluster-1-2                 1/1       Running   0          44m       192.168.36.179    k8s-node1
mybrokercluster-2-0                 1/1       Running   0          44m       192.168.108.37    k8s-node3
mybrokercluster-2-1                 1/1       Running   0          43m       192.168.122.147   k8s-node4
mybrokercluster-2-2                 1/1       Running   0          43m       192.168.196.51    k8s-node5
rocketmq-namesrv-5f685dbc8f-dcfg2   1/1       Running   0          6h        10.10.103.184     k8s-node2
rocketmq-namesrv-5f685dbc8f-mspjg   1/1       Running   0          6h        10.10.103.181     k8s-node4
rocketmq-operator-dcd764554-mff5c   1/1       Running   0          54m       192.168.122.144   k8s-node4
```

### Upgrade RocketMQ broker version

#### 1) For example, edit `deploy/04-cluster-2m-2s.yaml`, set `brokerImage` as from "4.3.2" to "4.9.3":
```
brokerImage: shopiz/rocketmq-broker-k8s:4.9.3

```

#### 2) And replace the BrokerCluster resource:
```
kubectl replace -f deploy/04-cluster-2m-2s.yaml
```

#### 3) Validate the new StatefulSets created by RocketMQ Operator:

```
kubectl -n rocketmq-operator get statefulset mybrokercluster-0 -o yaml
```
We can find the updated image version in `spec.template.spec.containers[0].image`.
