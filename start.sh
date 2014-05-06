#!/bin/sh

# Step : Start the 3 nodes and plumb them
docker run -d -i -p 22 --hostname="ceph-node1" --name="ceph-node1" ceph/node
sudo ./ceph-plumb.sh br10 ceph-node1 10.10.0.11/24 10.10.0.255 10

docker run -d -i -p 22 --hostname="ceph-node2" --name="ceph-node2" -v "$PWD"/../Volumes/ceph/mnt/ceph-0:/var/lib/ceph/osd/ceph-0 ceph/node
sudo ./ceph-plumb.sh br10 ceph-node2 10.10.0.12/24 10.10.0.255 10

docker run -d -i -p 22 --hostname="ceph-node3" --name="ceph-node3" -v "$PWD"/../Volumes/ceph/mnt/ceph-1:/var/lib/ceph/osd/ceph-1 ceph/node
sudo ./ceph-plumb.sh br10 ceph-node3 10.10.0.13/24 10.10.0.255 10

# Step : Start the ceph-deploy and plumb it
docker run -d -t -i --hostname="ceph-deploy" --name="ceph-deploy" ceph/deploy 
sudo ./ceph-plumb.sh br10 ceph-deploy 10.10.0.1/24 10.10.0.255 10

