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
3. [Working with TShark](#ts)
4.  [Working with Ryu](#ry)

---

##  1. Preparing the environment <a name="pr"></a>

1.  Clone the GitHub repository: https://github.com/rajdeepbaru/525a1.git
2.  Change your _present working directory_ to _lab04-OpenFlow/_, using the following code snippet:
    
```shell 
cd 525a1/cs609-autumn2024_25-/lab04-OpenFlow/
```

3.  Go to the required location using the following hints:

```shell
cd 01-initial-setup/
```
4.  Run the following script to start installing the package [Anaconda](https://docs.anaconda.com/).

```shell
bash script03-ubuntu-install-stage02-anaconda-pre-install.sh
```

5.  After the completion of installation, use the following script to initialize _conda_ use the following command in your terminal:

```shell
bash script04-ubuntu-install-stage02-anaconda-post-install.sh
```

6.  To create our desired _virtual environment_, use the following command.
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

    -   Note: after executing the above four commands, the output should be similar to the following image ((env01-ryu) should be visible at the left-most end of the prompt string 1. If not, do not proceed further, and raise your hand, the TA will be solving the issue with you.)
4.  Make sure that (env01-ryu) is visible at the left-most end, as shown in the picture.


We shall install Anaconda here. To start with, we shall install __curl__ and required packages. Then we shall downloadAnaconda, followed by the installation. Run the following script in your terminal to install the required packages:
   
    script03-ubuntu-install-stage02-anaconda-pre-install.sh 

Once completed, run the following script to  initialize conda after the installation process is done:

    script04-ubuntu-install-stage02-anaconda-post-install.sh

To create the required environment, run the following command. The name of the environment is __env01-ryu__.

    script05-anaconda-environment-creation.sh

Type the following command in your terminal and follow the output to activate the environment:

    script06-anaconda-environment-enter.sh



## 2.   Working with OpenFlow <a name="of"></a>


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
    -   three hosts: h1, h2, and h3, with IP 10.10.10.1, 10.10.10.2, and 10.10.10.1, respectively
    -   a switch s1, and
    -   links between the hosts and switch, and
    -   the default OpenFlow controller


---

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


