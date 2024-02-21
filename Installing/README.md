[![linkedin-shield]][linkedin-url] [![kubernetes-s]][kubernetes-doc] ![ubuntu] ![vbox]

<a name="readme-top"></a>

#### References:
[![ref1]][ref1-L] [![ref2]][ref2-L] [![ref6]][ref6-L] [![ref5]][ref5-L] [![ref3]][ref3-L] [![ref4]][ref4-L]

>[!NOTE]
> :construction: Under construction :construction:

Given the indicated reference, Kubeadm is the "fast paths" for creating Kubernetes clusters, and has the minimum of features to meet this end, therefore the only thing I expect from this part of my development is getting the higher level tools and using kubeadm as the foundation of all deployments will make it easier to create compliant clusters.

## Installing and Config Containerd

In general, the following criteria must be met (check the [raw commands page](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/Installing/raw-install-containerd.txt)):

1. Disable SWAP Memory: Swap configuration. The default behavior of a kubelet was to fail to start if swap memory was detected on a node. `$ sudo swapoff -a`

2. Forwarding IPv4 and letting iptables see bridged traffic. On `/etc/modules-load.d` make the k8s configuration for `overlay`, `br_netfilter` modules.

3. sysctl params required by setup, and apply `sysctl` params without reboot

4. Install daemon Containerd.

5. Update the apt package index and install packages needed to use the containerd apt repository.

6. Add the **docker** repository to Apt sources.

7. Install the containerd software.

8. Restart and check the status of containerd.

#### Script output
```sh
master@k8s-control-plane:~$ sudo bash install-containerd.sh 

 Message! 
The default behavior of a kubelet was to fail to start if swap memory was detected on a node.
Is neccesary disable swap to continue...

Press enter to continue

 Message! 
Up to this point, the modules variables br_netfilter, and overlay modules have been loaded
Showing previously configured modules:

br_netfilter           32768  0
bridge                307200  1 br_netfilter
overlay               151552  0

Press enter to continue

 Message! 
Up to this point, the following system variables have been configured
Showing previously configured system variables:

net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1

Press enter to continue
 Message! 
Containerd should be ready, showing the current status!

● containerd.service - containerd container runtime
     Loaded: loaded (/lib/systemd/system/containerd.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2024-02-18 06:08:51 UTC; 2s ago
       Docs: https://containerd.io
    Process: 3850 ExecStartPre=/sbin/modprobe overlay (code=exited, status=0/SUCCESS)
   Main PID: 3851 (containerd)
      Tasks: 10
     Memory: 13.0M
        CPU: 132ms
     CGroup: /system.slice/containerd.service
             └─3851 /usr/bin/containerd

Feb 18 06:08:51 k8s-control-plane containerd[3851]: time="2024-02-18T06:08:51.749567761Z" level=info msg="Start subscribing containerd event"   
Feb 18 06:08:51 k8s-control-plane containerd[3851]: time="2024-02-18T06:08:51.750070558Z" level=info msg="Start recovering state"
Feb 18 06:08:51 k8s-control-plane containerd[3851]: time="2024-02-18T06:08:51.750207614Z" level=info msg="Start event monitor"
Feb 18 06:08:51 k8s-control-plane containerd[3851]: time="2024-02-18T06:08:51.750337617Z" level=info msg=serving... address=/run/containerd/con>
Feb 18 06:08:51 k8s-control-plane containerd[3851]: time="2024-02-18T06:08:51.750520577Z" level=info msg=serving... address=/run/containerd/con>
Feb 18 06:08:51 k8s-control-plane containerd[3851]: time="2024-02-18T06:08:51.751726738Z" level=info msg="Start snapshots syncer"
Feb 18 06:08:51 k8s-control-plane containerd[3851]: time="2024-02-18T06:08:51.751881443Z" level=info msg="Start cni network conf syncer for def>
Feb 18 06:08:51 k8s-control-plane containerd[3851]: time="2024-02-18T06:08:51.751896881Z" level=info msg="Start streaming server"
Feb 18 06:08:51 k8s-control-plane systemd[1]: Started containerd container runtime.
Feb 18 06:08:51 k8s-control-plane containerd[3851]: time="2024-02-18T06:08:51.752196171Z" level=info msg="containerd successfully booted in 0.0>
lines 1-22/22 (END)
```

<p align="right"><a href="#readme-top">▲top</a></p> 

## Installing kubeadm, kubelet and kubectl [:link:](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)

It is necessary to update the `apt` base and install the following packages `sudo apt-get install -y apt-transport-https ca-certificates curl gpg`, but these were already installed previously during the `containerd` installing & configuration, I verify them as a double check:

```sh
root@k8s-control-plane:~# dpkg -l ca-certificates apt-transport-https curl gpg
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name                Version                 Architecture Description
+++-===================-=======================-============-=======================================================
ii  apt-transport-https 2.4.11                  all          transitional package for https support
ii  ca-certificates     20230311ubuntu0.22.04.1 all          Common CA certificates
ii  curl                7.81.0-1ubuntu1.15      amd64        command line tool for transferring data with URL syntax
ii  gpg                 2.2.27-3ubuntu2.1       amd64        GNU Privacy Guard -- minimalist public key operations
``` 

I would only have to download the public signing key, at the moment, I only have `docker` downloaded:

```sh
root@k8s-control-plane:~# ls -ld /etc/apt/keyrings
drwxr-xr-x 2 root root 4096 Feb 18 06:08 /etc/apt/keyrings
root@k8s-control-plane:~# ls -l /etc/apt/keyrings
total 4
-rw-r--r-- 1 root root 3817 Feb 18 06:08 docker.asc
root@k8s-control-plane:~#
```

Downloading the keyring:
```sh
root@k8s-control-plane:~# \
> curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
root@k8s-control-plane:~#
root@k8s-control-plane:~# ls -l /etc/apt/keyrings
total 8
-rw-r--r-- 1 root root 3817 Feb 18 06:08 docker.asc
-rw-r--r-- 1 root root 1200 Feb 19 16:46 kubernetes-apt-keyring.gpg
root@k8s-control-plane:~# 
```

Now, I need to add the appropriate Kubernetes apt repository, so far now I only have the `docker` info:
```sh
root@k8s-control-plane:~# ls -l /etc/apt/sources.list.d/
total 4
-rw-r--r-- 1 root root 110 Feb 18 06:08 docker.list
root@k8s-control-plane:~# 
```

The documentation warns me that this step will overwrite the existing configuration for the `kubernetes.list`, so being the first time this will be a clean installation.

```sh
root@k8s-control-plane:~# echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' |tee /etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /
root@k8s-control-plane:~#
root@k8s-control-plane:~# ls -l /etc/apt/sources.list.d/
total 8
-rw-r--r-- 1 root root 110 Feb 18 06:08 docker.list
-rw-r--r-- 1 root root 108 Feb 19 16:54 kubernetes.list
root@k8s-control-plane:~#
```
I proceed to update and install the `kubelet kubeadm kubectl` packages, and by the way, mark them on **hold** to avoid future updates that could be detrimental.

```sh
root@k8s-control-plane:~# apt update
   ...
root@k8s-control-plane:~# apt-get install -y kubelet kubeadm kubectl
   ...
root@k8s-control-plane:~# apt-mark hold kubelet kubeadm kubectl
kubelet set on hold.
kubeadm set on hold.
kubectl set on hold.
root@k8s-control-plane:~#
```
>[!IMPORTANT]
>The kubelet is now restarting every few seconds, as it waits in a crashloop for kubeadm to tell it what to do.

<p align="right"><a href="#readme-top">▲top</a></p> 


## Creating a cluster with kubeadm [:link:](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

According to the docs, `kubeadm` tool is good if I need:

* A simple way for you to try out Kubernetes, possibly for the first time.
* A way for existing users to automate setting up a cluster and test their application.
* A building block in other ecosystem and/or installer tools with a larger scope.

>[!IMPORTANT]
>Since it is necessary to have a static network configuration, and I'm currently trying to run these configurations in a VM on Windows, I have configured the VM with a "bridged" network mode and allowable to everything (promiscue mode: allow all), and I have configured static addressing by applying a "netplan" to each machine (I have this [bash-script](https://github.com/kjfigueroa/bash-scripts/blob/main/statics-ip-ubuntu-vm.sh) for such a commit).

### Install a single control-plane Kubernetes cluster



### Install a Pod network on the cluster

[linkedin-shield]: https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white
[linkedin-url]: https://www.linkedin.com/in/kjfigueroa/
[kubernetes-doc]: https://kubernetes.io/docs/home/
[kubernetes-s]: https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white
[vbox]: https://img.shields.io/badge/VirtualBox-183A61?logo=virtualbox&logoColor=white&style=for-the-badge
[ubuntu]: https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white 
[ref1]: https://img.shields.io/badge/glossary-kubeadm-blue
[ref1-L]: https://kubernetes.io/docs/reference/setup-tools/kubeadm/
[ref2]: https://img.shields.io/badge/install-kubeadm-blue
[ref2-L]: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
[ref3]: https://img.shields.io/badge/set_up-containerd-212121
[ref3-L]: https://kubernetes.io/docs/setup/production-environment/container-runtimes/
[ref4]: https://img.shields.io/badge/production_environment_tools-containerd-212121
[ref4-L]: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/
[ref5]: https://img.shields.io/badge/ports_and_protocols-kubeadm-blue
[ref5-L]: https://kubernetes.io/docs/reference/networking/ports-and-protocols/
[ref6]: https://img.shields.io/badge/create_a_cluster-kubeadm-blue
[ref6-L]: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/