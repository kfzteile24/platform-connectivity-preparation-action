#!/bin/bash
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update -y && sudo apt-get install -y openvpn screen python3.6-venv python3.6-dev\
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
ls -la
curl -Ls -O "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" \
&& unzip -o vault_${VAULT_VERSION}_linux_amd64.zip \
&& chmod +x vault \
&& sudo mv vault /usr/local/bin \
&& rm vault_${VAULT_VERSION}_linux_amd64.zip

# Install aws-iam-authenticator
curl -Ls -o aws-iam-authenticator "https://amazon-eks.s3-us-west-2.amazonaws.com/${AWS_IAM_AUTH_VERSION}/2021-01-05/bin/linux/amd64/aws-iam-authenticator"
chmod +x aws-iam-authenticator
sudo mv aws-iam-authenticator /usr/local/bin

# Install Hostess
curl -Ls -o  hostess "https://github.com/cbednarski/hostess/releases/download/v${HOSTESS_VERSION}/hostess_linux_amd64"
chmod +x hostess
sudo mv hostess /usr/local/bin/
