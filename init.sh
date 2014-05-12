#!/bin/sh

# Step : Restore permissions
chmod 600 ceph-deploy/id_rsa && chmod 644 ceph-deploy/id_rsa.pub 

# Step : Add the br10 bridge
sudo ovs-vsctl add-br br10 

# Step : Setting up storage
mkdir -p ../Volumes/ceph/mnt/ceph-0
mkdir -p ../Volumes/ceph/mnt/ceph-1

[ -f ../Volumes/ceph/ceph-0 ] || dd if=/dev/zero of=../Volumes/ceph/ceph-0 bs=1k count=2000000
[ -f ../Volumes/ceph/ceph-1 ] || dd if=/dev/zero of=../Volumes/ceph/ceph-1 bs=1k count=2000000

/sbin/mkfs.ext4 -F ../Volumes/ceph/ceph-0
/sbin/mkfs.ext4 -F ../Volumes/ceph/ceph-1

sudo mount -o loop ../Volumes/ceph/ceph-0   ../Volumes/ceph/mnt/ceph-0
sudo mount -o loop ../Volumes/ceph/ceph-1   ../Volumes/ceph/mnt/ceph-1

# Step : set up mount point for Ceph FS drive
mkdir -p ../Volumes/ceph/mnt/ceph-ds/

# Step : Create the ceph/base image
cd ceph-base
docker build -t ceph/base .
cd ..

# Step : Create the ceph/deploy image
cd ceph-deploy
docker build -t ceph/deploy .
cd ..

# Step : Create the ceph/node image
cd ceph-node
docker build -t ceph/node .
cd ..

