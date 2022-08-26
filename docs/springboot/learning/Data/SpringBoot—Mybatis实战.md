## SpringBoot—Mybatis

> 作者：知否派
> 博客地址: [https://snailthink.github.io/myblogs](https://snailthink.github.io/myblogs)
> 项目地址：[spring-boot-learning](https://gitee.com/VincentBlog/spring-boot-learning.git)
> 文章所涉及的资料来自互联网整理和个人总结，意在于个人学习和经验汇总，如有什么地方侵权，请联系本人删除，谢谢！

## 一、什么是 MyBatis ？

 MyBatis 是一款优秀的持久层框架，它支持自定义 SQL、存储过程以及高级映射。MyBatis 免除了几乎所有的 JDBC 代码以及设置参数和获取结果集的工作。MyBatis 可以通过简单的 XML 或注解来配置和映射原始类型、接口和 Java POJO（Plain Old Java Objects，普通老式 Java 对象）为数据库中的记录。 

**官网地址** **https://mybatis.org/mybatis-3/zh/getting-started.html ** 

## 二、 MyBatis如何安装？

 如果使用 Maven 来构建项目，则需将下面的 dependency 代码置于 pom.xml 文件中 

```xml
       <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.5.2</version>
        </dependency>
```

 如果使用 spring-boot 来构建项目，则需将下面的 dependency 代码置于 pom.xml 文件中 

```xml
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>2.1.2</version>
        </dependency>
```

## 三、MyBatis的优缺点

**特点：**

- mybatis是一种持久层框架，也属于ORM映射。前身是ibatis。
- 相比于hibernatehibernate为全自动化，配置文件书写之后不需要书写sql语句，但是欠缺灵活，很多时候需要优化；
- mybatis为半自动化，需要自己书写sql语句，需要自己定义映射。增加了程序员的一些操作，但是带来了设计上的灵活，并且也是支持hibernate的一些特性，如延迟加载，缓存和映射等；对数据库的兼容性比hibernate差。移植性不好，但是可编写灵活和高性能的sql语句。

**优点：**

- 简单易学：本身就很小且简单。没有任何第三方依赖，最简单安装只要两个jar文件+配置几个sql映射文件易于学习，易于使用，通过文档和源代码，可以比较完全的掌握它的设计思路和实现。
- 灵活：mybatis不会对应用程序或者数据库的现有设计强加任何影响。 sql写在xml里，便于统一管理和优化。通过sql基本上可以实现我们不使用数据访问框架可以实现的所有功能，或许更多。
- 解除sql与程序代码的耦合：通过提供DAL层，将业务逻辑和数据访问逻辑分离，使系统的设计更清晰，更易维护，更易单元测试。sql和代码的分离，提高了可维护性。
- 提供映射标签，支持对象与数据库的orm字段关系映射
- 提供对象关系映射标签，支持对象关系组建维护
- 提供xml标签，支持编写动态sql。



**缺点：**

- 编写SQL语句时工作量很大，尤其是字段多、关联表多时，更是如此。
- SQL语句依赖于数据库，导致数据库移植性差，不能更换数据库。
- 框架还是比较简陋，功能尚有缺失，虽然简化了数据绑定代码，但是整个底层数据库查询实际还是要自己写的，工作量也比较大，而且不太容易适应快速数据库修改。
- 二级缓存机制不佳
- JDBC方式可以用用打断点的方式调试，但是Mybatis不能，需要通过log4j日志输出日志信息帮助调试，然后在配置文件中修改。 
- 对SQL语句依赖程度很高；并且属于半自动，数据库移植比较麻烦，比如mysql数据库编程Oracle数据库，部分的sql语句需要调整。 



## 四、Mybatis配置

### 1.@MapperScan扫描的方式

**@Mapper@@Repository@@MapperScan含义**

1.@Mapper 是Mybatis 需要找到对应的mapper，编译的时候动态生成代理类，所以需要在mapper层的接口类上加@Mapper实现数据库查询功能。

2.@Repository是用于声明 mapper层的bean，只是为了声明这个类，@Repository 可有可无，加上以后可以消去service引入mapper层的依赖注入的报错信息。

3.@MapperScan等于@Mapper作用和@Mapper一样实现数据库查询功能。

4.无论是使用@Mapper和@MapperScan ，加不加@Repository都无影响，@Repository都可以加上，作用是消除报错依赖。

5.总结
	1.每个Mapper接口类上加@Mapper
	2.在主类启动类上加@MapperScan("com.xxx.xxx.mapper")
	3.@Repository都可以加上作用是消除报错信息

**如下所示**

**方式一：使用注解@Mapper**

```java
/**
 * 配置Mapper 在每个Mapper层都加上
 * Mapper注解表示这是Mybatis的mapper类
 */
@Mapper
public class UserMapper {
}
```

**方式二：使用注解@MapperScan**

```java
@SpringBootApplication
@MapperScan("com.example.snailthinkmybatis.dao.mapper")
public class SnailthinkMybatisApplication {
    public static void main(String[] args) {
        SpringApplication.run(SnailthinkMybatisApplication.class, args);
    }
}
```

**@MapperScan支持扫描多个包**

```java
@MapperScan({"com.example.snailthinkmybatis.dao.mapper","com.example.snailthinkmybatis.dao.mapper2"})
@SpringBootApplication
public class SnailthinkMybatisApplication {
	public static void main(String[] args) {
		SpringApplication.run(SpringBootApplication.class, args);
	}
}
```

**@MapperScan 支持表达式，扫描包和其子包中的类**

```java
@MapperScan({"com.example.*.mapper","com.example.*.mapper2"}) 
@SpringBootApplication
public class SnailthinkMybatisApplication {
	public static void main(String[] args) {
		SpringApplication.run(SpringBootApplication.class, args);
	}
}
```

**总结**

`@Mapper` 是对单个接口类的注解。单个操作。

`@MapperScan` 是对整个包下的所有的接口类的注解。是批量的操作。使用 `@MapperScan` 后，接口类 就不需要使用 `@Mapper` 注解。

### **2.Mybatis是如何将sql执行结果封装为目标对象并返回的** 

第一种是使用<resultMap>标签，逐一定义数据库列名和对象属性名之间的映射关系。

第二种是使用sql列的别名功能，将列的别名书写为对象属性名。 

### **3.Mapper中如何传递多个参数**

方法一：DAO层的函数

```xml
//DAO层的函数
Public UserselectUser(String name,String area);  
//对应的xml,#{0}代表接收的是dao层中的第一个参数，#{1}代表dao层中第二参数，更多参数一致往后加即可。
<select id="selectUser"resultMap="BaseResultMap">   select *  fromuser_user_t   whereuser_name = #{0} anduser_area=#{1}  
</select>  
```

方法二：使用 @param 注解: 

```xml
public interface usermapper {
   user selectuser(@param(“username”) string username,@param(“hashedpassword”) string hashedpassword);
}
然后,就可以在xml像下面这样使用(推荐封装为一个map,作为单个参数传递给mapper):
<select id=”selectuser” resulttype=”user”>
         select id, username, hashedpassword
         from some_table
         where username = #{username}
         and hashedpassword = #{hashedpassword}
</select>
```

方法三：参数封装为map

```java
//映射文件的命名空间.SQL片段的ID，就可以调用对应的映射文件中的SQL
//由于我们的参数超过了两个，而方法中只有一个Object参数收集，因此我们使用Map集合来装载我们的参数
Map<String, Object> map = new HashMap();
     map.put("start", start);
     map.put("end", end);
     return sqlSession.selectList("StudentID.pagination", map);
```

### 4.@Repository和@Component,@Repository区别

 * @Mapper:表示本类是一个 MyBatis 的 Mapper
 * @Repository:不仅能将类识别为Bean，同时它还能将所标注的类中抛出的数据访问异常封装为 Spring 的数据访问异常类型

`@Component`是通用性的注解，`@Service` 和`@Repository`则是在`@Component`的基础上添加了特定的功能

所以`@Component`可以替换为`@Service`和`@Repository`，但是为了规范，服务层bean用`@Service`，dao层用`@Repository`

`@Repository`的工作是捕获特定于平台的异常，并将它们作为Spring统一未检查异常的一部分重新抛出。为此，提供了`PersistenceExceptionTranslationPostProcessor`。

如果在dao层使用`@service`，就不能达到这样的目的。

### 5.**mapper-locations**

**mapper-locations** 是用来配置**.xml**位置

在yml文件中配置，作用是实现mapper接口和mapper文件的绑定

```yml
# mybatis 配置
mybatis:
  type-aliases-package: com.whcoding.mybatis.pojo
  #config-location: classpath:mybatis/mybatis-config.xml #Mybatis 的核心配置
  mapper-locations: classpath:mybatis/mapper/*.xml
  configuration:
    map-underscore-to-camel-case: true #配置驼峰大小写转换
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl #打印sql真实的参数以及结果
    #cache-enabled: true # 开启二级缓存
```

1.**配置多个.xml文件 ,xml文件路径在resources包下时，可根据路径配置如下**

```properties
#方法一：只有一个路径
mybatis.mapper-locations= classpath:mapper/*.xml
#方法二：有多个路径
mybatis.mapper-locations= classpath:mapper/*.xml,classpath:mapper/user*.xml
#方法三：通配符 ** 表示任意级的目录
mybatis.mapper-locations= classpath:**/*.xml
```

**2. \*.xml文件路径在\**java包\**下时，不可使用mybatis.mapper-locations配置，可根据路径配置如下**

在pom.xml的<build>标签中添加如下

```xml
    <build>
        <resources>
            <resource>
                <directory>src/main/java</directory>
                <includes>
                    <include>**/*.xml</include>
                </includes>
            </resource>
            <resource>
                <directory>src/main/resources</directory>
            </resource>
        </resources>
    </build>
```

### 6.打印日志

```yml
#方法一：用mybatis日志输出类输出
mybatis:
  type-aliases-package: com.whcoding.mybatis.pojo
  #config-location: classpath:mybatis/mybatis-config.xml #Mybatis 的核心配置
  mapper-locations: classpath:mybatis/mapper/*.xml
  configuration:
    map-underscore-to-camel-case: true #配置驼峰大小写转换
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl #打印sql真实的参数以及结果
    #cache-enabled: true # 开启二级缓存

# 方法二：通过配置xml映射文件所在包输出
logging:
  level:
    com.whcoding.mybatis.dao : debug
    
```

**方式三:**

[Mybatis日志打印官网](https://mybatis.org/mybatis-3/zh/logging.html)

在logback-spring.xml中配置logger，具体包名替换就可以指定到具体的Mapper上

```xml
<logger name="com.**.**.dao.mapper">
  <level value="trace"/>
</logger>
```

添加以上配置后，SLF4J(Logback) 就会记录 com...dao.OrmDeptMapper的详细执行操作，且仅记录应用中其它类的错误信息（若有）。

你也可以将日志的记录方式从接口级别切换到语句级别，从而实现更细粒度的控制。如下配置只对 selectDept语句记录日志：

```xml
    <!--哪个文件需要打印日志-->
<logger name="com.**.**.dao.mapper.OrmDeptMapper.selectDept">
    <!--日志等级-->
   <level value="trace"/>
</logger>
```



### 7.classpath和classpath*区别

***classpath**:*只会在你的**class路径下寻找**
***classpath\****:**不仅包含class路径，还包括jar文件中(class路径)进行查找**

## 五、SpringBoot如何集成Mybatis

在集成`SpringBoot`项目中可以按照以下流程进行操作总体的思路都是一样的。如果是第一次使用不知道如何搭建项目可以参考[SpringBoot 项目搭建的三种方式](SpringBoot 三种搭建方式)

- 导入依赖
- 修改application.yml配置文件
- 增加启动类 
- 增加实体类
- 增加Mapper接口以及**Mapper映射文件**
- 增加Service
- 增加ServiceImpl
- 增加Controller
- 运行项目

### 2.1 引入依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>spring-boot-learning</artifactId>
        <groupId>com.whcoding</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>demo-mybatis</artifactId>

    <dependencies>
        <!--SpringBootWeb项目-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <!--测试类-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <!--Mybatis-->
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
        </dependency>
        <!--MySQL连接-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        <!--lombok POVO-->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <!--hutool 工具类-->
        <dependency>
            <groupId>cn.hutool</groupId>
            <artifactId>hutool-all</artifactId>
        </dependency>
        <!--guava 工具类-->
        <dependency>
            <groupId>com.google.guava</groupId>
            <artifactId>guava</artifactId>
        </dependency>
    </dependencies>

    <build>
        <finalName>demo-mybatis</finalName>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>

```

### 2.2 application.yml 

```yml
server:
  port: 9150

# mybatis 配置
mybatis:
  type-aliases-package: com.whcoding.mybatis.pojo
  #config-location: classpath:mybatis/mybatis-config.xml #Mybatis 的核心配置
  mapper-locations: classpath:mybatis/mapper/*.xml
  configuration:
    map-underscore-to-camel-case: true #配置驼峰大小写转换
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl #打印sql真实的参数以及结果
    #cache-enabled: true # 开启二级缓存

#Spring 配置
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/snailthink?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&rewriteBatchedStatements=true # rewriteBatchedStatements
    username: root
    password: 1q2w3e
    driver-class-name: com.mysql.cj.jdbc.Driver
    type: com.zaxxer.hikari.HikariDataSource
  application:
    name: demo-mybatis


logging:
  level:
    com.whcoding.mybatis.dao : debug

```

### 2.3 增加启动类

```java
package com.whcoding.mybatis;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
//在这里加上@MapperScan 或者是在Mapper层的每个类上都加@Mapper
//@MapperScan(basePackages = {"com.whcoding.mybatis.dao"}) 
@SpringBootApplication
public class MybatisApplication {
    public static void main(String[] args) {
        SpringApplication.run(MybatisApplication.class, args);
    }
}
```

### 2.4 增加实体类

```java
package com.whcoding.mybatis.pojo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Accessors(chain=true) //链式写法
/**
 * 部门
 *  @author Manager
 */
public class OrmDeptVO implements Serializable {
    private Long id;
    private Integer deptId;
    private String deptNo;
    private String deptName;
	private Integer deptType;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createTime;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date updateTime;
    private BigDecimal deptPerf;
    private Integer isValidFlag;
    private String shortName;
    private String remark;
	private List<String> deptNoList;
}

```

### 2.5 增加Mapper接口/映射文件

**1.编写Mapper接口**

```java
package com.whcoding.mybatis.dao;

import com.whcoding.mybatis.pojo.OrmDeptVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * @author Manager
 * @Mapper:表示本类是一个 MyBatis 的 Mapper
 * @Repository:不仅能将类识别为Bean，同时它还能将所标注的类中抛出的数据访问异常封装为 Spring 的数据访问异常类型
 */
@Mapper
@Repository
public interface DeptDao {
	/**
	 * 根据ID 查询数据
	 * @param id
	 * @return
	 */
	OrmDeptVO queryDeptById(@Param("id") Long id);

	/**
	 * 查询全部数据
	 * @return
	 */
	List<OrmDeptVO> queryAllDept();
}

```

**2.编写Mapper映射文件**

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.whcoding.mybatis.dao.DeptDao">

    <!-- 这个cache 是关键 -->
    <!--可以通过设置useCache来规定这个sql是否开启缓存，ture是开启，false是关闭,刷新缓存：flushCache="true"  useCache="true"-->
    <cache eviction="LRU" flushInterval="100000" readOnly="true" size="1024"/>

    <resultMap id="ormDeptMap" type="com.whcoding.mybatis.pojo.OrmDeptVO">
        <id property="id" jdbcType="INTEGER" column="id"/>
        <result property="deptId" jdbcType="INTEGER" column="dept_id"/>
        <result property="deptNo" jdbcType="VARCHAR" column="dept_no"/>
        <result property="deptType" jdbcType="INTEGER" column="dept_type"/>
        <result property="deptName" jdbcType="VARCHAR" column="dept_name"/>
        <result property="createTime" jdbcType="DATETIME" column="create_time"/>
        <result property="updateTime" jdbcType="DATETIME" column="update_time"/>
        <result property="deptPerf" jdbcType="DECIMAL" column="dept_perf"/>
        <result property="isValidFlag" jdbcType="INTEGER" column="is_valid_flag"/>
        <result property="shortName" jdbcType="VARCHAR" column="short_name"/>
        <result property="remark" jdbcType="VARCHAR" column="remark"/>
    </resultMap>
    
    <sql id="dept_base_column">
         id id
        ,dept_id deptId
        ,dept_no deptNo
        ,dept_name deptName
        ,create_time createTime
        ,update_time updateTime
        ,dept_perf deptPerf
        ,is_valid_flag isValidFlag
        ,short_name shortName
        remark
    </sql>

    <select id="queryDeptById" resultType="com.whcoding.mybatis.pojo.OrmDeptVO" parameterType="long">
      SELECT
        <include refid="dept_base_column"/>
       FROM orm_dept WHERE id=#{id} ;
    </select>

    <select id="queryAllDept" resultMap="ormDeptMap">
        SELECT
        <include refid="dept_base_column"/>
        FROM orm_dept
    </select>
</mapper>
```

### 2.6 Service

```java
package com.whcoding.mybatis.service;

import com.whcoding.mybatis.pojo.OrmDeptVO;

import java.util.List;

/**
 * @author Manager
 */
public interface DeptService {

	/**
	 * 根据主键查询数据
	 *
	 * @param id
	 * @return
	 */
	OrmDeptVO queryDeptById(Long id);

	/**
	 * 查询全部数据
	 *
	 * @return
	 */
	List<OrmDeptVO> queryAllDept();
}


```

### 2.7 增加ServiceImpl

```java
@Service
public class DeptServiceImpl implements DeptService {

	private static final Logger log = LoggerFactory.getLogger(DeptServiceImpl.class);

	@Autowired
	private DeptDao dao;

	/**
	 * 查询数据-ID
	 *
	 * @param id
	 * @return
	 */
	@Override
	public OrmDeptVO queryDeptById(Long id) {
		return dao.queryDeptById(id);
	}
     
	/**
	 * 查询全部数据
	 *
	 * @return
	 */
	@Override
	public List<OrmDeptVO> queryAllDept() {
		return dao.queryAllDept();
	}
}
```

### 2.8 增加Controller

```java
/**
 * @author Sanilthink
 *
 */
@RestController
@RequestMapping("/dept/")
public class DeptController {
    
    @Autowired
    private DeptService deptService;
    
    /**
     *
     * @param id
     * @return
     */
    @GetMapping("queryDeptById")
    public OrmDeptVO queryDeptById(@RequestParam("id")  Long id) {
        return deptService.queryDeptById(id);
    }

	/**
	 * 查询全部数据
	 * @return
	 */
    @GetMapping("queryAllDept")
    public List<OrmDeptVO> queryAllDept() {
        return deptService.queryAllDept();
    }
    
}
```

### 2.9 请求测试

**http://localhost:9150/dept/queryDeptById/id=1**

## 六、Mybatis动态sql

- trim
- if
- foreach
- choose、when、otherwise
- insert ignore
- insert into …on duplicate key update
- include
- 

### 1.trim

- 属性
  1.常用
  prefix：在条件语句前需要加入的内容。
  suffix：在条件语句后需要加入的内容
- 2.不常用
  prefixOverrides：覆盖/去掉前一个前缀
  suffixOverrides：覆盖/去掉后一个前缀

```xml
 <!-- trim 的用法剔除多余的条件-->
 <trim prefix="WHERE" prefixOverrides="AND|OR">
     <if test="bTime != null and eTime != null">
         and create_time>'2019-12-01'
     </if>
 </trim>
```

### 2.foreach

foreach元素的属性主要有item，index，collection，open，separator，close。

- item：集合中元素迭代时的别名，
- index：集合中元素迭代时的索引
- open：常用语where语句中，表示以什么开始，比如以'('开始
- separator：表示在每次进行迭代时的分隔符，
- close 常用语where语句中，表示以什么结束，

```xml
<!--foreash使用 -->
 <if test="deptNoList!=null  and deptNoList.size() > 0 ">
     AND dept_no IN
     <foreach collection="list" item="item" index="index" separator="," open="(" close=")">
         #{item}
     </foreach>
 </if>
```



### 3.choose、when、otherwise

choose、when、otherwise 等价于数据中的Case When Else End

```xml
<choose>
     <when test="deptType !=null AND deptType==1">
         dept_type &lt;=#{deptType};
     </when>
     <when test="deptType !=null AND deptType==2">
         dept_type >#{deptType};
     </when>
     <otherwise>
         dept_type ={deptType};
     </otherwise>
 </choose>
```



### 4.insert ignore

当插入数据时，出现错误，或重复数据，将不返回错误，只以警告形式返回。如果数据库没有数据，就插入新的数据，如果有数据的话就跳过这条数据。 

```XML
<insert id="insertDept3" parameterType="java.util.List">
    INSERT IGNORE INTO orm_dept
    (dept_no ,
    dept_name
    )
    VALUES
    <foreach collection="list" item="item" index="index" separator=",">
        (
        #{dept. deptName},
        #{dept. deptNo}
        )
    </foreach>
</insert>
```

### 5.insert into …on duplicate key update

当primary或者unique重复时，则执行update语句,否则新增。

tips：ON DUPLICATE KEY UPDATE后放置需要更新的数据，未放到此处的列不会被更新

```xml
<!--主键存在则更新，反之则新增-->
<insert id="insertOrUpdateBatch">
    insert into `snailthink`.`orm_dept` (`dept_id`, `dept_no`,`dept_type`, `dept_name`, `update_time`, `dept_perf`,
    `is_valid_flag`, `short_name`, `remark` )
    values
    <foreach collection="deptVOS" item="dept" separator=",">
        (#{dept.deptId}, #{dept.deptNo},#{dept.deptType},#{dept.deptName},now(), #{dept.deptPerf},#{dept.isValidFlag},
        #{dept.shortName},#{dept.remark})
    </foreach>
    ON DUPLICATE KEY UPDATE
    remark = values(remark),
    dept_no = values(dept_no),
    dept_name = values(dept_name)
</insert>
```

### 6.include

```xml
<sql id="dept_base_column">
     id id
    ,dept_id deptId
    ,dept_no deptNo
    ,dept_name deptName
    ,create_time createTime
    ,update_time updateTime
    ,dept_perf deptPerf
    ,is_valid_flag isValidFlag
    ,short_name shortName
    remark
</sql>

<select id="queryDeptById" resultType="com.whcoding.mybatis.pojo.OrmDeptVO" parameterType="long">
  SELECT
    <include refid="dept_base_column"/>
   FROM orm_dept WHERE id=#{id} ;
</select>
```



### 7.insert … select … where not exist

根据select的条件判断是否插入

```sql
    <insert id="insertDept2">
        INSERT INTO orm_dept (dept_no,dept_name)
        SELECT
             dept_no
            ,dept_name
        FROM
            orm_dept
        WHERE
        NOT EXISTS (SELECT id FROM books WHERE id = 1)
    </insert>
```



### 8.Mybatis添加数据后返回主键

```xml
    <!--add keyProperty 主键 ，useGeneratedKeys 允许自动生成主键-->
    <insert id="addDept" parameterType="com.whcoding.mybatis.pojo.OrmDeptVO" keyProperty="id" useGeneratedKeys="true">
       INSERT INTO `snailthink`.`orm_dept` (`dept_id`, `dept_no`, `dept_type`, `dept_name`, `update_time`, `dept_perf`, `is_valid_flag`, `short_name`, `remark` )
       VALUES ( #{deptId}, #{deptNo}, #{deptType},#{deptName},now(), #{deptPerf},#{isValidFlag}, #{shortName},#{remark} );
    </insert>
```

useGeneratedKeys="true" ：设置是否使用JDBC的getGenereatedKeys方法获取主键并赋值到keyProperty设置的领域模型属性中。（适用于mysql、sqlserver数据库，oracle不能使用，使用selectkey子节点做）。

keyProperty：赋值的对象的属性名称。



### 9.常用转义符

- Mybatis 中的大于小于不能直接写 >= 或者 <=  ,可以加上`<![CDATA[ ]]>`

```XML
<![CDATA[ and create_time <= #{endDate}]]>
```

|         |      |        |
| ------- | ---- | ------ |
| &lt；   | <    | 小于   |
| &gt；   | >    | 大于   |
| &amp；  | &    | 与     |
| &apos； | ’    | 单引号 |
| &quot； | "    | 双引号 |

- 注意
  <![CDATA[ ]]>标记的sql语句中的<where> <if>等标签不会被解析.

## 七、其他

### 1.Mybatis的一级、二级缓存

1）一级缓存: 基于 PerpetualCache 的 HashMap 本地缓存，其存储作用域为 Session，当 Session flush 或 close 之后，该 Session 中的所有 Cache 就将清空，默认打开一级缓存。

2）二级缓存与一级缓存其机制相同，默认也是采用 PerpetualCache，HashMap 存储，不同在于其存储作用域为 Mapper(Namespace)，并且可自定义存储源，如 Ehcache。默认不打开二级缓存，要开启二级缓存，使用二级缓存属性类需要实现Serializable序列化接口(可用来保存对象的状态),可在它的映射文件中配置<cache/> ；

3）对于缓存数据更新机制，当某一个作用域(一级缓存 Session/二级缓存Namespaces)的进行了C/U/D 操作后，默认该作用域下所有 select 中的缓存将被 clear。

### 2.简述Mybatis的插件运行原理，以及如何编写一个插件

答：Mybatis仅可以编写针对ParameterHandler、ResultSetHandler、StatementHandler、Executor这4种接口的插件，Mybatis使用JDK的动态代理，为需要拦截的接口生成代理对象以实现接口方法拦截功能，每当执行这4种接口对象的方法时，就会进入拦截方法，具体就是InvocationHandler的invoke()方法，当然，只会拦截那些你指定需要拦截的方法。

编写插件：实现Mybatis的Interceptor接口并复写intercept()方法，然后在给插件编写注解，指定要拦截哪一个接口的哪些方法即可，记住，别忘了在配置文件中配置你编写的插件。

参考文章:[MyBatis 常见面试题总结]( https://zhuanlan.zhihu.com/p/73626454 )

### 3.实体类中的属性名和表中的字段名不一致

**第1种： 通过在查询的sql语句中定义字段名的别名，让字段名的别名和实体类的属性名一致。**

**第2种：通过<resultMap>来映射字段名和实体类属性名的一一对应的关系。 **

### 4.Mybatis的Xml映射文件中，不同的Xml映射文件，id是否可以重复？

答：不同的Xml映射文件，如果配置了namespace，那么id可以重复；如果没有配置namespace，那么id不能重复；毕竟namespace不是必须的，只是最佳实践而已。

原因就是namespace+id是作为Map<String, MappedStatement>的key使用的，如果没有namespace，就剩下id，那么，id重复会导致数据互相覆盖。有了namespace，自然id就可以重复，namespace不同，namespace+id自然也就不同。
