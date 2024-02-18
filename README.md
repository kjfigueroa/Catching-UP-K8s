[![LinkedIn][linkedin-shield]][linkedin-url] ![kubernetes-doc][kubernetes-s] ![KEVIN]


# Catching Up on K8s

This repository is intended to be a log of the progress of my Kubernetes self-training.

My Search, to understand the series of practices related to typical scenarios in a work environment with K8s. My purpose is to understand at a medium level the practical forms (codes and procedures) standardized for the following topics in K8s:

1.  [Installing](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/Installing)
2.  [Configuration](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/Configuration)
3.  [Architecture](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/Architecture)
4.  [APIs](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/APIs)
5.  [States](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/States)
6.  [Storage](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/Storage)
7.  [Services](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/Services)
8.  [Deployments](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/Deployments)
9.  [Ingress](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/Ingress)
10. [Scheduling](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/Scheduling)
11. [Logging](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/Logging)
12. [Troubleshooting](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/Troubleshooting)
13. [Objects and Operators](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/Objects_and_Operators)
14. [Security](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/Security)
15. [HAProxy](https://github.com/kjfigueroa/Catching-UP-K8s/tree/main/HAProxy)

### Environment

Since this project is only with the intention of training my skills, I have opted only for the use of a small home network in VirtualBox, of course, according to the same provider documentation ([Install and Set Up kubeadm on Linux](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)), It is not indicated exactly which platform should be worked on, so in an agnostic manner that the technology can be installed in the same way in **VirtualBox**, **GCP**, **AWS**, **Azure**, etc...

Pretendo que mi cluster disponga de las siguientes maquinas: 

* Control-Plane:

        Operating System: Ubuntu (64-bit)
        Base Memory: 4096 MB
        Processors: 3
        SATA Port 0: Control-Plane.vdi (Normal, 25.00 GB)

* Worker 1 (bis): 

        Operating System: Ubuntu (64-bit)
        Base Memory: 2048 MB
        Processors: 1
        SATA Port 0: Control-Plane.vdi (Normal, 10.00 GB)

For better usability of the machines in VirtualBox, I keep in mind to take a :camera: "*snapshoot*" for each time I try to make a successful progress, to return to the practice again and repeat it until I understand its process.

<div align="center">
    <img src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExemMwNXM1djc3anVrNHZoamJ6cGFpdHgwdWI3bnB6cXR3MXI1bGNtcSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/26zyYdiV4pdZZUWEU/giphy.gif">
    <p>"To Boldly Go Where No Man Has Gone Before"</p>
</div>



[linkedin-shield]: https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white
[linkedin-url]: https://www.linkedin.com/in/kjfigueroa/
[KEVIN]: https://img.shields.io/badge/Self_Learning-000000?style=for-the-badge
[kubernetes-doc]: https://kubernetes.io/docs/home/
[kubernetes-s]: https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white
