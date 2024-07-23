#vim .bashrc
#export PATH=$PATH:/usr/local/bin/
#source .bashrc


#! /bin/bash

# AWS configuration (make sure AWS CLI is installed and configured)
aws configure

# Download kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Download kops
wget https://github.com/kubernetes/kops/releases/download/v1.25.0/kops-linux-amd64

# Make kubectl and kops executable
chmod +x kubectl kops-linux-amd64

# Move kubectl and kops to /usr/local/bin
sudo mv kubectl /usr/local/bin/kubectl
sudo mv kops-linux-amd64 /usr/local/bin/kops

# Create S3 bucket for kops state store
aws s3api create-bucket --bucket my-k8s-cluster-state-store --region us-east-1

# Enable versioning on the S3 bucket
aws s3api put-bucket-versioning --bucket my-k8s-cluster-state-store --region us-east-1 --versioning-configuration Status=Enabled

# Export KOPS_STATE_STORE environment variable
export KOPS_STATE_STORE=s3://my-k8s-cluster-state-store

# Create a Kubernetes cluster using kops
kops create cluster --name my-k8s-cluster.k8s.local --zones us-east-1a --master-count=1 --master-size t2.medium --node-count=2 --node-size t2.medium

# Update the cluster and apply changes
kops update cluster --name my-k8s-cluster.k8s.local --yes --admin


