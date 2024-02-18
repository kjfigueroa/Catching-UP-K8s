#!/bin/bash
#
# February, 2024
#
# By Kevin J. Figueroa M. https://github.com/kjfigueroa
# Preparing a system for Kubernetes (K8s) with Kubeadm
# Debian-based distributions
#
# This Bash Script Install and Configure the Container Runtime Containerd
#
# References:
#
#  production-environment Kubeadm:
#       https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/
#
#  Installing Kubeadm: 
#       https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
#
#  Installing Container-Runtime (my selection: containerd)
#       https://kubernetes.io/docs/setup/production-environment/container-runtimes/
#       https://docs.docker.com/engine/install/ubuntu/ 
#
#  Ports and Protocols needed:
#       https://kubernetes.io/docs/reference/networking/ports-and-protocols/ 
#
#  ┌─────────────────────────────────────────┐
#  │ Note: RUN this bash-script as ROOT user │
#  └─────────────────────────────────────────┘
#
#■■■■■■■■■■■ 0. Spinning ■■■■■■■■■■■
 waitProgress()
 {
     local pid=$!
     local delay=0.75
     local spinstr='|/-\'
     while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
         local temp=${spinstr#?}
         printf " %c  " "$spinstr"
         local spinstr=$temp${spinstr%"$temp"}
         sleep $delay
         printf "\b\b\b\b\b\b"
     done
     printf "    \b\b\b\b"
 }
#
#
#
#■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  Install a Container Runtime ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
#           Is necessary to install a container runtime into each node in the cluster 
#           so that Pods can run there.    
#
#■■■■■■■■■■■ 1. Disable SWAP Memory ■■■■■■■■■■■
#           Swap configuration. The default behavior of a kubelet was to fail to start if swap 
#           memory was detected on a node. 
#           Swap has been supported since v1.22. And since v1.28, Swap is supported for cgroup v2 only; 
#           the NodeSwap feature gate of the kubelet is beta but disabled by default.
#           You MUST disable swap if the kubelet is not properly configured to use swap. 
#           For example, sudo swapoff -a will disable swapping temporarily. 
#           To make this change persistent across reboots, make sure swap is disabled in config files 
#           like /etc/fstab, systemd.swap, depending how it was configured on your system.
#
echo -e "\n\e[1;7m Message! \e[0m"
echo "The default behavior of a kubelet was to fail to start if swap memory was detected on a node."
echo "Is neccesary disable swap to continue..."
echo -e ""; sleep 1
read -p "Press enter to continue"                                             
swapoff -a           
#
#
#■■■■■■■■■■■ 2. Install and configure prerequisites ■■■■■■■■■■■            
#           Common settings for Kubernetes nodes on Linux.        
#
#           Forwarding IPv4 and letting iptables see bridged traffic
#
#
cat <<EOF | tee /etc/modules-load.d/k8s.conf >/dev/null 2>&1
overlay
br_netfilter
EOF
#
modprobe overlay
modprobe br_netfilter
#
#
#          Sysctl params required by setup, params persist across reboots
#
cat <<EOF | tee /etc/sysctl.d/k8s.conf >/dev/null 2>&1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
#
#
#          Apply sysctl params without reboot
#
sysctl --system >/dev/null 2>&1
#
#
#          Verify that the br_netfilter, overlay modules are loaded
#
echo -e "\n\e[1;7m Message! \e[0m"
echo "Up to this point, the modules variables br_netfilter, and overlay modules have been loaded"                                              
echo -e "Showing previously configured modules:\n"; lsmod |grep -Ew 'overlay|br_netfilter'
echo -e ""; read -p "Press enter to continue"
#
#
#          Verify that the below system variables are set to 1 in the sysctl:
#                       net.bridge.bridge-nf-call-iptables 
#                       net.bridge.bridge-nf-call-ip6tables
#                       net.ipv4.ip_forward 
#
echo -e "\n\e[1;7m Message! \e[0m"
echo "Up to this point, the following system variables have been configured"
echo -e "Showing previously configured system variables:\n"
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
echo -e ""; read -p "Press enter to continue"
#
#
#■■■■■■■■■■■ 3. Install daemon Containerd ■■■■■■■■■■■
#              "Containerd is a daemon to control runC, built for performance and density."
#
apt-get install -q -y containerd > /tmp/install-containerd-stdout-$(date +%F_%R) 2>&1 & waitProgress
#
#
#          Update the apt package index and install packages needed 
#          to use the containerd apt repository:
#
apt-get update > /tmp/update-stdout-$(date +%F_%R) && apt-get install -y apt-transport-https ca-certificates curl gpg software-properties-common > /tmp/install-index-packages-stdout-$(date +%F_%R) 2>&1 & waitProgress
#
#          In releases older than Debian 12 and Ubuntu 22.04, folder /etc/apt/keyrings 
#          does not exist by default, and it should be created before the curl command.
#
mkdir -p /etc/apt/keyrings
install -m 0755 -d /etc/apt/keyrings
#
#
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc & waitProgress
chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources
#echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null 2>&1
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list 2>&1 & waitProgress
#
#
#■■■■■■■■■■■ 4. Install the containerd software ■■■■■■■■■■■
#
apt-get update >> /tmp/update-stdout-$(date +%F_%R) && apt-get install -y containerd.io > /tmp/install-containerd.io-stdout-$(date +%F_%R) 2>&1 & waitProgress
containerd config default | tee /etc/containerd/config.toml >/dev/null 2>&1 & waitProgress
sed -e 's/SystemCgroup = false/Systemd = true/g' -i /etc/containerd/config.toml & waitProgress
systemctl restart containerd & waitProgress
#
#
#
echo -e "\e[1;7m Message! \e[0m"
echo "Containerd should be ready, showing the current status!"
sleep 2; echo -e ""
systemctl status containerd