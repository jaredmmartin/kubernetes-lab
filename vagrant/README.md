# Vagrant Kubernetes Lab

This Vagrantfile provisions a multi-node Kubernetes lab on VirtualBox using an
Ubuntu 24.04 base box built with Packer. The cluster includes one control plane
node and a configurable number of worker nodes, plus optional services.

## Requirements

- Vagrant 2.x
- VirtualBox
- Ansible installed on the host
- The base box built from `../packer/ubuntu-server-24.04/ubuntu-server-24.04.box`

## Quick start

From `k8s-lab/vagrant`:

```bash
vagrant up
```

To stop the cluster:

```bash
vagrant halt
```

To destroy everything:

```bash
vagrant destroy -f
```

## Cluster layout

- Control plane node: `k8s-main` at `10.0.3.40`
- Worker nodes: `k8s-worker01`, `k8s-worker02`, ... (incrementing IPs)
- DNS zone: `lab.test`
- Load balancer IP pool: `10.0.3.50-10.0.3.70`

All VMs are attached to the `public_network` bridge `enp12s0` and use the base
box `../packer/ubuntu-server-24.04/ubuntu-server-24.04.box`.

## Configuration

Edit these values at the top of `Vagrantfile` to customize the lab:

- `NUM_OF_WORKERS`: number of worker nodes
- `DNS_ZONE`: DNS zone used by services
- `GATEWAY_IP`, `MAIN_IP`, `SUBNET_CIDR`: network layout
- `LOAD_BALANCER_IP_POOL_RANGE`: MetalLB address pool
- `KUBERNETES_VERSION`: Kubernetes version to deploy
- `DEPLOY_AWX`, `DEPLOY_JENKINS`: optional services

## Provisioning flow

The control plane (`k8s-main`) provisions:

- Base OS config: `files/common/main.yml`
- DNS server: `files/bind/main.yml`
- NFS server: `files/nfs/main.yml`
- Kubernetes common setup: `files/k8s/common.yml`
- Control plane setup: `files/k8s/main.yml`

Each worker node provisions:

- Base OS config: `files/common/main.yml`
- Kubernetes common setup: `files/k8s/common.yml`
- Cluster join: `files/k8s/worker.yml`

On the final worker node, the following cluster-wide services are applied:

- MetalLB and Nginx ingress
- Kubernetes dashboard
- NFS provisioner
- Vault
- cert-manager
- Optional: AWX, Jenkins

## Notes

- The cluster join artifacts are cleaned on destroy via a Vagrant trigger.
- If you change the bridge interface name, update the `bridge` option on all
  `public_network` blocks.
