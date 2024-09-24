## [lab04-OpenFlow](cs609-autumn2024_25-/lab04-OpenFlow)

### 01-initial-setup

-   script03-ubuntu-install-stage02-anaconda-pre-install.sh
-   script04-ubuntu-install-stage02-anaconda-post-install.sh
-   script05-anaconda-environment-creation.sh
-   script06-anaconda-environment-enter.sh


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
