## 搭建项目



### 一.搭建Maven SpringCloud 总项目



#### 1.新建一个项目

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013155720.png)

#### 2.选择maven搭建项目

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013155756.png)



#### 3.搭建项目包名称以及项目名称



![](https://gitee.com/VincentBlog/image/raw/master/image/20211013155819.png)



#### 4.设置项目存放地址

提前在 F:\test\dev-project 文件夹下新建 springcloud 文件夹

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013155847.png)





![](https://gitee.com/VincentBlog/image/raw/master/image/20211013155846.png)

#### 5.查看项目结构

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013155923.png)

#### 6.删除多余文件

由于springcloud是父级项目则删src文件夹 删除后项目结构如下所示：

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013155924.png)



#### 7.配置pom文件作为总包统一管理

**注意**：使用dependencyManagement 统一管理

```java
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.snailthink</groupId>
    <artifactId>springcloud</artifactId>
    <version>1.0-SNAPSHOT</version>
    <modules>
        <module>springcloud-api</module>
        <module>springcloud-provide-dept-8001</module>
        <module>springcloud-consumer-dept-80</module>
        <module>springcloud-eureka-7001</module>
        <module>springcloud-eureka-7002</module>
        <module>springcloud-eureka-7003</module>
        <module>springcloud-provide-dept-8002</module>
        <module>springcloud-provide-dept-8003</module>
        <module>springcloud-consumer-dept-feign</module>
    </modules>

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


</project>

```



### 二、搭建api子模块

#### 1.新建一个model

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160020.png)



#### 2.选择maven构建

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160019.png)

#### 3.新建一个springcloud-api模块



![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160055.png)



#### 4.设计module 

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160056.png)



#### 5.查看项目结构

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160215.png)



#### 7.修改pom引入父级springcloud模板的依赖



```java
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>springcloud</artifactId>
        <groupId>com.snailthink</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>springcloud-api</artifactId>

    <!--单前Model 自己需要的依赖、如果父依赖以及配置就不用再写了-->
    <dependencies>

             
         <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!--热部署-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
        </dependency>
             
             
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
        </dependency>

    </dependencies>

</project>

```



#### 8.添加一个实体model



![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160154.png)



![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160244.png)



#### 9.添加一个pojo文件夹

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160243.png)



#### 10.添加DeptVO

```java
package com.snailthink.springcloud.pojo;



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
public class DeptVO implements Serializable {
	private Long id;
	private String deptno;

	private String dname;
	//这个数据库 存在哪个数据库的字段 微服务 ，一个服务对应一个数据库 同一个信息可能存在不同的数据库
	private String db_source;

	public DeptVO(String dname){
		this.dname=dname;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDeptno() {
		return deptno;
	}

	public void setDeptno(String deptno) {
		this.deptno = deptno;
	}

	public String getDname() {
		return dname;
	}

	public void setDname(String dname) {
		this.dname = dname;
	}

	public String getDb_source() {
		return db_source;
	}

	public void setDb_source(String db_source) {
		this.db_source = db_source;
	}

	/**
	 * 链式写法
	 * DeptVO deptVO =new DeptVO();
	 * deptVO.setDeptno(("123")).setDname("db数据库").setDb_source("Snailthink").setId(Long.valueOf("1"));
	 */
}
```



#### 11.添加application.yml 文件

```yml
# 端口号为8008
server:
  port: 8008

```



![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160406.png)



#### 12. 添加Dept_8008 启动类

```java
package com.snailthink.springcloud;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @program: springcloud
 * @description:
 * @author: SnailThink
 * @create: 2021-10-13 15:27
 **/
@SpringBootApplication
public class Dept_8008 {

	public static void main(String[] args) {
		SpringApplication.run(Dept_8008.class, args);
	}
}
```



![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160359.png)



#### 13.添加DeptController 

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160400.png)



```java
package com.snailthink.springcloud.controller;

import org.springframework.web.bind.annotation.*;

/**
 * @program: springcloud
 * @description:
 * @author: SnailThink
 * @create: 2021-10-13 15:35
 **/
@RestController
@RequestMapping("/dept")
public class DeptController {

	@GetMapping("/hello")
	public String helloStr() {
		return "hello world";
	}

	/**
	 * http://localhost:8008/dept/test?id=1
	 * @param id
	 * @return
	 */
	@GetMapping("/test")
	public String testStr(@RequestParam("id") Long id) {
		return "test"+id;
	}

	/**
	 * http://localhost:8008/dept/testRest/1
	 * @param id
	 * @return
	 */
	@GetMapping("/testRest/{id}")
	public String testRest(@PathVariable("id") Long id) {
		return "RESTful风格"+id;
	}

}

```



### 三、项目发布到github/gitee

#### 1.登录gitee 新建仓库



![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160401.png)



#### 2.创建仓库

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160402.png)



![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160403.png)



#### 3.部署项目到gitee

```linux
cd spring-cloud
git init
touch README.md 
git add README.md
git commit -m "first commit"
git remote add origin https://gitee.com/VincentBlog/spring-cloud.git
```

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160404.png)

#### 4.查看文件

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013181226.png)

### 四、搭建EurekaServe

#### 1.搭建Maven模块

![image-20211013181425389](https://gitee.com/VincentBlog/image/raw/master/image/20211013181425.png)



![image-20211013181458519](https://gitee.com/VincentBlog/image/raw/master/image/20211013181458.png)



![image-20211013181514245](https://gitee.com/VincentBlog/image/raw/master/image/20211013181514.png)

#### 2.修改springcloud-eureka-7001 pom文件

```java
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>springcloud</artifactId>
        <groupId>com.snailthink</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>springcloud-eureka-7001</artifactId>

    <dependencies>
        <!--eureka-server-->
        <!-- https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-starter-netflix-eureka-server -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
            <version>2.2.9.RELEASE</version>
        </dependency>
        <!--热部署-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
        </dependency>
    </dependencies>

</project>
```

#### 3.添加启动类

![image-20211013182411394](https://gitee.com/VincentBlog/image/raw/master/image/20211013182411.png)

```java
package com.snailthink.springcloud;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

/**
 * @program: springcloud
 * @description:
 * @author: SnailThink
 * @create: 2021-10-13 18:19
 **/
@SpringBootApplication
@EnableEurekaServer
public class EurekaServer_7001 {

	/**
	 * http://localhost:7001/  启动项目EurekaServe
	 *
	 * @param args
	 */
	public static void main(String[] args) {
		SpringApplication.run(EurekaServer_7001.class, args);
	}
}
```

#### 4.添加yml文件

```yml
server:
  port: 7001

# eureka 配置
eureka:
  instance:
    hostname: localhost #Eureka 服务端的实例名称
  client:
    register-with-eureka: false #表示是否向Eureka注册中心注册自己
    fetch-registry: false #fetch-registry 为false 表示自己为注册中心
    service-url: #监控页面  默认："defaultZone", "http://localhost:8761/eureka/"
      # 单机：defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
      # 集群(关联)：defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/，
      # 集群(关联)eg：defaultZone: http://localhost:7002/eureka/，http://localhost:7003/eureka/
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/

```

#### 5.运行项目

![image-20211013182739932](https://gitee.com/VincentBlog/image/raw/master/image/20211013182740.png)



### 五、搭建服务提供者 springcloud-provide-8001

#### 1.搭建maven模块

![image-20211013183218015](https://gitee.com/VincentBlog/image/raw/master/image/20211013183218.png)





![image-20211013183235398](https://gitee.com/VincentBlog/image/raw/master/image/20211013183235.png)



#### 2.修改pom文件

```yml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>springcloud</artifactId>
        <groupId>com.snailthink</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>springcloud-provide-8001</artifactId>


    <dependencies>

        <!-- https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-starter-eureka -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-eureka</artifactId>
            <version>1.4.6.RELEASE</version>
        </dependency>

        <!--完善监控信息 修改state 页面跳转-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-actuator</artifactId>
        </dependency>
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
        <!--jetty 类似tomcat-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jetty</artifactId>
        </dependency>

        <!--热部署工具-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
        </dependency>

    </dependencies>

</project>

```

#### 4.添加启动类

```java
package com.snailthink.springcloud;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

@SpringBootApplication
@EnableEurekaClient //配置客户端 注册到Eureka
public class DeptProvider_8001 {
    public static void main(String[] args) {
        SpringApplication.run(DeptProvider_8001.class, args);
    }
}
```



#### 5.添加yml文件

```yml
server:
  port: 8001

# mybatis 配置
mybatis:
  type-aliases-package: com.snailthink.springcloud.pojo
  #config-location: classpath:mybatis/mybatis-config.xml #Mybatis 的核心配置
  mapper-locations: classpath:mybatis/mapper/*.xml
  configuration:
    map-underscore-to-camel-case: true #配置驼峰大小写转换

#Spring 配置
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/snailthink?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
    username: root
    password: 1q2w3e
    driver-class-name: org.gjt.mm.mysql.Driver
    type: com.alibaba.druid.pool.DruidDataSource
  application:
    name: springcloud-provide-dept


#Eureka 配置
eureka:
  client:
    service-url:
      defaultZone: http://localhost:7001/eureka/
  instance:
    instance-id: springcloud-provide-dept8001  # 修改eureka 上Status展示的描述信息.

info:
  app.name: snailthink-springcloud
  company.name: bolg.snailthink.com
  author: snailthink
```



#### 6.添加Controller

```java
package com.snailthink.springcloud.controller;

import com.snailthink.springcloud.pojo.DeptVO;
import com.snailthink.springcloud.service.DeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;

//提供Restful 服务
@RestController
@RequestMapping("/dept")
public class DeptController {

    @Autowired
    private DeptService deptService;

    @Autowired
    DiscoveryClient discoveryClient;


    /**
     * http://localhost:8001/dept/connectStr?str=张三
     * 1.测试接口的联通性
     * @param str
     * @return
     */
    @GetMapping("/connectStr")
    public String connectStr(@RequestParam("str") String str) {
        return "hello：" + str;
    }

    /**
     *
     * http://localhost:8001/dept/connect/张三
     *
     * 2.测试接口的联通性
     * RESTful 风格
     * @param str
     * @return
     */
    @GetMapping("/connect/{str}")
    public String connect(@PathVariable("str") String str) {
        return "hello：" + str;
    }


    @PostMapping("/add")
    public boolean addDept(DeptVO deptVO) {
        return deptService.addDept(deptVO);
    }

    /**
     * http://localhost:8001/dept/queryDeptById/1
     * @param id
     * @return
     */
    @GetMapping("/queryDeptById/{id}")
    public DeptVO queryDeptById(@PathVariable("id") Long id) {
        return deptService.queryDeptById(id);
    }

    @GetMapping("/queryAllDept")
    public List<DeptVO> queryAllDept() {
        return deptService.queryAllDept();
    }


    //注册进来的微服务 获取一些信息
    @GetMapping("/discovery")
    public Object discovery(){
		//获取微服务列表的清单
        List<String> services=discoveryClient.getServices();
        System.out.println("discovery=>services:"+services);

        //得到一个具体的微服务信息、通过具体的服务id application
        List<ServiceInstance> instances=discoveryClient.getInstances("SPRINGCLOUD-PROVIDE-DEPT");
        for (ServiceInstance instance : instances) {
            System.out.println(
                    instance.getHost()+"\t"+ //主机地址
                    instance.getPort()+"\t"+ //端口
                    instance.getUri()+"\t"+ //URL
                    instance.getServiceId()+"\t" //服务名
            );
        }
        return  this.discoveryClient;
    }
}

```



#### 7.添加dao

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

#### 8.添加service

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

#### 9.添加实现impl

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

#### 10. 添加mybatis文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.snailthink.springcloud.dao.DeptDao">
    <!--add -->
    <insert id="addDept" parameterType="com.snailthink.springcloud.pojo.DeptVO">
      INSERT INTO `snailthink`.`dept`( `db_source`, `dept_name`)
       VALUES ( #{db_source}, #{dname} );
    </insert>

    <select id="queryDeptById" resultType="com.snailthink.springcloud.pojo.DeptVO" parameterType="long">
        SELECT dept_no AS deptno,dept_name AS dname ,db_source AS db_source FROM dept WHERE id=#{id} ;
    </select>

    <select id="queryAllDept" resultType="com.snailthink.springcloud.pojo.DeptVO" >
        SELECT dept_no AS deptno,dept_name AS dname ,db_source AS db_source FROM dept
    </select>
</mapper>

```

#### 11.运行项目访问

[测试接口联通性](http://localhost:8001/dept/connect/132)

[测试接口联通性](http://localhost:8001/dept/connectStr?str=AAA)

![image-20211013185115702](https://gitee.com/VincentBlog/image/raw/master/image/20211013185115.png)





#### 12.调用接口获取数据

[根据ID查询数据](http://localhost:8001/dept/queryDeptById/1)

![image-20211013185731013](https://gitee.com/VincentBlog/image/raw/master/image/20211013185731.png)

#### 13.查询注册中心

我们发现**springcloud-provide-8001** 已经注册到EurekaServe 上了

![image-20211013185811786](https://gitee.com/VincentBlog/image/raw/master/image/20211013185811.png)



#### 14. 查看项目层级目录

![image-20211013190257106](https://gitee.com/VincentBlog/image/raw/master/image/20211013190257.png)

### 六、搭建服务消费者   springcloud-consumer-dept-9001 

#### 1.搭建maven模块

![image-20211013192313693](https://gitee.com/VincentBlog/image/raw/master/image/20211013192313.png)



#### 2.修改pom文件

```java
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>springcloud</artifactId>
        <groupId>com.snailthink</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>springcloud-consumer-dept-feign-9001</artifactId>

    <!--实体类modle-->
    <dependencies>

        <!--使用Feign-->
        <!-- https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-starter-feign -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-feign</artifactId>
            <version>1.4.7.RELEASE</version>
        </dependency>

        <!-- https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-starter-eureka -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-eureka</artifactId>
            <version>1.4.6.RELEASE</version>
        </dependency>

        <dependency>
            <groupId>com.snailthink</groupId>
            <artifactId>springcloud-api</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
        </dependency>
    </dependencies>

</project>
```

#### 3.添加yml文件

```yml
server:
  port: 9001

# eureka 配置
eureka:
  client:
    register-with-eureka: false #表示是否向Eureka注册中心注册自己
    service-url: #监控页面  默认："defaultZone", "http://localhost:8761/eureka/"
      # 单机：defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
      # 集群(关联)：defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/，
      # 集群(关联)eg：defaultZone: http://localhost:7002/eureka/，http://localhost:7003/eureka/
      defaultZone: http://localhost:7001/eureka/

```

#### 4.添加启动类

```java
package com.snailthink.springcloud;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.cloud.openfeign.EnableFeignClients;

/**
 * @program: springcloud
 * @description:
 * @author: SnailThink
 * @create: 2021-10-13 19:24
 **/
@SpringBootApplication
@EnableEurekaClient //配置客户端 注册到Eureka
@EnableFeignClients(basePackages = {"com.snailthink.springcloud"}) //哪些包下面的注解要被扫描
public class FeginDeptConsumer_9001 {

	//Ribbon 和Eureka 整合后 可以直接调用，不用关系IP地址和端口号
	public static void main(String[] args) {
		SpringApplication.run(FeginDeptConsumer_9001.class, args);
	}
}

```

#### 5.API模块添加Feign



##### 1.添加Feign依赖

```java
        <!-- https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-starter-feign -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-feign</artifactId>
            <version>1.4.7.RELEASE</version>
        </dependency>

```

##### 2.添加server

```java

package com.snailthink.springcloud.server;

import com.snailthink.springcloud.pojo.DeptVO;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

/**
 * DeptServer API
 */
@Component
@FeignClient(value = "SPRINGCLOUD-PROVIDE-DEPT")
public interface DeptClientServer {

	/**
	 * 增加dept
	 * @param deptVO
	 * @return
	 */
	@PostMapping("dept/add")
	boolean addDept(DeptVO deptVO);

	/**
	 * 根据主键ID 查询dept
	 * @param id
	 * @return
	 */
	@GetMapping("dept/queryDeptById/{id}")
	DeptVO queryDeptById(@PathVariable("id") Long id);

	/**
	 * 查询dept 全部数据
	 * @return
	 */
	@GetMapping("dept/queryAllDept")
	List<DeptVO> queryAllDept();

}

```

#### 6.添加Controller

```java
package com.snailthink.springcloud.controller;

import com.snailthink.springcloud.pojo.DeptVO;
import com.snailthink.springcloud.server.DeptClientServer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @program: springcloud
 * @description: 消费者
 * @author: SnailThink
 * @create: 2021-10-11 15:52
 **/
@RestController
public class DeptConsumerController {

	//消费者不应该有Service 层
	//restTemplate ... 供我们直接调用就可以！注册到Spring中
	//(URL，实体：Map，Class<T> responseType)
	//http://localhost:8009/consumer/dept/list

	@Autowired
	private DeptClientServer deptServer = null;

	@GetMapping("consumer/dept/hello")
	public String helloStr() {
		return "hello World";
	}


	@RequestMapping("consumer/dept/add")
	public boolean add(DeptVO deptVO) {
		return this.deptServer.addDept(deptVO);
	}

	@RequestMapping("consumer/dept/get/{id}")
	public DeptVO get(@PathVariable("id") Long id) {
		return this.deptServer.queryDeptById(id);
	}

	@RequestMapping("consumer/dept/list")
	public List<DeptVO> list() {
		return this.deptServer.queryAllDept();
	}
}

```



#### 7.服务调用测试



[服务调用](http://localhost:9001/consumer/dept/get/1)

![image-20211013193755057](https://gitee.com/VincentBlog/image/raw/master/image/20211013193755.png)

#### 8.服务调用说明



![image-20211013194210544](https://gitee.com/VincentBlog/image/raw/master/image/20211013194210.png)



- 首先需要启动Eureka-Server 注册中心
- 将服务提供着provide-8001 注册到服务中心上
- 服务消费者根据服务名称访问Eureka 获取到服务提供者进行远程调用。



### 七、Hystrix服务熔断



#### 1.搭建maven模块

![image-20211015143315203](https://gitee.com/VincentBlog/image/raw/master/image/20211015143315.png)

![image-20211015143333389](https://gitee.com/VincentBlog/image/raw/master/image/20211015143333.png)



#### 2.修改pom依赖

**主要使用**

```xml
  <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
            <version>1.4.6.RELEASE</version>
        </dependency>
```

**完整xml文件**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>springcloud</artifactId>
        <groupId>com.snailthink</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>springcloud-provide-dept-hystrix-6001</artifactId>

    <dependencies>

        <!-- https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-starter-eureka -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-eureka</artifactId>
            <version>1.4.6.RELEASE</version>
        </dependency>

        <!-- hystrix -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
            <version>1.4.6.RELEASE</version>
        </dependency>

        <!--完善监控信息 修改state 页面跳转-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-actuator</artifactId>
        </dependency>
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
        <!--jetty 类似tomcat-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jetty</artifactId>
        </dependency>

        <!--热部署工具-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
        </dependency>

    </dependencies>

</project>
```

#### 3.添加启动类

```java
package com.snailthink.springcloud;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.circuitbreaker.EnableCircuitBreaker;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

@SpringBootApplication
@EnableEurekaClient //配置客户端 注册到Eureka
@EnableDiscoveryClient //获取discovery 数据 服务发现
@EnableCircuitBreaker //添加对熔断的支持
public class HystrixDeptProvider_6001 {
    public static void main(String[] args) {
        SpringApplication.run(HystrixDeptProvider_6001.class, args);
    }
}

```

#### 4.添加yml文件

```java
server:
  port: 6001

# mybatis 配置
mybatis:
  type-aliases-package: com.snailthink.springcloud.pojo
  #config-location: classpath:mybatis/mybatis-config.xml #Mybatis 的核心配置
  mapper-locations: classpath:mybatis/mapper/*.xml
  configuration:
    map-underscore-to-camel-case: true #配置驼峰大小写转换

#Spring 配置
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/snailthink?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
    username: root
    password: 1q2w3e
    driver-class-name: org.gjt.mm.mysql.Driver
    type: com.alibaba.druid.pool.DruidDataSource
  application:
    name: springcloud-provide-dept


#Eureka 配置
eureka:
  client:
    service-url:
      defaultZone: http://localhost:7001/eureka/
  instance:
    instance-id: springcloud-provide-dept-hystrix6001  # 修改eureka 上Status展示的描述信息.
    prefer-ip-address: true # 可以显示服务器的Ip

info:
  app.name: snailthink-springcloud
  company.name: bolg.snailthink.com
  author: snailthink

```

#### 5.修改Controller

```java
package com.snailthink.springcloud.controller;

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import com.snailthink.springcloud.pojo.DeptVO;
import com.snailthink.springcloud.service.DeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
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


	/**
	 * http://localhost:6001/dept/queryDeptById/1
	 * 失败时候调用 hystrixGet 方法
	 * @param id
	 * @return
	 */
	@GetMapping("dept/queryDeptById/{id}")
	@HystrixCommand(fallbackMethod = "hystrixGet") //失败时候调用 hystrixGet
	public DeptVO queryDeptById(@PathVariable("id") Long id) {

		DeptVO deptVO = deptService.queryDeptById(id);
		if (deptVO == null) {
			throw new RuntimeException("id=>" + id + "，不存在该用户、或者用户没有找到");
		}
		return deptService.queryDeptById(id);
	}

	public DeptVO hystrixGet(@PathVariable("id") Long id) {
		return new DeptVO().setId(null).setDb_source("not this database in mysql").setDname("id=>" + id + "没有对应的信息，null--@Hystrix");
	}

	@GetMapping("dept/queryAllDept")
	public List<DeptVO> queryAllDept() {
		return deptService.queryAllDept();
	}


}

```

## 八、服务降级

#### 1.springcloud-api

**添加服务降级Server的工厂方法**

```java
package com.snailthink.springcloud.server;

import com.snailthink.springcloud.pojo.DeptVO;
import feign.hystrix.FallbackFactory;

import java.util.List;

/**
 * @program: springcloud
 * @description: 服务降级
 * @author: SnailThink
 * @create: 2021-10-15 15:40
 **/
public class DeptClientServerFallBackFactory implements FallbackFactory {
	@Override
	public DeptClientServer create(Throwable throwable) {
		return new DeptClientServer() {
			@Override
			public boolean addDept(DeptVO deptVO) {
				return false;
			}

			/**
			 * 对queryDeptById 方法执行服务降级 其他方法一样的 操作
			 * @param id
			 * @return
			 */
			@Override
			public DeptVO queryDeptById(Long id) {
				return new DeptVO().setId(id).setDb_source("not this database in mysql").
						setDname("id=>" + id + "没有对应的信息，客户端口提供了降级信息，这个服务已经被关闭");
			}

			@Override
			public List<DeptVO> queryAllDept() {
				return null;
			}
		};
	}
}

```

**在Server中增加服务降级注解和工厂关联**



```java
package com.snailthink.springcloud.server;

import com.snailthink.springcloud.pojo.DeptVO;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

/**
 * DeptServer API
 */
@Component
@FeignClient(value = "SPRINGCLOUD-PROVIDE-DEPT",fallbackFactory = DeptClientServerFallBackFactory.class) //服务降级操作调用工厂实现
public interface DeptClientServer {

	/**
	 * 增加dept
	 * @param deptVO
	 * @return
	 */
	@PostMapping("dept/add")
	boolean addDept(DeptVO deptVO);

	/**
	 * 根据主键ID 查询dept
	 * @param id
	 * @return
	 */
	@GetMapping("dept/queryDeptById/{id}")
	DeptVO queryDeptById(@PathVariable("id") Long id);

	/**
	 * 查询dept 全部数据
	 * @return
	 */
	@GetMapping("dept/queryAllDept")
	List<DeptVO> queryAllDept();
}

```

#### 2.dept-feign中开启服务降级

**开启服务降级**

```java
# 开启服务降级
feign:
  hystrix:
    enabled: true
```



#### 3.启动服务

```
1.启动eurekaserve-7001
2.启动服务端provide-dept-8001
3.启动客户端consumer-dept-feign
```





##  九、服务监控



~~~java

1.添加引用

```java
  <!--Hystrix依赖-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-hystrix</artifactId>
            <version>1.4.6.RELEASE</version>
        </dependency>
        <!--dashboard依赖-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-hystrix-dashboard</artifactId>
            <version>1.4.6.RELEASE</version>
        </dependency>
```


2.主启动类增加如下
```java
@SpringBootApplication
@EnableEurekaClient //EnableEurekaClient 客户端的启动类，在服务启动后自动向注册中心注册服务
public class DeptProvider_8001 {
    public static void main(String[] args) {
        SpringApplication.run(DeptProvider_8001.class,args);
    }

    //增加一个 Servlet
    @Bean
    public ServletRegistrationBean hystrixMetricsStreamServlet(){
        ServletRegistrationBean registrationBean = new ServletRegistrationBean(new HystrixMetricsStreamServlet());
        //访问该页面就是监控页面
        registrationBean.addUrlMappings("/actuator/hystrix.stream");
       
        return registrationBean;
    }
}

```
~~~



**访问http://localhost:8008/hystrix**



![image-20211015171928197](https://gitee.com/VincentBlog/image/raw/master/image/20211015171929.png)





进入监控页面：http://localhost:8001/actuator/hystrix.stream

![image-20211015171958361](https://gitee.com/VincentBlog/image/raw/master/image/20211015171958.png)

**效果如下图：**



![img](https://img-blog.csdnimg.cn/20201121162612484.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzU5MTk4MA==,size_16,color_FFFFFF,t_70#pic_center)