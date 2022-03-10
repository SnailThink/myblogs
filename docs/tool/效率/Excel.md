## 1.Excel生成SQL语句



### 背景

由于客户提供一部分数据需要导入系统做初始化，由于数据量比较大，并且既有Insert，也有Update语句，故想到用EXCEL生成SQL语句。



![image-20220228154005823](https://gitee.com/VincentBlog/image/raw/master/image/20220228154005.png)



#### 生成Insert SQL



```sql
=CONCATENATE("INSERT INTO TABLENAME(UserId,UserName,UserPwd,CreateTime)VALUES('"&A2&"','"&B2&"','"&C2&"')")
```



#### 生成UPDATE SQL

```sql
="UPDATE 表名 SET 字段名 ='"&A1&"',字段名= '"&B1&"'  WHERE  字段名='"&C1&"'; "
```



## 2.Excel常用函数 



### 2.1 CONCATENATE

- 拼接字符串

在更新SQL语句中，我们想要的格式是 `'我是字符串;'`是带有单引号的，以及分号的，也可以使用EXCEL的 `CONCATENATE` 方法操作

```sql
=CONCATENATE("'",A1,"';,")
=CONCATENATE("#{item.",B1,"},")
```

![image-20220228154441775](https://gitee.com/VincentBlog/image/raw/master/image/20220228154441.png)



### 2.2 LEFT剔除最后一位

`=LEFT(A1,LEN(A1)-1)`  剔除最后一位

`=IF(RIGHT(A1,1)="$",LEFT(A1,LEN(A1)-1),A1)` 剔除最后一位是$的数据

