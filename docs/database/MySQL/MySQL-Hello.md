
## MySQL-Hello 

[mysqlExplan](https://juejin.cn/post/6953444668973514789)

[mysql 常用脚本](https://www.cnblogs.com/dingjiaoyang/p/7026718.html )



### 一、Mysql 安装



#### windows 配置环境变量

1.配置变量名：MYSQL_HOME

2.变量值：Mysql的安装路径

3.Path环境变量中追加：%MYSQL_HOME%\bin

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530180039.png)





#### 1.home目录下新建安装包存放位置

```shell
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

```shell
wget http://repo.mysql.com/mysql57-community-release-el7-8.noarch.rpm
```

#### 4.安装下载好的rpm包

```shell
rpm -ivh mysql57-community-release-el7-8.noarch.rpm
```

> 安装成功后，会在/etc/yum.repos.d/目录下增加了以下两个文件

#### 5.安装mysql，发现提示，y到底

```sql
yum install mysql-server
```

#### 6.查看下mysql的版本，确定是否安装成功
```sql
mysql -V
```

#### 7.运行mysql

```sql
service mysqld start
```

#### 8.取得mysql初始化随机密码

```sql
grep "password" /var/log/mysqld.log
```



### 二、MySQL常用语句

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



#### 2.字段CRUD

```sql
-- 1.创建表
DROP TABLE `dept_test`;
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
ALTER TABLE 表名 ADD 列名  varchar(64);
ALTER TABLE dept_test ADD dept_qty decimal(18,5);

-- 4.删除字段
ALTER TABLE 表名 DROP COLUMN 列名;
ALTER TABLE dept_test DROP COLUMN dept_qty;

-- 5.添加默认值字段
ALTER TABLE 【表名字】 ADD 【列名称】 INT NOT NULL  COMMENT '注释说明'
ALTER TABLE dept_test ADD dept_default varchar(32) NOT NULL DEFAULT 'AAA' COMMENT '注释说明';

-- 6.删除默认值字段
ALTER TABLE 表名 ALTER 列名 DROP DEFAULT;
ALTER TABLE dept_test ALTER DROP DEFAULT 默认值;

-- 7.修改列名称
ALTER TABLE 【表名字】 CHANGE 【列名称】【新列名称】 BIGINT NOT NULL  COMMENT '注释说明'
ALTER TABLE dept_test CHANGE dept_default dept_default2 varchar(32) NOT NULL DEFAULT 'AAA' COMMENT '注释说明'

-- 8.修改列类型
ALTER TABLE 【表名字】 CHANGE 【列名称】【新列名称（这里可以用和原来列同名即可）】 BIGINT NOT NULL  COMMENT '注释说明'

-- 9.修改列认值[只针对新增的数据有效]
ALTER TABLE 表名 ALTER 列名 set default '默认值'
ALTER TABLE dept_test ALTER dept_default2 set default '111' 

-- 10.删除主键
ALTER TABLE 表名 DROP PRIMARY KEY
ALTER TABLE dept_test DROP PRIMARY KEY
```

#### 3.常用SQL

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
        table_name = '表名称' 
        AND table_schema = ( SELECT DATABASE ( ) ) 
    ORDER BY
        ordinal_position
        
      -- 7.展示所有数据库
        SHOW databases

      -- 8. 展示所有的表
        SHOW tales
      -- 9.展示表中orm_user列信息
        DESCRIBE orm_user
        DESC orm_user 
        -- 10. 查询表创建语句
        show create table user_test;
     
        -- 11.TRUNCATE 删除语句
        TRUNCATE [TABLE] tbl_name
        清空数据
        删除重建表
        区别：
        1，truncate 是删除表再创建，delete 是逐条删除
        2，truncate 重置auto_increment的值。而delete不会
        3，truncate 不知道删除了几条，而delete知道。
        4，当被用于带分区的表时，truncate 会保留分区


```

#### 4.锁表

```sql
/* 锁表 */
表锁定只用于防止其它客户端进行不正当地读取和写入
MyISAM 支持表锁，InnoDB 支持行锁
-- 锁定
    LOCK TABLES tbl_name [AS alias]
-- 解锁
    UNLOCK TABLES
```



#### 5.数据表类型

##### 1.查看MySQL当前默认的存储引擎

查看默认的存储引擎。

```sql
show variables like '%storage_engine%';
```

查看表的存储引擎

```sql
show table status like "table_name";
```

##### 2.MyISAM和INNODB区别

|              | MyISAM | INNODB       |
| ------------ | ------ | ------------ |
| 事务支持     | 不支持 | 支持         |
| 数据行锁     | 不支持 | 支持         |
| 外键约束     | 不支持 | 支持         |
| 全文索引     | 支持   | 不支持       |
| 表空间的大小 | 较小   | 较大 约为2倍 |

常规操作使用

- MyISAM 节省空间 速度较快
- INNODB 安全性高 事务的处理 多表多用户操作

> 在物理空间存在的位置

所有的数据都存在data文件目录下 本质还是文件存储

MySQL 引擎在物理文件的区间

- INNODB 在数据库表中只有一个 *.frm 文件 以及上级目录下的 ibdata1文件
- MyISAM 对应的文件
  - *.frm -表结构的定义文件
  - *.MYD 数据文件
  - *.MYI 索引文件

> 设置数据库表的字符集编码

```
CHARSET=utf8
```

不设置的话 会是mysql的默认字符集编码 不支持中文

Mysql的默认编码是Lation ，不支持中文 ，如何修改编码

在my.ini 中配置默认的编码

```sql
character-set-server=utf8
```

#### 6.Joins操作



![image-20220824174210802](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220824174210802.png)

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

#### 1. 创建表

```mysql
CREATE TABLE IF NOT EXISTS `user_tbl`(
   `user_id` INT UNSIGNED AUTO_INCREMENT,
   `user_no` VARCHAR(100) NOT NULL,
   `user_name` VARCHAR(40) NOT NULL,
   `create_date` DATE,
   PRIMARY KEY ( `user_id` )
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

#### 2. 写入数据

```mysql
INSERT INTO `snailthink`.`user_tbl`
( `user_id`, `user_no`, `user_name`, `create_date` )
VALUES
	( 1, 'cs_01', '测试1', '2021-05-22' ),
	( 2, 'cs_02', '测试2', '2021-05-21' ),
	( 3, 'cs_03', '测试3', '2021-05-20' );
```

#### 3. 备份数据

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

#### 4. 还原数据库

```mysql
#还原MySQL数据库的命令。还原当前备份名为backupfile.sql的数据库
mysql -h127.0.0.1 -uroot -p1q2w3e < backupfile.sql

#还原压缩的MySQL数据库
gunzip < backupfile.sql.gz | mysql -h127.0.0.1 -uroot -p1q2w3e
```

### 五、事务

> 事务原则：ACID  原子性 一致性 隔离性 持久性

原子性A:要么同时成功 要么同时失败

一致性C：事务前后的数据要保持一致

隔离性I：事务的隔离性是多个用户并发访问数据库时，数据库为每一个用户开启的事务，不能被其他事务的操作数据所干涉，事务之间要相互隔离

持久性D：事务提交后不可逆，数据被持久化到数据库中。

> 隔离所导致的问题

脏读：指事务读取了另外一个事务未提交的数据

不可重复读：在一个事务内读取表中的某一行数据 多次读取结果不同 

虚读(幻读)：在一个事务内读取到了别的事务插入的数据，导致前后的数据不一致

> **MySQL 默认开启事务自动提交的**

```sql
SET autocommit=0  关闭
SET autocommit=1  开启

-- 手动处理事务
-- 事务开启
START transaction

-- 提交：持久化
COMMIT

-- 回滚：
ROLLBACK

-- 事务结束
SET autocommit=1  -- 开启自动提交
```



### 六、索引

> 索引是帮助MySQL 高效获取数据的数据结构
>
> 索引是数据结构

#### 1.索引的分类

> 在一个表中主键索引只能有一个 而唯一索引可以有多个

- 唯一索引 (PRIMARY KEY)
  - 避免重复的列出现，唯一索引可以出现 ，多个列都可以标识唯一索引

- 主键索引 (UNIQUE KEY )
  - 唯一的标识 主键不可重复，只能有一个列为主键

- 常规索引 (KEY/INDEX)
  - 默认的INDEX 

- 全文索引 (FULLText)
  - 在特定的数据库引擎MyISAM
  - 快速定位数据

```sql
-- 一.添加索引　　
ALTER TABLE 表名 ADD INDEX 索引名称 (字段名);

-- 1.添加主键索引　　
ALTER TABLE `table_name` ADD PRIMARY KEY (`column`) 　

-- 2.添加唯一索引　　
ALTER TABLE `table_name` ADD UNIQUE (`column`) 　

-- 3.添加全文索引　　
ALTER TABLE `table_name` ADD FULLTEXT (`column`) 　

-- 4.添加普通索引　　
ALTER TABLE `table_name` ADD INDEX index_name (`column` ) 　

-- 5.添加多列索引　　
ALTER TABLE `table_name` ADD INDEX index_name (`column1`, `column2`, `column3`)

-- 二、删除索引
DROP INDEX 索引名称 ON `table_name`;

-- 三、查看索引　　
SHOW INDEX FROM `table_name`；或者SHOW KEYS FROM 表名;

-- 分析SQL 执行的状况
EXPLAIN SELECT *FROM `table_name` 
```



```sql
-- 设置函数保存数据
DELIMITER $$
CREATE FUNCTION mock_data ( ) RETURN INT BEGIN
	DECLARE
		num INT DEFAULT 10000;
	WHILE
			i < num DO-- 插入数据
			INSERT INTO user_test ( `name`, `password` ,`number` )
		VALUES
			( CONCAT( '张三', i ), '123456' ,RAND()*(10-1000),number);
		
		SET i = i + 1;
		
	END WHILE;

END;
```

#### 2.索引原则

- 索引不是越多越好
- 不要对经常变动的数据加索引
- 小数据量的表不需要加索引
- 索引一般用来常用查询的字段上

> 索引的数据结构

Hash类型的索引

Btree :innoDB的默认数据结构

[MySQL索引背后的数据结构及算法原理](https://blog.csdn.net/qq_18298439/article/details/80816753)

### 七、权限管理和备份

#### 1.用户管理

```sql
-- 创建用户
CREATE USER whcoding IDENTIFIED BY '123456'

-- 修改当前用户密码
SET PASSWORD =PASSWORD('123456')

-- 修改指定用户密码
SET PASSWORD  FROM whcoding =PASSWORD('123456')

-- 重命名
RENAME USER whcoding TO whcoding2

-- 用户授权 全部的权限 库名称 表名称
GRANT ALL PRIVILEGES snailthink.orm_customer
GRANT ALL PRIVILEGES *.* TO whcoding

-- 删除用户
DROP USER 用户名

-- 查询指定用户权限
SHOW GRANTS FOR whcoding
SHOW GRANTS FOR ROOT@localhost

-- 撤销权限 在哪个库撤销 给谁撤销
REVOKE ALL PRIVILEGES ON *.* TO whcoding

-- root密码重置
1. 停止MySQL服务
2.  [Linux] /usr/local/mysql/bin/safe_mysqld --skip-grant-tables &
    [Windows] mysqld --skip-grant-tables
3. use mysql;
4. UPDATE `user` SET PASSWORD=PASSWORD("密码") WHERE `user` = "root";
-- 刷新权限
5. FLUSH PRIVILEGES;
-- root密码重置二
SET PASSWORD = PASSWORD('你的新密码');   （“需要带数字，大写字母，小写字母，特殊符号”）
ALTER USER 'root'@'localhost' PASSWORD EXPIRE NEVER;  ("密码永不过期")
flush privileges; ("刷新MySQL的系统权限相关表")
```



#### 2.备份

```sh
#导出一张表/多张表数据
mysqldump -h 主机 -u 用户名 -p 密码 数据库 表名称1 表名称2 >物理磁盘位置/文件名
#导出一张表/多张表数据
eg：mysqldump -hlocalhost -uroot -p1q2w3e snailthink orm_user >D:/a.sql

#导出一张表的部分数据
eg: mysqldump -h地址 -u用户名 -p密码 库名 表名 --where="create_time>'2020-04-27'" > fcst0427.sql

#导出整个数据库
eg：mysqldump -hlocalhost -uroot -p1q2w3e snailthink >D:/b.sql

#导入数据Windows
#1.登录
mysql -uroot -p1q2w3e
#2.使用数据库
use snailthink
#3.导入数据
source D:/a.sql

# 导入数据方法二:
mysql -u用户名 -h密码 库名称<备份文件

#导入sql文件
yum -y install lrzsz --安装rz/sz 
rz --上传文件
sz --下载文件
source d:/mysql.sql;--执行sql
```

### 八、数据库三大范式 

#### 1. 数据库设计

**糟糕的数据库设计**

- 数据冗余
- 数据库插入和删除都很麻烦[屏蔽物理外键]
- 程序的性能差

**良好的数据库设计**

- 节省内存空间
- 保证数据库的外键
- 方便开发系统

**数据库设计**

- 分析需求： 分析业务和需要处理的数据库的需求
- 概要设计：设计关系E-R图

#### 2. 第一范式

原子性 :保证每一列不可再分

#### 3. 第二范式(2NF)

前提:满足第一范式

每张表只描述一件事情 ,确保数据库表中的每一列都和主键相关 而不能只与主键的某一部分相关。

#### 4. 第三范式

前提:满足第二范式

确保数据库中的每一列数都与主键直接相关 而不能间接相关。

#### 规范性和性能的问题

- 因为关联查询不能超过三张表，

- 在规范性能的问题的时候，需要考虑下规范性

- 某些表需要增加一些冗余的字段，(从多表查改为单表查询、提升效率)

- 增加一些计算列

### 九、JDBC



#### **JDBC请求的由来**

![image-20220825105915985](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220825105915985.png)



#### JDBC 测试

```java
/**
	 * useUnicode=true 支持中文编码
	 * characterEncoding=UTF-8 字符串类型
	 * serverTimezone=UTC 设置时区
	 * useSSL=false 使用安全链接
	 * jdbc:mysql://127.0.0.1:3306/snailthink?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&useSSL=false
	 * @throws SQLException
	 * @throws ClassNotFoundException
	 */
	@Test
	public void contextLoads2() throws SQLException, ClassNotFoundException {
		//1.加载驱动
		Class.forName("com.mysql.jdbc.Driver");
		String url = "jdbc:mysql://127.0.0.1:3306/snailthink?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&useSSL=false";
		//2.用户信息以及URL
		String userName="root";
		String passWord="1q2w3e";
		//3.连接成功 数据库对象
		Connection connection= DriverManager.getConnection(url,userName,passWord);
		//4.执行SQL对象
		Statement statement=connection.createStatement();
		//5.执行SQL的对象 去执行SQL 可能存在的结果 查看返回的结果
		String sql="SELECT * FROM user_test";

		ResultSet resultset= statement.executeQuery(sql);
		while (resultset.next()){
			System.out.println("id="+resultset.getObject("id"));
		}
		//6.释放链接
		resultset.close();
		statement.close();
		connection.close();
	}
```

#### statement对象

Jdbc中的statement对象用于向数据库发送sql语句，想完成对数据库的增删改查，只需要通过这个对象向数据库发送增删改查语句即可。



##### JdbcUtil

```java
package com.whcoding.test.common;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

/**
 * @program: spring-boot-learning
 * @description:
 * @author: whcoding
 * @create: 2022-08-25 14:50
 **/
public class JdbcUtil {

	private static String driver = null;
	private static String username = null;
	private static String password = null;
	private static String url = null;

	static {
		try {
			InputStream rs = JdbcUtil.class.getClassLoader().getResourceAsStream("db.properties");
			Properties properties = new Properties();
			properties.load(rs);
			driver = properties.getProperty("driver");
			username = properties.getProperty("username");
			password = properties.getProperty("password");
			url = properties.getProperty("url");
			//驱动只用加载一次
			Class.forName(driver);
		} catch (IOException | ClassNotFoundException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 获取连接数据库对象
	 */
	public static Connection getConnection() throws SQLException {
		return DriverManager.getConnection(url, username, password);
	}

	/**
	 * 释放资源
	 */
	public static void release(Connection connection, Statement statement, ResultSet set) {
		if (set != null) {
			try {
				set.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		if (statement != null) {
			try {
				statement.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		if (connection != null) {
			try {
				connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

}

```

##### JdbcUtilTest

```java
package com.whcoding.test.common;


import org.junit.Test;

import java.sql.*;


public class JdbcUtilTest {


	/**
	 * JDBC 删除数据测试
	 */
	@Test
	public void jdbcDeleteTest() {
		Connection connection = null;
		Statement statement = null;
		try {
			connection = JdbcUtil.getConnection();
			statement = connection.createStatement();
			String sql = "DELETE FROM user_test WHERE id=1";
			int i = statement.executeUpdate(sql);
			if (i > 0) {
				System.out.println("删除成功！");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.release(connection, statement, null);
		}

	}


	/**
	 * JDBC 测试插入
	 */
	@Test
	public void jdbcInsertTest() {
		Connection connection = null;
		Statement statement = null;
		try {
			connection = JdbcUtil.getConnection();
			statement = connection.createStatement();
			String sql = "INSERT INTO user_test(name, password, number) VALUES ('张三', '123456', 2); ";
			int i = statement.executeUpdate(sql);
			if (i > 0) {
				System.out.println("添加成功！");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.release(connection, statement, null);
		}
	}

	/**
	 * JDBC 测试更新
	 */
	@Test
	public void jdbcUpdateTest() {
		Connection connection = null;
		Statement statement = null;
		try {
			connection = JdbcUtil.getConnection();
			statement = connection.createStatement();
			String sql = "UPDATE user_test SET `name`= '汉青' WHERE id=1";
			int i = statement.executeUpdate(sql);
			if (i > 0) {
				System.out.println("修改成功！");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.release(connection, statement, null);
		}
	}

	/**
	 * JDBC 测试查询
	 */
	@Test
	public void jdbcSelectTest() {
		Connection connection = null;
		Statement statement = null;
		ResultSet resultSet = null;
		try {
			connection = JdbcUtil.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT * FROM user_test where id=13";
			resultSet = statement.executeQuery(sql);
			if (resultSet.next()) {
				System.out.println(resultSet.getInt("id"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.release(connection, statement, resultSet);
		}
	}

	/**
	 * JDBC 使用事务
	 *
	 * @throws SQLException
	 */
	@Test
	public void jdbcTransactionTest() throws SQLException {
		//connection代表数据库
		Connection connection = null;
		PreparedStatement st = null;
		try {
			connection = JdbcUtil.getConnection();
			//1.手动设置关闭自动提交事务，此时，事务自动开启
			connection.setAutoCommit(false);
			String sql1 = "update user_test set number = number - 100 where `name` = '张三';";
			st = connection.prepareStatement(sql1);
			st.executeUpdate();
			int num = 1 / 0;//强制制造问题
			String sql2 = "update user_test set number = number + 100 where `name` = '张三';";
			st = connection.prepareStatement(sql2);
			st.executeUpdate();
			//2.提交数据
			connection.commit();
			System.out.println("转账成功");
		} catch (SQLException e) {
			//数据出现问题，事务会自动回滚到原来的样子，这里可以不用设回滚
			try {
				connection.rollback();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		} finally {
			JdbcUtil.release(connection, st, null);
		}
	}
}
```

#### PreparedStatmnet 对象

> 可以防止SQL注入

```java
	/**
	 * SQL注入
	 */
	@Test
	public void preparedStatementTest() throws SQLException {

		Connection connection = null;
		PreparedStatement statement = null;

		try {
			//使用?代替占位符
			String sql = "INSERT INTO user_test(name, password, number) VALUES (?,?,?);";
			statement = connection.prepareStatement(sql);

			//手动给参数赋值
			statement.setInt(1, 2);
			statement.setString(2, "123456");
			statement.setInt(3, 2);
			// 注意点: sql.Date 数据库  java.sql.Date()
			// 注意点: util.Date
			int i = statement.executeUpdate();
			if (i > 0) {
				System.out.println("插入数据成功！");
			}
		} catch (SQLException e) {
			//输出错误的堆栈信息
			e.printStackTrace();
			//错误code
			e.getErrorCode();
		}
	}
```





