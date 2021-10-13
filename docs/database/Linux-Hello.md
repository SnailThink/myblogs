

### 实验楼复盘

[实验楼Linux基础](https://www.lanqiao.cn/courses/1/learning/)

**Linux 常用命令** 

![](https://gitee.com/VincentBlog/image/raw/master/image/20201124175734.png)



#### 常用命令

```shell
//输出字符串
echo "hello vincent"

#创建文件并输入文本
echo 'hello world' >hello.txt

#hello.txt中再追加内容
echo '0000'>hello.txt

```



##### 删除文件

```sh
#删除文件
rm test //删除文件

rm-f test //删除文件没有提示信息

rm-r family //删除目录要加-r

rm-rf family //遇到权限不足删除不了的文件则加上-f

rm file1 file2 file3 //删除多个文件
```

##### 连接服务器
ssh root@121.41.31.240

##### 删除文件

##### tail 命令可用于查看文件的内容 

```shell
tail notes.log         # 默认显示最后 10 行
tail -f notes.log  # 要跟踪名为 notes.log 的文件的增长情况
```



##### touch 创建文件

```shell

//创建2个文件 后缀为txt
touch asd.txt fgh.txt 

//创建多个文件比如 test_1_linux.txt 
//test_2_linux.txt 
touch test_{1..10}_linux.txt
touch file{1..5}.txt
//.txt文件重命名.c 为后缀的文件
rename 's/\.txt/\.c/' *.txt
//将.c改为.C
rename 'y/a-z/A-Z/' *.txt

//文件中填写内容
echo "AAA" > 文件名

```



##### ls 查找文件

```shell
//查找后缀为 .txt的文件
ls *.txt 

//创建文件夹
touch [test]

//查看文件权限
ls -alh [文件名]

//声明一个变量test
declare test
test=AAA//赋值
echo $test //输出

//创建shell文件
touch hellow_shell.sh
gedit hellow_shell.sh

whereis who
whereis find

sudo find /etc/ -name 文件名
find / -name '*.txt' -o -name '*.pdf'


~ 退回到主页

```

##### find

```shell
find / -name file——/代表全文搜索
```



##### **who 查看用户**

```shell
who am i

# 或者

who mom like

[root@iZbp11bb3m59delo5elu0zZ ~]# who am i
root     pts/0        2020-11-16 19:36 (117.22.144.128)
[root@iZbp11bb3m59delo5elu0zZ ~]# 
```



##### **创建用户**

```shell
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



##### 查看/etc/group 文件

```shell
cat/etc/group | sort
```



##### 修改文件权限

```shell
//1.创建文件
sudo touch iphone11

//查看文件权限
ls -alh iphone

//切换用户
exit

//进入用户目录
cd /home/lilei
ls iphone

//修改文件权限为shiyanlou
sudo chown shiyanlou iphone 11
```



### 2.目录结构



![](https://gitee.com/VincentBlog/image/raw/master/image/20201119171414.png)



#### 2.1 目录路径

```shell
//进入上一级目录
cd ..

//进入home 目录
cd ~

#绝对路径
cd /user/local/bin

#相对路径
cd ../../user/local/bin

#创建目录
mkdir mydir

#复制文件
//将test 文件复制到grandson文件中
cp test father/son/grandson

#复制目录
//将father目录复制到family
cp -r father family

#删除文件
rm test //删除文件

rm-f test //删除文件没有提示信息

rm-r family //删除目录要加-r

rm-rf family //遇到权限不足删除不了的文件则加上-f

rm file1 file2 file3 //删除多个文件

# 移动文件
mkdir test//创建test目录
touch filetest //创建一个文件
mv filetest test // 将filetest文件移动到test文件中

#重命名
mv filetest filetestNew
```



#### 2.2 查看文件

```shell
cat -文件名 //查看文件

cat -n 文件名 //添加行号

tail /etc/passwd 

tail -n /etc/passwd 

vimtutor//编辑文件
```



#### 2.3 文件打包和压缩

```shell
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



#### 2.4 磁盘操作

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
```



#### 2.5 帮助命令

```shell
# 得到这样的结果说明是内建命令，正如上文所说内建命令都是在 bash 源码中的 builtins 的.def中
xxx is a shell builtin
# 得到这样的结果说明是外部命令，正如上文所说，外部命令在/usr/bin or /usr/sbin等等中
xxx is /usr/bin/xxx
# 若是得到alias的结果，说明该指令为命令别名所设定的名称；
xxx is an alias for xx --xxx
```



#### 2.6 任务计划crontab

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



 #### 2.7 备份日志

```shell
   sudo cron -f &
   crontab -e # 添加
   0 3 * * * sudo rm /home/shiyanlou/tmp/*
   0 3 * * * sudo cp /var/log/alternatives.log /home/shiyanlou/tmp/$(date +\%Y-\%m-\%d)
```



#### 2.8 命令执行顺序和管道

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



#### 2.9 排序

```shell
# 默认为字典排序
cat /etc/passwd | sort

# 反转排序
cat /etc/passwd | sort -r

#特定字段排序
cat /etc/passwd | sort -t':' -k 3
```

#### 2.10 去重

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



#### 3.2 col 命令



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



### 6.快捷键

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

![公众号](https://gitee.com/VincentBlog/image/raw/master/image/20211013200549.jpg)

![](https://pic.downk.cc/item/5f33d1f214195aa594018b66.gif)

