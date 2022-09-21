## 一、count 的区别

### 1.count(1) and count(*) 区别

 从执行计划来看，count(1)和count(*)的效果是一样的。

 当表的数据量大些时，对表作分析之后，使用count(1)还要比使用count(*)用时多！ 

 当数据量在1W以内时，count(1)会比count(*)的用时少些，不过也差不了多少。

 如果count(1)是聚集索引时，那肯定是count(1)快，但是差的很小。 

 因为count(*)，会自动优化指定到那一个字段。所以没必要去count(1)，使用count(*)，sql会帮你完成优化的 


### 2.count(1) and count(字段)
count(1) 会统计表中的所有的记录数，包含字段为null 的记录。

count(字段) 会统计该字段在表中出现的次数，忽略字段为null 的情况。即不统计字段为null 的记录。

### 3.count(*) 和 count(1)和count(列名)区别  

 count(*)包括了所有的列，相当于行数，在统计结果的时候，不会忽略为NULL的值。

 count(1)包括了忽略所有列，用1代表代码行，在统计结果的时候，不会忽略为NULL的值。

 count(列名)只包括列名那一列，在统计结果的时候，会忽略列值为NULL的数据

### 4. 执行效率

列名为主键，count(列名)会比count(1)快  

列名不为主键，count(1)会比count(列名)快  

如果表多个列并且没有主键，则 count(1 的执行效率优于 count（*）  

如果有主键，则 select count（主键）的执行效率是最优的  

如果表只有一个字段，则 select count（*）最优。

## 2.MySQL字符串长度

| 数据类型               | 最大长度   |
| ---------------------- | ---------- |
| CHAR                   | 255        |
| BINARY                 | 255        |
| varchar VARBINARY      | 65535      |
| TINYBLOB,TINYTEXT      | 255        |
| BLOB ,TEXT             | 65535      |
| MEDIUMBLOB ,MEDIUMTEXT | 16777215   |
| LONGBLOB,LONGTEXT      | 4294967295 |
| ENUM                   | 65535      |
| SET                    | 65535      |


## 3.存储过程以及函数


### 3.1 MySQL 创建以及调用存储过程


```sql

-- 1.创建存储过程
DROP PROCEDURE IF EXISTS Pro_Employee;
DELIMITER $$
CREATE PROCEDURE Pro_Employee(IN pdepid VARCHAR(20),OUT pcount INT )
READS SQL DATA
SQL SECURITY INVOKER
BEGIN
SELECT COUNT(id) INTO pcount FROM Employee WHERE depid=pdepid;

END$$
DELIMITER ;


-- 2.调用存储过程
CALL Pro_Employee(101,@pcount);
-- 返回结果
SELECT @pcount;


-- 3.删除存储过程
DROP PROCEDURE Pro_Employee; 
```


### 3.2 MySQL 创建以及调用函数

```sql

-- 函数的创建
DELIMITER $$
create function myselect5(name varchar(15)) 
returns int
begin 
    declare c int;
    select id into c from orm_dept where dept_name=name ;
    return c;
end $$


-- 函数的删除
DROP FUNCTION myselect5

-- 执行函数
select myselect5("运维部");
 
```

### 3.3 查看视图以及存储过程

1. mysql查看存储过程函数
```sql
 select `name` from mysql.proc where db = 'xx' and `type` = 'PROCEDURE'   //存储过程
 select `name` from mysql.proc where db = 'xx' and `type` = 'FUNCTION'   //函数

 show procedure status; //存储过程
 show function status;     //函数
```
2. 查看存储过程或函数的创建代码

```sql
show create procedure proc_name;
show create function func_name;
```
3.查看视图
```sql
SELECT * from information_schema.VIEWS   //视图
SELECT * from information_schema.TABLES   //表
```
4.查看触发器
```sql
SHOW TRIGGERS [FROM db_name] [LIKE expr]
SELECT * FROM triggers T WHERE trigger_name=”mytrigger” \G
```
