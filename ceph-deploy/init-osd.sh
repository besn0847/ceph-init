#!/bin/sh

cp /home/ceph/ceph.conf /etc/ceph/ceph.conf

cp /home/ceph/ceph.client.admin.keyring /etc/ceph/ceph.client.admin.keyring

ceph osd create

ceph-osd -i $1 --mkfs --mkkey

ceph auth add osd.$1 osd 'allow *' mon 'allow rwx' -i /var/lib/ceph/osd/ceph-$1/keyring

ceph osd crush add-bucket $2 host

ceph osd crush move $2 root=default

ceph osd crush add osd.$1 1.0 host=$2

echo "[program:ceph-osd]" > /etc/supervisor/conf.d/ceph-osd.conf

echo "command=ceph-osd -i $1" >> /etc/supervisor/conf.d/ceph-osd.conf

supervisorctl reread

supervisorctl update

#supervisorctl start ceph-osd

