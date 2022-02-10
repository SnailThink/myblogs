# Docker及Kubernetes常用命令操作

# Docker 简介

**Docker 是一种运行于 Linux 和 Windows 上的软件，用于创建、管理和编排容器。**

Docker的基本组成

![img](https://img-blog.csdnimg.cn/20190514233134595.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2x1b2NoZW5odWkyMDE4,size_16,color_FFFFFF,t_70)

1. **Docker Client客户端**

   Docker是C/S架构的程序，docker的客户端向服务器端(也就是Docker的守护进程)发出请求，守护进程处理完所有的工作并返回结果；docker客户端向服务器端的访问既可以在本地也可以通过远程来访问；

2. **Docker Daemon 守护进程**

3. **Docker Image 镜像**

   镜像是docker容器的基石，容器基于镜像启动和运行，镜像好比容器的源代码，保存了启动容器的各种条件

4. **Docker Container 容器**

   容器通过镜像来启动，docker的容器是docker执行单元，容器中可以运行客户的一个或者多个进程，如果说镜像是docker生命周期中的构建和打包阶段，那么容器就是启动和执行阶段；

5. **Docker Registry 仓库**

   docker用仓库来保存用户构建的对象，分为公有和私有，Docker公司自己提供了一个公有的，叫Docker Hub

## Docker 安装

linux 安装

### 脚本安装

```shell
$ wget -qO- https://get.docker.com/ | sh
```

### yum安装

```shell
$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2
$ sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
$ sudo yum list docker-ce --showduplicates | sort -r
$ sudo yum install docker-ce
```

## Docker命令

### Docker容器生命周期管理

#### **docker run ：**创建一个新的容器并运行一个命令

##### 语法

```shell
$ docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

OPTIONS说明：

**-a stdin:** 指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项；

- **-d:** 后台运行容器，并返回容器ID；
- **-i:** 以交互模式运行容器，通常与 -t 同时使用；
- **-P:** 随机端口映射，容器内部端口**随机**映射到主机的端口
- **-p:** 指定端口映射，格式为：主机(宿主)端口:容器端口
- **-t:** 为容器重新分配一个伪输入终端，通常与 -i 同时使用；
- **--name="nginx-lb":** 为容器指定一个名称；
- **--dns 8.8.8.8:** 指定容器使用的DNS服务器，默认和宿主一致；
- **--dns-search example.com:** 指定容器DNS搜索域名，默认和宿主一致；
- **-h "mars":** 指定容器的hostname；
- **-e username="ritchie":** 设置环境变量；
- **--env-file=[]:** 从指定文件读入环境变量；
- **--cpuset="0-2" or --cpuset="0,1,2":** 绑定容器到指定CPU运行；
- **-m :**设置容器使用内存最大值；
- **--net="bridge":** 指定容器的网络连接类型，支持 bridge/host/none/container: 四种类型；
- **--link=[]:** 添加链接到另一个容器；
- **--expose=[]:** 开放一个端口或一组端口；
- **--volume , -v:** 绑定一个卷

##### 示例

```shell
# 使用Docker镜像nginx:latest以后台模式启动一个容器,并将容器命名为mynginx。
$ docker run --name mynginx -d nginx:latest

# 使用镜像nginx:latest以后台模式启动一个容器,并将容器的80端口映射到主机随机端口。（这里是P是大写）
$ docker run -P -d nginx:latest

# 使用镜像 nginx:latest，以后台模式启动一个容器,将容器的 80 端口映射到主机的 80 端口,主机的目录 /data 映射到容器的 /data。
$ docker run -p 80:80 -v /data/docker_data:/data -d nginx:latest

# 绑定容器的 8080 端口，并将其映射到本地主机 127.0.0.1 的 80 端口上。
$ docker run -p 127.0.0.1:80:8080/tcp ubuntu bash

# 使用镜像nginx:latest以交互模式启动一个容器,在容器内执行/bin/bash命令。
$ docker run -it nginx:latest /bin/bash
```

#### docker start/stop/restart 

**docker start** :启动一个或多个已经被停止的容器

**docker stop** :停止一个运行中的容器

**docker restart** :重启容器

##### 语法

```shell
$ docker start [OPTIONS] CONTAINER [CONTAINER...]
$ docker stop [OPTIONS] CONTAINER [CONTAINER...]
$ docker restart [OPTIONS] CONTAINER [CONTAINER...]
```

##### 示例

```shell
# 启动已被停止的容器
$ docker start mynginx

# 停止运行中的容器myrunoob
$ docker stop mynginx

# 重启容器myrunoob
$ docker restart mynginx
```

#### **docker kill** :杀掉一个运行中的容器。

##### 语法

```shell
$ docker kill [OPTIONS] CONTAINER [CONTAINER...]
```

OPTIONS说明：

- **-s :**向容器发送一个信号

##### 示例

```shell
# 杀掉运行中的容器mynginx
$ docker kill -s KILL mynginx
mynginx
```

#### **docker rm ：**删除一个或多个容器。

##### 语法

```shell
$ docker rm [OPTIONS] CONTAINER [CONTAINER...]
```

OPTIONS说明：

- **-f :**通过 SIGKILL 信号强制删除一个运行中的容器。
- **-l :**移除容器间的网络连接，而非容器本身。
- **-v :**删除与容器关联的卷。

##### 示例

```shell
# 强制删除容器 mynginx：
$ docker rm -f mynginx nginxdemo

# 删除容器 nginx01, 并删除容器挂载的数据卷：
$ docker rm -v nginx01

# 删除所有已经停止的容器：
$ docker rm $(docker ps -a -q)
```

#### **docker pause/unpause** :

**docker pause** : 暂停容器中所有的进程。

**docker unpause** :恢复容器中所有的进程。

##### 语法

```shell
$ docker pause CONTAINER [CONTAINER...]
$ docker unpause CONTAINER [CONTAINER...]
```

##### 示例

```shell
# 暂停数据库容器db01提供服务。
$ docker pause mynginx

# 恢复数据库容器 db01 提供服务。
$ docker unpause mynginx
```

#### **docker create ：**创建一个新的容器但不启动它

用法同 [docker run](https://www.e6.com/docker/docker-run-command.html)

##### 语法

```shell
$ docker create [OPTIONS] IMAGE [COMMAND] [ARG...]
```

语法同 [docker run](https://www.e6.com/docker/docker-run-command.html)

##### 示例

```shell
# 使用docker镜像nginx:latest创建一个容器,并将容器命名为myrunoob
$ docker create  --name nginxdemo3  nginx:latest      
```



#### **docker exec ：**在运行的容器中执行命令

##### 语法

```shell
$ docker exec [OPTIONS] CONTAINER COMMAND [ARG...]
```

OPTIONS说明：

- **-d :**分离模式: 在后台运行
- **-i :**即使没有附加也保持STDIN 打开
- **-t :**分配一个伪终端

##### 示例

```shell
# 在容器 mynginx 中开启一个交互模式的终端:
$ docker exec -i -t  mynginx /bin/bash
```



### 容器操作

#### **docker ps :** 列出容器

##### 语法

```shell
$ docker ps [OPTIONS]
```

OPTIONS说明：

- **-a :**显示所有的容器，包括未运行的。

- **-f :**根据条件过滤显示的内容。

- **--format :**指定返回值的模板文件。

- **-l :**显示最近创建的容器。

- **-n :**列出最近创建的n个容器。

- **--no-trunc :**不截断输出。

- **-q :**静默模式，只显示容器编号。

- **-s :**显示总的文件大小。

##### 示例

列出所有在运行的容器信息。

```shell
$ docker ps
CONTAINER ID   IMAGE          COMMAND                ...  PORTS                    NAMES
09b93464c2f7   nginx:latest   "nginx -g 'daemon off" ...  80/tcp, 443/tcp          myrunoob
96f7f14e99ab   mysql:5.6      "docker-entrypoint.sh" ...  0.0.0.0:3306->3306/tcp   mymysql
```

输出详情介绍：

**CONTAINER ID:** 容器 ID。

**IMAGE:** 使用的镜像。

**COMMAND:** 启动容器时运行的命令。

**CREATED:** 容器的创建时间。

**STATUS:** 容器状态。

状态有7种：

- created（已创建）
- restarting（重启中）
- running（运行中）
- removing（迁移中）
- paused（暂停）
- exited（停止）
- dead（死亡）

**PORTS:** 容器的端口信息和使用的连接类型（tcp\udp）。

**NAMES:** 自动分配的容器名称。

##### 示例

```shell
# 列出最近创建的5个容器信息。
$ docker ps -n 5
CONTAINER ID        IMAGE               COMMAND                   CREATED           
09b93464c2f7        nginx:latest        "nginx -g 'daemon off"    2 days ago   ...     
b8573233d675        nginx:latest        "/bin/bash"               2 days ago   ...     
b1a0703e41e7        nginx:latest        "nginx -g 'daemon off"    2 days ago   ...    
f46fb1dec520        5c6e1090e771        "/bin/sh -c 'set -x \t"   2 days ago   ...   
a63b4a5597de        860c279d2fec        "bash"                    2 days ago   ...


# 列出所有创建的容器ID。
$ docker ps -a -q
09b93464c2f7
b8573233d675
b1a0703e41e7
f46fb1dec520
a63b4a5597de
6a4aa42e947b
de7bb36e7968
43a432b73776
664a8ab1a585
ba52eb632bbd
...
```

#### **docker inspect :** 获取容器/镜像的元数据。

##### 语法

```shell
$ docker inspect [OPTIONS] NAME|ID [NAME|ID...]
```

OPTIONS说明：

- **-f :**指定返回值的模板文件。
- **-s :**显示总的文件大小。
- **--type :**为指定类型返回JSON。

##### 示例

获取镜像mysql:5.6的元信息。

```shell
$ docker inspect mysql:5.6
[
    {
        "Id": "sha256:2c0964ec182ae9a045f866bbc2553087f6e42bfc16074a74fb820af235f070ec",
        "RepoTags": [
            "mysql:5.6"
        ],
        "RepoDigests": [],
        "Parent": "",
        "Comment": "",
        "Created": "2016-05-24T04:01:41.168371815Z",
        "Container": "e0924bc460ff97787f34610115e9363e6363b30b8efa406e28eb495ab199ca54",
        "ContainerConfig": {
            "Hostname": "b0cf605c7757",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "3306/tcp": {}
            },
...
```

获取正在运行的容器mymysql的 IP。

```shell
$ docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mymysql
172.17.0.3
```

#### **docker top :**查看容器中运行的进程信息，支持 ps 命令参数。

##### 语法

```shell
$ docker top [OPTIONS] CONTAINER [ps OPTIONS]
```

容器运行时不一定有/bin/bash终端来交互执行top命令，而且容器还不一定有top命令，可以使用docker top来实现查看container中正在运行的进程。

##### 示例

```shell
# 查看容器mymysql的进程信息。
$ docker top mymysql
UID    PID    PPID    C      STIME   TTY  TIME       CMD
999    40347  40331   18     00:58   ?    00:00:02   mysqld

# 查看所有运行容器的进程信息。
$ for i in  `docker ps |grep Up|awk '{print $1}'`;do echo \ &&docker top $i; done
```

#### **docker attach :**连接到正在运行中的容器。

##### 语法

```shell
$ docker attach [OPTIONS] CONTAINER
```

要attach上去的容器必须正在运行，可以同时连接上同一个container来共享屏幕（与screen命令的attach类似）。

官方文档中说attach后可以通过CTRL-C来detach，但实际上经过我的测试，如果container当前在运行bash，CTRL-C自然是当前行的输入，没有退出；如果container当前正在前台运行进程，如输出nginx的access.log日志，CTRL-C不仅会导致退出容器，而且还stop了。这不是我们想要的，detach的意思按理应该是脱离容器终端，但容器依然运行。好在attach是可以带上--sig-proxy=false来确保CTRL-D或CTRL-C不会关闭容器。

##### 示例

容器mynginx将访问日志指到标准输出，连接到容器查看访问信息。

```shell
$ docker attach --sig-proxy=false mynginx
192.168.239.1 - - [10/Jul/2016:16:54:26 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.93 Safari/537.36" "-"
```

#### **docker events :** 从服务器获取实时事件

##### 语法

```shell
$ docker events [OPTIONS]
```

OPTIONS说明：

- **-f ：**根据条件过滤事件；
- **--since ：**从指定的时间戳后显示所有事件;
- **--until ：**流水时间显示到指定的时间为止；

##### 示例

```shell
# 显示docker 2021年3月20日后的所有事件。
$ docker events  --since="1616233483"


# 显示docker 2021年3月20日后的所有事件.
$ docker events -f "image"="mysql" --since="1616233483" 

```

如果指定的时间是到秒级的，需要将时间转成时间戳。如果时间为日期的话，可以直接使用，如--since="2021-03-20"。

#### **docker logs :** 获取容器的日志

##### 语法

```shell
$ docker logs [OPTIONS] CONTAINER
```

OPTIONS说明：

- **-f :** 跟踪日志输出
- **--since :**显示某个开始时间的所有日志
- **-t :** 显示时间戳
- **--tail :**仅列出最新N条容器日志

##### 示例

```shell
# 跟踪查看容器mynginx的日志输出。
$ docker logs -f mynginx
192.168.239.1 - - [10/Jul/2016:16:53:33 +0000] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.93 Safari/537.36" "-"
2016/07/10 16:53:33 [error] 5#5: *1 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 192.168.239.1, server: localhost, request: "GET /favicon.ico HTTP/1.1", host: "192.168.239.130", referrer: "http://192.168.239.130/"
192.168.239.1 - - [10/Jul/2016:16:53:33 +0000] "GET /favicon.ico HTTP/1.1" 404 571 "http://192.168.239.130/" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.93 Safari/537.36" "-"
192.168.239.1 - - [10/Jul/2016:16:53:59 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.93 Safari/537.36" "-"
...
```

查看容器mynginx从2021-03-20后的最新10条日志。

```shell
$ docker logs --since="2021-03-20" --tail=10 mynginx
```

#### **docker wait :** 阻塞运行直到容器停止，然后打印出它的退出代码。

##### 语法

```shell
$ docker wait [OPTIONS] CONTAINER [CONTAINER...]
```

##### 示例

```shell
$ docker wait CONTAINER
```

#### **docker export :**将文件系统作为一个tar归档文件导出到STDOUT。

##### 语法

```shell
$ docker export [OPTIONS] CONTAINER
```

OPTIONS说明：

- **-o :**将输入内容写到文件。

##### 示例

```shell
# 将id为46162045d607的容器按日期保存为tar文件。
$ docker export -o mysql-`date +%Y%m%d`.tar 46162045d607
$ ls mysql-`date +%Y%m%d`.tar
mysql-20210320.tar
```

#### **docker port :**列出指定的容器的端口映射，或者查找将PRIVATE_PORT NAT到面向公众的端口。

##### 语法

```shell
$ docker port [OPTIONS] CONTAINER [PRIVATE_PORT[/PROTO]]
```

##### 示例

```shell
# 查看容器mynginx的端口映射情况。
$ docker port mymysql
3306/tcp -> 0.0.0.0:3306
```

### 容器rootfs命令

#### **docker commit :**从容器创建一个新的镜像。

##### 语法

```shell
$ docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]
```

OPTIONS说明：

- **-a :**提交的镜像作者；

- **-c :**使用Dockerfile指令来创建镜像；

- **-m :**提交时的说明文字；

- **-p :**在commit时，将容器暂停。

##### 示例

```shell
# 将容器46162045d607 保存为新的镜像,并添加提交人信息和说明信息。
$ docker commit -a "e6gps" -m "my apache" 46162045d607  mymysql:v1 
sha256:37af1236adef1544e8886be23010b66577647a40bc02c0885a6600b33ee28057
$ docker images mymysql:v1
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mymysql             v1                  37af1236adef        15 seconds ago      329 MB
```

#### **docker cp :**用于容器与主机之间的数据拷贝。

##### 语法

```shell
$ docker cp [OPTIONS] CONTAINER:SRC_PATH DEST_PATH|-
$ docker cp [OPTIONS] SRC_PATH|- CONTAINER:DEST_PATH
```

OPTIONS说明：

- **-L :**保持源目标中的链接

##### 示例

```shell
# 将主机/www/e6目录拷贝到容器96f7f14e99ab的/www目录下。
$ docker cp /www/e6 96f7f14e99ab:/etc/nginx/conf.d

# 将主机/www/e6目录拷贝到容器96f7f14e99ab中，目录重命名为www。
$ docker cp /www/e6 96f7f14e99ab:/www

# 将容器96f7f14e99ab的/www目录拷贝到主机的/tmp目录中。
$ docker cp  96f7f14e99ab:/www /tmp/
```

#### **docker diff :** 检查容器里文件结构的更改。

##### 语法

```shell
$ docker diff [OPTIONS] CONTAINER
```

##### 示例

```shell
# 查看容器mymysql的文件结构更改。
$ docker diff mymysql
A /logs
A /mysql_data
C /run
C /run/mysqld
A /run/mysqld/mysqld.pid
A /run/mysqld/mysqld.sock
C /tmp
```

### 镜像仓库

#### docker login/logout

**docker login :** 登陆到一个Docker镜像仓库，如果未指定镜像仓库地址，默认为官方仓库 Docker Hub

**docker logout :** 登出一个Docker镜像仓库，如果未指定镜像仓库地址，默认为官方仓库 Docker Hub

##### 语法

```shell
$ docker login [OPTIONS] [SERVER]
$ docker logout [OPTIONS] [SERVER]
```

OPTIONS说明：

- **-u :**登陆的用户名
- **-p :**登陆的密码

##### 示例

```shell
# 登陆到阿里云
$ docker login --username=lanjiaxuan@e6yun registry.cn-shenzhen.aliyuncs.com
# 登出# 登出Docker Hub
$ docker logout
```

#### **docker pull :** 从镜像仓库中拉取或者更新指定镜像

##### 语法

```shell
$ docker pull [OPTIONS] NAME[:TAG|@DIGEST]
```

OPTIONS说明：

- **-a :**拉取所有 tagged 镜像

- **--disable-content-trust :**忽略镜像的校验,默认开启

##### 示例

```shell
# 从Docker Hub下载java最新版镜像。
$ docker pull registry.cn-shenzhen.aliyuncs.com/base_e6yw/nginxdemo:v1

# 从Docker Hub下载REPOSITORY为java的所有镜像。
$ docker pull -a java
```

#### **docker push :** 将本地的镜像上传到镜像仓库,要先登陆到镜像仓库

##### 语法

```shell
$ docker push [OPTIONS] NAME[:TAG]
```

OPTIONS说明：

- **--disable-content-trust :**忽略镜像的校验,默认开启

##### 示例

```shell
# 上传本地镜像myapache:v1到镜像仓库中。
$ docker tag 159d74e6cbce registry.cn-shenzhen.aliyuncs.com/base_e6yw/mysqldemo:v1
$ docker push registry.cn-shenzhen.aliyuncs.com/base_e6yw/mysqldemo:v1
```

#### **docker search :** 从Docker Hub查找镜像

##### 语法

```shell
$ docker search [OPTIONS] TERM
```

OPTIONS说明：

- **--automated :**只列出 automated build类型的镜像；
- **--no-trunc :**显示完整的镜像描述；
- **-f <过滤条件>:**列出收藏数不小于指定值的镜像。

##### 示例

```shell
# 从 Docker Hub 查找所有镜像名包含 java，并且收藏数大于 10 的镜像
$ docker search -f stars=10 java
NAME                              DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
node                              Node.js is a JavaScript-based platform for s…   9857      [OK]       
tomcat                            Apache Tomcat is an open source implementati…   2980      [OK]       
openjdk                           OpenJDK is an open-source implementation of …   2664      [OK]       
java                              Java is a concurrent, class-based, and objec…   1976      [OK]       
ghost                             Ghost is a free and open source blogging pla…   1338      [OK]       
couchdb                           CouchDB is a database that uses JSON for doc…   393       [OK]       
jetty                             Jetty provides a Web server and javax.servle…   356       [OK]       
groovy                            Apache Groovy is a multi-faceted language fo…   105       [OK]       
lwieske/java-8                    Oracle Java 8 Container - Full + Slim - Base…   49                   [OK]
nimmis/java-centos                This is docker images of CentOS 7 with diffe…   42                   [OK]
fabric8/java-jboss-openjdk8-jdk   Fabric8 Java Base Image (JBoss, OpenJDK 8)      29                   [OK]
cloudbees/java-build-tools        Docker image with commonly used tools to bui…   15                   [OK]
frekele/java                      docker run --rm --name java frekele/java        12                   [OK]

```

参数说明：

**NAME:** 镜像仓库源的名称

**DESCRIPTION:** 镜像的描述

**OFFICIAL:** 是否 docker 官方发布

**stars:** 类似 Github 里面的 star，表示点赞、喜欢的意思。

**AUTOMATED:** 自动构建。

### 本地镜像管理

#### **docker images :** 列出本地镜像。

##### 语法

```shell
$ docker images [OPTIONS] [REPOSITORY[:TAG]]
```

OPTIONS说明：

- **-a :**列出本地所有的镜像（含中间映像层，默认情况下，过滤掉中间映像层）；

- **--digests :**显示镜像的摘要信息；

- **-f :**显示满足条件的镜像；

- **--format :**指定返回值的模板文件；

- **--no-trunc :**显示完整的镜像信息；

- **-q :**只显示镜像ID。

  

##### 示例

```shell
# 查看本地镜像列表。
$ docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
mymysql                 v1                  37af1236adef        5 minutes ago       329 MB
e6/ubuntu           v4                  1c06aa18edee        2 days ago          142.1 MB
<none>                  <none>              5c6e1090e771        2 days ago          165.9 MB
httpd                   latest              ed38aaffef30        11 days ago         195.1 MB
alpine                  latest              4e38e38c8ce0        2 weeks ago         4.799 MB
mongo                   3.2                 282fd552add6        3 weeks ago         336.1 MB
redis                   latest              4465e4bcad80        3 weeks ago         185.7 MB
php                     5.6-fpm             025041cd3aa5        3 weeks ago         456.3 MB
python                  3.5                 045767ddf24a        3 weeks ago         684.1 MB
...



# 列出本地镜像中REPOSITORY为nginx的镜像列表。
$ docker images  nginx
```

#### **docker rmi :** 删除本地一个或多少镜像。

##### 语法

```shell
$ docker rmi [OPTIONS] IMAGE [IMAGE...]
```

OPTIONS说明：

- **-f :**强制删除；

- **--no-prune :**不移除该镜像的过程镜像，默认移除；

##### 示例

```shell
# 强制删除本地镜像 e6/ubuntu:v4。
$ docker rmi -f e6/ubuntu:v4
Untagged: e6/ubuntu:v4
Deleted: sha256:1c06aa18edee44230f93a90a7d88139235de12cd4c089d41eed8419b503072be
Deleted: sha256:85feb446e89a28d58ee7d80ea5ce367eebb7cec70f0ec18aa4faa874cbd97c73
```

#### **docker tag :** 标记本地镜像，将其归入某一仓库。

##### 语法

```shell
$ docker tag [OPTIONS] IMAGE[:TAG] [REGISTRYHOST/][USERNAME/]NAME[:TAG]
```

##### 示例

```shell
# 将镜像ubuntu:15.10标记为 e6/ubuntu:v3 镜像。
$ docker tag ubuntu:15.10 e6/ubuntu:v3
$ docker images   e6/ubuntu:v3
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
e6/ubuntu       v3                  4e3b13c8a266        3 months ago        136.3 MB
```

#### **docker build** 命令用于使用 Dockerfile 创建镜像。

##### 语法

```shell
$ docker build [OPTIONS] PATH | URL | -
```

OPTIONS说明：

- **--build-arg=[] :**设置镜像创建时的变量；
- **--cpu-shares :**设置 cpu 使用权重；
- **--cpu-period :**限制 CPU CFS周期；
- **--cpu-quota :**限制 CPU CFS配额；
- **--cpuset-cpus :**指定使用的CPU id；
- **--cpuset-mems :**指定使用的内存 id；
- **--disable-content-trust :**忽略校验，默认开启；
- **-f :**指定要使用的Dockerfile路径；
- **--force-rm :**设置镜像过程中删除中间容器；
- **--isolation :**使用容器隔离技术；
- **--label=[] :**设置镜像使用的元数据；
- **-m :**设置内存最大值；
- **--memory-swap :**设置Swap的最大值为内存+swap，"-1"表示不限swap；
- **--no-cache :**创建镜像的过程不使用缓存；
- **--pull :**尝试去更新镜像的新版本；
- **--quiet, -q :**安静模式，成功后只输出镜像 ID；
- **--rm :**设置镜像成功后删除中间容器；
- **--shm-size :**设置/dev/shm的大小，默认值是64M；
- **--ulimit :**Ulimit配置。
- **--squash :**将 Dockerfile 中所有的操作压缩为一层。
- **--tag, -t:** 镜像的名字及标签，通常 name:tag 或者 name 格式；可以在一次构建中为一个镜像设置多个标签。
- **--network:** 默认 default。在构建期间设置RUN指令的网络模式

##### 示例

```shell
# 使用当前目录的 Dockerfile 创建镜像，标签为 e6/ubuntu:v1。
$ docker build -t e6/ubuntu:v1 . 

# 也可以通过 -f Dockerfile 文件的位置：
$ docker build -f /path/to/a/Dockerfile .

# 在 Docker 守护进程执行 Dockerfile 中的指令前，首先会对 Dockerfile 进行语法检查，有语法错误时会返回：
$ docker build -t test/myapp .
Sending build context to Docker daemon 2.048 kB
Error response from daemon: Unknown instruction: RUNCMD
```

#### **docker history :** 查看指定镜像的创建历史。

##### 语法

```shell
$ docker history [OPTIONS] IMAGE
```

OPTIONS说明：

- **-H :**以可读的格式打印镜像大小和日期，默认为true；

- **--no-trunc :**显示完整的提交记录；

- **-q :**仅列出提交记录ID。

##### 示例

查看本地镜像e6/ubuntu:v3的创建历史。

```shell
$ docker history e6/ubuntu:v1
IMAGE          CREATED        CREATED BY                                      SIZE      COMMENT
e76ebd704270   2 days ago     /bin/sh -c #(nop)  CMD ["curl" "-s" "http://…   0B        
643a0fed86a9   2 days ago     /bin/sh -c apt-get update && apt-get install…   16.2MB    
9499db781771   4 months ago   /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B        
<missing>      4 months ago   /bin/sh -c mkdir -p /run/systemd && echo 'do…   7B        
<missing>      4 months ago   /bin/sh -c rm -rf /var/lib/apt/lists/*          0B        
<missing>      4 months ago   /bin/sh -c set -xe   && echo '#!/bin/sh' > /…   745B      
<missing>      4 months ago   /bin/sh -c #(nop) ADD file:8eef54430e581236e…   131MB  
```

#### **docker save :** 将指定镜像保存成 tar 归档文件。

##### 语法

```shell
$ docker save [OPTIONS] IMAGE [IMAGE...]
```

OPTIONS 说明：

- **-o :**输出到的文件。

  

##### 示例

将镜像 e6/ubuntu:v3 生成 my_ubuntu_v3.tar 文档

```shell
$ docker save -o my_ubuntu_v1.tar e6/ubuntu:v1
$ ll my_ubuntu_v1.tar
-rw------- 1 e6 e6 142102016 Jul 11 01:37 my_ubuntu_v1.tar
```

#### **docker load :** 导入使用 [docker save](https://www.e6.com/docker/docker-save-command.html) 命令导出的镜像。

##### 语法

```shell
$ docker load [OPTIONS]
```

OPTIONS 说明：

- **--input , -i :** 指定导入的文件，代替 STDIN。

- **--quiet , -q :** 精简输出信息。

##### 示例

导入镜像：

```shell
$ docker image ls

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE

$ docker load < my_ubuntu_v1.tar

Loaded image: e6/ubuntu:v1
$ docker images
REPOSITORY                                              TAG       IMAGE ID       CREATED          SIZE
mymysql                                                 v1        159d74e6cbce   12 minutes ago   302MB
registry.cn-shenzhen.aliyuncs.com/base_e6yw/mysqldemo   v1        159d74e6cbce   12 minutes ago   302MB
<none>                                                  <none>    17c51e0230b6   2 days ago       302MB
e6/ubuntu                                               v1        e76ebd704270   2 days ago       147MB
myip                                                    latest    e76ebd704270   2 days ago       147MB
nginx                                                   latest    f6d0b4767a6c   2 months ago     133MB
mysql                                                   5.6       6e68afc1976f   2 months ago     302MB
ubuntu                                                  16.04     9499db781771   4 months ago     131MB

$ docker load --input my_ubuntu_v1.tar

Loaded image: e6/ubuntu:v1

$ docker images
REPOSITORY                                              TAG       IMAGE ID       CREATED          SIZE
mymysql                                                 v1        159d74e6cbce   13 minutes ago   302MB
registry.cn-shenzhen.aliyuncs.com/base_e6yw/mysqldemo   v1        159d74e6cbce   13 minutes ago   302MB
<none>                                                  <none>    17c51e0230b6   2 days ago       302MB
e6/ubuntu                                               v1        e76ebd704270   2 days ago       147MB
myip                                                    latest    e76ebd704270   2 days ago       147MB
nginx                                                   latest    f6d0b4767a6c   2 months ago     133MB
mysql                                                   5.6       6e68afc1976f   2 months ago     302MB
ubuntu                                                  16.04     9499db781771   4 months ago     131MB
```

#### **docker import :** 从归档文件中创建镜像。

##### 语法

```shell
$ docker import [OPTIONS] file|URL|- [REPOSITORY[:TAG]]
```

OPTIONS说明：

- **-c :**应用docker 指令创建镜像；

- **-m :**提交时的说明文字；

  

##### 示例

```shell
# 从镜像归档文件my_ubuntu_v3.tar创建镜像，命名为e6/ubuntu:v4
$ docker import  my_ubuntu_v1.tar e6/ubuntu:v2  
sha256:7e6f3bd25c59e8c18206457cc403544278eb9049641e894a7a8576220fdcf398
$ docker images e6/ubuntu:v2
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
e6/ubuntu    v2        7e6f3bd25c59   25 seconds ago   152MB
```

### info|version

#### docker info : 显示 Docker 系统信息，包括镜像和容器数。。

##### 语法

```shell
$ docker info
```

##### 示例



```shell
# 查看docker系统信息。
$ docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  app: Docker App (Docker Inc., v0.9.1-beta3)
  buildx: Build with BuildKit (Docker Inc., v0.5.1-docker)

Server:
 Containers: 5
  Running: 3
  Paused: 0
  Stopped: 2
 Images: 7
 Server Version: 20.10.5
 Storage Driver: overlay2
  Backing Filesystem: xfs
  Supports d_type: true
  Native Overlay Diff: true
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 1
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 io.containerd.runtime.v1.linux runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 05f951a3781f4f2c1911b05e61c160e9c30eaa8e
 runc version: 12644e614e25b05da6fd08a38ffa0cfe1903fdec
 init version: de40ad0
 Security Options:
  seccomp
   Profile: default
 Kernel Version: 3.10.0-1160.el7.x86_64
 Operating System: CentOS Linux 7 (Core)
 OSType: linux
 Architecture: x86_64
 CPUs: 4
 Total Memory: 15.19GiB
 Name: localhost.localdomain
 ID: 5PCC:SY6I:UAAH:CLPH:FDXT:A2EN:KWEA:7S3W:4HEA:WO3B:2HJR:3PN7
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Registry Mirrors:
  https://7xatqpwu.mirror.aliyuncs.com/
 Live Restore Enabled: false
```

#### docker version :显示 Docker 版本信息。

##### 语法

```shell
$ docker version [OPTIONS]
```

OPTIONS说明：

- **-f :**指定返回值的模板文件。

  

##### 实例

```shell
# 显示 Docker 版本信息。
$ docker version
Client: Docker Engine - Community
 Version:           20.10.5
 API version:       1.41
 Go version:        go1.13.15
 Git commit:        55c4c88
 Built:             Tue Mar  2 20:33:55 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.5
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.13.15
  Git commit:       363e9a8
  Built:            Tue Mar  2 20:32:17 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.4
  GitCommit:        05f951a3781f4f2c1911b05e61c160e9c30eaa8e
 runc:
  Version:          1.0.0-rc93
  GitCommit:        12644e614e25b05da6fd08a38ffa0cfe1903fdec
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

```



# kubernetes

## 什么是kubernetes

Kubernetes 是 Google 团队发起的一个开源项目，它的目标是管理跨多个主机的容器，用于自动部署、扩展和管理容器化的应用程序，主要实现语言为 Go 语言。

## kubernetes 的组成

- Master：Master 节点是 Kubernetes 集群的控制节点，负责整个集群的管理和控制。Master 节点上包含以下组件：
- kube-apiserver：集群控制的入口，提供 HTTP REST 服务
- kube-controller-manager：Kubernetes 集群中所有资源对象的自动化控制中心
- kube-scheduler：负责 Pod 的调度



- Node：Node 节点是 Kubernetes 集群中的工作节点，Node 上的工作负载由 Master 节点分配，工作负载主要是运行容器应用。Node 节点上包含以下组件：

  - kubelet：负责 Pod 的创建、启动、监控、重启、销毁等工作，同时与 Master 节点协作，实现集群管理的基本功能。
  - kube-proxy：实现 Kubernetes Service 的通信和负载均衡
  - 运行容器化(Pod)应用

  

- Pod: Pod 是 Kubernetes 最基本的部署调度单元。每个 Pod 可以由一个或多个业务容器和一个根容器(Pause 容器)组成。一个 Pod 表示某个应用的一个实例

- ReplicaSet：是 Pod 副本的抽象，用于解决 Pod 的扩容和伸缩

- Deployment：Deployment 表示部署，在内部使用ReplicaSet 来实现。可以通过 Deployment 来生成相应的 ReplicaSet 完成 Pod 副本的创建

- Service：Service 是 Kubernetes 最重要的资源对象。Kubernetes 中的 Service 对象可以对应微服务架构中的微服务。Service 定义了服务的访问入口，服务的调用者通过这个地址访问 Service 后端的 Pod 副本示例。Service 通过 Label Selector 同后端的 Pod 副本建立关系，Deployment 保证后端Pod 副本的数量，也就是保证服务的伸缩性。

![k8s basic](https://www.qikqiak.com/k8s-book/docs/images/k8s-basic.png)





## kubectl管理工具以及命令

### 基础命令

#### kubectl create 创建

通过配置文件名或stdin创建一个集群资源对象。

支持JSON和YAML格式的文件。

##### 语法

```shell
$ kubectl create -f FILENAME
```

##### 示例

```shell
# 通过pod.json文件创建一个pod。
$ kubectl create -f ./pod.json

# 通过stdin的JSON创建一个pod。
$ cat pod.json | kubectl create -f -
```

#### kubectl apply 创建/更新

通过配置文件名或stdin创建一个集群资源对象。

支持JSON和YAML格式的文件。

##### 语法

```shell
$ kubectl apply -f FILENAME
```

##### 示例

```shell
# 通过pod.json文件创建一个pod。
$ kubectl apply -f ./pod.json

# 通过stdin的JSON创建一个pod。
$ cat pod.json | kubectl apply -f -
```

##### 注意

<font color='red' size='3'>**kubectl create命令可创建新资源。 因此，如果再次运行该命令，则会抛出错误，因为资源名称在名称空间中应该是唯一的。**</font>

<font color='red' size='3'>**kubectl apply命令将配置应用于资源。 如果资源不在那里，那么它将被创建。 kubectl apply命令可以第二次运行，如果资源在那里，那么它将配置应用于现有资源**</font>

<font color='red' size='3'>**简单来说，如果在单个文件上运行操作以创建资源，则create和apply基本相同。 但是， apply允许您在目录下的多个文件上同时创建和修补。**</font>

#### kubectl delete 删除

通过配置文件名、stdin、资源名称或label选择器来删除资源。

##### 语法

```shell
$ kubectl delete ([-f FILENAME] | TYPE [(NAME | -l label | --all)])
```

##### 示例

```shell
# 使用 pod.json中指定的资源类型和名称删除pod。
$ kubectl delete -f ./pod.json

# 根据传入stdin的JSON所指定的类型和名称删除pod。
$ cat pod.json | kubectl delete -f -

# 删除名为“baz”和“foo”的Pod和Service。
$ kubectl delete pod,service baz foo

# 删除 Label name = myLabel的pod和Service。
$ kubectl delete pods,services -l name=myLabel

# 强制删除dead node上的pod
$ kubectl delete pod foo --grace-period=0 --force

# 删除所有pod
$ kubectl delete pods --all
```



#### kubectl get获取资源信息

获取列出一个或多个资源的信息。

可以使用的资源包括：

- all 
- certificatesigningrequests (aka 'csr')  
- clusterrolebindings
- clusterroles
- clusters (valid only for federation apiservers)
- componentstatuses (aka 'cs')
- configmaps (aka 'cm')
- controllerrevisions
- cronjobs
- daemonsets (aka 'ds')
- deployments (aka 'deploy')
- endpoints (aka 'ep')
- events (aka 'ev')
- horizontalpodautoscalers (aka 'hpa')
- ingresses (aka 'ing')
- jobs
- limitranges (aka 'limits')
- namespaces (aka 'ns')
- networkpolicies (aka 'netpol')
- nodes (aka 'no')
- persistentvolumeclaims (aka 'pvc')
- persistentvolumes (aka 'pv')
- poddisruptionbudgets (aka 'pdb')
- podpreset
- pods (aka 'po')
- podsecuritypolicies (aka 'psp')
- podtemplates
- replicasets (aka 'rs')
- replicationcontrollers (aka 'rc')
- resourcequotas (aka 'quota')
- rolebindings
- roles
- secrets
- serviceaccounts (aka 'sa')
- services (aka 'svc')
- statefulsets
- storageclasses
- thirdpartyresources

##### 语法

```shell
$ kubectl get resource名称
```

##### OPTIONS说明：

- -o wide/yaml/json				用不同的格式查看
- -l key=value				           看指定标签的pods，支持’=’, ‘==’, and ‘!=’操作符

- -n 命名空间			          	查看指定的命名空间

##### 示例

```shell
# 查看Master状态
$ kubectl get componentstatuses

# 查看所有命名空间
$ kubectl get namespace

# 列出所有的pods
$ kubectl get pods

# 显示更多的pods列表信息(例如 pod的ip和所处的node)
$ kubectl get pods -o wide

# 列出名字为web的rc
$ kubectl get replicationcontroller web

# 获取名字为web-pod-13je7的pod的信息，并以json格式输出
$ kubectl get -o json pod web-pod-13je7

# 根据pod文件查找pod，并以json格式输出
$ kubectl get -f pod.yaml -o json

# 获取pod容器的状态
$ kubectl get -o template pod/kube-dns-795f5f6f9c-ldxxs --template {{.status.phase}}

# 同时获取所有的rc和service
$ kubectl get rc,services

# 获取符合条件的所有rc,svc,pod
$ kubectl get rc/web service/frontend pods/web-pod-13je7

# 获取所有resource
$ kubectl get all
```

#### kubectl run创建并运行

- 创建并运行一个或多个容器镜像。
- 创建一个deployment 或job 来管理容器。

##### 语法

```shell
$ kubectl run NAME --image=image [--env="key=value"] [--port=port] [--replicas=replicas] [--dry-run=bool] [--overrides=inline-json] [--command] -- [COMMAND] [args...]
```

##### 示例：

```shell
# 启动nginx实例。
$ kubectl run nginx --image=nginx

# hazelcast实例，暴露容器端口 5701。
$ kubectl run hazelcast --image=hazelcast --port=5701

# 启动hazelcast实例，在容器中设置环境变量“DNS_DOMAIN = cluster”和“POD_NAMESPACE = default”。
$ kubectl run hazelcast --image=hazelcast --env="DNS_DOMAIN=cluster" --env="POD_NAMESPACE=default"

# 启动nginx实例，设置副本数5。
$ kubectl run nginx --image=nginx --replicas=5

#  Dry  打印相应的API对象而不创建它们。
$ kubectl run nginx --image=nginx --dry-run
```

#### kubectl expose 创建资源的service

将资源暴露为新的Kubernetes Service。

指定deployment、service、replica set、replication controller或pod ，并使用该资源的选择器作为指定端口上新服务的选择器。deployment 或 replica set只有当其选择器可转换为service支持的选择器时，即当选择器仅包含matchLabels组件时才会作为暴露新的Service。

资源包括(不区分大小写)：

pod（po），service（svc），replication controller（rc），deployment（deploy），replica set（rs）

##### 语法

```shell
$ kubectl expose (-f FILENAME | TYPE NAME) [--port=port] [--protocol=TCP|UDP] [--target-port=number-or-name] [--name=name] [--external-ip=external-ip-of-service] [--type=type]
```

##### 示例

```shell
# 为RC的deployment创建service，并通过Service的80端口转发至宿主机端口上。
$ kubectl expose deployment centos7-test2 --port=22 --type=NodePort
```

#### kubectl set配置应用资源

配置应用资源。

使用这些命令能帮你更改现有应用资源一些信息。

##### 语法

```shell
$ kubectl set SUBCOMMAND
```

##### 子命令

- image
- resources
- selector
- subject



#### kubectl edit 使用默认编辑器 编辑服务器上定义的资源。

使用命令行工具获取的任何资源都可以使用edit命令编辑。edit命令会打开使用KUBE_EDITOR，GIT_EDITOR 或者EDITOR环境变量定义的编辑器，可以同时编辑多个资源，但所编辑过的资源只会一次性提交。edit除命令参数外还接受文件名形式。

文件默认输出格式为YAML。要以JSON格式编辑，请指定“-o json”选项。

如果在更新资源时报错，将会在磁盘上创建一个临时文件来记录。在更新资源时最常见的错误是几个用户同时使用编辑器更改服务器上资源，发生这种情况，你需要将你的更改应用到最新版本的资源上，或者更新保存的临时副本。

##### 语法

```shell
$ kubectl edit (RESOURCE/NAME | -f FILENAME)
```

##### 示例

```shell
# 编辑名为'centos7-test2'的service：
$ kubectl edit svc centos7-test2 -n test
```



### 故障排查和调试命令

#### kubtctl describe输出指定的一个/多个资源的详细信息

输出指定的一个/多个资源的详细信息。

此命令组合调用多条API，输出指定的一个或者一组资源的详细描述。

##### 语法

```shell
$ kubectl describe (-f FILENAME | TYPE [NAME_PREFIX | -l label] | TYPE/NAME)
```

##### 示例

```shell
# 描述一个node
$ kubectl describe nodes k8s-master

# 描述一个pod
$ kubectl describe pods/nginx

# 描述deployment_centos7.yaml中的资源类型和名称指定的pod
$ kubectl describe -f deployment_centos7.yaml -n test

# 描述所有的pod
$ kubectl describe pods -n test
```

#### kubectl  logs日志查看

查看容器日志

##### 语法

```shell
$ kubectl logs [-f] [-p] (POD | TYPE/NAME) [-c CONTAINER] [options]
```

##### 示例

```shell
# 输出一个单容器pod my-pod的日志到标准输出
$ kubectl logs pod/centos7-test2-5dbbc849f4-f6w77 -n test

# 输出多容器pod中的某个nginx容器的日志
$ kubectl logs nginx-78f5d695bd-czm8z -c nginx

# 输出所有包含app-nginx标签的pod日志
$ kubectl logs -l app=nginx

# 加上-f参数跟踪日志，类似tail -f
$ kubectl logs -f my-pod
                       
# 输出该pod的上一个退出的容器实例日志。在pod容器异常退出时很有用
$ kubectl logs my-pod  -p

# 指定时间戳输出日志          
$ kubectl logs my-pod  --since-time=2018-11-01T15:00:00Z

# 指定时间段输出日志，单位s/m/h
$ kubectl logs my-pod  --since=1h 
```

#### kubectl exec 执行容器的命令

exec主要作用是在容器内部执行命令（一般为查看容器内部日志

##### 语法

```bash
$ kubectl exec -it podName  -c  containerName -n namespace -- shell comand
```

##### 示例

```shell
 # 进入centos  的pod
 $ kubectl exec -it pod/centos7-test2-5dbbc849f4-f6w77 /bin/bash -n test
```



#### kubectl cp文件传输

文件传输

##### 语法：

```shell
$ kubectl cp <file-spec-src> <file-spec-dest> [options]
```

##### 示例

```shell
# 拷贝宿主机本地文件夹到pod
$ kubectl cp /tmp/foo_dir <some-pod>:/tmp/bar_dir     

# 指定namespace的拷贝pod文件到宿主机本地目录
$ kubectl cp <some-namespace>/<some-pod>:/tmp/foo /tmp/bar  

# 对于多容器pod，用-c指定容器名
$ kubectl cp /tmp/foo <some-pod>:/tmp/bar -c <specific-container> 
```

### kubectl 部署命令

#### kubectl rollout对资源进行管理

可用资源包括：

- deployments
- daemonsets

##### 语法

```shell
$ kubectl rollout SUBCOMMAND
```

##### 示例

```shell
# 回滚到之前的deployment
$ $ kubectl rollout undo deployment/abc

# 查看daemonet的状态
$ kubectl rollout status daemonset/foo
```

#### kubectl rolling-update执行指定ReplicationController的滚动更新。

该命令创建了一个新的RC， 然后一次更新一个pod方式逐步使用新的PodTemplate，最终实现Pod滚动更新，new-controller.json需要与之前RC在相同的namespace下。

##### 语法：

```shell
$ kubectl rolling-update OLD_CONTROLLER_NAME ([NEW_CONTROLLER_NAME] --image=NEW_CONTAINER_IMAGE | -f NEW_CONTROLLER_SPEC)
```

##### 示例

```shell
# 使用frontend-v2.json中的新RC数据更新frontend-v1的pod
$ kubectl rolling-update frontend-v1 -f frontend-v2.json


# 使用JSON数据更新frontend-v1的pod。
$ cat frontend-v2.json | kubectl rolling-update frontend-v1 -f -
```

#### kubectl scale扩容或缩容 Deployment、ReplicaSet、Replication Controller或 Job 中Pod数量。

scale也可以指定多个前提条件，如：当前副本数量或 --resource-version ，进行伸缩比例设置前，系统会先验证前提条件是否成立。

##### 语法

```shell
$ kubectl scale [--resource-version=version] [--current-replicas=count] --replicas=COUNT (-f FILENAME | TYPE NAME)
```

##### 示例

```shell
# 将名为centos7-test2的pod副本数设置为3
$ kubectl scale --replicas=3 deployment/centos7-test2 -n test
```

#### kubectl autoscale使用 autoscaler 自动设置在kubernetes集群中运行的pod数量（水平自动伸缩）

指定Deployment、ReplicaSet或ReplicationController，并创建已经定义好资源的自动伸缩器。使用自动伸缩器可以根据需要自动增加或减少系统中部署的pod数量。

##### 语法

```shell
$ kubectl autoscale (-f FILENAME | TYPE NAME | TYPE/NAME) [--min=MINPODS] --max=MAXPODS [--cpu-percent=CPU] [flags]
```

##### 示例

```shell
# 使用 Deployment “centos7-test2”设定，使用默认的自动伸缩策略，指定目标CPU使用率，使其Pod数量在2到10之间。
$ kubectl autoscale deployment centos7-test2 --min=2 --max=10
```



# Dockerfile 定制镜像

  **镜像的定制实际上就是定制每一层所添加的配置、文件**。如果我们可以把每一层修改、安装、构建、操作的命令都写入一个脚本，用这个脚本来构建、定制镜像，那么无法重复的问题、镜像构建透明性的问题、体积的问题就都会解决。这个脚本就是 `Dockerfile`。

`Dockerfile` 是一个文本文件，其内包含了一条条的`指令`(Instruction)，每一条指令构建一层，因此每一条指令的内容，就是描述该层应当如何构建。

```dockerfile
FROM nginx
RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
```

## Dockerfile 指令详解

### FROM 指定基础镜像

**所谓定制镜像，那一定是以一个镜像为基础，在其上进行定制。而 FROM 就是指定基础镜像，因此一个 `Dockerfile` 中 `FROM` 是必备的指令，并且`必须是第一条指令`。**

在 Docker Store 上有非常多的高质量的官方镜像，有可以直接拿来使用的服务类的镜像，如nginx 、 redis 、 mongo 、mysql 等；也有一些方便开发、构建、运行各种语言应用的镜像，如 node 、 openjdk 、 python 等。可以在其中寻找一个最符合我们最终目标的镜像为基础镜像进行定制。

  如果没有找到对应服务的镜像，官方镜像中还提供了一些更为基础的操作系统镜像，如ubuntu 、 debian 、 centos 等，这些操作系统的软件库为我们提供了更广阔的扩展空间。

  除了选择现有镜像为基础镜像外，Docker 还存在一个特殊的镜像，名为 scratch 。这个镜像是虚拟的概念，并不实际存在，它表示一个空白的镜像。

```dockerfile
FROM scratch
...
```


  如果你以 scratch 为基础镜像的话，意味着你不以任何镜像为基础，接下来所写的指令将作为镜像第一层开始存在。

  不以任何系统为基础，直接将可执行文件复制进镜像的做法并不罕见，比如 swarm 、 coreos/etcd 。对于 Linux 下静态编译的程序来说，并不需要有操作系统提供运行时支持，所需的一切库都已经在可执行文件里了，因此直接 FROM scratch 会让镜像体积更加小巧。使用 Go 语言 开发的应用很多会使用这种方式来制作镜像，这也是为什么有人认为 Go是特别适合容器微服务架构的语言的原因之一。

### RUN 执行命令

##### 语法：

`RUN` 指令是用来执行命令行命令的。由于命令行的强大能力， RUN 指令在定制镜像时是最常用的指令之一。其格式有两种：

- **shell 格式：** `RUN <命令>` ，就像直接在命令行中输入的命令一样。刚才写的 Dockerfile 中的 RUN 指令就是这种格式。

```dockerfile
RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
```

- **exec 格式：** `RUN ["可执行文件", "参数1", "参数2"]`，这更像是函数调用中的格式。

##### 注意：

​		既然 RUN 就像 Shell 脚本一样可以执行命令，那么我们是否就可以像 Shell 脚本一样把每个命令对应一个 RUN 呢？比如这样：

```dockerfile
FROM debian:jessie
RUN apt-get update
RUN apt-get install -y gcc libc6-dev make
RUN wget -O redis.tar.gz "http://download.redis.io/releases/redis-3.2.5.tar.gz"
RUN mkdir -p /usr/src/redis
RUN tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1
RUN make -C /usr/src/redis
RUN make -C /usr/src/redis install
```

之前说过，Dockerfile 中每一个指令都会建立一层， RUN 也不例外。每一个 RUN 的行为，就和刚才我们手工建立镜像的过程一样：新建立一层，在其上执行这些命令，执行结束后， commit 这一层的修改，构成新的镜像。

  而上面的这种写法，创建了 7 层镜像。这是完全没有意义的，而且很多运行时不需要的东西，都被装进了镜像里，比如编译环境、更新的软件包等等。结果就是产生非常臃肿、非常多层的镜像，不仅仅增加了构建部署的时间，也很容易出错。 这是很多初学 Docker 的人常犯的一个错误。

  Union FS （联合文件系统Union File System）是有最大层数限制的，比如 AUFS（早期docker的默认文件系统），曾经是最大不得超过 42 层，现在是不得超过127 层。

  上面的 Dockerfile 正确的写法应该是这样：

```dockerfile
FROM debian:jessie
RUN buildDeps='gcc libc6-dev make' \
    && apt-get update \
    && apt-get install -y $buildDeps \
    && wget -O redis.tar.gz "http://download.redis.io/releases/redis-3.2.5.tar.gz" \
    && mkdir -p /usr/src/redis \
    && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
    && make -C /usr/src/redis \
    && make -C /usr/src/redis install \
    && rm -rf /var/lib/apt/lists/* \
    && rm redis.tar.gz \
    && rm -r /usr/src/redis \
    && apt-get purge -y --auto-remove $buildDeps
```

##### 示例

  在 Dockerfile 文件所在目录执行：

```shell
$ docker build -t nginx:v3 .
Sending build context to Docker daemon 2.048 kB
Step 1 : FROM nginx
---> e43d811ce2f4
Step 2 : RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
---> Running in 9cdc27646c7b
---> 44aa4490ce2c
Removing intermediate container 9cdc27646c7b
Successfully built 44aa4490ce2c

$ docker run -d -P --name nginxdemo nignx:v3
```


  从命令的输出结果中，我们可以清晰的看到镜像的构建过程。在 Step 2 中，如同我们之前所说的那样， RUN 指令启动了一个容器 9cdc27646c7b ，执行了所要求的命令，并最后提交了这一层 44aa4490ce2c ，随后删除了所用到的这个容器 9cdc27646c7b 。


  在这里我们指定了最终镜像的名称 -t nginx:v3 ，构建成功后，我们可以直接运行这个镜像，其结果就是我们的主页被改变成了Hello, Docker!。

### COPY 复制文件

##### 语法：

- ```dockerfile
  COPY <源路径>... <目标路径>
  COPY ["<源路径1>",... "<目标路径>"]
  ```

##### 注意：

 1. <源路径> 可以是多个，甚至可以是通配符，其通配符规则要满足 Go 的 filepath.Match 规则

    ```dockerfile
    COPY hom* /mydir/
    COPY hom?.txt /mydir/
    ```

 2. <目标路径> 可以是容器内的绝对路径，也可以是相对于工作目录的相对路径（工作目录可以用 WORKDIR 指令来指定）。目标路径不需要事先创建，如果目录不存在会在复制文件前先行创建缺失目录。

 3. 和 RUN 指令一样，也有两种格式，一种类似于命令行，一种类似于函数调用。COPY 指令将从构建上下文目录中 <`源路径`> 的文件/目录复制到新的一层的镜像内的 <`目标路径`> 位置。比如：

    ```dockerfile
    COPY package.json /usr/src/app/
    ```

 4. 使用 COPY 指令，源文件的各种元数据都会保留。比如读、写、执行权限、文件变更时间等。这个特性对于镜像定制很有用。特别是构建相关文件都在使用 Git进行管理的时候

### ADD 更高级的复制文件

 ADD 指令和 COPY 的格式和性质基本一致。但是在 COPY 基础上增加了一些功能。比如 <源路径> 可以是一个 URL ，这种情况下，Docker 引擎会试图去下载这个链接的文件放到 <目标路径> 去。下载后的文件权限自动设置为 600 ，如果这并不是想要的权限，那么还需要增加额外的一层 RUN 进行权限调整，另外，如果下载的是个压缩包，需要解压缩，也一样还需要额外的一层 RUN 指令进行解压缩。所以不如直接使用 RUN 指令，然后使用 wget 或者 curl 工具下载，处理权限、解压缩、然后清理无用文件更合理。**因此，这个功能其实并不实用，而且不推荐使用**。

  如果 <源路径> 为一个 tar 压缩文件的话，压缩格式为 gzip , bzip2 以及 xz 的情况下， ADD 指令将会自动解压缩这个压缩文件到 <目标路径> 去。

  在某些情况下，这个自动解压缩的功能非常有用，比如官方镜像 ubuntu 中：

```dockerfile
FROM scratch
ADD ubuntu-xenial-core-cloudimg-amd64-root.tar.gz /
...
```


  但在某些情况下，如果我们真的是希望复制个压缩文件进去，而不解压缩，这时就不可以使用 ADD 命令了。

  但在某些情况下，如果我们真的是希望复制个压缩文件进去，而不解压缩，这时就不可以使用 ADD 命令了。

  在 Docker 官方的 Dockerfile 最佳实践文档 中要求，尽可能的使用 COPY ，因为 COPY 的语义很明确，就是复制文件而已，而 ADD 则包含了更复杂的功能，其行为也不一定很清晰。最适合使用 ADD 的场合，就是所提及的需要自动解压缩的场合。

  另外需要注意的是， ADD 指令会令镜像构建缓存失效，从而可能会令镜像构建变得比较缓慢。

  因此在 COPY 和 ADD 指令中选择的时候，可以遵循这样的原则，所有的文件复制均使用 COPY 指令，仅在需要自动解压缩的场合使用 ADD 。

### CMD 容器启动命令

##### 语法

CMD 指令的格式和 RUN 相似，也是两种格式：

```dockerfile
# shell 格式： 
CMD <命令>
# exec 格式： 
CMD ["可执行文件", "参数1", "参数2"...]


# 参数列表格式(在指定了 ENTRYPOINT 指令后，用 CMD 指定具体的参数)
CMD ["参数1", "参数2"...] 
```

##### 注意

1.**容器就是进程。**既然是进程，那么在启动容器的时候，需要指定所运行的程序及参数。 CMD 指令就是用于指定默认的容器主进程的启动命令的。

2.在运行时可以指定新的命令来替代镜像设置中的这个默认命令，比如， ubuntu 镜像默认的CMD 是 /bin/bash ，如果我们直接 docker run -it ubuntu 的话，会直接进入 bash 。我们也可以在运行时指定运行别的命令，如 docker run -it ubuntu cat /etc/os-release 。这就是用 cat /etc/os-release 命令替换了默认的 /bin/bash 命令了，输出了系统版本信息。
3.在指令格式上，一般推荐使用 `exec` 格式，这类格式在解析时会被解析为 `JSON 数组`，因此一定要使用双引号 `"` ，而不要使用单引号。

4.如果使用 shell 格式的话，实际的命令会被包装为 `sh -c` 的参数的形式进行执行。比如：

```dockerfile
CMD echo $HOME
```

 在实际执行中，会将其变更为：

```dockerfile
CMD [ "sh", "-c", "echo $HOME" ]
```

### ENTRYPOINT 入口点

ENTRYPOINT 的格式和 RUN 指令格式一样，分为 exec 格式和 shell 格式。

  ENTRYPOINT 的目的和 CMD 一样，都是在指定容器启动程序及参数。ENTRYPOINT 在运行时也可以替代，不过比 CMD 要略显繁琐，需要通过 docker run 的参数 –entrypoint 来指定。

  当指定了 ENTRYPOINT 后， CMD 的含义就发生了改变，不再是直接的运行其命令，而是将CMD 的内容作为参数传给 ENTRYPOINT 指令，换句话说实际执行时，将变为：

```
<ENTRYPOINT> "<CMD>"
```





### ENV 设置环境变量

##### 语法：

格式有两种：

- `ENV <key> <value>`
- `ENV <key1>=<value1> <key2>=<value2>...`



##### 示例：

```
ENV VERSION=1.0 DEBUG=on \
    NAME="Happy Feet"
```

##### 注意：

下列指令可以支持环境变量展开：
  **ADD 、 COPY 、 ENV 、 EXPOSE 、 LABEL 、 USER 、 WORKDIR 、 VOLUME 、 STOPSIGNAL 、 ONBUILD **

### VOLUME 定义匿名卷

##### 格式为：

```
VOLUME ["<路径1>", "<路径2>"...]
VOLUME <路径>
```


  之前我们说过，容器运行时应该尽量保持容器存储层不发生写操作，对于数据库类需要保存动态数据的应用，其数据库文件应该保存于卷(volume)中。为了防止运行时用户忘记将动态文件所保存目录挂载为卷，在 Dockerfile 中，我们可以事先指定某些目录挂载为匿名卷，这样在运行时如果用户不指定挂载，其应用也可以正常运行，不会向容器存储层写入大量数据。

```
VOLUME /data
```

  这里的 /data 目录就会在运行时自动挂载为匿名卷，任何向 /data 中写入的信息都不会记录进容器存储层，从而保证了容器存储层的无状态化。当然，运行时可以覆盖这个挂载设置。比如：

```shell
$ docker run -d -v mydata:/data xxxx

```


  在这行命令中，就使用了 mydata 这个命名卷挂载到了 /data 这个位置，替代了 Dockerfile 中定义的匿名卷的挂载配置。

### EXPOSE 声明端口

格式为

```
 EXPOSE <端口1> [<端口2>...]
```

  EXPOSE 指令是声明运行时容器提供服务端口，这只是一个声明，在运行时并不会因为这个声明应用就会开启这个端口的服务。在 Dockerfile 中写入这样的声明有两个好处，一个是帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射；另一个用处则是在运行时使用随机端口映射时，也就是 docker run -P 时，会自动随机映射 EXPOSE 的端口。

  此外，在早期 Docker 版本中还有一个特殊的用处。以前所有容器都运行于默认桥接网络中，因此所有容器互相之间都可以直接访问，这样存在一定的安全性问题。于是有了一个 Docker 引擎参数 --icc=false ，当指定该参数后，容器间将默认无法互访，除非互相间使用了 --links 参数的容器才可以互通，并且只有镜像中 EXPOSE 所声明的端口才可以被访问。这个 --icc=false 的用法，在引入了 docker network 后已经基本不用了，通过自定义网络可以很轻松的实现容器间的互联与隔离。

  要将 EXPOSE 和在运行时使用 -p <宿主端口>:<容器端口> 区分开来。 -p ，是映射宿主端口和容器端口，换句话说，就是将容器的对应端口服务公开给外界访问，而 EXPOSE 仅仅是声明容器打算使用什么端口而已，并不会自动在宿主进行端口映射。


### WORKDIR 指定工作目录

格式为

```
 WORKDIR <工作目录路径> 。
```

  使用 WORKDIR 指令可以来指定工作目录（或者称为当前目录），以后各层的当前目录就被改为指定的目录，如该目录不存在， WORKDIR 会帮你建立目录。

  之前提到一些初学者常犯的错误是把 Dockerfile 等同于 Shell 脚本来书写，这种错误的理解还可能会导致出现下面这样的错误：

```
RUN cd /app
RUN echo "hello" > world.txt
```

  如果将这个 Dockerfile 进行构建镜像运行后，会发现找不到 /app/world.txt 文件，或者其内容不是 hello 。原因其实很简单，在 Shell 中，连续两行是同一个进程执行环境，因此前一个命令修改的内存状态，会直接影响后一个命令；而在 Dockerfile 中，这两行 RUN 命令的执行环境根本不同，是两个完全不同的容器。这就是对 Dockerfile 构建分层存储的概念不了解所导致的错误。

  如果将这个 Dockerfile 进行构建镜像运行后，会发现找不到 /app/world.txt 文件，或者其内容不是 hello 。原因其实很简单，在 Shell 中，连续两行是同一个进程执行环境，因此前一个命令修改的内存状态，会直接影响后一个命令；而在 Dockerfile 中，这两行 RUN 命令的执行环境根本不同，是两个完全不同的容器。这就是对 Dockerfile 构建分层存储的概念不了解所导致的错误。

  之前说过每一个 RUN 都是启动一个容器、执行命令、然后提交存储层文件变更。第一层 RUNcd /app 的执行仅仅是当前进程的工作目录变更，一个内存上的变化而已，其结果不会造成任何文件变更。而到第二层的时候，启动的是一个全新的容器，跟第一层的容器更完全没关系，自然不可能继承前一层构建过程中的内存变化。

  因此如果需要改变以后各层的工作目录的位置，那么应该使用 WORKDIR 指令。




### USER 指定当前用户

格式： `USER <用户名>`USER 指令和 WORKDIR 相似，都是改变环境状态并影响以后的层。 WORKDIR 是改变工作目录， USER 则是改变之后层的执行 RUN , CMD 以及 ENTRYPOINT 这类命令的身份。当然，和 WORKDIR 一样， USER 只是帮助你切换到指定用户而已，这个用户必须是事先建立好的，否则无法切换。

```dockerfile
RUN groupadd -r redis && useradd -r -g redis redis
USER redis
RUN [ "redis-server" ]
```

 如果以 root 执行的脚本，在执行期间希望改变身份，比如希望以某个已经建立好的用户来运行某个服务进程，不要使用 su 或者 sudo ，这些都需要比较麻烦的配置，而且在 `TTY` 缺失的环境下经常出错。建议使用 `gosu` 

```dockerfile
# 建立 redis 用户，并使用 gosu 换另一个用户执行命令
RUN groupadd -r redis && useradd -r -g redis redis
# 下载 gosu
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.7/
gosu-amd64" \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true
# 设置 CMD，并以另外的用户执行
CMD [ "exec", "gosu", "redis", "redis-server" ]
```

## 练习

```dockerfile
FROM openjdk:8-jdk-alpine

# Add Maintainer Info
MAINTAINER honux <e6@e6yun.com>

# 设置locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ=Asia/Shanghai

RUN mkdir /app \
    mkdir /opt/settings && echo "env=DEV" > /opt/settings/server.properties

WORKDIR /app

COPY e6-ms-gateway-2.0.0-SNAPSHOT-exec.jar /app/demo.jar
COPY config/* /app/config/

EXPOSE 8080

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-Dserver.port=8080", "-jar","/app/demo.jar"]
```

## kubesphere 中基本操作





