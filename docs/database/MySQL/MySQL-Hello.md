## MySQL-Hello 

[mysqlExplan](https://juejin.cn/post/6953444668973514789)

[mysql 常用脚本](https://www.cnblogs.com/dingjiaoyang/p/7026718.html )



### 一、Mysql 安装



#### windows 配置环境变量

1.配置变量名：MYSQL_HOME

2.变量值：Mysql的安装路径

3.Path环境变量中追加：%MYSQL_HOME%\bin

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530180039.png)



-----





#### 1.home目录下新建安装包存放位置

```
cd home
mkdir lnmp
cd /home/lnmp
```

#### 2.检查是否已经过mysql

```shell
yum list installed | grep mysql
# 如已经安装则删除
yum -y remove mysql-libs.x86_64
# 删除
rm -rf 文件/文件名
```

#### 3.下载mysql5.7 rpm源

```
wget http://repo.mysql.com/mysql57-community-release-el7-8.noarch.rpm
```

#### 4.安装下载好的rpm包

```
rpm -ivh mysql57-community-release-el7-8.noarch.rpm
```

> 安装成功后，会在/etc/yum.repos.d/目录下增加了以下两个文件



#### 5.安装mysql，发现提示，y到底

```
yum install mysql-server
```



#### 6查看下mysql的版本，确定是否安装成功
```
mysql -V
```



#### 7.运行mysql

```
service mysqld start
```



#### 8取得mysql初始化随机密码

```
grep "password" /var/log/mysqld.log
```

#### 9登录mysql

````
mysql -u root -p
粘贴密码
````



#### 10更改root密码

```
SET PASSWORD = PASSWORD('你的新密码');   （“需要带数字，大写字母，小写字母，特殊符号”）
ALTER USER 'root'@'localhost' PASSWORD EXPIRE NEVER;  ("密码永不过期")
flush privileges; ("刷新MySQL的系统权限相关表")
```







### 二、Mysql常用语句

#### 1.登录

```sql
-- 格式：mysql -h主机地址 -u用户名 －p用户密码  连接本地Mysql
-- 格式：mysql -P 端口号 -h 远程机地址/ip -u 用户名 -p  连接远程Mysql
CD  C:\Program Files\MySQL\MySQL Server 5.7\bin
-- 1.1 登录
mysql -h localhost -u root -p1q2w3e  (这里我电脑上的用户名是root，密码1q2w3e)
-- 1.2 切换数据库 
use snailthink (切换数据库,本地数据库为snailthink)
-- 1.3 查询命令
SELECT `customer_name`, `customer_no`, `customer_id`, `customer_address`, `customer_type`, `customer_fund`, 
`order_date`, `order_no`, `order_id`, `create_time`, `update_time` FROM orm_customer;
-- 1.4 退出MYSQL命令： 
exit (回车)
```

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530180115.png)



#### 2.修改密码

```sql
--修改mysql中的root密码：
update user set password=password(″1q2w3e″) where user=’root’;

--刷新数据库
flush snailthink

--打开数据库
use snailthink

--展示所有数据库
show databases

--展示所有的表
show tales

--展示表中orm_user列信息
DESCRIBE orm_user/desc orm_user 
```



#### 3、备份数据

```sql
--备份数据库
mysqldump -h host -u root -p dbname >dbname_backup.sql

--恢复数据库
mysqladmin -h myhost -u root -p create dbname
mysqldump -h host -u root -p dbname < dbname_backup.sql

--将表数据导出
mysqldump -h地址 -u用户名 -p密码 库名 表名 --where="create_time>'2020-04-27'" > fcst0427.sql

--导入sql文件
yum -y install lrzsz --安装rz/sz 
rz --上传文件
sz --下载文件
source d:/mysql.sql;--执行sql

格式则是：mysql -h 主机地址(本机localhost) -u 用户名(root) -p 数据库名 < 要导入的数据文件(比如是c:\mysql\test.sql)

比如：mysql -h localhost -u root -p test< c:\mysql\test.sql
```

#### 4.字段操作

```sql

-- 1.创建表

drop table `dept_test`;
CREATE TABLE `dept_test` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `branch_id` bigint(20) NOT NULL,
  `dept_id` varchar(100) NOT NULL,
  `dept_no` varchar(128) NOT NULL,
  `dept_name` varchar(128) NOT NULL,

  `log_status` int(11) NOT NULL,
  `log_created` datetime NOT NULL,
  `log_modified` datetime NOT NULL,
  `ext` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_undo_log` (`xid`,`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


CREATE TABLE `dept_test`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dept_no` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `dept_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `db_source` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
)
-- 2.写入数据
INSERT INTO `dept_test` VALUES (1, 'A001', 'Test', 'SnailThink');
INSERT INTO `dept_test` VALUES (2, 'A002', 'Test2', 'SnailThink2');
INSERT INTO `dept_test` VALUES (3, 'A003', 'Test3', 'SnailThink3');

-- 3.添加字段
alter table 表名 add 列名  varchar(64);
ALTER TABLE dept_test ADD dept_qty decimal(18,5);

-- 4.删除字段
alter table 表名 drop column 列名;
alter table dept_test drop column dept_qty;

-- 5.添加默认值字段
ALTER TABLE 【表名字】 ADD 【列名称】 INT NOT NULL  COMMENT '注释说明'
ALTER TABLE dept_test ADD dept_default varchar(32) NOT NULL DEFAULT 'AAA' COMMENT '注释说明';

-- 6.删除默认值字段
alter table 表名 alter 列名 drop default;
alter table dept_test alter dept_default drop default;

-- 7.修改列名称
ALTER TABLE 【表名字】 CHANGE 【列名称】【新列名称】 BIGINT NOT NULL  COMMENT '注释说明'
ALTER TABLE dept_test CHANGE dept_default dept_default2 varchar(32) NOT NULL DEFAULT 'AAA' COMMENT '注释说明'

-- 8.修改列类型
ALTER TABLE 【表名字】 CHANGE 【列名称】【新列名称（这里可以用和原来列同名即可）】 BIGINT NOT NULL  COMMENT '注释说明'

-- 9.修改列认值[只针对新增的数据有效]
alter table 表名 alter 列名 set default '默认值'
alter table dept_test alter dept_default2 set default '111' 

-- 10.删除主键
alter table 表名 drop primary key;
alter table dept_test drop primary key;
```



#### 5.索引相关

```sql
-- 一.添加索引　　
ALTER TABLE 表名 ADD INDEX 索引名称 (字段名);

--1.添加主键索引　　
ALTER TABLE `table_name` ADD PRIMARY KEY (`column`) 　

--2.添加唯一索引　　
ALTER TABLE `table_name` ADD UNIQUE (`column`) 　

--3.添加全文索引　　
ALTER TABLE `table_name` ADD FULLTEXT (`column`) 　

--4.添加普通索引　　
ALTER TABLE `table_name` ADD INDEX index_name (`column` ) 　

--5.添加多列索引　　
ALTER TABLE `table_name` ADD INDEX index_name (`column1`, `column2`, `column3`)

-- 二、删除索引
DROP INDEX 索引名称 ON 表名;

-- 三、查看索引　　
SHOW INDEX FROM 表名；或者SHOW KEYS FROM 表名;
```

#### 6.用户和权限管理

```sql
-- root密码重置
1. 停止MySQL服务
2.  [Linux] /usr/local/mysql/bin/safe_mysqld --skip-grant-tables &
    [Windows] mysqld --skip-grant-tables
3. use mysql;
4. UPDATE `user` SET PASSWORD=PASSWORD("密码") WHERE `user` = "root";
5. FLUSH PRIVILEGES;

-- 刷新权限
FLUSH PRIVILEGES;

-- 重命名用户
RENAME USER old_user TO new_user

-- 设置密码
SET PASSWORD = PASSWORD('密码')  -- 为当前用户设置密码
SET PASSWORD FOR 用户名 = PASSWORD('密码') -- 为指定用户设置密码

-- 删除用户
DROP USER 用户名
```

#### 7.SELECT

```sql
-- 1.GROUP BY 子句, 分组子句
    以下[合计函数]需配合 GROUP BY 使用：
    count 返回不同的非NULL值数目  count(*)、count(字段)
    sum 求和
    max 求最大值
    min 求最小值
    avg 求平均值
    group_concat 返回带有来自一个组的连接的非NULL值的字符串结果。组内字符串连接。
-- 2.HAVING 子句，条件子句
    与 where 功能、用法相同，执行时机不同。
    where 在开始时执行检测数据，对原数据进行过滤。
    having 对筛选出的结果再次进行过滤。
    having 字段必须是查询出来的，where 字段必须是数据表存在的。
    where 不可以使用字段的别名，having 可以。因为执行WHERE代码时，可能尚未确定列值。
    where 不可以使用合计函数。一般需用合计函数才会用 having
    SQL标准要求HAVING必须引用GROUP BY子句中的列或用于合计函数中的列。
-- 3.子查询
    -- from型
    select * from (select * from tb where id>0) as subfrom where id>1;
     -- where型
    select * from tb where money = (select max(money) from tb);
    -- 列子查询
    select column1 from t1 where exists (select * from t2);
    -- 行子查询
    select * from t1 where (id, gender) in (select id, gender from t2);
    
-- 4.获取当前时间
SELECT DATE_FORMAT(now(), '%Y-%m-%d') AS day
-- 5.查询一个月前的数据
SELECT * FROM orm_customer WHERE create_time >= DATE_ADD(now(),INTERVAL -1 MONTH)

-- 6.查询表字段
SELECT
    column_name columnName, -- 字段名称
    data_type dataType, -- 字段类型
    column_comment columnComment, -- 字段描述
    column_key columnKey, -- 主键
    extra -- 主键自动增加
FROM
    information_schema.COLUMNS 
WHERE
    table_name = 'dm_tb_sc_ga_delivery_dashboard_update_data_daily_fact' 
    AND table_schema = ( SELECT DATABASE ( ) ) 
ORDER BY
    ordinal_position
    


```

#### 8.锁表

```sql
/* 锁表 */
表锁定只用于防止其它客户端进行不正当地读取和写入
MyISAM 支持表锁，InnoDB 支持行锁
-- 锁定
    LOCK TABLES tbl_name [AS alias]
-- 解锁
    UNLOCK TABLES
```

#### 9.TRUNCATE

```sql
/* TRUNCATE */ ------------------
TRUNCATE [TABLE] tbl_name
清空数据
删除重建表
区别：
1，truncate 是删除表再创建，delete 是逐条删除
2，truncate 重置auto_increment的值。而delete不会
3，truncate 不知道删除了几条，而delete知道。
4，当被用于带分区的表时，truncate 会保留分区
```


#### 10.查看MySQL当前默认的存储引擎

查看默认的存储引擎。
```sql
show variables like '%storage_engine%';
```
查看表的存储引擎
```sql
show table status like "table_name";
```


### 三、 binlog恢复数据

#### 1.恢复binlog数据流程

```mysql
# 登录
mysql -hlocalhost -uroot -p1q2w3e;

# 准备测试数据创建表
CREATE TABLE `user_temp` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `mail` varchar(255) DEFAULT NULL,
  `lock` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

# 写入数据
INSERT INTO `snailthink`.`user_temp`(`name`, `phone`, `mail`, `lock`) VALUES ('zhangsan', '110', '110@qq.com', '0');
INSERT INTO `snailthink`.`user_temp`( `name`, `phone`, `mail`, `lock`) VALUES ('lisi', '111', '111@qq.com', '0');
INSERT INTO `snailthink`.`user_temp`(`name`, `phone`, `mail`, `lock`) VALUES ('wangwu', '112', '112@qq.com', '0');
INSERT INTO `snailthink`.`user_temp`(`name`, `phone`, `mail`, `lock`) VALUES ('xiaoming', '113', '113@qq.com', '0');

# 查看是否开启binlog
show variables like '%log_bin%';

# 删除数据
DELETE from user_temp where id=1;

# 查看binlog写入的文件
show master status;

# 查看biglog
show binlog events in 'mysql-bin.000127';

# 根据时间段筛选biglog 并转为sql
mysqlbinlog --start-datetime="2022-06-16 15:50:00" --stop-datetime="2022-06-16 16:02:00" mysql-bin.000201 -d snailthink> filename_binlog.sql;

# 执行sql语句
source  filename_binlog.sql;
```









#### **2.查看Binlog是否开启**

![image-20210522111429209](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531111411.png)

log_bin:ON 则为开启

若未开启则需要执行 

```sql
SET SQL_LOG_BIN=1 命令开启
SET SQL_LOG_BIN=0 命令关闭
```



#### **3.查看当前写入的日志文件**

![image-20210522112010358](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531111423.png)



#### **4.查看binlog 日志**

```mysql
show binlog events in 'mysql-bin.000127';
```

![image-20210522140951203](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531111426.png)



#### **5.通过binlog恢复数据**

第一种：是通过binlog中的position id恢复,首先通过备份将数据导入数据库，然后将后面缺失的数据库操作通过binlog恢复

使用命令

```
mysqlbinlog --start-position=100 --stop-position=500 --database=test
/var/lib/mysql/mysql-bin.000001 | /usr/bin/mysql -u root -p passwd -v
database_name
```

第二种：根据时间查询biglog，将binlog转为sql语句(它本质上还是一个二进制的文本文件，不能直接执行需要通过source执行)，然后通过source执行sql 文件.**推荐**

```sql
mysqlbinlog --start-datetime="2022-06-16 15:50:00" --stop-datetime="2022-06-16 16:02:00" mysql-bin.000201 -d snailthink> filename_binlog.sql;
```

```sql
 source D:\filename_binlog.sql
```

第三种：直接执行 将sql语句执行并恢复到数据库中

```sql
mysqlbinlog --start-datetime="2022-06-16 15:50:00" --stop-datetime="2022-06-16 16:02:00" mysql-bin.000201 | mysql -u root -p 1q2w3e snailthink;
```


mysqlbinlog.exe 路径：C:\Program Files\MySQL\MySQL Server 5.7\bin
mysql-bin.000003文件路径：C:\ProgramData\MySQL\MySQL Server 5.7\Data

#### **6.记录mysql操作日志**

1.这两个命令在MySQL重启后失效 为临时方法
```sql
-- 查看日志记录是否开启 general_log为ON 则为开启
SHOW VARIABLES LIKE "general_log%";
//日志开启
SET GLOBAL log_output = 'TABLE';SET GLOBAL general_log = 'ON';  
//日志关闭
SET GLOBAL log_output = 'TABLE'; SET GLOBAL general_log = 'OFF';  
-- 查看当前执行的sql语句
select * from information_schema.`PROCESSLIST` where info is not null;
```
2. 永久开启
永久有效需要配置my.cnf文件，加入下面两行：
```sql
general_log = 1
general_log_file = /var/log/mysql/general_sql.log
```




### 四、使用mysqldump 恢复数据

#### 1.1 创建表

```mysql
CREATE TABLE IF NOT EXISTS `user_tbl`(
   `user_id` INT UNSIGNED AUTO_INCREMENT,
   `user_no` VARCHAR(100) NOT NULL,
   `user_name` VARCHAR(40) NOT NULL,
   `create_date` DATE,
   PRIMARY KEY ( `user_id` )
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

#### 1.2 写入数据

```mysql
INSERT INTO `snailthink`.`user_tbl`
( `user_id`, `user_no`, `user_name`, `create_date` )
VALUES
	( 1, 'cs_01', '测试1', '2021-05-22' ),
	( 2, 'cs_02', '测试2', '2021-05-21' ),
	( 3, 'cs_03', '测试3', '2021-05-20' );
```

#### 1.3 备份数据

```mysql
# 备份整张表数据
mysqldump -h localhost -uroot -p1q2w3e > d:/bascksql/backupfile.sql
# 备份压缩数据
mysqldump -hlocalhost -uroot -p1q2w3e | gzip > d:/bascksql/backupfile.sql.gz

# 备份服务器上所有数据库
mysqldump --all-databases -h127.0.0.1 -uroot -p1q2w3e > allbackupfile.sql

# 备份MySQL数据库某个(些)表。此例备份table1表和table2表。备份到linux主机的/home下
mysqldump -h127.0.0.1 -uroot -p1q2w3e table1 table2 > /home/backupfile.sql

```

#### 1.4 还原数据库

```mysql
#还原MySQL数据库的命令。还原当前备份名为backupfile.sql的数据库
mysql -h127.0.0.1 -uroot -p1q2w3e < backupfile.sql

#还原压缩的MySQL数据库
gunzip < backupfile.sql.gz | mysql -h127.0.0.1 -uroot -p1q2w3e
```
