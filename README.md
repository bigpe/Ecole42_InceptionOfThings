# Inception-of-Things

## Part 1

### Test

run following commands in `p1` directory:

`vagrant up`

`vagrant ssh oouklichS`

`k get nodes -o wide`

### Some resources

#### Vagrant

- [Trying out vagrant](https://github.com/ilkou/vagrant_getting_started)

- [Vagrant Docs](https://www.vagrantup.com/docs/provisioning/shell#env)

- [Install centox 8](https://computingforgeeks.com/run-centos-8-vm-using-vagrant-on-kvm-virtualbox-vmware-parallels/)

Vagrant enables you to create and configure reproducible, and portable development environments using Virtual machine images called Boxes.

With Vagrant, you can setup your development environments in seconds on various virtualization platforms such as VirtualBox, KVM, VMware, Hyper-V, e.t.c.

### VBoxManage Customizations

[VBoxManage](https://www.virtualbox.org/manual/ch08.html) is a utility that can be used to make modifications to VirtualBox virtual machines from the command line.

Vagrant exposes a way to call any command against VBoxManage just prior to booting the machine:

```ruby
config.vm.provider "virtualbox" do |v|
  v.customize ["modifyvm", :id, "--name", "ilkou"]
end
```

which is equivalent to:

```shell
VBoxManage modifyvm "id-of-vm=being-created" --name ilkou
```

There are some convenience shortcuts for memory and CPU settings:

```ruby
config.vm.provider "virtualbox" do |v|
  v.memory = 512
  v.cpus = 1
end
```

[the bare minimum in terms of resources](https://rancher.com/docs/k3s/latest/en/installation/installation-requirements/#hardware)

The following NAT networking settings are available through VBoxManage modifyvm. With all these settings, the decimal number directly following the option name, 1-N in the list below, specifies the virtual network adapter whose settings should be changed.

`--natdnsproxy<1-N> on|off`: Makes the NAT engine proxy all guest DNS requests to the host's DNS servers. [See Section 9.8.5, “Enabling DNS Proxy in NAT Mode”](https://www.virtualbox.org/manual/ch09.html#nat-adv-dns).

`--natdnshostresolver<1-N> on|off`: Makes the NAT engine use the host's resolver mechanisms to handle DNS requests. [See Section 9.8.6, "Using the Host's Resolver as a DNS Proxy in NAT Mode"](https://www.virtualbox.org/manual/ch09.html#nat_host_resolver_proxy).

[reason-behind](https://www.vagrantup.com/docs/providers/virtualbox/common-issues#dns-not-working)

- Overview of Networking Modes

<img width="661" alt="table" src="https://user-images.githubusercontent.com/48165230/137567878-d41744ad-dad9-4c71-a072-b670d66a0646.png">

#### K3S

[Uninstalling K3s](https://rancher.com/docs/k3s/latest/en/installation/uninstall/)

[Installation Options](https://rancher.com/docs/k3s/latest/en/installation/install-options/)

[K3s Server Configuration Reference](https://rancher.com/docs/k3s/latest/en/installation/install-options/server-config/)

## Part 2

in this part we will expose 3 web apps hosted with nginx by using the K3s built-in ingress controller “Traefik”.

first, we should turn off both options of the virtual box --natdnsproxy1 --natdnshostresolver1 ; [issue link](https://githubmemory.com/repo/k3s-io/k3s/issues/4026)

#### Examples

- [Install and configure a Kubernetes cluster with k3s to self-host applications](<https://kauri.io/#collections/Build%20your%20very%20own%20self-hosting%20platform%20with%20Raspberry%20Pi%20and%20Kubernetes/(38)-install-and-configure-a-kubernetes-cluster-w/>)

- [Deploy an Ingress Controller on K3s](https://rancher.com/blog/2020/deploy-an-ingress-controllers)

- [Ingressing with k3s](https://carpie.net/articles/ingressing-with-k3s)

- [Setup Kubernetes Development Environment using Vagrant and K3s](https://berviantoleo.medium.com/setup-kubernetes-development-environment-using-vagrant-and-k3s-9d3273589c44)

#### Docs

- [Ingress by host](https://kubernetes.io/fr/docs/concepts/services-networking/ingress/#fanout-simple)

#### Useful commands

- after running the machine we should be able to view ingress by typing the following command

`kubectl describe ingress`

- to debug and see if the deployment is doing well (logs kinda thing)

`sudo journalctl -u k3s | tail -n 20`

- to delete a deployment

`kubectl delete -f deployment.yaml`

## Part 3

#### Examples

- [GitOps on a Laptop with K3D and ArgoCD](https://en.sokube.ch/post/gitops-on-a-laptop-with-k3d-and-argocd-1)

- [k3d setup](https://github.com/iwilltry42/k3d-demo)

- [argocd](https://tanzu.vmware.com/developer/guides/argocd-gs/)

## Configure VM

Update packages

```shell
sudo apt update -y
sudo apt upgrade -y
```

Grant ur user with sudo permissions

```shell

su

apt install sudo

usermod -aG sudo ilkou

su ilkou

```

Install ur favorite text editor

```shell
sudo apt install vim -y
```

Set a static IP address

```console
ilkou@iot:~$ cat /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
#allow-hotplug enp0s3
#iface enp0s3 inet dhcp
auto enp0s3
iface enp0s3  inet static
 address 192.168.1.253
 netmask 255.255.255.0
 gateway 192.168.1.1
 dns-domain sweet.home
 dns-nameservers 192.168.1.1
```

Restart networking service on Debian Linux to switch from DHCP to static IP config

```console
$ sudo systemctl restart networking.service
```

## Bonus

[deploy gitlab](https://docs.gitlab.com/charts/installation/deployment.html)
