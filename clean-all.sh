#!/bin/sh

# Step : Stop the 3 nodes and remove them
docker stop ceph-node1 && docker rm ceph-node1
docker stop ceph-node2 && docker rm ceph-node2
docker stop ceph-node3 && docker rm ceph-node3
docker stop ceph-node4 && docker rm ceph-node4

# Step : Start the ceph-deploy and plumb it
docker stop ceph-deploy && docker rm ceph-deploy

# Step : Remove images
docker rmi ceph/node
docker rmi ceph/deploy
docker rmi ceph/base

# Remove local connection to br10
sudo ip link del dev veth1
sudo ip link del dev veth0

# Step : suppress bridge
sudo ovs-vsctl del-br br10

# Step : remove Ceph storage
sudo umount ../Volumes/ceph/mnt/ceph-0
sudo umount ../Volumes/ceph/mnt/ceph-1

rm -rf ../Volumes/ceph/*
