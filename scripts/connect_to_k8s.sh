#!/bin/bash
set -euox pipefail

# Establish ECP VPN connectivity
echo "${VPN_PROFILE}" > KFZ_pritunl.vpn.ovpn
sudo  openvpn --config KFZ_pritunl.vpn.ovpn --daemon
sleep 10
sudo netstat -nr

mkdir -p k8s/${PLATFORM_ID}/kube-config

export KUBECONFIG_FILE=k8s/${PLATFORM_ID}/kube-config/kubeconfig.conf
echo "${KUBECONFIG}" > ${KUBECONFIG_FILE}

export KUBECTL="kubectl --kubeconfig=${KUBECONFIG_FILE}"
alias kubectl="$KUBECTL"

# Check k8s connectivity:
if [[ $(kubectl cluster-info |echo $?) -ne 0 ]]; then
  echo "Unable to connect to k8s ..."
  exit 1
else
  echo "Successfully connected to k8s"
fi
