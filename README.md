# DXSpider Deployment

This is a deployment project for [DX Spider](http://wiki.dxcluster.org/index.php/Main_Page)
Amateur Radio DX Cluster software, independent of DX Spider development.

This project focuses on easy DX Spider deployment in virtualised/cloud
environments and as such its focus is primarily supporting telnet nodes running
on TCP networks.

## Running in docker-compose

Rename the file `prod.sample.env` to `prod.env`, edit it at your will, and then
just run the following command:

```sh
sudo ./build
```

You should not need to change anything in the `docker-compose.yml` file itself.
A directory called `./spider` will be created and used as the storage location for
your cluster's files. You should not execute cluster commands within this directory.

Once the build process is completed, assuming there were no issues, you can use the `dx`
script to control the state of the docker container and DXspider. To bring the container
online, simply type:
```sh
./dx up
```

This will start the container and the cluster software within it. To see the debug logs,
and tell if the cluster is running successfully, look at the docker container logs using
`docker-compose logs` or `./dx logs`. You should get an output similar to:
```txt
reading database descriptors ...
doing local initialisation ...
orft we jolly well go ...
queue msg (0)
queue msg (0)
```

You can now telnet to your cluster node and use it list like any other telnet
node:

```txt
$ telnet localhost 1234
Trying ::1...
Connected to localhost.
Escape character is '^]'.
login: MY1CALL
MY1CALL
Hello Joe Bloggs, this is MY1CALL-2 in London, England
running DXSpider V1.55 build 0.166
Cluster: 1 nodes, 1 local / 1 total users  Max users 1  Uptime 0 00:08
MY1CALL de MY1CALL-2  4-Oct-2018 0918Z dxspider >
```

If you want to allow external connections to your node, you will need to allow
this traffic on your firewall.

To put down the server, run:

```sh
./dx down
```

### Sysop Shell

In order to get a sysop shell in your running Docker container:
```sh
./dx sh
```

### Cluster Console
In order to get a cluster console in your running Docker container:
```sh
./dx console
```

