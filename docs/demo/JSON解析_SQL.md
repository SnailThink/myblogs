## SQLSERVER JSON解析

### 1.解析字符串函数

```sql
CREATE FUNCTION [dbo].[fn_split](@p_str VARCHAR(8000), @p_split VARCHAR(10))
RETURNS @tab TABLE(tid VARCHAR(2000))
AS
BEGIN
DECLARE @idx INT
DECLARE @len INT
SELECT @len = LEN(@p_split), @idx = CHARINDEX(@p_split, @p_str, 1)
WHILE(@idx >= 1)
BEGIN
INSERT INTO @tab SELECT LEFT(@p_str, @idx - 1)
SELECT @p_str = RIGHT(@p_str, LEN(@p_str) - @idx - @len + 1), @idx = CHARINDEX(@p_split, @p_str, 1)
END
if(@p_str <> '') INSERT INTO @tab SELECT @p_str
RETURN
END;
```

### 2.解析JSON字符串

```sql
CREATE FUNCTION [dbo].[fn_parsejson]
(@p_jsonstr VARCHAR(8000),@p_key VARCHAR(200)) 
RETURNS VARCHAR(3000)
AS      
BEGIN
DECLARE @rtnVal VARCHAR(3000);
  DECLARE @i INT;
  DECLARE @jsonkey VARCHAR(200);
  DECLARE @jsonvalue VARCHAR(1000);
  DECLARE @json VARCHAR(8000);
  DECLARE @tmprow VARCHAR(2000);
  DECLARE @tmpval VARCHAR(2000);
  
  IF(@p_jsonstr IS NOT NULL)
BEGIN
     SET @json = REPLACE(@p_jsonstr, '{', '');
     SET @json = REPLACE(@json, '}', '');
     SET @json = REPLACE(@json, '"', '');
DECLARE @json_cur CURSOR;  -- 声明外层游标
SET @json_cur = CURSOR FOR SELECT tid FROM fn_split(@json, ',');
OPEN @json_cur-- 打开游标（外层游标）
FETCH NEXT FROM @json_cur INTO @tmprow-- 提取外层游标行
WHILE(@@FETCH_STATUS = 0)
BEGIN
IF(@tmprow IS NOT NULL)
BEGIN
SET @i = 0;
SET @jsonkey = '';
SET @jsonvalue = '';

DECLARE @str_cur CURSOR;-- 声明内层游标
SET @str_cur = CURSOR FOR SELECT tid FROM fn_split(@tmprow, ':');--第二次拆分后的游标（内层游标）
OPEN @str_cur  -- 打开游标
FETCH NEXT FROM @str_cur INTO @tmpval-- 提取内层游标行

WHILE(@@FETCH_STATUS = 0)
BEGIN
IF(@i = 0) 
BEGIN
SET @jsonkey = @tmpval
END
IF(@i = 1)
BEGIN
SET @jsonvalue = @tmpval
END

SET @i = @i + 1

FETCH NEXT FROM @str_cur into @tmpval-- 内层游标下移一行
END

CLOSE @str_cur-- 关闭内层游标
DEALLOCATE @str_cur -- 释放内层游标

IF(@jsonkey = @p_key)
BEGIN
SET @rtnVal = @jsonvalue
END
END

FETCH NEXT FROM @json_cur INTO @tmprow-- 内层游标结束后，外层游标下移一行
END

CLOSE @json_cur-- 关闭外层游标
DEALLOCATE @json_cur-- 释放外层游标
END 
  RETURN @rtnVal  
END
```

### 3.函数调用

```sql
DECLARE @HandleResultStr NVARCHAR(128);
SET @HandleResultStr='{"response":{"content":{"code":500,"message":"数据不存在！","success":false}, "code":0}}'
SELECT [dbo].[fn_parsejson](@HandleResultStr,'message')
```

![image-20220520170000318](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220520170002.png)