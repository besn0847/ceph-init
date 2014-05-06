#!/bin/bash
set -e

BRIDGE=$1
GUESTNAME=$2
IPADDR=$3
BROADCAST=$4
#GWADDR=$5
#VLANTAG=$6
VLANTAG=$5

[ "$IPADDR" ] || {
    echo "Syntax:"
    echo "ceph-plumb.sh <hostinterface> <guest> <ipaddr>/<subnet> <broadcast> [vlan tag]"
    exit 1
}

# Step  : Find the full guestname
GUESTNAME=`docker inspect --format='{{.ID}}' $GUESTNAME`
[ "$GUESTNAME" ] || {
    echo "Could not find a running container $GUESTNAME."
    exit 1
}

# Step : Find the guest (for now, we only support LXC containers)
while read dev mnt fstype options dump fsck
do
    [ "$fstype" != "cgroup" ] && continue
    echo $options | grep -qw devices || continue
    CGROUPMNT=$mnt
done < /proc/mounts

[ "$CGROUPMNT" ] || {
    echo "Could not locate cgroup mount point."
    exit 1
}

N=$(find "$CGROUPMNT" -name "$GUESTNAME*" | wc -l)
case "$N" in
    0)
	echo "Could not find any container matching $GUESTNAME."
	exit 1
	;;
    1)
	true
	;;
    *)
	echo "Found more than one container matching $GUESTNAME."
	exit 1
	;;
esac

NSPID=$(head -n 1 $(find "$CGROUPMNT" -name "$GUESTNAME*" | head -n 1)/tasks)
[ "$NSPID" ] || {
    echo "Could not find a process inside container $GUESTNAME."
    exit 1
}

# Step : Extend /etc/hosts
[ -f conf/hosts ] && {
	cp conf/hosts /var/lib/docker/containers/$GUESTNAME/hosts
}


# Step : Prepare the working directory
mkdir -p /var/run/netns
rm -f /var/run/netns/$NSPID
ln -s /proc/$NSPID/ns/net /var/run/netns/$NSPID

# Step : Creating virtual interfaces
LOCAL_IFNAME=vethl$NSPID
GUEST_IFNAME=vethg$NSPID
ip link add name $LOCAL_IFNAME type veth peer name $GUEST_IFNAME
ip link set $LOCAL_IFNAME up

# Step : Adding the virtual interface to the bridge
ip link set $GUEST_IFNAME netns $NSPID
if [ "$VLANTAG" ]
then
	/usr/bin/ovs-vsctl add-port $BRIDGE $LOCAL_IFNAME tag=$VLANTAG
else
	/usr/bin/ovs-vsctl add-port $BRIDGE $LOCAL_IFNAME
fi

# Step : Configure netwroking within the container
ip netns exec $NSPID ip link set $GUEST_IFNAME name eth1
ip netns exec $NSPID ip addr add $IPADDR broadcast $BROADCAST dev eth1
ip netns exec $NSPID ip link set eth1 up
