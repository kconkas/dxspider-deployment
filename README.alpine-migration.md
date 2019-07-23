From commit **d6105f8cfd6fc57fcaccb44b67731983c8639442** onwards, docker image produced by this project is based on Alpine Linux and is considerably smaller in size (some 60MB versus some 200MB) than the old, CentOS based, one.

If you had run this image before commit **d6105f8cfd6fc57fcaccb44b67731983c8639442** got merged to master branch (and corresponding docker image pushed to dockerhub), the image you're using will have been based on CentOS Linux. It will also have persisted the whole of the container's `/spider` directory in a docker container called `dxspider_data`. 

The issue is the `/spider` directory contains not only configuration files you may have customised in `local` or `data` but also some compiled binaries under `src` and, because of differences in the Alpine Linux and CentOS Linux design, these binaries will not be compatible between the two.

You've got several options:

### 1. Continue using the old CentOS based image

There is nothing wrong in using the old CentOS based image and you can still use it, it is just that you won't benefit from any reduction in size the Alpine based image brings. And just to make sure you can use this image whenever you need, its tag in Docker Hub is `kconkas/dxspider:1.55-063dbc33-centos`. 
    
When running it as described in [README.md](./README.md) simply substitute `kconkas/dxspider` with `kconkas/dxspider:1.55-063dbc33-centos` and you don't need to do anything else.

### 2. Start from clean installation (recommended)
If you can lose your existing customisations, the simplest option is to delete your `dxspider_data` docker volume. Next time you run the new image, this volume will be recreated and persisted. 

You can delete this volume by running:
```
docker volume rm dxspider_data
```

**Important** this will destroy all your current DX Spider data. If there are any configuration files or customisations you would like to save, [copy them to your local drive](./README.md#copying-data-tofrom-docker-container) beforehand.

### 3. Manually copy necessary files

When starting DX spider as described in 
[Running in Docker](./README.md#running-in-docker)
replace:
```
--mount source=dxspider_data,target=/spider \
```
with
```
 --mount source=dxspider_data,target=/spider_old \
 --mount source=dxspider_data_new,target=/spider \
 ```

Your old volume will now be mounted in the running container as `/spider_old`, the new one as `/spider`. You will now be able to log in to the running container and [copy data](./README.md#copying-data-tofrom-docker-container) as required.

Note, because docker doesn't support renaming volumes, after this procedure the docker volume you actually need will be called `dxspider_data_new` and you will need to refer to it as such when running containers thereafter. Therefore, each time you follow the [documented instructions](./README.md) you will need to use:
```
 --mount source=dxspider_data_new,target=/spider \
 ```
instead of
 ```
 --mount source=dxspider_data,target=/spider \
 ```

You can remove the old `dxspider_data` once you've ascertained you've copied everything you need.

Since this operation is manual and error prone, it is recommended that you only use it if you're absolutely certain you know what you're doing.