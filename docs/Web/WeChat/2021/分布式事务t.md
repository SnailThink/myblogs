# 分布式事务

## ACID

> A: automicity(原子性)
>
> C: consitency(一致性)
>
> I: isolation (隔离性)
>
> D: durability (持久性)

[从ACID到CAP/BASE](https://www.cnblogs.com/linbingdong/p/6178488.html)

# CAP理论

> C:consistency (一致性)
>
> A:availability(可用性)
>
> P:partition tolerance(分区容错性)
>
> [CAP 定理的含义](http://www.ruanyifeng.com/blog/2018/07/cap.html)

```
核心思路：三者不可兼得，只可保证两者，在分布式环境下，P已成必然，就只能考虑CP或者AP两种情况，
```

## BASE理论

> BA: basically aviliable (基本可用)
>
> S : soft state (软状态)
>
> E : eventually consistency (最终一致性)

### 一种分类说法:

-  刚性事务
-  柔性事务 ,分为：2PC两阶段型、TCC补偿型、本地消息表（异步确保）、LCN等

# X/Open DTP 模型

[X/Open DTP——分布式事务模型](https://www.cnblogs.com/aigongsi/archive/2012/10/11/2718313.html)

> X/Open DTP(X/Open Distributed Transaction Processing Reference Model) 是X/Open 这个组织定义的一套分布式事务的标准，也就是了定义了规范和API接口，由这个厂商进行具体的实现。这个思想在java 平台里面到处都是。
>
>  ![image](https://cdn.nlark.com/yuque/0/2019/jpeg/182541/1571306743523-b76d0e24-b12f-4ca7-b7d5-6a310f50b145.jpeg)
>
> X/Open DTP 定义了三个组件： AP，TM，RM
>
> AP(Application Program)：也就是应用程序，可以理解为使用DTP的程序
>
> RM(Resource Manager)：资源管理器，这里可以理解为一个DBMS系统，或者消息服务器管理系统，应用程序通过资源管理器对资源进行控制。资源必须实现XA定义的接口
>
> TM(Transaction Manager)：事务管理器，负责协调和管理事务，提供给AP应用程序编程接口以及管理资源管理器
>
> 其中，AP 可以和TM 以及 RM 通信，TM 和 RM 互相之间可以通信，DTP模型里面定义了XA接口，TM 和 RM 通过XA接口进行双向通信，例如:TM通知RM提交事务或者回滚事务，RM把提交结果通知给TM。AP和RM之间则通过RM提供的Native API 进行资源控制，这个没有约定API和规范，各个厂商自己实现自己的资源控制，比如Oracle自己的数据库驱动程序。

# TX规范

> 应用与事务管理器的接口

# XA规范

> 主要定义了(全局)事务管理器(Transaction Manager)和(局部)资源管理器(Resource Manager)之间的接口。 XA接口是双向的系统接口，在事务管理器（Transaction Manager）以及一个或多个资源管理器（Resource Manager）之间形成通信桥梁。 XA 是一个两阶段提交协议，该协议分为以下两个阶段： 第一阶段：事务协调器要求每个涉及到事务的数据库预提交(precommit)此操作，并反映是否可以提交。 第二阶段：事务协调器要求每个数据库提交数据。 其中，如果有任何一个数据库否决此次提交，那么所有数据库都会被要求回滚它们在此事务中的那部分信息。

参考资料：[MySQL 中基于 XA 实现的分布式事务](https://www.jianshu.com/p/a7d1c4f2542c)

# 分布式事务的几种解决方案

## 两阶段提交（2PC）

> 两阶段：prepare和commit阶段，类似投票，事务管理器先逐一询问各个相关的资源管理器是否就绪，如果所有都就绪，再逐一通知所有资源管理器可以commit。

###### 正常情况下的两阶段提交

![image](https://cdn.nlark.com/yuque/0/2019/jpeg/182541/1571306743449-4e8d2c83-e466-412b-9d62-8880ca7e0d68.jpeg)

###### 如果第一阶段某一个资源预提交失败，第二阶段就回滚第一阶段已经预提交成功的资源

![image](https://cdn.nlark.com/yuque/0/2019/jpeg/182541/1571306743468-0fa85055-5832-4a7d-979c-dddb92074c6f.jpeg)[链接到图来源](https://www.cnblogs.com/aigongsi/archive/2012/10/11/2718313.html)

- 问题1：效率低，需要和局部资源管理器多次交互
- 问题2：当下游RM收到prepare指令后，TM挂了，RM就会长时间陷入事务挂起状态
- 问题3：commit阶段部分RM挂了
- 问题4：没有分布式事务处理能力

> 参考资料2：[MySQL 中基于 XA 实现的分布式事务](https://www.jianshu.com/p/a7d1c4f2542c)，有通过mysql中XA接口实现的手工2pc使用代码示例，通过这个代码大家可以思考: 如何实现一个分布式的事务。

## 3PC

相比较2PC而言，3PC对于协调者（Coordinator）和参与者（Partcipant）都设置了超时时间，而2PC只有协调者才

拥有超时机制 

![image](https://cdn.nlark.com/yuque/0/2019/webp/182541/1571306743676-c039ee8d-b393-4844-aaf2-f912acd1b417.webp)

## 补偿事务（TCC）

> TCC（Try-Confirm-Cancel）的作用主要是解决跨服务调用场景下的分布式事务问题,遵循BASE原理 总体思路和XA很像，但是XA是资源级别的分布式事务，TCC是业务层面的分布式事务 核心思想是："针对每个操作都要注册一个与其对应的确认和补偿（撤销操作）"，这个是和2PC和核心区别 2PC机制需要RM提供底层支持（一般是兼容XA），而TCC机制则不需要。

[参考资料：柔性事务:TCC两阶段补偿型](http://www.tianshouzhi.com/api/tutorials/distributed_transaction/388) (这个文章很好，一篇就足以理解TCC了，还有TCC和XA的对比)

## 本地消息表（异步确保）

![image](https://cdn.nlark.com/yuque/0/2019/png/182541/1571306743590-2e76cb8b-0488-4c04-bf39-1b6311ab4ffc.png)

```
基本思路就是：
消息生产方，需要额外建一个消息表，并记录消息发送状态。
消息表和业务数据要在一个事务里提交，也就是说他们要在一个数据库里面。
然后消息会经过MQ发送到消息的消费方。如果消息发送失败，会进行重试发送。
消息消费方，需要处理这个消息，并完成自己的业务逻辑。
此时如果本地事务处理成功，表明已经处理成功了，
如果处理失败，那么就会重试执行。
如果是业务上面的失败，可以给生产方发送一个业务补偿消息，通知生产方进行回滚等操作。
生产方和消费方定时扫描本地消息表，把还没处理完成的消息或者失败的消息再发送一遍。
如果有靠谱的自动对账补账逻辑，这种方案还是非常实用的。
这种方案遵循BASE理论，采用的是最终一致性，
是这几种方案里面比较适合实际业务场景的，
即不会出现像2PC那样复杂的实现(当调用链很长的时候，2PC的可用性是非常低的)，
也不会像TCC那样可能出现确认或者回滚不了的情况。
```

> 优点： 一种非常经典的实现，避免了分布式事务，实现了最终一致性。
>
> 缺点： 消息表会耦合到业务系统中，如果没有封装好的解决方案，会有很多杂活需要处理。
>
> 写本地消息表来定时扫表还是直接写MQ通知，或是写表+发MQ+定时扫表？
>
> [本地消息表和MQ等可靠消息解决方案](https://blog.csdn.net/lsblsb/article/details/89451745)

## MQ 事务消息

> RocketMQ的事务消息
>
>  ![image](https://cdn.nlark.com/yuque/0/2019/png/182541/1571306743505-156ecc76-5d45-44ff-bae2-5cd2f214d869.png)

## Saga事务模型

![image](https://cdn.nlark.com/yuque/0/2019/jpeg/182541/1571359334140-95c084f9-e62d-40c2-8f64-0985c819db9a.jpeg?x-oss-process=image%2Fresize%2Cw_1500)

> [分布式事务：Saga模式](https://www.jianshu.com/p/e4b662407c66)

# 其他参考资料：

> [分布式事务之深入理解什么是2PC、3PC及TCC协议](https://www.cnblogs.com/wudimanong/p/10340948.html)
>
> [分布式系统事务一致性解决方案](https://www.infoq.cn/article/solution-of-distributed-system-transaction-consistency)
>
> [分布式事务：不过是在一致性、吞吐量和复杂度之间，做一个选择](https://mp.weixin.qq.com/s?__biz=MzI4MTY5NTk4Ng==&mid=2247489579&idx=1&sn=128c1ced738e205f0b9def9bc5ec6d51&source=41)
>
> [TX-LCN分布式事务框架](http://www.txlcn.org/zh-cn/)

# Seata(Fescar)

- Fescar（Fast & EaSy Commit And Rollback）
- Seata，Simple Extensible Autonomous Transaction Architecture，是一套一站式分布式事务解决方案。
- Seata项目地址 (https://github.com/seata/seata)
- 中文文档 (https://github.com/seata/seata/wiki/Home_Chinese)

#### STEP1:Seata Server 配置和启动

###### 第1步： 下载seata-server

> 从这个地址下载 (https://github.com/seata/seata/releases)

###### 第2步： mysql数据库里建立一个库名叫seata,并建表

> 建表sql在 seata-server/conf/db_store.sql

###### 第3步： 修改seata-server的连库配置

> 编辑文件 seata-server/conf/file.conf,修改其中的数据库连接串、账号和密码

###### 第4步： 启动seata-server

> 到seata-server/bin目录下,执行：./seata-server.sh -h 172.16.57.103 -p 8091 -m file

#### STEP2:SpringCloud应用程序集成

###### 第1步： 添加pom依赖

```xml
<!-- seata -->
    <dependency>
        <groupId>io.seata</groupId>
        <artifactId>seata-all</artifactId>
        <version>0.8.0</version>
    </dependency>
    <!-- 以下依赖工程中应该都有了-->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>5.1.31</version>
    </dependency>
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>druid-spring-boot-starter</artifactId>
        <version>1.1.10</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
```

###### 第2步： resources下增加两个配置文件

> file.conf 需要修改两行配置

```java
transport {
...
}
service {
  # 注意下面的 “storage-service” 保持和spring.application.name保持一致
  vgroup_mapping.storage-service-fescar-service-group="default"
  # seata-server地址
  default.grouplist = "172.16.57.103:8091"
  ...
}
...
```

> registry.conf (不修改，这里去掉了没用的配置示例)

```java
registry {
  type = "file"
  file {
    name = "file.conf"
  }
}
config {
  type = "file"
  file {
    name = "file.conf"
  }
}
```

###### 第3步： 增加数据库代理配置

```java
/**
     * 需要将 DataSourceProxy 设置为主数据源，否则事务无法回滚
     *
     * @param druidDataSource The DruidDataSource
     * @return The default datasource
     */
    @Primary
    @Bean("dataSource")
    public DataSource dataSource(DruidDataSource druidDataSource) {
        return new DataSourceProxy(druidDataSource);
    }
```

###### 第4步： 增加seata配置

```java
@Configuration
public class SeataConfiguration {
    @Value("${spring.application.name}")
    private String applicationId;
    /**
     * 注册一个StatViewServlet
     * @return global transaction scanner
     */
    @Bean
    public GlobalTransactionScanner globalTransactionScanner() {
        GlobalTransactionScanner globalTransactionScanner = new GlobalTransactionScanner(applicationId,
            "order-service-fescar-service-group");
        return globalTransactionScanner;
    }
}
```

###### 第5步： 事务总方法前增加注解@GlobalTransactional

```java
@GlobalTransactional
    public void purchase(String userId, String commodityCode, int orderCount) {
        logger.info(" ------------ BusinessService.purchase 1");
        storageFeignClient.deduct(commodityCode, orderCount);
        logger.info(" ------------ BusinessService.purchase 2");
        orderFeignClient.create(userId, commodityCode, orderCount);
        logger.info(" ------------ BusinessService.purchase 3");
    }
```

###### 第6步： 各子业务代码前添加注解@Transactional

###### 第6步： 各业务库中增加一个表

```java
drop table `undo_log`;
CREATE TABLE `undo_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `branch_id` bigint(20) NOT NULL,
  `xid` varchar(100) NOT NULL,
  `context` varchar(128) NOT NULL,
  `rollback_info` longblob NOT NULL,
  `log_status` int(11) NOT NULL,
  `log_created` datetime NOT NULL,
  `log_modified` datetime NOT NULL,
  `ext` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_undo_log` (`xid`,`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```