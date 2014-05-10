#!/bin/sh

# Step : Start the 4 nodes and plumb them
#	node 1 -> Ceph MON
#	node 2 -> Ceph OSD
#	node 3 -> Ceph OSD
#	node 4 -> Ceph MDS
docker run -d -i -p 22 --hostname="ceph-node1" --name="ceph-node1" ceph/node
sudo ./ceph-plumb.sh br10 ceph-node1 10.10.0.11/24 10.10.0.255 10

docker run -d -i -p 22 --hostname="ceph-node2" --name="ceph-node2" -v "$PWD"/../Volumes/ceph/mnt/ceph-0:/var/lib/ceph/osd/ceph-0 ceph/node
sudo ./ceph-plumb.sh br10 ceph-node2 10.10.0.12/24 10.10.0.255 10

docker run -d -i -p 22 --hostname="ceph-node3" --name="ceph-node3" -v "$PWD"/../Volumes/ceph/mnt/ceph-1:/var/lib/ceph/osd/ceph-1 ceph/node
sudo ./ceph-plumb.sh br10 ceph-node3 10.10.0.13/24 10.10.0.255 10

docker run -d -i -p 22 --hostname="ceph-node4" --name="ceph-node4" ceph/node
sudo ./ceph-plumb.sh br10 ceph-node4 10.10.0.14/24 10.10.0.255 10

# Step : Start the ceph-deploy and plumb it
docker run -d -t -i --hostname="ceph-deploy" --name="ceph-deploy" ceph/deploy 
sudo ./ceph-plumb.sh br10 ceph-deploy 10.10.0.10/24 10.10.0.255 10

# Add a local interface to communicate with VLAN 10
sudo ip link add name veth0 type veth peer name veth1
sudo ip link set veth0 up
sudo ovs-vsctl add-port br10 veth0 tag=10
sudo ip addr add 10.10.0.1 broadcast 10.10.0.255 dev veth1
sudo ip link set veth1 up
sudo route add -net 10.10.0.0/24 dev veth1
