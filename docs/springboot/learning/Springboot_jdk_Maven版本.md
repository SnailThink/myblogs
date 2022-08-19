
## 1.Springboot 版本+ jdk 版本 + Maven 版本的匹配

| Spring boot 版本 | Spring Framework | jdk 版本 | maven 版本 |
| ---------------- | ---------------- | -------- | ---------- |
| 1.2.0 版本之前   |                  | 6        | 3.0        |
| 1.2.0            |  4.1.3+	      | 6        | 3.2+       |
| 1.2.1            |  4.1.3+	      | 7        | 3.2+       |
| 1.2.3            |  4.1.5+	      | 7        | 3.2+       |
| 1.3.4            |  4.2.6+	      | 7        | 3.2+       |
| 1.3.6            |  4.2.7+	      | 7        | 3.2+       |
| 1.3.7            |  4.2.7+	      | 7        | 3.2+       |
| 1.3.8            |  4.2.8+	      | 7        | 3.2+       |
| 1.4.0            |  4.3.2+	      | 7        | 3.2+       |
| 1.4.1            |  4.3.3	     	  | 7        | 3.2+       |
| 1.4.2            |  4.3.4	          | 7        | 3.2+       |
| 1.4.3            |  4.3.5	          | 7        | 3.2+       |
| 1.4.4            |  4.3.6	          | 7        | 3.2+       |
| 1.4.5            |  4.3.7	          | 7        | 3.2+       |
| 1.4.6            |  4.3.8	          | 7        | 3.2+       |
| 1.4.7            |  4.3.9           | 7        | 3.2+       |
| 1.5.0            |  4.3.6	          | 7        | 3.2+       |
| 1.5.2            |  4.3.7	          | 7        | 3.2+       |
| 1.5.3            |  4.3.8	          | 7        | 3.2+       |
| 1.5.4            |  4.3.9	          | 7        | 3.2+       |
| 1.5.5            |  4.3.10	      | 7        | 3.2+       |
| 1.5.7            |  4.3.11	      | 7        | 3.2+       |
| 1.5.8            |  4.3.12	      | 7        | 3.2+       |
| 1.5.9            |  4.3.13	      | 7        | 3.2+       |
| 2.0.0            |  5.0.2	          | 8        | 3.2+       |



## 2.Springboot 和springcloud 版本对应

###  大版本对应： 

| Spring Cloud             | Spring Boot                                    |
| ------------------------ | ---------------------------------------------- |
| Angel版本                | 兼容Spring Boot 1.2.x                          |
| Brixton版本              | 兼容Spring Boot 1.3.x，也兼容Spring Boot 1.4.x |
| Camden版本               | 兼容Spring Boot 1.4.x，也兼容Spring Boot 1.5.x |
| Dalston版本、Edgware版本 | 兼容Spring Boot 1.5.x，不兼容Spring Boot 2.0.x |
| Finchley版本             | 兼容Spring Boot 2.0.x，不兼容Spring Boot 1.5.x |
| Greenwich版本            | 兼容Spring Boot 2.1.x                          |
| Hoxtonl版本              | 兼容Spring Boot 2.2.x                          |



### 开发版本对应：

| Spring Boot                  | Spring Cloud            |
| ---------------------------- | ----------------------- |
| 1.5.2.RELEASE                | Dalston.RC1             |
| 1.5.9.RELEASE                | Edgware.RELEASE         |
| 2.0.2.RELEASE                | Finchley.BUILD-SNAPSHOT |
| 2.0.3.RELEASE                | Finchley.RELEASE        |
| 2.1.0.RELEASE-2.1.14.RELEASE | Greenwich.SR5           |
| 2.2.0.M4                     | Hoxton.SR4              |

### spring cloud1.x版本和2.x版本区别

spring cloud各个版本之间是有所区别的，比如在SpringCloud中，1.X和2.X版本在pom.xml中引入的jar包名字都不一样，比如有的叫spirng-cloud-starter-hystrix 有的叫spring-cloud-netflix-hystrix，维护起来会比较困难。


 1.x版本pom.xml

```java

<project xmlns="http://maven.apache.org/POM/4.0.0"
	    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	    <modelVersion>4.0.0</modelVersion>
	    <groupId>com.joyce</groupId>
	    <artifactId>joyce-test</artifactId>
	    <version>1.0</version>
	    <packaging>jar</packaging>
	
	    <parent>
	        <groupId>org.springframework.boot</groupId>
	        <artifactId>spring-boot-starter-parent</artifactId>
	        <version>1.5.9.RELEASE</version>
	        <relativePath /> 
	    </parent>
	    
	    <dependencyManagement>
	        <dependencies>
	            <dependency>
	                <groupId>org.springframework.cloud</groupId>
	                <artifactId>spring-cloud-dependencies</artifactId>
	                <version>Edgware.RELEASE</version>
	                <type>pom</type>
	                <scope>import</scope>
	            </dependency>
	        </dependencies>
	    </dependencyManagement>
	    
	    <properties>
	        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
	    </properties>
	
	    <dependencies>
	        <dependency>
	            <groupId>org.springframework.cloud</groupId>
	            <artifactId>spring-cloud-starter-feign</artifactId>
	        </dependency>
	        <dependency>
	            <groupId>org.springframework.cloud</groupId>
	            <artifactId>spring-cloud-starter-hystrix</artifactId>
	        </dependency>
	        <dependency>
	            <groupId>org.springframework.cloud</groupId>
	            <artifactId>spring-cloud-starter-zipkin</artifactId>
	        </dependency>
	        <dependency>
	            <groupId>org.springframework.cloud</groupId>
	            <artifactId>spring-cloud-starter-eureka</artifactId>
	        </dependency>
	        <dependency>
	            <groupId>org.springframework.boot</groupId>
	            <artifactId>spring-boot-starter-actuator</artifactId>
	        </dependency>
	        <dependency>
	            <groupId>org.springframework.boot</groupId>
	            <artifactId>spring-boot-starter-web</artifactId>
	            <exclusions>
	                <!-- 排除spring boot默认使用的tomcat，使用jetty -->
	                <exclusion>
	                    <groupId>org.springframework.boot</groupId>
	                    <artifactId>spring-boot-starter-tomcat</artifactId>
	                </exclusion>
	            </exclusions>
	        </dependency>
	        <dependency>
	            <groupId>org.springframework.boot</groupId>
	            <artifactId>spring-boot-starter-jetty</artifactId>
	        </dependency>
	        <dependency>
	            <groupId>org.springframework.cloud</groupId>
	            <artifactId>spring-cloud-starter-ribbon</artifactId>
	        </dependency>
	        <dependency>
	            <groupId>org.springframework.boot</groupId>
	            <artifactId>spring-boot-starter-test</artifactId>
	            <scope>test</scope>
	        </dependency>
	    </dependencies>
	</project>

```

 而在2.x版本中，比如我们需要eureka,去maven仓库中可能会看到deprecated, please use spring-cloud-starter-netflix-eureka-client这类提示，

![image-20220103170536105](C:\Users\Manager\AppData\Roaming\Typora\typora-user-images\image-20220103170536105.png)

2.x的版本pom.xml类似如下

```java
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.forezp</groupId>
    <artifactId>service-feign</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>jar</packaging>

    <name>service-feign</name>
    <description>Demo project for Spring Boot</description>


    <parent>
        <groupId>com.forezp</groupId>
        <artifactId>sc-f-chapter3</artifactId>
        <version>0.0.1-SNAPSHOT</version>
    </parent>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
    </dependencies>
    
    </project>


```

