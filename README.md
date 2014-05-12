This setup will install ceph with 1 MON and 2 OSD on 1 docker.
Open vSwitch is required to plum all the nodes together (needed for multi docker environment - to be done later).

Pre-requisites :

. Docker 0.10.0 (packages : lxc-docker)
. Open vSwitch 1.4.6 (packages : openvswitch-common, openvswitch-switch, openvswitch-datapath-dkms)
. CGroup 1.1.5 (packages : cgroup-lite)


Steps :

0. Reset correct permissions (issue with Github to be sorted)
	> chmod 600 ceph-deploy/id_rsa && chmod 644 ceph-deploy/id_rsa.pub 


1. Run the init.sh script from local directory (it takes about 5 minutes to build all containers) 
	> ./init.sh

2. Start the 4 containers (1 for deployment and 3 for Ceph configuration)
	> ./start.sh

3. Connect to the ceph-deploy container and bootstrap the environment
	> docker attach ceph-deploy
		>> su - ceph
		>> ./bootstrap.sh
		>> exit
		>> exit

4. Connect to ceph-node1 through exposed SSH port (check docker ps) to verify it is running (password : passw0rd) and wait until the cluster start-up is OK
	> ssh root@localhost -p <exposed port for ceph-node1>
	> ceph -w

5. Mount the Ceph FS drive using the output of the bootstrap script (each deployment will create a different key)
	> sudo mount -t ceph 10.10.0.11:6789:/ ../Volumes/ceph/mnt/ceph-ds/ -o name=admin,secret=AQCHwHBTyKOJKBAA4gfK33sw/V9zkzlR5g9GtA==
	> df -k ../Volumes/ceph/mnt/ceph-ds/


Stop & start, clean... :
------------------------
Just run ./stop.sh and ./restart.sh to stop/start all the containers. Ceph will be automatically restarted.
The clean-all.sh script will erase everything while clean-containers.sh will only remove the 4 created containers.

