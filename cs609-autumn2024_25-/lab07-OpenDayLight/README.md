<h2 align="center" style="border-bottom: 5px dotted">
   <p> Software-Defined Networking and Network Function Virtualization (CS-609)</p>
    <p> Autumn 2024-25, Indian Institute of Technology Dharwad </p>
    <p> Lab Worksheet 07, Tuesday morning session, 29th October 2024 </p>
    

</h2>

<h2 align="center" style="border-bottom: 5px dotted">
   <p> Topic covered: OpenDaylight </p>
    

</h2>


### Table of contents 
1.	Installation
    -   1.1.    Install OpenDaylight
    -   1.2. Install the Karaf features
    -   1.3. Listing available features
    -   1.4 How to start OpenDaylight
4. Example 1: Create a network with a single switch and a host
    -   4.1 Objective
    -   4.2 Steps
5. Example 2:  Configure a network topology with flows using OpenDaylight's REST API
    -   5.1. Objective
    -   5.2.    Algorithm
    -   5.3. Steps

6.  Example 3: Create a simple network topology with multiple hosts and switches while using OpenFlow to control packet flows
    -   6.1.  Objective
    -   6.2.    Algorithm
    -   6.3. Steps  

7. References



# Installation <a name="1"></a>

## Install OpenDaylight


1. You may use the following link: https://nexus.opendaylight.org/content/repositories/public/org/opendaylight/integration/distribution-karaf/0.6.3-Carbon

2. Extract it using: `tar -xvzf karaf-0.21.0.tar.gz`

3. Change to the directory `cd karaf-0.6.3/`

4.  Make sure to install openjdk-8.

5. To run the karaf distribition, execute `./bin/karaf`


<img src="Screenshot from 2024-10-29 06-02-21.png" >


## Install the Karaf features <a name"2"></a>

To install a feature, use the following command, where feature1 is the feature name listed in the table below:

`feature:install <feature1>`

You can install multiple features using the following command:

`feature:install <feature1> <feature2> ... <featureN-name>`



## Listing available features

To find the complete list of Karaf features, run the following command:

`feature:list`

To list the installed Karaf features, run the following command:

`feature:list -i`


## How to start OpenDaylight

Starting OpenDaylight involves a few steps, including downloading the software, setting up the environment, and running the OpenDaylight controller. Here’s a step-by-step guide to help you get started:

1. Download OpenDaylight
    -   Visit the OpenDaylight website: Go to the OpenDaylight Downloads page.
    -   Choose a distribution: Select the appropriate release (for example, the latest stable version) and download the ZIP or TAR.GZ file.
    -   Extract the archive: After downloading, extract the contents to a directory of your choice.

2.  Install Java

OpenDaylight requires Java to run. Make sure you have Java 8 or higher installed on your machine.
    -   Check Java installation: `java -version`
    -   Install Java (if not installed):    
        -   `sudo apt update`
        -   `sudo apt install openjdk-8-jdk`

3. Start OpenDaylight
    -   Navigate to the OpenDaylight directory: Open a terminal and change the directory to where you extracted OpenDaylight. For example: `cd /path/to/opendaylight-<version>`
    -   Run OpenDaylight: You can start OpenDaylight by running the following command: `./bin/karaf`
    -   Access the Karaf console: After running the above command, you will see the Karaf console interface. Here, you can issue commands to manage OpenDaylight.

4.  Install Necessary Features
    -   Once the Karaf console is running, you may want to install the necessary features for your use case. For example, to enable REST APIs and OpenFlow features, you can use the following commands in the Karaf console: `feature:install odl-restconf`  

`feature:install odl-openflowplugin-flow-services`

`feature:install odl-l2switch-switch`

5. Verify OpenDaylight is Running

To verify that OpenDaylight is running correctly, you can access the REST API using a web browser or a tool like `curl`.
    -   Check the REST API: Open a web browser and go to: `http://localhost:8181/restconf`. You should see a response indicating that the REST API is accessible.
    -   Use curl to check the API: You can also use the following command: `curl -u admin:admin http://localhost:8181/restconf`



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

## Algorithm

1.  Start OpenDaylight and install required features.
2.  Start Mininet with a two-switch topology, pointing it to OpenDaylight.
3.  Add flow rules using OpenDaylight’s REST API to forward packets between switches.
4   Test connectivity with ping.

## Steps

1.  Make sure you have the required features installed: `feature:install odl-restconf odl-l2switch-switch odl-openflowplugin-flow-services`

2. To Set Up Mininet with Multiple Switches, Start Mininet with two switches and two hosts, and configure it to use OpenDaylight as the controller. Use the following command: `sudo mn --controller=remote,ip=<OpenDaylight_IP>,port=6633 --topo linear,2`. Replace `OpenDaylight_IP` with the IP address of your OpenDaylight controller. This command creates a linear topology where:

    -   Switch 1 (s1) connects to Host 1 (h1).
    -   Switch 2 (s2) connects to Host 2 (h2).
    -   Switch 1 and Switch 2 are linked together.

3. Add Flow Rules via OpenDaylight REST API. To ensure connectivity between Host 1 and Host 2 through the two switches, we’ll add flow rules to direct traffic between them.

### Flow Rule 1: Forward Packets from Switch 1 to Switch 2


The first flow rule will be added on Switch 1 to forward traffic coming in on port connected to Host 1 out to Switch 2.
```shell
`curl -X PUT -H "Content-Type: application/json" \
-d '{
      "flow": [
          {
              "id": "1",
              "match": {
                  "in-port": "1"
              },
              "instructions": {
                  "instruction": [
                      {
                          "apply-actions": {
                              "action": [
                                  {
                                      "output-action": {
                                          "output-node-connector": "2"
                                      }
                                  }
                              ]
                          }
                      }
                  ]
              },
              "priority": "500",
              "table_id": "0"
          }
      ]
    }' \


http://<OpenDaylight_IP>:8181/restconf/config/opendaylight-inventory:nodes/node/openflow:1/table/0/flow/1
```


### Flow Rule 2: Forward Packets from Switch 2 to Switch 1

This second flow rule will be added on Switch 2 to forward packets back to Switch 1 when needed.

```shell
curl -X PUT -H "Content-Type: application/json" \
-d '{
      "flow": [
          {
              "id": "2",
              "match": {
                  "in-port": "1"
              },
              "instructions": {
                  "instruction": [
                      {
                          "apply-actions": {
                              "action": [
                                  {
                                      "output-action": {
                                          "output-node-connector": "2"
                                      }
                                  }
                              ]
                          }
                      }
                  ]
              },
              "priority": "500",
              "table_id": "0"
          }
      ]
    }' \
http://<OpenDaylight_IP>:8181/restconf/config/opendaylight-inventory:nodes/node/openflow:2/table/0/flow/2
```

4. Test Connectivity

In Mininet, use the following command to check if Host 1 can reach Host 2:
```shell
mininet> h1 ping h2
```

You should see successful ping responses, indicating that OpenDaylight is managing the flow between the switches


## Example 3: Create a simple network topology with multiple hosts and switches while using OpenFlow to control packet flows

### Objective

We will use a basic setup with two switches and two hosts, and we’ll add a flow to allow communication between the two hosts through the switches


### Algorithm

1.  Create a Mininet topology with two switches and two hosts.
2.  Use OpenDaylight to manage the flow rules that allow traffic to pass between the hosts.
3.  Verify communication between the hosts.



### Steps

1.  Set Up OpenDaylight: Make sure OpenDaylight is installed and running with the necessary features. Start the OpenDaylight Karaf console and install required features if you haven’t done so already: `feature:install odl-restconf odl-l2switch-switch odl-openflowplugin-flow-services`

2. Set Up Mininet: Start Mininet with a custom topology containing two switches and two hosts. Use the OpenDaylight controller as the remote controller. Use the following code: `sudo mn --controller=remote,ip=<OpenDaylight_IP>,port=6633 --topo single,2 --switch ovsk`. Replace `OpenDaylight_IP`  with the actual IP address of your OpenDaylight controller.

3. Add Flow Rule1 Using OpenDaylight REST API: It will allow Traffic from Host 1 to Host 2: This flow will allow traffic from Host 1 (h1) to Host 2 (h2) via Switch 1 (s1) to Switch 2 (s2).
    -   Create a flow on Switch 1 to forward packets from Host 1
```shell
curl -X PUT -H "Content-Type: application/json" \
-d '{
      "flow": [
          {
              "id": "h1-to-s2",
              "match": {
                  "in-port": "1"
              },
              "instructions": {
                  "instruction": [
                      {
                          "apply-actions": {
                              "action": [
                                  {
                                      "output-action": {
                                          "output-node-connector": "2"
                                      }
                                  }
                              ]
                          }
                      }
                  ]
              },
              "priority": "500",
              "table_id": "0"
          }
      ]
    }' \
http://<OpenDaylight_IP>:8181/restconf/config/opendaylight-inventory:nodes/node/openflow:1/table/0/flow/h1-to-s2
```


    -   Create a flow on Switch 2 to forward packets from Switch 1 to Host 2.


```shell
curl -X PUT -H "Content-Type: application/json" \
-d '{
      "flow": [
          {
              "id": "s1-to-h2",
              "match": {
                  "in-port": "1"
              },
              "instructions": {
                  "instruction": [
                      {
                          "apply-actions": {
                              "action": [
                                  {
                                      "output-action": {
                                          "output-node-connector": "2"
                                      }
                                  }
                              ]
                          }
                      }
                  ]
              },
              "priority": "500",
              "table_id": "0"
          }
      ]
    }' \
http://<OpenDaylight_IP>:8181/restconf/config/opendaylight-inventory:nodes/node/openflow:2/table/0/flow/s1-to-h2
```

4. Verify Communication: you can verify that Host 1 can communicate with Host 2 by using the ping command in Mininet `mininet> h1 ping h2`

5. Desired output: You should see successful ping responses indicating that Host 1 can communicate with Host 2 through the OpenDaylight-controlled switches.

# References

1.  [OpenDaylight Documentation](https://docs.opendaylight.org/en/latest/index.html)
2.  [OpenDaylight Project](https://www.youtube.com/@OpendaylightOrg/videos)
