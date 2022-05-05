[TOC]

### 一、SQL基础

```xml
1.查询
SELECT 列名称 FROM 表名称

2.去重
SELECT DISTINCT 列名称 FROM 表名称

3.WHERE 子句
SELECT 列名称 FROM 表名称 WHERE 列 运算符 值

4.AND 和 OR 运算符
SELECT * FROM User WHERE UserName='张三' AND UserID=10

5.ORDER BY 语句
SELECT OrgID, OrgName FROM Organization ORDER BY Company

6.INSERT
INSERT INTO 表名称 VALUES (值1, 值2,....)

7.Update 
UPDATE 表名称 SET 列名称 = 新值 WHERE 列名称 = 某值

8.DELETE
DELETE FROM 表名称 WHERE 列名称 = 值
```
### 二、提升
```xml
1.IN 操作符多个值查询
SELECT column_name(s) FROM table_name WHERE column_name IN (value1,value2,...)

2.INNER JOIN 返回table_name1所有数据
SELECT column_name(s)  FROM table_name1
INNER JOIN table_name2 ON table_name1.column_name=table_name2.column_name

3.INNER JOIN 返回table_name2 和table_name1 交集数据
SELECT column_name(s) FROM table_name1
LEFT JOIN table_name2 ON table_name1.column_name=table_name2.column_name

4.RIGHT JOIN 返回table_name2所有数据
SELECT column_name(s) FROM table_name1
RIGHT JOIN table_name2 ON table_name1.column_name=table_name2.column_name

5.FULL JOIN 
SELECT column_name(s) 
FROM table_name1 FULL JOIN table_name2 ON table_name1.column_name=table_name2.column_name

6.SELECT INTO  复制表数据
SELECT * INTO table_name1  FROM table_name2

7.LIKE 模糊查询
SELECT column_name FROM table_name WHERE column_name LIKE '张%'

8.BETWEEN 某一个字段的值在哪个区间
SELECT column_name FROM table_name WHERE column_name BETWEEN value1 AND value2

9.TOP 查询数据库前几条数据
SELECT TOP 10 * FROM table_name

10.IS NULL/IS NOT NULL 查询某一个字段不为null
SELECT TOP 10 * FROM users where users_name is not null 
SELECT TOP 10 * FROM users where users_name is  null 
```
### 三、函数

```
1.COUNT 查询表中总共有多少数据
SELECT COUNT( * )   FROM table_name

2.AVG 查询平均值
SELECT AVG(column_name) FROM table_name

3.MAX 查询某一字段最大值
SELECT MAX(column_name) FROM table_name

3.Min 查询某一字段最小值
SELECT Min(column_name) FROM table_name

4.SUM  对某一字段求和
SELECT SUM(column_name) FROM table_name

5.HAVING 子句 一般用于去重
SELECT Customer,SUM(qty) FROM Orders GROUP BY Customer HAVING SUM(qty)<100

6.FORMAT 时间格式转化
SELECT FORMAT(column_name,format) FROM table_name
```

### 四、实战

#### 1.SELECT

1.FOR XML 将多条数据合并为一条数据

```sql
	SELECT d.DriverName+','
	FROM dbo.TaskDriver td WITH(NOLOCK)    
	INNER JOIN dbo.Driver d WITH(NOLOCK) ON td.DriverID=d.DriverID   
	WHERE td.IsValid=1 AND td.TaskID=384186 FOR  XML PATH('')
```

2.FOR XML 加子查询加INNER JOIN 联合使用

```sql
	SELECT A.RoleID,r.RoleName,LEFT(ColumnStr,LEN(ColumnStr)-1) AS ColumnStr 
	FROM(	
		SELECT pr.RoleID  
			,  (SELECT ColumnName+',' 
				FROM PageColumnSetting p3 
				WHERE p3.IsValid=1 AND p3.ParentID>0  
				AND NOT EXISTS(
					SELECT 1 FROM PageColumnSetting p4 
					WHERE p4.IsValid=1 AND p4.ParentID=p3.ID
				)
			FOR XML PATH('')) AS ColumnStr
		FROM PageColumnSetting p1 
		INNER JOIN PageRoleDim pr ON p1.ID=pr.ColumnID AND pr.IsValid=1
		WHERE p1.IsValid=1 AND p1.ParentID>0  
		AND NOT EXISTS(
			SELECT 1 FROM PageColumnSetting p2 
			WHERE p2.IsValid=1 AND p2.ParentID=p1.ID
		)
		GROUP BY pr.RoleID
	)A
	INNER JOIN dbo.[Role] r  WITH(NOLOCK) ON A.RoleID=r.RoleID AND r.IsValid =1
```


3.FULL JOIN 将俩条数据合并为同一条数据
```sql
	SELECT ISNULL(b1.TaskID,b2.TaskID) AS TaskID,ISNULL(b1.BookingID,b2.BookingID) AS BookingID, ISNULL(b1.BookingType,b2.BookingType) AS BookingType,
		   b1.OperationType AS PickOperationType,b1.FirstUpdateConfirmTime AS PickRollbackUpdateConfirmTime ,b1.FirstUpdateReasonType AS PickRollbackUpdateReason, --回退  
		   b2.OperationType AS UnloadOperationType,b2.FirstUpdateConfirmTime AS PickUpdateConfirmTime ,b2.FirstUpdateReasonType AS PickUpdateReason --修改提货/卸货
	FROM BookingRecordOperation b1
	FULL JOIN BookingRecordOperation b2 ON  b1.BookingID=b2.BookingID AND b1.TaskID=b2.TaskID AND b2.OperationType=2
	AND   b1.OperationType=1
``` 
#### 2.Update

1.更新#PageData表中不存在的数据

```sql
	UPDATE pd
	SET pd.IsDump = 1
	FROM #PageData pd 
	WHERE EXISTS(
		SELECT 1 
		FROM dbo.DeliveryDetail dd WITH(NOLOCK)
		WHERE dd.DeliveryNo = pd.DeliveryNo 
		AND dd.TotalNum <> dd.ResidueNum 
		AND dd.IsValid = 1
	) 
	AND pd.CurrentOrgID = pd.SendOrgID
```

2.Update和INNER JOIN配合使用

```sql
	UPDATE pd 
	SET pd.TotalVolume = a.TotalVolume,
		pd.TotalWeight = a.TotalWeight,
		pd.NumberOfUnits = a.NumberOfUnits,    
		pd.RevenueTon = dbo.GetRevenueTon(a.TotalVolume,a.TotalWeight)
	FROM #PageData pd
	INNER JOIN (    
		SELECT dt.DeliveryNo,
				SUM(dt.ResidueNum) AS NumberOfUnits,    
				SUM((dt.Weight/dt.TotalNum)*dt.ResidueNum) AS TotalWeight,    
				SUM((dt.Volume/dt.TotalNum)*dt.ResidueNum) AS TotalVolume   
		FROM dbo.DeliveryDetail dt WITH(NOLOCK)    
		INNER JOIN #PageTemp pt ON pt.DeliveryNo = dt.DeliveryNo     
		WHERE dt.IsValid = 1 
		AND dt.TotalNum > 0
		GROUP BY dt.DeliveryNo    
	) a ON a.DeliveryNo = pd.DeliveryNo
	WHERE pd.DeliveryNo NOT IN(SELECT * FROM #XqDeliveryNo)
	AND pd.SendOrgID = pd.CurrentOrgID	
```

#### 3.表/字段

```xml
新增表
create table tablename(col1 type1 [not null] [primary key],col2 type2 [not null],..)

删除表
drop table tablename

修改表
sp_rename tablename,newtablename  //修改表名称

新增字段：
ALTER TABLE [表名] ADD [字段名] NVARCHAR (50) NULL

ALTER TABLE [表名] ADD [字段名] INT NOT NULL DEFAULT (0) //添加有默认值的

删除字段：
ALTER TABLE [表名] DROP COLUMN [字段名]

修改字段：
ALTER TABLE [表名] ALTER COLUMN [字段名] NVARCHAR (50) NULL

ALTER TABLE [表名] ADD DEFAULT [默认值] FOR [字段名] //修改默认值
```

#### 4.索引(增删改查)

```xml
新增：
1、一般的创建语法：
CREATE (unique/cluster) INDEX<索引名> ON <表名>
【拓展】索引的类型有UNIQUE（唯一索引）、CLUSTERED（建立聚集索引）、NONCLUSTERED（建立非聚集索引）、Index_property（索引属性）。

UNIQUE索引既可以采用聚集索引结构，也可以采用非聚集索引的结构，如果不指明采用的索引结构，则SQL SERVER系统默认为采用非聚集索引结构。

删除：
1、一般的删除语法
drop index<索引名>

2、简要的删除语法
drop index [索引名]

3、删除某张表中的索引
drop index [索引名] ON [表名]

修改：
1、使用系统存储过程修改索引名称：
EXEC sp_rename [原名称],[新名称],[index]
【备注】sp_rename不止可以修改索引名称，同时可以修改表名、列名和类型名称。

查：
1、使用系统存储过程查询：
EXEC sp_helpindex [表名称]

2、使用系统的视图查询：
SELECT * FROM sysindexes WHERE name = ‘索引名称’

【常用的操作】
1、判断是否存在该索引，存在则删除
if exists(select * from sysindexes where name ‘soyn’)
drop index [soyn] on test1
```

### 点赞👍 关注❤ 不迷路

>如果你觉得我的文章对你有帮助话，欢迎点赞👍 关注❤️ 分享👥！
>如果本篇博客有任何错误，请批评指教，不胜感激！

![极客大本营](https://user-gold-cdn.xitu.io/2020/1/12/16f9787f4bedeb25?w=600&h=498&f=png&s=48621)
