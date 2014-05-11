#!/bin/sh

# Step : Bootstrap Ceph MON
scp init-mon.sh ceph@ceph-node1:/home/ceph
scp ceph.conf ceph@ceph-node1:/home/ceph

ssh ceph@ceph-node1 'sudo /home/ceph/init-mon.sh'

scp ceph@ceph-node1:/home/ceph/ceph.client.admin.keyring .
scp ceph.client.admin.keyring ceph@ceph-node2:/home/ceph/
scp ceph.client.admin.keyring ceph@ceph-node3:/home/ceph/

# Step : Bootstrap Ceph OSDs
scp ceph.conf ceph@ceph-node2:/home/ceph
scp ceph.conf ceph@ceph-node3:/home/ceph

scp init-osd.sh ceph@ceph-node2:/home/ceph
scp init-osd.sh ceph@ceph-node3:/home/ceph

ssh ceph@ceph-node2 'sudo /home/ceph/init-osd.sh 0 ceph-node2'
ssh ceph@ceph-node3 'sudo /home/ceph/init-osd.sh 1 ceph-node3'

# Step : Bootstrap Ceph MDS
scp ceph.client.admin.keyring ceph@ceph-node4:/home/ceph/

scp ceph.conf ceph@ceph-node4:/home/ceph

scp init-mds.sh ceph@ceph-node4:/home/ceph

ssh ceph@ceph-node4 'sudo /home/ceph/init-mds.sh 0 ceph-node1'

# Step : Mount CephFS drive
KEY=`grep "key = " ceph.client.admin.keyring | awk -F "key = " '{ print $2}' -`
echo "To mount the Ceph FS drive, run : "
echo "sudo mount -t ceph 10.10.0.11:6789:/ ../Volumes/ceph/mnt/ceph-ds/ -o name=admin,secret="$KEY

