# base-project

`base-project` 是一个基础项目的维护

使用的技术如下

- [x] JPA
- [x] Mybatis
- [x] Redis
- [ ] RabbitMQ
- [x] swagger
- [x] 代码生成器
- [x] AOP切面日志
- [x] 统一异常，统一返回值 BaseResultVO 封装
- [x] EasyExcel 导出封装
- [ ] 





## 一、AOP记录接口访问日志

> 本文主要讲述AOP在base-project 项目中的应用，通过在controller层建一个切面来实现接口访问的统一日志记录

### 1.1 什么是AOP

> AOP为Aspect Oriented Programming的缩写，意为：面向切面编程，通过预编译方式和运行期动态代理实现程序功能的统一维护的一种技术。利用AOP可以对业务逻辑的各个部分进行隔离，从而使得业务逻辑各部分之间的耦合度降低，提高程序的可重用性，同时提高了开发的效率

### 1.2.AOP的相关术语

#### 通知（Advice）

通知描述了切面要完成的工作以及何时执行。比如我们的日志切面需要记录每个接口调用时长，就需要在接口调用前后分别记录当前时间，再取差值。

- 前置通知（Before）：在目标方法调用前调用通知功能；
- 后置通知（After）：在目标方法调用之后调用通知功能，不关心方法的返回结果；
- 返回通知（AfterReturning）：在目标方法成功执行之后调用通知功能；
- 异常通知（AfterThrowing）：在目标方法抛出异常后调用通知功能；
- 环绕通知（Around）：通知包裹了目标方法，在目标方法调用之前和之后执行自定义的行为。

#### 连接点（JoinPoint）

通知功能被应用的时机。比如接口方法被调用的时候就是日志切面的连接点。

#### 切点（Pointcut）

切点定义了通知功能被应用的范围。比如日志切面的应用范围就是所有接口，即所有controller层的接口方法

#### 切面（Aspect）

切面是通知和切点的结合，定义了何时、何地应用通知功能。

#### 引入（Introduction）

在无需修改现有类的情况下，向现有的类添加新方法或属性

#### 织入（Weaving）

把切面应用到目标对象并创建新的代理对象的过程。

#### 切点表达式

指定了通知被应用的范围，表达式格式：

```java
execution(方法修饰符 返回类型 方法所属的包.类名.方法名称(方法参数)

//com.whcoding.base.project.controller 包中所有类的public方法都应用切面里的通知
execution(public * com.whcoding.base.project.controller.*.*(..))
//com.whcoding.base.project.service包及其子包下所有类中的所有方法都应用切面里的通知
execution(* com.whcoding.base.project.service..*.*(..))
```



### 1.3.添加AOP切面实现接口日志记录

#### 1.3.1.业务背景：

项目有新的需求 需要做日志分析，以及方法的请求统计。

- 1.统计各个类别的方法[增、删、改、查、导入、导出]
- 2.查看方法请求的参数，耗时，以及返回的数据

当接到这个需求的时候需要怎么实现呢，下面谈谈我的思路

1. 使用AOP切面，获取 `HttpServletRequest`的参数，切入Controller

2. 自定义注解，在方法增加注解类型，用于判断方法类型

   

#### 1.3.2.如何实现

##### 1.3.2.1 引入依赖

```xml
<!-- aop 工具类 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
```



##### 1.3.2.2 增加webLog 实体和BusinessType 枚举

```java
package com.whcoding.base.project.pojo;

import com.whcoding.base.project.constant.BusinessType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @program: spring-boot-learning
 * @description:
 * @author: whcoding
 * @create: 2022-06-28 15:46
 **/
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WebLog {
	/**
	 * 线程id
	 */
	private String threadId;
	/**
	 * 线程名称
	 */
	private String threadName;
	/**
	 * ip地址
	 */
	private String ip;
	/**
	 * url
	 */
	private String url;
	/**
	 * http方法 GET POST PUT DELETE PATCH
	 */
	private String httpMethod;
	/**
	 * 类方法
	 */
	private String classMethod;
	/**
	 * 请求参数
	 */
	private Object requestParams;
	/**
	 * 返回参数
	 */
	private Object result;
	/**
	 * 接口耗时
	 */
	private Long timeCost;
	/**
	 * 操作系统
	 */
	private String os;
	/**
	 * 浏览器
	 */
	private String browser;
	/**
	 * user-agent
	 * 用户代理
	 */
	private String userAgent;

	/**
	 * 操作时间
	 */
	private Long operationTime;

	/**
	 * 方法描述信息
	 */
	private String description;

	/**
	 * 方法 类型 [增删改查 导入 导出]
	 */
	private String businessTypeValue;

	/**
	 * 方法 类型 [增删改查 导入 导出] Code
	 */
	private Integer businessTypeCode;

}

```

**BusinessType** 枚举

```java
package com.whcoding.base.project.constant;

/**
 * @program: spring-boot-learning
 * @description: 操作类型
 * @author: whcoding
 * @create: 2022-07-01 17:56
 **/
public enum BusinessType {

	SAVE("保存", 1001),
	DELETE("删除", 1002),
	UPDAATE("保存", 1003),
	QUERY("查询", 1004),
	IMPORT("导入", 1005),
	EXPORT("导出", 1006),
	OTHER("其他", 1007);

	private String value;
	private Integer code;

	BusinessType(String value, Integer code) {
		this.code = code;
		this.value = value;
	}

	public String getValue() {
		return value;
	}

	public Integer getCode() {
		return code;
	}

}

```



##### 1.3.2.3 增加切面AopLog

```java
package com.whcoding.base.project.aspectj;

import cn.hutool.core.util.ArrayUtil;
import cn.hutool.json.JSONUtil;
import com.google.common.collect.Maps;
import com.whcoding.base.project.annotion.AutoLog;
import com.whcoding.base.project.constant.BaseConstant;
import com.whcoding.base.project.constant.BusinessType;
import com.whcoding.base.project.pojo.WebLog;
import eu.bitwalker.useragentutils.UserAgent;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Method;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Collections;
import java.util.Date;
import java.util.Map;
import java.util.Objects;

/**
 * <p>
 * 使用 aop 切面记录请求日志信息
 * </p>
 *
 * @author whcoding
 * @date Created in 2021-10-25 20:05
 */
@Aspect
@Component
@Slf4j
public class AopLog {
	/**
	 * 切入点
	 * <p>
	 * 方法一；只扫描Controller @Pointcut("execution(public * com.whcoding.base.project.controller.*Controller.*(..))")
	 * 方法二; 增加注解扫描 @Pointcut("@annotation(com.whcoding.base.project.annotion.AutoLog)")
	 */
//  @Pointcut("execution(public * com.whcoding.base.project.controller.*Controller.*(..))")
	@Pointcut("@annotation(com.whcoding.base.project.annotion.AutoLog)")
	public void webLog() {

	}

	/**
	 * 环绕操作
	 *
	 * @param point 切入点
	 * @return 原方法返回值
	 * @throws Throwable 异常信息
	 */
	@Around("webLog()")
	public Object aroundLog(ProceedingJoinPoint point) throws Throwable {

		// 开始打印请求日志
		ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
		HttpServletRequest request = Objects.requireNonNull(attributes).getRequest();

		// 打印请求相关参数
		long startTime = System.currentTimeMillis();
		Object result = point.proceed();
		String header = request.getHeader("User-Agent");
		UserAgent userAgent = UserAgent.parseUserAgentString(header);

		//获取API注解的描述信息
		Signature signature = point.getSignature();
		MethodSignature methodSignature = (MethodSignature) signature;
		Method method = methodSignature.getMethod();
		String descriptionStr = BaseConstant.DEFAULT_STRING_VALUE;
		Integer businessTypeCode= BaseConstant.DEFAULT_VALID_ZERO;
		String businessTypeValue= BaseConstant.DEFAULT_STRING_VALUE;

		if (method.isAnnotationPresent(AutoLog.class)) {
			AutoLog apiOperation = method.getAnnotation(AutoLog.class);
			descriptionStr = apiOperation.value();
			BusinessType businessType= apiOperation.businessType();
			if(Objects.nonNull(businessType)){
				businessTypeCode=businessType.getCode();
				businessTypeValue=businessType.getValue();
			}
		}

		final WebLog l = WebLog.builder()
				//操作时间
				.operationTime(startTime)
				//接口描述信息
				.description(descriptionStr)
				//增删改查
				.businessTypeCode(businessTypeCode)
				.businessTypeValue(businessTypeValue)
				.threadId(Long.toString(Thread.currentThread().getId()))
				.threadName(Thread.currentThread().getName())
				.ip(getIp(request))
				.url(request.getRequestURL().toString())
				.classMethod(String.format("%s.%s", point.getSignature().getDeclaringTypeName(),
						point.getSignature().getName()))
				.httpMethod(request.getMethod())
				.requestParams(getNameAndValue(point))
				.result(result)
				.timeCost(System.currentTimeMillis() - startTime)
				.userAgent(header)
				.browser(userAgent.getBrowser().toString())
				.os(userAgent.getOperatingSystem().toString()).build();

		log.info("Request Log Info : {}", JSONUtil.toJsonStr(l));

		return result;
	}

	/**
	 * 获取方法参数名和参数值
	 *
	 * @param joinPoint
	 * @return
	 */
	private Map<String, Object> getNameAndValue(ProceedingJoinPoint joinPoint) {

		final Signature signature = joinPoint.getSignature();
		MethodSignature methodSignature = (MethodSignature) signature;
		final String[] names = methodSignature.getParameterNames();
		final Object[] args = joinPoint.getArgs();

		if (ArrayUtil.isEmpty(names) || ArrayUtil.isEmpty(args)) {
			return Collections.emptyMap();
		}
		if (names.length != args.length) {
			log.warn("{}方法参数名和参数值数量不一致", methodSignature.getName());
			return Collections.emptyMap();
		}
		Map<String, Object> map = Maps.newHashMap();
		for (int i = 0; i < names.length; i++) {
			map.put(names[i], args[i]);
		}
		return map;
	}

	private static final String UNKNOWN = "unknown";

	/**
	 * 获取ip地址
	 */
	public static String getIp(HttpServletRequest request) {
		String ip = request.getHeader("x-forwarded-for");
		if (ip == null || ip.length() == 0 || UNKNOWN.equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || UNKNOWN.equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || UNKNOWN.equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		String comma = ",";
		String localhost = "127.0.0.1";
		if (ip.contains(comma)) {
			ip = ip.split(",")[0];
		}
		if (localhost.equals(ip)) {
			// 获取本机真正的ip地址
			try {
				ip = InetAddress.getLocalHost().getHostAddress();
			} catch (UnknownHostException e) {
				log.error(e.getMessage(), e);
			}
		}
		return ip;
	}
}

```



##### 1.3.2.4 增加自定义注解

```java
package com.whcoding.base.project.annotion;

import com.whcoding.base.project.constant.BusinessType;

import java.lang.annotation.*;

/**
 * @program: spring-boot-learning
 * @description:
 * @author: whcoding
 * @create: 2022-06-08 16:00
 **/
@Target(ElementType.METHOD) //作用于方法上
@Retention(RetentionPolicy.RUNTIME) //运行时生效
@Documented
public @interface AutoLog {
	/**
	 * 日志内容
	 *
	 * @return
	 */
	String value() default "";

	/**
	 * 功能
	 */
	BusinessType businessType() default BusinessType.OTHER;
}

```







#### 参考:

[统一日志](https://mp.weixin.qq.com/s?__biz=MzI1NDY0MTkzNQ==&mid=2247499074&idx=1&sn=186afefae2b6ba4de91686ef0e12f85a&chksm=e9c0af22deb7263412fbd85536494b840f7dd13a84cc8e4cb534a87e7b9c8a7d66864178e8a8&scene=178&cur_album_id=2369296394722934787#rd)

## 二、统一异常

[Controller返回数据封装](https://mp.weixin.qq.com/s/ANJ0DV9wyZA-mBdgDuiufw)


### 项目启动

[Swagger启动地址](http://localhost:9800/basic_project/swagger-ui.html#/)

[Swagger 增强版Knife4j启动地址](http://localhost:9800/basic_project/doc.html)



