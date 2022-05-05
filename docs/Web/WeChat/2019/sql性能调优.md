>**你知道的越多,你不知道的越多**

# SQL性能优化

[TOC]

## 1.索引使用

### 1.1、 创建索引

 1.添加PRIMARY KEY（主键索引）

```
ALTER TABLE `table_name` ADD PRIMARY KEY ( `column` ) 
```
 2.添加UNIQUE(唯一索引) 

```
ALTER TABLE `table_name` ADD UNIQUE ( `column` ) 
```
 3.添加INDEX(普通索引) 

```
ALTER TABLE `table_name` ADD INDEX index_name ( `column` )
```
 4.添加FULLTEXT(全文索引) 

```
ALTER TABLE `table_name` ADD FULLTEXT ( `column`) 
```
 5.添加多列索引

```
ALTER TABLE `table_name` ADD INDEX index_name ( `column1`, `column2`, `column3` )
```

### 1.2、 最左前缀原则

MySQL中的索引可以以一定顺序引用多列，这种索引叫作联合索引。如customer表的customer_name和city加联合索引就是(customer_name,city)o而最左前缀原则指的是，如果查询的时候查询条件精确匹配索引的左边连续一列或几列，则此列就可以被用到。如下：        

```
select * from customer where customer_name=xx and city=xx ; ／／可以命中索引
select * from customer where customer_name=xx ; // 可以命中索引
select * from customer where city=xx; // 无法命中索引            
```
这里需要注意的是，查询的时候如果两个条件都用上了，但是顺序不同，如 `city= xx and customer_name ＝xx`，那么现在的查询引擎会自动优化为匹配联合索引的顺序，这样是能够命中索引的.

由于最左前缀原则，在创建联合索引时，索引字段的顺序需要考虑字段值去重之后的个数，较多的放前面。ORDERBY子句也遵循此规则。

### 1.3、 注意避免冗余索引

冗余索引指的是索引的功能相同，能够命中 就肯定能命中 ，那么 就是冗余索引如（customer_name,city ）和（customer_name ）这两个索引就是冗余索引，能够命中后者的查询肯定是能够命中前者的 在大多数情况下，都应该尽量扩展已有的索引而不是创建新索引。

MySQLS.7 版本后，可以通过查询 sys 库的 `schemal_r dundant_indexes` 表来查看冗余索引     

##  2.不走索引

每当后端技术人员讲起SQL的调优时，第一个想到的方案往往是索引。

先举个最简单的例子，这里在tb表中给字段tb_name加上普通的索引，

由此根据该字段进行SELECT查询时就无需进行全表遍历，以加快查询速度

```
CREATE INDEX tb_tb_a ON tb (tb_a);
SELECT tb_id FROM tb WHERE tb_a='Sherry';
```
以下几种情况将无法使用索引：

### 2.1、 使用OR时

  - 带有OR操作的语句即使其中部分带了索引字段的也不会使用，以下SELECT操作是使用不了索引的，所以SQL要尽量少用OR操作

```
CREATE INDEX tb_tb_a ON tb (tb_a);
SELECT tb_id FROM tb WHERE tb_a='Sherry' OR tb_b='Billy';（索引失效）
```
- 如果要想使用OR并且让索引生效，只能将OR条件里每个相关列都加上索引！！！(备注in 是走索引的)

### 2.2、 使用多列索引时

```
CREATE INDEX tb_tb_a_tb_b ON tb (tb_a,tb_b);
```

- 这个多列索引本质上是创建了两个索引，分别是tb_a和tb_a_tb_b（可理解为字段最左部的某连续部分），则对以下SELECT语句产生不同的结果

```
SELECT tb_id FROM tb WHERE tb_a='Sherry';（索引生效）
SELECT tb_id FROM tb WHERE tb_b='Sherry';（索引失效）
SELECT tb_id FROM tb WHERE tb_a='Sherry' AND tb_b='Billy';（索引生效）
```
- 多列索引tb_tb_a_tb_b和分开对tb_a、tb_b字段创建两个独立的索引的区别是多列索引能顺序地利用所包含的字段索引，

- 而分开创建的索引则会选择最严格（可以理解为所选出结果集最小的索引）的索引来进行检索，其他相关的索引也不会被使用，

- 故效果不如多列索引。另外建立多列索引时，需要注意索引所用字段的顺序，应将最严格的索引放在最前面使索引产生更好的效果

### 2.3、 使用LIKE接以%开头的字符串时

```
CREATE INDEX tb_tb_a ON tb (tb_a);
SELECT tb_id FROM tb WHERE tb_a LIKE 'She%';（索引生效）
SELECT tb_id FROM tb WHERE tb_a LIKE '%rry';（索引失效）
```
- 上面这种失效的情况下，可以使用另一种方式

```
SELECT tb_id FROM tb WHERE REVERSE(tb_a) LIKE 'yrr%';（索引生效）
```
- 即对所需查询的字段做一次翻转然后再进行LIKE操作，就可以达到利用索引的目的，不过这里又涉及到在SQL中使用函数的问题可能影响效率，

- 因此最好对实际情况进行测试而决定使用方式，但这种方式不适用于LIKE '%xxx%'之类的SQL调优

### 2.4、 列是字符串类型时

```
CREATE INDEX tb_tb_a ON tb (tb_a);
SELECT tb_id FROM tb WHERE tb_a='123456';（索引生效）
SELECT tb_id FROM tb WHERE tb_a=123456;（索引失效）
```
- 字符串字段的查询参数不加引号时虽然在某些情况下能查询成功，但并不能利用到已创建的索引

### 2.5、 使用not in 不能命中索引

```
CREATE INDEX tb_t1_a ON tb (phone);
CREATE INDEX tb_t2_a ON tb (phone);
select * from t1 where phone not in (select phone from t2)（索引失效）
```
- 将not in修改为 select * from t1 where not exists(select phone from t2 where t1.phone =t2.phone) （索引生效）

### 2.6、 order by关键字优化

- 尽量使用index方式排序，避免使用filesort方式。

- order by满足两种情况会使用index排序：①、order by语句使用索引最左前列，②、使用where子句与order by子句条件列组合满足索引最左前列

- 双路排序：MySQL4.1之前，两次扫描磁盘

- 单路排序：从磁盘读取查询需要的所有列，按照order by列在buffer对它们进行排序，然后扫描排序后的列进行输出，
   效率更高一点，但是它会使用更多的空间，因为它把每一行都保存在内存中了，

- 优化策略: 增大sort_buffer_size参数的设置、增大max_length_for_sort_data参数的设置

### 2.7、 <> 和！= 使用

```
CREATE INDEX tb_tb_a ON tb (tb_a);
SELECT tb_id FROM tb WHERE tb_a！= '123456';（索引生效）
SELECT tb_id FROM tb WHERE tb_a <> '123456';（索引生效）
```

### 2.8、 小结

- 全值匹配
- 最佳左前缀法则
- 不在索引列上做任何操作（计算、函数、（手动或自动）类型转换），会导致索引失效而转向全表扫描
- 存储引擎不能使用索引中范围条件右边的列
- 尽量使用覆盖索引
- MySQL在使用不等于（!=或<>)的时候无法使用索引会导致全表扫描
- is null，is not null也无法使用索引
- like以通配符开头（“%abc..‘）MySQL索引失效会变成全表扫描的操作
- 字符串不加单引号索引失效（自动类型转换）
- or左边有索引、右边没索引也会失效

##  3. Sql优化

###  3.1、 计算操作

1.尽量避免在SQL的JOIN和WHERE部分使用计算操作，因为大多数涉及到在SQL中计算操作的情况往往会使索引失效而进行了全表遍历操作或者加大了数据库的负担，

而这些本来是可以放到业务服务器上进行处理的，如

```
CREATE INDEX tb_tb_time ON tb (tb_time);
SELECT tb_id FROM tb WHERE YEAR(tb_time)='2012';（调用YEAR函数本质上也是计算操作）
```

这种情况不仅不能利用索引，还会给数据库带来更大的计算负担，而这种情况几乎不需要给业务服务器带来更大负担就可以进行优化，只需要将SQL修改为

```
CREATE INDEX tb_tb_time ON tb (tb_time);
SELECT tb_id FROM tb WHERE tb_time BETWEEN '2012-01-01 00:00:00' AND '2012-12-31 23:59:59'
```

### 3.2、 字段

 1.SELECT语句中所提取的字段尽量少，一般只取出需要的字段，千万不要为了方便编写SQL语句而使用以下类似做法

```
SELECT * FROM tb WHERE tb_gender=0;
```
当你读取出来的记录量很大时更要禁止这种做法，这就是为什么我在本篇文章中写的SQL都是SELECT tb_id之类来作为例子，

而不是SELECT *，这个读者可以亲测，即使你数据库的数据量不是很多，你也能发现当你SELECT *和SELECT ，

tb_id时的耗时差别有多大（PS：某次项目经历中我就因为这个问题导致两个SQL的耗时分别是 1100ms 和 200ms）

2.VARCHAR类型的字段长度在尽量合理范围内分配，无需分配过多

3.尽量使用TINYINT、SMALLINT、MEDIUM_INT作为整数字段类型而不是INT

4.设计允许的情况下，尽量将字段能否为NULL属性设置为NOT NULL，否则将可能导致引擎放弃使用索引而进行全表扫描


### 3.3、 连接表

有时候为了取到多个表的字段，编写SQL时会使用一次甚至多次JOIN操作，在进行多表连接时应使各个表的数据集尽量少，举个例子，比如现在tb1表数据量很大

```
SELECT tb1.tb1_name FROM tb1 LEFT JOIN tb2 ON tb2.tb2_otherid=tb1.tb1_id WHERE tb1.tb1_gender=0;
```
上面语句JOIN操作时会进行tb1、tb2两个表所有数据集连接操作，为了减小连接操作的数据集，可将其改为

```
SELECT tb1.tb1_name FROM (SELECT tb1.tb1_id, tb1.tb1_name FROM tb1 WHERE tb1.tb1_gender=0) AS tb1 LEFT JOIN tb2 ON tb2.tb2_otherid=tb1.tb1_id;
```
这样一来，JOIN左边的数据集就仅仅是tb1_gender=0筛选出来的数据集而不是tb1所有数据集，从而提高了JOIN操作的执行速度。要注意一点是，

JOIN操作的查询效率要比子查询高得多，所以可以使用JOIN操作的情况下尽量减少或杜绝子查询操作.



### 3.4索引的使用规范：

- 索引的创建要与应用结合考虑，建议大的 OLTP 表不要超过 6 个索引；
- 尽可能的使用索引字段作为查询条件，尤其是聚簇索引，必要时可以通过 index index_name 来强制指定索引；
- 避免对大表查询时进行 table scan，必要时考虑新建索引；
- 在使用索引字段作为条件时，如果该索引是联合索引，那么必须使用到该索引中的第一个字段作为条件时才能保证系统使用该索引，否则该索引将不会被使用；
- 要注意索引的维护，周期性重建索引，重新编译存储过程。　　


## 4.SQL语句的执行顺序

### 4.1.sql语句的执行顺序

```mysql
SELECT
	customer_type,
	count( * ) 
FROM
	orm_customer 
WHERE
	customer_type IS NOT NULL 
GROUP BY
	customer_type 
ORDER BY
	customer_type DESC
```

**sql语句的语法顺序**

 `SELECT[DISTINCT] >FROM>WHERE>GROUP BY > HAVING >UNION> ORDER BY` 

**sql语句的执行顺序**

`FROM>WHERE>GROUP BY>HAVING>SELECT>DISTINCT>UNION>ORDER BY`

-  1.执行from关键字后面的语句，明确数据的来源，它是从哪张表取来的。 
-  2.执行where关键字后面的语句，对数据进行筛选。 
-  3.执行group by后面的语句，对数据进行分组分类。 
-  4.执行select后面的语句，也就是对处理好的数据，具体要取哪一部分。 
-  5.执行order by后面的语句，对最终的结果进行排序 


## 关注
![snailThink.png](http://ww1.sinaimg.cn/large/006aMktPgy1gdegzjxv6yj30go0gogmi.jpg)

![](https://pic.downk.cc/item/5f5e3aae160a154a67a7b936.gif)
 &ensp;创作不易，感谢各位的支持和认可，就是我创作的最大动力，我们下篇文章见！

【转载请联系本人】如果本篇博客有任何错误，请批评指教，不胜感激！


