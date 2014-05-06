#!/bin/sh

# Step : Stop the 3 nodes and plumb them
docker stop ceph-node1
docker stop ceph-node2
docker stop ceph-node3

# Step : Start the ceph-deploy and plumb it
docker stop ceph-deploy

