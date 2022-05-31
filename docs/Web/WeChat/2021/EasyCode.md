## IDEA EasyCode(代码神器)



 Easycode是idea的一个插件，可以直接对数据的表生成entity,controller,service,dao,mapper,



#### 1.安装EasyCode

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531103850.png)



#### 2.创建数据库

````sql
DROP TABLE IF EXISTS `orm_customer`;
CREATE TABLE `orm_customer`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `customer_no` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `customer_address` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `customer_type` int(11) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_user` int(11) NULL DEFAULT NULL,
  `update_user` int(11) NULL DEFAULT NULL,
  `asset_money` decimal(16, 7) NULL DEFAULT NULL COMMENT '资产',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;
````



#### 3.在IDEA中配置数据库

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531103920.png)

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531103931.png)

#### 4.生成代码

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531103941.png)



![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531103950.png)



#### 5.pom文件

```xml
 <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>

        <!--热部署-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <optional>true</optional> <!-- 这个需要为 true 热部署才有效 -->
        </dependency>

        <!--mybatis-->
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>1.3.2</version>
        </dependency>

        <!-- mysql -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.47</version>
        </dependency>

        <!--阿里巴巴连接池-->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid</artifactId>
            <version>1.0.9</version>
        </dependency>
```

#### 6. Application.yml 

```yaml

server:
  port: 8089
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/database?useUnicode=true&characterEncoding=UTF-8
    username: root
    password: 123456
    type: com.alibaba.druid.pool.DruidDataSource
    driver-class-name: com.mysql.jdbc.Driver

mybatis:
  mapper-locations: classpath:/mapper/*Dao.xml
  typeAliasesPackage: com.vue.demo.entity
```

#### 7.启动项目

- 在启动项目之前， 在dao层加上@mapper注解 

```java
@Mapper
public interface OrmCustomerMapper {

    /**
     * 通过ID查询单条数据
     *
     * @param id 主键
     * @return 实例对象
     */
    OrmCustomerPO queryById(Integer id);
}

```



-  在启动类里面加上 @MapperScan("com.vue.demo.dao") 

```java
@SpringBootApplication
@MapperScan("com.example.snailthink.dao")
public class SnailthinkRabbitmqExampleApplication {

  public static void main(String[] args) {
    SpringApplication.run(SnailthinkRabbitmqExampleApplication.class, args);
  }
}

```

