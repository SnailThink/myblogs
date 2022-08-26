## Spirng Boot—JPA

> 作者：知否派
> 博客地址: [https://snailthink.github.io/myblogs](https://snailthink.github.io/myblogs)
> 项目地址：[spring-boot-learning](https://gitee.com/VincentBlog/spring-boot-learning.git)
> 文章所涉及的资料来自互联网整理和个人总结，意在于个人学习和经验汇总，如有什么地方侵权，请联系本人删除，谢谢！

### 一、什么是JPA

[JPA](https://so.csdn.net/so/search?q=JPA&spm=1001.2101.3001.7020) 即Java Persistence API。

JPA 是一个基于O/R映射的标准规范（目前最新版本是JPA 2.1 ）。所谓规范即只定义标准规则（如注解、接口），不提供实现，软件提供商可以按照标准规范来实现，而使用者只需按照规范中定义的方式来使用，而不用和软件提供商的实现打交道.

JPA的出现有两个原因：

- 简化现有Java EE和Java SE应用的对象持久化的开发工作；
- Sun希望整合对ORM技术，实现持久化领域的。

### 二、Spirng Boot 集成JPA

#### 2.1 引入依赖

```xml
<dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>

        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>cn.hutool</groupId>
            <artifactId>hutool-all</artifactId>
        </dependency>

        <dependency>
            <groupId>com.google.guava</groupId>
            <artifactId>guava</artifactId>
        </dependency>

        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
    </dependencies>
```

#### 2.2 配置数据库

```yml
server:
  port: 9110


spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/snailthink?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
    username: root
    password: 1q2w3e
    driver-class-name: com.mysql.cj.jdbc.Driver
    type: com.zaxxer.hikari.HikariDataSource
  jpa:
    show-sql: true # 配置在日志中打印出执行的 SQL 语句信息。
    hibernate:
      ddl-auto: create # 配置指明在程序启动的时候要删除并且创建实体类对应的表。这个参数很危险，因为他会把对应的表删除掉然后重建。所以千万不要在生成环境中使用。只有在测试环境中，一开始初始化数据库结构的时候才能使用一次。
      naming:
        physical-strategy: org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl # 驼峰转换
    database-platform: org.hibernate.dialect.MySQL5InnoDBDialect # 在 SrpingBoot 2.0 版本中，Hibernate 创建数据表的时候，默认的数据库存储引擎选择的是 MyISAM，将默认的存储引擎切换为 InnoDB

#logging:
#  level:
#    com.whcoding: debug
#    org.hibernate.SQL: debug #打印sql
#    org.hibernate.type: trace
   # org.hibernate.engine.QueryParameters: debug
    # org.hibernate.engine.query.HQLQueryPlan: debug

```

#### 2.3 OrmDeptPO

**实体类字段说明**

- `@Table` ：表名称
- `@Entity`: 实体类
- ` @Column` :表字段名称
- `@GeneratedValue` :ID生成策略

```
ID对应数据库表的主键，是保证唯一性的重要属性。JPA提供了以下几种ID生成策略

- GeneratorType.AUTO ，由JPA自动生成
- GenerationType.IDENTITY，使用数据库的自增长字段，需要数据库的支持（如SQL Server、MySQL、DB2、Derby等）
- GenerationType.SEQUENCE，使用数据库的序列号，需要数据库的支持（如Oracle）
- GenerationType.TABLE，使用指定的数据库表记录ID的增长 需要定义一个TableGenerator，在@GeneratedValue中引用。

@GeneratedValue(strategy = GenerationType.TABLE,generator=“myGenerator”)
@TableGenerator( name=“myGenerator”, table=“GENERATORTABLE”, pkColumnName = “ENTITYNAME”, pkColumnValue=“MyEntity”,   valueColumnName = “PKVALUE”, allocationSize=1 )
```



```java
package com.whcoding.jpa.pojo;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * (OrmDeptPO)表实体类
 *
 * @author makejava
 * @since 2022-03-22 11:31:14
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Accessors(chain=true) //链式写法
@Entity
@Table(name = "orm_dept")
@ToString(callSuper = true)
public class OrmDeptPO implements Serializable {

    /**
     * 主键
     */
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    /**
     * 部门id
     */
    @Basic
    @Column(name = "dept_id")
    private Integer deptId;
    /**
     * 部门编码
     */
    @Basic
    @Column(name = "dept_no")
    private String deptNo;
    /**
     * 部门类型 1,2,3
     */
    @Basic
    @Column(name = "dept_type")
    private Integer deptType;
    /**
     * 部门名称
     */
    @Basic
    @Column(name = "dept_name")
    private String deptName;
    /**
     * 创建时间
     */
    @Basic
    @Column(name = "create_time")
    private Date createTime;
    /**
     * 更新时间
     */
    @Basic
    @Column(name = "update_time")
    private Date updateTime;
    /**
     * 部门绩效
     */
    @Basic
    @Column(name = "dept_perf")
    private BigDecimal deptPerf;
    /**
     * 是否有效
     */
    @Basic
    @Column(name = "is_valid_flag")
    private Integer isValidFlag;
    /**
     * 部门简称
     */
    @Basic
    @Column(name = "short_name")
    private String shortName;
    /**
     * 备注
     */
    @Basic
    @Column(name = "remark")
    private String remark;

}
```

#### 2.4 DeptService

```java
package com.whcoding.jpa.service;

import com.whcoding.jpa.pojo.OrmDeptPO;

import java.util.List;

public interface DeptService {

    /**
     *
     * 新增数据
     * @param deptVO
     * @return
     */
    boolean addDept(OrmDeptPO deptVO);

    /**
     * 根据主键ID 查询数据
     * @param id
     * @return
     */
    OrmDeptPO queryDeptById(Integer id);

    /**
     * 根据DeptName 查询数据
     * @param deptName
     * @return
     */
    OrmDeptPO queryDeptByDeptName(String deptName);
    /**
     *
     * 查询list数据
     * @return
     */
    List<OrmDeptPO> queryAllDept();

    /**
     * 用户自定义SQL查询
     * @return
     */
    List<OrmDeptPO> queryDeptBySql();
}

```

#### 2.5 DeptServiceImpl

```java
package com.whcoding.jpa.service.impl;

import com.whcoding.jpa.dao.DeptDao;
import com.whcoding.jpa.pojo.OrmDeptPO;
import com.whcoding.jpa.service.DeptService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;

/**
 * @author Manager
 */
@Service
public class DeptServiceImpl implements DeptService {

	private static final Logger log = LoggerFactory.getLogger(DeptServiceImpl.class);

	@Autowired
	DeptDao deptDao;

	/***
	 *
	 * 1.新增
	 * @param deptVO
	 * @return
	 */
	@Override
	public boolean addDept(OrmDeptPO deptVO) {
		OrmDeptPO saveMode = deptDao.save(deptVO);
		return saveMode.getId() > 0;
	}

	/**
	 * 根据ID 查询数据
	 *
	 * @param id
	 * @return
	 */
	@Override
	public OrmDeptPO queryDeptById(Integer id) {
		Optional<OrmDeptPO> optional = deptDao.findById(id);
		if (optional.isPresent()) {
			return optional.get();
		}
		return new OrmDeptPO();
	}

	/**
	 * 根据DeptName 查询数据
	 *
	 * @param deptName
	 * @return
	 */
	@Override
	public OrmDeptPO queryDeptByDeptName(String deptName) {
		return deptDao.findOrmDeptByDeptName(deptName);
	}

	/**
	 * 查询全部数据
	 *
	 * @return
	 */
	@Override
	public List<OrmDeptPO> queryAllDept() {
		return deptDao.findAll();
	}

	/**
	 * 用户自定义sql 查询
	 *
	 * @return
	 */
	@Override
	public List<OrmDeptPO> queryDeptBySql() {
		//根据ID 获取dept
		OrmDeptPO deptVO = queryDeptById(1);
		if (StringUtils.isEmpty(deptVO.getDeptName())) {
			return null;
		}
		List<OrmDeptPO> deptReslutList = deptDao.queryDeptByName(deptVO.getDeptName());
		log.info("根据deptName获取到的数据为：" + deptReslutList.size());
		return deptReslutList;
	}
}

```

#### 2.6 DeptDao

```java
package com.whcoding.jpa.dao;

import com.whcoding.jpa.pojo.OrmDeptPO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Repository
public interface DeptDao extends JpaRepository<OrmDeptPO, Integer> {

	/**
	 * JPA 增加事务处理
	 *
	 * @param type
	 */
	@Transactional(rollbackFor = Exception.class)
	@Modifying
	@Query(value = "DELETE FROM orm_dept where dept_id = ?1 and is_valid_flag = 1", nativeQuery = true)
	void deleteOrmDeptVOByDeptId(Long type);

	/**
	 * 自定义SQL查询
	 * @param deptName
	 * @return
	 */
	@Query(value = "select * from orm_dept where dept_name=(:deptName)", nativeQuery = true)
	List<OrmDeptPO> queryDeptByName(@Param("deptName") String deptName);

	/**
	 * 根据DeptName 查询数据
	 *
	 * @param deptName
	 * @return
	 */
	OrmDeptPO findOrmDeptByDeptName(String deptName);
}

```

#### 2.7 DeptServiceImplTest 测试类

```java
package com.whcoding.jpa.service.impl;

import com.whcoding.jpa.DemoJpaApplicationTest;
import com.whcoding.jpa.dao.DeptDao;
import com.whcoding.jpa.pojo.OrmDeptPO;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Date;
import java.util.List;
import java.util.Optional;

public class DeptServiceImplTest extends DemoJpaApplicationTest {

	private static final Logger log = LoggerFactory.getLogger(DeptServiceImplTest.class);

	@Autowired
	DeptDao deptDao;

	/**
	 * 新增部门数据
	 */
	@Test
	public void addDept() {
		Optional<OrmDeptPO> optional = deptDao.findById(1);
		OrmDeptPO savePO=optional.get();
		savePO.setUpdateTime(new Date());
		deptDao.save(savePO);
	}

	/**
	 * 根据id查询数据
	 */
	@Test
	public void queryDeptById() {
		Optional<OrmDeptPO> optional = deptDao.findById(1);
		log.info("queryDeptByID 返回结果{}",optional.get());
	}

	/**
	 * 根据deptName 查询数据
	 */
	@Test
	public void queryDeptByDeptName() {
		OrmDeptPO ormDeptPO= deptDao.findOrmDeptByDeptName("客服部");
		log.info("据deptName 查询数据 返回结果{}",ormDeptPO);
	}

	/**
	 * 查询全部数据
	 */
	@Test
	public void queryAllDept() {
		List<OrmDeptPO> deptPOS= deptDao.findAll();
		log.info("queryAllDept 返回数量count={}",deptPOS.size());
	}

	/**
	 * 自定义sql 查询
	 */
	@Test
	public void queryDeptBySql() {
		deptDao.queryDeptByName("开发部");
	}
}

```

#### 2.8 启动类

```java
package com.whcoding.jpa;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @program: spring-boot-learning
 * @description:
 * @author: SnailThink
 * @create: 2021-10-25 18:31
 **/
@SpringBootApplication
public class DemoJpaApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoJpaApplication.class, args);
	}
}

```

#### 2.9 yml 配置

```yml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/snailthink?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
    username: root
    password: 1q2w3e
    driver-class-name: com.mysql.cj.jdbc.Driver
    type: com.zaxxer.hikari.HikariDataSource
  jpa:
    show-sql: true # 配置在日志中打印出执行的 SQL 语句信息。
    naming:
      physical-strategy: org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl # 默认驼峰转换

server:
  port: 9110


logging:
  level:
    com.whcoding: debug
    org.hibernate.SQL: debug #打印sql
    org.hibernate.type: trace
   # org.hibernate.engine.QueryParameters: debug
    # org.hibernate.engine.query.HQLQueryPlan: debug
```





### 三、总结

#### 1.JPA @Column 字段命名 默认驼峰转换

JPA @Column 字段命名 默认驼峰转换  如果数据库字段为非下划线命名则需要配置。

spring data jpa 使用的默认策略是 ImprovedNamingStrategy

所以修改配置下 hibernate 的命名策略就可以了

在application.properties文件中加入:

```yml
#PhysicalNamingStrategyStandardImpl
spring.jpa.hibernate.naming.physical-strategy=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
```

#### 2.Spring Data jpa方法命名规则

| 关键字            | 方法命名                       | sql where字句              |
| ----------------- | ------------------------------ | -------------------------- |
| And               | findByNameAndPwd               | where name= ? and pwd =?   |
| Or                | findByNameOrSex                | where name= ? or sex=?     |
| Is,Equals         | findById,findByIdEquals        | where id= ?                |
| Between           | findByIdBetween                | where id between ? and ?   |
| LessThan          | findByIdLessThan               | where id < ?               |
| LessThanEquals    | findByIdLessThanEquals         | where id <= ?              |
| GreaterThan       | findByIdGreaterThan            | where id > ?               |
| GreaterThanEquals | findByIdGreaterThanEquals      | where id > = ?             |
| After             | findByIdAfter                  | where id > ?               |
| Before            | findByIdBefore                 | where id < ?               |
| IsNull            | findByNameIsNull               | where name is null         |
| isNotNull,NotNull | findByNameNotNull              | where name is not null     |
| Like              | findByNameLike                 | where name like ?          |
| NotLike           | findByNameNotLike              | where name not like ?      |
| StartingWith      | findByNameStartingWith         | where name like '?%'       |
| EndingWith        | findByNameEndingWith           | where name like '%?'       |
| Containing        | findByNameContaining           | where name like '%?%'      |
| OrderBy           | findByIdOrderByXDesc           | where id=? orderVO by x desc |
| Not               | findByNameNot                  | where name <> ?            |
| In                | findByIdIn(Collection<?> c)    | where id in (?)            |
| NotIn             | findByIdNotIn(Collection<?> c) | where id not  in (?)       |
| True              | findByAaaTue                   | where aaa = true           |
| False             | findByAaaFalse                 | where aaa = false          |
| IgnoreCase        | findByNameIgnoreCase           | where UPPER(name)=UPPER(?) |

#### 3.JPA不被持久化字段

 一般使用后面两种方式比较多，推荐使用注解的方式。 

```java
public class OrmDeptVO implements Serializable {


static String transient1; // not persistent because of static

final String transient2 = "Satish"; // not persistent because of final

transient String transient3; // not persistent because of transient

@Transient
String transient4; // not persistent because of @Transient

}
```


#### 4.非主键实现自增
```java
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id",nullable=false,insertable=false,updatable=false,columnDefinition="numeric(19,0) IDENTITY")
    private Integer id;
```



#### 5.JPA打印SQL语句以及参数

```properties
# 打印JPA执行的SQL语句
spring.jpa.properties.hibernate.show_sql=true          //控制台是否打印
spring.jpa.properties.hibernate.format_sql=true        //格式化sql语句
spring.jpa.properties.hibernate.use_sql_comments=true  //指出是什么操作生成了该语句
 
logging.level.org.hibernate.type.descriptor.sql.BasicBinder=trace
```





### 参考

[Spring Data JPA](https://www.docs4dev.com/docs/zh/spring-data-jpa/1.11.18.RELEASE/reference/)

### 关注

如果大家想要实时关注我更新的文章以及分享的干货的话，可以关注我的公众号。

<img src="https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220507200900.jpg" style="zoom:50%;" />

