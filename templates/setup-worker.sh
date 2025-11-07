#!/bin/bash

sleep 10

apt-get update 
apt-get -y install curl

until curl -k --output /dev/null --silent --head --fail "https://${control_plane_ip}:6443/ping"; do
  echo "Control Plane not ready. Retrying in 5 seconds..."
  sleep 5
done

curl -sfL https://get.k3s.io | K3S_TOKEN="${k3s_token}" K3S_URL="https://${control_plane_ip}:6443" sh -
