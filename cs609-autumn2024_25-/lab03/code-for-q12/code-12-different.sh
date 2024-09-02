sudo mn --topo linear,2,1  --switch ovsk --controller=remote
nodes
dpctl dump-flows
sh ovs-ofctl add-flow s1 in_port=5,nw_dst=10.0.0.5,actions=output:5
dpctl dump-flows
