<h2 align="center" style="border-bottom: 5px dotted">
   <p> Software-Defined Networking and Network Function Virtualization (CS-609)</p>
    <p> Autumn 2024-25, Indian Institute of Technology Dharwad </p>
    <p> Lab Worksheet 06, Thursday morning session, 10th October 2024 </p>
    

</h2>

<h2 align="center" style="border-bottom: 5px dotted">
   <p> Topic covered: Open Network Operating System (ONOS)</p>
    

</h2>



<!---
## Lab - 04: OpenFlow

### 01-initial-setup
-->

**Lab objective:** Open Network Operating System 


# Some understanding


## What is ONOS?

According to [[2]](#ref2), Open Network Operating System (ONOS) is the leading open source SDN controller for building next-generation SDN/NFV solutions.

ONOS was designed to meet the needs of operators wishing to build carrier-grade solutions that leverage the economics of white box merchant silicon hardware while offering the flexibility to create and deploy new dynamic network services with simplified programmatic interfaces. ONOS supports both configuration and real-time control of the network, eliminating the need to run routing and switching control protocols inside the network fabric. By moving intelligence into the ONOS cloud controller, innovation is enabled and end-users can easily create new network applications without the need to alter the dataplane systems.

The ONOS platform includes:
-   A platform and a set of applications that act as an extensible, modular, distributed SDN controller.
-   Simplified management, configuration and deployment of new software, hardware & services.
-   A scale-out architecture to provide the resiliency and scalability required to meet the rigors of production carrier environments.




# Installing and running ONOS
---

## Specifications we shall be using for this lab worksheet

As on October 2024, I failed several time to install ONOS in Ubuntu 22.04. So based on that experience, I am going to use an older version of Ubuntu while using ONOS. We shall use Ubuntu 16.04 for this lab duration. 

1.  Login to your Proxmox VM using the credentials provided. First, check the version of Ubuntu you are given. Run the command `cat /etc/lsb-release` and your output should be similar to following:
> [!NOTE]
> You should receive a similar output as follows:   
> `DISTRIB_ID=Ubuntu`  
> `DISTRIB_RELEASE=22.04`  
> `DISTRIB_CODENAME=jammy`  
> `DISTRIB_DESCRIPTION="Ubuntu 22.04.5 LTS"`  

2. However, we shall be using `Ubuntu 16.04` and `Mininet 2.2.1` while working with ONOS. 


## Synchronize your working directory and navigate to the desired location

1. Please navigate to the GitHub repository by executing the following command:
```shell
cd 525a1/
``` 

2. Please execute the following command to synchrionize your *present working directory* with the GitHub repository:
```shell
git pull
```

3. To navigate tio the desired location, execute the following command:
```shell
cd cs609-autumn2024_25-/lab06-onos-updated/
```

## Preparation of the ground for installation of ONOS

### Working with docker

1.   Run the following command to download the required tools:
```shell
bash script01-blackbox01of02.sh
```
followed by:
```shell
bash script01-blackbox02of02.sh
```

### Working with Distrobox


1. To install distrobox, execute the following commands:
```shell
curl -O https://raw.githubusercontent.com/89luca89/distrobox/main/install
```

followed by

```shell
sudo bash install
```

2. To view the list of available distroboxes, run the following command:
```shell
distrobox-list --root
```

> [!NOTE]  
> As we have not yet created any distro using distrobox, this list should be empty.



3. Now we shall install Ubuntu 16 using distrobox. To do so, execute the following command in your terminal:
```shell
distrobox-create --root --name Ubuntu16 --image ubuntu:16.04
```
Run the following command to verify it:
```shell
distrobox-list --root
```
For reference, you may look at the following snapshot:
<img src="../../.supporting-files/lab06-onos/img01.png" >

> [!NOTE]  
> We have just installed the required Ubuntu 16.04. So it is visible in the list. And you may verify it by seeing the list.


4. To enter the container `Ubuntu16`, use the following command:
```shell
distrobox enter --root Ubuntu16
```

> [!NOTE]
> You need to provide one password when the following prompt will be shown:  
> `First time user password setup`  
> `Enter new UNIX password:`  
> In that case, use the password `HelloSdn`  

You may consider the following reference:
<img src="../../.supporting-files/lab06-onos/vid01.gif" >

5. Run the command `cat /etc/lsb-release` and your output should be similar to following:
> [!NOTE]
> You should receive a similar output as follows:   
> `DISTRIB_ID=Ubuntu`  
> `DISTRIB_RELEASE=16.04`  
> `DISTRIB_CODENAME=xenial`  
> `DISTRIB_DESCRIPTION="Ubuntu 16.04.7 LTS"`  

6. The setup is ready. We are all set to install ONOS.



## Installing on a single machine


6. sudo apt install vim git curl -y

7. cat /etc/lsb-release

8. rm install


## Running ONOS as a service

## Accessing the CLI and GUI

## Forming a cluster

# References

1.  [AI Assisted Automation Framework in ONOS](https://www.youtube.com/watch?v=vtnliDI4sFg)<a	name="ref1"></a>
2.  [Open Network Operating System](https://opennetworking.org/onos/)<a	name="ref2"></a>
3.  [ONOS Overview - ONF Bootcamp May 23, 2017](https://www.youtube.com/watch?v=XI3ckGAK84k&t=3s)<a	name="ref3"></a>
