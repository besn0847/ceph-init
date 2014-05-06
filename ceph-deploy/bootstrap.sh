#!/bin/sh

scp init-mon.sh ceph@ceph-node1:/home/ceph
scp ceph.conf ceph@ceph-node1:/home/ceph

ssh ceph@ceph-node1 'sudo /home/ceph/init-mon.sh'

scp ceph@ceph-node1:/home/ceph/ceph.client.admin.keyring .
scp ceph.client.admin.keyring ceph@ceph-node2:/home/ceph/
scp ceph.client.admin.keyring ceph@ceph-node3:/home/ceph/

scp ceph.conf ceph@ceph-node2:/home/ceph
scp ceph.conf ceph@ceph-node3:/home/ceph

scp init-osd.sh ceph@ceph-node2:/home/ceph
scp init-osd.sh ceph@ceph-node3:/home/ceph

ssh ceph@ceph-node2 'sudo /home/ceph/init-osd.sh 0 ceph-node2'
ssh ceph@ceph-node3 'sudo /home/ceph/init-osd.sh 1 ceph-node3'
