# 数据接口配置服务-Dataway

官方文档地址:https://www.hasor.net/web/dataway/about.html

Dataway的demo地址:https://github.com/Guofucheng0822/spring-boot-demo/tree/master/project-hasor-dataway

**1.Dataway介绍**

Dataway 是基于 DataQL 服务聚合能力，为应用提供的一个接口配置工具。使得使用者无需开发任何代码就配置一个满足需求的接口。整个接口配置、测试、冒烟、发布。一站式都通过 Dataway 提供的 UI 界面完成。UI 会以 Jar 包方式提供并集成到应用中并和应用共享同一个 http 端口，应用无需单独为 Dataway 开辟新的管理端口。

这种内嵌集成方式模式的优点是，可以使得大部分老项目都可以在无侵入的情况下直接应用 Dataway。进而改进老项目的迭代效率，大大减少企业项目研发成本。

Dataway 工具化的提供 DataQL 配置能力。这种研发模式的变革使得，相当多的需求开发场景只需要配置即可完成交付。从而避免了从数据存取到前端接口之间的一系列开发任务，例如：Mapper、BO、VO、DO、DAO、Service、Controller 统统不在需要。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531095838.png)

**2.Spring Boot整合Dataway**

第一步：引入相关依赖

Dataway 是 Hasor 生态中的一员，使用 Dataway 第一步需要通过 hasor-spring 打通两个生态。hasor-spring 负责 Spring 和 Hasor 框架之间的整合。hasor-dataway 是工作在 Hasor 之上，利用 hasor-spring 我们就可以使用 dataway了。

初始化springboot工程,引入依赖:

```xml
<!--   dataway-->
<!--    hasor-spring 负责 Spring 和 Hasor 框架之间的整合。-->
<dependency>
    <groupId>net.hasor</groupId>
    <artifactId>hasor-spring</artifactId>
    <version>4.1.3</version>
</dependency>
<!--   hasor-dataway 是工作在 Hasor 之上，利用 hasor-spring 我们就可以使用 dataway了-->
<dependency>
    <groupId>net.hasor</groupId>
    <artifactId>hasor-dataway</artifactId>
    <version>4.1.3-fix20200414</version><!-- 4.1.3 包存在UI资源缺失问题 -->
</dependency>
```





第二步：配置 Dataway，并初始化数据表

dataway 会提供一个界面让我们配置接口，这一点类似 Swagger 只要jar包集成就可以实现接口配置。找到我们 springboot 项目的配置文件 application.properties

```java
#-----------------------------Dataway相关配置----------------------------------------------------
# 是否启用 Dataway 功能（必选：默认false）
HASOR_DATAQL_DATAWAY=true

# 是否开启 Dataway 后台管理界面（必选：默认false）
HASOR_DATAQL_DATAWAY_ADMIN=true

# dataway  API工作路径（可选，默认：/api/）
HASOR_DATAQL_DATAWAY_API_URL=/api/ 

# dataway-ui 的工作路径（可选，默认：/interface-ui/）
HASOR_DATAQL_DATAWAY_UI_URL=/interface-ui/

# SQL执行器方言设置（可选，建议设置）
HASOR_DATAQL_FX_PAGE_DIALECT=mysql
```







Dataway 一共涉及到 5个可以配置的配置项，但不是所有配置都是必须的。

其中 HASOR_DATAQL_DATAWAY、HASOR_DATAQL_DATAWAY_ADMIN 两个配置是必须要打开的，默认情况下 Datawaty 是不启用的。

Dataway 需要两个数据表才能工作，下面是这两个数据表的简表语句。下面这个 SQL 可以在 dataway的依赖 jar 包中 “META-INF/hasor-framework/mysql” 目录下面找到，建表语句是用 mysql 语法写的。

```sql
CREATE TABLE `interface_info` (
    `api_id`          int(11)      NOT NULL AUTO_INCREMENT   COMMENT 'ID',
    `api_method`      varchar(12)  NOT NULL                  COMMENT 'HttpMethod：GET、PUT、POST',
    `api_path`        varchar(512) NOT NULL                  COMMENT '拦截路径',
    `api_status`      int(2)       NOT NULL                  COMMENT '状态：0草稿，1发布，2有变更，3禁用',
    `api_comment`     varchar(255)     NULL                  COMMENT '注释',
    `api_type`        varchar(24)  NOT NULL                  COMMENT '脚本类型：SQL、DataQL',
    `api_script`      mediumtext   NOT NULL                  COMMENT '查询脚本：xxxxxxx',
    `api_schema`      mediumtext       NULL                  COMMENT '接口的请求/响应数据结构',
    `api_sample`      mediumtext       NULL                  COMMENT '请求/响应/请求头样本数据',
    `api_create_time` datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `api_gmt_time`    datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`api_id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COMMENT='Dataway 中的API';

CREATE TABLE `interface_release` (
    `pub_id`          int(11)      NOT NULL AUTO_INCREMENT   COMMENT 'Publish ID',
    `pub_api_id`      int(11)      NOT NULL                  COMMENT '所属API ID',
    `pub_method`      varchar(12)  NOT NULL                  COMMENT 'HttpMethod：GET、PUT、POST',
    `pub_path`        varchar(512) NOT NULL                  COMMENT '拦截路径',
    `pub_status`      int(2)       NOT NULL                  COMMENT '状态：0有效，1无效（可能被下线）',
    `pub_type`        varchar(24)  NOT NULL                  COMMENT '脚本类型：SQL、DataQL',
    `pub_script`      mediumtext   NOT NULL                  COMMENT '查询脚本：xxxxxxx',
    `pub_script_ori`  mediumtext   NOT NULL                  COMMENT '原始查询脚本，仅当类型为SQL时不同',
    `pub_schema`      mediumtext       NULL                  COMMENT '接口的请求/响应数据结构',
    `pub_sample`      mediumtext       NULL                  COMMENT '请求/响应/请求头样本数据',
    `pub_release_time`datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间（下线不更新）',
    PRIMARY KEY (`pub_id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COMMENT='Dataway API 发布历史。';

create index idx_interface_release on interface_release (pub_api_id);
```



第三步：配置数据源

作为 Spring Boot 项目有着自己完善的数据库方面工具支持。我们这次采用 druid + mysql + spring-boot-starter-jdbc 的方式。

首先引入依赖

然后增加数据源的配置

```java
#-----------------------------数据源相关配置----------------------------------------------------
#db
spring.datasource.url=jdbc:mysql://192.168.18.128:3306/test
spring.datasource.username=root
spring.datasource.password=123456
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.type:com.alibaba.druid.pool.DruidDataSource
#druid
spring.datasource.druid.initial-size=3
spring.datasource.druid.min-idle=3
spring.datasource.druid.max-active=10
spring.datasource.druid.max-wait=60000
spring.datasource.druid.stat-view-servlet.login-username=admin
spring.datasource.druid.stat-view-servlet.login-password=admin
spring.datasource.druid.filter.stat.log-slow-sql=true
spring.datasource.druid.filter.stat.slow-sql-millis=1
```



第四步：把数据源设置到 Hasor 容器中

Spring Boot 和 Hasor 本是两个独立的容器框架，我们做整合之后为了使用 Dataway 的能力需要把 Spring 中的数据源设置到 Hasor 中。

首先新建一个 Hasor 的 模块，并且将其交给 Spring 管理。然后把数据源通过 Spring 注入进来。

```java
@DimModule
@Component
public class ExampleModule implements SpringModule {
    @Autowired
    private DataSource dataSource = null;

    @Override
    public void loadModule(ApiBinder apiBinder) throws Throwable {
        // .DataSource form Spring boot into Hasor
        apiBinder.installModule(new JdbcModule(Level.Full, this.dataSource));
    }
}
```

Hasor 启动的时候会调用 loadModule 方法，在这里再把 DataSource 设置到 Hasor 中。



第五步：在SprintBoot 中启用 Hasor

```java
@EnableHasor()      // 在Spring 中启用 Hasor
@EnableHasorWeb()   // 将 hasor-web 配置到 Spring 环境中，Dataway 的 UI 是通过 hasor-web 提供服务。
@SpringBootApplication
public class DatawayApplication {

    public static void main(String[] args) {
        SpringApplication.run(DatawayApplication.class, args);
    }
}
```



第六步：启动应用

应用在启动过程中会看到 Hasor Boot 的欢迎信息

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531100023.png)

在启动日志中看到下列信息输出就表示 Dataway 已经可以正常访问了。

```java
2020-05-02 10:16:04.264  INFO 1236 --- [ost-startStop-1] n.hasor.core.context.TemplateAppContext  : loadModule class net.hasor.dataway.config.DatawayModule
2020-05-02 10:16:04.264  INFO 1236 --- [ost-startStop-1] net.hasor.dataway.config.DatawayModule   : dataway api workAt /api/
2020-05-02 10:16:04.264  INFO 1236 --- [ost-startStop-1] n.h.c.environment.AbstractEnvironment    : var -> HASOR_DATAQL_DATAWAY_API_URL = /api/.
2020-05-02 10:16:04.271  INFO 1236 --- [ost-startStop-1] net.hasor.dataway.config.DatawayModule   : dataway admin workAt /interface-ui/
```



- dataway api workAt /api/ 表示 API 的工作路径。
- dataway admin workAt /interface-ui/ 表示 管理配置界面的地址。

此时访问：http://:/interface-ui/ 就可以看到配置页面了。

1.查询

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531095915.png)

2.新增

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531095927.png)

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531095939.png)

3.修改

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531095954.png)

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531100007.png)