## 安装nginx环境

### 1.Windows安装

[Windows安装Nginx](https://blog.csdn.net/hyfsbxg/article/details/122322125?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-122322125-blog-125912715.pc_relevant_multi_platform_whitelistv4&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-122322125-blog-125912715.pc_relevant_multi_platform_whitelistv4&utm_relevant_index=1)

```shell
安装环境

yum install gcc
yum install pcre-devel
yum install zlib zlib-devel
yum install openssl openssl-devel

在usr/local目录下新建nginx文件夹

cd /usr/local
mkdir nginx

进入nginx文件夹
cd nginx

下载nginx的tar包
wget http://nginx.org/download/nginx-1.9.7.tar.gz

解压tar
tar -zxvf nginx-1.9.7.tar.gz

进入文件
cd nginx-1.9.7

安装nginx
./configure

执行make
make

执行make install
make install

进入nginx
cd ..

进入sbin
cd sbin

启动
sudo ./nginx

查询nginx.conf是否正确
/usr/local/nginx/sbin/nginx -t
```

![image-20220907150405830](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220907150405830.png)

### 2.部署静态文件

```shell
cd nginx
vim conf/nginx.conf

 server {
        listen       80;
        server_name  _;
        #root /usr/local/nginx/nginx-1.9.7/web/;      # 静态页面根目录
        #index index.html;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   /usr/local/nginx/nginx-1.9.7/web/;
            index  index.html;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
```

**安装服务**

```sh
重启：
./sbin/nginx -s reload

查看是否已经安装服务
yum list installed | grep docker

#安装docker
yum -y install docker

启动docker
systemctl start docker

查看docker服务
systemctl status docker
```

### 3.linux安装Nginx

### 参考

[Nginx中文文档](https://blog.redis.com.cn/doc/)

[Nginx介绍以及使用](https://blog.csdn.net/weixin_52028697/article/details/125912715)

[Windows安装Nginx](https://blog.csdn.net/hyfsbxg/article/details/122322125?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-122322125-blog-125912715.pc_relevant_multi_platform_whitelistv4&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-122322125-blog-125912715.pc_relevant_multi_platform_whitelistv4&utm_relevant_index=1)