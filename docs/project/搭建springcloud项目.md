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

![](https://gitee.com/VincentBlog/image/raw/master/image/20211013160405.png)