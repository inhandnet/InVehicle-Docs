# Using ALSA in Docker Container

- pull ubuntu image

```sh
docker pull ubuntu:16.04
```

- run ubuntu image

```sh
docker run -it --name vgalsa-base ubuntu:16.04 /bin/bash
```

- replace package source(optional)

把 mirrors.tuna.tsinghua.edu.cn 替换成你本地镜像站的域名

```sh
sed -i -e 's|ports.ubuntu.com|mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list && apt update
```

- Install alsa packages

```sh
apt install alsa-base
```

- alsa的基础环境已经好了， 我们通过 docker commit的方式从容器生成新的镜像
- run alsa example container with privilege

```sh
docker run -it --privileged -v "/dev:/dev" --name alsa_env vgalsa:v1 /bin/bash
```

