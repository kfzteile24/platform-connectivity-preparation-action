#!/bin/bash
set -euox pipefail

export KUBECTL="kubectl --kubeconfig=${KUBECONFIG}"
alias kubectl="$KUBECTL"

export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"

# Special EKS config for Staging and live private Endpoint connectivity:
if [[ $PLATFORM_ENV == "aws.live" ]];then
  export DNS_ZONE="${PLATFORM_ID}.${TOP_ZONE_NAME}"
  export EKS_IP="$(dig +short +time=1 +tries=1 \
	  api.${DNS_ZONE} @${INBOUND_ENDPOINT_IP_A} @${INBOUND_ENDPOINT_IP_B} @${INBOUND_ENDPOINT_IP_C} \
	  | tail -1 \
	  | grep -v "connection timed out")"
  export EKS_DOMAIN="$(sed -n 's/[[:space:]]*server:[[:space:]]*https:\/\/\(.*\)[[:space:]]*/\1/p' ${KUBECONFIG})"
  export EKS_TO_HOSTS_FILE=$(sudo hostess fix -s; \
	sudo hostess del "${EKS_DOMAIN}"; \
	sudo hostess add "${EKS_DOMAIN}" "${EKS_IP}")
fi

# Check k8s connectivity:
if [[ $(kubectl cluster-info |echo $?) -ne 0 ]]; then
  echo "Unable to connect to k8s ..."
  exit 1
else
  echo "Successfully connected to k8s"
fi
