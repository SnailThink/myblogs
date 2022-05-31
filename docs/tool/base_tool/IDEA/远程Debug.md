转载地址：https://juejin.cn/post/6987174016607846437

### 1.远程Debug

在服务器上将启动参数修改为：

```
java -Djavax.net.debug=
ssl -Xdebug -Xnoagent -Djava.compiler=
NONE -Xrunjdwp:transport=
dt_socket,server=y,suspend=
n,address=8888 -jar springboot-1.0.jar

```

这个时候服务端远程Debug模式开启，端口号为8888。

在IDEA中，点击Edit Configuration按钮。

![image-20220531095210798](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531095210.png)

出现弹窗，点击+按钮，找到Remote选项。

![image-20220531095249516](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531095249.png)

在【1】中填入Remote项目名称，在【2】中填IP地址和端口号，在【3】选择远程调试的项目module，配置完成后点击OK即可

如果碰到连接超时的情况，很有可能服务器的防火墙的问题，举例CentOs7,关闭防火墙

```
systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动

```

点击debug按钮，IDEA控制台打印信息：

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531095302.png)

说明远程调试成功。

### 2.JVM工具远程连接

#### 2.1 jconsole与Jvisualvm远程连接

通常我们的web服务都输部署在服务器上的，在window使用jconsole是很方便的，相对于Linux就有一些麻烦了，需要进行一些设置。

**1.查看hostname,首先使用**

```
hostname -i
复制代码
```

查看，服务器的hostname为127.0.0.1，这个是不对的，需要进行修改

**2.修改hostname**

修改/etc/hosts文件，将其第一行的“127.0.0.1 localhost.localdomain localhost”，修改为：“192.168.44.128 localhost.localdomain localhost”.“192.168.44.128”为实际的服务器的IP地

**3.重启Linux，在服务器上输入hostname -i，查看实际设置的IP地址是否为你设置的**

**4.启动服务，参数为：**

```
java -jar -Djava.rmi.server.hostname=192.168.44.128 -
Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=911 -
Dcom.sun.management.jmxremote.ssl=false -
Dcom.sun.management.jmxremote.authenticate=false jantent-1.0-SNAPSHOT.jar
```

ip为192.168.44.128，端口为911 。

**5.打开Jconsole，进行远程连接,输入IP和端口即可**



![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531095314.png)

点击连接，经过稍稍等待之后，即可完成连接，如下图所示：

![image-20220531095327929](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531095328.png)

同理，JvisualVm的远程连接是同样的，启动参数也是一样。

然后在本机JvisualVm输入IP：PORT，即可进行远程连接：如下图所示：

![image-20220531095327929](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531095404.png)

相比较Jvisualvm功能更加强大一下，界面也更美观。

