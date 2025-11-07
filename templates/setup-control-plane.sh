#!/bin/bash

sleep 10

apt-get update
apt-get -y install curl

server_ip=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)

curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --token ${k3s_token} --tls-san "$server_ip"