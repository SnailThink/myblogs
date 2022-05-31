
### springcloud 结束进程
结束进程
``` linux
curl -X DELETE "http://192.168.8.164:10001/eureka/apps/E6-MS-TMS-BUSI-OPEN-API-WEB/172.16.57.21:8845"
```


### jar 打包
```sql
打包
https://blog.csdn.net/xiegqooo/article/details/9718351

用法: jar {ctxui}[vfmn0PMe] [jar-file] [manifest-file] [entry-point] [-C dir] files ...
选项:
  -c  创建新档案
  -t  列出档案目录
  -x  从档案中提取指定的 (或所有) 文件
  -u  更新现有档案
  -v  在标准输出中生成详细输出
  -f  指定档案文件名
  -m  包含指定清单文件中的清单信息
  -n  创建新档案后执行 Pack200 规范化
  -e  为捆绑到可执行 jar 文件的独立应用程序
    指定应用程序入口点
  -0  仅存储; 不使用任何 ZIP 压缩
  -P  保留文件名中的前导 '/' (绝对路径) 和 ".." (父目录) 组件
  **-M  不创建条目的清单文件**
  -i  为指定的 jar 文件生成索引信息
  -C  更改为指定的目录并包含以下文件
如果任何文件为目录, 则对其进行递归处理。
清单文件名, 档案文件名和入口点名称的指定顺序
与 'm', 'f' 和 'e' 标记的指定顺序相同。

**示例 1: 将两个类文件归档到一个名为 classes.jar 的档案中: 
    jar cvf classes.jar Foo.class Bar.class** 
**示例 2: 使用现有的清单文件 'mymanifest' 并
      将 foo/ 目录中的所有文件归档到 'classes.jar' 中: 
    jar cvfm classes.jar mymanifest -C foo/ .**

- 解压 ：jar -xvf jar包名字.jar
- 合并 ：jar cvf classes.jar *
```


### lambda forEach方法跳出循环

今天在`code review`的时候发现同事用forEach有点问题。

不知道大家是怎么在foreash 中跳出循环的。

首先回顾下forEach跳出循环：

- continue ： 终止本次循环，继续下一次循环。 
- break： 终止本循环 

那么在Java8中如何使用，如果在Java8中直接写 `continue`会提示`Continue outside of loop`，`break`则会提示`Break outside switch or loop`，`continue/break` 需要在循环外执行.

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531095032.png)



lambda foreach()处理集合时**不能使用break和continue**, 也就是说不能按照普通的for循环遍历集合时那样根据条件来中止循环。  而如果要实现在普通for循环中的效果时，可以使用return来达到

**lambda表达式forEach中使用return相当于普通for循环中的continue **

### 终止本次循环，继续下一次循环

```java
@Test
	void forEashDemo() {
		List<String> list = Arrays.asList("A1", "B2", "C3", "D5", "11", "22", "33", "44");

		List<Integer> integerList = Arrays.asList(1, 2, 3, 5, 11, 22, 33, 44);

		//跳出本次循环
		for (Integer integer : integerList) {
			if (integer > 11) {
				continue;
			}
			System.out.println("普通forEach循环"+integer);
		}

		//java 8跳出本次循环
		integerList.stream().forEach(e -> {
			if (e > 11) {
				return;
			}
			System.out.println("lambda forEach循环"+e);
		});
	}
```



**输出结果**

```
普通forEach循环1
普通forEach循环2
普通forEach循环3
普通forEach循环5
普通forEach循环11
lambda forEach循环1
lambda forEach循环2
lambda forEach循环3
lambda forEach循环5
lambda forEach循环11
```

### 终止本循环 

```java
@Test
	void forEashDemo2() {
		List<Integer> integerList = Arrays.asList(1, 2, 3, 5, 11, 22, 33, 44);

		//跳出for循环
		for (Integer integer : integerList) {
			if (integer > 11) {
				break;
			}
			System.out.println("普通forEach循环："+integer);
		}

		//java 8跳出本次循环
		integerList.stream().forEach(e -> {
			if (e > 11) {
				throw new RuntimeException("终止lambda forEach循环");
			}
			System.out.println("lambda forEach循环："+e);
		});
	}
```



**输出结果**

```
普通forEach循环：1
普通forEach循环：2
普通forEach循环：3
普通forEach循环：5
普通forEach循环：11
lambda forEach循环：1
lambda forEach循环：2
lambda forEach循环：3
lambda forEach循环：5
lambda forEach循环：11

java.lang.RuntimeException: 终止lambda forEach循环
```

### 1. gitlab 如何merge 代码


#### **1.选择自己的分支然后点击 Create merge**

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531091149.png)

**2.选择分支**

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531091213.png)

**3.选择自己的分支和远程分支进行merge**

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531091224.png)

#### 2.如何将不同的项目放在同一个IDEA中打开

**1.选择project structure**

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531091234.png)

**2.导入项目所在的文件件**

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531091244.png)

**3.选择maven导入项目一路下一步保存**



![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531091254.png)

### 2.Java常见错误



#### 1.微服务启动报Cannot execute request on any known server 

微服务：发现（eureka）采坑记录：

报Cannot execute request on any known server 这个错：连接Eureka服务端地址不对。

有以下几种处理方式。

一、更改.yml文件或者.properties文件配置即可：

下划线+下划线后面的小写字母等同于去掉下划线大写下划线后面的字母（驼峰原则）

```yml
eureka.client.registerWithEureka=false   #是否将自己注册到 Eureka-Server 中，默认的为 true   registerWithEureka等同于register_with_eureka
eureka.client.fetchRegistry=false        #是否需要拉取服务信息，默认未true       fetchRegistry等同于 fetch-registry
```

二、连接Eureka服务端URL不对：

如果访问地址是：http://127.0.0.1:8761/eureka/

则在Eureka服务发现应该配置为：

server.port: 8761

eureka.client.serviceUrl.defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/

 三、注销依赖以及清空下载的eureka依赖包： 

```xml
<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
   <version>2.1.1.RELEASE</version>
</dependency>
```

[参考网址](https://blog.csdn.net/sevenmt/article/details/91793311)

#### 解决required a bean of type ‘XXX’ that could not be found.的问题

 **一、没有给对应的DAO接口注入@Mapper属性**
通常这个问题是有可能是忘记了或者粗心大意所遇到的，也是比较的简单，直接添加@Mapper就可以解决了 

```java
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AlarmSettingMapper {

}
```

 **二、Mapper引入的时候引入错了包**
第二种情况我这个菜鸟不太懂，但是有试过就是同样的引入的Mapper里面，引入的不是我们需要的Mybatis，所以出现找不到的情况，这种情况确实不太好定位，因为这也很难看出来。。。。 

注意这个@Mapper是不能引入成别的的了

**三、包扫描不到！！！！！是主启动类的报名和你的Bean文件的包裹问题**
注意，我的Bean文件的包名是“org.Choiridong.Security.DAO”
但是！！！重点来了，如果你的启动类是这样子的（我之前启动类就是这样）“[org.Choiridong.web](http://org.choiridong.web/)”
请注意，这样子就会有问题，据我了解，之前看到资料是说，主类只会扫面主类文件下面的包，所以，我的Bean文件自然是没有办法扫到的，他只能扫到“[org.Choiridong.web](http://org.choiridong.web/)”之后的部分，所以把主类名字改成“org.Choiridong”改成这样子之后，就可以了 

####  3.解决method xxx in xxx required a bean of type 'java.lang.String' that could not be found


#### 4.intellij debug模式提示 Method breakpoints may dramatically slow down debugging 解决办法

原因：断点加在了

 **快捷键（Ctrl - Shift -F8 ） 出现所有的断点**

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531091323.png)

