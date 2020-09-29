#!/bin/bash

cp -p /etc/apt/sources.list /etc/apt/sources.list.bak
sudo sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
apt update
apt upgrade -y
apt install openvswitch-switch -y
