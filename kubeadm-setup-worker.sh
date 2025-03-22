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

# Prompt user for the kubeadm join command (output from master script)
read -p "Enter kubeadm join command: " JOIN_CMD
sudo $JOIN_CMD
