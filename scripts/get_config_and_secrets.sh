#!/bin/bash
set -euox pipefail

# Establish ECP VPN connectivity
echo "${VPN_PROFILE }" > KFZ_pritunl.vpn.ovpn
sudo  openvpn --config KFZ_pritunl.vpn.ovpn --daemon
sleep 10
sudo netstat -nr

# Config and secrets preparation:
mkdir -p kube-config k8s/${PLATFORM_ID}
export VAULT_ADDR="http://secrets.kfz42.de"

# Loing to Vault and pick the platform secrets file and K8s config file:
vault login -method=token token=$VAULT_GIT_TOKEN > /dev/null 2>&1
vault kv get -field=value secret/${PLATFORM_ENV}/${KUBECONFIG} > ${KUBECONFIG}
vault kv get -field=value secret/${PLATFORM_ENV}/k8s/${PLATFORM_ID}/platform-secrets.yaml >  k8s/${PLATFORM_ID}/platform-secrets.yaml

# Pick Config from Platform-code and global environment secrets from Vault:
if [[ $PLATFORM_ENV == "aws.live" ]];then
  ## get vault stage secrets
  vault kv get -field=value secret/${PLATFORM_ENV}/k8s/${PLATFORM_ID}/stage-secrets.yaml > k8s/${PLATFORM_ID}/stage-secrets.yaml
  ## get stage and platform config
  curl -Ls -o k8s/${PLATFORM_ID}/stage-config.yaml https://${GIT_TOKEN}@raw.githubusercontent.com/${PLATFORM_CODE_VALUES_DIR}/${PLATFORM_ENV}/${PLATFORM_ID}/stage-config.yaml
  curl -Ls -o k8s/${PLATFORM_ID}/platform-config.yaml https://${GIT_TOKEN}@raw.githubusercontent.com/${PLATFORM_CODE_VALUES_DIR}/${PLATFORM_ENV}/${PLATFORM_ID}/platform-config.yaml

elif [[ $PLATFORM_ENV == "aws.qa" ]];then
  ## get vault stage secrets
  vault kv get -field=value secret/${PLATFORM_ENV}/k8s/stage-secrets.yaml > k8s/${PLATFORM_ID}/stage-secrets.yaml
  ## get stage and platform config
  curl -Ls -o k8s/${PLATFORM_ID}/stage-config.yaml https://${GIT_TOKEN}@raw.githubusercontent.com/${PLATFORM_CODE_VALUES_DIR}/${PLATFORM_ENV}/stage-config.yaml
  curl -Ls -o k8s/${PLATFORM_ID}/platform-config.yaml https://${GIT_TOKEN}@raw.githubusercontent.com/${PLATFORM_CODE_VALUES_DIR}/${PLATFORM_ENV}/${PLATFORM_ID}/platform-config.yaml
fi

# List all the config and secrets files:
ls -l k8s/${PLATFORM_ID}
ls -l kube-config