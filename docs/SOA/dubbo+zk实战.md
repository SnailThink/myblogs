## dubbo+zookeeper



### 1.安装zookeeper

[安装ZK](https://blog.csdn.net/dayonglove2018/article/details/109156635)

下载成功后运行`zkServer.cmd` 文件、运行成功如下图所示

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530183325.png)



zk客户端查看节点信息

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530183345.png)



## 实战

 尽量新建一个文件夹，然后后面将接口项目、服务提供者以及服务消费者都放在这个文件夹。

项目结构：

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530183351.png)



#### 1.先新建一个maven项目

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530183359.png)



#### 2.配置groupId

groupId：com.snailthink

Actifactid：dubbo

#### 3.删除dubbo文件下的src文件



#### 4.在dubbo项目下增加

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530183406.png)

- dubbo-common
- dubbo-provider
-  dubbo-consumer






### 1.实现服务接口dubbo-common

**此 module 主要是用于公共部分，主要存放工具类，实体，以及服务提供方/调用方的接口定义**

#### 1.引入依赖

```java
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>dubbo</artifactId>
        <groupId>com.snailthink</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>dubbo-common</artifactId>

</project>
```



#### 2.Hello服务接口

```java
package com.snailthink.dubbo.common.service;

public interface HelloService {

	/**
	 * sayHelloWorld
	 *
	 * @param name 姓名
	 * @return 问好
	 */
	String sayHelloWorld(String name);
}
```





### 2.实现服务提供者 dubbo-provider

**此 module 主要是服务提供方示例**

#### 1.导入依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>dubbo</artifactId>
        <groupId>com.snailthink</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>dubbo-provider</artifactId>


    <dependencies>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!--引入dubbo的依赖-->
        <dependency>
            <groupId>com.alibaba.spring.boot</groupId>
            <artifactId>dubbo-spring-boot-starter</artifactId>
            <!--<version>2.0.0</version>-->
            <version>${dubbo.starter.version}</version>
        </dependency>

        <!--调用自己的common-->
        <dependency>
            <groupId>${project.groupId}</groupId>
            <artifactId>dubbo-common</artifactId>
            <version>${project.version}</version>
        </dependency>

        <!-- 引入zookeeper的依赖 -->
        <dependency>
            <groupId>com.101tec</groupId>
            <artifactId>zkclient</artifactId>
            <!--<version>0.10</version>-->
            <version>${zkclient.version}</version>
        </dependency>

        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>

        <!--<dependency>-->
            <!--<groupId>org.springframework.boot</groupId>-->
            <!--<artifactId>spring-boot-starter-test</artifactId>-->
            <!--<scope>test</scope>-->
        <!--</dependency>-->
    </dependencies>

    <build>
        <finalName>dubbo-provider</finalName>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
```



#### 2.编写配置类application.yml

```yml
server:
  port: 9090
  servlet:
    context-path: /demo

spring:
  dubbo:
    application:
      name: dubbo-provider
      registry: zookeeper://localhost:2181

```

#### 3.添加启动类

```java
package com.snailthink.dubbo.provider;
import com.alibaba.dubbo.spring.boot.annotation.EnableDubboConfiguration;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @program: springcloud
 * @description:
 * @author: SnailThink
 * @create: 2021-10-22 17:54
 **/
@SpringBootApplication
@EnableDubboConfiguration //Dubbo 自动配置
public class DubboProviderApplication {

	public static void main(String[] args) {
		SpringApplication.run(DubboProviderApplication.class,args);
	}
}

```

#### 4.添加接口实现类

`HelloService` 调用的是`dubbo.common` 包下的接口

```java
package com.snailthink.dubbo.provider.service;

import com.alibaba.dubbo.config.annotation.Service;
import com.snailthink.dubbo.common.service.HelloService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * @program: springcloud
 * @description:
 * @author: SnailThink
 * @create: 2021-10-22 18:08
 **/

@Service
@Component
@Slf4j
public class HelloServiceImpl implements HelloService {

	@Override
	public String sayHelloWorld(String name) {
		log.info("someone is calling me......");
		return "say hello to: " + name;
	}
}

```



### 3.实现服务消费者：dubbo-consumer



#### 1.导入依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>dubbo</artifactId>
        <groupId>com.snailthink</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>dubbo-consumer</artifactId>


    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>com.alibaba.spring.boot</groupId>
            <artifactId>dubbo-spring-boot-starter</artifactId>
            <version>${dubbo.starter.version}</version>
        </dependency>

        <dependency>
            <groupId>${project.groupId}</groupId>
            <artifactId>dubbo-common</artifactId>
            <version>${project.version}</version>
        </dependency>

        <dependency>
            <groupId>com.101tec</groupId>
            <artifactId>zkclient</artifactId>
            <version>${zkclient.version}</version>
        </dependency>

        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <finalName>dubbo-consumer</finalName>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
```

#### 2.编写配置类application.yml

```yml
server:
  port: 10180
  servlet:
    context-path: /demo

spring:
  dubbo:
    application:
      name: dubbo-consumer
      registry: zookeeper://127.0.0.1:2181
```



#### 3.添加启动类

```java
package com.snailthink.dubbo.consumer;

import com.alibaba.dubbo.spring.boot.annotation.EnableDubboConfiguration;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @program: springcloud
 * @description: 启动类
 * @author: SnailThink
 * @create: 2021-10-22 18:37
 **/

@SpringBootApplication
@EnableDubboConfiguration
public class DubboConsumerApplication {

	public static void main(String[] args) {
		SpringApplication.run(DubboConsumerApplication.class, args);
	}

}

```



#### 4.添加controller

```java
package com.snailthink.dubbo.consumer.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.snailthink.dubbo.common.service.HelloService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * @program: springcloud
 * @description:
 * @author: SnailThink
 * @create: 2021-10-22 18:37
 **/
@RestController
public class HelloController {

	@Reference
	private HelloService helloService;

	/**
	 * http://localhost:10180/demo/sayHelloWorld?name=aaa
	 * @param name
	 * @return
	 */
	@GetMapping("/sayHelloWorld")
	public String sayHelloWorld(@RequestParam(defaultValue = "snailthink") String name) {

		return helloService.sayHelloWorld(name);
	}
}

```



### 启动顺序

1.先启动 zk

2.启动dubbo-provide

3.启动consumer

4.调用接口地址consomer： http://localhost:10180/demo/sayHelloWorld?name=aaa



### 问题：移除依赖

```xml


  <dependency>
            <groupId>com.101tec</groupId>
            <artifactId>zkclient</artifactId>
            <version>0.10</version>
            <exclusions>
                <exclusion>
                    <groupId>log4j</groupId>
                    <artifactId>log4j</artifactId>
                </exclusion>
                <exclusion>
                    <groupId>org.slf4j</groupId>
                    <artifactId>slf4j-log4j12</artifactId>
                </exclusion>
                <exclusion>
                    <groupId>org.slf4j</groupId>
                    <artifactId>slf4j-api</artifactId>
                </exclusion>
                <exclusion>
                    <groupId>jline</groupId>
                    <artifactId>jline</artifactId>
                </exclusion>

                <exclusion>
                    <groupId>io.netty</groupId>
                    <artifactId>netty</artifactId>
                </exclusion>

            </exclusions>
        </dependency>
```






### 参考文档：

[SpringBoot+Dubbo 搭建一个简单的分布式服务]( https://segmentfault.com/a/1190000017178722#articleHeader20)

[springboot整合dubbo+zookeeper](https://blog.csdn.net/dayonglove2018/article/details/109156635 )



