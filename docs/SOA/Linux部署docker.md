### 一、部署jar包到服务器

#### **1.执行步骤**

1. 上传文件到服务器
2. Linux服务器开启防火墙
3. 开启对外访问端口
4. 执行jar包 `java -jar springdemo.jar &`  &代表在后台运行。当前ssh窗口不被锁定，但是当窗口关闭时，程序中止运行。
   

```
1.查看防火墙状态
firewall-cmd --state
如果返回的是“not running”，那么需要先开启防火墙；
2. 开启防火墙
systemctl start firewalld.service

3. 开启指定端口
firewall-cmd --zone=public --add-port=2099/tcp --permanent
显示success表示成功
–zone=public表示作用域为公共的
–add-port=443/tcp添加tcp协议的端口端口号为443
–permanent永久生效，如果没有此参数，则只能维持当前 服 务生命周期内，重新启动后失效；
4. 重启防火墙
systemctl restart firewalld.service
系统没有任何提示表示成功！
5. 重新加载防火墙
firewall-cmd --reload
显示success表示成功
6.查看已开启的端口
firewall-cmd --list-ports

7.关闭指定端口
firewall-cmd --zone=public --remove-port=2099/tcp --permanent
systemctl restart firewalld.service
firewall-cmd --reload

8.查看端口被哪一个进程占用
netstat -lnpt |grep 2099
centos7默认没有 netstat 命令，需要安装 net-tools 工具：
安装 net-tools
yum install -y net-tools

9.临时关闭防火墙
systemctl stop firewalld.service
# 或者
systemctl stop firewalld

查看系统对外开放的端口
netstat -tunlp
```



> 当在Linux中成功开启了某个端口，但是远程telnet还是无法ping通，是正常的！
>
> **因为端口没有被Linux进程监听，换句话说，就是该端口上没有运行任何程序！！！**

#### 2.测试

1.将jar包上传到linux /software/jar 文件夹下

2.执行启动jar包`java -jar demo-0.0.1-SNAPSHOT.jar &`

![image-20220629143319719](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220629143319719.png)

3.运行hello方法

**看看代码**

```java
package com.deploy.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @program: deploy-demo
 * @description:
 * @author: whcoding
 * @create: 2022-06-23 15:16
 **/
@RestController
@RequestMapping("hello")
public class HelloWorldController {

	@GetMapping("/hello")
	public String hello() {
		System.out.println("HelloWorld");
		return "HelloWorld";
	}

	@GetMapping("/sayHello")
	public String sayHello(String name) {
		System.out.println("HelloWorld");
		return name + "HelloWorld";
	}
}

```

4.执行hello 请求

http://172.16.57.156:2099/hello/hello

![image-20220629143626651](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220629143626651.png)



### 二、Linux安装Docker

#### 1.推荐 使用yum 

Docker 要求 CentOS 系统的内核版本高于 3.10 ，查看本页面的前提条件来验证你的CentOS 版本是否支持 Docker

```sh
命令查看你当前的内核版本
uname -r 

[root@localhost ~]# uname -r 
3.10.0-693.el7.x86_64
[root@localhost ~]# 
```

**删除旧的版本**

```sh
$ sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
```

- **安装`yum-utils`：**

```sh
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

- 为yum源添加docker仓库位置：

```sh
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

**更新 yum 缓存：**

```sh
sudo yum makecache fast
```

**安装 Docker-ce：**

```sh
sudo yum -y install docker-ce
```

**启动 Docker 后台服务**

```sh
sudo systemctl start docker
```

**测试运行 hello-world**

```sh
[root@localhost ~]# docker run hello-world
```



![image-20220629113800492](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220629113800492.png)



由于本地没有hello-world这个镜像，所以会下载一个hello-world的镜像，并在容器内运行

**查看当前版本，若有版本数据，则安装成功**

```
[root@localhost ~]# docker -v
Docker version 1.13.1, build 7f2769b/1.13.1
[root@localhost ~]# 
```



**配置国内镜像加速**

```
【加速器地址：】
    https://y5krm9wr.mirror.aliyuncs.com

【修改配置文件：】
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json <<-'EOF'
    {
      "registry-mirrors": ["https://y5krm9wr.mirror.aliyuncs.com"]
    }
    EOF
    sudo systemctl daemon-reload
    sudo systemctl restart docker
```

**启动 docker，并检查是否成功启动。**

```
# 启动、关闭 docker
       sudo systemctl start docker
       sudo systemctl stop docker
或
       sudo service docker start
       sudo service docker stop
       
# 检查是否启动成功
   查看本地镜像
       sudo docker images
       
   或 运行 hello-world 镜像
       sudo docker run hello-world
```

**设置开机自启动**

docker 属于底层支持软件, 如果每次开机都需要手动输入命令, 用于重新启动 docker，很麻烦，所以一般设置开机自启动。

```
# 查看是否开机自启动
    systemctl list-unit-files | grep enable
    或者
    systemctl list-unit-files | grep docker

# 开机自启动
    sudo systemctl enable docker  
```



#### 2.使用脚本安装 Docker

**1.yum 包更新到最新。**

```
$ sudo yum update
```

**2.执行 Docker 安装脚本**

```
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
```

执行这个脚本会添加 `docker.repo` 源并安装 Docker。

**3.启动 Docker 进程**

```
sudo systemctl start docker
```

**4.验证 docker 是否安装成功并在容器中执行一个测试的镜像**

```
$ sudo docker run hello-world
docker ps
```



### 三、Docker程序



#### 3.1.MySQL安装

- 下载MySQL`5.7`的docker镜像：

```sh
docker pull mysql:5.7
```

- 使用如下命令启动MySQL服务：

  ```sh
  docker run -p 3306:3306 --name mysql \
  -v /mydata/mysql/log:/var/log/mysql \
  -v /mydata/mysql/data:/var/lib/mysql \
  -v /mydata/mysql/conf:/etc/mysql \
  -e MYSQL_ROOT_PASSWORD=root  \
  -d mysql:5.7
  ```

  

- 参数说明
  - -p 3306:3306：将容器的3306端口映射到主机的3306端口
  - -v /mydata/mysql/conf:/etc/mysql：将配置文件夹挂在到主机
  - -v /mydata/mysql/log:/var/log/mysql：将日志文件夹挂载到主机
  - -v /mydata/mysql/data:/var/lib/mysql/：将数据文件夹挂载到主机
  - -e MYSQL_ROOT_PASSWORD=root：初始化root用户的密码

- 进入运行MySQL的docker容器：

```sh
docker exec -it mysql /bin/bash
```

- 使用MySQL命令打开客户端：

```sh
mysql -uroot -proot --default-character-set=utf8
```

- 创建mall数据库：

```sh
create database whcoding character set utf8
```

- 安装上传下载插件，并将`document/sql/snailthink_220704.sql`上传到Linux服务器上：

  ```sh
  yum -y install lrzsz
  ```

- 将`snailthink_220704.sql`文件拷贝到mysql容器的`/`目录下：

```sh
docker cp /mydata/snailthink_220704.sql mysql:/
```

- 将sql文件导入到数据库：

```
use snailthink;
source /snailthink_220704.sql;
```

- 创建一个`reader:123456`帐号并修改权限，使得任何ip都能访问：

```sh
grant all privileges on *.* to 'reader' @'%' identified by '123456';
```

- 查看mysql用户

![image-20220704145551082](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220704145551082.png)

备注：host为 % 表示不限制ip localhost表示本机使用 plugin非mysql_native_password 则需要修改密码

修改加密方式

```
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';  ### 123456 mysql的登录密码
flush privileges;
```



- 测试连接MySQL

![image-20220704145817461](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220704145817461.png)

#### 3.2 Redis安装 todo 

- 下载Redis`7`的docker镜像：

```sh
docker pull redis:7
```

- 使用如下命令启动Redis服务：

```sh
docker run -p 6379:6379 --name redis \
-v /mydata/redis/data:/data \
-d redis:7 redis-server --appendonly yes;
```

- 进入Redis容器使用`redis-cli`命令进行连接：

```
docker exec -it redis redis-cli
```



#### 3.3 Nginx安装

- 下载Nginx`1.22`的docker镜像：

```sh
docker pull nginx:1.22
```

- 先运行一次容器（为了拷贝配置文件）：

```sh
docker run -p 80:80 --name nginx \
-v /mydata/nginx/html:/usr/share/nginx/html \
-v /mydata/nginx/logs:/var/log/nginx  \
-d nginx:1.22
```

- 将容器内的配置文件拷贝到指定目录：

```sh
docker container cp nginx:/etc/nginx /mydata/nginx/
```

- 修改文件名称：

```sh
mv nginx conf
```

- 终止并删除容器：

```sh
docker stop nginx
docker rm nginx
```

- 使用如下命令启动Nginx服务：

```sh
docker run -p 80:80 --name nginx \
-v /mydata/nginx/html:/usr/share/nginx/html \
-v /mydata/nginx/logs:/var/log/nginx  \
-v /mydata/nginx/conf:/etc/nginx \
-d nginx:1.22
```



#### 3.4 RabbitMQ安装 ok

- 下载rabbitmq`3.9-management`的docker镜像：

```
docker pull rabbitmq:3.9-management
```

- 使用如下命令启动RabbitMQ服务：

```
docker run -p 5672:5672 -p 15672:15672 --name rabbitmq \
-d rabbitmq:3.9-management
```

- 开启防火墙：

```
firewall-cmd --zone=public --add-port=15672/tcp --permanent
firewall-cmd --reload
```

- 访问地址查看是否安装成功：http://192.168.3.101:15672

![image-20220704110020445](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220704110020445.png)

- 输入账号密码并登录：guest guest
- 创建帐号并设置其角色为管理员：whcoding whcoding 

![image-20220704135437834](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220704135437834.png)

- 创建一个新的虚拟host为：/whcoding

![image-20220704135837604](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220704135837604.png)

- 配置用户Virtual Host:

![image-20220704135919146](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220704135919146.png)

#### 3.5 Elasticsearch安装

- 下载Elasticsearch`7.17.3`的docker镜像：

```
docker pull elasticsearch:7.17.3
```

- 修改虚拟内存区域大小，否则会因为过小而无法启动:

```
sysctl -w vm.max_map_count=262144
```

- 使用如下命令启动Elasticsearch服务，内存小的服务器可以通过`ES_JAVA_OPTS`来设置占用内存大小：

```
docker run -p 9200:9200 -p 9300:9300 --name elasticsearch \
-e "discovery.type=single-node" \
-e "cluster.name=elasticsearch" \
-e "ES_JAVA_OPTS=-Xms512m -Xmx1024m" \
-v /mydata/elasticsearch/plugins:/usr/share/elasticsearch/plugins \
-v /mydata/elasticsearch/data:/usr/share/elasticsearch/data \
-d elasticsearch:7.17.3

```

- 启动时会发现`/usr/share/elasticsearch/data`目录没有访问权限，只需要修改`/mydata/elasticsearch/data`目录的权限，再重新启动即可；

```
chmod 777 /mydata/elasticsearch/data/
```

- 安装中文分词器IKAnalyzer，注意下载与Elasticsearch对应的版本，下载地址：https://github.com/medcl/elasticsearch-analysis-ik/releases

![image-20220704111416910](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220704111416910.png)

- 下载完成后解压到Elasticsearch的`/mydata/elasticsearch/plugins`目录下；



![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/mall_linux_deploy_new_03.d123512a.png)

- 重新启动服务：

```sh
docker restart elasticsearch
```

- 开启防火墙：

```
firewall-cmd --zone=public --add-port=9200/tcp --permanent
firewall-cmd --reload
```

- 访问会返回版本信息：http://192.168.3.101:9200

```
{
  "name": "708f1d885c16",
  "cluster_name": "elasticsearch",
  "cluster_uuid": "mza51wT-QvaZ5R0NmE183g",
  "version": {
    "number": "7.17.3",
    "build_flavor": "default",
    "build_type": "docker",
    "build_hash": "5ad023604c8d7416c9eb6c0eadb62b14e766caff",
    "build_date": "2022-04-19T08:11:19.070913226Z",
    "build_snapshot": false,
    "lucene_version": "8.11.1",
    "minimum_wire_compatibility_version": "6.8.0",
    "minimum_index_compatibility_version": "6.0.0-beta1"
  },
  "tagline": "You Know, for Search"
}

```





#### 3.6 Logstash安装

- 下载Logstash`7.17.3`的docker镜像：

```sh
docker pull logstash:7.17.3
```

- 修改Logstash的配置文件`logstash.conf`中`output`节点下的Elasticsearch连接地址为`es:9200`，
- 配置文件地址：https://github.com/macrozheng/mall/blob/master/document/elk/logstash.conf

```sh
output {
  elasticsearch {
    hosts => "es:9200"
    index => "mall-%{type}-%{+YYYY.MM.dd}"
  }
}
```

- 创建`/mydata/logstash`目录，并将Logstash的配置文件`logstash.conf`拷贝到该目录；

```sh
mkdir /mydata/logstash
```

- 使用如下命令启动Logstash服务；

```sh
docker run --name logstash -p 4560:4560 -p 4561:4561 -p 4562:4562 -p 4563:4563 \
--link elasticsearch:es \
-v /mydata/logstash/logstash.conf:/usr/share/logstash/pipeline/logstash.conf \
-d logstash:7.17.3
```

- 进入容器内部，安装`json_lines`插件。

```sh
logstash-plugin install logstash-codec-json_lines
```





#### 3.7 Kibana安装

- 下载Kibana`7.17.3`的docker镜像：

```
docker pull kibana:7.17.3
```

- 使用如下命令启动Kibana服务：

```
docker run --name kibana -p 5601:5601 \
--link elasticsearch:es \
-e "elasticsearch.hosts=http://es:9200" \
-d kibana:7.17.3
```

- 开启防火墙：

```
firewall-cmd --zone=public --add-port=5601/tcp --permanent
firewall-cmd --reload
```

- 访问地址进行测试：http://172.16.57.156:5601

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/mall_linux_deploy_new_04.5c098822.png)





#### 3.8 MongoDB安装

- 下载MongoDB`4`的docker镜像：

```
docker pull mongo:4
```

- 使用docker命令启动：

```
docker run -p 27017:27017 --name mongo \
-v /mydata/mongo/db:/data/db \
-d mongo:4
```



#### Docker全部环境安装完成

一键启动docker中的软件

```sh
docker ps -a | grep Exited | awk '{print $1}' | xargs docker start
```



- 所有下载镜像文件：

```sh
REPOSITORY            TAG                 IMAGE ID            CREATED             SIZE
redis                 7                   604d80444252        2 days ago          117MB
nginx                 1.22                f9c88cc1c21a        2 weeks ago         142MB
elasticsearch         7.17.3              3c91aa69ae06        8 weeks ago         613MB
kibana                7.17.3              4897f4b8b6ee        8 weeks ago         797MB
logstash              7.17.3              dd4291c803f4        8 weeks ago         774MB
mongo                 4                   1c0f1e566fec        5 months ago        438MB
rabbitmq              3.9-management      6c3c2a225947        6 months ago        253MB
mysql                 5.7                 7faa3c53e6d6        3 years ago         373MB
nginx                 1.10                0346349a1a64        5 years ago         182MB
java                  8                   d23bdf5b1b1b        5 years ago         643MB

```



- 所有运行在容器里面的应用：

```
docker ps
```



#### 2.安装Redis

**1.查看docker hub上redis版本**

```
docker search redis
```

![image-20220629140434123](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220629140434123.png)

**2.拉取redis镜像**

我这里拉取的最新版本，可以指定版本

```
docker pull redis
```

**3.查看镜像**

```
docker images
```

**4.创建文件挂载目录**

文件路径可以根据自己习惯，个人习惯将容器内重要文件挂载到宿主机

```
创建目录
mkdir -p /home/redis/conf
mkdir -p /whcoding/app_data/redis/conf

创建文件
touch /home/redis/conf/redis.conf

touch /whcoding/app_data/redis/conf/redis.conf
```

**5.创建并启动redis容器**

```sh
docker run \
-d \
--name redis \
-p 6379:6379 \
--restart unless-stopped \
-v /home/redis/data:/data \
-v /home/redis/conf/redis.conf:/etc/redis/redis.conf \
redis-server /etc/redis/redis.conf \
redis:bullseye 
```

**命令解释如下：**

| 命令                                     | 功能                                                         |
| ---------------------------------------- | ------------------------------------------------------------ |
| docker run                               | 创建并启动容器                                               |
| –name                                    | 指定一个容器名称                                             |
| -m                                       | 指定容器内存大小                                             |
| –memory-swap                             | 指定虚拟内存大小                                             |
| -v                                       | 将容器内部文件挂载到宿主机目录                               |
| $PWD                                     | 输出当前所在目录名称,等同于/opt/redis_docker                 |
| –appendonly yes                          | 开启redis数据持久化                                          |
| -d                                       | 后台运行容器，并返回容器ID                                   |
| -p                                       | 指定端口                                                     |
| –restart always                          | 随docker启动                                                 |
| redis redis-server /etc/redis/redis.conf | 启动的镜像并指定redis服务按照这个配置启动（这里如果不按照指定配置启动，就会默认无配置启动） |
| ：                                       | 符号左边为宿主机，右边为容器空间                             |

**查看是否启动成功**

```
docker ps
```

**测试redis**

```
进入redis容器内部
docker exec -it redis /bin/bash
登陆redis（因为现在还没有修改配置，所有无需严重密码）
redis-cli
然后简单get,set数据测试一下
```

**修改redis配置开启远程访问及设置访问密码**

**进入宿主机映射文件夹**

```
cd /opt/redis_docker
```

**编辑映射配置文件**

```
sudo vim redis.conf

使用#注释掉 bind 127.0.0.1 这一行，使redis可以外部访问
requirepass 123456 设置密码
appendonly yes 持久化设置
然后保存退出

重启redis容器
docker restart redis

再次测试
进入redis容器内部
docker exec -it redis /bin/bash
登陆redis
redis-cli
会出现如下前缀
127.0.0.1:6379->
然后验证密码后登陆
auth 123456
然后简单get,set数据测试一下
```



参考:

[docker安装redis](https://blog.csdn.net/qq_39934154/article/details/121845546)

### 四、Docker部署jar包



#### 1.方法一：使用Dockerfile手动打包jar

##### **1.在相同目录下创建Dockerfile**

```
# 拉取jdk8作为基础镜像
FROM java:8
# 作者
MAINTAINER whcoding <whcoding@163.com>
# 添加jar到镜像并命名为user.jar
ADD docker-hello-0.0.1-SNAPSHOT.jar whcodingdocker.jar
# 镜像启动后暴露的端口
EXPOSE 8001
# jar运行命令，参数使用逗号隔开
ENTRYPOINT ["java","-jar","whcodingdocker.jar"]
```



![image-20220629140019902](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220629140019902.png)



##### **2.使用docker命令打包：**

```
docker build -t whcodingdocker.jar .
```

- whcodingdocker 表示镜像名称

![image-20220629141724393](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220629141724393.png)



- docker images 查看镜像

![image-20220629141757069](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220629141757069.png)



##### 3.使用docker run命令创建并运行容器：

```
# 根据repository 启动
docker run -d --name whcodingdocker -p 8001:8001 whcodingdocker
# 根据image_id 启动
docker run -d --name 1f85e1792442 -p 8001:8001 1f85e1792442
```

**命令解释如下：**

| 命令       | 功能                                              |
| ---------- | ------------------------------------------------- |
| docker run | 创建并启动容器                                    |
| –name      | 指定一个容器名称                                  |
| -d         | 后台运行容器，并返回容器ID                        |
| -p         | 指定端口                                          |
| user       | 需要启动的镜像（名称+版本）不指定版本默认最新版本 |
| ：         | 符号左边为宿主机，右边为容器空间                  |





##### 4.启动完成,查看启动日志：

```
方式一：根据image_id 启动
docker logs -f -t 1f85e1792442
方式二：根据repository 启动
docker logs -f -t whcodingdocker
jar日志启动成功，查看容器：
docker ps
```

![image-20220629142521025](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220629142521025.png)



##### 5.测试效果





#### 2.方法二:复用容器；

**1.停止容器**

```
停止容器：
docker stop whcodingdocker
删除容器：
docker rm whcodingdocker
删除镜像：
docker rmi whcodingdocker
```

**2.修改Dockerfile文件**

修改后内容如下(给jar安排了一个目录，方便[挂载](https://so.csdn.net/so/search?q=挂载&spm=1001.2101.3001.7020)到宿主机)：

```
# 拉取jdk8作为基础镜像
FROM java:8
# 作者
MAINTAINER whcoding <whcoding@163.com>
# 添加jar到镜像并命名为user.jar
ADD docker-hello-0.0.1-SNAPSHOT.jar  /app/whcodingdocker.jar
# 镜像启动后暴露的端口
EXPOSE 8001
# jar运行命令，参数使用逗号隔开
ENTRYPOINT ["java","-jar","whcodingdocker.jar"]
```

**3.在/opt/docker_app文件夹下面创建jar挂载目录**

```

cp docker-hello-0.0.1-SNAPSHOT.jar /opt/docker_app/app/whcodingdocker.jar
```

![image-20220629145032106](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220629145032106.png)



![image-20220629145131360](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220629145131360.png)

把你的jar包cp一份到宿主机/opt/docker_app/app目录下并改名为whcodingdocker.jar 这里一定要在app目录下存放你的jar,不然容器启动会失败，找不到jar

**打包镜像-创建并运行容器**
打包镜像：

```
docker build -t whcodingdocker.
```


创建并运行容器：

```
docker run -d --name whcodingdocker-p 8001:8001 -v /opt/docker_app/app:/app whcodingdocker
```

**命令解释如下：**

| 命令       | 功能                                              |
| ---------- | ------------------------------------------------- |
| docker run | 创建并启动容器                                    |
| –name      | 指定一个容器名称                                  |
| -d         | 后台运行容器，并返回容器ID                        |
| -p         | 指定端口                                          |
| user       | 需要启动的镜像（名称+版本）不指定版本默认最新版本 |
| -v         | 挂载目录到宿主机                                  |
| ：         | 符号左边为宿主机，右边为容器空间                  |

这样的方式启动完成之后，更新服务时只需要更换宿主机/opt/java_app_docker/app目录下的jar包，然后重启容器即可实现更新，省略了每次更新删除打包创建等过程。

#### 3.究极进化：jdk镜像直接创建可服用容器

**1.停止容器**

```
停止容器：
docker stop user
删除容器：
docker rm user
删除镜像：
docker rmi user
**查看jdk版本**
docker images
```



**2.创建并运行容器（直接基于jdk镜像创建容器）**

```java
docker run -d --name user -p 8001:8001 -v /opt/java_app_docker/app:/app java:8 /usr/bin/java -jar /app/user.jar
```

**命令解释如下：**

| 命令                             | 功能                                                         |
| -------------------------------- | ------------------------------------------------------------ |
| docker run                       | 创建并启动容器                                               |
| –name                            | 指定一个容器名称                                             |
| -d                               | 后台运行容器，并返回容器ID                                   |
| -p                               | 指定端口                                                     |
| -v                               | 挂载目录到宿主机                                             |
| java:8                           | 需要启动的镜像（名称+版本）不指定版本默认最新版本            |
| /usr/bin/java -jar /app/user.jar | jar启动命令及jar所在位置，因为创建的容器挂在了宿主机/opt/java_app_docker/app目录，所以里面映射了我们上面放进去的user.jar |
| ：                               | 符号左边为宿主机，右边为容器空间                             |

这样的方式省略了创建Dockerfile并把jar打包成镜像的操作，无论多少个服务，只要有jdk镜像，一条命令搞定！比如现在我需要增加gateway服务，那就把gateway.jar放在任意目录下，直接执行：

```
docker run -d --name user -p ${任意外部端口}😒{任意容器端口} -v ${你的gateway.jar存放目录}:/${任意容器内目录名称} java:8 /usr/bin/java -jar /${任意容器内目录名称}/gateway.jar
```




这种方式也是直接替换挂载目录下jar,然后docker restart 容器ID or 名称 就行



### 五、启动jar包



[docker部署jar包的几种方式](https://blog.csdn.net/qq_39934154/article/details/121985650)

