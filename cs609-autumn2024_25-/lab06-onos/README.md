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

## Specifications we shall be using for this lab worksheet

We shall use Ubuntu 16.04?? for this lab duration. 

1.  Login to your Proxmox VM using the credentials provided. First, check the version of Ubuntu you are given. Run the command `cat /etc/lsb-release` and your output should be similar to following:
> [!NOTE]
> `DISTRIB_ID=Ubuntu`  
> `DISTRIB_RELEASE=22.04`  
> `DISTRIB_CODENAME=jammy`  
> `DISTRIB_DESCRIPTION="Ubuntu 22.04.5 LTS"`  

## Installing on a single machine

## Running ONOS as a service

## Accessing the CLI and GUI

## Forming a cluster

# References

1.  [AI Assisted Automation Framework in ONOS](https://www.youtube.com/watch?v=vtnliDI4sFg)<a	name="ref1"></a>
2.  [Open Network Operating System](https://opennetworking.org/onos/)<a	name="ref2"></a>
3.  [ONOS Overview - ONF Bootcamp May 23, 2017](https://www.youtube.com/watch?v=XI3ckGAK84k&t=3s)<a	name="ref3"></a>
