#!/bin/sh

cp /home/ceph/ceph.conf /etc/ceph/ceph.conf

ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'

ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --set-uid=0 --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow'

ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring

monmaptool --create --add ceph-node1 10.10.0.11 --fsid a7f64266-0894-4f1e-a635-d0aeaca0e993 /tmp/monmap

mkdir /var/lib/ceph/mon/ceph-ceph-node1

ceph-mon --mkfs -i ceph-node1 --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring

echo "[program:ceph-mon]" > /etc/supervisor/conf.d/ceph-mon.conf

echo "command=ceph-mon -i ceph-node1" >> /etc/supervisor/conf.d/ceph-mon.conf

supervisorctl reread

supervisorctl update

#supervisorctl start ceph-mon

cp /etc/ceph/ceph.client.admin.keyring /home/ceph     

chown ceph.ceph /home/ceph/ceph.client.admin.keyring

