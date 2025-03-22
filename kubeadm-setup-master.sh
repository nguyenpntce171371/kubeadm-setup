#! /bin/bash

swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
apt update
apt full-upgrade -y

#---------------------

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

#---------------------

modprobe overlay
modprobe br_netfilter

#--------------------------

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

#--------------------

sysctl --system

#-----------

sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
apt-get install -y kubelet kubeadm kubectl containerd docker.io
apt-mark hold kubelet kubeadm kubectl docker.io
mkdir /etc/containerd
containerd config default > /etc/containerd/config.toml
sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml

#-----------

systemctl restart containerd.service
systemctl restart kubelet.service
systemctl start docker.service
systemctl enable kubelet.service
systemctl enable docker.service

#----------------------

kubeadm config images pull
kubeadm init --pod-network-cidr=192.168.56.10/16 --pod-network-cidr=192.168.0.0/16 --kubernetes-version=1.32.3 --ignore-preflight-errors=all

#------------------

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#------------

kubectl apply -f https://docs.projectcalico.org/manifests/canal.yaml

#-----------

watch -n5 kubectl get pods -A     
