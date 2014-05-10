#!/bin/sh

# Step : Start the 3 nodes and plumb them
docker restart ceph-node1
sudo ./ceph-plumb.sh br10 ceph-node1 10.10.0.11/24 10.10.0.255 10

docker restart ceph-node2
sudo ./ceph-plumb.sh br10 ceph-node2 10.10.0.12/24 10.10.0.255 10

docker restart ceph-node3
sudo ./ceph-plumb.sh br10 ceph-node3 10.10.0.13/24 10.10.0.255 10

docker restart ceph-node4
sudo ./ceph-plumb.sh br10 ceph-node4 10.10.0.14/24 10.10.0.255 10

# Step : Start the ceph-deploy and plumb it
docker restart ceph-deploy
sudo ./ceph-plumb.sh br10 ceph-deploy 10.10.0.10/24 10.10.0.255 10

