## Spirng Boot——国际化

### 前言

**网站涉及中英文甚至多语言的切换。**可以配置国际化我们最常见的就是中英文切换，根据国际化配置也可以其他语言比如繁体字段，总之可以根据自己实际项目中的情况进行使用 使用方法都是一样的，我下面整理的只是简单的入门操作。

项目地址[demo-international](https://gitee.com/VincentBlog/spring-boot-learning/tree/master/demo-international)

### 1.什么是国际化

国际化，也叫 i18n，为啥叫这个名字呢？因为国际化英文是 internationalization ，在i和n之间有18个字母，所以叫 i18n。我们的应用如果做了国际化就可以在不同的语言环境下，方便的进行切换，最常见的就是中文和英文之间的切换

### 2.Spirng Boot集成国际化

#### 1. 导入依赖

```xml
   <!--springboot启动类-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <!--springboot 测试类-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-configuration-processor</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>
```



#### 2.设置编码格式

如果properties中有中文，可能会导致乱码，解决方案：

IDEA中设置编码格式为UTF-8；

settings-->FileEncodings 中配置；

![image-20220802171456341](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220802171456341.png)

#### 3.编写国际化配置文件

**login.properties**

```
login.tip = "请登录"
login.username = "用户名"
login.password = "密码"
login.btn = "提交"
login.remeber = "记住"
```

**login_en_US.properties**

```
login.btn=Submit
login.tip=Please Sign in
login.username=Username
login.password=Password
login.remember=remember
```

**login_zh_CN.properties**

```
login.btn=提交
login.tip=请登录
login.username=用户名
login.password=密码
login.remember=记住密码
```

#### 4.添加配置文件

**MyLocaleResolver**

```java
package com.whcoding.international.config;

import org.springframework.util.StringUtils;
import org.springframework.web.servlet.LocaleResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Locale;

/**
 * @program: International
 * @description:
 * @author: whcoding
 * @create: 2022-08-02 15:36
 **/

public class MyLocaleResolver implements LocaleResolver {
	//解析请求可以在链接上携带区域信息
	@Override
	public Locale resolveLocale(HttpServletRequest request) {
		String language = request.getParameter("l");
		// 如果没有获取到就使用系统默认的
		Locale locale = Locale.getDefault();
		//如果请求链接不为空
		if (!StringUtils.isEmpty(language)) {
			//分割请求参数
			String[] split = language.split("_");
			//国家，地区
			locale = new Locale(split[0], split[1]);
		}
		return locale;
	}

	@Override
	public void setLocale(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Locale locale) {

	}
}

```

**MyMvcConfig**

```java
package com.whcoding.international.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * @program: International
 * @description:
 * @author: whcoding
 * @create: 2022-08-02 15:44
 **/

@Configuration
public class MyMvcConfig implements WebMvcConfigurer {

	@Bean
	public LocaleResolver localeResolver(){
		return new MyLocaleResolver();
	}
}
```



#### 5.Controller

```java
package com.whcoding.international.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @program: International
 * @description:
 * @author: whcoding
 * @create: 2022-08-02 15:44
 **/
@Controller
public class InternationalTest {

	/**
	 * http://localhost:9303/index.html
	 * @return
	 */
	@RequestMapping("/index.html")
	public String index(){
		return "index";
	}

	/**
	 * http://localhost:9301/test.html
	 * @return
	 */
	@RequestMapping("/test.html")
	public String test(){
		return "test";
	}
}

```

#### 6.index.html

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<form>

    <h3 th:text="#{login.tip}" >Please Sign in</h3>

    <input type="text"  th:placeholder="#{login.username}" > <br>
    <input type="password" th:placeholder="#{login.password}"> <br>

    <input type="checkbox" value="rember-me">[[#{login.remember}]] <br>

    <button type="submit" th:text="#{login.btn}" > Sign in</button>  <br>

    <p class="mt-5 mb-3 text-muted">© 2020-2022</p>
    <a class="btn btn-sm" th:href="@{/index.html(l='zh_CN')}">中文</a>
    <a class="btn btn-sm" th:href="@{/index.html(l='en_US')}">English</a>
</form>
</body>
</html>
```

#### 7.application.properties

```java
server.port=9303

# 国际化资源文件位置
spring.messages.basename=i18n.login
# messages 文件的缓存失效时间
spring.messages.cache-duration=1
# 属性配置文件中文乱码问题
spring.messages.encoding=utf-8
# 解决中文乱码
server.servlet.encoding.charset=UTF-8
server.servlet.encoding.enabled=true
server.servlet.encoding.force=true
# 解决Tomcat中文乱码问题
server.tomcat.accesslog.encoding=UTF-8

spring.thymeleaf.cache=true
spring.thymeleaf.enabled=true
spring.thymeleaf.encoding=utf-8
```



#### 8.启动类

```java
package com.whcoding.international;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @program: spring-boot-learning
 * @description:
 * @author: whcoding
 * @create: 2022-08-02 16:45
 **/
@SpringBootApplication
public class DemoInternationalApplication {
	public static void main(String[] args) {
		SpringApplication.run(DemoInternationalApplication.class, args);
	}
}

```



#### 9.查看项目结构

![image-20220802170213757](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220802170213757.png)



#### 10.启动项目

**点击English即可实现切换到英文**

http://localhost:9301/index.html

![image-20220802171605039](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220802171605039.png)



#### 11.常见语言简称表

| 语言               | 简称  |
| ------------------ | ----- |
| 简体中文(中国)     | zh_CN |
| 繁体中文(中国台湾) | zh_TW |
| 繁体中文(中国香港) | zh_HK |
| 英语(中国香港)     | en_HK |
| 英语(美国)         | en_US |
| 英语(英国)         | en_GB |

## 参考

[SpringBoot 国际化 ](https://blog.csdn.net/weixin_42414405/article/details/124474855?spm=1001.2101.3001.6650.19&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7Edefault-19-124474855-blog-104667731.pc_relevant_show_downloadRating&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7Edefault-19-124474855-blog-104667731.pc_relevant_show_downloadRating&utm_relevant_index=25)

[Spring Boot 国际化踩坑指南](https://blog.csdn.net/u012702547/article/details/104667731)