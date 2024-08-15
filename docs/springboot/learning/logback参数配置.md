##

###  一、获取系统环境变量



java获取系统[环境变量](https://so.csdn.net/so/search?q=环境变量&spm=1001.2101.3001.7020)使用方法为`System.getenv()`(获取全部的环境信息)，`System.getenv(key)`(获取某个环境信息)；
`key`的常用值如下表所示

![image-20220608170951570](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220608170958.png)



#### 1.1 Java获取环境变量

System.getEnv() 得到所有的[环境变量](https://so.csdn.net/so/search?q=环境变量&spm=1001.2101.3001.7020)

System.getEnv(key) 得到某个环境变量

```java
	Map map = System.getenv();
		Iterator it = map.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry entry = (Map.Entry) it.next();
			System.out.print(entry.getKey() + "=");
			System.out.println(entry.getValue());
		}
		String javaHome = System.getenv("JAVA_HOME");
		System.out.println("JavaHome 环境变量为:"+javaHome);
```



#### 1.2 获取系统环境变量

ava 获取环境变量的方式也很简单：

System.getProperties() 得到所有的系统变量

System.getProperty(key) 得到某个系统变量的值

```java
/**
	 * 2.获取系统环境变量
	 */
	@Test
	public void systemParam() {
		Properties properties = System.getProperties();
		Iterator it =  properties.entrySet().iterator();
		while(it.hasNext())
		{
			Map.Entry entry = (Map.Entry)it.next();
			System.out.print(entry.getKey()+"=");
			System.out.println(entry.getValue());
		}
	}
```

#### 1.3 设置环境变量

可以通过System.setProperty(key, value) 的方式设置自己需要的系统变量。

```java
//		// java类路径
//		String javaClassPath = System.getProperty("java.class.path");
//		System.out.println(javaClassPath);
//		//修改环境变量
//		System.setProperty("java.class.path", javaClassPath + ";D:\\");
//
//		javaClassPath = System.getProperty("java.class.path");
//		System.out.println(javaClassPath);
```



### 二、logback.xml获取配置参数



#### 2.1 通过yml文件获取参数

**2.1.1 在yml文件中增加参数:**

```yml
whcoding: whcodingLog
```

**2.1.2 在logback.xml文件中添加配置**

```xml
<!--读取yml文件中的配置信息-->
<springProperty scope="context" name="whcodingValue" source="whcoding" defaultValue="logs"/>
```

**2.1.3 读取yml中的配置参数**

```xml

<!--${whcodingValue}  获取参数-->
<FileNamePattern>logs/demo-base-project/${whcodingValue}_info.created_on_%d{yyyy-MM-dd}.part_%i.log</FileNamePattern>
```



#### 2.2 通过程序获取擦参数



**2.2.1 设置配置参数[环境变量]**

```java
package com.whcoding.base.project.property;

import ch.qos.logback.core.PropertyDefinerBase;

/**
 * @program: spring-boot-learning
 * @description: logback-spring.xml 中使用该参数
 * @author: whcoding
 * @create: 2022-06-08 16:57
 **/
public class CanonicalConfigPropertyDefiner extends PropertyDefinerBase {
	/***
	 * 获取系统环境变量 根据系统需求获取配置信息
	 * @return
	 */
	@Override
	public String getPropertyValue() {
         String javaHome = System.getenv("JAVA_HOME");
		return "ConfigProperty6666";
	}
}
```

**2.2.2 logback.xml配置CanonicalConfigPropertyDefiner**

```xml
<!--通过CanonicalConfigPropertyDefiner 获取对应数据 -->
<define name="configParam" class="com.whcoding.base.project.property.CanonicalConfigPropertyDefiner"/>
```

**2.2.3 读取配置信息**

```xml
${configParam}  获取参数
```

