# **NATS install/settings**

[NATS](https://nats.io)

[NATS download](https://nats.io/download/)

[NATS docker](https://hub.docker.com/_/nats)

------------

## Configuration simple NATS server
server NATS+MQTT
```
server_name: nats-mqtt-server
listen: 4222
http: 4333
jetstream: enabled

mqtt {
	port:1883
}

authorization {
    users = [
        {user: "xxandev", password: "XXanDevNats"}
        {user: "tester", password: "qwertyuiop"}
    ]
}
```

------------

## Configuration simple NATS servers cluster
1 server config (suppose ip: 192.168.1.101)
```
server_name: nats-mqtt-server-one
listen: 4222
http: 4333
jetstream: enabled

mqtt {
	port:1883
}

authorization {
    users = [
        {user: "xxandev", password: "XXanDevNats"}
        {user: "tester", password: "qwertyuiop"}
    ]
}

cluster {
    name: nats-servers
    listen: 6234
    authorization {
        user: clusterUSR
        pass: clusterPWD
        timeout: 5
    }
    routes = [
        nats://clusterUSR:clusterPWD@192.168.1.102:6234
        nats://clusterUSR:clusterPWD@192.168.1.103:6234
    ]
}
```

2 server config (suppose ip: 192.168.1.102)
```
server_name: nats-mqtt-server-two
listen: 4234
http: 4333
jetstream: enabled

mqtt {
	port:1883
}

authorization {
    users = [
        {user: "xxandev", password: "XXanDevNats"}
        {user: "tester", password: "qwertyuiop"}
    ]
}

cluster {
    name: nats-servers
    listen: 6234
    authorization {
        user: NATScluster
        pass: ClusterPWD
        timeout: 5
    }
    routes = [
        nats://clusterUSR:clusterPWD@192.168.1.101:6234
        nats://clusterUSR:clusterPWD@192.168.1.103:6234
    ]
}
```

3 server config (suppose ip: 192.168.1.103)
```
server_name: nats-mqtt-server-three
listen: 4222
http: 4333
jetstream: enabled

mqtt {
	port:1883
}

authorization {
    users = [
        {user: "xxandev", password: "XXanDevNats"}
        {user: "tester", password: "qwertyuiop"}
    ]
}

cluster {
    name: nats-servers
    listen: 6234
    authorization {
        user: clusterUSR
        pass: clusterPWD
        timeout: 5
    }
    routes = [
        nats://clusterUSR:clusterPWD@192.168.1.101:6234
        nats://clusterUSR:clusterPWD@192.168.1.102:6234
    ]
}
```

------------

## Unpack archive server 

if the unzip command isn't already installed on your system, then run:
```
apt -y install unzip
```
after installing the unzip utility, if you want to extract to a particular destination folder, you can use:
```
unzip file.zip -d destination_folder
```
if the source and destination directories are the same, you can simply do:
```
unzip file.zip
```

------------

## Create systemd service NATS
[systemd add script](/scripts/systemd/nats)

simple systemd service
```
[Unit]
Description=nats-server
After=syslog.target 
After=network-online.target

[Service]
Type=simple
User=root
WorkingDirectory={{APP PATH}}/
ExecStart={{APP PATH}}/nats-server -c nats.conf
Restart=always
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
```

**OR**

simple systemd service + cgroup memory (**if system resources are limited**)
```
[Unit]
Description=nats-server
After=syslog.target 
After=network-online.target

[Service]
Type=simple
User=root
WorkingDirectory={{APP PATH}}/
ExecStart={{APP PATH}}/nats-server -c nats.conf
ExecStartPost=/bin/bash -c "echo 0 > /sys/fs/cgroup/memory/system.slice/nats-server.service/memory.swappiness"
Restart=always
RestartSec=10
KillMode=process

MemoryAccounting=true
MemoryLimit=100M
MemoryHigh=100M
MemoryMax=100M

[Install]
WantedBy=multi-user.target
```