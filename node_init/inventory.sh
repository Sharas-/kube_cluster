#! /bin/bash

cat <<EOF
{
master: [$(terraform output master_ip)], 
nodes: [$(terraform output node_ips)]
}
EOF

