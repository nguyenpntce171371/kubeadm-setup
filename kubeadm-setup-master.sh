#!/bin/bash

set -e

# Update and install required packages
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl

# Add the Kubernetes repository
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install kubeadm, kubelet, and kubectl
sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl  # Prevent accidental upgrades

# Disable swap (Kubernetes requires swap to be off)
sudo swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Initialize the Kubernetes master node
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# Set up kubeconfig for the current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico network plugin for pod networking
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Output the join command for worker nodes
kubeadm token create --print-join-command