<h1 align="center" style="border-bottom: 5px dotted">
   <p> Software-Defined Networking and Network Function Virtualization</p>
    <p> CS 609, Autumn 2024-25, Indian Institute of Technology Dharwad </p>
    Tuesday, 10th September 2024, Worksheet - 04 (OpenFlow)

</h1>


<!---
## Lab - 04: OpenFlow

### 01-initial-setup
-->

#   Lab 04

---

### Table of contents
1. [Preparing the environment](#pr)
2. [Working with OpenFlow](#of)
    -   [2.1    Preparing the environmnet for OpenFlow](#pro)
    -   [2.2    The OpenFlow topology with static flows](#of)
        -   [2.2.1  What will we solve?](#ww)
        -   [2.2.2  Naming convention](#nc)
        -   [2.2.3  Problem at hand](#ph)
        -   [2.2.4  Solution](#sol1)

3. [Working with TShark](#ts)
4.  [Working with Ryu](#ry)

---

##  1. Preparing the environment <a name="pr"></a>

1.   Check your Gmail inbox, search for the email titled as *Reg. Software Defined Networking and Network Function Virtualization (CS-609), Autumn 2024-25* sent on *Tuesday, 20th August 2024* between 5 p.m. to 7 p.m. If the provided IP address is AB.CDE.EF.GHI, then type the following:

```shell
ssh-keygen -R AB.CDE.EF.GHI
```
>   [!NOTE] 
>   Choose "yes" when prompt is appeared in your terminal.
>

2.  Clone the GitHub repository using the following command:

```shell
git clone https://github.com/rajdeepbaru/525a1.git
```

3.  Change your _present working directory_ to _lab04-OpenFlow/_, using the following code snippet:
    
```shell 
cd 525a1/cs609-autumn2024_25-/lab04-OpenFlow/
```

4.  Go to the required location using the following hints:

```shell
cd 01-initial-setup/
```
5.  Run the following script to start installing the package [Anaconda](https://docs.anaconda.com/).

```shell
bash script03-ubuntu-install-stage02-anaconda-pre-install.sh
```

6.  After the completion of installation, use the following script to initialize _conda_ use the following command in your terminal:

```shell
bash script04-ubuntu-install-stage02-anaconda-post-install.sh
```

7.  To create our desired _virtual environment_, use the following command.
```shell
bash script05-anaconda-environment-creation.sh
```
>   [!NOTE] 
>   We shall be working on the environment named _env01-ryu_.
>
To do so, execute the following command:
```shell
source script06-anaconda-environment-enter.sh
```

>   [!WARNING] 
>   After executing the above four commands, the output should be similar to the following image. Make sure that *(env01-ryu)* should be visible at the left-most end of the prompt string 1. If not, do not proceed further, and raise your hand, the TA will be solving the issue with you.
>

>   [!CAUTION]
>   Make sure that *(env01-ryu)* is visible at the left-most end. Otherwise fix the issue without proceeding further.
>

<img src="../../.supporting-files/img01-env01-ryu.png" >

## 2.   Working with OpenFlow <a name="of"></a>

Move to the proper location by executing the following command:

```shell
cd ../02-open-flow-/
```

### 2.1 Preparing the environmnet for OpenFlow<a name="pro"></a>


1.  To install _mininet_ python library, run the following ccommand:

```shell
bash code01-install-mininet-in-python-environment.sh
```

2.  Check that there already exists an output file. You may check it using the below command.

```shell
ls | grep run
```

3. To delete it, execute the following command:

```shell
rm output01-static-flow.run
```
4. After deletion, cross-verify whether deletion is completed successfully or not. To do so, execute the following command:

```shell
ls | grep run
```
Match the output with the below snapshot.

<img src="../../.supporting-files/img02-remove-existing-output-in-openflow.png" >


### 2.2 The OpenFlow topology with static flows <a name="of"></a>


####    2.2.1  What will we solve? <a name="ww"></a>

OpenFlow topology with static flows.

####    2.2.2   Naming convention <a name="nc"></a>


1.  Hosts: h1, h2, h3
2.  OVSSwitch: s1
3.  Controller: c0
4.  Bridge: br0

####    2.2.3   Problem at hand <a name="ph"></a>


We shall create a network topology and execute a few open-flow commands.

1.  Create a network using
    -   Mininet’s built-in OpenFlow reference controller (controller), and
    -   The OVSSwitch
2.  Add the following:
    -   three hosts: h1, h2, and h3, with IP 10.10.10.1, 10.10.10.2, and 10.10.10.1, respectively, and
    -   a switch s1, and
    -   links between the hosts and switch, and
    -   the default OpenFlow controller
3.  Start the network
4.  Initialize the  Open vSwitch database
5.  Print the following:
    -   a brief overview of the database contents
6.  Create a new bridge named br0
7.  Enable OpenFlow 1.0, 1.1, 1.2, and 1.3 on br0
8.  Print the following:
    -   OpenFlow version of the switch
    -   Print information on the switch to the console, including information on its flow tables and ports
    -   Print the statistics for each flow table the switch uses to the console.
    -   Print to the console statistics for network devices associated with the switch.
    -   Print switch's fragment handling mode.
    -   Print to the console all flow entries in the switch's tables that match flows.
    -   Print to the console aggregate statistics for flows in the switch's tables that match flows.
    -   Print to the console statistics for the specified queue on the port within the switch.
    -   Print to the console the statistics of bridge IPFIX for the switch.
    -   Print to the console the statistics of flow-based  IPFIX  for the switch.
    -   Print the list of protocols
9.  Apply the static rules:
    -   Forwarding rules between h1 and h2
        -   Traffic from h1 is forwarded to h2
        -   Traffic from h2 is forwarded to h1
    -   Forwarding rules between h1 and h3
        -   Traffic from h1 is forwarded to h3
        -   Traffic from h3 is forwarded to h1
    -   Forwarding rules between h2 and h3
        -   Traffic from h2 is forwarded to h3
        -   Traffic from h3 is forwarded to h2
10. Verify the connectivity between the three hosts.

> [!TIP]
> The code is given bellow. Study the components of the code with the statements of the above questions.

```python
from mininet.net import Mininet
from mininet.node import OVSSwitch, Controller
from mininet.cli import CLI
from mininet.log import setLogLevel
import time



def lab_on_10september2024():
    # Create a Mininet network with an OpenFlow switch and controller
    net = Mininet(controller=Controller, switch=OVSSwitch)

    # Add three hosts
    h1 = net.addHost('h1', ip='10.10.10.1')
    h2 = net.addHost('h2', ip='10.10.10.2')
    h3 = net.addHost('h3', ip='10.10.10.3')

    # Add a switch
    s1 = net.addSwitch('s1')

    # Create links between the hosts and switch
    net.addLink(h1, s1)
    net.addLink(h2, s1)
    net.addLink(h3, s1)

    # Add default OpenFlow controller
    net.addController('c0')

    # Start the network
    net.start()
    
    
    
  
    
    #print("Switch connected to controller with OpenFlow version:")
    print(s1.cmd('ovs-vsctl init'))
    
    
    print(s1.cmd('ovs-vsctl show'))
    
    
    print(s1.cmd('ovs-vsctl add-br br0'))
    
    
    print(s1.cmd('ovs-vsctl set bridge br0 protocols=OpenFlow10,OpenFlow12,OpenFlow13'))
   
    print(s1.cmd('ovs-ofctl -V'))
    
    
    print(s1.cmd('ovs-ofctl show br0'))
    
    print(s1.cmd('ovs-ofctl dump-tables br0'))
    
    print(s1.cmd('ovs-ofctl dump-ports br0'))
    
    print(s1.cmd('ovs-ofctl get-frags br0'))
    
    print(s1.cmd('ovs-ofctl dump-flows br0'))
    
    print(s1.cmd('ovs-ofctl dump-aggregate br0'))
    
    print(s1.cmd('ovs-ofctl queue-stats br0'))
    
    print(s1.cmd('ovs-ofctl dump-ipfix-bridge br0'))
    
    print(s1.cmd('ovs-ofctl dump-ipfix-flow br0'))
    

    # Show OpenFlow version of the switch
    print("Switch connected to controller with OpenFlow version:")


    print(s1.cmd('ovs-vsctl get bridge br0 protocols'))

    # Add static OpenFlow rules using ovs-ofctl
    # Rule 1: Forward packets from h1 to h2 (through port 2)
    print("Rule 1 starts here")
    print(s1.cmd('ovs-ofctl add-flow s1 priority=10,in_port=1,actions=output:2'))
    print("Rule 1 ends here")

    # Rule 2: Forward packets from h2 to h1 (through port 1)
    print(s1.cmd('ovs-ofctl add-flow s1 priority=10,in_port=2,actions=output:1'))
    print("Rule 2 ends here")

    # Rule 3: Forward packets from h1 to h3 (through port 3)
    s1.cmd('ovs-ofctl add-flow s1 priority=10,in_port=1,actions=output:3')
    print("Rule 3 ends here")

    # Rule 4: Forward packets from h3 to h1 (through port 1)
    s1.cmd('ovs-ofctl add-flow s1 priority=10,in_port=3,actions=output:1')
    print("Rule 4 ends here")

    # Rule 5: Forward packets from h2 to h3 (through port 3)
    s1.cmd('ovs-ofctl add-flow s1 priority=10,in_port=2,actions=output:3')
    print("Rule 5 ends here")

    # Rule 6: Forward packets from h3 to h2 (through port 2)
    s1.cmd('ovs-ofctl add-flow s1 priority=10,in_port=3,actions=output:2')
    print("Rule 6 ends here")

    # Test connectivity by pinging between hosts
    print("Testing connectivity with pingall:")
    net.pingAll()

    # Open Mininet CLI for further testing and debugging
    #CLI(net)

    # Stop the network
    net.stop()

if __name__ == '__main__':
    print("This is CS609 Lab. Execution starts")
    time.sleep(5)
    lab_on_10september2024()
    print("Execution ends")
    time.sleep(5)
```

####    2.2.4   Solution  <a name="sol1"></a>

1.  Run the following command in the terminal to execute it:

```shell
sudo python3 code02-static-flow.py
```

2.  Check the following execution for hints.
<img src="../../.supporting-files/vid01-staticFlowExecution.gif" >

---

3.	To save the output, use the following command:

```shell
sudo python3 code02-static-flow.py >> output01-static-flow.run
```

4.	To view the output, the the follosing command:
```shell
vim output01-static-flow.run
```

5.	To return to the terminal, use the follosing command:
```shell
	-	:
	-	q
	-	!
	-	<Press the Enter key.>




## Working with TShark <a name="ts"></a>

To install tshark run the following command:

    bash 01-tshark-install.sh

Once installation is completed at your terminal, use the following command to check the version:

    02-tshark-version-check.sh

-   03-tshark-add-to-group.sh
-   04-tshark-capture-packets.sh
-   05-tshark-list-of-all-interfaces.sh
-   06-tshark-scan-one-network-interface.sh
-   07-tshark-capture-ten-packets.sh
-   output01.this-is-the-result



## Working with Ryu <a name="ry"></a>

-   01-ryu-install/
    *   ryu/
    *   script07-install-ryu-and-test.sh

2. 02-experiment-with-ryu/
    *   code02-test.py
    *   code-for-ryu-controller.py
    *   \_\_pycache__/

3. 03-create-router/
    *   code01-copy-custom-topology.sh
    *   code02-run-custom-topology.sh
    *   code03-do-pingall.sh
    *   code04-setupHosts-via-cli.sh
    *   code04-setupHosts-via-xterm.sh
    *   mytopo.py




<!---
test
--->
---

[comment]: # (Comment)





