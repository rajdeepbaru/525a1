sudo mn --topo single,3 --mac --switch ovsk --controller remote -x

In s1: 
ovs-vsctl show
ovs-dpctl show
ovs-vsctl set Bridge s1 protocols=OpenFlow13
ovs-ofctl -O OpenFlow13 dump-flows s1

In c0:
ryu-manager --verbose ryu.app.example_switch_13

In s1:
# ovs-ofctl -O openflow13 dump-flows s1

In h1:
# tcpdump -en -i h1-eth0

In h2:
# tcpdump -en -i h2-eth0


In h3:
# tcpdump -en -i h3-eth0


In mn:
mininet> h1 ping -c1 h2

In s1:
# ovs-ofctl -O openflow13 dump-flows s1

Look at controller


In h1:
# tcpdump -en -i h1-eth0

In h2:
# tcpdump -en -i h2-eth0

In h3:
# tcpdump -en -i h3-eth0


