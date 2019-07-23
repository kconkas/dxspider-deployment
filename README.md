# DXSpider Deployment

This is a deployment project for [DX Spider](http://wiki.dxcluster.org/index.php/Main_Page) Amateur Radio DX Cluster 
software, independent of DX Spider development.

This project focuses on easy DX Spider deployment in virtualised/cloud
environments and as such its focus is primarily supporting telnet nodes
running on TCP networks.

**Note:** if you first run this docker image before 23rd July 2019, please refer to [Alpine image migration](./README.alpine-migration.md) for important information.

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
--mount source=dxspider_data,target=/spider \
-p 1234:1234 \
kconkas/dxspider:latest
```

In the above command, ensure that `CLUSTER_PORT` value equals to that of the 
published port `-p <host port>:<container port>`.

**Important:** Once generated, DX Spider configuration files will be preserved for 
subsequent runs in Docker volume named `dxspider_data`. For subsequent runs you 
can omit setting the `CLUSTER_*` environment variables as they will be ignored anyway. 
If you wish to change this behaviour and overwrite configuration files (for example 
to change some parameters) add `--env OVERWRITE_CONFIG="yes"` to the above command.

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
    
    You can now perform administrative tasks as sysop (such as modify configuration files using `vim.tiny` editor) or
    simply connect to your local DX Spider instance:
    ```bash
    sysop@672fba158ac2:/spider/local$ cd /spider/src/
    sysop@672fba158ac2:/spider/src$ ./client  MY1CALL
    Hello Joe Bloggs, this is MY1CALL-2 in East Dereham, Norfolk
    running DXSpider V1.55 build 0.166
    Cluster: 1 nodes, 1 local / 1 total users  Max users 1  Uptime 0 00:00
    MY1CALL de MY1CALL-2  4-Oct-2018 0938Z dxspider >
    ```

### Copying Data to/from Docker Container  
Your DX Spider data, user and spot databases, and any customisations of files under `/spider` directory will be 
saved in Docker volume called `dxspider_data` and will be used in subsequent runs provided you started DX Spider 
container as described in [Running in Docker](#running-in-docker).

Sometimes you may need to copy files from your workstation into your running Docker container (or vice-versa).
For instance, you may find it easier to prepare DX Spider connection files using a fully-featured editor instead of 
`vim.tiny`. You can do this by using the `docker cp` command:

1. Find out your running container ID (see [Sysop Shell](#sysop-shell) for more details)
2. Copy local file to container
    ```bash
    $ docker cp ab1cde 672fba158ac2:/spider/connect/.
    # to verify the file got copied across
    $ docker exec -it 672fba158ac2 ls -la /spider/connect
    total 24
    drwxrwsr-x  2 sysop sysop   4096 Nov  7 18:41 .
    drwxrwsr-x 24 sysop sysop   4096 Oct 28 14:27 ..
    -rw-r--r--  1 sysop sysop      2 Oct 25 13:34 .cvsignore
    -rw-r--r--  1 sysop sysop     23 Oct 25 13:34 .gitignore
    -rw-r--r--  1   502 dialout  194 Nov  7 18:40 ab1cde
    -rw-r--r--  1 sysop sysop    194 Oct 25 13:34 gb7tlh
    ```
  
    **Note:** In this example the copied file does not have the correct user/group membership. This is due to Docker 
    container user/group databases having no relationship with host workstation's ones. If this is likely to cause 
    issues, you can correct the permissions by running:
    ```bash
    $ docker exec -u root -it 672fba158ac2 chown sysop:sysop /spider/connect/ab1cde
    # verify the file ownership has changed
    $ docker exec -it 672fba158ac2 ls -la /spider/connect
    total 24
    drwxrwsr-x  2 sysop sysop 4096 Nov  7 18:05 .
    drwxrwsr-x 24 sysop sysop 4096 Oct 28 14:27 ..
    -rw-r--r--  1 sysop sysop    2 Oct 25 13:34 .cvsignore
    -rw-r--r--  1 sysop sysop   23 Oct 25 13:34 .gitignore
    -rw-r--r--  1 sysop sysop  194 Nov  7 18:40 ab1cde
    -rw-r--r--  1 sysop sysop  194 Oct 25 13:34 gb7tlh
    ```
    
3. Copy file from container to local filesystem
    ```bash
    $ docker cp 672fba158ac2:/spider/connect/gb7tlh .
    # to verify the file got copied across
    $ ls -l gb7tlh
    -rw-r--r--  1 kconkas  users  194 25 Oct 14:34 gb7tlh
    ```

You can also use this approach to copy directory trees etc. For more details refer to 
[docker cp](https://docs.docker.com/engine/reference/commandline/cp/) documentation.
  
### Stopping a Running Container
1. Find out your running container ID
    ```bash
    $ docker ps | grep dxspider
    CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS                    NAMES
    672fba158ac2        dxspider:latest     "/entrypoint.sh"    About a minute ago   Up About a minute   0.0.0.0:1234->1234/tcp   dazzling_kowalevski
    ```
2.  Stop the container
    ```bash
    $ docker stop 672fba158ac2
    672fba158ac2
    ```

Your DX Spider data is now saved in the `dxspider_data` volume:
```bash
$ docker volume ls --filter name=dxspider_data
DRIVER              VOLUME NAME
local               dxspider_data
```
