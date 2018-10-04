# DXSpider Deployment

This is a deployment project for [DX Spider](http://wiki.dxcluster.org/index.php/Main_Page) Amateur Radio DX Cluster 
software, independent of DX Spider development.

This project focuses on easy DX Spider deployment in virtualised/cloud
environments and as such its focus is primarily supporting telnet nodes
running on TCP networks.

## Running in Docker
DX Spider node parameters can be specified via Docker environment variables:
```bash
docker run \
--env CLUSTER_CALLSIGN="MY1CALL-2" \
--env CLUSTER_SYSOP_NAME="Joe Bloggs" \
--env CLUSTER_SYSOP_CALLSIGN="MY1CALL" \
--env CLUSTER_LATITUDE=+51.5 \
--env CLUSTER_LONGITUDE=-0.13 \
--env CLUSTER_LOCATOR="IO91WM" \
--env CLUSTER_QTH='London, England' \
--env CLUSTER_SYSOP_EMAIL="joe@test.com" \
--env CLUSTER_SYSOP_BBS_ADDRESS="MY1CALL@MY1CALL-2.#1.CTY.CO" \
--env CLUSTER_PORT=1234 \
-p 1234:1234 \
kconkas/dxspider:latest
```

In the above command, ensure that `CLUSTER_PORT` value equals to that of the 
published port `-p <host port>:<container port>`.

If your node started up successfully, at the end of the startup you should 
get an output similar to:
```
reading database descriptors ...
doing local initialisation ...
orft we jolly well go ...
queue msg (0)
queue msg (0)
```

You can now telnet to your cluster node and use it list like any other telnet
node:
```bash
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

### Sysop Shell
In order to get a sysop shell in your running Docker container:

1. Find out your running container ID
    ```bash
    $ docker ps | grep dxspider
    CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS                    NAMES
    672fba158ac2        dxspider:latest     "/entrypoint.sh"    About a minute ago   Up About a minute   0.0.0.0:1234->1234/tcp   dazzling_kowalevski
    ```

2. Get sysop shell
    ```bash
    $ docker exec -it 672fba158ac2 bash
    sysop@672fba158ac2:/$
    ```
    
    You can now perform administrative tasks (e.g. modify configuration files) or
    simply connect to a local DX Spider instance:
    ```bash
    sysop@672fba158ac2:/spider/local$ cd /spider/src/
    sysop@672fba158ac2:/spider/src$ ./client  MY1CALL
    Hello Joe Bloggs, this is MY1CALL-2 in East Dereham, Norfolk
    running DXSpider V1.55 build 0.166
    Cluster: 1 nodes, 1 local / 1 total users  Max users 1  Uptime 0 00:00
    MY1CALL de MY1CALL-2  4-Oct-2018 0938Z dxspider >
    ```

Now you can perform administrative tasks as sysop. Note any changes will be made in the context of
your running docker image.

### Stopping a Running Container
**Important:** Stopping a running Docker container will destroy all DX Spider data and customisations
applied to it! Use `docker cp` to copy any important data to your host computer beforehand.

1. Find out your running container ID
    ```bash
    $ docker ps | grep dxspider
    CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS                    NAMES
    21cd9f6cacfb        dxspider:latest     "/entrypoint.sh"    About a minute ago   Up About a minute   0.0.0.0:1234->1234/tcp   dazzling_kowalevski
    ```
2.  Stop the container
    ```bash
    $ docker stop 92ed43dd6de1
    92ed43dd6de1
    ```
