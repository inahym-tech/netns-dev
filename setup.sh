#!/bin/bash

sudo sed -i -e 's/\r//g' /etc/apt/sources.list
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
