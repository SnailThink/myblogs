**Transact-SQL编码规范**v1.4

 

目录

\1. 概述	6

1.1.基本原则	6

1.2.基本规范	6

\2. 命名规范	6

2.1.对象命名	6

2.1.1. 数据库	6

2.1.2. 数据库文件	6

2.1.3. 关系型数据仓库	7

2.1.4. 数据架构	7

2.1.5. 数据表	7

2.1.6. 数据视图	7

2.1.7. 数据列	7

2.1.8. 存储过程	8

2.1.9. 函数	8

2.1.10. 用户定义数据类型	8

2.1.11. DML触发器	8

2.1.12. DDL触发器	8

2.1.13.主键、外键关系和索引	9

2.1.14 约束和默认值	9

2.2.参数命名	10

2.2.1. 数据列参数	10

2.2.2. 非数据列参数	10

2.2.3. 命名尽量意义明确	10

2.3.常见命名	10

2.3.1. 常用字段命名	10

\3. SQL编写	11

3.1. 大小写	11

3.2. 使用“;”	11

3.3. 存储格式	11

3.4. 类型选择	11

3.5. 默认值	12

3.6. 字段长度	12

3.7. 使用“'”	12

3.8. 语句缩进	12

3.9. 语句换行	12

3.10. 语句分割	12

3.11. 使用“*”	13

3.12. 表名别名	13

3.13. 类型转换	13

3.14. 数值比较	13

3.15. 排序	13

3.16. Unicode字符串	13

3.17. BEGIN...END 块	14

3.18. TRY块	14

3.19. TOP子句	14

3.20. TRANSACTION编写	15

3.21. 存储过程	15

3.22. 架构名称	16

3.23. INSERT语句	16

3.24 表创建	16

\4. 代码注释	16

4.1. 代码头部注释	16

4.2. TRANSACTION注释	17

4.3 注释的有效性	17

\5. 附录A 命名规则	17



#  1. 概述

## 1.1.基本原则

以大小写敏感编写SQL语句。

尽量使用Unicode 数据类型。

优先使用连接代替子查询或嵌套查询。

使用参数化SQL查询代替语句拼接SQL查询。

禁止使用[拼音]+[英语]的方式来命名SQL对象或变量。

使用存储过程代替SQL语句。

## 1.2.基本规范

采用Pascal样式命名数据库对象。

大写T-SQL语言的所有关键字，谓词和系统函数。

# 2. 命名规范

在一般情况下，采用Pascal样式命名数据库对象，使在开发基于数据库应用程序的时候通过ORM工具生成的数据访问代码不需要调整就符合程序开发语言（比如C#）命名规范。另外，关系型数据库同Xml结合得越来越紧密,规范的命名越来越重要。



## 2.1.对象命名

### 2.1.1. 数据库

采用Pascal样式命名，命名格式为[项目英文名称]。

示例：AdventureWorks

### 2.1.2. 数据库文件

数据文件：[数据库名称] +_[文件组名称][数量]_FILE[数量]+ _Data.mdf

​		  [数据库名称] +[文件组名称] [数量]_FILE[数量]+ _Data.ndf

日志文件：[数据库名称] + _Log.ldf

```
示例：AdventureWorks_PRI_FILE1_Data.mdf
AdventureWorks_FG1_FILE1_Date.ndf
AdventureWorks_Log.ldf
```

### 2.1.3. 关系型数据仓库

采用Pascal样式命名，命名格式为[项目英文名称] + DW。

```
示例：AdventureWorksDW
```

### 2.1.4. 数据架构

除SQL Server 系统定义的数据架构外，新建架构采用Pascal样式命名，命名格式为[架构名]。

```
示例：HumanResources
Production
```

对数据库对象 Table，View，Procedure，Function等使用数据架构进行归类。在SQL Server 2000中dbo为默认架构。在创建与架构有关数据库对象（表、视图、存储过程、触发器、函数等）时，需加架构名称。

```
示例：CREATE TABLE dbo.ai_objcomm等
```

### 2.1.5. 数据表

采用Pascal样式命名，命名格式为 [表名]。

```
示例：Employee Product
```

表名以英文单数命名，主要是参考SQL Server 2005示例数据库。

```
示例：使用Product 而不是Products
```

### 2.1.6. 数据视图

视图名称采用Pascal样式命名，命名格式为v + [视图名称]。

```
示例：vEmployee vSalesPerson
```

### 2.1.7. 数据列

列名称命名采用英文单词或缩写，英文单词只来自于具体业务定义，尽量表达清楚含义。采用Pascal样式命名，命名格式为[列名称]。

```
示例：AddressID PostalCode
```

尽量避免使用拼音命名，如果不可避免，对于比较短的列名，采用拼音全写，如果拼音列名比较复杂，可以采用首个字用全拼，其它字用首字母大写表示。

```
示例：宁波 Ningbo 经营方式 JingYFS
```

### 2.1.8. 存储过程

建议采用Pascal样式命名，命名格式为pr+[存储过程名称] +{Ins|Upd|Del|Sel }，让相同功能模块的存储过程在一起，方便查找。

```
示例：prLogUserIns prLogUserSel
```

### 2.1.9. 函数

自定义函数采用Pascal样式命名，命名格式为fn+[函数名]，系统函数使用全部大写。

```sql
示例：SELECT ISNULL(@LastName,'Unknown last name');
GETDATE()
dbo. fnConvertGPSStatus
```

### 2.1.10. 用户定义数据类型

采用Pascal样式命名，命名格式为[自定义数据类型名称]。

```
示例：NameStyle
```

### 2.1.11. DML触发器

DML触发器是当数据库服务器中发生数据操作语言 (DML) 事件时要执行的操作。DML 事件包括对表或视图发出的 UPDATE、INSERT 或 DELETE 语句。根据事件不同命名规则使用前缀进行区分,格式为 ：

AFTER 触发器：tr表名[后面插入加I,修改加U,删除加D]。

INSTEAD OF 触发器：tr表名或视图名OF[后面插入加I,修改加U,删除加D]

```
示例：dbo.trTrackOFI，dbo.trTrackIU
```

### 2.1.12. DDL触发器

响应各种数据定义语言 (DDL) 事件而激发。这些事件主要与以关键字 CREATE、ALTER 和 DROP 开头的 Transact-SQL 语句对应。执行 DDL 式操作的系统存储过程也可以激发 DDL 触发器。

添加ddl前缀，

```sql
示例：
CREATE TRIGGER [ddlDatabaseTriggerLog] 
ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS 
AS
```

### 2.1.13.主键、外键关系和索引

主键: PK_[表名称]_[主键]；如果是组合主键，使用PK_[表名]_[主键1]_[主键2]。

```sql
示例：PK_Store_CustomerID
PK_StoreContact_CustomerID_ContactID
```

外键关系：FK_[从表名称]_[主表名称]_[外键列名称]。

```sql
示例：FK_StoreContact_Store_CustomerID
```

聚集索引：PK_[表名称]_[主键]；如果是组合主键，使用PK_[表名]_[主键1]_[主键2]。

```sql
示例：PK_Store_CustomerID 
PK_StoreContact_CustomerID_ContactID
```

唯一非聚集索引:AK_[表名称]_[列名称]。

```sql
示例：AK_Store_rowguid
```

不唯一非聚集索引：IX_[表名称]_[列名称]。

```sql
示例：IX_Store_SalesPersonID
```

主 XML索：PXML_[表名称]_[Xml类型列名称]。

```sql
示例：PXML_Store_Demographics
```

### 2.1.14 约束和默认值

约束：CK_[表名称] _[列名]；如果约束涉及多列，使用CK_[表名称]_[列名1]_[列名2]或CK_[表名称]_[约束含义]

```sql
示例：CK_Ai_Track_GPSTime
```

默认值：DF_[表名]_[列名]

```sql
示例：DF_Ai_Track_CreatedDate
```

## 2.2.参数命名

### 2.2.1. 数据列参数

命名格式为 @ + [列名称]。

```sql
示例：@EmployeeID
```

在列名不符合Pascal样式时（早期遗留系统），例如使用全部大写的列名称，或使用“_”进行连接的字段名称，参数名称定义使用 @ + [列名称]，这里的列名称尽量符合Pascal样式命名。

### 2.2.2. 非数据列参数

在参数无法跟列名称进行关联时，使用能够反映该参数功能的英文单词或单词组合, 采用Pascal样式命名。

示例：@ErrorID

### 2.2.3. 命名尽量意义明确

名字要尽可能地具体。那些太模糊或者太通用以致于能够用于多种目的的名字通常不要使用。

示例：@Flag等

## 2.3.常见命名

### 2.3.1. 常用字段命名

这里的常用字段是指在建表时频繁使用的表名或列名，下表对常用字段进行建议性定义,

 

| 列名称       | 数据类型         | 说明                                       |
| ------------ | ---------------- | ------------------------------------------ |
| CreatedDate  | datetime         | 记录创建日期，一般使用GETDATE()自动生成    |
| ModifiedDate | datetime         | 记录最后修改日期，首次使用GETDATE()        |
| DeletedDate  | datetime         | 记录删除（标记删除）日期                   |
| BTime        | datetime         | 开始时间                                   |
| ETime        | datetime         | 结束时间                                   |
| rowguid      | uniqueidentifier | 唯一标识行的ROWGUIDCOL号，用于支持合并复制 |
| ParentID     | int              | 父ID                                       |
| Odometer     | Decimal(11,3)    | 里程                                       |
| Lat          | Decimal(9,6)     | 纬度                                       |
| Lon          | Decimal(9,6)     | 经度                                       |
| GPSTime      | Datetime         | GPS时间                                    |
| ObjID        | CHAR(6)          | 车辆编号                                   |
| BLat         | Decimal(9,6)     | 开始纬度                                   |
| BLon         | Decimal(9,6)     | 开始经度                                   |
| ELat         | Decimal(9,6)     | 结束纬度                                   |
| ELon         | Decimal(9,6)     | 结束经度                                   |
|              |                  |                                            |

# 3. SQL编写

## 3.1. 大小写

大写T-SQL 语言的所有关键字，谓词和系统函数。变量名称及游标名称使用Pascal样式。数据类型定义使用全部大写。

示例：DECLARE @LastName NVARCHAR(32);

## 3.2. 使用“;”

使用“;”作为 Transact-SQL 语句终止符。虽然分号不是必需的，但使用它是一种好的习惯。

```sql
示例：
USE AdventureWorks;
GO
DECLARE @find VARCHAR(30);
SET @find = 'Man%';
SELECT LastName, FirstName, Phone
FROM Person.Contact
WHERE LastName LIKE @find;
```

## 3.3. 存储格式

尽量采用Unicode数据存储格式，提高可移植性和兼容性，实际应用中尽量使用nchar、nvarchar、ntext代替char、varchar、text。

 

## 3.4. 类型选择

如果字符具有明确的长度，使用nchar代替nvarchar；char代替varchar。

在SQL Server 2005中，使用nvarchar(MAX)代替ntext；varchar(MAX)代替text；varbinary(MAX)代替image。 

## 3.5. 默认值

在建立数据表时，尽量使用默认值代替NULL值。比如设置CreatedDate列默认值为GETDATE()。在可行的情况下设置字段为不允许空。

## 3.6. 字段长度

始终指定字符数据类型的长度，并确保允许用户可能需要的最大字符数，避免超出最大长度时出现字符丢失现象。对于字符型数据，建议采用2的n次方来定义数据长度。

```sql
示例：nvarchar(32) varchar(64)
```

## 3.7. 使用“'”

在 T-SQL 代码中为字符常量使用单引号。 

## 3.8. 语句缩进

一个嵌套代码块中的语句使用四个空格的缩进。使用Microsoft SQL Server Management Studio ,选择“工具”菜单，打开“选项”菜单，在选项对话框中选择文本编辑器->纯文本->制表符,选中“插入空格单选框”,设置“制表符大小”为4，缩进大小为“4”。

## 3.9. 语句换行

建议SQL代码每行以关键字或“，”开头。

```sql
-- 示例：
SELECT 
 [ShiftID]
 ,[Name]
 ,[StartTime]
 ,[EndTime]
 ,[ModifiedDate]
 FROM [HumanResources].[Shift]
```

## 3.10. 语句分割

使用一个（而不是两个）空行分隔 T-SQL 代码的逻辑块。

## 3.11. 使用“*”

避免在任何代码中使用 “SELECT *”，在使用EXISTS时除外。

## 3.12. 表名别名

表名别名要简短，但意义要尽量明确。通常使用大写的表名作为别名，使用 AS 关键字指定表或字段的别名。在多表关联查询某些字段时，查询的列必须使用表表名加字段名。比如表别名为A，应写A.ObjID等。

## 3.13. 类型转换

不要依赖任何隐式的数据类型转换，不要假定 T-SQL 会进行必要的转换。例如，把数字变量赋予字符值。相反，在为变量赋值或比较值之前，应使用适当的 CONVERT 函数使数据类型相匹配。在写Where条件时应注意变量的声明应与数据库的定义一致，防止因表中的数据列发生隐式转换，而造成索引统计信息失效。

## 3.14. 数值比较

不要将空的变量值直接与比较运算符（符号）比较。如果变量可能为空，应使用 IS NULL 或 IS NOT NULL 进行比较，或者使用 ISNULL 函数。

## 3.15. 排序

决不要依赖 SELECT 语句会按任何特定顺序返回行，除非在 ORDER BY 子句中指定了顺序。通常，应将 ORDER BY 子句与 SELECT 语句一起使用。可预知的顺序（即使不是最方便的）比不可预知的顺序强，尤其是在开发或调试过程中。在返回行的顺序无关紧要的情况下，可以忽略 ORDER BY ，减少资源开销。

## 3.16. Unicode字符串

在Unicode字符前面使用N前缀，避免引起数据的不一致。

```sql
示例：

-- Assumes the default code page is not Greek
CREATE TABLE #t1 (c1 nchar(1))
INSERT #t1 VALUES(N'Ω')
INSERT #t1 VALUES('Ω')
SELECT * FROM #t1
输出结果：
c1  
\---- 
Ω
O
```

## 3.17. BEGIN...END 块

在SQL代码快中尽量使用BEGIN...END 语句块，提高代码可阅读性。

 

## 3.18. TRY块

在SQL Server 2005中对一些可能执行失败的语句尽量使用TRY块。Transact-SQL 语句组可以包含在 TRY 块中，如果 TRY 块内部发生错误，则会将控制传递给 CATCH 块中包含的另一个语句组。在CATCH块中，除进行必要的错误处理外，需要将错误信息写入统一的表中，方便处理。目前我们用[dbo].[uspLogError]处理。

```sql
示例：
BEGIN TRY
   SQL 语句组1
END TRY
BEGIN CATCH
SQL 语句组2
EXEC [dbo].[uspLogError];
END CATCH;
```

## 3.19. TOP子句

在SQL Server 2005中加强了TOP的使用，尽量使用TOP(变量)来减少SQL拼串现象。除基本的应用外，TOP中可以使用表达式、子查询、百分比等返回数据。

```sql
表达式
select top (datepart(mm,getdate()))  ContactID,Phone from Person.Contact declare @top as smallint; set @top = 10 select top (@top)  ContactID,Phone from Person.Contac
子查询
SELECT TOP (SELECT COUNT(*) FROM Sales.SalesPerson)
SalesOrderID, RevisionNumber, OrderDate
FROM Sales.SalesOrderHeader
ORDER BY SalesOrderID
```

## 3.20. TRANSACTION编写

只要在例程中使用多个数据库修改语句，包括在一个循环中多次执行一个语句，就应考虑声明显式事务。在SQL SERVER 2005 中，增加了TRY块可进行很好的应用。

```sql
BEGIN TRY
        BEGIN TRANSACTION;
 
        UPDATE [HumanResources].[Employee] 
        SET [Title] = @Title 
            ,[HireDate] = @HireDate 
            ,[CurrentFlag] = @CurrentFlag 
        WHERE [EmployeeID] = @EmployeeID;
 
        INSERT INTO [HumanResources].[EmployeePayHistory] 
            ([EmployeeID]
            ,[RateChangeDate]
            ,[Rate]
            ,[PayFrequency]) 
        VALUES (@EmployeeID, @RateChangeDate, @Rate, @PayFrequency);
 
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN	
            ROLLBACK TRANSACTION;
        END
 
        EXECUTE [dbo].[uspLogError];
    END CATCH;
```

## 3.21. 存储过程

在编写存储过程时，使用PROCEDURE 代替 PROC 简写。

```sql
示例：CREATE PROCEDURE [dbo].[存储过程名字]
```

在存储过程开头加

SET NOCOUNT ON;

##  3.22. 架构名称

在查询或调用存储过程时，加架构名称。

```sql
SELECT [UserName] FROM [dbo]. [ErrorLog]
[dbo].[prInsErrorLog]
```

## 3.23. INSERT语句

在写INSERT语句时，表名后面需将列名带上。

```sql
-- 示例
INSERT INTO dbo.ai_Objcomm(ObjID,RegName) VALUES(…等)
```

## 3.24 表创建

表创建时，应充分考虑表中存储的数据，根据数据决定主键、唯一键及相关的Check约束。根据数据量及访问数据的方式，决定是否需要索引。对于主表、子表关系的表，如果主表主键为2个字段，可考虑增加自增键做主键。

# 4. 代码注释

## 4.1. 代码头部注释

在SQL代码块（sql文件或存储过程）的头部进行注释，标注创建人(Author)、创始日期(Create date)、修改信息(Modify [n])。

格式：

```sql
-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- Modify [n]:  < Modifier,Date, Description >
-- =============================================
示例：
-- ================================================
-- Author:     Manager
-- Create date:  2006-12-25
-- Description:  H2000报关单回执处理（功能模块名称+所执行的操作）
-- Modify [1]:  郑佐, 2006-12-31, 简化逻辑判断流程
-- Modify [2]:  郑佐, 2007-01-20, 更新条件判断
-- ================================================
注：日期格式使用 yyyy-MM-dd。Modify [n] n代表修改序号，从1开始，每次修改加1。
```

## 4.2. TRANSACTION注释

建议在每个事务的开头进行注释，说明该事务的功能。

```sql
-- < Modifier,Date, Description >
BEGIN TRANSACTION;
```

## 4.3 注释的有效性

对于无用的注释，应当删除。因语句修改造成的注释无效应立即更新。

```sql
例如：新建存储过程模板中，头上的注释应删掉。
-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
```

## 5. 附录A 命名规则

常见命名规则有四种样式：完全大写、完全小写、Pascal 大小写和 Camel 大小写。

5.1.Pascal 大小写

组成标识符的每个单词的首字母大写，其余字母小写的书写约定。对于缩写的双字母单词，要求全部大写。

```sql
例如：ApplicationException
   ID
```





 