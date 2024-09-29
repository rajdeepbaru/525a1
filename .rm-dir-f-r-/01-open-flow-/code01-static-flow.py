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
