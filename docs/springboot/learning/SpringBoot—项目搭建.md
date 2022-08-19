## SpringBoot—项目搭建

## 前言

千里之行,始于足下，要用好SpringBoot项目我们首先要搭建SpringBoot项目不知道大家都是如何搭建的。下面我谈谈我是如何使用的

---

`提示：以下是本篇文章正文内容，下面案例可供参考`

### 环境准备

|                     | 版本     | 安装说明 |
| ------------------- | -------- | -------- |
| JDK                 | 1.8      |          |
| IDEA                | 2021 2.3 |          |
| Maven               | 3.6.0    |          |
| Git                 | 2.20.1   |          |
| MySQL               | 5.7      |          |
| Navicat             | 12.1     |          |
| Redis               | 2.8.2400 |          |
| RedisDesktopManager | 0.93.817 |          |
| MongoDB             | 1.32.2   |          |
|                     |          |          |
|                     |          |          |
|                     |          |          |
|                     |          |          |
|                     |          |          |



### 方法一：IDEA搭建

File->New->Project

**1.选择spring initalizr ， 其默认就是去官网的快速构建工具那里实现的`https://start.spring.io/`**



![image-20220803170426345](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803170426345.png)



**2.配置SpringBoot jar包**

![image-20220803173945356](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803173945356.png)



**3.配置初始化组件比如数据库或者Web项目**

![image-20220803174109447](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803174109447.png)



**4.选择项目路径**

![image-20220803174204119](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803174204119.png)

**5.查看项目结构 红色框内的可以删除**

![image-20220803174411367](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803174411367.png)



**6.配置maven路径**

**File->setting-Maven**

![image-20220803174508239](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803174508239.png)



**7.配置application.properties**

```yml
server.port=9991
```

**8.编写Controller**

![image-20220803175304902](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803175304902.png)

```java
package com.whcoding.springbootdemo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @program: springboot-demo
 * @description:
 * @author: whcoding
 * @create: 2022-08-03 17:46
 **/
@RequestMapping("/hello")
@RestController
public class HelloWorld {
	/**
	 * localhost
	 * @return
	 */
	@GetMapping("/sayHello")
	public String sayHello(){
		return "HelloWorld";
	}
}
```



**9.运行项目**

**启动SpringbootDemoApplication**

http://localhost:9991/hello/sayHello

![image-20220803174949866](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803174949866.png)

### 方法二：官网搭建

[官网地址](https://start.spring.io/)

**1.在官网生成SpringBoot项目**

![image-20220803175151589](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803175151589.png)





**2.解压到指定目录,用IDEA打开**

![image-20220803175556878](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803175556878.png)



**3.修改application.properties**

配置端口号

```yml
server.port= 9992
```

**4.修改pom文件**

由于我们是Web项目可以将原有的`spring-boot-starter` 替换成`spring-boot-starter-web` 替换后文件如下所示

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>2.7.2</version>
		<relativePath/> <!-- lookup parent from repository -->
	</parent>
	<groupId>com.whcoding</groupId>
	<artifactId>demo</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>demo</name>
	<description>Demo project for Spring Boot</description>
	<properties>
		<java.version>1.8</java.version>
	</properties>
	<dependencies>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>
	</dependencies>

	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>
</project>
```



**5.添加controller**

```java
package com.whcoding.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @program: springboot-demo
 * @description:
 * @author: whcoding
 * @create: 2022-08-03 17:46
 **/
@RequestMapping("/hello")
@RestController
public class HelloWorld {

	/**
	 * localhost
	 * @return
	 */
	@GetMapping("/sayHello")
	public String sayHello(){
		return "HelloWorld";
	}
}

```



**6.运行项目**

**运行主程序DemoApplication。**

**http://localhost:9992/hello/sayHello**

![image-20220803180149643](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803180149643.png)



### 方法三：Maven搭建

**1.File->New->Peoject**

使用Maven搭建和使用`initializr`有区别这里选择Maven然后下一步

![image-20220803180243437](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803180243437.png)

**2.设置GroupID **

![image-20220803180453951](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803180453951.png)



**3.选择项目名称以及项目路径**

![image-20220803180511335](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803180511335.png)

**4.查看项目结构**

![image-20220803180554645](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803180554645.png)

由于使用maven搭建项目，项目结构是不完整的有些文件以及文件夹需要我们自己配置，下面是我配置好得项目结构

![image-20220803181125673](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803181125673.png)

**5.pom中增加依赖**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.2</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    
    <groupId>com.whcoding</groupId>
    <artifactId>springboot-demo</artifactId>
    <version>1.0-SNAPSHOT</version>

    <dependencies>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>

```



**6.添加application.properties文件**

```yml
server.port= 9993
```

**7.添加启动类DemoApplication**

```java
package com.whcoding.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}
}
```

**8.添加controller**

```java
package com.whcoding.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @program: springboot-demo
 * @description:
 * @author: whcoding
 * @create: 2022-08-03 17:46
 **/
@RequestMapping("/hello")
@RestController
public class HelloWorldController {

	/**
	 * localhost
	 * @return
	 */
	@GetMapping("/sayHello")
	public String sayHello(){
		return "HelloWorld";
	}
}

```

**9.启动项目**

**启动DemoApplication文件** 当看到`Tomcat started on port(s): 9993 (http) ` 则表示项目运行成功

![image-20220803181408388](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803181408388.png)

访问HelloWorldController

http://localhost:9993/hello/sayHello

![image-20220803181516853](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803181516853.png)

**查看访问结果**

## 总结

一般搭建项目就是选择其中的一种方式搭建，若是自己写demo测试类什么的，推荐使用方法一，若是多模块项目则使用方法三Maven方式搭建项目比较好，以上仅是个人使用的一些方式。如有不对欢迎指导。

##  公众号

如果大家想要实时关注我更新的文章以及分享的干货的话，可以关注我的公众号。
<img src="https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220507200900.jpg" style="zoom:50%;" />



