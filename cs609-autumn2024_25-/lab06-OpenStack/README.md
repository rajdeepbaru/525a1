<h2 align="center" style="border-bottom: 5px dotted">
   <p> Software-Defined Networking and Network Function Virtualization (CS-609)</p>
    <p> Autumn 2024-25, Indian Institute of Technology Dharwad </p>
    <p> Lab Worksheet 06, Tuesday morning session, 22nd October 2024 </p>
    

</h2>

<h2 align="center" style="border-bottom: 5px dotted">
   <p> Topic covered: OpenStack </p>
    

</h2>



<!---
## Lab - 04: OpenFlow

### 01-initial-setup
-->
<!---
### Table of contents 
1.	[Some understanding](#1)
    -   1.1.  [What is ONOS?](#1.1)
    -   1.2.  [Features of ONOS](#1.2)

2.  [Installation of ONOS and its verification](#2)
    -   2.1. [Specifications we shall be using for this lab worksheet](#2.1)
    -   2.2. [Synchronize your working directory and navigate to the desired location](#2.2)
    -   2.3. [Preparation of the ground for installation of ONOS](#2.3)
        -   2.3.1. [Working with docker](#2.3.1)
        -   2.3.2. [Working with Distrobox](#2.3.2)
    -   2.4 [Installing ONOS on a single machine](#2.4)
    -   2.5. [Cross-checking the installation process](#2.5)

3. [Starting the components of ONOS](#3)
    -   3.1. [Starting Karaf](#2.6)
        -   3.1.1. [What is Karaf?](#2.6.1)
        -   3.1.2. [An example](#2.6.2)
        -   3.1.3. [How is it related to ONOS?](#2.6.3)
        -   3.1.4. [Starting Karaf CLI in a new terminal](#2.6.4)
    -   3.2. [Running ONOS as a service](#2.7)
        -   3.2.1.  [Install the service files](#271)
        -   3.2.2.  [Steps for Systemd based systems](#272)
    -   3.3. [Accessing the ONOS GUI](#29)
    -   3.4. [Starting ONOS CLI in a new terminal](#28)
4.  [Working with some ONOS CLI using some commands](#4)
    -   onos:ui-views 
    -   onos:ui-prefs
    -   maps
    -   exports
    -   info
    -   onos:ui-prefs 
    -   metrics
    -   bundle:info
    -   system:name and system:version
    -   bundle:classes
    -   feature-list
    -   bundle:list 
    -   bundle:services
    -   driver-providers
5.  [Mininet and ONOS](#5)
6.  [References](#6)
-->

---
### Table of contents 

0.  [Cross-checking the desktop environment](#0)
    -   0.1.    [Operating system used](#0.1)
    -   0.2.    [Installing packages](#0.2)

1.	[How to configure the environment](#1)
    -   1.1.    [Network Time Protocol ](#1.1)
    -   1.2.    [OpenStack packages](#1.2)
    -   1.3.    [SQL database](#1.3)
    -   1.4.    [Message queue](#1.4)
    -   1.5.    [Memcached](#1.5)
    -   1.6.    [Etcd](#1.6)

2.  [OpenStack services](#2)
    -   2.1. [To do](#2.1)
 
**Lab objective:** 
<!--- The objective of performing an ONOS Lab (Open Network Operating System Lab) typically revolves around understanding and experimenting with the capabilities of ONOS, a software-defined networking (SDN) controller platform. The specific objectives for today's lab is to do some experimenting with *SDN Concepts using ONOS*. 
--->

---


# 0. Cross-checking the desktop environment

## 0.1. Operating system used

1.  **Operating system with version:** Ubuntu 20.04. Please cross-verify the system you are using before proceeding further. 
<h2 align="center" >
<img src="f0601.png" >
</h2>

2. All the following steps are done in a dektop kept at 525-A1. Note the details:
    -   the IP is `10.230.3.154` 
    -   the username is `rajdeep`
    -   the password is `sdn`

> [!NOTE] 
> In case you are stuck, you may verify the corresponding step with the system with IP `10.230.3.154`


## 0.2 Installing packages
Please execute the following command in your terminal:

```shell
bash ../../.supporting-files/lab06-openstack/installAll-for-lab06.sh
```

2. Please clone the GitHub repository by using the following command in your terminal:
```shell
git clone https://github.com/rajdeepbaru/525a1.git
```

3. Please navigate to the desired directory for today's lab session by using the following command in your terminal:
```shell
cd 525a1/cs609-autumn2024_25-/lab06-OpenStack/

```

#   1.	How to configure the environment



##  1.1.    Network Time Protocol 

### 1.1.1. Synchronize Time with NTP in Your PC by configuring 

1. Please follow the [NTP Synchronize steps mentioned at our intranet by our CCS team](https://intranet.iitdh.ac.in:444/CCS.php).


2. After following all the steps mentioned there, you should get an output similar to the following when you will type `vim /etc/ntp.conf` in your terminal.
<p align="center" >
<img src="f0602.png" >
</p>
<p align="center" >
<img src="f0603.png" >
</p>

3. You may check whether *ntp* is installed or not by using `sudo apt list --installed | grep ntp`.


### 1.1.2. Controller node

1. **Do edit:**  Edit the `chrony.conf` file and add, change, or remove the following keys as necessary for your environment. To do so, type the following in your terminal:
```shell
sudo vim /etc/chrony/chrony.conf
```




2. Then press `i` and add the following line in the file.
```shell
server ntp.iitdh.ac.in iburst
```

and comment the following four lines by placing a hash symbol at the beginning of each of the four lines.  
`pool ntp.ubuntu.com        iburst maxsources 4`   
`pool 0.ubuntu.pool.ntp.org iburst maxsources 1`  
`pool 1.ubuntu.pool.ntp.org iburst maxsources 1`  
`pool 2.ubuntu.pool.ntp.org iburst maxsources 2` 





3. **Enable other nodes:** To enable other nodes to connect to the chrony daemon on the controller node, add the following key to the  `chrony.conf` file mentioned above:
```shell
allow 10.230.0.0/20
```
You may verify with the following situation:

<p align="center" >
<img src="i34.png" >
</p>

> [!NOTE] 
>  Please make sure to modify the value `10.230.0.0/20` accordingly. Note that the value is correct fro *525-A1 Lab*. For *512-A1 Lab*, the value should be identical, verify by yourself and then proceed.


<p align="center" >
<img src="i08.png" >
</p>



4. **Do restart:** Restart the NTP service by using the following command:
```shell
service chrony restart
```
You may verify with the following situation:

<p align="center" >
<img src="f0606.png" >
</p>

> [!CAUTION]
> You see an error saying `Failed to restart chrony.service: Unit chrony.service is masked.` as mentioned below:
>
> <p align="center" > <img src="06error.png" >  </p> 
> 
> In that check the output of the following commands: 
>   -   `systemctl status chrony.service`,
>   -    `systemctl unmask chrony.service`, and 
>   -   `service chrony restart`.  
>   
> The error should be resolved.

<p align="center" >
<img src="crkk.png" >
</p>








### 1.1.4. Verifying NTP synchronization

1. Please execute the following command and cross-verify the corresponding output:
```shell
chronyc sources
```
You should get an output similar to following:
<h2 align="center" >
<img src="f0607.png" >
</h2>

> [!CAUTION]
> In case you see an error saying `Command 'chronyc' not found, but can be installed with: sudo apt install chrony`. 
>  
> <p align="center" > <img src="ec.png" >  </p> 
> 
> 
>  
> In that case, execute the following: 
>   -   `sudo apt install chrony`
>   -   `service chrony restart`
>   -   `chronyc sources`
>  
>  <p align="center" > <img src="cr.png" >  </p> 
>  
> The error should be resolved.



2. Optionally you may verify as follows:

```shell
chronyc sourcestats
```
<h2 align="center" >
<img src="f0608.png" >
</h2>




##  1.3.    SQL database

1. Create and edit the /etc/mysql/mariadb.conf.d/99-openstack.cnf 
```shell
sudo touch /etc/mysql/mariadb.conf.d/99-openstack.cnf
```

2. Open using *vim* and add the follwoing:
```shell
sudo vim /etc/mysql/mariadb.conf.d/99-openstack.cnf
```
 and then add the following lines.



> [!NOTE] 
> To *start writing* or *adding characters* in *vim*, press the `i` button and then you may proceed for entering characters. To *save and exit* from *vim*, press the following sequence:
>	-	:
>	-	w
>	-	q
>	-	\<Press the Enter button\>



`[mysqld]`  
`bind-address = 10.0.0.154`  

> [!NOTE]
> Modify the address `10.0.0.154` according to your system. Note that the value `10.0.0.154` is correct for *525-A1*. For *512-A1*, calculate the value seeing the output of *ifconfig*. It should be `10.0.0.T` where `T` is the *last octate of your IP*. Please cross-verify.


After the cross-verification, add the following in the same file.

`default-storage-engine = innodb`  
`innodb_file_per_table = on`  
`max_connections = 4096`  
`collation-server = utf8_general_ci`  
`character-set-server = utf8`  


Save the file. You may take help from the following snapshot.

<h2 align="center" >
<img src="i09.png" >
</h2>


3. Restart the database service
```shell
service mysql restart
```
<h2 align="center" >
<img src="f0609.png" >
</h2>



4. Use the following steps  to secure the database. 



> [!NOTE] 
> In below, please provide password `abc` when prompted `Enter current password for root (enter for none):`   
>   



 
```shell
sudo mysql_secure_installation
```
<h2 align="center" >
<img src="f0610.png" >
</h2>

> [!WARNING]   
> If you see an error like `ERROR 1698 (28000): Access denied for user 'root'@'localhost'`, try the following steps:  
> `sudo mysql -u root`  
> `use mysql;`   
> `flush privileges;`  
> `exit` 
> and then try `sudo mysql_secure_installation` again.


> [!NOTE]   
> In the system 10.230.3.154, the *database password* is *abc*.
> 



##  1.4.    Message queue

1. To add the `openstack` user, use the following code:
```shell
rabbitmqctl add_user openstack def
```

> [!NOTE] 
> `def` is the password for the user


2. Permit configuration, write, and read access for the openstack user:
```shell
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
``` 
You may take help from the following snapshot.

<h2 align="center" >
<img src="i12.png" >
</h2>





##  1.5.    Memcached

1. Edit the `/etc/memcached.conf` file and configure the service to use the management IP address of the controller node. This is to enable access by other nodes via the management network. To do so, follow the steps:
```shell
sudo vim /etc/memcached.conf 
```

2. Then find the line containing `-l 127.0.0.1` and make it `-l 10.230.3.154`. Do not forget to replace with the correct IP address.
<h2 align="center" >
<img src="i13.png" >
</h2>

3. Restart the Memcached service using the following command:
```shell
service memcached restart
```
You may take help from the following snapshot.

<h2 align="center" >
<img src="i14.png" >
</h2>




##  1.6.    Etcd

1. Change user by `sudo su -`.

2. Type the following in your terminal:

```shell
echo "ETCD_NAME=\"controller\" " >> /etc/default/etcd
```

followed by

```shell
echo "ETCD_DATA_DIR=\"/var/lib/etcd\" " >> /etc/default/etcd
```

followed by

```shell
echo "ETCD_INITIAL_CLUSTER_STATE=\"new\"  " >> /etc/default/etcd
```

followed by

```shell
echo "ETCD_INITIAL_CLUSTER_TOKEN=\"etcd-cluster-01\" " >> /etc/default/etcd
```

followed by

```shell
echo "ETCD_INITIAL_CLUSTER=\"controller=http://10.230.3.154:2380\" " >> /etc/default/etcd
```

followed by

```shell
echo "ETCD_INITIAL_ADVERTISE_PEER_URLS=\"http://10.230.3.154:2380\" " >> /etc/default/etcd
```

followed by

```shell
echo "ETCD_ADVERTISE_CLIENT_URLS=\"http://10.230.3.154:2379\" " >> /etc/default/etcd
```

followed by

```shell
echo "ETCD_LISTEN_PEER_URLS=\"http://0.0.0.0:2380\" " >> /etc/default/etcd
```

followed by

```shell
echo "ETCD_LISTEN_CLIENT_URLS=\"http://10.230.3.154:2379\"  ">> /etc/default/etcd
```

You may take help from the following snapshot.

<h2 align="center" >
<img src="i35.png" >
</h2>



> [!NOTE]
> The above commands should be executed in the *root* privilege.

To exit from the *root* shell, type `exit`.

3. To enable the etcd service, execute the following:
```shell
systemctl enable etcd
```

You should get an output similar to the following:
<h2 align="center" >
<img src="i17.png" >
</h2>

4. Restart `etcd`  by the following command:
```shell
systemctl restart etcd
```


# References

1. [OpenStack Installation Guide](https://docs.openstack.org/install-guide/)
