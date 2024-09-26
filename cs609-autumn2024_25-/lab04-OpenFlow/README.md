<h1 align="center" style="border-bottom: 5px dotted">
   <p> Software-Defined Networking and Network Function Virtualization</p>
    <p> CS 609, Autumn 2024-25, Indian Institute of Technology Dharwad </p>
    Tuesday, 10th September 2024, Worksheet - 04 (OpenFlow)

</h1>


<!---
## Lab - 04: OpenFlow

### 01-initial-setup
-->
We shall install Anaconda here. To start with, we shall install __curl__ and required packages. Then we shall downloadAnaconda, followed by the installation. Run the following script in your terminal to install the required packages:
   
    script03-ubuntu-install-stage02-anaconda-pre-install.sh 

Once completed, run the following script to  initialize conda after the installation process is done:

    script04-ubuntu-install-stage02-anaconda-post-install.sh

To create the required environment, run the following command. The name of the environment is __env01-ryu__.

    script05-anaconda-environment-creation.sh

Type the following command in your terminal and follow the output to activate the environment:

    script06-anaconda-environment-enter.sh


### 02-open-flow-

-   code01-install-mininet-in-python-environment.sh
-   code02-static-flow.py
-   mininet/
-   oflops/
-   oftest/
-   openflow/
-   pox/


### 03-tshark-

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



### 04-ryu-

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


