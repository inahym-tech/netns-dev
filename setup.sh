#!/bin/bash

sudo sed -i -e 's/\r//g' /etc/apt/sources.list
apt update
apt upgrade -y
