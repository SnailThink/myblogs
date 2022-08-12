## Spring Cloud—Rest环境搭建

## 前言

> **Spring Cloud是基于HTTP的REST方式调用的**,带领大家进行**基于Spring Clou的Rest环境的搭建**，更加了解 **Spring Cloud**的特性。

### 1.创建Maven父项目，并编写pom.xml

![image-20220811191136630](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220811191136630.png)

![image-20220811180032295](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220811180032295.png)



![image-20220811191214550](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220811191214550.png)



```xml

	 <!--打包方式  pom-->
    <packaging>pom</packaging>

    <!--版本号-->
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <junit.version>4.12</junit.version>
        <log4j.version>1.2.17</log4j.version>
        <lombok.version>1.16.18</lombok.version>
    </properties>

    <dependencyManagement>
        <dependencies>
            <!--SpringCloud alibaba 依赖-->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-alibaba-dependencies</artifactId>
                <version>0.2.0.RELEASE</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <!--springCloud的依赖-->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>Greenwich.SR1</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <!--SpringBoot-->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-dependencies</artifactId>
                <version>2.1.4.RELEASE</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <!--数据库-->
            <dependency>
                <groupId>mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
                <version>5.1.47</version>
            </dependency>
            <dependency>
                <groupId>com.alibaba</groupId>
                <artifactId>druid</artifactId>
                <version>1.1.10</version>
            </dependency>
            <!--SpringBoot 启动器-->
            <dependency>
                <groupId>org.mybatis.spring.boot</groupId>
                <artifactId>mybatis-spring-boot-starter</artifactId>
                <version>1.3.2</version>
            </dependency>

            <!--日志测试-->
            <dependency>
                <groupId>ch.qos.logback</groupId>
                <artifactId>logback-core</artifactId>
                <version>1.2.3</version>
            </dependency>
            <dependency>
                <groupId>junit</groupId>
                <artifactId>junit</artifactId>
                <version>${junit.version}</version>
            </dependency>
            <dependency>
                <groupId>log4j</groupId>
                <artifactId>log4j</artifactId>
                <version>${log4j.version}</version>
            </dependency>
            <dependency>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <version>${lombok.version}</version>
            </dependency>
        </dependencies>
    </dependencyManagement>

```

### 2.建立子Module

****同样以Maven形式创建。****

**建立三个Maven子项目，目录如下**

- springcloud-api
- springcloud-provide-dept-8001
- springcloud-consumer-dept-7001



![image-20220811191422390](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220811191422390.png)



### 3.配置springcloud-api

> 我们把**实体类**放在**springcloud-api**中。

**1）导入依赖**

```xml
	<dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
    </dependency>
```



**2.建立如下目录**

![image-20220811192103160](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220811192103160.png)

**3.编写实体类Blog**

```java
package com.snailthink.springcloud.pojo;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

import java.io.Serializable;

/**
 * @program: springcloud
 * @description:
 * @author: SnailThink
 * @create: 2021-10-09 18:45
 **/

//所有的实体类必须实现序列化
@Data
@NoArgsConstructor
@Accessors(chain=true) //链式写法
public class DeptVO implements Serializable {
	private Long id;
	private String deptno;

	private String dname;
	//这个数据库 存在哪个数据库的字段 微服务 ，一个服务对应一个数据库 同一个信息可能存在不同的数据库
	private String db_source;

	public DeptVO(String dname){
		this.dname=dname;
	}

	/**
	 * 链式写法
	 * DeptVO deptVO =new DeptVO();
	 * deptVO.setDeptno(("123")).setDname("db数据库").setDb_source("Snailthink").setId(Long.valueOf("1"));
	 */
}
```

### 4.配置springcloud-provide-dept-8001

> springcloud-provide-dept-8001：是我们的**服务提供方。**

**1.导入依赖**

```xml
    <dependencies>

        <!--需要实体类 所以要配置api-model-->
        <dependency>
            <groupId>com.snailthink</groupId>
            <artifactId>springcloud-api</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>

        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
        </dependency>

        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>

        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid</artifactId>
        </dependency>

        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-core</artifactId>
        </dependency>

        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
        </dependency>
        <!--test-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-test</artifactId>
        </dependency>
        
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        

        <!--热部署工具-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
        </dependency>

    </dependencies>
```

**2.目录如下**

![image-20220811192304877](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220811192304877.png)

**3.编写启动类**

```java
package com.snailthink.springcloud;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DeptProvider_8001 {
    
    public static void main(String[] args) {
        SpringApplication.run(DeptProvider_8001.class, args);
    }
}
```

**4.编写application.yml**

```yml
server:
  port: 8001
  
# mybatis 配置
mybatis:
  # springcloud-api 模块下的pojo包
  type-aliases-package: com.snailthink.springcloud.pojo
  #config-location: classpath:mybatis/mybatis-config.xml #Mybatis 的核心配置
  # 本模块下的mapper配置文件类路径
  mapper-locations: classpath:mybatis/mapper/*.xml
  configuration:
    map-underscore-to-camel-case: true #配置驼峰大小写转换
 
spring:
  application:
    name: springcloud-provider-dept
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://127.0.0.1:3306/snailthink?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&useSSL=false
    username: root
    password: 1q2w3e
    driver-class-name: org.gjt.mm.mysql.Driver
    # 德鲁伊数据源
    type: com.alibaba.druid.pool.DruidDataSource

```

**5.编写dao deptDao**

```java
package com.snailthink.springcloud.dao;

import com.snailthink.springcloud.pojo.DeptVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface DeptDao {

    boolean addDept(DeptVO deptVO);

    DeptVO queryDeptById(@Param("id") Long id);

    List<DeptVO> queryAllDept();
}

```

**6.编写DeptMapper.xml文件**

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.snailthink.springcloud.dao.DeptDao">
    <!--add -->
    <insert id="addDept" parameterType="com.snailthink.springcloud.pojo.DeptVO">
      INSERT INTO `snailthink`.`orm_dept`( `db_source`, `dept_name`)
       VALUES ( #{db_source}, #{dname} );
    </insert>

    <select id="queryDeptById" resultType="com.snailthink.springcloud.pojo.DeptVO" parameterType="long">
        SELECT dept_no AS deptno,dept_name AS dname ,remark AS db_source FROM orm_dept WHERE id=#{id} ;
    </select>

    <select id="queryAllDept" resultType="com.snailthink.springcloud.pojo.DeptVO" >
        SELECT dept_no AS deptno,dept_name AS dname ,remark AS db_source FROM orm_dept
    </select>
</mapper>

```

**7.编写接口DeptService**

```java
package com.snailthink.springcloud.service;

import com.snailthink.springcloud.pojo.DeptVO;

import java.util.List;

public interface DeptService {

    boolean addDept(DeptVO deptVO);

    DeptVO queryDeptById(Long id);

    List<DeptVO> queryAllDept();
}

```

**8.编写DeptServiceImpl**

```java
package com.snailthink.springcloud.service.impl;

import com.snailthink.springcloud.dao.DeptDao;
import com.snailthink.springcloud.pojo.DeptVO;
import com.snailthink.springcloud.service.DeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DeptServiceImpl implements DeptService {

    @Autowired
    private DeptDao dao;

    @Override
    public boolean addDept(DeptVO deptVO) {
        return dao.addDept(deptVO);
    }

    @Override
    public DeptVO queryDeptById(Long id) {
        return dao.queryDeptById(id);
    }

    @Override
    public List<DeptVO> queryAllDept() {
        return dao.queryAllDept();
    }
}
```

**9.编写controller**

```java
package com.snailthink.springcloud.controller;

import com.snailthink.springcloud.pojo.DeptVO;
import com.snailthink.springcloud.service.DeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

//提供Restful 服务
@RestController
public class DeptController {

    @Autowired
    private DeptService deptService;

    @PostMapping("dept/add")
    public boolean addDept(DeptVO deptVO) {
        return deptService.addDept(deptVO);
    }

    /**
     * http://localhost:8001/dept/queryDeptById/1
     * @param id
     * @return
     */
    @GetMapping("dept/queryDeptById/{id}")
    public DeptVO queryDeptById(@PathVariable("id") Long id) {
        return deptService.queryDeptById(id);
    }

    @GetMapping("dept/queryAllDept")
    public List<DeptVO> queryAllDept() {
        return deptService.queryAllDept();
    }
}

```

**10.运行项目**

http://localhost:8001/dept/queryDeptById/1

![image-20220811195212187](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220811195212187.png)

### 5.springcloud-consumer-dept-7001

> springcloud-consumer-dept-7001：是我们的**服务调用方。**服务调用方是没有service层的

**1.导入依赖**

```xml

    <!--实体类modle-->
    <dependencies>
        <dependency>
            <groupId>com.snailthink</groupId>
            <artifactId>springcloud-api</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
		<!--热部署-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
        </dependency>
    </dependencies>
```



**2.查看项目结构**

![image-20220811194603564](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220811194603564.png)



**3.编写yml文件**

```yml
server:
  port: 8006
```



**4.编写启动类**

```java
package com.snailthink.springcloud;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @program: springcloud
 * @description:
 * @author: SnailThink
 * @create: 2021-10-11 17:29
 **/
@SpringBootApplication
public class DeptConsumer_80 {

	public static void main(String[] args) {
		SpringApplication.run(DeptConsumer_80.class, args);
	}
}

```



**5.编写controller**

```java
package com.snailthink.springcloud.controller;

import com.snailthink.springcloud.pojo.DeptVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.util.List;

/**
 * @program: springcloud
 * @description: 消费者
 * @author: SnailThink
 * @create: 2021-10-11 15:52
 **/
@RestController
public class DeptConsumerController {


	@Autowired
	private RestTemplate restTemplate;


	private static final String REST_URL_PERFIX = "http://localhost:8001";


	@RequestMapping("consumer/dept/add")
	public boolean add(DeptVO deptVO) {
		return restTemplate.postForObject(REST_URL_PERFIX + "/dept/add", deptVO, Boolean.class);
	}

	/**
	 * 访问地址：http://localhost:8006/consumer/dept/get/1
	 * @param id
	 * @return
	 */
	@RequestMapping("consumer/dept/get/{id}")
	public DeptVO get(@PathVariable("id") Long id) {
		return restTemplate.getForObject(REST_URL_PERFIX + "/dept/queryDeptById/" + id, DeptVO.class);
	}

	@RequestMapping("consumer/dept/list")
	public List<DeptVO> list() {
		return restTemplate.getForObject(REST_URL_PERFIX + "/dept/queryAllDept", List.class);
	}
}

```



**6.编写ConfigBean**

> a、由于Spring Cloud是基于HTTP的REST方式进行调用，所以我们这里需要使用到一个类RestTemplate，其可以提供多种便捷访问远程http服务的方法，简单的Restful服务模板。
>
> b、但是RestTemplate并没有注入到Spring中，所以才需要我们自己编写配置类注册到**Spring中**。

```java
package com.snailthink.springcloud.config;

import com.netflix.loadbalancer.IRule;
import com.netflix.loadbalancer.RandomRule;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

/**
 * @program: springcloud
 * @description:
 * @author: SnailThink
 * @create: 2021-10-11 17:26
 **/
@Configuration
public class ConfigBean {

	//@Configuration --Spring applicationContext.xml  注册到spring bean 中
	//配置负载均衡
	//IRULE  ：默认采用轮循
	//RoundRobinRule 轮循
	//RandomRule 随机
	//AvailabilityFilteringRule ：会先过滤掉 故障 的服务、对剩下的服务进行轮循
	//RetryRule 先按照轮循获取服务、如果服务获取失败 则会在短时间内进行重试
	@Bean
	public RestTemplate getRestTemplate() {
		return new RestTemplate();
	}
}

```



**7.测试REST调用**



> 服务启动顺序为：springcloud-provide-dept=》springcloud-consumer-dept



http://localhost:8006/consumer/dept/get/1

![image-20220811195246319](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220811195246319.png)

### 6.回顾

> 进行到这一步，我们**基于Spring Cloud的REST环境搭建**就已经**成功了！**我们来看下各个子项目分别都执行了什么功能。

- springcloud-api 存放实体类
- springcloud-provide-dept-8001：***\*服务提供方，负责与数据库进行交互\****，dao层和service层都在这个子项目中。
- springcloud-consumer-dept-7001 ：***\*消费方，只需负责对请求的调用\**。**

服务方与消费方之间通过***\*RestTemplate\**** 进行调用
