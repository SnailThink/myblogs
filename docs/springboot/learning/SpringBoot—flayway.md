# Flyway


> 本 demo 演示了 Spring Boot 如何使用 Flyway 去初始化项目数据库，同时支持数据库脚本的版本控制。


##  一、Flyway是什么
简单地说，flyway是一个能对数据库变更做版本控制的工具。


## 二、为什么要用Flyway

在多人开发的项目中，我们都习惯了使用SVN或者Git来对代码做版本控制，主要的目的就是为了解决多人开发代码冲突和版本回退的问题。

其实，数据库的变更也需要版本控制，在日常开发中，我们经常会遇到下面的问题：

1. 自己写的SQL忘了在所有环境执行；
2. 别人写的SQL我们不能确定是否都在所有环境执行过了；
3. 有人修改了已经执行过的SQL，期望再次执行；
4. 需要新增环境做数据迁移；
5. 每次发版需要手动控制先发DB版本，再发布应用版本；
6. 其它场景...

有了flyway，这些问题都能得到很好的解决。



## 三、如何使用Flyway

### 3.1 准备数据库

首先，我们需要准备好一个空的数据库。（数据库的安装和账密配置此处忽略）

此处以mysql为例，在本地电脑上新建一个空的数据库，名称叫做flyway

### 3.2 准备SpringBoot工程

**参考：SpringBoot项目创建的三种方式**

### 3.3 flyway的引入与尝试

#### 3.3.1 在pom文件中引入flyway的核心依赖包：

```xml
<!-- 添加 flyway 的依赖 -->
<dependency>
  <groupId>org.flywaydb</groupId>
  <artifactId>flyway-core</artifactId>
</dependency>
```

其次，在src/main/resources目录下面新建db.migration文件夹，默认情况下，该目录下的.sql文件就算是需要被flyway做版本控制的数据库SQL语句。

但是此处的SQL语句命名需要遵从一定的规范，否则运行的时候flyway会报错。

#### 3.3.2 命名规则主要有两种：

1. 仅需要被执行一次的SQL命名以大写的"V"开头，后面跟上"0~9"数字的组合,数字之间可以用“.”或者下划线"_"分割开，然后再以两个下划线分割，其后跟文件名称，最后以.sql结尾。比如，`V2.1.5__create_user_ddl.sql`、`V4.1_2__add_user_dml.sql`。

2. 可重复运行的SQL，则以大写的“R”开头，后面再以两个下划线分割，其后跟文件名称，最后以.sql结尾。。比如，`R__truncate_user_dml.sql`。

   其中，V开头的SQL执行优先级要比R开头的SQL优先级高。


#### 3.3.3 我们准备了三个脚本，如下所示：

1.`V1__create_user.sql`，其中代码如下，目的是建立一张 `t_user`表，且只执行一次

```sql
CREATE TABLE IF NOT EXISTS `t_user`(
  `user_id`          INT(11)           NOT NULL AUTO_INCREMENT,
  `user_name`        VARCHAR(100)      NOT NULL COMMENT '用户姓名',
  `age`              INT(3)            NOT NULL COMMENT '年龄',
  `created_time`     datetime          NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_user`       varchar(100)      NOT NULL DEFAULT 'UNKNOWN',
  `updated_time`     datetime          NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_user`       varchar(100)      NOT NULL DEFAULT 'UNKNOWN',
  PRIMARY KEY (`user_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

2.`V2__add_user.sql`，其中代码如下，目的是往 `t_user` 表中插入一条数据，且只执行一次

```sql
INSERT INTO t_user (user_name, age, created_time, created_user , updated_time, updated_user) VALUES ('whcoding', 18, NOW(), 1 , NOW(), 1);
```

3.`R__add_unknown_user.sql`，其中代码如下，目的是每次启动倘若有变化，则往user表中插入一条数据。

```sql
INSERT INTO t_user (user_name, age, created_time, created_user , updated_time, updated_user) VALUES ('whcoding2', 19, NOW(), 1 , NOW(), 1);
```

4.`V3__orm_dept.sql` 目的是建立一张 `orm_dept`表，且只执行一次

```sql

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for orm_dept
-- ----------------------------
DROP TABLE IF EXISTS `orm_dept`;
CREATE TABLE `orm_dept`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dept_id` int(11) NOT NULL COMMENT '部门id',
  `dept_no` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '部门编码',
  `dept_type` int(11) NULL DEFAULT NULL COMMENT '部门类型 1,2,3',
  `dept_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门名称',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `dept_perf` decimal(11, 4) NULL DEFAULT NULL COMMENT '部门绩效',
  `is_valid_flag` int(11) NULL DEFAULT NULL COMMENT '是否有效',
  `short_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门简称',
  `remark` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`, `dept_id`, `dept_no`) USING BTREE,
  UNIQUE INDEX ` UNIQ_TEMP`(`dept_id`, `dept_no`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;

```

与之相对应的目录截图如下：

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220224164117.png)



其中2.1.6、2.1.7和every的文件夹不会影响flyway对SQL的识别和运行，可以自行取名和分类。

到这一步，flyway的默认配置已经足够我们开始运行了。此时，我们启动SpringBoot的主程序，如果以上步骤没有配置错误的话，运行截图如下：

![image-20220701144121768](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220701144121768.png)

查看数据库，可以看到增加的创建表语句已经执行，并且`flyway_schema_history` 表中也有对应的脚本数据

下图是 `flyway_schema_history` 表中的数据

![image-20220701144028660](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220701144028660.png)



![image-20220701144046344](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220701144046344.png)



![image-20220701144453925](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220701144453925.png)



我们不改变任何东西，再次执行主程序，日志如下：两张数据库表中的内容也毫无任何变化。

![image-20220701144642666](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220701144642666.png)



可是，如果我们修改`V2__add_user.sql`中的内容，再次执行的话，就会报错，提示信息如下：



![image-20220701144739669](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220701144739669.png)



如果我们修改了`R__add_unknown_user.sql`，再次执行的话，该脚本就会再次得到执行，并且flyway的历史记录表中也会增加本次执行的记录。

项目启动正常:

![image-20220701144829891](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220701144829891.png)

**`flyway_schema_history`表中的数据**

![image-20220701144850974](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220701144850974.png)

**查看t_user 表中的数据 发现多了一条数据**

![image-20220701144931533](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220701144931533.png)



### 3.4 maven插件的使用

以上步骤中，每次想要migration都需要运行整个springboot项目，并且只能执行migrate一种命令，其实flyway还是有很多其它命令的。maven插件给了我们不需要启动项目就能执行flyway各种命令的机会。在pom中引入flyway的插件，同时配置好对应的数据库连接。

```xml
            <plugin>
                <groupId>org.flywaydb</groupId>
                <artifactId>flyway-maven-plugin</artifactId>
                <version>5.2.4</version>
                <configuration>
                    <url>jdbc:mysql://localhost:3306/flyway?useUnicode=true&amp;characterEncoding=utf8&amp;serverTimezone=GMT</url>
                    <user>root</user>
                    <password>root</password>
                    <driver>com.mysql.cj.jdbc.Driver</driver>
                </configuration>
            </plugin>
```

然后更新maven插件列表，就可以看到flyway的全部命令了。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220224154351.png)



此时，我们双击执行上图中的flyway:migrate的效果和启动整个工程执行migrate的效果是一样的。

其它命令的作用如下列出，各位可自行实验体会：

1. baseline

   对已经存在数据库Schema结构的数据库一种解决方案。实现在非空数据库新建MetaData表，并把Migrations应用到该数据库；也可以在已有表结构的数据库中实现添加Metadata表。

2. clean

   清除掉对应数据库Schema中所有的对象，包括表结构，视图，存储过程等，clean操作在dev 和 test阶段很好用，但在生产环境务必禁用。

3. info

   用于打印所有的Migrations的详细和状态信息，也是通过MetaData和Migrations完成的，可以快速定位当前的数据库版本。

4. repair

   repair操作能够修复metaData表，该操作在metadata出现错误时很有用。

5. undo

   撤销操作，社区版不支持。

6. validate

   验证已经apply的Migrations是否有变更，默认开启的，原理是对比MetaData表与本地Migrations的checkNum值，如果值相同则验证通过，否则失败。

### 3.5 flyway补充知识

1. flyway执行migrate必须在空白的数据库上进行，否则报错；
2. 对于已经有数据的数据库，必须先baseline，然后才能migrate；
3. clean操作是删除数据库的所有内容，包括baseline之前的内容；
4. 尽量不要修改已经执行过的SQL，即便是R开头的可反复执行的SQL，它们会不利于数据迁移；

## 四、总结

在进行了如上的实验后，相信我们都已经掌握了flyway的初步使用，当需要做数据迁移的时候，更换一个新的空白数据库，执行下migrate命令，所有的数据库更改都可以一步到位地迁移过去，真的是太方便了。

## 附录

flyway的配置清单：

```xml
flyway.baseline-description对执行迁移时基准版本的描述.
flyway.baseline-on-migrate当迁移时发现目标schema非空，而且带有没有元数据的表时，是否自动执行基准迁移，默认false.
flyway.baseline-version开始执行基准迁移时对现有的schema的版本打标签，默认值为1.
flyway.check-location检查迁移脚本的位置是否存在，默认false.
flyway.clean-on-validation-error当发现校验错误时是否自动调用clean，默认false.
flyway.enabled是否开启flywary，默认true.
flyway.encoding设置迁移时的编码，默认UTF-8.
flyway.ignore-failed-future-migration当读取元数据表时是否忽略错误的迁移，默认false.
flyway.init-sqls当初始化好连接时要执行的SQL.
flyway.locations迁移脚本的位置，默认db/migration.
flyway.out-of-order是否允许无序的迁移，默认false.
flyway.password目标数据库的密码.
flyway.placeholder-prefix设置每个placeholder的前缀，默认${.
flyway.placeholder-replacementplaceholders是否要被替换，默认true.
flyway.placeholder-suffix设置每个placeholder的后缀，默认}.
flyway.placeholders.[placeholder name]设置placeholder的value
flyway.schemas设定需要flywary迁移的schema，大小写敏感，默认为连接默认的schema.
flyway.sql-migration-prefix迁移文件的前缀，默认为V.
flyway.sql-migration-separator迁移脚本的文件名分隔符，默认__
flyway.sql-migration-suffix迁移脚本的后缀，默认为.sql
flyway.tableflyway使用的元数据表名，默认为schema_version
flyway.target迁移时使用的目标版本，默认为latest version
flyway.url迁移时使用的JDBC URL，如果没有指定的话，将使用配置的主数据源
flyway.user迁移数据库的用户名
flyway.validate-on-migrate迁移时是否校验，默认为true

```

## 参考

[Flyway快速上手教程](https://www.jianshu.com/p/567a8a161641)
