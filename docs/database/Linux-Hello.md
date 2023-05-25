
## 实验楼复盘

>作者：知否派 </br>
>博客地址: [https://snailthink.github.io/myblogs](https://snailthink.github.io/myblogs)</br>
>文章所涉及的资料来自互联网整理和个人总结，意在于个人学习和经验汇总，如有什么地方侵权，请联系本人删除，谢谢！

[实验楼Linux基础](https://www.lanqiao.cn/courses/1/learning/)

**Linux 常用命令**

![20201124175734](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530174701.png)

### 1.常用命令

#### 1.1 查找文件

```shell
find / -name filename.txt  #根据名称查找/目录下的filename.txt文件。

find . -name "*.xml" #递归查找所有的xml文件

find . -name "*.xml" |xargs grep "hello world" #递归查找所有文件内容中包含hello world的xml文件

grep -H 'spring' *.xml  #查找所以有的包含spring的xml文件

find ./ -size 0 | xargs rm -f & #删除文件大小为零的文件

ls -l | grep '.jar' #查找当前目录中的所有jar文件

grep 'test' d* #显示所有以d开头的文件中包含test的行。

grep 'test' aa bb cc #显示在aa，bb，cc文件中匹配test的行。

grep '[a-z]\{5\}' aa #显示所有包含每个字符串至少有5个连续小写字符的字符串的行。

ls -al  #查看文件，包含隐藏文件
```

#### 1.2 复制文件

```shell
cp source dest #复制文件

cp -r sourceFolder targetFolder #递归复制整个文件夹

scp sourecFile romoteUserName@remoteIp:remoteAddr #远程拷贝

#文件复制到当前目录并重命名 ./ 表示单前目录
cp temp.text ./temp4.text

#将文件复制到 2022log文件夹中
cp temp.text /software/2022log/

```

#### 1.3 删除文件

```sh
mkdir test #创建目录

#删除文件
rm test #删除文件

rm-f test #删除文件没有提示信息

rm-r test #删除目录要加-r

rm-rf test #遇到权限不足删除不了的文件则加上-f

rm file1 file2 file3 #删除多个文件

sudo rm a.txt #使用管理员身份删除文件

rmdir test #删除空目录
```

#### 1.4 移动文件重命名

```sh
#1.移动文件
mv /temp/movefile /targetFolder
#2.重命名
mv oldNameFile newNameFile

#文件重命名
rename 'test' 'aaa' test.txt

#将文件移动到 2022log文件夹中
mv temp2.text /software/2022log/
```

#### 1.5 创建文件

```shell
#创建test目录
mkdir test 

#//创建2个文件 后缀为txt
touch asd.txt fgh.txt 

#//创建多个文件比如 test_1_linux.txt 
#//test_2_linux.txt 
touch test_{1..10}_linux.txt
touch file{1..5}.txt
#//.txt文件重命名.c 为后缀的文件
rename 's/\.txt/\.c/' *.txt
#//将.c改为.C
rename 'y/a-z/A-Z/' *.txt

#//文件中填写内容
echo "AAA" > 文件名
```

#### 1.6 文件权限

```sh
# 修改文件权限
chmod 777 file.java  # file.java 的权限-rwxrwxrwx，r表示读、w表示写、x表示可执行
```

#### 1.7 文件压缩/下载

```sh
#压缩文件
tar -czf test.tar.gz /test1 /test2
#列出压缩文件列表
tar -tzf test.tar.gz
#解压文件
tar -xvzf test.tar.gz

# 文件下载
wget http://file.tgz
curl http://file.tgz


#1.打包文件
zip -r -q -o test.zip /home/shiyanlou/Desktop

#2.查看文件类型以及大小
du -h test.zip

#3.查看压缩包信息
file test.zip

# tar 打包工具
#1.1 创建一个tar包
tar -P -cf test.tar /home/shiyanlou/Desktop

#1.2.解包一个文件
mkdir tardir
#将文件解压到tardir
tar -xf shiyanlou.tar -C tardir
#只查看不解压文件
tar -tf shiyanlou.tar
```



#### 1.8 查看日志

```sh
# 1.查询最近多少条日志：
tail -n 100 default.log

# 2.根据关键字查询日志：：
cat -n default.log |grep '关键字'

# 3.根据关键字查出100行的日志：：
tail -n 100 file.log | grep "关键字" # 文件头10行
head -n 10 file.log | grep "关键字" # 文件尾10行

#4.实时查看日志
tail -f /logs/app_logs/default.log

#5.这个命令可以查找日志文件特定的一段 , 根据时间的一个范围查询，可以按照行号和时间范围查询
按照行号
sed -n '5,10p' default.log 这样你就可以只查看文件的第5行到第10行。
按照时间段
sed -n '/2022-06-17 16:17:20/,/2022-06-17 16:18:00/p' default.log
```

#### 1.9 查看文件

```sh
cat -文件名 //查看文件

cat -n 文件名 //添加行号

tail /etc/passwd 

tail -n /etc/passwd 

vimtutor//编辑文件

tail notes.log         # 默认显示最后 10 行
tail -f notes.log  # 要跟踪名为 notes.log 的文件的增长情况


#输出字符串
echo "hello vincent"

#创建文件并输入文本
echo 'hello world' >hello.txt

#hello.txt中再追加内容
echo '0000'>hello.txt
```

#### 1.10 **创建/查看用户**

```shell
# 查看用户
who am i
who mom like
[root@iZbp11bb3m59delo5elu0zZ ~]# who am i
root     pts/0        2020-11-16 19:36 (117.22.144.128)
[root@iZbp11bb3m59delo5elu0zZ ~]# 


//创建用户
sudo adduser admin

//切换用户
su -l admin[用户名]

//修改用户密码
sudo passwd admin[用户名]

//删除用户
sudo  deluser admin -remove-home

//删除组
sudo groupdel test[组]

//将用户设置为管理员
sudo usermod -G sudo lilei

//退出用户
exit 
```

#### 1.11 进程

```sh
# 1.查看进程
ps aux|grep java #查看java进程
ps aux #查看所有进程

# 2.端口
netstat -tln | grep 8080 #查看端口8080的使用情况
lsof -i :8080 #查看端口属于哪个程序

#3.查看一个程序是否运行
ps -ef|grep tomcat #查看所有有关tomcat的进程

#4.终止线程
kill -9 19979 #终止线程号位19979的进程
```

#### 1.13 其他

```sh
#1.以树状图列出目录的内容
tree a

# 2.查看文件当前路径
pwd

# 3.网络检测
ping www.baidu.com

#4.连接服务器远程登录
ssh root@121.41.31.240

#2.查看/etc/group 文件
cat/etc/group | sort
```

### 2.目录结构

#### 2.1 目录路径

![20201119171414](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530174652.png)

#### 2.2 磁盘操作

```shell
# 默认同样以块的大小展示
du
# 加上 `-h` 参数，以更易读的方式展示
du -h
# 只查看 1 级目录的信息
du -h -d 0 ~
# 查看 2 级
du -h -d 1 ~

du -h # 同 --human-readable 以 K，M，G 为单位，提高信息的可读性。
du -a # 同 --all 显示目录中所有文件的大小。
du -s # 同 --summarize 仅显示总计，只列出最后加总的值。
du -h ljl.txt  --查看文件的大小

```

#### 2.3 帮助命令

```shell
# 得到这样的结果说明是内建命令，正如上文所说内建命令都是在 bash 源码中的 builtins 的.def中
xxx is a shell builtin
# 得到这样的结果说明是外部命令，正如上文所说，外部命令在/usr/bin or /usr/sbin等等中
xxx is /usr/bin/xxx
# 若是得到alias的结果，说明该指令为命令别名所设定的名称；
xxx is an alias for xx --xxx
```

#### 2.4 任务计划crontab

```shell
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
```

 #### 2.5 备份日志

```shell
   sudo cron -f &
   crontab -e # 添加
   0 3 * * * sudo rm /home/shiyanlou/tmp/* #凌晨3点执行备份
   0 3 * * * sudo cp /var/log/alternatives.log /home/shiyanlou/tmp/$(date +\%Y-\%m-\%d)
```

#### 2.6 命令执行顺序和管道

```shell
#grep 在文本中或者stdin中查找匹配的字符串
grep [命令选项] ... 用户匹配的表达式 [文件]...

#查找包含shiyanlou的文本文件
grep -rnI "shiyanlou" ~

# 查找环境变量中以yanlou结尾的字符串
export | gerp ".*yanlou$"


# 行数
wc -l /etc/passwd
# 单词数
wc -w /etc/passwd
# 字节数
wc -c /etc/passwd
# 字符数
wc -m /etc/passwd
# 最长行字节数
wc -L /etc/passwd

#查看目录数
ls -dl /etc/*/ | wc -l
```

#### 2.7 排序

```shell
# 默认为字典排序
cat /etc/passwd | sort

# 反转排序
cat /etc/passwd | sort -r

#特定字段排序
cat /etc/passwd | sort -t':' -k 3
```

#### 2.8 去重

```shell
uniq 用于过滤或者输出重复行

history查看最近执行命令 实际为读取吃的是${SHELL}_history 文件
history | cut -c 8- | cut -d ' ' -f 1 | uniq

# 输出重复过的行（重复的只输出一个）及重复次数
history | cut -c 8- | cut -d ' ' -f 1 | sort | uniq -dc
# 输出所有重复的行
history | cut -c 8- | cut -d ' ' -f 1 | sort | uniq -D
```

### 3.文本处理

#### 3.1 tr

```shell
tr 命令用来删除一段文本信息中的某些文字，或者将其转换
tr [option] ... SET1 

# 删除 "hello shiyanlou" 中所有的'o'，'l'，'h'
$ echo 'hello shiyanlou' | tr -d 'olh'
# 将"hello" 中的ll，去重为一个l
$ echo 'hello' | tr -s 'l'
# 将输入文本，全部转换为大写或小写输出
$ echo 'input some text here' | tr '[:lower:]' '[:upper:]'
# 上面的'[:lower:]' '[:upper:]'你也可以简单的写作'[a-z]' '[A-Z]'，当然反过来将大写变小写也是可以的

```

#### 3.2 cat命令

```shell
# 查看 /etc/protocols 中的不可见字符，可以看到很多 ^I ，这其实就是 Tab 转义成可见字符的符号
cat -A /etc/protocols
# 使用 col -x 将 /etc/protocols 中的 Tab 转换为空格，然后再使用 cat 查看，你发现 ^I 不见了
cat /etc/protocols | col -x | cat -A
```

#### 3.3 join 命令

```shell
cd /home/shiyanlou
# 创建两个文件
echo '1 hello' > file1
echo '1 shiyanlou' > file2
join file1 file2
# 将 /etc/passwd 与 /etc/shadow 两个文件合并，指定以':'作为分隔符
sudo join -t':' /etc/passwd /etc/shadow
# 将 /etc/passwd 与 /etc/group 两个文件合并，指定以':'作为分隔符，分别比对第4和第3个字段
sudo join -t':' -1 4 /etc/passwd -2 3 /etc/group
```

#### 3.4 paste 命令

```shell
paste 与join命令类型 将多个文件合并在一起 以为tab隔开
echo hello > file1
echo shiyanlou > file2
echo www.shiyanlou.com > file3
paste -d ':' file1 file2 file3
paste -s file1 file2 file3
```

#### 3.5  数据流重定向

```shell
echo 'hello shiyanlou' > redirect
echo 'www.shiyanlou.com' >> redirect
cat redirect
```

### 4.软件安装

| 工具           | 说明                                                         |
| -------------- | ------------------------------------------------------------ |
| `install`      | 其后加上软件包名，用于安装一个软件包                         |
| `update`       | 从软件源镜像服务器上下载/更新用于更新本地软件源的软件包列表  |
| `upgrade`      | 升级本地可更新的全部软件包，但存在依赖问题时将不会升级，通常会在更新之前执行一次 `update` |
| `dist-upgrade` | 解决依赖关系并升级（存在一定危险性）                         |
| `remove`       | 移除已安装的软件包，包括与被移除软件包有依赖关系的软件包，但不包含软件包的配置文件 |
| `autoremove`   | 移除之前被其他软件包依赖，但现在不再被使用的软件包           |
| `purge`        | 与 remove 相同，但会完全移除软件包，包含其配置文件           |
| `clean`        | 移除下载到本地的已经安装的软件包，默认保存在 `/var/cache/apt/archives/` |
| `autoclean`    | 移除已安装的软件的旧版本软件包                               |

下面是一些`apt-get`常用的参数：

| 参数                 | 说明                                                         |
| -------------------- | ------------------------------------------------------------ |
| `-y`                 | 自动回应是否安装软件包的选项，在一些自动化安装脚本中使用这个参数将十分有用 |
| `-s`                 | 模拟安装                                                     |
| `-q`                 | 静默安装方式，指定多个 `q` 或者 `-q=#`，`#` 表示数字，用于设定静默级别，这在你不想要在安装软件包时屏幕输出过多时很有用 |
| `-f`                 | 修复损坏的依赖关系                                           |
| `-d`                 | 只下载不安装                                                 |
| `--reinstall`        | 重新安装已经安装但可能存在问题的软件包                       |
| `--install-suggests` | 同时安装 APT 给出的建议安装的软件包                          |

**在线安装**

```shell
#安装软件
sudo apt-get --reinstall install <packagename>

# 更新软件源
sudo apt-get update

# 升级没有依赖问题的软件包
sudo apt-get upgrade

# 升级并解决依赖关系
sudo apt-get dist-upgrade

# 删除包
sudo apt-get remove w3m

#查找包
sudo apt-cache search softname1 softname2 softname3……
```

**磁盘安装**

```sh

# 使用dpkg安装
sudo dpkg -i emacs24_24.5+1-6ubuntu1.1_amd64.deb
```

### 5.上传下载

```sh
#安装rz sz 
yum install -y lrzsz 

rz 上传[选择文件名]

sz 下载选择文件名称
```

### 6.用户管理

#### 6.1 添加用户

```sh
# 新增用户
adduser 用户名

# 设置用户密码
passwd 用户名

Changing password for user 用户名.

# 在这里输入新密码
New UNIX password:

# 再次输入新密码
Retype new UNIX password: 

# 密码重新成功
passwd: all authentication tokens updated successfully.
```

#### 6.2 添加管理员

**方法一:**

```sh
#修改 /etc/sudoers 用户权限配置文件
vi /etc/sudoers
# 放开 wheel组内成员的所有命令行执行权限
## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL
```

**方法二:直接将指定用户设为管理员(这中方式成功！已测试)**

```sh
# 修改/etc/sudoers
vi /etc/sudoers
# 新增：
## Allow root to run any commands anywhere
root    ALL=(ALL)       ALL
enzo    ALL=(ALL)       ALL
# 退出时，需要强制保存，因为该文件是只读的 
编辑完后 按esc 后按住 shift+: 输入 wq表示保存并退出 。
```

#### 6.3 将用户加入至管理员组

```sh
# 使用usermod 修改用户归属组
usermod -g root 用户名 (wheel即root组)
# 查看指定用户组信息
groups 用户名
```

### 7.快捷键

|               |                                          |
| ------------- | :--------------------------------------: |
| tab           |                 命令补全                 |
| Ctrl+C        |               终止当前程序               |
| ctrl+d        |          键盘输入结束或退出终端          |
| ctrl+s        | 暂停的当前程序，暂停后按下任意键恢复运行 |
| ctrl+a        |     将光标移至输入行头，相当于home键     |
| ctrl+e        |     将光标移至输入行末，相当于end键      |
| ctrl+k        |          删除光标所在位置到行末          |
| alt+backspace |             向前删除一个单词             |
| shift+pgUP    |              将终端向上滚动              |
| shift+pgON    |            将终端显示向下滚动            |
| ↑             |            查询历史输入的命令            |
| ctrl+D        |                 退出终端                 |
| u             |             u撤销上一步操作              |
| ctrl+r        |          恢复上一步被撤销的操作          |
| `\`+Enter     |                   换行                   |



//常用快捷键使用技巧

````
1、tab //命令或路径等的补全键，linux用的最多的一个快捷键 ⭐️

2、ctrl+a //光标迅速回到行首 ⭐️

3、ctrl+e //光标迅速回到行尾 ⭐️

4、ctrl+f //光标向右移动一个字符

5、ctrl+b //光标向左移动一个字符

6、ctrl+insert //复制命令行内容（mac系统不能使用）

7、shift+insert //粘贴命令行内容（mac系统不能使用）

8、ctrl+k //剪切（删除）光标处到行尾的所有字符 ⭐️

9、ctrl+u //剪切（删除）光标处到行首的所有字符 ⭐️

10、ctrl+w //剪切（删除）光标前的一个字符

11、ctrl+y //粘贴 ctrl+k、ctrl+u、ctrl+w删除的字符 ⭐️

12、ctrl+c //中断终端正在执行的任务并开启一个新的一行 ⭐️

13、ctrl+h //删除光标前的一个字符（相当于退格键）

14、ctrl+d //退出当前shell命令行，如果是切换过来的用户，则执行这个命令回退到原用户 ⭐️

15、ctrl+r //搜索命令行使用过的历史命令记录 ⭐️

16、ctrl+g //从ctrl+r的搜索历史命令模式中退出

17、ctrl+l //清楚屏幕所有的内容，并开启一个新的一行 ⭐️

18、ctrl+s //锁定终端，使之任何人无法输入

19、ctrl+q //解锁ctrl+s的锁定状态

20、ctrl+z //暂停在终端运行的任务,使用"fg"命令可以使暂停恢复 ⭐️

21、!! //执行上一条命令 ⭐️

22、!pw //这是一个例子，是执行以pw开头的命令，这里的pw可以换成任何已经执行过的字符 ⭐️

23、!pw:p //这是一个例子，是仅打印以pw开头的命令，但不执行，最后的那个“p”是命令固定字符 ⭐️

24、!num //执行历史命令列表的第num条命令，num代指任何数字（前提是历史命令里必须存在）⭐️

25、!$ //代指上一条命令的最后一个参数，该命令常用于shell脚本中 ⭐️

26、esc+. //注意那个".“ 意思是获取上一条命令的(以空格为分隔符)最后的部分 ⭐️

27、esc+b //移动到当前单词的开头

28、esc+f //移动到当前单词的结尾

````






#### 常用的通配符

| 字符                | 含义                                      |
| ------------------- | ----------------------------------------- |
| *                   | 匹配0或多个字符                           |
| ?                   | 匹配任意一个字符                          |
| [list]              | 匹配list中的任意单一字符                  |
| [^list]             | 匹配除list中的任意单一字符以外的字符      |
| [c1-c2]             | 匹配c1-c2中的任意单一字符如：`[0-9][a-z]` |
| {string,stirng2...} | 匹配string1或string2其一字符串            |
| {c1..c2}            | 匹配c1-c2中全部字符如{1..10}              |
|                     |                                           |

#### 彩蛋

```shell
sudo apt-get update

sodo apt-get install sysvbanner

banner linux //输出linux
```

## 关注

>如果你觉得我的文章对你有帮助话，欢迎点赞👍 关注❤️ 分享👥！
>
>如果本篇博客有任何错误，请批评指教，不胜感激！
>
>点个在看，分享到朋友圈，对我真的很重要！！！

<img src="https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530174025.jpg" alt="知否派" style="zoom:50%;" />



