

## mybatis实战

### 1.什么是 MyBatis ？

 MyBatis 是一款优秀的持久层框架，它支持自定义 SQL、存储过程以及高级映射。MyBatis 免除了几乎所有的 JDBC 代码以及设置参数和获取结果集的工作。MyBatis 可以通过简单的 XML 或注解来配置和映射原始类型、接口和 Java POJO（Plain Old Java Objects，普通老式 Java 对象）为数据库中的记录。 

**官网地址** **https://mybatis.org/mybatis-3/zh/getting-started.html ** 

### 2. MyBatis如何安装？

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

### 3.MyBatis的优缺点

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
-  JDBC方式可以用用打断点的方式调试，但是Mybatis不能，需要通过log4j日志输出日志信息帮助调试，然后在配置文件中修改。 
-  对SQL语句依赖程度很高；并且属于半自动，数据库移植比较麻烦，比如mysql数据库编程Oracle数据库，部分的sql语句需要调整。 

### 4.Mybatis 开启控制台打印sql语句

#### 4.1 方法一

 **1.在mybatis的配置文件中添加：** 

```xml
<settings>
    <!-- 打印sql日志 -->
    <setting name="logImpl" value="STDOUT_LOGGING" />
</settings>
```

 **2.mybatis的配置文件----mybatis-config.xml如下：** 

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <settings>
        <!-- 打印sql日志 -->
        <setting name="logImpl" value="STDOUT_LOGGING" />
    </settings>
</configuration>
```



#### 4.2 方法二

 **在springboot的配置文件----appcation.yml中添加：** 

```xml
logging:
  level:
    com.groot.springbootmybatis.dao.mapper: debug
```

![](https://pic.downk.cc/item/5f0dbacc14195aa594ea23ad.png)

ps：com.groot.springbootmybatis.dao.mapper为包名称mapper路径



#### 4.2 方法三

 **如果你使用的是springboot+mybatis-plus的话：** 

```xml
  <dependency>
       <groupId>com.baomidou</groupId>
       <artifactId>mybatis-plus-boot-starter</artifactId>
       <version>3.3.1</version>
  </dependency>
```

 **application.yml:**  

```xml
mybatis-plus:
  configuration:
    log-impl: com.groot.springbootmybatis.dao.mapper
```

[参考文章]( https://blog.csdn.net/qq_37495786/article/details/82799910?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-8.nonecase&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-8.nonecase )



### 5.Mybatis 动态sql



#### 5.1 常见动态sql的使用

- sql
- trim
- if
- choose、when、otherwise
- concat
- foreach
- include

**1.trim的使用**

- 属性
   1.常用
   prefix：在条件语句前需要加入的内容。
   suffix：在条件语句后需要加入的内容

- 2.不常用
   prefixOverrides：覆盖/去掉前一个前缀
   suffixOverrides：覆盖/去掉后一个前缀

**2.foreach元素的属性主要有item，index，collection，open，separator，close。**

- item：集合中元素迭代时的别名，
- index：集合中元素迭代时的索引
- open：常用语where语句中，表示以什么开始，比如以'('开始
- separator：表示在每次进行迭代时的分隔符，
- close 常用语where语句中，表示以什么结束，

**3.choose、when、otherwise**

等价于数据中的Case When Else End

**4.concat**模糊查询

等价于数据中的like

**5.if**

判断是否存在

**6.include**

可以进行封装，或者针对不同的返回类型使用同一include、



**以下为使用的样例**

```java
	/**
	 * 1.查询list mapper文件
	 * @return
	 */
	List<ExampleDemoVO> findMybatisOperation();
```

```xml
    <!--1.1 查询列 -->
    <sql id="column">
        cbd.delivery_no deliveryNo,
        cbd.booking_id bookingId,
        cbd.task_id TASKID,
        cbd.update_time UPdateTime,
        cbd.update_user updateUser
    </sql>

    <!--1.2 where 条件 -->
    <sql id="whereParameter">
        from example_data cbd
        <!-- trim 的用法剔除多余的条件-->
        <trim prefix="WHERE" prefixOverrides="AND|OR">
            <if test="bTime != null and eTime != null">
                and create_time>'2019-12-01'
            </if>
            <!-- if 标签 -->
            <if test="bookingIdList!=null and bookingIdList.size>0">
                AND booking_id IN
                <!--foreach标签-->
                <foreach collection="bookingIdList" item="item" index="index" open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
            <!-- choose 标签类似case when -->
            <choose>
                <when test="isPrecisionFlag != null and isPrecisionFlag=1">
                    AND precision_result = 1
                </when>
                <when test="isPrecisionFlag != null and isPrecisionFlag>1">
                    AND is_valid &lt;2
                </when>
                <otherwise>
                    AND precision_result = 0
                </otherwise>
            </choose>
            <!--concat的用法 -->
            <if test="receiveNo!=null and receiveNo!= ''">
                AND delivery_receive_no like concat('%',concat(#{receiveNo},'%'))
            </if>
            <!--可以将参数写到签名进行判断 -->
            <if test="isPrecisionFlag != null ">
                AND #{isPrecisionFlag}=CASE WHEN FP.precision_result = '111' THEN 1 ELSE 0 END
            </if>
        </trim>
    </sql>

    <!-- 1.查询 -->
    <select id="findMybatisOperation" parameterType="map" resultType="com.groot.springbootmybatis.pojo.ExampleDemoVO">
        SELECT
        <include refid="column"/>
        <include refid="whereParameter"/>
    </select>
```

#### 5.2 mybatis常规增删改查

**1.mapper**

```java
	/**
	 * 2.修改
	 * @param list
	 */
	void updateMybatisOperation(List<ExampleDemoVO> list);

	/**
	 * 2.1 修改
	 * @param list
	 */
	void updateMybatisOperation2(Map map);

	/**
	 * 3.新增
	 * @param list
	 */
	void saveMybatisOperation(List<ExampleDemoVO> list);

	/**
	 *
	 * 4.删除
	 * @param type
	 */
	void deleteMybatisOperation(@Param("type") Integer type);

```

**2.mybatis文件**

```xml

    <!-- 2.修改 -->
    <update id="updateMybatisOperation" parameterType="java.util.List">
        <foreach collection="list" item="item" index="index" separator=";">
            UPDATE `example_data`
            SET update_time = NOW(),
            update_user = 89,
            is_valid=0
            where task_id = #{item.id}
        </foreach>
    </update>

	<!-- 2.修改单条-->
    <update id="updateMybatisOperation2" parameterType="map">
         UPDATE `example_data`
        <set>
            <if test="update_time != null">
                update_time = NOW(),
            </if>
            <if test="is_valid != null">
                is_valid =0
            </if>
        </set>
            where task_id = #{id}
    </update>

    <!--3.新增-->
    <insert id="saveMybatisOperation" parameterType="java.util.List">

        INSERT INTO example_data
        (create_time ,
        update_time ,
        create_user ,
        update_user ,
        is_valid ,
        rversion ,
        delivery_no ,
        booking_id ,
        task_id ,
        delivery_receive_no,
        sequence_customer_type
        )
        VALUES
        <foreach collection="list" item="item" index="index" separator=",">
            (
            now(),
            now(),
            #{item.createUser},
            #{item.updateUser},
            1,
            #{item.rversion},
            #{item.deliveryNo},
            #{item.bookingId},
            #{item.taskId},
            #{item.deliveryReceiveNo}
            )
        </foreach>
    </insert>

    <!-- 4.删除 -->
    <delete id="deleteMybatisOperation" parameterType="java.lang.Integer">
		DELETE FROM `example_data` WHERE booking_id = #{type}
	</delete>
```

#### 5.3 mybatis使用技巧

**1.insert ignore**

当插入数据时，出现错误，或重复数据，将不返回错误，只以警告形式返回。如果数据库没有数据，就插入新的数据，如果有数据的话就跳过这条数据。 

```xml
 <insert id="saveMybatisOperation2" parameterType="java.util.List">
        INSERT IGNORE INTO example_data
        (create_time ,
        update_time 
        )
       VALUES
        <foreach collection="list" item="item" index="index" separator=",">
            (
            now(),
            now()
            )
        </foreach>
    </insert>
```

**2.insert into …on duplicate key update**

 当**primary或者unique重复**时，则执行update语句,否则新增。
**tips：ON DUPLICATE KEY UPDATE后放置需要更新的数据，未放到此处的列不会被更新** 

```XML
    <insert id="saveMybatisOperation2" parameterType="java.util.List">
        INSERT INTO example_data
        (create_time ,
        update_time 
        )
       VALUES
        <foreach collection="list" item="item" index="index" separator=",">
            (
            now(),
            now()
            )
        </foreach>
        ON DUPLICATE KEY UPDATE
        deliveryNo = values(delivery_no),
        bookingId = values(booking_id)
    </insert>
```

**3. insert … select … where not exist**

 根据**select**的条件判断是否插入。 

```XML
    <insert id="saveMybatisOperation2" parameterType="java.util.List">
        INSERT  INTO example_data
        (
        delivery_no ,
        booking_id
        )
      SELECT delivery_no,booking_id from example_data WHERE task_id>0
      AND NOT EXISTS (SELECT id FROM example_data WHERE is_valid = 0)
    </insert>
```



**4.replace into**

 如果存在primary or unique相同的记录，则先**删除**掉。**再插入**新记录。 

```XML
    <insert id="saveMybatisOperation2" parameterType="java.util.List">
       REPLACE  INTO example_data
        (
        delivery_no ,
        booking_id
        )
      SELECT delivery_no,booking_id from example_data WHERE task_id>0
    </insert>
```

**5.selectKey的用法**

返回主键针对单条数据

```xml
<insert id="saveMybatisOperation2" parameterType="com.groot.springbootmybatis.pojo.ExampleDemoVO">
        <selectKey keyProperty="id" order="AFTER" resultType="java.lang.String">
            select LAST_INSERT_ID()
        </selectKey>
        insert INTO example_data
        (
        delivery_no ,
        booking_id
        )
        SELECT delivery_no,booking_id from example_data WHERE task_id>0
    </insert>
```

**6.selectKey的用法**

针对多条数据

```xml
    <!--3.3新增-->
    <insert id="saveMybatisOperation3"  useGeneratedKeys="true" keyProperty="id" parameterType="java.util.List">
        INSERT INTO example_data
        (create_time ,
        update_time
        )
        VALUES
        <foreach collection="list" item="item" index="index" separator=",">
            (
            now(),
            now()
            )
        </foreach>
    </insert>
```

**备注**

- mybatis 中的大于小于不能直接写 >= 或者 <=  ,可以加上`<![CDATA[ ]]>`

```
<![CDATA[ and create_time <= #{endDate}]]>
```

- c常用的转义符如下所示

|         |      |        |
| ------- | ---- | ------ |
| &lt；   | <    | 小于   |
| &gt；   | >    | 大于   |
| &amp；  | &    | 与     |
| &apos； | ’    | 单引号 |
| &quot； | "    | 双引号 |



### mybatis常见问题

**1.Could not find result map java.util.Map 问题分析及解决**



```java
//错误写法
<select id="queryXXXCount" resultMap="java.util.Map" >
正确写法:
<select id="queryXXXCount" resultType="java.util.Map">  
```


 注解：

MyBatis中在查询进行select映射的时候，返回类型可以用resultType，也可以用resultMap，resultType是直接表示返回类型的，而resultMap则是对外部ResultMap的引用，但是resultType跟resultMap不能同时存在。



在MyBatis进行查询映射时，其实查询出来的每一个属性都是放在一个对应的Map里面的，其中键是属性名，值则是其对应的值。

 

①当提供的返回类型属性是resultType时，MyBatis会将Map里面的键值对取出赋给resultType所指定的对象对应的属性。所以其实MyBatis的每一个查询映射的返回类型都是ResultMap，只是当提供的返回类型属性是resultType的时候，MyBatis对自动的给把对应的值赋给resultType所指定对象的属性。

 

②当提供的返回类型是resultMap时，因为Map不能很好表示领域模型，就需要自己再进一步的把它转化为对应的对象，这常常在复杂查询中很有作用。

**2.#{} 以及 ${}区别**

动态 sql 是 mybatis 的主要特性之一，在 mapper 中定义的参数传到 xml 中之后，在查询之前 mybatis 会对其进行动态解析。mybatis 为我们提供了两种支持动态 sql 的语法：#{} 以及 ${}。



#{}表示一个占位符号，通过#{}可以实现preparedStatement向占位符中设置值，自动进行java类型和jdbc类型转换，#{}可以有效防止sql注入。#{}可以接收简单类型值或pojo属性值。如果parameterType传输单个简单类型值，#{}括号中可以是value或其它名称。



表示拼接sql串，通过{}表示拼接sql串，通过表示拼接sql串，通过{}可以将parameterType传入的内容拼接在sql中且不进行jdbc类型转换，可以接收简单类型值或pojo属性值，如果parameterType传输单个简单类型值，{}可以接收简单类型值或pojo属性值，如果parameterType传输单个简单类型值，可以接收简单类型值或pojo属性值，如果parameterType传输单个简单类型值，{}括号中只能是value。



在下面的语句中，如果 传入的的值为 单个字符,如传入的值为xiaoming，则两种方式无任何区别：
例：

```xml
      select * from user where name = #{nameString};
      select * from user where name = ${nameString};
```


其解析之后的结果均为

```xml
select * from user where name = 'mybatistest';
```

但是 #{} 和 ${} 在预编译中的处理是不一样的。#{} 在预处理时，会把参数部分用一个占位符 ? 代替，变成如下的 sql 语句：select * from user where name = ?;

而 ${} 则只是简单的字符串替换，在动态解析阶段，该 sql 语句会被解析成
select * from user where name = ‘zhangsan’;

#{} 的参数替换是发生在 DBMS 中，而 ${} 则发生在动态解析过程中。

在使用过程中是要优先使用 #{}。因为 ${} 会导致 sql 注入的问题。



**3.Mybatis的Xml映射文件中，不同的Xml映射文件，id是否可以重复？**

答：不同的Xml映射文件，如果配置了namespace，那么id可以重复；如果没有配置namespace，那么id不能重复；毕竟namespace不是必须的，只是最佳实践而已。

原因就是namespace+id是作为Map<String, MappedStatement>的key使用的，如果没有namespace，就剩下id，那么，id重复会导致数据互相覆盖。有了namespace，自然id就可以重复，namespace不同，namespace+id自然也就不同。



**4.当实体类中的属性名和表中的字段名不一样 ，怎么办 ？**

**第1种： 通过在查询的sql语句中定义字段名的别名，让字段名的别名和实体类的属性名一致。**

```xml
 <select id=”selectorder” parametertype=”int” resultetype=”com.groot.springbootmybatis.pojo.ExampleDemoVO”>
      SELECT cbd.delivery_no deliveryNo,
      cbd.booking_id bookingId,
      cbd.task_id TASKID,
      cbd.update_time UPdateTime,
      cbd.update_user updateUser
      from channel_booking_delivery cbd
    </select>
```

第2种： 通过<resultMap>来映射字段名和实体类属性名的一一对应的关系。



**5.Mybatis的一级、二级缓存:**

1）一级缓存: 基于 PerpetualCache 的 HashMap 本地缓存，其存储作用域为 Session，当 Session flush 或 close 之后，该 Session 中的所有 Cache 就将清空，默认打开一级缓存。

2）二级缓存与一级缓存其机制相同，默认也是采用 PerpetualCache，HashMap 存储，不同在于其存储作用域为 Mapper(Namespace)，并且可自定义存储源，如 Ehcache。默认不打开二级缓存，要开启二级缓存，使用二级缓存属性类需要实现Serializable序列化接口(可用来保存对象的状态),可在它的映射文件中配置<cache/> ；

3）对于缓存数据更新机制，当某一个作用域(一级缓存 Session/二级缓存Namespaces)的进行了C/U/D 操作后，默认该作用域下所有 select 中的缓存将被 clear。



**6.使用MyBatis的mapper接口调用时有哪些要求？**

① Mapper接口方法名和mapper.xml中定义的每个sql的id相同；
② Mapper接口方法的输入参数类型和mapper.xml中定义的每个sql 的parameterType的类型相同；
③ Mapper接口方法的输出参数类型和mapper.xml中定义的每个sql的resultType的类型相同；
④ Mapper.xml文件中的namespace即是mapper接口的类路径。



**7.简述Mybatis的插件运行原理，以及如何编写一个插件**

答：Mybatis仅可以编写针对ParameterHandler、ResultSetHandler、StatementHandler、Executor这4种接口的插件，Mybatis使用JDK的动态代理，为需要拦截的接口生成代理对象以实现接口方法拦截功能，每当执行这4种接口对象的方法时，就会进入拦截方法，具体就是InvocationHandler的invoke()方法，当然，只会拦截那些你指定需要拦截的方法。

编写插件：实现Mybatis的Interceptor接口并复写intercept()方法，然后在给插件编写注解，指定要拦截哪一个接口的哪些方法即可，记住，别忘了在配置文件中配置你编写的插件。

参考文章:

[MyBatis 常见面试题总结]( https://zhuanlan.zhihu.com/p/73626454 )



## 关注

>如果你觉得我的文章对你有帮助话，欢迎点赞👍 关注❤️ 分享👥！
>
>如果本篇博客有任何错误，请批评指教，不胜感激！
>
>点个在看，分享到朋友圈，对我真的很重要！！！


![snailThink.png](http://ww1.sinaimg.cn/large/006aMktPgy1gdegzjxv6yj30go0gogmi.jpg)


