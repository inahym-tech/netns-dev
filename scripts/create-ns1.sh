#!/bin/bash

ip netns add host1-1
ip netns add host1-2
ip netns add host2-1
ip netns add host2-2
ovs-vsctl add-br ovs1
ovs-vsctl add-br ovs2
ip link add h11-ovs1 type veth peer name ovs1-h11
ip link add h12-ovs1 type veth peer name ovs1-h12
ip link add h21-ovs2 type veth peer name ovs2-h21
ip link add h22-ovs2 type veth peer name ovs2-h22
ip link set h11-ovs1 netns host1-1
ip link set h12-ovs1 netns host1-2
ip link set h21-ovs2 netns host2-1
ip link set h22-ovs2 netns host2-2
ovs-vsctl add-port ovs1 ovs1-h11 tag=10
ovs-vsctl add-port ovs1 ovs1-h12 tag=20
ovs-vsctl add-port ovs2 ovs2-h21 tag=10
ovs-vsctl add-port ovs2 ovs2-h22 tag=20
ip link add ovs1-ovs2 type veth peer name ovs2-ovs1
ovs-vsctl add-port ovs1 ovs1-ovs2 trunk=10,20
ovs-vsctl add-port ovs2 ovs2-ovs1 trunk=10,20
ip link set ovs1-h11 up
ip link set ovs1-h12 up
ip link set ovs2-h21 up
ip link set ovs2-h22 up
ip netns exec host1-1 ip link set h11-ovs1 up
ip netns exec host1-2 ip link set h12-ovs1 up
ip netns exec host2-1 ip link set h21-ovs2 up
ip netns exec host2-2 ip link set h22-ovs2 up
ip netns exec host2-2 ip link set lo up
ip netns exec host1-1 ip link set lo up
ip netns exec host1-2 ip link set lo up
ip netns exec host2-1 ip link set lo up
ip link set ovs1 up
ip link set ovs2 up
ip link set ovs1-ovs2 up
ip link set ovs2-ovs1 up
ip netns exec host1-1 ip addr add 192.168.100.11/24 dev h11-ovs1
ip netns exec host1-2 ip addr add 192.168.100.12/24 dev h12-ovs1
ip netns exec host2-1 ip addr add 192.168.100.21/24 dev h21-ovs2
ip netns exec host2-2 ip addr add 192.168.100.22/24 dev h22-ovs2

