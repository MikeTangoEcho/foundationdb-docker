#!/bin/bash

# deb install does useless work; TODO use binaries
update-rc.d foundationdb disable
kill -9 `cat /var/run/fdbmonitor.pid`
rm -rf /var/lib/foundationdb/data/4500/

# https://apple.github.io/foundationdb/administration.html#foundationdb-cluster-file
# description:ID@IP:PORT,IP:PORT,...
container_ip=`hostname -i`
private_ip=${PRIVATE_IP:-${container_ip}}
public_ip=${PUBLIC_IP:-${private_ip}}
if [ -z "$DOCKER_COMPOSE_SCALING" ]; then
  coordinator_ip=${COORDINATOR_IP:-${private_ip}}
else
  # Docker Compose create a specific network and the first node always has ip.2
  # Quick Hack for testing scaling
  coordinator_ip=${COORDINATOR_IP:-${private_ip%.*}.2}
fi
coordinator_port=${COORDINATOR_PORT:-4500}

# .2 is first IP of compose network
echo "entrypoint> CoordinatorIP is ${coordinator_ip}"
echo "entrypoint> PrivateIP is  ${private_ip}"
echo "entrypoint> PublicIP is  ${public_ip}"

# Inside the cluster the private ip/container ip can be used
# Outside the cluster the public ip can be used
echo "docker:docker@${coordinator_ip}:${coordinator_port}" > /etc/foundationdb/fdb.cluster

# Quick Hack
# Create Database if needed
# If inside docker compose scaling, only create it on first node
if [ -n "$CONFIGURE_DATABASE" ]; then
  if [ -z "$DOCKER_COMPOSE_SCALING" ]; then 
    (sleep 10; fdbcli --exec "configure new ${CONFIGURE_DATABASE}") &
  else
    if [ "${container_ip##*.}" == "2" ]; then 
      (sleep 10; fdbcli --exec "configure new ${CONFIGURE_DATABASE}") &
    fi
  fi
fi

# Update conf public and listen address
# TODO Create as many entry/port as cores
sed -i "s/public_address = auto/public_address = $public_ip/" /etc/foundationdb/foundationdb.conf
sed -i "s/listen_address = public/listen_address = $private_ip:\$ID/" /etc/foundationdb/foundationdb.conf

# Run it!
/usr/lib/foundationdb/fdbmonitor --conffile /etc/foundationdb/foundationdb.conf --lockfile /var/run/fdbmonitor.pid

