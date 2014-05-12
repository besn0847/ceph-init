Associated blog post : http://fbevmware.blogspot.fr/2014/05/software-defined-compute-network-and.html

This setup will install ceph with 1 MON, 2 OSD & 1 MDS on 1 docker.
Open vSwitch is required to plumb all the nodes together (needed for multi-docker environment - see part II of this post - not available for now).

##Pre-requisites

- Docker 0.10.0 (packages : lxc-docker)
- Open vSwitch 1.4.6 (packages : openvswitch-common, openvswitch-switch, openvswitch-datapath-dkms)
- CGroup 1.1.5 (packages : cgroup-lite)

Make sure you use Docker 0.10.0 otherwise there might be FUSE issues when installing the ceph-mds package in the images.


##Steps

1. Run the init.sh script from local directory (it takes about 5 minutes to build all containers) 
	> (host)> ./init.sh

2. Start the 5 containers (1 for deployment and 4 for Ceph set-up)
	> (host)> ./start.sh

3. Connect to the ceph-deploy container and bootstrap the environment
	> (host)> docker attach ceph-deploy

	> (ceph-deploy) > su - ceph

	> (ceph-deploy)> ./bootstrap.sh


4. Connect to ceph-node1 through exposed SSH port (check docker ps) to verify it is running (password : passw0rd) and wait until the cluster start-up is OK
	> (host)> ssh root@localhost -p <exposed port for ceph-node1>

	> (ceph-node1)> ceph -w

5. Mount the Ceph FS drive using the output of the bootstrap script (each deployment will create a different key)
	> (host)> sudo mount -t ceph 10.10.0.11:6789:/ ../Volumes/ceph/mnt/ceph-ds/ -o name=admin,secret=AQCHwHBTyKOJKBAA4gfK33sw/V9zkzlR5g9GtA==

	> (host)> df -k ../Volumes/ceph/mnt/ceph-ds/

Just make sure you give some time for the cluster to correctly boot up before mounting the drive. 

##Stop & start, clean... 
Just run ./stop.sh and ./restart.sh to stop/start all the containers. Ceph will be automatically restarted.
The clean-all.sh script will erase everything while clean-containers.sh will only remove the 5 created containers.

