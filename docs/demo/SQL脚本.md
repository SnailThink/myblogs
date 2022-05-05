
### 1、添加字段

```sql
alter table 表名 add 字段名 type not null default 0 ;

ALTER TABLE GZWarehouseBooking ADD XTimeLimit DECIMAL(6,1) NOT NULL DEFAULT (0);

ALTER TABLE WmPlatformBooking ADD IsPushAutoBookingToGA INT NOT NULL DEFAULT (0)

ALTER TABLE PushQuantityNumber ADD Remarks NVARCHAR(128) NOT NULL DEFAULT ('')
```

### 2、修改字段名

```sql
alter table 表名 rename column A to B ;
```

### 3、修改字段类型
```sql
alter table 表名 modify column UnitPrice decimal(18, 4) not null;
```

### 4、修改字段默认值
```sql

alter table 表名 add default (0) for 字段名 with values

alter table 表名 drop constraint 约束名字   ------说明：删除表的字段的原有约束

alter table 表名 add constraint 约束名字 DEFAULT 默认值 for 字段名称 -------说明：添加一个表的字段的约束并指定默认值
```
### 5、删除字段
```sql
alter table 表名 drop column 字段名;
```

### 6、删除有默认值的字段
```sql
 alter table tableName(表名) drop constraint '默认值约束名'

 alter table talbeName(表名) drop column '字段名'
```

### 8、修改表字段长度
```sql
ALTER TABLE 表名 ALTER COLUMN column1 VARCHAR(256)
```
### 9、修改表字段类型
```sql
alter table PsOrderDetail alter column OTDarriveDate datetime
```

### 10、修改表字段名称

```sql
-- 修改字段默认值不为null
alter table A_test alter column TEST1 decimal(18,5) not null 
```

### 11、查询表中包含某字段的数据
```sql
select * from [test_db].[dbo].sysobjects 
where id in(select id from [test_db].[dbo].syscolumns Where name='DriverID')
```

### 12、添加索引
```sql
-- 创建非聚集索引
CREATE index IX_Customer_ShortName ON dbo.Customer(ShortName)

-- 创建聚集索引
CREATE CLUSTERED INDEX PK_Customer_ShortName on Customer(ShortName);

--删除索引
DROP index dbo.Customer.IX_Customer_ShortName

-- 查看索引
exec sp_helpindex 'dbo.Customer' 

```

### 13、查看表创建时间
```sql
select name,crdate from sysobjects where xtype = 'U' AND name='Organization'
```
### 14、批量更新

```sql
UPDATE d SET UpdateTime=cbd.CreateTime
FROM  dbo.Delivery D
INNER JOIN (
SELECT DeliveryNo,BookingID,CreateTime FROM dbo.ChannelBookingDelivery WHERE DeliveryNo ='WM070301'
)cbd ON cbd.DeliveryNo = D.DeliveryNo 
```


```sql

SELECT d.DeliveryNo,cb.BookingID
 FROM dbo.Delivery d
INNER JOIN 
(
SELECT DeliveryNo,BookingID FROM dbo.ChannelBookingDelivery WHERE DeliveryNo ='49552049'
) CB ON CB.DeliveryNo = d.DeliveryNo AND d.IsValid=1
 
```


### 15、查询重复数据

```sql

-- 查询重复的单个字段（group by）
select 重复字段A, count(*) from 表 group by 重复字段A having count(*) > 1

-- 查询重复的多个字段（group by）
select 重复字段A, 重复字段B, count(*) from 表 group by 重复字段A, 重复字段B having count(*) > 1

-- 删除所有重复的数据
delete from table group by 重复字段 having count(重复字段) > 1
```


### 16.查询时间范围修改的存储过程

```sql
declare @Platform nvarchar(100) = '数据库名称'
declare @Platform_BusinessData nvarchar(100) = '数据库名称' 
declare @LastModifyDate nvarchar(100) = '2020-04-10 00:00:00'  --修改时间

declare @sql nvarchar(max) = '
if OBJECT_ID(''tempdb..#t'') is not null drop table #t

select *
    into #t
    from (
    select ''' + @Platform + '..'' + o.name + isnull(''.'' + tb.name, '''') name, o.create_date, o.modify_date,o.type_desc
        FROM ' + @Platform + '.sys.all_objects o
        left join ' + @Platform + '.sys.triggers t on t.object_id = o.object_id
        left join ' + @Platform + '.sys.tables tb on tb.object_id = t.parent_id
        union all
    select ''' + @Platform_BusinessData + '..'' + o.name + isnull(''.'' + tb.name, ''''), o.create_date, o.modify_date,o.type_desc
        FROM ' + @Platform_BusinessData + '.sys.all_objects o
        left join ' + @Platform_BusinessData + '.sys.triggers t on t.object_id = o.object_id
        left join ' + @Platform_BusinessData + '.sys.tables tb on tb.object_id = t.parent_id
    ) t
    where modify_date >=''' + @LastModifyDate + '''

--select distinct type_desc from #t

select * from #t
    where type_desc = ''USER_TABLE''
        
select * from #t
    where type_desc = ''SQL_STORED_PROCEDURE''
    
select * from #t
    where type_desc = ''SQL_SCALAR_FUNCTION'' or type_desc = ''SQL_TABLE_VALUED_FUNCTION''
    
select * from #t
    where type_desc = ''VIEW''
    
select * from #t
    where type_desc = ''SQL_TRIGGER''
'    

print @Sql
exec sp_executesql @sql
```



### 17.查询时间范围创建的表

```sql
-- 查看自己模式中的表创建时间，created字段对应的就是创建时间
-- 查看其它模式里的表：dba_objects, all_objects
select * from user_objects where object_type='TABLE'

-- sqlserver中如何表的创建时间
select name,crdate from sysobjects where xtype='u' order by crdate desc
select name,crdate from sysobjects where xtype='u' AND crdate>'2020-01-01' ORDER by crdate DESC 
```


#### 18.行转列存储过程
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

#### 19、查看锁

```sql
--查看数据库表锁的情况：

  --查看被锁表： 

    select   request_session_id   spid,OBJECT_NAME(resource_associated_entity_id) tableName    

    from   sys.dm_tran_locks where resource_type='OBJECT' 

 select * from      sys.dm_tran_locks   where resource_type='OBJECT' 
     --spid   锁表进程  
	 --tableName   被锁表名 
   -- 解锁： 
       declare @spid  int  
    Set @spid  = 57 --锁表进程 
  declare @sql varchar(1000) 
    set @sql='kill '+cast(@spid  as varchar) 
    exec(@sql)
 
select * from [sys].[sysprocesses] der
 CROSS APPLY 
  sys.[dm_exec_sql_text](der.[sql_handle]) AS dest 
 where spid=25


 --闩锁总累计等待次数和时间
SELECT wait_type,wait_time_ms,waiting_tasks_count
,wait_time_ms/NULLIF(waiting_tasks_count,0) AS avg_wait_time
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE 'LATCH%'
or wait_type LIKE 'PAGELATCH%'
or wait_type LIKE 'PAGEIOLATCH%'

--各种类闩锁详细累计等待次数和时间
SELECT * FROM sys.dm_os_latch_stats

--查看自旋锁
SELECT * FROM sys.dm_os_spinlock_stats

DBCC SQLPERF(spinlockstats)

```

#### 20、SqlServer字段说明查询
```sql 
SELECT t.[name] AS 表名,c.[name] AS 字段名,cast(ep.[value] 
  as varchar(100)) AS [字段说明]
  FROM sys.tables AS t
  INNER JOIN sys.columns 
  AS c ON t.object_id = c.object_id
 LEFT JOIN sys.extended_properties AS ep 
  ON ep.major_id = c.object_id AND ep.minor_id = c.column_id WHERE ep.class =1 
  AND t.name='TableName'
```

#### 21、SqlServer查看表结构
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


#### 22.查找表主键

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

#### 23.Mysql设置多列唯一索引

```sql
ALTER TABLE `orm_dept` ADD UNIQUE INDEX ` UNIQ_TEMP` (`dept_id`, `dept_no`) USING BTREE 
```
#### 24. 查看数据库引擎  InnoDB/ MyISAM
```sql
show engines 
show variables like 'storage_engine'
show variables like '%storage_engine%'
show create table orm_dept_test
```
#### 25. 查看数据库创建表语句
```sql
show create table orm_dept_test
```

#### 26. MySQL查找表字段
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

#### 27. 查询存储过程的修改时间
```sql

-- 查询存储过程的修改时间
Select [name],create_date,modify_date FROM sys.all_objects where type_desc = N'SQL_STORED_PROCEDURE' and name = '存储过程名'

```

#### 28 查询数据库所有表名称
```sql
-- 1.查询数据库中所有表名称
-- 
show tables;
SELECT TABLE_NAME,TABLE_ROWS FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='Snailthink';

-- 2.查询指定数据库中指定表的所有字段名
select column_name from information_schema.columns where table_schema='Snailthink' and table_name='Table_Name'
```


#### 29.关联更新数据
```sql
UPDATE operation o 
       JOIN  (SELECT o.id, 
                            o.status 
                     FROM   operation o 
                     WHERE  o.group = 123 
                            AND o.status NOT IN ( 'done' ) 
                     ORDER  BY o.parent, 
                               o.id 
                     LIMIT  1) t
         ON o.id = t.id 
SET    status = 'applying' 
```

#### 30. SQL执行顺序

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

#### 31. 某个存储过程修改时间
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