## SpringBoot—JDBC

## 前言

>作者：知否派
>博客地址: [https://snailthink.github.io/myblogs](https://snailthink.github.io/myblogs)
>项目地址：[spring-boot-learning](https://gitee.com/VincentBlog/spring-boot-learning.git)
>文章所涉及的资料来自互联网整理和个人总结，意在于个人学习和经验汇总，如有什么地方侵权，请联系本人删除，谢谢！

`提示：以下是本篇文章正文内容，下面案例可供参考`

## 一、JDBC是什么？
概念：JDBC(Java DataBase Connectivity) ：Java数据库连接技术：具体讲就是通过Java连接广泛的数据库，并对表中数据执行增、删、改、查等操作的技术。如图所示：

作用：通过JDBC技术与数据库进行交互，使用Java语言发送SQL语句到数据库中，可以实现对数据的增、删、改、查等功能，可以更高效、安全的管理数据。

## 二、JDBC编码步骤

### 1.JDBC流程

```
1. 加载驱动
2. 获取链接
3. 准备SQL以及发送SQL的工具
4. 执行SQL
5. 处理结果集
6. 释放资源
```

![image-20220803151156091](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803151156091.png)





## 三、SpringBoot 继承JDBC

### 1.引入库

代码如下（示例）：

```xml
<!--springboot启动类-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<!--springboot 测试类-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>

<!--JDBC -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>
```

### 2.编写yaml配置文件连接数据库
代码如下（示例）：
```yml
spring:
  datasource:
    username: root
    password: 1q2w3e
    #?serverTimezone=UTC解决时区的报错
    url: jdbc:mysql://localhost:3306/snailthink?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8
    driver-class-name: com.mysql.cj.jdbc.Driver
```
### 3.测试数据源

```java
package com.whcoding.test;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * @program: spring-boot-learning
 * @description:
 * @author: whcoding
 * @create: 2022-08-03 14:53
 **/
public class JDBCTests extends TestApplicationTest {

	//DI注入数据源
	@Autowired
	DataSource dataSource;

	@Test
	public void contextLoads() throws SQLException {
		//看一下默认数据源
		System.out.println(dataSource.getClass());
		//获得连接
		Connection connection = dataSource.getConnection();
		System.out.println(connection);
		//关闭连接
		connection.close();
	}
}

```

**查看结果**

![image-20220803151500592](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803151500592.png)

根据上图的可知JDBC的默认数据源为`class com.zaxxer.hikari.HikariDataSource`

Sring Boot 1.5 则默认使用 `org.apache.tomcat.jdbc.pool.DataSource` 作为数据源；

### 4.JdbcTemplate

---

JdbcTemplate主要提供以下几类方法

**execute方法**：可以用于执行任何SQL语句，一般用于执行DDL语句；

**update方法：**及batchUpdate方法：update方法用于执行新增、修改、删除等语句；batchUpdate方法用于执行批处理相关语句

**query方法：**及queryForXXX方法：用于执行查询相关语句；

**call方法：**用于执行存储过程、函数相关语句。

1. JdbcTemplate 的自动配置是依赖 org.springframework.boot.autoconfigure.jdbc 包下的 JdbcTemplateConfiguration 类.

![image-20220803152741756](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803152741756.png)

**2.JdbcTemplate 封装了CRUD方法** 位置在org.springframework:spring-jdbc下

![image-20220803152542826](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803152542826.png)

### 5.测试

```java
package com.whcoding.test;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @program: spring-boot-learning
 * @description:
 * @author: whcoding
 * @create: 2022-08-03 14:53
 **/
public class JDBCTests extends TestApplicationTest {

	//DI注入数据源
	@Autowired
	DataSource dataSource;

	@Autowired
	JdbcTemplate jdbcTemplate;

	@Test
	public void contextLoads() throws SQLException {
		//看一下默认数据源
		System.out.println(dataSource.getClass());
		//获得连接
		Connection connection = dataSource.getConnection();
		System.out.println(connection);
		//关闭连接
		connection.close();
	}


	@Test
	public void jdbcTemplateTest() {
		//1. 查询数据
		String querySql = "SELECT id, customer_name customerName, customer_no, customer_id, customer_address , customer_type, customer_fund, order_date, order_no, order_id FROM orm_customer LIMIT 10;";
		List<Map<String, Object>> mapList = jdbcTemplate.queryForList(querySql);
		System.out.println(mapList);
		//2. 插入数据
		String insertSql = "INSERT INTO `snailthink`.`orm_customer`(`customer_name`, `customer_no`, `customer_id`, `customer_address`, `customer_type`, `customer_fund`, `order_date`, `order_no`, `order_id`, `create_time`, `update_time`, `create_user`, `update_user`, `is_valid`) VALUES ('太仓DC', 'A673', 101, '杭州市滨江区钱江大厦', 1, 0.00000, '2020-11-16 00:00:00', 'SO101', 101, '2021-03-05 18:56:56', '2021-03-05 18:56:56', 0, 0, 1);";
		jdbcTemplate.update(insertSql);
		//3. 更新数据
		String updateSql = "UPDATE orm_customer SET customer_no=?,update_time=? WHERE id=1";
		Object[] objects = new Object[2];
		objects[0] = "test2";
		objects[1] = new Date();
		jdbcTemplate.update(updateSql, objects);
		//4. 删除数据
		Integer deleteId = 100;
		String deleteSql = "delete from `orm_customer` where id=?";
		jdbcTemplate.update(deleteSql, deleteId);
	}
}
```

## 参考

[SpringBoot整合JDBC](https://blog.csdn.net/weixin_44449838/article/details/108660419?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-1-108660419-blog-122162662.pc_relevant_show_downloadRating&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-1-108660419-blog-122162662.pc_relevant_show_downloadRating&utm_relevant_index=1)

## 总结

提示：这里对文章进行总结：
例如：以上就是今天要讲的内容，本文仅仅简单介绍了pandas的使用，而pandas提供了大量能使我们快速便捷地处理数据的函数和方法。
