#!/bin/bash

if [[ $(id -u) -ne 0 ]] ; then
    echo "Please run with sudo"
    exit 1
fi

run () {
    echo "$@"
    "$@" || exit 1
}

run ip netns add host1-1
run ip netns add host1-2
run ip netns add host2-1
run ip netns add host2-2
run ovs-vsctl add-br ovs1
run ovs-vsctl add-br ovs2

run ip link add h11-ovs1 type veth peer name ovs1-h11
run ip link add h12-ovs1 type veth peer name ovs1-h12
run ip link add h21-ovs2 type veth peer name ovs2-h21
run ip link add h22-ovs2 type veth peer name ovs2-h22
run ip link add ovs1-ovs2 type veth peer name ovs2-ovs1

run ip link set h11-ovs1 netns host1-1
run ip link set h12-ovs1 netns host1-2
run ip link set h21-ovs2 netns host2-1
run ip link set h22-ovs2 netns host2-2
run ip link set ovs1-h11 up
run ip link set ovs1-h12 up
run ip link set ovs2-h21 up
run ip link set ovs2-h22 up

run ovs-vsctl add-port ovs1 ovs1-h11 tag=10
run ovs-vsctl add-port ovs1 ovs1-h12 tag=20
run ovs-vsctl add-port ovs2 ovs2-h21 tag=10
run ovs-vsctl add-port ovs2 ovs2-h22 tag=20
run ovs-vsctl add-port ovs1 ovs1-ovs2 trunk=10,20
run ovs-vsctl add-port ovs2 ovs2-ovs1 trunk=10,20

run ip netns exec host1-1 ip link set h11-ovs1 up
run ip netns exec host1-2 ip link set h12-ovs1 up
run ip netns exec host2-1 ip link set h21-ovs2 up
run ip netns exec host2-2 ip link set h22-ovs2 up
run ip netns exec host2-2 ip link set lo up
run ip netns exec host1-1 ip link set lo up
run ip netns exec host1-2 ip link set lo up
run ip netns exec host2-1 ip link set lo up
run ip link set ovs1 up
run ip link set ovs2 up
run ip link set ovs1-ovs2 up
run ip link set ovs2-ovs1 up

run ip netns exec host1-1 ip addr add 192.168.100.11/24 dev h11-ovs1
run ip netns exec host1-2 ip addr add 192.168.100.12/24 dev h12-ovs1
run ip netns exec host2-1 ip addr add 192.168.100.21/24 dev h21-ovs2
run ip netns exec host2-2 ip addr add 192.168.100.22/24 dev h22-ovs2

destroy_network () {
    run ip -all netns del
    run ovs-vsctl del-br ovs1
    run ovs-vsctl del-br ovs2
}

stop () {
    destroy_network
}

trap stop 0 1 2 3 13 14 15

status=0; $SHELL || status=$?
exit $status

