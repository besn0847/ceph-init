#!/bin/sh

# Step : Stop the 3 nodes and remove them
docker stop ceph-node1 && docker rm ceph-node1
docker stop ceph-node2 && docker rm ceph-node2
docker stop ceph-node3 && docker rm ceph-node3
docker stop ceph-node4 && docker rm ceph-node4

# Step : Start the ceph-deploy and plumb it
docker stop ceph-deploy && docker rm ceph-deploy

