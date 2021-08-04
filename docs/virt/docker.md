# Architecture
![Docker Architect](images/docker-architect.png "Docker Architect")

# Install refer to official site
* Refer to [Get Docker CE for Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
* To simply install by apt, refer to [link](https://gist.github.com/jgseong/7516dcf03e47d94bfd7e043ba69de794).

## Install docker
* the way to install by script
```sh
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# sudo groupadd docker   # if not be group
sudo usermod -aG docker $USER

# re-login $USER
# logout

# Test docker
docker run hello-world

```

## Install docker-compose
* Recommended after installed docker
* if host OS is alpinelinux, recommended to install by pip
> For alpine, the following dependency packages are needed: py-pip, python-dev, libffi-dev, openssl-dev, gcc, libc-dev, and make.

```sh 
# download docker-compose binary version 1.25.5
# for specify version, use the shell variables.
VER=1.25.5
sudo curl -L "https://github.com/docker/compose/releases/download/${VER}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod + /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# test docker-compose
docker-compose --version
```

# Basic Commands
* show docker container
```sh
# show running docker containers
docker ps 

# show all docker containers
docker ps -a
```
* show docker image
```sh
docker images
```
* search image
```sh
docker search 'image name'
```
* pull image
```sh
docker pull 'image name'
```
** examples
```sh
docker pull nginx
docker pull jekyll/minimal
```
* launch container
```sh
docker run [options] --name 'container name' 'image name'
```
** options
```bash
  -d : daemon mode
	-p : port forwarding
	--name : specify container name
```
** example
```sh
docker run -it --name minilinux apline
docker run -d -p 8080:80 --name webserver nginx
```
* control container
```sh
docker [start | restart | stop] webserver
```
* delete container
```sh
docker rm [options] 'container name'
```
** options
```bash
  -f : force
```
* delete image
```sh
docker rmi 'container name'
```

# Failed to login dockerhub
set `"credsStore": ""` in `~/.docker/config.json`

# Push image to dockerhub
1. `docker login`
2. create repository on [hub.docker.com](https://hub.docker.com/repositories)
3. make tag
```
# make tag
docker tag ${local-img}:{local-tag} ${new-repo}:{new-tag}

# push image to repository
docker push ${new-repo}:{new-tag}
```

