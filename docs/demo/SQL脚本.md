
### 1.添加字段

```sql
alter table 表名 add 字段名 type not null default 0 ;

ALTER TABLE GZWarehouseBooking ADD XTimeLimit DECIMAL(6,1) NOT NULL DEFAULT (0);

ALTER TABLE WmPlatformBooking ADD IsPushAutoBookingToGA INT NOT NULL DEFAULT (0)

ALTER TABLE PushQuantityNumber ADD Remarks NVARCHAR(128) NOT NULL DEFAULT ('')
```

### 2.修改字段名称

```sql
alter table 表名 rename column A to B ;
-- 修改字段默认值不为null
alter table A_test alter column TEST1 decimal(18,5) not null 

sp_rename 'EstimatedToArrivalUpload.CustomerRequirArrivTime','CustomerRequirArrivTime2','column'

```

### 3.修改字段类型
```sql
alter table 表名 modify column UnitPrice decimal(18, 4) not null;
alter table PsOrderDetail alter column OTDarriveDate datetime
```

### 4.修改字段默认值
```sql
alter table 表名 add default (0) for 字段名 with values
alter table 表名 drop constraint 约束名字   ------说明：删除表的字段的原有约束
alter table 表名 add constraint 约束名字 DEFAULT 默认值 for 字段名称 -------说明：添加一个表的字段的约束并指定默认值
```
### 5.删除字段
```sql
alter table 表名 drop column 字段名;
-- 删除有默认值的字段
alter table tableName(表名) drop constraint '默认值约束名'
alter table talbeName(表名) drop column '字段名'
```

### 8.修改表字段长度
```sql
ALTER TABLE 表名 ALTER COLUMN column1 VARCHAR(256)
```
### 9.关联查询

```sql
SELECT d.DeliveryNo, cb.BookingID
FROM dbo.Delivery d
	INNER JOIN (
		SELECT DeliveryNo, BookingID
		FROM dbo.ChannelBookingDelivery
		WHERE DeliveryNo = '49552049'
	) CB
	ON CB.DeliveryNo = d.DeliveryNo
		AND d.IsValid = 1
```

### 11.查询表中某字段
```sql
select * from [test_db].[dbo].sysobjects 
where id in(select id from [test_db].[dbo].syscolumns Where name='DriverID')
```

### 12.添加索引
```sql
-- 创建非聚集索引
CREATE index IX_Customer_ShortName ON dbo.Customer(ShortName)

-- 创建聚集索引
CREATE CLUSTERED INDEX PK_Customer_ShortName on Customer(ShortName);

-- 删除索引
DROP index dbo.Customer.IX_Customer_ShortName

-- 查看索引
exec sp_helpindex 'dbo.Customer' 
```



### 14.批量关联更新

```sql
UPDATE  D
SET     D.UpdateTime = cbd.CreateTime
FROM    dbo.Delivery D
        INNER JOIN ( SELECT DeliveryNo ,
                            BookingID ,
                            CreateTime
                     FROM   dbo.ChannelBookingDelivery
                     WHERE  DeliveryNo = 'TH040105'
                   ) cbd ON cbd.DeliveryNo = D.DeliveryNo; 
```


### 15.查询重复数据

```sql

-- 查询重复的单个字段（group by）
select 重复字段A, count(*) from 表 group by 重复字段A having count(*) > 1

-- 查询重复的多个字段（group by）
select 重复字段A, 重复字段B, count(*) from 表 group by 重复字段A, 重复字段B having count(*) > 1

-- 删除所有重复的数据
delete from table group by 重复字段 having count(重复字段) > 1
```

### 17.查询时间范围创建的表

```sql
-- 查看自己模式中的表创建时间，created字段对应的就是创建时间
-- 查看其它模式里的表：dba_objects, all_objects
select * from user_objects where object_type='TABLE'

-- sqlserver中如何表的创建时间
select name,crdate from sysobjects where xtype='u' order by crdate desc
select name,crdate from sysobjects where xtype='u' AND crdate>'2020-01-01' ORDER by crdate DESC 

-- sqlserver中如何表的创建时间
select name,crdate from sysobjects where xtype = 'U' AND name='Organization'
```

### 18.行转列存储过程

```sql
use data 
go
if OBJECT_ID('rowtocolok') is not null
begin
drop PROCEDURE [dbo].[rowtocolok]
end
go
CREATE PROCEDURE [dbo].[rowtocolok] @tableName SYSNAME,@groupColumn SYSNAME, 
@row2column SYSNAME,@row2columnValue SYSNAME,@sql_where NVARCHAR(MAX)
AS 
DECLARE @sql_str NVARCHAR(MAX)
DECLARE @sql_col NVARCHAR(MAX)
BEGIN
/********
DECLARE @tableName SYSNAME --行转列表
DECLARE @groupColumn SYSNAME --分组字段
DECLARE @row2column SYSNAME --行变列的字段
DECLARE @row2columnValue SYSNAME --行变列值的需聚合字段
SET @tableName = '#temp1'
SET @groupColumn = '客户编号'
SET @row2column = '月统计'
SET @row2columnValue = '付款金额'
SET @sql_where = 'where 月统计 between ''2016-7-1'' and ''2017-7-1'''
********/

SET @sql_str = N'
SELECT @sql_col_out = ISNULL(@sql_col_out + '','','''') + QUOTENAME(['+@row2column+'])
    FROM ['+@tableName+'] '+@sql_where+' GROUP BY ['+@row2column+']'
PRINT @sql_str
EXEC sp_executesql @sql_str,N'@sql_col_out NVARCHAR(MAX) OUTPUT',@sql_col_out=@sql_col OUTPUT
PRINT @sql_col
 
SET @sql_str = N'
SELECT * FROM (
    SELECT ['+@groupColumn+'],['+@row2column+'],['+@row2columnValue+'] FROM ['+@tableName+']) p PIVOT
    (SUM(['+@row2columnValue+']) FOR ['+@row2column+'] IN ( '+ @sql_col +') ) AS pvt
ORDER BY pvt.['+@groupColumn+']'
PRINT (@sql_str)
EXEC (@sql_str)
END

```


### 20.表字段说明查询

```sql
SELECT 
	t.[name] AS 表名,
	c.[name] AS 字段名,
	cast(ep.[value] as varchar(100)) AS [字段说明]
  FROM sys.tables AS t
  INNER JOIN sys.columns 
  AS c ON t.object_id = c.object_id
 LEFT JOIN sys.extended_properties AS ep 
  ON ep.major_id = c.object_id AND ep.minor_id = c.column_id WHERE ep.class =1 
  AND t.name='TableName'
```

### 21.查看表结构
```sql
--快速查看表结构（比较全面的）
SELECT  CASE WHEN col.colorder = 1 THEN obj.name
                  ELSE ''
             END AS 表名,
        col.colorder AS 序号 ,
        col.name AS 列名 ,
        ISNULL(ep.[value], '') AS 列说明 ,
        t.name AS 数据类型 ,
        col.length AS 长度 ,
        ISNULL(COLUMNPROPERTY(col.id, col.name, 'Scale'), 0) AS 小数位数 ,
        CASE WHEN COLUMNPROPERTY(col.id, col.name, 'IsIdentity') = 1 THEN '√'
             ELSE ''
        END AS 标识 ,
        CASE WHEN EXISTS ( SELECT   1
                           FROM     dbo.sysindexes si
                                    INNER JOIN dbo.sysindexkeys sik ON si.id = sik.id
                                                              AND si.indid = sik.indid
                                    INNER JOIN dbo.syscolumns sc ON sc.id = sik.id
                                                              AND sc.colid = sik.colid
                                    INNER JOIN dbo.sysobjects so ON so.name = si.name
                                                              AND so.xtype = 'PK'
                           WHERE    sc.id = col.id
                                    AND sc.colid = col.colid ) THEN '√'
             ELSE ''
        END AS 主键 ,
        CASE WHEN col.isnullable = 1 THEN '√'
             ELSE ''
        END AS 允许空 ,
        ISNULL(comm.text, '') AS 默认值
FROM    dbo.syscolumns col
        LEFT  JOIN dbo.systypes t ON col.xtype = t.xusertype
        inner JOIN dbo.sysobjects obj ON col.id = obj.id
                                         AND obj.xtype = 'U'
                                         AND obj.status >= 0
        LEFT  JOIN dbo.syscomments comm ON col.cdefault = comm.id
        LEFT  JOIN sys.extended_properties ep ON col.id = ep.major_id
                                                      AND col.colid = ep.minor_id
                                                      AND ep.name = 'MS_Description'
        LEFT  JOIN sys.extended_properties epTwo ON obj.id = epTwo.major_id
                                                         AND epTwo.minor_id = 0
                                                         AND epTwo.name = 'MS_Description'
WHERE   obj.name = 'TableName'--表名
ORDER BY col.colorder ;
```

### 30.SQL执行顺序

```sql
FROM <1>
ON <2>
JOIN <3>
WHERE <4>
GROUP BY <5>
HAVING <6>
SELECT <7>
DISTINCT <8>
ORDER BY <9>
LIMIT <10>
```

### 31.存储过程创建、修改时间

```sql
SELECT
    [name]
    ,create_date
    ,modify_date
FROM
  sys.all_objects
WHERE
type_desc = N'SQL_STORED_PROCEDURE'
and name = '存储过程名称' -- 输入名称
and modify_date >='2021-04-20 00:00:00'
```

### 32.SqlServer 使用正则校验
```sql
SELECT * FROM dbo.SapPushPODetail WHERE 
 PATINDEX('%[cut]', CustomerOrderNo)>0

SELECT * FROM dbo.SapPushPODetail WHERE 
CustomerOrderNo LIKE '%cut'

```

### 33.获取指定表的所有约束
```sql
SELECT  OBJECT_NAME(so.id) AS tableName ,
        OBJECT_NAME(sc.constid)
FROM    sysconstraints SC
        INNER JOIN sysobjects SO ON sc.id = so.id
WHERE   OBJECT_NAME(so.id) = 'TableName'
```

### 34.获取指定表指定列的默认值：
```sql
SELECT  SCOM.text AS value
FROM    syscolumns SCOL
        LEFT JOIN syscomments SCOM ON SCOL.cdefault = SCOM.id
WHERE   SCOL.id = OBJECT_ID('TableName')
        AND SCOL.name = 'ColumnName'
```


### 时间格式转化

```sql
 
SELECT CONVERT(varchar(100), GETDATE(), 0) AS Style0 
SELECT CONVERT(varchar(100), GETDATE(), 1) AS Style1 
SELECT CONVERT(varchar(100), GETDATE(), 2) AS Style2 
SELECT CONVERT(varchar(100), GETDATE(), 3) AS Style3 
SELECT CONVERT(varchar(100), GETDATE(), 4) AS Style4 
SELECT CONVERT(varchar(100), GETDATE(), 5) AS Style5 
SELECT CONVERT(varchar(100), GETDATE(), 6) AS Style6 
SELECT CONVERT(varchar(100), GETDATE(), 7) AS Style7 
SELECT CONVERT(varchar(100), GETDATE(), 8) AS Style8 
SELECT CONVERT(varchar(100), GETDATE(), 9) AS Style9 
SELECT CONVERT(varchar(100), GETDATE(), 10) AS Style10 
SELECT CONVERT(varchar(100), GETDATE(), 11) AS Style11 
SELECT CONVERT(varchar(100), GETDATE(), 12) AS Style12 
SELECT CONVERT(varchar(100), GETDATE(), 13) AS Style13 
SELECT CONVERT(varchar(100), GETDATE(), 14) AS Style14 
SELECT CONVERT(varchar(100), GETDATE(), 20) AS Style21 
SELECT CONVERT(varchar(100), GETDATE(), 21) AS Style21 
SELECT CONVERT(varchar(100), GETDATE(), 22) AS Style22 
SELECT CONVERT(varchar(100), GETDATE(), 23) AS Style23 
SELECT CONVERT(varchar(100), GETDATE(), 24) AS Style24 
SELECT CONVERT(varchar(100), GETDATE(), 25) AS Style25 
```


## 2.Mysql

### 2.1.创建临时表

```sql
CREATE TEMPORARY TABLE temp_table AS
(
	SELECT table_name, table_comment, create_time, update_time 
	FROM information_schema.tables
	WHERE table_schema = (SELECT DATABASE()) 
	AND table_name like 'dwd%'
	ORDER BY create_time DESC
);
```



### 2.2 查询所有表名

```sql
-- .查询指定数据库中指定表的所有字段名
show tables;
SELECT TABLE_NAME,TABLE_ROWS FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='Snailthink';

select column_name from information_schema.columns where table_schema='Snailthink' and table_name='Table_Name'

SELECT 
	table_name, 
	table_comment,
    create_time,
    update_time 
FROM information_schema.tables
WHERE table_schema = (SELECT DATABASE()) 
AND table_name like 'dwd%'
ORDER BY create_time DESC
```



### 2.3 查看表主键

```sql

SELECT
	table_schema,
	table_name,
	column_name AS ID 
FROM
	INFORMATION_SCHEMA.KEY_COLUMN_USAGE t 
WHERE
	t.table_schema = 'snailthink' 
	AND table_name = '表名称';
```



### 2.4 查看表字段

```sql
SELECT
	COLUMN_NAME,
	IS_NULLABLE,
	DATA_TYPE,
	CHARACTER_MAXIMUM_LENGTH,
	COLUMN_TYPE COLUMN_KEY,
	EXTRA,
	COLUMN_COMMENT 
FROM
	information_schema.COLUMNS 
WHERE
	table_name = 'orm_dept' 
	AND table_schema = 'snailthink';
```

### 2.5 索引

```sql

-- 1. Mysql设置多列唯一索引
ALTER TABLE `orm_dept` ADD UNIQUE INDEX ` UNIQ_TEMP` (`dept_id`, `dept_no`) USING BTREE 
```

### 2.6. 查看数据库引擎 InnoDB/ MyISAM

```sql
show engines 
show variables like 'storage_engine'
show variables like '%storage_engine%'
show create table orm_dept_test
```

### 2.7 查看数据库创建表语句

```sql
show create table orm_dept_test
```

### 2.8 行转列

```sql

```

### 2.9 列转行

```sql
-- 安装逗号分割
select group_concat(id) from orm_customer;
```

### 2.10 mysql时间用法

```sql
1.获得当前日期函数：curdate()，current_date()
2.获得当前时间函数：curtime();
3.获得当前日期+时间：now();
4.SELECT DATE_ADD(CURRENT_DATE(),INTERVAL 2 DAY) AS OrderPayDate //2天后
5.SELECT DATE_SUB(CURRENT_DATE(),INTERVAL 2 DAY) AS OrderPayDate //2天前
6.SELECT DATEDIFF('2020-08-14','2020-08-10') //返回4 时间相减
7.SELECT DATE_FORMAT(NOW(),'%Y-%m-%d') //时间格式转化
8.SELECT DATE_ADD(NOW(),INTERVAL -15 DAY) 15天前的数据
9.DATE_ADD(NOW,INTERVAL 1 MONTH) -- 一个月之后
10.获取23:59:59 时间
SELECT DATE_FORMAT('2019-08-08','%Y-%m-%d %H:%i:%s');
SELECT DATE_SUB( DATE_ADD('2019-08-08', INTERVAL 1 DAY),INTERVAL 1 SECOND)
```


### 2.11 查询重复数据
```sql
SELECT
	* 
FROM
	snailthink.orm_dept 
WHERE
	dept_no IN ( SELECT dept_no FROM snailthink.orm_dept GROUP BY dept_no HAVING count( dept_no ) > 1 )
	
```

### 2.12 SUBSTRING 截取数据
```sql

SELECT SUBSTRING('MySQL SUBSTRING',1,5);

SELECT COUNT(*) FROM orm_booking where 
SUBSTRING(delivery_no,1,4)='2019';
```

### 2.13 正则查询数据

```sql
-- 查找 person_name 字段中以'st'为开头的所有数据：
SELECT person_name FROM person_tbl WHERE name REGEXP '^st';

-- 查找 person_name 字段中以'ok'为结尾的所有数据：
SELECT person_name FROM person_tbl WHERE name REGEXP 'ok$';

-- 查找 person_name 字段中包含'mar'字符串的所有数据：
 SELECT person_name FROM person_tbl WHERE name REGEXP 'mar';

-- 查找 person_name 字段中以元音字符开头或以'ok'字符串结尾的所有数据：
SELECT person_name FROM person_tbl WHERE name REGEXP '^[aeiou]|ok$';
```
### 2.14 索引相关


### 2.15 字段处理

```sql
-- 添加字段
alter table carrier add remark  varchar(64);
-- 删除字段
alter table carrier drop column remark;

```

