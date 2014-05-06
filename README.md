This setup will install ceph with 1 MON and 2 OSD on 1 docker.
Open vSwitch is required to plum all the nodes together (needed for multi docker environment - to be done later).

Pre-requisites :
	. Docker 0.10.0 (packages : lxc-docker)
	. Open vSwitch 1.4.6 (packages : openvswitch-common, openvswitch-switch, openvswitch-datapath-dkms)
	. CGroup 1.1.5 (packages : cgroup-lite)


Steps :
    1. Run the init.sh script from local directory (it takes about 5 minutes to build all containers) 
	> ./init.sh

    2. Start the 4 containers (1 for deployment and 3 for Ceph configuration)
	> ./start.sh

    3. Connect to the ceph-deploy container and bootstrap the environment
	> docker attach ceph-deploy
		>> su - ceph
		>> ./bootstrap.sh
		>> exit

    4. Connect to ceph-node1 through exposed SSH port (check docker ps) to verify it is running
	> ssh root@localhost -p <exposed port for ceph-node1>
	> ceph -w

