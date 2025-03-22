#! /bin/bash

swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

apt update
apt full-upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
apt-get install -y kubelet kubeadm kubectl containerd docker.io

mkdir /etc/containerd
containerd config default > /etc/containerd/config.toml
sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml

systemctl restart containerd.service
systemctl restart kubelet.service
systemctl start docker.service
systemctl enable kubelet.service
systemctl enable docker.service


