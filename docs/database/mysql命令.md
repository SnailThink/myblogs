## mysql使用

**https://juejin.cn/post/6953444668973514789  mysqlExplan**

**https://www.cnblogs.com/dingjiaoyang/p/7026718.html mysql 常用脚本**

### 一.mysql 安装

#### Windows安装

#### 配置环境变量

1.配置变量名：MYSQL_HOME

2.变量值：Mysql的安装路径

3.Path环境变量中追加：%MYSQL_HOME%\bin

![](https://gitee.com/VincentBlog/image/raw/master/image/20210427155613.png)



#### Linux下安装




### 二 、常用的MySQL命令大全 



### 1.连接本地的Mysql

```mysql
-- 格式：mysql -h主机地址 -u用户名 －p用户密码  连接本地Mysql
-- 格式：mysql -P 端口号 -h 远程机地址/ip -u 用户名 -p  连接远程Mysql
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

![](https://gitee.com/VincentBlog/image/raw/master/image/20210427155612.png)



### 2. 修改密码 

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

### 3.备份数据

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

### 4.修改结构 

```sql
--重命名表名称[将t1改为t2]
ALTER TABLE 【表名字】 RENAME 【表新名字】
--添加列
alter table 表名 add 列名  varchar(30);
-- 添加有默认值的列
ALTER TABLE 【表名字】 ADD 【列名称】 INT NOT NULL  COMMENT '注释说明'
--修改列类型
ALTER TABLE 【表名字】 CHANGE 【列名称】【新列名称（这里可以用和原来列同名即可）】 BIGINT NOT NULL  COMMENT '注释说明'
--重命名列
ALTER TABLE 【表名字】 CHANGE 【列名称】【新列名称】 BIGINT NOT NULL  COMMENT '注释说明'
--删除列
alter table 表名 drop column 列名;
--修改列认值
alter table 表名 alter 列名 set default '默认值'
--删除列默认值
alter table 表名 alter 列名 drop default;
--表position去掉列test
alter table position drop column test;
--删除主键
alter table 表名 drop primary key;
--表depart_pos增加主键
alter table depart_pos add primary key PK_depart_pos (department_id,position_id);

```

### 5.索引相关

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

### 6.用户和权限管理

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

### 7.SELECT

```sql
-- GROUP BY 子句, 分组子句
    以下[合计函数]需配合 GROUP BY 使用：
    count 返回不同的非NULL值数目  count(*)、count(字段)
    sum 求和
    max 求最大值
    min 求最小值
    avg 求平均值
    group_concat 返回带有来自一个组的连接的非NULL值的字符串结果。组内字符串连接。
-- HAVING 子句，条件子句
    与 where 功能、用法相同，执行时机不同。
    where 在开始时执行检测数据，对原数据进行过滤。
    having 对筛选出的结果再次进行过滤。
    having 字段必须是查询出来的，where 字段必须是数据表存在的。
    where 不可以使用字段的别名，having 可以。因为执行WHERE代码时，可能尚未确定列值。
    where 不可以使用合计函数。一般需用合计函数才会用 having
    SQL标准要求HAVING必须引用GROUP BY子句中的列或用于合计函数中的列。
-- 子查询
    -- from型
    select * from (select * from tb where id>0) as subfrom where id>1;
     -- where型
    select * from tb where money = (select max(money) from tb);
    -- 列子查询
    select column1 from t1 where exists (select * from t2);
    -- 行子查询
    select * from t1 where (id, gender) in (select id, gender from t2);

```

### 8.锁表

```sql
/* 锁表 */
表锁定只用于防止其它客户端进行不正当地读取和写入
MyISAM 支持表锁，InnoDB 支持行锁
-- 锁定
    LOCK TABLES tbl_name [AS alias]
-- 解锁
    UNLOCK TABLES
```

### 9.TRUNCATE

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


 









































### 问题

 **1.mysql导入时出现"ERROR at line : Unknown command ‘\’’."** 

 出现上述错误是因为字符集的问题，解决方法就是在导入命令中加：–default-character-set=utf8 

正常导入：

```sql
 mysql -u root -h localhost -p test<c:\mysql\test.sql 
```

 添加后： 

```sql
mysql -u root -h localhost -p --default-character-set=utf8 test<c:\mysql\test.sql
```



**时间转换**

```mysql
-- 获取当前时间
SELECT DATE_FORMAT(now(), '%Y-%m-%d') AS day
-- 查询一个月前的数据
SELECT * FROM orm_customer WHERE create_time >= DATE_ADD(now(),INTERVAL -1 MONTH)
```

