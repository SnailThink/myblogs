>你知道的越多、不知道的越多

### 1.目录说明：
```
/bin： 存放二进制可执行文件(ls,cat,mkdir等)，常用命令一般都在这里；

/etc： 存放系统管理和配置文件；

/home： 存放所有用户文件的根目录，是用户主目录的基点，比如用户user的主目录就是/home/user，可以用~user表示；

/usr ： 用于存放系统应用程序；

/opt： 额外安装的可选应用程序包所放置的位置。一般情况下，我们可以把tomcat等都安装到这里；

/proc： 虚拟文件系统目录，是系统内存的映射。可直接访问这个目录来获取系统信息；

/root： 超级用户（系统管理员）的主目录；

/sbin: 存放二进制可执行文件，只有root才能访问。这里存放的是系统管理员使用的系统级别的管理命令和程序。如ifconfig等；

/dev： 用于存放设备文件；

/mnt： 系统管理员安装临时文件系统的安装点，系统提供这个目录是让用户临时挂载其他的文件系统；

/boot： 存放用于系统引导时使用的各种文件；

/lib ： 存放着和系统运行相关的库文件 ；

/tmp： 用于存放各种临时文件，是公用的临时文件存储点；

/var： 用于存放运行时需要改变数据的文件，也是某些大文件的溢出区，比方说各种服务的日志文件（系统启动日志等。）等；

/lost+found： 目录一般是空的，系统非正常关机而留下“无家可归”的文件
```
### 2.快捷键
```
-tab //补全

-ctrl+c //终止

-ctrl + l //清屏，类似clear命令

-ctrl + r //查找历史命令（history）

-ctrl+k  //删除此处至末尾所有内容

-ctrl+u  //删除此处至开始所有内容

-ctrl+insert //复制命令行内容(mac系统不能使用)

-shift+insert //粘贴命令行内容(mac系统不能使用)

-ctrl+f //光标向右移动一个字符

-ctrl+b //光标向左移动一个字符

-ctrl+a //光标迅速回到行首

-ctrl+e //光标迅速回到行尾

-ctrl+s //锁定终端，使之任何人无法输入

-ctrl+q //解锁ctrl+s的锁定状态
```
### 3.常用命令

#### 3.1 文件管理
```
find / -name test.txt //根据名称查找/目录下的test.txt文件。

find . -name "*.xml" //查找所有的xml文件

find . -name "*.xml" |xargs grep "Errror异常 "  //查找所有文件内容中包含Errror异常的xml文件

grep -H 'spring' *.xml //查找所以有的包含spring的xml文件

find ./ -size 0 | xargs rm -f & //删除文件大小为0的文件

ls -l | grep  '.jar' //查找当前目录中的所有jar文件   

ls -al   //查看文件，包含隐藏文件

ll  //类似ls -l 比ls更加详细 有时间和总数的

pwd  //当前工作目录

mv oldNameFile newNameFile  //重命名

mkdir newfolder //创建目录

rmdir deleteEmptyFolder 删除空目录 rm -rf deleteFile 递归删除目录中所有内容

chmod 777 file.java   //file.java的权限-rwxrwxrwx，r表示读、w表示写、x表示可执行   修改文件权限

tar -czf test.tar.gz /temp1 /temp2  //压缩文件 

tar -tzf test.tar.gz  //列出压缩文件列表

tar -xvzf test.tar.gz //解压文件

head -n 10 2020-01-20.txt  // 查看文件头10行

tail -n 10 2020-01-20.txt // 查看文件头10行

cat  test.txt //查看文件内容

cp source dest 复制文件

cp -r sourceFolder targetFolder 复制整个文件夹

scp sourecFile romoteUserName@remoteIp:remoteAddr 远程拷贝

mv /temp/movefile /targetFolder   //移动文件

tail -f exmaple.log //这个命令会自动显示新增内容，查看日志类型文件
```

#### 3.2 用户管理
 
```
su -username  //切换用户

sudo rm a.txt 使用管理员身份删除文件

groups test //查看test用户所在的组

useradd 用户名 //创建用户

userdel -r 用户名 :删除用户//（-r表示把用户的主目录一起删除）

usermod -g 组名 用户名 //修改用户的组

usermod -aG 组名 用户名 //将用户添加到组

groups test //查看test用户所在的组

cat /etc/group |grep test //查看test用户详情//用户名:口令:用户标识号:组标识号:注释性描述:主目录:登录Shell

passwd [ludf] 用户名 //用户改自己密码，不需要输入用户名，选项-d:指定空口令,-l:禁用某用户，-u解禁某用户，-f//强迫用户下次登录时修改口令

groupadd 组名 //创建用户组

groupdel 用户组 //删除组

groupmod -n 新组名 旧组名 //修改用户组名字

sudo 命令 //以root的身份执行命令（输入用户自己的密码，而su为输入要切换用户的密码，普通用户需设置/etc/sudoers才可用sudo）

```

#### 3.3 进程端口管理

```
>1查看一个程序是否运行
ps –ef|grep tomcat 查看所有有关tomcat的进程

ps -ef|grep --color java 高亮要查询的关键字

>2查看端口占用情况

netstat -tln | grep 8080   查看端口8080的使用情况

>3查看端口属于哪个程序

lsof -i :8080

>4查看进程

ps aux|grep java 查看java进程

ps aux 查看所有进程

>5终止线程

kill -9 19979 终止线程号位19979的进程
```

#### 3.4 上传下载
```
1.rz ：上传文件
2.连数据库
3.source 文件名.sql
```
#### 其他

```
telnet www.baidu.com 80  //端口是否可访问

ping  [主机名称或IP地址] // 检测主机

grep [文件或目录...]   //用于查找文件里符合条件的字符串。

clear  //清屏

mysqldump -h主机名 -P端口 -u用户名 -p密码 --database 数据库名 表名称> 表名称.sql //备份表名称
```

### 4.Linux学习

linux手册:[https://www.linuxcool.com/](https://www.linuxcool.com/)

Linux命令大全：[http://man.linuxde.net/](http://man.linuxde.net/)

Linux命令大全：[https://ipcmen.com/](https://ipcmen.com/)

Linux学习网址：[explainshell.com/](explainshell.com/)

>参考博客:

>[https://www.cnblogs.com/caozy/p/9261224.html](https://www.cnblogs.com/caozy/p/9261224.html)

>[https://blog.csdn.net/tianzongnihao/article/details/80539264](https://blog.csdn.net/tianzongnihao/article/details/80539264)

>[https://blog.csdn.net/xiaoguaihai/article/details/8705992](https://blog.csdn.net/xiaoguaihai/article/details/8705992)

### 点赞👍 关注❤ 不迷路

>如果你觉得我的文章对你有帮助话，欢迎点赞👍 关注❤️ 分享👥！
>如果本篇博客有任何错误，请批评指教，不胜感激！

![极客大本营](https://user-gold-cdn.xitu.io/2020/1/12/16f9787f4bedeb25?w=600&h=498&f=png&s=48621)
