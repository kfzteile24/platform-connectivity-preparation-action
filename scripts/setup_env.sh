#!/bin/bash
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update -y && sudo apt-get install -y openvpn screen python3.9-venv python3.9-dev\
&& sudo pip install boto wheel

# Install helm
curl -Ls -o helm.tar.gz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
  && tar -xvf helm.tar.gz \
  && chmod +x linux-amd64/helm \
  && sudo mv linux-amd64/helm /usr/local/bin/helm \
  && rm helm.tar.gz

# Install kubectl
curl -Ls -o kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && chmod +x kubectl \
  && sudo mv kubectl /usr/local/bin/kubectl

# Install Vault client
curl -Ls -O "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" \
&& unzip -o vault_${VAULT_VERSION}_linux_amd64.zip \
&& chmod +x vault \
&& sudo mv vault /usr/local/bin \
&& rm vault_${VAULT_VERSION}_linux_amd64.zip


