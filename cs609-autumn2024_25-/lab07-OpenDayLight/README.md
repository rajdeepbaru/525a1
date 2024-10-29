<h2 align="center" style="border-bottom: 5px dotted">
   <p> Software-Defined Networking and Network Function Virtualization (CS-609)</p>
    <p> Autumn 2024-25, Indian Institute of Technology Dharwad </p>
    <p> Lab Worksheet 07, Tuesday morning session, 29th October 2024 </p>
    

</h2>

<h2 align="center" style="border-bottom: 5px dotted">
   <p> Topic covered: OpenDaylight </p>
    

</h2>




# Installation



1. You may use the following link: https://nexus.opendaylight.org/content/repositories/public/org/opendaylight/integration/distribution-karaf/0.6.3-Carbon

2. Extract it using: `tar -xvzf karaf-0.21.0.tar.gz`

3. Change to the directory `cd karaf-0.6.3/`

4.  Make sure to install openjdk-8.

5. To run the karaf distribition, execute `./bin/karaf`


<img src="Screenshot from 2024-10-29 06-02-21.png" >


# Install the Karaf features

To install a feature, use the following command, where feature1 is the feature name listed in the table below:

`feature:install <feature1>`

You can install multiple features using the following command:

`feature:install <feature1> <feature2> ... <featureN-name>`



# Listing available features

To find the complete list of Karaf features, run the following command:

`feature:list`

To list the installed Karaf features, run the following command:

`feature:list -i`




# Example 1: Create a network with a single switch and a host 

## Objective: 

We shall use Mininet and OpenDaylight to create a network with a single switch and a host connected to it. Here OpenDaylight controller will manage the switch.


## Steps

###  In the OpenDayLight terminal

1. Start OpenDaylight using `./bin/karaf`

2. In the Karaf console, install the necessary OpenFlow features: `feature:install odl-restconf odl-l2switch-switch odl-openflowplugin-flow-services`



### Set Up Mininet

1. Install mininet.

2. Start Mininet with an OpenFlow switch that connects to the OpenDaylight controller: `sudo mn --controller=remote,ip=<OpenDaylight_IP>,port=6633 --topo single,2 --switch ovsk`. Replace `OpenDaylight_IP` with the IP address of your OpenDaylight controller.


### Testing Connectivity

After starting Mininet, you can test connectivity between the hosts:

`mininet> pingall`


# Example 2:  Configure a network topology with flows using OpenDaylight's REST API


## Objective: 

Create a basic network topology, add devices (nodes), and configure them with flows using OpenDaylight’s REST APIs


## Steps

1.  Make sure you have the required features installed: `feature:install odl-restconf odl-l2switch-switch odl-openflowplugin-flow-services`

2. To Set Up Mininet with Multiple Switches, Start Mininet with two switches and two hosts, and configure it to use OpenDaylight as the controller. Use the following command: `sudo mn --controller=remote,ip=<OpenDaylight_IP>,port=6633 --topo linear,2`. Replace `OpenDaylight_IP` with the IP address of your OpenDaylight controller. This command creates a linear topology where:

    -   Switch 1 (s1) connects to Host 1 (h1).
    -   Switch 2 (s2) connects to Host 2 (h2).
    -   Switch 1 and Switch 2 are linked together.

3. Add Flow Rules via OpenDaylight REST API. To ensure connectivity between Host 1 and Host 2 through the two switches, we’ll add flow rules to direct traffic between them.

### Flow Rule 1: Forward Packets from Switch 1 to Switch 2

