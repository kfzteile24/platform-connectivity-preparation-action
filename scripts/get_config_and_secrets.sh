#!/bin/bash
set -euox pipefail

# Pick Config from Platform-code
if [[ $PLATFORM_ENV == "aws.live" ]];then
  ## get stage and platform config
  curl -Ls -o k8s/${PLATFORM_ID}/stage-config.yaml https://${GIT_TOKEN}@raw.githubusercontent.com/${PLATFORM_CODE_VALUES_DIR}/${PLATFORM_ENV}/${PLATFORM_ID}/stage-config.yaml
  curl -Ls -o k8s/${PLATFORM_ID}/platform-config.yaml https://${GIT_TOKEN}@raw.githubusercontent.com/${PLATFORM_CODE_VALUES_DIR}/${PLATFORM_ENV}/${PLATFORM_ID}/platform-config.yaml

elif [[ $PLATFORM_ENV == "aws.qa" ]];then
  ## get stage and platform config
  curl -Ls -o k8s/${PLATFORM_ID}/stage-config.yaml https://${GIT_TOKEN}@raw.githubusercontent.com/${PLATFORM_CODE_VALUES_DIR}/${PLATFORM_ENV}/stage-config.yaml
  curl -Ls -o k8s/${PLATFORM_ID}/platform-config.yaml https://${GIT_TOKEN}@raw.githubusercontent.com/${PLATFORM_CODE_VALUES_DIR}/${PLATFORM_ENV}/${PLATFORM_ID}/platform-config.yaml
fi

# List all the config and secrets files:
ls -l k8s/${PLATFORM_ID}
ls -l kube-config