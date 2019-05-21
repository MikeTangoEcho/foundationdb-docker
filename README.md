# FoundationDB in Docker + Compose

**Using deb installation. One Day! Binaries? An who know? Maybe Alpine**

## HowTo

### Requirements

* Download the deb packages you want to install into the folder `deb`

Example
```sh
cd deb
wget https://www.foundationdb.org/downloads/6.0.18/ubuntu/installers/foundationdb-clients_6.0.18-1_amd64.deb
wget https://www.foundationdb.org/downloads/6.0.18/ubuntu/installers/foundationdb-server_6.0.18-1_amd64.deb
```

### Docker

#### Build

```sh
docker build . -t foundation:anytagyouwant
``` 

#### Run

```console
$ docker run --rm -d --name foundationdb foundation:anytagyouwant
$ docker exec foundationdb fdbcli --exec "configure new single memory"
Database created
$ docker exec foundationdb fdbcli --exec status
Using cluster file `/etc/foundationdb/fdb.cluster'.

Configuration:
  Redundancy mode        - single
  Storage engine         - memory
  Coordinators           - 1

Cluster:
  FoundationDB processes - 1
  Machines               - 1
  Memory availability    - 0.7 GB per process on machine with least available
                           >>>>> (WARNING: 4.0 GB recommended) <<<<<
  Fault Tolerance        - 0 machines
  Server time            - 05/21/19 13:17:49

Data:
  Replication health     - (Re)initializing automatic data distribution
  Moving data            - unknown (initializing)
  Sum of key-value sizes - unknown
  Disk space used        - 0 MB

Operating space:
  Storage server         - 1.0 GB free on most full server
  Log server             - 1.0 GB free on most full server

Workload:
  Read rate              - 36 Hz
  Write rate             - 3 Hz
  Transactions started   - 11 Hz
  Transactions committed - 1 Hz
  Conflict rate          - 0 Hz

Backup and DR:
  Running backups        - 0
  Running DRs            - 0

Client time: 05/21/19 13:17:49
```

### Docker Compose

The following commands do
* Create a single node
* Get status of foundation cluster
* Scale to 3 nodes
* Get status of foundation cluster

```console
$ docker-compose up
Creating network "fdb_default" with the default driver
Creating fdb_foundationdb_1 ... done
Attaching to fdb_foundationdb_1
foundationdb_1  | /home/entrypoint.sh: line 5: kill: (69) - No such process
foundationdb_1  | entrypoint> CoordinatorIP is 172.23.0.2
foundationdb_1  | entrypoint> PrivateIP is  172.23.0.2
foundationdb_1  | entrypoint> PublicIP is  172.23.0.2
foundationdb_1  | Time="1558446729.544049" Severity="10" LogGroup="default" Process="fdbmonitor": Started FoundationDB Process Monitor 6.0 (v6.0.15)
foundationdb_1  | Time="1558446729.552293" Severity="10" LogGroup="default" Process="fdbmonitor": Watching conf file /etc/foundationdb/foundationdb.conf
foundationdb_1  | Time="1558446729.552361" Severity="10" LogGroup="default" Process="fdbmonitor": Watching conf dir /etc/foundationdb (2)
foundationdb_1  | Time="1558446729.552378" Severity="10" LogGroup="default" Process="fdbmonitor": Loading configuration /etc/foundationdb/foundationdb.conf
foundationdb_1  | Time="1558446729.552795" Severity="10" LogGroup="default" Process="fdbmonitor": Starting backup_agent.1
foundationdb_1  | Time="1558446729.552938" Severity="10" LogGroup="default" Process="fdbmonitor": Starting fdbserver.4500
foundationdb_1  | Time="1558446729.553110" Severity="10" LogGroup="default" Process="backup_agent.1": Launching /usr/lib/foundationdb/backup_agent/backup_agent (16) for backup_agent.1
foundationdb_1  | Time="1558446729.553202" Severity="10" LogGroup="default" Process="fdbserver.4500": Launching /usr/sbin/fdbserver (17) for fdbserver.4500
foundationdb_1  | Time="1558446729.614455" Severity="10" LogGroup="default" Process="fdbserver.4500": FDBD joined cluster.
foundationdb_1  | Database created
...
$ docker-compose exec foundationdb fdbcli --exec status
Using cluster file `/etc/foundationdb/fdb.cluster'.

Configuration:
  Redundancy mode        - single
  Storage engine         - memory
  Coordinators           - 1

Cluster:
  FoundationDB processes - 1
  Machines               - 1
  Memory availability    - 0.7 GB per process on machine with least available
                           >>>>> (WARNING: 4.0 GB recommended) <<<<<
  Fault Tolerance        - 0 machines
  Server time            - 05/21/19 13:53:48

Data:
  Replication health     - Healthy (Rebalancing)
  Moving data            - 0.000 GB
  Sum of key-value sizes - 0 MB
  Disk space used        - 0 MB

Operating space:
  Storage server         - 1.0 GB free on most full server
  Log server             - 1.0 GB free on most full server

Workload:
  Read rate              - 15 Hz
  Write rate             - 0 Hz
  Transactions started   - 4 Hz
  Transactions committed - 0 Hz
  Conflict rate          - 0 Hz

Backup and DR:
  Running backups        - 0
  Running DRs            - 0

Client time: 05/21/19 13:53:48
$ docker-compose.exe up -d --scale foundationdb=3
foundationdb_2  | /home/entrypoint.sh: line 5: kill: (69) - No such process
foundationdb_2  | entrypoint> CoordinatorIP is 172.23.0.2
foundationdb_2  | entrypoint> PrivateIP is  172.23.0.3
foundationdb_2  | entrypoint> PublicIP is  172.23.0.3
foundationdb_2  | Time="1558446986.180762" Severity="10" LogGroup="default" Process="fdbmonitor": Started FoundationDB Process Monitor 6.0 (v6.0.15)
foundationdb_2  | Time="1558446986.195738" Severity="10" LogGroup="default" Process="fdbmonitor": Watching conf file /etc/foundationdb/foundationdb.conf
foundationdb_2  | Time="1558446986.195760" Severity="10" LogGroup="default" Process="fdbmonitor": Watching conf dir /etc/foundationdb (2)
foundationdb_2  | Time="1558446986.195773" Severity="10" LogGroup="default" Process="fdbmonitor": Loading configuration /etc/foundationdb/foundationdb.conf
foundationdb_2  | Time="1558446986.196114" Severity="10" LogGroup="default" Process="fdbmonitor": Starting backup_agent.1
foundationdb_2  | Time="1558446986.196235" Severity="10" LogGroup="default" Process="fdbmonitor": Starting fdbserver.4500
foundationdb_2  | Time="1558446986.196893" Severity="10" LogGroup="default" Process="fdbserver.4500": Launching /usr/sbin/fdbserver (15) for fdbserver.4500
foundationdb_2  | Time="1558446986.196909" Severity="10" LogGroup="default" Process="backup_agent.1": Launching /usr/lib/foundationdb/backup_agent/backup_agent (14) for backup_agent.1
foundationdb_3  | entrypoint> CoordinatorIP is 172.23.0.2
foundationdb_3  | entrypoint> PrivateIP is  172.23.0.4
foundationdb_3  | entrypoint> PublicIP is  172.23.0.4
foundationdb_3  | /home/entrypoint.sh: line 5: kill: (69) - No such process
foundationdb_3  | Time="1558446986.221450" Severity="10" LogGroup="default" Process="fdbmonitor": Started FoundationDB Process Monitor 6.0 (v6.0.15)
foundationdb_3  | Time="1558446986.253357" Severity="10" LogGroup="default" Process="fdbmonitor": Watching conf file /etc/foundationdb/foundationdb.conf
foundationdb_3  | Time="1558446986.253392" Severity="10" LogGroup="default" Process="fdbmonitor": Watching conf dir /etc/foundationdb (2)
foundationdb_3  | Time="1558446986.253415" Severity="10" LogGroup="default" Process="fdbmonitor": Loading configuration /etc/foundationdb/foundationdb.conf
foundationdb_3  | Time="1558446986.253877" Severity="10" LogGroup="default" Process="fdbmonitor": Starting backup_agent.1
foundationdb_3  | Time="1558446986.254019" Severity="10" LogGroup="default" Process="fdbmonitor": Starting fdbserver.4500
foundationdb_3  | Time="1558446986.256005" Severity="10" LogGroup="default" Process="backup_agent.1": Launching /usr/lib/foundationdb/backup_agent/backup_agent (14) for backup_agent.1
foundationdb_3  | Time="1558446986.256294" Severity="10" LogGroup="default" Process="fdbserver.4500": Launching /usr/sbin/fdbserver (15) for fdbserver.4500
foundationdb_2  | Time="1558446986.265558" Severity="10" LogGroup="default" Process="fdbserver.4500": FDBD joined cluster.
foundationdb_3  | Time="1558446986.302197" Severity="10" LogGroup="default" Process="fdbserver.4500": FDBD joined cluster.
$ docker-compose.exe exec foundationdb fdbcli --exec "configure double memory"
Configuration changed
$ docker-compose.exe down -v
Stopping fdb_foundationdb_3 ... done
Stopping fdb_foundationdb_2 ... done
Stopping fdb_foundationdb_1 ... done
Removing fdb_foundationdb_3 ... done
Removing fdb_foundationdb_2 ... done
Removing fdb_foundationdb_1 ... done
Removing network fdb_default
```


