#!/bin/sh

cp /home/ceph/ceph.conf /etc/ceph/ceph.conf

cp /home/ceph/ceph.client.admin.keyring /etc/ceph/ceph.client.admin.keyring

echo "" >> /etc/ceph/ceph.conf		
echo "[mds]" >> /etc/ceph/ceph.conf
echo "mds data = /var/lib/ceph/mds/mds.$1" >> /etc/ceph/ceph.conf
echo "keyring = /var/lib/ceph/mds/mds.$1/mds.$1.keyring" >> /etc/ceph/ceph.conf
echo "[mds.$1]" >> /etc/ceph/ceph.conf
echo "host = $2" >> /etc/ceph/ceph.conf

mkdir -p  /var/lib/ceph/mds/mds.$1

ceph auth get-or-create mds.$1 mds 'allow ' osd 'allow *' mon 'allow rwx' > /var/lib/ceph/mds/mds.$1/mds.$1.keyring

echo "[program:ceph-mds]" > /etc/supervisor/conf.d/ceph-mds.conf

echo "command=ceph-mds -i $1" >> /etc/supervisor/conf.d/ceph-mds.conf

supervisorctl reread

supervisorctl update
