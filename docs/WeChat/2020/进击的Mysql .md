![](https://pic.downk.cc/item/5f12a49f14195aa594661127.png)



## 一. Mysql基础

 #### 1、基础语法

```mysql
-- 1.创建数据库
CREATE DATABASE oct_mysql;

-- 2.切换数据库
use oct_mysql;

-- 3.查看mysql中的表
show tables;

-- 4..创建表
DROP TABLE IF EXISTS `groot_user`;
CREATE TABLE `groot_user`  (
  `groot_user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户名称',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建日期',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '公司ID',
  `company_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '公司名称',
  `user_type` int(11) NULL DEFAULT NULL COMMENT '用户类型，1职员，2.组长，3.经理.4.主管',
  PRIMARY KEY (`groot_user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- 5.增加

INSERT INTO `oct`.`groot_user`
( `user_name`, `create_time`, `company_id`, `company_name`, `user_type`)
VALUES ('张三', '2020-07-18 16:22:29', 1, '国贸', 1);

-- 6.删

DROP TABLE groot_user;
-- 7.改
UPDATE groot_user SET user_name="李四" where user_name='张三'
-- 8.查
SELECT * from groot_user

-- 9.创建视图
create view v as (select * from table1) union all (select * from table2);

create view 数据库1.v as (select * from 数据库1.table1) union all (select * from 数据库2.table2);
```

#### 2. 字段操作

 1、增 

```mysql
ALTER TABLE 数据表名 ADD 新增字段 字段类型;

ALTER TABLE runoob_tbl ADD status tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态 0正常 1删除';
```

 2、删除

```mysql
ALTER TABLE 数据表名 DROP 字段名;

ALTER TABLE runoob_tbl  DROP status;
```


 3、修改

```mysql
#例如，把字段 c 的类型从 CHAR(1) 改为 CHAR(10)，可以执行以下命令:
ALTER TABLE testalter_tbl MODIFY c CHAR(10);
ALTER TABLE testalter_tbl CHANGE c c CHAR(10);

#修改字段类型及名称
#在 CHANGE 关键字之后，紧跟着的是你要修改的字段名，然后指定新字段名及类型。尝试如下实例：
#例如，把字段 c 改成 字段 j ,类型从 CHAR(1) 改为 CHAR(10)，可以执行以下命令:
ALTER TABLE testalter_tbl CHANGE c j CHAR(10);

#ALTER TABLE 对 Null 值和默认值的影响
ALTER TABLE testalter_tbl MODIFY j BIGINT NOT NULL DEFAULT 100;

#修改字段默认值
ALTER TABLE testalter_tbl ALTER i SET DEFAULT 1000;

#修改表名
ALTER TABLE testalter_tbl RENAME TO alter_tbl;
```

## 二.索引

**1.什么是索引？为什么要建立索引？**

索引用于快速找出在某个列中有一特定值的行，不使用索引，MySQL必须从第一条记录开始读完整个表，

直到找出相关的行，表越大，查询数据所花费的时间就越多，如果表中查询的列有一个索引，

MySQL能够快速到达一个位置去搜索数据文件，而不必查看所有数据，那么将会节省很大一部分时间。

 ***MySQL****中的索引的存储类型有两种：**BTREE**、**HASH**。 也就是用树或者Hash值来存储该字段 。



**2.MySQL中索引的优点和缺点和使用原则**

优点:

- 通过创建唯一性索引，可以保证数据库表中每一行数据的唯一性。   
- 可以大大加快 数据的检索速度 
-  可以加速表和表之间的连接，特别是在实现数据的参考完整性方面特别有意义。  
-  在使用分组和排序子句进行数据检索时，同样可以显著减少查询中分组和排序的时间。 
-  通过使用索引，可以在查询的过程中，使用优化隐藏器，提高系统的性能。 

缺点:

-  创建索引和维护索引要耗费时间，并且随着数据量的增加所耗费的时间也会增加 
-  当对表中的数据进行增加、删除、修改时，索引也需要动态的维护，降低了数据的维护速度。 
-  索引也需要占空间，我们知道数据表中的数据也会有最大上线设置的 

使用原则:

-  对经常更新的表就避免对其进行过多的索引，对经常用于查询的字段应该创建索引 
-  数据量小的表最好不要使用索引，因为由于数据较少，可能查询全部数据花费的时间比遍历索引的时间还要短 
-  在一同值少的列上(字段上)不要建立索引，比如在学生表的"性别"字段上只有男，女两个不同值。相反的，在一个字段上不同值较多可以建立索引。 

**3.索引的分类**

`注意：索引是在存储引擎中实现的，也就是说不同的存储引擎，会使用不同的索引 `

 MyISAM和InnoDB存储引擎：只支持BTREE索引， 也就是说默认使用BTREE，不能够更换MEMORY/HEAP存储

 引擎：支持HASH和BTREE索引 

>  1、索引我们分为四类来讲 单列索引(普通索引，唯一索引，主键索引)、组合索引、全文索引、空间索引、 
>
>   1.1、单列索引：一个索引只包含单个列，但一个表中可以有多个单列索引。 这里不要搞混淆了。 
>
>  1.1.1、普通索引：MySQL中基本索引类型，没有什么限制，允许在定义索引的列中插入重复值和空值，纯粹为了查询数据更快一点。 
>
>   1.1.2、唯一索引：索引列中的值必须是唯一的，但是允许为空值， 
>
>   1.1.3、主键索引：是一种特殊的唯一索引，不允许有空值 
>
>   1.2、组合索引 
>
>  　在表中的多个字段组合上创建的索引，只有在查询条件中使用了这些字段的左边字段时，索引才会被使用，使用组合索引时遵循最左前缀集合。这个如果还不明白，等后面举例讲解时在细说 
>
> 1.3、全文索引
>
> 　　全文索引，只有在MyISAM引擎上才能使用，只能在CHAR,VARCHAR,TEXT类型字段上使用全文索引，介绍了要求，说说什么是全文索引，就是在一堆文字中，通过其中的某个关键字等，就能找到该字段所属的记录行，比如有"你是个靓仔，靓女 ..." 通过靓仔，可能就可以找到该条记录。这里说的是可能，因为全文索引的使用涉及了很多细节，
>
> 1.4、空间索引
>
> 　　空间索引是对空间数据类型的字段建立的索引，MySQL中的空间数据类型有四种，GEOMETRY、POINT、LINESTRING、POLYGON。在创建空间索引时，使用SPATIAL关键字。要求，引擎为MyISAM，创建空间索引的列，必须将其声明为NOT NULL。



**4.索引的操作**

 1、创建普通索引 

```mysql
#这是最基本的索引，它没有任何限制。它有以下几种创建方式：
#(1)创建索引

CREATE INDEX indexName ON mytable(username(length)); 
#如果是CHAR，VARCHAR类型，length可以小于字段实际长度；如果是BLOB和TEXT类型，必须指定 length。

#(2)创建表的时候直接指定
CREATE TABLE mytable(  
	ID INT NOT NULL,   
	username VARCHAR(16) NOT NULL,  
	INDEX [indexName] (username(length)) 
); 
```

2.创建唯一索引

```mysql
#它与前面的普通索引类似，不同的就是：索引列的值必须唯一，但允许有空值。如果是组合索引，则列值的组合必须唯一。它#有以下几种创建方式：

#(1)创建索引
CREATE UNIQUE INDEX indexName ON mytable(username(length)) ;

#(2)创建表的时候直接指定
CREATE TABLE mytable( 
	ID INT NOT NULL,  
	username VARCHAR(16) NOT NULL,  
	UNIQUE [indexName] (username(length))  
);
```

 3、删除索引 

```mysql
DROP INDEX [indexName] ON mytable; 
```



 4、使用ALTER 命令添加和删除索引 

```mysql
有四种方式来添加数据表的索引：
#(1)该语句添加一个主键，这意味着索引值必须是唯一的，且不能为NULL。
ALTER TABLE tbl_name ADD PRIMARY KEY (column_list);

#(2)这条语句创建索引的值必须是唯一的（除了NULL外，NULL可能会出现多次）。
ALTER TABLE tbl_name ADD UNIQUE index_name (column_list);

#(3)添加普通索引，索引值可出现多次。
ALTER TABLE tbl_name ADD INDEX index_name (column_list);

#(4)该语句指定了索引为 FULLTEXT ，用于全文索引。
ALTER TABLE tbl_name ADD FULLTEXT index_name (column_list);

#添加索引实例
ALTER TABLE testalter_tbl ADD INDEX (c);

#删除索引实例
ALTER TABLE testalter_tbl DROP INDEX c;
```

#### 4.约束调整

**PK - Primary Key **

   主键必须包含唯一的值。  主键列不能包含 NULL 值。 

**FK - Foreign Key**

 一个表中的 FOREIGN KEY 指向另一个表中的 PRIMARY KEY。 

**IX - Non-Unique Index**

 非唯一索引 

**AK - Unique Index (AX should have been AK (Alternate Key))**

唯一索引

**CK - Check Constraint** 

 CHECK 约束用于限制列中的值的范围 

**DF - Default Constraint**

 约束指定某列的默认值 

**UQ - Unique Constraint**

唯一索引





## 三.优化规范

**1.** **避免使用 select \***

 查询指定列就行

**2.** **当你只需要查询出一条数据的时候,要使用 limit 1**

判断数据是否存在limit 1

**3. 建立高性能的索引**

索引不是随便加的也不是索引越多越好，更不是所有索引对查询都有效。索引加载where条件上

**4.** **建数据库表时,给字段设置固定合适的大小**

字段不能设置的太大，设置太大就造成浪费,会使查询速度变慢。

**5.** **表字段要尽量使用not null**

 任何数跟NULL进行运算都是NULL, 判断值是否等于NULL，不能简单用=，而要用IS NULL关键字。 

**6. EXPLAIN 你的 SELECT 查询**

使用EXPLAIN，查看sql的执行计划

**7.** **在Join表的时候，被用来Join的字段，应该是相同的类型的，且字段应该是被建过索引的。**

这样，MySQL内部会启动为你优化Join的SQL语句的机制。

**8. 如果你有一个字段，比如“性别”，“国家”，“民族”, “省份”，“状态”或“部门”，这些字段的取值是有限而且固定的，那么，应该使用 ENUM 而不是 VARCHAR。**

因为在MySQL中，ENUM类型被当作数值型数据来处理，而数值型数据被处理起来的速度要比文本类型快得多。这样，我们又可以提高数据库的性能**。**

**9. 垂直分割**

将常用和有关系的字段放在相同的表中，把一张表的数据分成几张表，这样可以降低表的复杂度和字段的数目，从而达到优化的目的

**10. 优化where查询**

**①避免在where子句中对字段进行表达式操作**

比如：select 列 from 表 where age*2=36; 建议改成 select 列 from 表 where age=36/2;

**②应尽量避免在 where 子句中使用 !=或<> 操作符，否则将引擎放弃使用索引而进行全表扫描**

**③应尽量避免在 where 子句中对字段进行 null 值 判断**

**④应尽量避免在 where 子句中使用 or 来连接条件**

**11.** **不建议使用%前缀模糊查询,这种查询会导致索引失效而进行全表扫描**

例如LIKE “%name”或者LIKE “%name%这两种都是不建议的。但是可以使用LIKE “name%”。

对于LIKE “%name%，可以使用全文索引的形式

**12. 要慎用in和 not in**

例如：select id from t where num in(1,2,3) 建议改成 select id from t where num between 1 and 3

对于连续的数值，能用 between 就不要用 in 了。

**13. 理解in和exists， not in和not exists的区别**

很多时候用 exists 代替 in 是一个好的选择：如查询语句使用了not in那么内外表都进行全表扫描，没用到索引，而not exists子查询依然能用到表上索引，所以无论哪个表大，用not exists都比not in要快。

select num from a where num in(select num from b) 建议改成: select num from a where exists(select 1 from b where num=a.num)

区分in和exists主要是造成了驱动顺序的改变（这是性能变化的关键），如果是exists，那么以外层表为驱动表，先被访问，如果是IN，那么先执行子查询。所以IN适合于外表大而内表小的情况；EXISTS适合于外表小而内表大的情况。

关于not in和not exists，推荐使用not exists，不仅仅是效率问题，not in可能存在逻辑问题。

**14. 理解select Count (\*)和Select Count(1)以及Select Count(column)区别**

一般情况下，Select Count (*)和Select Count(1)两者返回结果是一样的；

假如表没有主键(Primary key), 那么count(1)比count(*)快；

如果有主键的话，那主键作为count的条件时候count(主键)最快；

如果你的表只有一个字段的话那count(*)就是最快的；

count(*) 跟 count(1) 的结果一样，都包括对NULL的统计，而count(column) 是不包括NULL的统计。



## 四. Navicat使用技巧

- 1: Ctrl+q就会弹出一个sql输入窗口 
- 2: Ctrl+r就执行sql了 
- 3: 按f6会弹出一个命令窗口 
- 4: Ctrl+/ 注释 
- 5: Ctrl +Shift+/ 解除注释 
- 6: Ctrl+R 运行选中的SQL语句 
- 7: Ctrl+Shift+R 只运行选中的sql语句 
- 8: Ctrl+L 删除选中行内容 
- 9: Ctrl+D 表的数据显示显示页面切换到表的结构设计页面，但是在查询页面写sql时是复制当前行并粘贴到下一行 
- 10: Ctrl+N 打开一个新的查询窗口 
- 11: Ctrl+W 关闭当前查询窗口 
- 12: 鼠标左键三击选择当前行

友情链接**:mysql安装包以及navicat安装包(pojie) 提取码：co4t**

[链接](https://pan.baidu.com/s/1xglHKU5-GLl_ziKdVnhLvg ) 




## 五.小技巧

- 1.批量删除表

```sql
-- 批量删除表
SELECT CONCAT( 'drop table ', table_name, ';' ) 
FROM information_schema.tables
WHERE table_name LIKE 'view_%';
```

- 2.查询表字段

```sql

SELECT Name FROM SysColumns 
WHERE id=OBJECT_ID('[dwd].[tb_sc_tvss_shipto_organization_assoc]')
order by name;


-- 查询表字段
SELECT COLUMN_NAME
FROM information_schema.COLUMNS 
WHERE table_name = '表名称' 
AND table_schema = '数据库'
ORDER BY COLUMN_NAME;
```

- 3.navicat查询多条语句.

   默认myslq只能查询一条语句，如果想查询多条，可以在各条之间加;号 


```sql
select * from tbl_A;
select * from tbl_B
```

- 4.Mysql中如何查特定字段，后面再加*

```sql
select COLUMN_NAME,a.* from tbl_A a
```

- 5.force index() 强制索引的使用

```sql
--使用MySQL force index 强制索引的目的是对目标表添加最关键的索
select * from tbl_A a 
where date(create_time-interval 6 hour) > '2016-10-01 06:00:00'
```


```sql
--优化后强制走索引
select * from ws_shop a force index(create_time)
where date(create_time-interval 6 hour) > '2016-10-01 06:00:00'
```

- 6. IFNULL(a,b)  c

```sql
select if(a ='' or a  is null,b,a) c from tbl_A 
```

```sql
--ifnull 判断时间有问题这里其实是用字符串比较、需要加上时分秒判断是否相同
select IFNULL(a.test_time,'1900-01-01 00:00:00')='1900-01-01 00:00:00'
```


## 六、Mysql遇到的坑



 **Union All：对两个结果集进行并集(相加)操作，包括重复行，不进行排序；**  

在使用UNION ALL时候查询数据

修改前

```mysql
SELECT COUNT(*) C1 FROM dbo.Task
WHERE TaskID='547813' 
UNION ALL
SELECT COUNT(*) C1 FROM dbo.Task
WHERE TaskID='547813' 
```


| C1   |
| :--- |
| 1    |
| 1    |

**UNALL  对两个结果集进行并集(相加)操作，不包括重复行，同时进行默认规则的排序；**

```mysql
SELECT COUNT(*) C1 FROM dbo.Task
WHERE TaskID='547813' 
UNION 
SELECT COUNT(*) C1 FROM dbo.Task
WHERE TaskID='547813' 
```

返回结果

| C1   |
| ---- |
| 1    |

取Sum数据

```mysql
SELECT SUM(C1) FROM (
SELECT COUNT(*) C1 FROM dbo.Task
WHERE TaskID='547813' 
UNION ALL
SELECT COUNT(*) C1 FROM dbo.Task
WHERE TaskID='547813' 
)a
```

| C1   |
| ---- |
| 2    |


## 关注

>如果你觉得我的文章对你有帮助话，欢迎点赞👍 关注❤️ 分享👥！
>
>如果本篇博客有任何错误，请批评指教，不胜感激！
>
>点个在看，分享到朋友圈，对我真的很重要！！！


![snailThink.png](http://ww1.sinaimg.cn/large/006aMktPgy1gdegzjxv6yj30go0gogmi.jpg)

![](https://pic.downk.cc/item/5f33d1f214195aa594018b66.gif)

