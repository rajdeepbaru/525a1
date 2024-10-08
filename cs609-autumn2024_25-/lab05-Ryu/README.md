<h2 align="center" style="border-bottom: 5px dotted">
   <p> Software-Defined Networking and Network Function Virtualization, (CS-609)</p>
    <p> Autumn 2024-25, Indian Institute of Technology Dharwad </p>
    

</h2>


<!---
## Lab - 04: OpenFlow

### 01-initial-setup
-->



#   Lab Worksheet 05: Tuesday morning session, 08th October 2024. 

**Lab objective:** The following are the broad overview for toady's lab session.
-   We shall see an existing *switching hub* application implementation. Also we shall learn to use it.
-   We shall use an existing implementation to add a function to monitor OpenFlow switch statistical information to the switching hub.
-   We shall learn how to add a *REST link function* to the *switching hub*.


<!---

### Table of contents
1. [Preparing the environment](#pr)
2. [Working with OpenFlow](#of)
    -   [2.1    Preparing the environmnet for OpenFlow](#pro  )
    -   [2.2    The OpenFlow topology with static flows](#of)  
        -   [2.2.1  What will we solve?](#ww)  
        -   [2.2.2  Naming convention](#nc)  
        -   [2.2.3  Problem at hand](#ph)  
        -   [2.2.4  Solution](#sol1)  

3. [Working with TShark](#ts)
4. [Working with Ryu: first example](#ry1)
5. [Working with Ryu: Ryu with Tshark](#ry2)
6. [Working with Ryu: Create router](#ry3)
    -   [6.1    Create topology](#ct)
    -   [6.2    To set up hosts](#su)
7.	[Testing a remote desktop protocol](#rd)
8. [Reference](#ref)
--->

### Table of contents

1.	[Initialization step](#is)
2.  [Ryu SDN framework](#rf)
    -   2.1. [Switching Hub](#sh)  
            -   2.1.1 [Experiment objective and overview](#211)  
            -   2.1.2 [The Switching Hub by OpenFlow -- an intuitive algorithm](#212)  
            -   2.1.3 [Example of the above mentioned algorithm](#213)  
            -   2.1.4 [Relevant python code](#214)  
            -   2.1.5 [Our job is to execute the Ryu application and verify the output](#214)  
    -   2.2. [Traffic Monitor](#tm)
    -   2.3 [REST Linkage](#rl)
3.  [OpenFlow protocol](#la)
4.	[Reference](#r2)

---

<!---

##  1. Preparing the environment <a name="pr"></a>


<img src="../../.supporting-files/rdp02.gif" >

--->


**Notation:** We shall be working with two *terminals*, next to each other. In the follosing discussion, the words *first terminal* and *left terminal* are used interchangeably. Similarly, the words *second terminal* and *right terminal* are used interchangeably. 




##	1. Initialization step <a	name="is"></a>

### 1.1 How many terminals do we need here?

Two.

### 1.2 Execute the following steps in both of the terminals

1.	Please navigate to the *desired location*. By the term *desired location*, we mean that the *present working directory* should be `525a1`. To do so, run the following command:
```shell
cd 525a1/
```

2.	Please execute the following command at the *desired location* to fetch and download content from [this GitHub repository](https://github.com/rajdeepbaru/525a1/tree/main) and immediately update your *local repository* to match that content:
```shell
git pull
```

3.	Please activate the desired *virtual environment* `env01-ryu` by executing the following command:
```shell
conda activate env01-ryu
```

5.	Now we shall navigate to the subdirectory for todays lab session. To do so, execute the following command:
```shell
cd cs609-autumn2024_25-/lab05-Ryu/
```

6.  For example, you may refer to the follosing diagram:
<img src="../../.supporting-files/dia01.png" >

7..	We are all set to proceed to the following step.


---

## 2. Ryu SDN framework <a	name="rf"></a>

**What is Ryu?** According to [Ryu community](https://ryu-sdn.org/),  Ryu is a component-based software defined networking framework. Ryu provides software components with well defined API that make it easy for developers to create new network management and control applications. Ryu supports various protocols for managing network devices, such as OpenFlow, Netconf, OF-config, etc. About OpenFlow, Ryu supports fully 1.0, 1.2, 1.3, 1.4, 1.5 and Nicira Extensions. All of the code is freely available under the Apache 2.0 license.

> [!NOTE]
> Ryu means *flow* in Japanese. Ryu is pronounced *ree-yooh*.

###	2.1 Switching Hub	<a	name="sh"></a>
According to [A Comprehensive Guide to Switch Hubs: All You Need to Know](https://medium.com/@gbicfiber123/a-comprehensive-guide-to-switch-hubs-all-you-need-to-know-dadf642afbe9), a  *switching hub* is a vital networking tool that connects devices within a local area network (LAN). Its main responsibility is to effectively transmit data packets from one device to another. Unlike a *hub*, which sends data to all connected devices, a *switching hub* can intelligently identify the recipient of each packet and send it directly to them. This approach reduces network traffic and improves the performance of the entire network.


#### 2.1.1 Experiment objective and overview<a	name="211"></a>

-	**Experiment objective:** In this setup, we shall have a functioning *switching hub* using the Ryu controller that learns MAC addresses and reduces flooding.


-	**Brief overview:** Please read about [*Switching Hub*](https://book.ryu-sdn.org/en/html/switching_hub.html) before proceeding further.
-   **Functions of switching hub:** Switching hubs have a variety of functions. Here, we take a look at a switching hub having the following simple functions.
    -   Learns the MAC address of the host connected to a port and retains it in the MAC address table.
    -   When receiving packets addressed to a host already learned, transfers them to the port connected to the host.
    -   When receiving packets addressed to an unknown host, performs flooding.


#### 2.1.2 The *Switching Hub* by *OpenFlow* -- an intuitive algorithm<a	name="212"></a>

OpenFlow switches can perform the following by receiving instructions from OpenFlow controllers such as Ryu.

-   Rewrites the address of received packets or transfers the packets from the specified port.
-   Transfers the received packets to the controller (Packet-In).
-   Transfers the packets forwarded by the controller from the specified port (Packet-Out).

It is possible to achieve a switching hub having those functions combined.

-   First of all, you need to use the Packet-In function to learn MAC addresses.
    -   The controller can use the Packet-In function to receive packets from the switch. 
    -   The switch analyzes the received packets to learn the MAC address of the host and information about the connected port.
-   After learning, the switch transfers the received packets. 
    -   The switch investigates whether the destination MAC address of the packets belong to the learned host. 
    -   Depending on the investigation results, the switch performs the following processing.
-   If the host is already a learned host ... Uses the Packet-Out function to transfer the packets from the connected port.
-   If the host is unknown host ... Use the Packet-Out function to perform flooding.


#### 2.1.3 Example of the above mentioned algorithm<a	name="213"></a>

1.  **Initial status**

-   This is the initial status where the flow table is empty.
-   Assuming host A is connected to port 1, host B to part 4, and host C to port 3.

<img src="../../.supporting-files/morningDiagram01.png" >

2.  **Host A -> Host B**

-   When packets are sent from host A to host B, a Packet-In message is sent and the MAC address of host A is learned by port 1. Because the port for host B has not been found, the packets are flooded and are received by host B and host C.

<img src="../../.supporting-files/morningDiagram02.png" >

**Packet-In:**


`in-port: 1`  
`eth-dst: Host B`  
`eth-src: Host A`  



**Packet-Out:**


`action: OUTPUT:Flooding`  


3.  **Host B -> Host A**
-   When the packets are returned from host B to host A, an entry is added to the flow table and also the packets are transferred to port 1. For that reason, the packets are not received by host C.



<img src="../../.supporting-files/morningDiagram03.png" >


**Packet-In:**


`in-port: 4`  
`eth-dst: Host A`  
`eth-src: Host B`  



**Packet-Out:**


`action: OUTPUT:Port 1`  



4.  **Host A -> Host B**

-   Again, when packets are sent from host A to host B, an entry is added to the flow table and also the packets are transferred to port 4.


<img src="../../.supporting-files/morningDiagram04.png" >

**Packet-In:**


`in-port: 1`    
`eth-dst: Host B`   
`eth-src: Host A`    


**Packet-Out:**


`action: OUTPUT:Port 4`   

<!---

${\color{blue}Blue}$
--->

<!---
<code style="color : blue">text</code>
--->

#### 2.1.4 **Relevant python code:** <a	name="214"></a>


```python
# Copyright (C) 2016 Nippon Telegraph and Telephone Corporation.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_3
from ryu.lib.packet import packet
from ryu.lib.packet import ethernet


class ExampleSwitch13(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super(ExampleSwitch13, self).__init__(*args, **kwargs)
        # initialize mac address table.
        self.mac_to_port = {}

    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        datapath = ev.msg.datapath
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        # install the table-miss flow entry.
        match = parser.OFPMatch()
        actions = [parser.OFPActionOutput(ofproto.OFPP_CONTROLLER,
                                          ofproto.OFPCML_NO_BUFFER)]
        self.add_flow(datapath, 0, match, actions)

    def add_flow(self, datapath, priority, match, actions):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        # construct flow_mod message and send it.
        inst = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS,
                                             actions)]
        mod = parser.OFPFlowMod(datapath=datapath, priority=priority,
                                match=match, instructions=inst)
        datapath.send_msg(mod)

    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
    def _packet_in_handler(self, ev):
        msg = ev.msg
        datapath = msg.datapath
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        # get Datapath ID to identify OpenFlow switches.
        dpid = datapath.id
        self.mac_to_port.setdefault(dpid, {})

        # analyse the received packets using the packet library.
        pkt = packet.Packet(msg.data)
        eth_pkt = pkt.get_protocol(ethernet.ethernet)
        dst = eth_pkt.dst
        src = eth_pkt.src

        # get the received port number from packet_in message.
        in_port = msg.match['in_port']

        self.logger.info("packet in %s %s %s %s", dpid, src, dst, in_port)

        # learn a mac address to avoid FLOOD next time.
        self.mac_to_port[dpid][src] = in_port

        # if the destination mac address is already learned,
        # decide which port to output the packet, otherwise FLOOD.
        if dst in self.mac_to_port[dpid]:
            out_port = self.mac_to_port[dpid][dst]
        else:
            out_port = ofproto.OFPP_FLOOD

        # construct action list.
        actions = [parser.OFPActionOutput(out_port)]

        # install a flow to avoid packet_in next time.
        if out_port != ofproto.OFPP_FLOOD:
            match = parser.OFPMatch(in_port=in_port, eth_dst=dst)
            self.add_flow(datapath, 1, match, actions)

        # construct packet_out message and send it.
        out = parser.OFPPacketOut(datapath=datapath,
                                  buffer_id=ofproto.OFP_NO_BUFFER,
                                  in_port=in_port, actions=actions,
                                  data=msg.data)
        datapath.send_msg(out)
```


**Various components of the above python modeule**

1.  **Class Definition and Initialization:** `class ExampleSwitch13`
2.  **Event Handler:** With Ryu, when an OpenFlow message is received, an event corresponding to the message is generated. The Ryu application implements an event handler corresponding to the message desired to be received.
3.  **Adding Table-miss Flow Entry:** After handshake with the OpenFlow switch is completed, the Table-miss flow entry is added to the flow table to get ready to receive the Packet-In message. Upon receiving the `switch_features_handler(self, ev)` Features Reply message, the Table-miss flow entry is added.
4.  **Packet-in Message:** Create the handler of the Packet-In event handler in order to accept received packets with an unknown destination.
5. **Updating the MAC Address Table:** In `def _packet_in_handler(self, ev):`, check the blocks under `get the received port number from packet_in message` and `learn a mac address to avoid FLOOD next time`
6. **Judging the Transfer Destination Port:** The strategy is:
    -   if the destination mac address is already learned, decide which port to output the packet, otherwise FLOOD.
    -   construct action list.
    -   install a flow to avoid packet_in next time.
7.  **Adding Processing of Flow Entry:** construct flow_mod message and send it.
8. **Packet Transfer:** Regardless whether the destination MAC address is found from the MAC address table, at the end the Packet-Out message is issued and received packets are transferred.

#### 2.1.5 Our job is to execute the Ryu application and verify the output<a	name="215"></a>

1.  We shall create a Mininet network with one switch and three hosts connected to it. We shall assign MAC addresses to the hosts automatically, use Open vSwitch for the switch, connects to a remote SDN controller, and try to open a terminal interface for each node. To do so, execute the following command in the *right termianl* or equivalently *second terminal*.
```shell
sudo mn --topo single,3 --mac --switch ovsk --controller remote -x
```

You may refer the following situationn for a reference.
<img src="../../.supporting-files/lab05-vid01.gif" >

2.  Let us check the status of the Open vSwitch. To do so, execute the following command in the *right terminal*:
```shell
sh ovs-vsctl show
```

You should get an output similar to the following reference:

<img src="../../.supporting-files/dia02.png" >

3.  We shall print  a summary of configured datapaths, including their datapath numbers and a list of ports  connected  to  each  datapath. To do so, execute the following in  the *right terminal*:
```shell
sh ovs-dpctl show
```
You should get an output similar to the following reference:


<img src="../../.supporting-files/dia03.png" >

4.  We shall set 1.3 for the OpenFlow version:

To do so, execute the following in  the *right terminal*:
```shell
ovs-vsctl set Bridge s1 protocols=OpenFlow13
```


5.  Let us check the empty flow table. To do so, execute the following in  the *right terminal*:
```shell
ovs-ofctl -O OpenFlow13 dump-flows s1
```

6. The overall process till now is stated below:

<img src="../../.supporting-files/lab05-vid02.gif" >

7. Execute the following command in the *left terminal*. It will start *ryu manager*.
```shell
ryu-manager --verbose ../lab04-OpenFlow/04-ryu-/01-ryu-install/ryu/ryu/app/example_switch_13.py 
```

You should a similar output similar to the following:

<img src="../../.supporting-files/dia04.png" >


> [!IMPORTANT]  
> Wait for ten seconds and you will see the following as output in the *left terminal*. This is because it may take time to connect to OVS.

<img src="../../.supporting-files/dia05.png" >


8.  You may verify your steps and outputs with the following reference:
<img src="../../.supporting-files/lab05-vid03.gif" >

**What happened?**
The OVS is connected, handshake is done, the Table-miss flow entry has been added and the switching hub is in the status waiting for Packet-In.

9.  Now we shall confirm that the Table-miss flow entry has been added. To do so, execute the following in the *right terminal*. <a	name="s9"></a>
```shell
sh ovs-ofctl -O openflow13 dump-flows s1
```

> [!NOTE]  
>  The output should be similar to `cookie=0x0, duration=45.666s, table=0, n_packets=2, n_bytes=140, priority=0 actions=CONTROLLER:65535`

> [!IMPORTANT]  
> - The priority level is 0,
> - match,
> - bytes 140,
> - CONTROLLER is specified for action, and transfer data size of 65535(0xffff = OFPCML_NO_BUFFER) is specified.


> [!CAUTION]
> Our experimental results slightly differs with the [results mentioned here](https://book.ryu-sdn.org/en/html/switching_hub.html#:~:text=The%20priority%20level%20is%200%2C%20no%20match%2C%20and%20CONTROLLER%20is%20specified%20for%20action%2C%20and%20transfer%20data%20size%20of%2065535(0xffff%20%3D%20OFPCML_NO_BUFFER)%20is%20specified). **Can you identify the difference between the two results?**


10. Please check all the network interfaces on your system. To do so, execute the following command:
```shell
sh ifconfig -a
```

You should see a output similar to the following:

<img src="../../.supporting-files/dia06.png" >


11. We shall check packets were received by the hosts. For `h1`, execute the following:
```shell
sh tcpdump -en -i s1-eth1
```
> [!NOTE]  
>  The output should be similar to  
> `tcpdump: verbose output suppressed, use -v[v]... for full protocol decode`   
> `listening on s1-eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes`  
>  `07:50:39.580864 00:00:00:00:00:02 > 33:33:00:00:00:02, ethertype IPv6 (0x86dd), length 70: fe80::200:ff:fe00:2 > ff02::2: ICMP6, router solicitation, length 16` 


> [!IMPORTANT]  
> The output in the *left terminal* is 
> `EVENT ofp_event->ExampleSwitch13 EventOFPPacketIn
> packet in 1 00:00:00:00:00:02 33:33:00:00:00:02 2`


12. For reference, you may look into the following video:
<img src="../../.supporting-files/lab05-vid04.gif">

13. To exit from the execution of the *right terminal*, press:

-   <Ctrl + c>

**Self evaluation quesion:** How many packets captured?

14. Execute each of the following commands and note your observation down.
-   `sh tcpdump -en -i s1-eth2`
-   `sh tcpdump -en -i s1-eth3`

15. Execute the following command to issue ping from host 1 to host 2:
```shell
mininet> h1 ping -c1 h2
```
You should see output similar to the following:   
`PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.`  
`64 bytes from 10.0.0.2: icmp_seq=1 ttl=64 time=2.80 ms`  
 
`--- 10.0.0.2 ping statistics ---`  
`1 packets transmitted, 1 received, 0% packet loss, time 0ms`  
`rtt min/avg/max/mdev = 2.799/2.799/2.799/0.000 ms` 

> [!NOTE]
> In the *first terminal*, you should see an output similar to the following:  
> `EVENT ofp_event->ExampleSwitch13 EventOFPPacketIn`  
> `packet in 1 00:00:00:00:00:01 ff:ff:ff:ff:ff:ff 1`  
> `EVENT ofp_event->ExampleSwitch13 EventOFPPacketIn`  
> `packet in 1 00:00:00:00:00:02 00:00:00:00:00:01 2`  
> `EVENT ofp_event->ExampleSwitch13 EventOFPPacketIn`  
> `packet in 1 00:00:00:00:00:01 00:00:00:00:00:02 1`  
  


13. For reference, you may look into the following video:
<img src="../../.supporting-files/lab05-vid05.gif">

14. We shall check the flow table. In the *right terminal*, execute the following command:
```shell
sh ovs-ofctl -O OpenFlow13 dump-flows s1
```

> [!NOTE]
> The output should be similar to the following:   
> `cookie=0x0, duration=20.055s, table=0, n_packets=2, n_bytes=140, priority=1,in_port="s1-eth2",dl_dst=00:00:00:00:00:01 actions=output:"s1-eth1"`  
> `cookie=0x0, duration=20.054s, table=0, n_packets=1, n_bytes=42, priority=1,in_port="s1-eth1",dl_dst=00:00:00:00:00:02 actions=output:"s1-eth2"`  
> `cookie=0x0, duration=260.171s, table=0, n_packets=8, n_bytes=532, priority=0 actions=CONTROLLER:65535`  


15. For reference, you may look into the following video:
<img src="../../.supporting-files/lab05-vid06.gif">


> [!IMPORTANT]  
> Compare this output with the output [above, in step 9](#s9).  

**What happened?**
-   Receive port (in_port):2, Destination MAC address (dl_dst):host 1 -> Action (actions):Transfer to port 1 
-   Receive port (in_port):1, Destination MAC address (dl_dst): host 2 -> Action (actions): Transfer to port 2

> [!CAUTION]
> Our experimental results slightly differs with the [results mentioned here](https://book.ryu-sdn.org/en/html/switching_hub.html). **Can you identify the difference between the two results?**




16. Let us take a look at the output of tcpdump executed on each host. To do so, execute the following command:
```shell
sh tcpdump -en -i s1-eth1
```


You should see an output similar to below in *right terminal*:  
`tcpdump: verbose output suppressed, use -v[v]... for full protocol decode`  
`listening on s1-eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes`  
`07:53:19.323956 00:00:00:00:00:01 > 33:33:00:00:00:02, ethertype IPv6 (0x86dd), length 70: fe80::200:ff:fe00:1 > ff02::2: ICMP6, router solicitation, length 16`  

In the *left terminal*, you should see an output similar to following:
`EVENT ofp_event->ExampleSwitch13 EventOFPPacketIn`  
`packet in 1 00:00:00:00:00:01 00:00:00:00:00:02 1`  


**Self evaluation quesion:** What is the output of tcpdump executed on `s1-eth2` and `s1-eth3`?



---




###	2.2 Traffic Monitor	<a	name="tm"></a>

-	**Brief overview:** Please read about [*Traffic Monitor*](https://book.ryu-sdn.org/en/html/traffic_monitor.html) before proceeding further.
-	**Experiment objective:** In this setup, we shall add a function to monitor OpenFlow switch statistical information to the switching hub.
-   **Motivation for this experiment:** Networks have already become the infrastructure of many services and businesses, so maintaining of normal and stable operation is expected. Having said that, problems always occur.
    -   When an error occurred on network, the cause must be identified and operation restored quickly. Needless to say, in order to detect errors and identify causes, it is necessary to understand the network status on a regular basis. For example, assuming the traffic volume of a port of some network device indicates a very high value, whether it is an abnormal state or is usually that way and when it became that way cannot be determined if the port’s traffic volume has not been measured continuously.
    -   For this reason, constant monitoring of the health of a network is essential for continuous and safe operation of the services or businesses that use that network. As a matter of course, simply monitoring traffic information does not provide a perfect guarantee but this section describes how to use OpenFlow to acquire statistical information for a switch.


**Relevant python code:** 

```shell
# Copyright (C) 2016 Nippon Telegraph and Telephone Corporation.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from operator import attrgetter

from ryu.app import simple_switch_13
from ryu.controller import ofp_event
from ryu.controller.handler import MAIN_DISPATCHER, DEAD_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.lib import hub


class SimpleMonitor13(simple_switch_13.SimpleSwitch13):

    def __init__(self, *args, **kwargs):
        super(SimpleMonitor13, self).__init__(*args, **kwargs)
        self.datapaths = {}
        self.monitor_thread = hub.spawn(self._monitor)

    @set_ev_cls(ofp_event.EventOFPStateChange,
                [MAIN_DISPATCHER, DEAD_DISPATCHER])
    def _state_change_handler(self, ev):
        datapath = ev.datapath
        if ev.state == MAIN_DISPATCHER:
            if datapath.id not in self.datapaths:
                self.logger.debug('register datapath: %016x', datapath.id)
                self.datapaths[datapath.id] = datapath
        elif ev.state == DEAD_DISPATCHER:
            if datapath.id in self.datapaths:
                self.logger.debug('unregister datapath: %016x', datapath.id)
                del self.datapaths[datapath.id]

    def _monitor(self):
        while True:
            for dp in self.datapaths.values():
                self._request_stats(dp)
            hub.sleep(10)

    def _request_stats(self, datapath):
        self.logger.debug('send stats request: %016x', datapath.id)
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        req = parser.OFPFlowStatsRequest(datapath)
        datapath.send_msg(req)

        req = parser.OFPPortStatsRequest(datapath, 0, ofproto.OFPP_ANY)
        datapath.send_msg(req)

    @set_ev_cls(ofp_event.EventOFPFlowStatsReply, MAIN_DISPATCHER)
    def _flow_stats_reply_handler(self, ev):
        body = ev.msg.body

        self.logger.info('datapath         '
                         'in-port  eth-dst           '
                         'out-port packets  bytes')
        self.logger.info('---------------- '
                         '-------- ----------------- '
                         '-------- -------- --------')
        for stat in sorted([flow for flow in body if flow.priority == 1],
                           key=lambda flow: (flow.match['in_port'],
                                             flow.match['eth_dst'])):
            self.logger.info('%016x %8x %17s %8x %8d %8d',
                             ev.msg.datapath.id,
                             stat.match['in_port'], stat.match['eth_dst'],
                             stat.instructions[0].actions[0].port,
                             stat.packet_count, stat.byte_count)

    @set_ev_cls(ofp_event.EventOFPPortStatsReply, MAIN_DISPATCHER)
    def _port_stats_reply_handler(self, ev):
        body = ev.msg.body

        self.logger.info('datapath         port     '
                         'rx-pkts  rx-bytes rx-error '
                         'tx-pkts  tx-bytes tx-error')
        self.logger.info('---------------- -------- '
                         '-------- -------- -------- '
                         '-------- -------- --------')
        for stat in sorted(body, key=attrgetter('port_no')):
            self.logger.info('%016x %8x %8d %8d %8d %8d %8d %8d',
                             ev.msg.datapath.id, stat.port_no,
                             stat.rx_packets, stat.rx_bytes, stat.rx_errors,
                             stat.tx_packets, stat.tx_bytes, stat.tx_errors)
```

**Components of the above python code**


-   **Fixed-Cycle Processing:** In parallel with switching hub processing, create a thread to periodically issue a request to the OpenFlow switch to acquire statistical information.
-   **FlowStats:** In order to receive a response from the switch, create an event handler that receives the FlowStatsReply message.
-   **PortStats:** In order to receive a response from the switch, create an event handler that receives the PortStatsReply message.



**Our job is to execute the Ryu application and verify the output:**

To do so, follow the steps.

1. Follow the [Initialization step](#is) for the two terminals.

2. To set OpenFlow13 for the OpenFlow version, execute the following steps in the *right terminal*:
```shell
sudo mn --topo single,3 --mac --switch ovsk --controller remote -x
```

```shell
sh ovs-vsctl show
```

```shell
sh ovs-dpctl show
```

```shell
sh ovs-vsctl set Bridge s1 protocols=OpenFlow13
```

3. To execute the traffic monitor, run the following in the *left terminal*:
```shell
ryu-manager --verbose ../lab04-OpenFlow/04-ryu-/01-ryu-install/ryu/ryu/app/simple_monitor_13.py
```

4. Do `ping` from `host 1` to `host 2`. The output will be similar to the following:

<img src="../../.supporting-files/dia07.png">



5. Do `pingall`. The output will be similar to the following:

<img src="../../.supporting-files/dia08.png">



6. For reference, you may look at the following video:

<img src="../../.supporting-files/lab05-vid07.gif">



**What happened?**

We did the following:
-   Thread generation method by Ryu application
-   Capturing of Datapath status changes
-   How to acquire FlowStats and PortStats


---



###	2.3 REST Linkage	<a	name="rl"></a>

We shall add a REST link function to the switching hub.

**Brief overview:** Please read about [*REST Linkage*](https://book.ryu-sdn.org/en/html/rest_api.html) before proceeding further.


**Integrating REST API:** Ryu has a Web server function corresponding to WSGI. By using this function, it is possible to create a REST API, which is useful to link with other systems or browsers.

**WSGI:** The term *WSGI* means a unified framework for connecting Web applications and Web servers in Python.

**Implementing a Switching Hub with REST API**

We shall add the following two REST APIs to the switching hub explained in *Switching Hub*.
1.  MAC address table acquisition API
    -   Returns the content of the MAC address table held by the switching hub. Returns a pair of MAC address and port number in JSON format.
2.  MAC address table registration API
    -   Registers a pair of MAC address and port number in the MAC address table and adds a flow entry to the switch.





**Relevant python code:** 

```python
# Copyright (C) 2016 Nippon Telegraph and Telephone Corporation.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import json

from ryu.app import simple_switch_13
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.app.wsgi import ControllerBase
from ryu.app.wsgi import Response
from ryu.app.wsgi import route
from ryu.app.wsgi import WSGIApplication
from ryu.lib import dpid as dpid_lib

simple_switch_instance_name = 'simple_switch_api_app'
url = '/simpleswitch/mactable/{dpid}'


class SimpleSwitchRest13(simple_switch_13.SimpleSwitch13):

    _CONTEXTS = {'wsgi': WSGIApplication}

    def __init__(self, *args, **kwargs):
        super(SimpleSwitchRest13, self).__init__(*args, **kwargs)
        self.switches = {}
        wsgi = kwargs['wsgi']
        wsgi.register(SimpleSwitchController,
                      {simple_switch_instance_name: self})

    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        super(SimpleSwitchRest13, self).switch_features_handler(ev)
        datapath = ev.msg.datapath
        self.switches[datapath.id] = datapath
        self.mac_to_port.setdefault(datapath.id, {})

    def set_mac_to_port(self, dpid, entry):
        mac_table = self.mac_to_port.setdefault(dpid, {})
        datapath = self.switches.get(dpid)

        entry_port = entry['port']
        entry_mac = entry['mac']

        if datapath is not None:
            parser = datapath.ofproto_parser
            if entry_port not in mac_table.values():

                for mac, port in mac_table.items():

                    # from known device to new device
                    actions = [parser.OFPActionOutput(entry_port)]
                    match = parser.OFPMatch(in_port=port, eth_dst=entry_mac)
                    self.add_flow(datapath, 1, match, actions)

                    # from new device to known device
                    actions = [parser.OFPActionOutput(port)]
                    match = parser.OFPMatch(in_port=entry_port, eth_dst=mac)
                    self.add_flow(datapath, 1, match, actions)

                mac_table.update({entry_mac: entry_port})
        return mac_table


class SimpleSwitchController(ControllerBase):

    def __init__(self, req, link, data, **config):
        super(SimpleSwitchController, self).__init__(req, link, data, **config)
        self.simple_switch_app = data[simple_switch_instance_name]

    @route('simpleswitch', url, methods=['GET'],
           requirements={'dpid': dpid_lib.DPID_PATTERN})
    def list_mac_table(self, req, **kwargs):

        simple_switch = self.simple_switch_app
        dpid = kwargs['dpid']

        if dpid not in simple_switch.mac_to_port:
            return Response(status=404)

        mac_table = simple_switch.mac_to_port.get(dpid, {})
        body = json.dumps(mac_table)
        return Response(content_type='application/json', text=body)

    @route('simpleswitch', url, methods=['PUT'],
           requirements={'dpid': dpid_lib.DPID_PATTERN})
    def put_mac_table(self, req, **kwargs):

        simple_switch = self.simple_switch_app
        dpid = kwargs['dpid']
        try:
            new_entry = req.json if req.body else {}
        except ValueError:
            raise Response(status=400)

        if dpid not in simple_switch.mac_to_port:
            return Response(status=404)

        try:
            mac_table = simple_switch.set_mac_to_port(dpid, new_entry)
            body = json.dumps(mac_table)
            return Response(content_type='application/json', text=body)
        except Exception as e:
            return Response(status=500)
```



**Executing REST API Added Switching Hub**

1. Follow the [Initialization step](#is) for the two terminals.

2. To set OpenFlow13 for the OpenFlow version, execute the following steps in the *right terminal*:
```shell
sudo mn --topo single,3 --mac --switch ovsk --controller remote -x
```

```shell
sh ovs-vsctl show
```

```shell
sh ovs-dpctl show
```

```shell
sh sudo ovs-vsctl set Bridge s1 protocols=OpenFlow13
```

3. To execute the traffic monitor, run the following in the *left terminal*:
```shell
ryu-manager --verbose ../lab04-OpenFlow/04-ryu-/01-ryu-install/ryu/ryu/app/simple_switch_rest_13.py
```

<img src="../../.supporting-files/f1.png">



4. In the *right terminal*, execute the following:
```shell
h1 ping -c 1 h
```

> [!NOTE]
> `The output should be similar to following:`   
> `EVENT ofp_event->SimpleSwitchRest13 EventOFPPacketIn`   
> `packet in 0000000000000001 00:00:00:00:00:01 33:33:00:00:00:02 1`   
> `EVENT ofp_event->SimpleSwitchRest13 EventOFPPacketIn`   
> `packet in 0000000000000001 00:00:00:00:00:02 33:33:00:00:00:02 2`   
> `EVENT ofp_event->SimpleSwitchRest13 EventOFPPacketIn`   
> `packet in 0000000000000001 00:00:00:00:00:03 33:33:00:00:00:02 3`   
> `EVENT ofp_event->SimpleSwitchRest13 EventOFPPacketIn`   
> `packet in 0000000000000001 00:00:00:00:00:01 33:33:00:00:00:02 1`   
> `EVENT ofp_event->SimpleSwitchRest13 EventOFPPacketIn`   
> `packet in 0000000000000001 00:00:00:00:00:02 33:33:00:00:00:02 2`   
> `EVENT ofp_event->SimpleSwitchRest13 EventOFPPacketIn`   
> `packet in 0000000000000001 00:00:00:00:00:03 33:33:00:00:00:02 3`   


<img src="../../.supporting-files/f2.png">



<img src="../../.supporting-files/f3.png">






5. Let us execute REST API that acquires the MAC table of the switching hub. This time, use the curl command to call REST API. To do so, execute the following command:
```shell
curl -X GET http://127.0.0.1:8080/simpleswitch/mactable/0000000000000001
```

> [!TIP]
> The output in the *right terminal* should be similar to following:  
> `{"00:00:00:00:00:01": 1, "00:00:00:00:00:02": 2, "00:00:00:00:00:03": 3}`  


> [!CAUTION]
> Our experimental results slightly differs with the [results mentioned here](https://book.ryu-sdn.org/en/html/rest_api.html). **Can you identify the difference between the two results?**


> [!TIP]
> The output in the *left terminal* should be similar to following:  
> `(21634) accepted ('127.0.0.1', 58836)`  
> `127.0.0.1 - - [06/Oct/2024 16:12:17] "GET /simpleswitch/mactable/0000000000000001 HTTP/1.1" 200 180 0.000787`  

6. Now call REST API for updating of the MAC address table for each host. The data format when calling REST API shall be {``mac`` : ``MAC address``, ``port`` : Connection port number}.

```shell
curl -X PUT -d '{"mac" : "00:00:00:00:00:01", "port" : 1}' http://127.0.0.1:8080/simpleswitch/mactable/0000000000000001
```


> [!TIP]
> The output in the *right terminal* should be similar to following:  
> {"00:00:00:00:00:01": 1, "00:00:00:00:00:02": 2, "00:00:00:00:00:03": 3}



> [!CAUTION]
> Our experimental results slightly differs with the [results mentioned here](https://book.ryu-sdn.org/en/html/rest_api.html). **Can you identify the difference between the two results?**




> [!TIP]
> The output in the *left terminal* should be similar to following:  
> `(21634) accepted ('127.0.0.1', 59148)`  
> `127.0.0.1 - - [06/Oct/2024 16:14:20] "PUT /simpleswitch/mactable/0000000000000001 HTTP/1.1" 200 180 0.000377`  
> `EVENT ofp_event->SimpleSwitchRest13 EventOFPPacketIn`  
> `packet in 0000000000000001 00:00:00:00:00:03 33:33:00:00:00:02 3`  


4. Do `ping` from `host 1` to `host 2`. The output will be similar to the following:

```shell
h1 ping -c 1 h2
```
<img src="../../.supporting-files/f4.png">


> [!TIP]
> The output in the *right terminal* should be similar to following:
> `PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.`  
> `64 bytes from 10.0.0.2: icmp_seq=1 ttl=64 time=0.183 ms`  
> `--- 10.0.0.2 ping statistics ---`  
> `1 packets transmitted, 1 received, 0% packet loss, time 0ms`  
> `rtt min/avg/max/mdev = 0.183/0.183/0.183/0.000 ms`  

<img src="../../.supporting-files/f5.png">




> [!CAUTION]
> Our experimental results slightly differs with the [results mentioned here](https://book.ryu-sdn.org/en/html/rest_api.html). **Can you identify the difference between the two results?**



<!---
<img src="../../.supporting-files/dia07.png">
--->


5. Do `pingall`. Checl the output in both of the terminals.

<!---
<img src="../../.supporting-files/dia08.png">
--->


---


##	3. OpenFlow protocol	<a	name="la"></a>

There are *match*, *instructions* and *actions* defined in the OpenFlow protocol. 
-   **Match:** There are a variety of conditions that can be specified to match, and it grows each time OpenFlow is updated.
-   **Instruction:** The instruction is intended to define what happens when a packet corresponding to the match is received.
-   **Action:** The OFPActionOutput class is used to specify packet forwarding to be used in Packet-Out and Flow Mod messages. 

Please go through [OpenFlow Protocol](https://book.ryu-sdn.org/en/html/openflow_protocol.html) for the details.



---


##  4. Reference	<a	name="r2"></a>
-   [RYU SDN Framework: Ryubook 1.0 documentation](https://book.ryu-sdn.org/en/html/)
-   [Build SDN Agilely](https://ryu-sdn.org)
-   [A Comprehensive Guide to Switch Hubs: All You Need to Know](https://medium.com/@gbicfiber123/a-comprehensive-guide-to-switch-hubs-all-you-need-to-know-dadf642afbe9)
-   [Welcome to RYU the Network Operating System(NOS)](https://ryu.readthedocs.io/en/latest/)
-   [Writing Your Ryu Application](https://ryu.readthedocs.io/en/latest/developing.html)
-   [https://github.com/faucetsdn/ryu](https://github.com/faucetsdn/ryu)

<!---
test
--->
---

[comment]: # (Comment)





