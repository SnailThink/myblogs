## 备份MySQL数据库

### 1.导出数据脚本

```c
@echo off
 
set now=%date:~0,4%%date:~5,2%%date:~8,2%0%time:~1,1%%time:~3,2%%time:~6,2%
echo %now%
set host=192.168.1.51
set port=3306
set user=root
set pass=root
set dbname=steam
set backupfile=c:/Back_Up/mysql/%dbname%-%now%.sql
CD C:\Program Files\MySQL\MySQL Server 5.7\bin
mysqldump -h%host% -u%user% -p%pass% --default-character-set=utf8 %dbname% -R --force> %backupfile%
```

### 2.导出数据语句

```sql
1.导出整个数据库
mysqldump -u 用户名 -p 数据库名 > 导出的文件名
mysqldump -u dbuser -p dbname > dbname.sql

2.导出一个表
mysqldump -u 用户名 -p 数据库名 表名> 导出的文件名
mysqldump -u dbuser -p dbname users> dbname_users.sql

3.导出一个数据库结构
mysqldump -u dbuser -p -d --add-drop-table dbname >d:/dbname_db.sql
-d 没有数据 --add-drop-table 在每个create语句之前增加一个drop table


4.导入数据库
常用source 命令
进入mysql数据库控制台，如
mysql -u root -p
mysql>use 数据库
然后使用source命令，后面参数为脚本文件(如这里用到的.sql)
mysql>source d:/dbname.sql
```

### 3.导入数据

```sql
1. 导入数据到数据库
mysql -uroot -D数据库名 

1. 导入数据到数据库中得某个表
mysql -uroot -D数据库名  表名

D:\Program Files\MySQL\MySQL Server 5.7\bin>mysqldump -u root -p  erp lightinthebox_tags > ligh
tinthebox.sql
```

### 4.linux导出数据

#### 一、导出数据库用mysqldump命令（注意mysql的安装路径，即此命令的路径）：

1、导出数据和表结构：

```shell
mysqldump -u用户名 -p密码 数据库名 > 数据库名.sql
#/usr/local/mysql/bin/  mysqldump -uroot -p abc > abc.sql
敲回车后会提示输入密码
```

2、只导出表结构

```shell
mysqldump -u用户名 -p密码 -d 数据库名 > 数据库名.sql
#/usr/local/mysql/bin/  mysqldump -uroot -p -d abc > abc.sql
注：/usr/local/mysql/bin/ ---> mysql的data目录
```



#### 二、导入数据库

1、首先建空数据库

```sql
mysql>create database abc;
```

2、导入数据库
**方法一：**

```shell
1.选择数据库
mysql>use abc;
2.设置数据库编码
set names utf8;
3.导入数据（注意sql文件的路径）
mysql>source /home/abc/abc.sql;
```

**方法二：**

```shell
mysql -u用户名 -p密码 数据库名 < 数据库名.sql
#mysql -uabc_f -p abc < abc.sql
```

