<!-- TITLE: Basic -->
<!-- SUBTITLE: A quick summary of docker usage -->

# Docker

## Docker Architecture
![Docker Architect](/uploads/docker-architect.png "Docker Architect")


## CLI

### show docker container
```sh
# show running docker containers
docker ps 

# show all docker containers
docker ps -a
```

### show docker image
```sh
docker images
```

### search image
```sh
docker search 'image name'
```

### pull image
```sh
docker pull 'image name'
```
* examples
```sh
docker pull nginx
docker pull jekyll/minimal
```

### launch container
```sh
docker run [options] --name 'container name' 'image name'
```

* options
```bash
  -d : daemon mode
	-p : port forwarding
	--name : specify container name
```

* example
```sh
docker run -it --name minilinux apline
docker run -d -p 8080:80 --name webserver nginx
```

### control container
```sh
docker [start | restart | stop] webserver
```

### delete container
```sh
docker rm [options] 'container name'
```
* options
```bash
  -f : force
```


### delete image
```sh
docker rmi 'container name'
```