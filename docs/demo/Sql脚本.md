
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

