sudo mn --topo linear,2,1  --switch ovsk --controller=remote
nodes
dpctl add-flow in_port=1,nw_dst=10.0.0.2,actions=output:3
exit
