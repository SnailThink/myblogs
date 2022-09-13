# spring-boot-demo-exception-handler

> 此 demo 演示了如何在Spring Boot中进行统一的异常处理，包括了两种方式的处理：第一种对常见API形式的接口进行异常处理，统一封装返回格式；第二种是对模板页面请求的异常处理，统一处理错误页面。



## 一、准备工作

### 1.引入依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>spring-boot-learning</artifactId>
        <groupId>com.whcoding</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>demo-exception-handler</artifactId>


    <version>1.0.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <name>demo-exception-handler</name>
    <description>Demo project for Spring Boot</description>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
    </dependencies>

    <build>
        <finalName>demo-exception-handler</finalName>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
```

### 2.添加统一返回值

> 统一的API格式返回封装

```java

/**
 * <p>
 * 通用的 API 接口封装
 * </p>
 *
 * @author: SnailThink
 * @create: 2022-02-24 17:00
 */
@Data
public class ApiResponse {
	/**
	 * 状态码
	 */
	private Integer code;

	/**
	 * 返回内容
	 */
	private String message;

	/**
	 * 返回数据
	 */
	private Object data;

	/**
	 * 无参构造函数
	 */
	private ApiResponse() {

	}

	/**
	 * 全参构造函数
	 *
	 * @param code    状态码
	 * @param message 返回内容
	 * @param data    返回数据
	 */
	private ApiResponse(Integer code, String message, Object data) {
		this.code = code;
		this.message = message;
		this.data = data;
	}

	/**
	 * 构造一个自定义的API返回
	 *
	 * @param code    状态码
	 * @param message 返回内容
	 * @param data    返回数据
	 * @return ApiResponse
	 */
	public static ApiResponse of(Integer code, String message, Object data) {
		return new ApiResponse(code, message, data);
	}

	/**
	 * 构造一个成功且带数据的API返回
	 *
	 * @param data 返回数据
	 * @return ApiResponse
	 */
	public static ApiResponse ofSuccess(Object data) {
		return ofStatus(ResultStatus.OK, data);
	}

	/**
	 * 构造一个成功且自定义消息的API返回
	 *
	 * @param message 返回内容
	 * @return ApiResponse
	 */
	public static ApiResponse ofMessage(String message) {
		return of(ResultStatus.OK.getCode(), message, null);
	}

	/**
	 * 构造一个有状态的API返回
	 *
	 * @param status 状态 {@link ResultStatus}
	 * @return ApiResponse
	 */
	public static ApiResponse ofStatus(ResultStatus status) {
		return ofStatus(status, null);
	}

	/**
	 * 构造一个有状态且带数据的API返回
	 *
	 * @param status 状态 {@link ResultStatus}
	 * @param data   返回数据
	 * @return ApiResponse
	 */
	public static ApiResponse ofStatus(ResultStatus status, Object data) {
		return of(status.getCode(), status.getMessage(), data);
	}

	/**
	 * 构造一个异常且带数据的API返回
	 *
	 * @param t    异常
	 * @param data 返回数据
	 * @param <T>  {@link BaseException} 的子类
	 * @return ApiResponse
	 */
	public static <T extends BaseException> ApiResponse ofException(T t, Object data) {
		return of(t.getCode(), t.getMessage(), data);
	}

	/**
	 * 构造一个异常且带数据的API返回
	 *
	 * @param t   异常
	 * @param <T> {@link BaseException} 的子类
	 * @return ApiResponse
	 */
	public static <T extends BaseException> ApiResponse ofException(T t) {
		return ofException(t, null);
	}
}
```

**状态码枚举**

```java
package com.whcoding.exception.handler.constant;

import lombok.Getter;

/**
 * <p>
 * 状态码封装
 * </p>
 *
 * @author: SnailThink
 * @create: 2022-02-24 17:00
 */
@Getter
public enum ResultStatus {
    /**
     * 操作成功
     */
    OK(200, "操作成功"),

    /**
     * 未知异常
     */
    UNKNOWN_ERROR(500, "服务器出错啦"),

    /**
     * 未知异常
     */
    UNKNOWN_EXCEPTION(100, "未知异常"),

    /**
     * 格式错误
     */
    FORMAT_ERROR(101, "参数格式错误"),

    /**
     * 超时
     */
    TIME_OUT(102, "超时"),

    /**
     * 添加失败
     */
    ADD_ERROR(103, "添加失败"),

    /**
     * 更新失败
     */
    UPDATE_ERROR(104, "更新失败"),

    /**
     * 删除失败
     */
    DELETE_ERROR(105, "删除失败"),

    /**
     * 查找失败
     */
    GET_ERROR(106, "查找失败"),

    /**
     * 参数类型不匹配
     */
    ARGUMENT_TYPE_MISMATCH(107, "参数类型不匹配"),

    /**
     * 请求方式不支持
     */
    REQ_METHOD_NOT_SUPPORT(110,"请求方式不支持") ;

    /**
     * 状态码
     */
    private Integer code;
    /**
     * 内容
     */
    private String message;

    ResultStatus(Integer code, String message) {
        this.code = code;
        this.message = message;
    }
}

```

### 3.添加启动类

```java
package com.whcoding.exception.handler;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * <p>
 * 启动类
 * </p>
 *
 * @author: SnailThink
 * @create: 2022-02-24 17:00
 */
@SpringBootApplication
public class SpringBootDemoExceptionHandlerApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringBootDemoExceptionHandlerApplication.class, args);
    }
}

```

### 4.添加配置信息

```yml
server:
  port: 9290
  servlet:
    context-path: /demo
spring:
  thymeleaf:
    cache: false
    mode: HTML
    encoding: UTF-8
    servlet:
      content-type: text/html
```



## 二、添加异常类

### 1.BaseException

```java
package com.whcoding.exception.handler.exception;

import com.whcoding.exception.handler.constant.ResultStatus;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <p>
 * 异常基类
 * </p>
 *
 * @author: SnailThink
 * @create: 2022-02-24 17:00
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class BaseException extends RuntimeException {
    private Integer code;
    private String message;

    public BaseException(ResultStatus status) {
        super(status.getMessage());
        this.code = status.getCode();
        this.message = status.getMessage();
    }

    public BaseException(Integer code, String message) {
        super(message);
        this.code = code;
        this.message = message;
    }
}

```





### 2.JsonException

> JSON 参数序列化或者反序列化异常

```java
package com.whcoding.exception.handler.exception;

import com.whcoding.exception.handler.constant.ResultStatus;
import lombok.Getter;

/**
 * <p>
 * JSON异常
 * </p>
 *
 * @author: SnailThink
 * @create: 2022-02-24 17:00
 */
@Getter
public class JsonException extends BaseException {

    public JsonException(ResultStatus status) {
        super(status);
    }

    public JsonException(Integer code, String message) {
        super(code, message);
    }
}
```



### 3.PageException

```java
package com.whcoding.exception.handler.exception;

import com.whcoding.exception.handler.constant.ResultStatus;
import lombok.Getter;

/**
 * <p>
 * 页面异常
 * </p>
 *
 * @author: SnailThink
 * @create: 2022-02-24 17:00
 */
@Getter
public class PageException extends BaseException {

    public PageException(ResultStatus status) {
        super(status);
    }

    public PageException(Integer code, String message) {
        super(code, message);
    }
}

```

### 4.RunException

```java
package com.whcoding.exception.handler.exception;

import com.whcoding.exception.handler.constant.ResultStatus;
import lombok.Getter;

/**
 * @program: spring-boot-learning
 * @description: 运行异常
 * @author: whcoding
 * @create: 2022-05-26 18:04
 **/
@Getter
public class RunException extends BaseException {

	public RunException(ResultStatus status) {
		super(status);
	}

	public RunException() {
		super(ResultStatus.TIME_OUT.getCode(), ResultStatus.TIME_OUT.getMessage());
	}

	public RunException(Integer code, String message) {
		super(code, message);
	}
}

```

### 5.error.html

> 位于 `src/main/resources/template` 目录下

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head lang="en">
	<meta charset="UTF-8"/>
	<title>统一页面异常处理</title>
</head>
<body>
<h1>统一页面异常处理</h1>
<div th:text="${message}"></div>
</body>
</html>
```



## 三、异常处理类

### 1.DemoExceptionHandler

```java
package com.whcoding.exception.handler.handler;


import com.whcoding.exception.handler.exception.JsonException;
import com.whcoding.exception.handler.exception.PageException;
import com.whcoding.exception.handler.exception.RunException;
import com.whcoding.exception.handler.model.ApiResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * <p>
 * 统一异常处理
 * </p>
 *
 * @author: SnailThink
 * @create: 2022-02-24 17:00
 */
@ControllerAdvice
@Slf4j
public class DemoExceptionHandler {
    private static final String DEFAULT_ERROR_VIEW = "error";

    /**
     * 统一 json 异常处理
     *
     * @param exception JsonException
     * @return 统一返回 json 格式
     */
    @ExceptionHandler(value = JsonException.class)
    @ResponseBody
    public ApiResponse jsonErrorHandler(JsonException exception) {
        log.error("【JsonException】:{}", exception.getMessage());
        return ApiResponse.ofException(exception);
    }

    /**
     * 统一 超时 异常处理
     *
     * @param exception RunException
     * @return 统一返回 json 格式
     */
    @ExceptionHandler(value = RunException.class)
    @ResponseBody
    public ApiResponse runtimeErrorHandler(RunException exception) {
        log.error("【RunException】:{}", exception.getMessage());
        return ApiResponse.ofException(exception);
    }

    /**
     * 统一 页面 异常处理
     *
     * @param exception PageException
     * @return 统一跳转到异常页面
     */
    @ExceptionHandler(value = PageException.class)
    public ModelAndView pageErrorHandler(PageException exception) {
        log.error("【DemoPageException】:{}", exception.getMessage());
        ModelAndView view = new ModelAndView();
        view.addObject("message", exception.getMessage());
        view.setViewName(DEFAULT_ERROR_VIEW);
        return view;
    }
}

```


## 四、常见的异常类有哪些

- NullPointerException：当应用程序试图访问空对象时，则抛出该异常。

- SQLException：提供关于数据库访问错误或其他错误信息的异常。

- IndexOutOfBoundsException：指示某排序索引（例如对数组、字符串或向量的排序）超出范围时抛出。 

- NumberFormatException：当应用程序试图将字符串转换成一种数值类型，但该字符串不能转换为适当格式时，抛出该异常。

- FileNotFoundException：当试图打开指定路径名表示的文件失败时，抛出此异常。

- IOException：当发生某种I/O异常时，抛出此异常。此类是失败或中断的I/O操作生成的异常的通用类。

- ClassCastException：当试图将对象强制转换为不是实例的子类时，抛出该异常。

- ArrayStoreException：试图将错误类型的对象存储到一个对象数组时抛出的异常。

- IllegalArgumentException：抛出的异常表明向方法传递了一个不合法或不正确的参数。

- ArithmeticException：当出现异常的运算条件时，抛出此异常。例如，一个整数“除以零”时，抛出此类的一个实例。 

- NegativeArraySizeException：如果应用程序试图创建大小为负的数组，则抛出该异常。

- NoSuchMethodException：无法找到某一特定方法时，抛出该异常。

- SecurityException：由安全管理器抛出的异常，指示存在安全侵犯。

- UnsupportedOperationException：当不支持请求的操作时，抛出该异常。

- RuntimeExceptionRuntimeException：是那些可能在Java虚拟机正常运行期间抛出的异常的超类
- 



