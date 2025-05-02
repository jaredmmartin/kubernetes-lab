# k8s-lab

This repository contains automation to provision a Kubernetes cluster running the latest available version.

## Contents

### packer

#### ubuntu-server-22.04

Packer template to build Vagrant box for VirtualBox with Ubuntu Server 22.04 LTS

### vagrant

### k8s-latest

Vagrant file to build a Kubernetes cluster with one control plane node and n number of worker nodes. The number of worker nodes is set by the `NUM_OF_WORKERS` variable in the Vagrantfile.

Kubernetes operators
+ MetalLB with Nginx ingress controller
+ Kubernetes dashboard
    + After successful deployment, retrieve the URL and login token from `vagrant/k8s-latest/files/k8s/temp/dashboard.txt`
+ NFS provisioner
+ Hashicorp Vault
    + After successful deployment, retrieve the URL, root token, and unseal keys from `vagrant/k8s-latest/files/k8s/temp/vault.txt`
+ cert-manager
+ AWX
+ Hashicorp Consul
    + After successful deployment, retrieve the URL from `vagrant/k8s-latest/files/k8s/temp/consul.txt`
+ Grafana
+ Jenkins
    + For some reason, this operator takes forever to come online
+ PingFederate
    + You must register for the Ping DevOps program (it's free) and populate your user and key in `vagrant/k8s-latest/files/k8s/services/ping/files/pingctl-config` before this operator will work.
