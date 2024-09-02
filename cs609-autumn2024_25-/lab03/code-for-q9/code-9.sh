ovs-vsctl --help
sh ovs-vsctl list open_vswitch
sh ovs-vsctl list interface
sh ovs-vsctl list interface cfb6ed39-c351-45ca-ab0c-2bde32d33ecc
sh ovs-vsctl list interface cfb6ed39-c351-45ca-ab0c-2bde32d33ecc
sh ovs-vsctl --columns=options list interface cfb6ed39-c351-45ca-ab0c-2bde32d33ecc  
sh ovs-vsctl --columns=ofport,name list Interface
sh ovs-vsctl --columns=ofport,name --format=table list Interface
ovs-vsctl -f csv --no-heading --columns=_uuid list controller


