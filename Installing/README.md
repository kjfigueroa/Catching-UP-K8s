[![linkedin-shield]][linkedin-url] [![kubernetes-s]][kubernetes-doc] ![ubuntu] ![vbox]

#### References:
[![ref1]][ref1-L] [![ref2]][ref2-L] [![ref5]][ref5-L] [![ref3]][ref3-L] [![ref4]][ref4-L]


# Installing

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