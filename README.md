# Inception-of-Things

## Description

This educational project aims to deepen knowledge by making use K3d and K3s with Vagrant.

It will consist of setting up several environments under specific rules. It is divided into three parts you have to do in the following order:
* Part 1: [K3s and Vagrant](#part-1-k3s-and-vagrant)
* Part 2: [K3s and three simple applications](#part-2-k3s-and-three-simple-applications)
* Part 3: [K3d and Argo CD](#part-3-k3d-and-argo-cd)
* Bonus: [Gitlab](#bonus-part-gitlab)

<hr>

### Part 1: K3s and Vagrant

Go and check [step-by-step instruction](./p1_description.md) for this part!

Goals:

* Own Vagrantfile using the latest stable version of CentOS and only the bare minimum in terms of resources

* Machines must have a dedicated IP on the eth1 interface.

* Be able to connect with SSH on both machines with no password.

* K3s must be installed on both machines:
    - In the first one (Server), it will be installed in controller mode.
    - In the second one (ServerWorker), in agent mode.

<hr>

### Part 2: K3s and three simple applications

Go and check [step-by-step instruction](./p2_description.md) for this part!

Goals:
* Set up 3 web applications that will run in your K3s instance.

* With the HOST app1.com, the server must display the app1. When the HOST app2.com is used, the server must display the app2. Otherwise, the app3 should be selected by default.

* Application number 2 must have 3 replicas.
<hr>

### Part 3: K3d and Argo CD

Go and check [step-by-step instruction](./p3_description.md) for this part!

Goals:

* No Vagrant
* Install K3D on your virtual machine.
* Create continuous integration using Argo CD
* Must be able to change the version from your public Github repository, then check that the application has been correctly updated.

<hr>

### Bonus: Gitlab

Go and check [step-by-step instruction](./bonus_description.md) for this part!

Goals:
* Add Gitlab to the Part 3.
* Gitlab instance must run locally.
* Configure Gitlab to make it work with  cluster.
* Create a dedicated namespace named gitlab.
* Everything in Part 3 must work with local Gitlab.