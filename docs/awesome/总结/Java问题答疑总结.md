

### Java问题答疑总结

## 一、API接口相关



### 1.接口幂等实现方案主要有8种：

- select+insert+主键/唯一索引冲突

- 直接 insert + 主键/唯一索引冲突

- 状态机幂等

- 抽取防重表

- token 令牌

- 悲观锁

- 乐观锁

- 分布式锁

### 2.SQL 优化从这几个维度思考：

- explain 分析 SQL 查询计划（重点关注 type、extra、filtered 字段）
- show profile 分析，了解 SQL 执行的线程的状态以及消耗的时间
- 索引优化 （覆盖索引、最左前缀原则、隐式转换、order by 以及 group by 的优化、join 优化）
- 大分页问题优化（延迟关联、记录上一页最大 ID）
- 数据量太大（分库分表、同步到 es，用 es 查询）

### 3. **写代码时，考虑线性安全问题**

在高并发情况下，HashMap 可能会出现死循环。因为它是非线性安全的，可以考虑使用 ConcurrentHashMap。

所以这个也尽量养成习惯，不要上来反手就是一个 new HashMap();

- Hashmap、Arraylist、LinkedList、TreeMap等都是线性不安全的
- Vector、Hashtable、ConcurrentHashMap等都是线性安全的



### 4.分布式事务的几种解决方案

- 2PC（二阶段提交）方案、3PC
- TCC（Try、Confirm、Cancel）
- 本地消息表
- 最大努力通知
- seata



### 5.异常处理：

- 尽量不要使用 e.printStackTrace()，而是使用 log 打印。因为 e.printStackTrace() 语句可能会导致内存占满
- catch 住异常时，建议打印出具体的 exception，利于更好定位问题
- 不要用一个 Exception 捕捉所有可能的异常
- 记得使用 finally 关闭流资源或者直接使用 try-with-resource
- 捕获异常与抛出异常必须是完全匹配，或者捕获异常是抛异常的父类
- 捕获到的异常，不能忽略它，至少打点日志吧
- 注意异常对你的代码层次结构的侵染
- 自定义封装异常，不要丢弃原始异常的信息 Throwable cause
- 运行时异常 RuntimeException ，不应该通过 catch 的方式来处理，而是先预检查，比如：NullPointerException 处理
- 注意异常匹配的顺序，优先捕获具体的异常





###  6.如何保证缓存与数据库数据一致性

[数据一致性](https://blog.csdn.net/qq_42253147/article/details/94447103)



严格要求缓存+数据库必须一致性

将不一致分为三种情况：

1. 数据库有数据，缓存没有数据；
2. 数据库有数据，缓存也有数据，数据不相等；
3. 数据库没有数据，缓存有数据。



 在讨论这三种情况之前，先说明一下使用缓存的策略，叫做 Cache Aside Pattern。 **旁路缓存模式**  简而言之就是 



 **1.首先尝试从缓存读取，读到数据则直接返回；如果读不到，就读数据库，并将数据会写到缓存，并返回** 

 **2.需要更新数据时，先更新数据库，然后把缓存里对应的数据失效掉（删掉）** 

 第一种**数据库有数据，缓存没有数据**：在读数据的时候，会自动把数据库的数据写到缓存，因此不一致自动消除. 

 第二种**数据库有数据，缓存也有数据，数据不相等**：数据最终变成了不相等，但他们之前在某一个时间点一定是相等的（不管你使用懒加载还是预加载的方式，在缓存加载的那一刻，它一定和数据库一致）。这种不一致，一定是由于你更新数据所引发的。前面我们讲了更新数据的策略，先更新数据库，然后删除缓存。因此，不一致的原因，一定是数据库更新了，但是删除缓存失败了。 

 第三种**数据库没有数据，缓存有数据**，情况和第二种类似，你把数据库的数据删了，但是删除缓存的时候失败了。 



 因此，最终的结论是，需要解决的不一致，产生的原因是更新数据库成功，但是删除缓存失败。 

 **解决方案大概有以下几种：** 

  对删除缓存进行重试，数据的一致性要求越高，我越是重试得快。 

 定期全量更新，简单地说，就是我定期把缓存全部清掉，然后再全量加载。 

 给所有的缓存一个失效期。 



 第三种方案可以说是一个大杀器，任何不一致，都可以靠失效期解决，失效期越短，数据一致性越高。但是失效期越短，查数据库就会越频繁。因此失效期应该根据业务来定。 



**并发不高的情况：**

读: 读redis->没有，读mysql->把mysql数据写回redis，有的话直接从redis中取；

写: 写mysql->成功，再写redis；

**并发高的情况：**

读: 读redis->没有，读mysql->把mysql数据写回redis，有的话直接从redis中取；

写：异步话，先写入redis的缓存，就直接返回；定期或特定动作将数据保存到mysql，可以做到多次更新，一次保存







### 7.事物的四大特性(ACID)

1. **原子性（Atomicity）：** 事务是最小的执行单位，不允许分割。事务的原子性确保动作要么全部完成，要么完全不起作用；
2. **一致性（Consistency）：** 执行事务前后，数据保持一致，多个事务对同一个数据读取的结果是相同的；
3. **隔离性（Isolation）：** 并发访问数据库时，一个用户的事务不被其他事务所干扰，各并发事务之间数据库是独立的；
4. **持久性（Durability）：** 一个事务被提交之后。它对数据库中数据的改变是持久的，即使数据库发生故障也不应该对其有任何影响。



### 8.常见的rpc 框架

 **RMI（JDK自带）：** JDK自带的RPC。详细内容可以参考 

- **Dubbo:** Dubbo是 阿里巴巴公司开源的一个高性能优秀的服务框架，使得应用可通过高性能的 RPC 实现服务的输出和输入功能，可以和 Spring框架无缝集成。详细内容可以参考：[高性能优秀的服务框架-dubbo介绍](https://blog.csdn.net/qq_34337272/article/details/79862899)

- **gRPC**： Google 公布的开源软件，基 HTTP 2.0 协议，并支持常见的众多编程语言。
- **Thrift：** Apache Thrift是Facebook开源的跨语言的RPC通信框架，目前已经捐献给Apache基金会管理，由于其跨语言特性和出色的性能，在很多互联网公司得到应用，有能力的公司甚至会基于thrift研发一套分布式服务框架，增加诸如服务注册、服务发现等功能。详细内容可以参考： [【Java】分布式RPC通信框架Apache Thrift 使用总结](https://www.cnblogs.com/zeze/p/8628585.html)
- **Hessian：** Hessian是一个轻量级的remotingonhttp工具，使用简单的方法提供了RMI的功能。 相比WebService，Hessian更简单、快捷。采用的是二进制RPC协议，因为采用的是二进制协议，所以它很适合于发送二进制数据。详细内容可以参考： [Hessian的使用以及理解](https://blog.csdn.net/sunwei_pyw/article/details/74002351)

### 9.Redis持久化

**两种持久化策略** 

1.AOF：记录每一次的写操作到日志上，重启时重放日志以重建数据

 2.RDB：每隔一段时间保存一次当前时间点上的数据快照   快照就是一次又一次地从头开始创造一切 

3.可以关闭持久化

 4.在持久化上、AOF好一些，但AOF依然存在不如RDB的地方

**AOF 优点**    

多种策略可以选择：是每秒同步一次（默认，灾难发生会丢失1秒的数据）、还是每次请求时同步一次

（超级慢 + 超级安全）、从不执行同步。    日志使用追加模式；当日志太大时Redis会重新创建一个日志写    

重写日志是安全的，Redis一边会在旧的日志上追加，一边会创建新的日志文件，一旦新日志创建完毕，

就往新文件上追加



**缺点**    AOF文件显然占据大量存储空间    举例：对count = 1累加100次，最终的结果是count对应的值只会有一个，就是100；但是AOF文件里面却有100条记录 当你恢复的时候他会超级费时的重复这些操作（浪费！）    AOF比RDB慢，有延迟    bug比RDB多     AOF文件损坏后就麻烦了，redis-check-aof --fix命令用于修复



**RDB ** 

**优点**：   对于每个一段时间要保存一下数据特别适用。如：每隔24小时保存一次数据    可以保存不同时间点的rdb（通过复制备份，看下文），然后你可以恢复不同时间点的数据库    由于保存的是整个库，所以恢复大数据集特别快    启动子进程来处理RDB文件的写入 



**缺点**    在时间间隔内挂掉的话数据会丢失，要做好一定会丢失数据的准备    RDB 需要经常调用 fork()子进程来持久化到磁盘。如果数据集很大的话，fork()比较耗时，结果就是，当数据集非常大并且 CPU 性能不够强大的话，Redis 会停止服务客户端几毫秒甚至一秒 **选择谁** 如果可以接受丢失几分钟的数据，选择RDB吧！



### 10.Spring 读取配置文件也是有优先级的

![image-20220527161154499](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220527161220.png)

### 11.SpringBoot自动装配

 `@SpringBootApplication` 标注是一个springboot的应用 

- ```java
  @SpringBootConfiguration   springboot的配置
  @Configuration   spring的配置类
  @Component   说明这也是一个spring的组件
  @EnableAutoConfiguration   开启自动配置
  @AutoConfigurationPackage  自动配置包
  @Import(AutoConfigurationPackages.Registrar.class)  导入选择器
  @Import(AutoConfigurationImportSelector.class)   导入选择器
  List<String> configurations = getCandidateConfigurations(annotationMetadata, attributes); 获取所有的配置
  ```
  
- ```java
  //获取所有的配置
  protected List<String> getCandidateConfigurations(AnnotationMetadata metadata, AnnotationAttributes attributes) {
     List<String> configurations = SpringFactoriesLoader.loadFactoryNames(getSpringFactoriesLoaderFactoryClass(),
           getBeanClassLoader());
     Assert.notEmpty(configurations, "No auto configuration classes found in META-INF/spring.factories. If you "
           + "are using a custom packaging, make sure that file is correct.");
     return configurations;
  }
  
  protected Class<?> getSpringFactoriesLoaderFactoryClass() {
      return EnableAutoConfiguration.class;
   }
  ```
  
- META-INF/spring.factories  自动配置的核心文件

 **SpringBoot自动装配**

![](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530102041.png)

spring-factories 存放的都是自动配置类的名称，主程序启动时候就通过注解将自动配置类全部加载，有了这些配置类就省去写配置文件.

[springboot自动装配](https://juejin.cn/post/6939520188823896100)

[springboot原理解析](https://juejin.cn/post/6939470264853889061#heading-19)

### 12.集合

#### 12.1  Arraylist 与 LinkedList 区别?

1. 是否保证线程安全： ArrayList 和 LinkedList 都是不同步的，也就是不保证线程安全；
2. **底层数据结构：** `Arraylist` 底层使用的是 **`Object` 数组**；`LinkedList` 底层使用的是 **双向链表** 数据结构（JDK1.6 之前为循环链表，JDK1.7 取消了循环。
3. **插入和删除是否受元素位置的影响：** ① **`ArrayList` 采用数组存储，所以插入和删除元素的时间复杂度受元素位置的影响。** 比如：执行`add(E e)`方法的时候， `ArrayList` 会默认在将指定的元素追加到此列表的末尾，这种情况时间复杂度就是 O(1)。但是如果要在指定位置 i 插入和删除元素的话（`add(int index, E element)`）时间复杂度就为 O(n-i)。因为在进行上述操作的时候集合中第 i 和第 i 个元素之后的(n-i)个元素都要执行向后位/向前移一位的操作。 ② **`LinkedList` 采用链表存储，所以对于`add(E e)`方法的插入，删除元素时间复杂度不受元素位置的影响，近似 O(1)，如果是要在指定位置`i`插入和删除元素的话（`(add(int index, E element)`） 时间复杂度近似为`o(n))`因为需要先移动到指定位置再插入。**
4. **是否支持快速随机访问：** `LinkedList` 不支持高效的随机元素访问，而 `ArrayList` 支持。快速随机访问就是通过元素的序号快速获取元素对象(对应于`get(int index)`方法)。
5. **内存空间占用：** ArrayList 的空 间浪费主要体现在在 list 列表的结尾会预留一定的容量空间，而 LinkedList 的空间花费则体现在它的每一个元素都需要消耗比 ArrayList 更多的空间（因为要存放直接后继和直接前驱以及数据）。
6. LinkedList 言插入删除操作很快，但是查询操作很慢

#### 12.2 如何选用集合

需要排序时选择 `TreeMap`,不需要排序时就选择 `HashMap`,需要保证线程安全就选用 `ConcurrentHashMap`。

当我们只需要存放元素值时，就选择实现`Collection` 接口的集合，需要保证元素唯一时选择实现 `Set` 接口的集合比如 `TreeSet` 或 `HashSet`，不需要就选择实现 `List` 接口的比如 `ArrayList` 或 `LinkedList`，然后再根据实现这些接

#### 12.3 HashSet、LinkedHashSet 和 TreeSet 三者的异同

`HashSet` 是 `Set` 接口的主要实现类 ，`HashSet` 的底层是 `HashMap`，线程不安全的，可以存储 null 值；

`LinkedHashSet` 是 `HashSet` 的子类，能够按照添加的顺序遍历；

`TreeSet` 底层使用红黑树，能够按照添加元素的顺序进行遍历，排序的方式有自然排序和定制排序。



### 13.**面向对象的五大基本原则**

**单一职责原则（Single-Responsibility Principle）**

其核心思想为：一个类，最好只做一件事，只有一个引起它的变化。

单一职责原则可以看做是低耦合、高内聚在面向对象原则上的引申，将职责定义为引起 变化的原因，以提高内聚性来减少引起变化的原因。

职责过多，可能引起它变化的原因就越多，这将导致职责依赖，相互之间就产生影响， 从而大大损伤其内聚性和耦合度。

通常意义下的单一职责，就是指只有一种单一功能，不要为类实现过多的功能点，以保 证实体只有一个引起它变化的原因。

专注，是一个人优良的品质；同样的，单一也是一个类的优良设计。交杂不清的职责将 使得代码看起来特别别扭牵一发而动全身，有失美感和必然导致丑陋的系统错误风险。

**开放封闭原则（Open-Closed principle）**

其核心思想是：软件实体应该是可扩展的，而不可修改的。也就是，对扩展开放，对修 改封闭的。

开放封闭原则主要体现在两个方面：

1、对扩展开放，意味着有新的需求或变化时，可以对现有代码进行扩展，以适应新的 情况。 2、对修改封闭，意味着类一旦设计完成，就可以独立完成其工作，而不要对其进行任 何尝试的修改。

实现开放封闭原则的核心思想就是对抽象编程，而不对具体编程，因为抽象相对稳定。 让类依赖于固定的抽象，所以修改就是封闭的；而通过面向对象的继承和多态机制，又可实现对抽象类的继承，通过覆写其方法来改变固有行为，实现新的拓展方法，所以就是开放的。

“需求总是变化”没有不变的软件，所以就需要用封闭开放原则来封闭变化满足需求， 同时还能保持软件内部的封装体系稳定，不被需求的变化影响。

**Liskov 替换原则（Liskov-Substitution Principle）**

其核心思想是：子类必须能够替换其基类。这一思想体现为对继承机制的约束规范，只 有子类能够替换基类时，才能保证系统在运行期内识别子类，这是保证继承复用的基础。

在父类和子类的具体行为中，必须严格把握继承层次中的关系和特征，将基类替换为子 类，程序的行为不会发生任何变化。同时，这一约束反过来则是不成立的，子类可以替换基 类，但是基类不一定能替换子类。

Liskov 替换原则，主要着眼于对抽象和多态建立在继承的基础上，因此只有遵循 Liskov 替换原则，才能保证继承复用是可靠地。

实现的方法是面向接口编程：将公共部分抽象为基类接口或抽象类，通过 Extract Abstract Class，在子类中通过覆写父类的方法实现新的方式支持同样的职责。 Liskov 替换原则是关于继承机制的设计原则，违反了 Liskov 替换原则就必然导致违反开放封闭原 则。 Liskov 替换原则能够保证系统具有良好的拓展性，同时实现基于多态的抽象机制，能 够减少代码冗余，避免运行期的类型判别。

**依赖倒置原则（Dependecy-Inversion Principle）**

其核心思想是：依赖于抽象。具体而言就是高层模块不依赖于底层模块，二者都同依赖 于抽象；抽象不依赖于具体，具体依赖于抽象。

我们知道，依赖一定会存在于类与类、模块与模块之间。当两个模块之间存在紧密的耦 合关系时，最好的方法就是分离接口和实现：在依赖之间定义一个抽象的接口使得高层模块 调用接口，而底层模块实现接口的定义，以此来有效控制耦合关系，达到依赖于抽象的设计 目标。

抽象的稳定性决定了系统的稳定性，因为抽象是不变的，依赖于抽象是面向对象设计的 精髓，也是依赖倒置原则的核心。 依赖于抽象是一个通用的原则，而某些时候依赖于细节 则是在所难免的，必须权衡在抽象和具体之间的取舍，方法不是一层不变的。依赖于抽象， 就是对接口编程，不要对实现编程。

**接口隔离原则（Interface-Segregation Principle）**

其核心思想是：使用多个小的专门的接口，而不要使用一个大的总接口。

具体而言，接口隔离原则体现在：接口应该是内聚的，应该避免“胖”接口。一个类对 另外一个类的依赖应该建立在最小的接口上，不要强迫依赖不用的方法，这是一种接口污染。

接口有效地将细节和抽象隔离，体现了对抽象编程的一切好处，接口隔离强调接口的单 一性。而胖接口存在明显的弊端，会导致实现的类型必须完全实现接口的所有方法、属性等； 而某些时候，实现类型并非需要所有的接口定义，在设计上这是“浪费”，而且在实施上这 会带来潜在的问题，对胖接口的修改将导致一连串的客户端程序需要修改，有时候这是一种 灾难。在这种情况下，将胖接口分解为多个特点的定制化方法，使得客户端仅仅依赖于它们 的实际调用的方法，从而解除了客户端不会依赖于它们不用的方法。

分离的手段主要有以下两种：

1、委托分离，通过增加一个新的类型来委托客户的请求，隔离客户和接口的直接依赖， 但是会增加系统的开销。 2、多重继承分离，通过接口多继承来实现客户的需求，这种方式是较好的。

### 14.Stream和parallelStream 区别

**并行流parallelStream:**parallelStream提供了流的并行处理，它是Stream的另一重要特性，其底层使用**Fork/Join**框架实现。简单理解就是多线程异步任务的一种实现。

**样例数据:**

```java
public String testMailRetryer() {
		String resp = "success";

		Callable<Boolean> mailCallable = new Callable<Boolean>() {
			int times = 0;

			@Override
			public Boolean call() {
				times++;
				logger.info("mail重试第{}次", times);
				if (times == 7) {
					return true;
				}
				return false;
			}
		};
		try {
			mailRetryer.call(mailCallable);
		} catch (Exception e) {
			System.out.println(e);
			resp = "fail";
		}
		return resp;
	}
```

### 15.forEachOrdered 和 forEach区别

`forEachOrdered()`和`forEach()`方法的区别在于`forEachOrdered()`将始终按照流(`stream`)中元素的遇到顺序执行给定的操作，而`forEach()`方法是不确定的。

在并行流(`parallel stream`)中，`forEach()`方法可能不一定遵循顺序，而`forEachOrdered()`将始终遵循顺序。

在序列流(`sequential stream`)中，两种方法都遵循顺序。

如果我们希望在每种情况下，不管流(`stream`)是连续的还是并行的，都要按照遵循顺序执行操作，那么我们应该使用`forEachOrdered()`方法。

如果流(`stream`)是连续的，我们可以使用任何方法来维护顺序。

但是如果流(`stream`)也可以并行，那么我们应该使用`forEachOrdered()`方法来维护顺序。

### 16.重写tostring

```java
package com.whcoding.test.pojo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.util.Date;


/**
 * @author Manager
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
//链式写法
@Accessors(chain = true)
public class OrmDeptVO implements Serializable {
	private Long id;
	private Integer deptId;
	private String deptNo;
	private Integer deptType;
	private String deptName;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
	private Date createTime;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
	private Date updateTime;
	private transient BigDecimal deptPerf;
	private Integer isValidFlag;
	private String shortName;
	private String remark;


	@Override
	public String toString() {
		return modelToString(this);
	}

	/**
	 * 重写ToString
	 *
	 * @param t
	 * @param <T>
	 * @return
	 */
	public static <T> String modelToString(T t) {
		StringBuilder result = new StringBuilder("[");

		for (Field declaredField : t.getClass().getDeclaredFields()) {
			try {
				result
						.append(declaredField.getName())
						.append("=")
						.append(declaredField.get(t))
						.append(",");
			} catch (IllegalAccessException e) {
				declaredField.setAccessible(true);
				try {
					result
							.append(declaredField.get(t))
							.append(",");
				} catch (IllegalAccessException e1) {
					e1.printStackTrace();
				}
				declaredField.setAccessible(false);
			}
		}
		return result.substring(0, result.length() - 1) + "]";
	}
}

```



### 17.微服务启动报Cannot execute request on any known server

微服务：发现（eureka）采坑记录：

报Cannot execute request on any known server 这个错：连接Eureka服务端地址不对。

有以下几种处理方式。

一、更改.yml文件或者.properties文件配置即可：

下划线+下划线后面的小写字母等同于去掉下划线大写下划线后面的字母（驼峰原则）

```
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



### 18.微服务调用超时问题

![image-20220615111146993](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220615111146993.png)

[微服务调用超时](https://www.cnblogs.com/big-cut-cat/p/9893572.html)



## 二、基础

### 2.1 Java中的方法覆盖（Overwrite）和方法重载（Overloading）是什么意思？

重载Overload表示同一个类中可以有多个名称相同的方法，但这些方法的参数列表各不相同(即参数个数或类型不同)。

重写Override表示子类中的方法可以与父类的某个方法的名称和参数完全相同，通过子类创建的实例对象调用这个方法时，将调用子类中的定义方法，这相当于把父类中定义的那个完全相同的方法给覆盖了，这也是面向对象编程的多态性的一种表现。 

###  2.2 接口和抽象类的区别是什么？

抽象类：含有abstract修饰的类即为抽象类，抽象类不能创建实例对象。含有abstract方法的类必须定义为抽象类，抽象类中的方法不必是抽象的。抽象类中定义抽象方法必须在具体子类中实现，所以，不能有抽象构造方法或抽象静态方法。如果子类没有实现抽象父类中的所有抽象方法，那么子类也必须定义为abstract类型。

接口：可以说成是抽象类的一种特例，接口中的所有方法都必须是抽象的。接口中的方法定义默认为public abstract类型，接口中的成员变量类型默认为public static final。

下面比较一下两者的语法区别

1. 抽象类可以有构造方法，接口中不能有构造方法。

2. 抽象类中可以有普通成员变量，接口中没有普通成员变量

3. 抽象类中可以包含非抽象的普通方法，接口中的所有方法必须都是抽象的，不能有非抽象的普通方法。

4. 抽象类中的抽象方法的访问类型可以使public、protected和默认类型，但接口中的抽象方法只能是public类型的，并且默认修饰即为public abstract类型。

5. 抽象类中可以包含静态方法，接口中不能包含静态方法

6. 抽象类和接口中都可以包含静态成员变量，抽象类中的静态成员变量的访问类型可以任意，但接口中定义的变量只能是public static final类型，并且默认即为public static final类型。

7. 一个类可以实现多个接口，但只能继承一个抽象类。

###  1.3 创建线程有几种不通的方式？

 l 自定义类继承Thread类方式
 l 自定义类实现Runnable接口方式

### 1.4 Java集合框架的基本接口有哪些？

 Collection接口
 List接口
 Set接口
 Map接口

### 1.5 Java中的两种异常类型是什么？

 Error：称为错误，由java虚拟机生成并抛出，包括动态链接失败，虚拟机错误等，程序对其不做处理。
 Exception：所有异常类的父类，其子类对应了各种各样的可能出现的异常事件，一般需要用户显示的声明或捕获。
 Runtime Exception:一类特殊的异常，如被0除、数组下标超范围等，其产生比较频繁，处理麻烦，如果显示的声明或捕获将会对程序可读性和运行效率影响很大。因此由系统自动检测并将它们交给缺省的异常处理程序（用户可不必对其处理）。

### 1.7 Final,finallyfinalize的区别？

 final用于声明属性，方法和类，分别表示属性不可变，方法不可覆盖，类不可继承。内部类要访问局部变量，局部变量必须定义成final类型。
 finally是异常处理语句结构的一部分，表示总是执行。
 finalize是Object类的一个方法，在垃圾收集器执行的时候会调用被回收对象的此方法，可以覆盖此方法提高垃圾收集时的其他资源回收，例如关闭文件等。JVM不保证此方法总被调用。

###  1.8 Java中如何实现序列化，有什么意义？

 序列化就是一种用来处理对象流的机制，所谓对象流也就是将对象的内容进行流化。可以对流化后的对象进行读写操作，也可将流化后的对象传输于网络之间。序列化是为了解决对象流读写操作时可能引发的问题（如果不进行序列化可能会存在数据乱序的问题）。
 要实现序列化，需要让一个类实现Serializable接口，该接口是一个标识性接口，标注该类对象是可被序列化的，然后使用一个输出流来构造一个对象输出流并通过writeObject(Object)方法就可以将实现对象写出（即保存其状态）；如果需要反序列化则可以用一个输入流建立对象输入流，然后通过readObject方法从流中读取对象。序列化除了能够实现对象的持久化之外，还能够用于对象的深度克隆。



### 1.9 spring优点:

 a. Spring能有效地组织你的中间层对象，不管你是否选择使用了EJB。如果你仅仅使用了Struts或其他为J2EE的 API特制的framework，Spring致力于解决剩下的问题。
 b. Spring能消除在许多工程中常见的对Singleton的过多使用。根据我的经验，这是一个很大的问题，它降低了系统的可测试性和面向对象的程度。
 c. 通过一种在不同应用程序和项目间一致的方法来处理配置文件，Spring能消除各种各样自定义格式的属性文件的需要。曾经对某个类要寻找的是哪个魔法般的属性项或系统属性

 感到不解，为此不得不去读Javadoc甚至源编码？有了Spring，你仅仅需要看看类的JavaBean属性。Inversion of Control的使用（在下面讨论）帮助完成了这种简化。
 d. 通过把对接口编程而不是对类编程的代价几乎减少到没有，Spring能够促进养成好的编程习惯。
 e. Spring被设计为让使用它创建的应用尽可能少的依赖于他的APIs。在Spring应用中的大多数业务对象没有依赖于Spring。
 f. 使用Spring构建的应用程序易于单元测试。
 g. Spring能使EJB的使用成为一个实现选择,而不是应用架构的必然选择。你能选择用POJOs或local EJBs来实现业务接口，却不会影响调用代码。
 h. Spring帮助你解决许多问题而无需使用EJB。Spring能提供一种EJB的替换物，它们适用于许多web应用。例如，Spring能使用AOP提供声明性事务管理而不通过EJB容器，如果你仅仅需要与单个数据库打交道，甚至不需要一个JTA实现。 
 i. Spring为数据存取提供了一个一致的框架,不论是使用的是JDBC还是O/R mapping产品（如Hibernate）。
 Spring确实使你能通过最简单可行的解决办法来解决你的问题。而这是有有很大价值的。

### 1.10 谈谈Spring的IOC、AOP？

**IoC Inversion of Control 控制反转。**
我们以前开发，在一个类中使用其他类对象的时候都是采用new的方式直接获取，或者高级一点是通过反射的方式的得到需要的对象实例。这就造成了程序的耦合度非常高，一个类的运行，严重依赖于其他的类。并且还会出现程序中硬编码的情况。
而spring中的IoC很好的解决了该问题，我们在一个类中使用其他类对象时，只需要定义一个接口类型的类成员变量，由使用者在使用时为我们注入具体的实现类对象，从而降低了程序的耦合度。实现IoC的思想就只有两种：依赖注入（Dependency Injection，简称DI）和依赖查找（Dependency Lookup）。
而依赖注入使用的更广泛一些。例如：构造函数注入,set方法注入等等。

**AOP Aspect Oriented Programming 面向切面编程。**
我们之前学习的java语言，号称是面向对象编程，它有自己的优势。但是也存在着一些弊端。
举例说明，在实际开发中，我们都会有一根业务主线，即客户（甲方）的需求。而程序员要做的就是围绕业务主线上的需求，实现功能（实现功能的方法我们叫做业务核心方法）。但是不可避免的，会有一些功能与业务主线没有关系，却又不能不做，比如权限的控制，事务的控制，日志的记录等等，这些功能绝大多数时候和业务主线没有关系，但是却和很多业务核心方法交织在一起，使我们的开发变得麻烦，并且冗余代码增多。
而spring的提供了一种思想，把这些和业务主线没有关系的功能剥离出来，而在需要使用这些公共方法时，适时适地的把它加到我们的代码中去，使程序员在开发时，把更多的精力放在理解需求，实现业务核心功能上，并且让我们的代码变得简洁。这种思想就是面向切面编程。
Spring实现面向切面编程使用的是动态代理技术，并且会根据实际情况来选择使用基于子类的还是基于接口的动态代理。



### 2.11 简单介绍一下你对spring的理解?

任何框架在植入项目之中都不能带来效率的提升，反而是会带来效率的下降。因为java核心机制的问题，内存中多创建一个对象，就会造成性能降低。
但是，spring带来的好处还是显而易见的：
 1、它的核心之一IoC，降低了我们程序的耦合度，使我们可以把项目设计成为一个可插拔的组件式工程。
 2、它的另一大核心AOP，使我们在开发过程中，精力得到释放，可以更专注的去理解客户的需求。并且在后期维护时，可以只维护很少的一部分。
 3、它提供的事务管理机制，采用声明的方式来配置事务，从而在维护时无需改动源码，解决了程序硬编码的弊端。
 4、它提供的DAO模板使我们的持久层开发又多了一种途径。
 5、它可以整合其他时下流行的框架，使我们在管理项目时，更加清晰，明确。
并且以现在计算机的水平，使用spring框架造成的这点下降对程序的影响是微乎其微的。
所以，总体来说spring框架的使用还是利大于弊的。



### 2.12 你知道依赖注入么?简单介绍一下

首先，明确依赖注入是实现控制反转的一种思想（另一种是依赖查找）。
其次，在开发过程中，我们需要某个类的实例时，是由使用者为我们提供该类的实例。而不是自己去获取。
最后，实现依赖注入的方式可以是使用构造方法注入或者set方法注入两种方式。
在spring中注入的方式就有很多了，比如constructor-arg元素，property元素，p名称空间等等。

### **2.13 你知道控制反转么**?简单介绍一下

它是spring的核心之一。或者说是spring的基础核心，spring的其余核心功能都必须有IoC的支持。
控制反转指的是，我们在获取对象的时候，由之前的主动出击，变成了被动接收。也就是说，在编写某个类时，只需要提供一个接口类型的类成员，并不需要关系具体的实现类，而是由使用者在使用时提供。这就降低了类和类之间的耦合度。



## 三、数据库

### 3.1 .数据库索引失效

 避免对索引字段进行计算操作
 避免在索引字段上使用not，<>，!=
 避免在索引列上使用IS NULL和IS NOT NULL
 避免在索引列上出现数据类型转换
 避免在索引字段上使用函数
 避免建立索引的列中使用空值

- 不要以字符格式声明数字，要以数字格式声明字符值。（日期同样）否则会使索引无效，产生全表扫描。
- 避免在WHERE子句中使用in，not in，or 或者having。
- 尽量避免在 where 子句中对字段进行 null 值判断，否则将导致引擎放弃使用索引而进行全表扫描



## 四、问题处理

### 4.1.IDEA生成JavaDoc 

javadoc -encoding UTF-8 -charset UTF-8 DocTest.java

### 4.2.Windows执行Jar包 并指定环境

java -jar demo-helloworld.jar spring.profiles.active=dev

### 4.3.profiles文件执行先后顺序

spring boot启动会扫描以下位置的application.properties或者application.ymlI文件作为Spring boot的默认配置文件

- fle..config/

- file:./

- classpath:/config/

- classpath:/

  -以上是按照优先级从高到低的顺序,所有位置的文件都会被加载,高优先级配置内容会覆盖低优先级配置内容。**互补配置**

  我们也可以通过配置spring.config.location来改变默认配置

项目打包后，可以使用命令参数的形式，启动项目的时候指定配置文件的位置，指定配置文件和默认加载这些配置文件共同作用形成互补配置；

### 4.4.Linux执行jar包

```linux
方法一: 当前ssh窗口被锁定，可按CTRL + C打断程序运行，或直接关闭窗口，程序退出
java -jar springdemo.jar 

方法二： &代表在后台运行。当前ssh窗口不被锁定，但是当窗口关闭时，程序中止运行。
java -jar springdemo.jar &

方法三：nohup java -jar springdemo.jar &
nohup 意思是不挂断运行命令,当账户退出或终端关闭时,程序仍然运行
当用 nohup 命令执行作业时，缺省情况下该作业的所有输出被重定向到nohup.out的文件中，除非另外指定了输出文件

方式四：
nohup java -jar springdemo.jar >/dev/null  &  

可通过jobs命令查看后台运行任务
jobs

查看某端口占用的线程的pid
netstat -nlp |grep :9181
```

### 4.5.日志框架

日志门面：SLF4J 

日志实现：Logback

SpringBoot 选用 `SLF4J` `Logback`

**注意：** 日志方法调用 ，不应该直接使用日志的实现类，而是选择 调用日志抽象层里面的方法

```java
package com.whcoding.helloworld;

import com.whcoding.helloworld.controller.HelloWorldController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoHelloWorldApplication {

	private static final Logger logger = LoggerFactory.getLogger(HelloWorldController.class);
	public static void main(String[] args) {
		logger.info("DemoHelloWorldApplication");
		SpringApplication.run(DemoHelloWorldApplication.class, args);
	}
}

```

每一个日志框架 多有自己的配置文件 ，使用SLF4J以后，配置文件还是要做成日志实现框架的配置文件。

如何让系统中所有的日志都统一到slf4j：

1.将系统中其他的日志排除出去

2.用中间包来代替原有的日志框架

3.我们导入slf4j其他的实现

![image-20220615174800815](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220615174800815.png)



如果引入其他的框架 ，一定要把这个框架的默认日志依赖移除掉，因为包名称为 `org.apache.log4j` 会导致冲突

Spring 框架用的是commons-logging:

```xml
       <dependency>
            <groupId>org.springframeworkt</groupId>
            <artifactId>spring-core</artifactId>
            <exclusions>
                <exclusion>
                    <groupId>commons-logging</groupId>
                    <artifactId>commons-logging</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
```

**SpringBoot能自动适配所有的日志,而且底层使用slf4j+logback的方式记录日志，引入其他框架的时候，只需要把这个框架依赖的日志框架排除掉:**

![image-20220615175610400](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220615175610400.png)



### 4.6 @Component 和 @Bean 的区别

**@Component 的使用**

```java
@Component
public class StudentVO2 {

	private String name = "lkm";

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}
```

**而@Bean则常和@Configuration注解搭配使用**

```java
@Configuration
public class WebSocketConfig {
    @Bean
    public Student student(){
        return new Student();
    } 
}
```



**区别：**

1. @Component 作用于类，@Bean作用于方法。
2. @Component和@Bean都是用来注册Bean并装配到Spring容器中，但是Bean比Component的自定义性更强。可以实现一些Component实现不了的自定义加载类。
3. @Configuration与@Bean结合使用。@Configuration可理解为用spring的时候xml里面的<beans>标签，@Bean可理解为用spring的时候xml里面的<bean>标签。Spring Boot不是spring的加强版，所以@Configuration和@Bean同样可以用在普通的spring项目中，而不是Spring Boot特有的，只是在spring用的时候，注意加上扫包配置。

**为什么有了@Compent,还需要@Bean呢？**

1.如果想将第三方的类变成组件，你又没有没有源代码，也就没办法使用@[Component](https://so.csdn.net/so/search?q=Component&spm=1001.2101.3001.7020)进行自动配置，这种时候使用@Bean就比较合适了。不过同样的也可以通过xml方式来定义。

2.另外@Bean注解的方法返回值是对象，可以在方法中为对象设置属性。





### 4.7 `@Autowired` 和 `@Resource`的区别

**区别:**

1. @Autowired 是spring提供的注解，@Resource 是JDK提供的注解
2. @Autowired 默认的注入方式是ByType（根据类型进行匹配）@Resource 默认的注入方式是 ByName (根据名称进行匹配)
3. 当一个接口存在多个实现类的情况下，@Autowired 和 @Resource都需要通过名称才能匹配到对应Bean。@Autowired可以通过@Qualifier来显示指定的名称，@Resource 可以通过name来显示指定名称
4. 一般@Autowired和@Qualifier一起用，@Resource单独用。

### 4.8 `@Repository` 注解说明

1. @Repository用于标注数据访问组件，即DAO组件
2. @Repository跟@Service,@Compent,@Controller这4种注解是没什么本质区别,都是声明作用,取不同的名字只是为了更好区分各自的功能。
3. @Repository的作用：**该注解的作用不只是将类识别为Bean，同时它还能将所标注的类中抛出的数据访问异常封装为 Spring 的数据访问异常类型。 Spring本身提供了一个丰富的并且是与具体的数据访问技术无关的数据访问异常结构，用于封装不同的持久层框架抛出的异常，使得异常独立于底层的框架。**

不用@Repository来注解接口,我们照样可以注入到这个接口的实现类呢?

1、spring配置文件中配置了MapperScannerConfigurer这个bean，它会扫描持久层接口创建实现类并交给spring管理。

2、接口上使用了@Mapper注解或者Springboot中主类上使用了@MapperScan注解，和MapperScannerConfigurer作用一样。

注：不使用@Repository注解，idea会报警告，提示找不到这个bean，直接忽略即可。

![image-20220708172640306](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220708172640306.png)



### 4.9 @Bean 与 @Component 用在同一个类上

@Component 修饰的 UserManager 定义直接被覆盖成了 @Configuration + @Bean 修饰的 UserManager 定义

[参考资料](https://www.cnblogs.com/youzhibing/p/15354706.html)



## 五、日常问题

### 5.1 Mysql 设置时区serverTimezone

> mysql的驱动jar包升级到了8.0版本以上。升级后从mysql中查出的时候，全都比数据库的时间多13小时，而且这些时间存到数据库的时间，有些是正确的时间，有时比正确时间少13小时，这样返回给前端的时间就不准确，解决这个问题只要在springboot的数据库连接配置中增加一段配置就能解决问题。

//北京时间==东八区时间！=北京当地时间
**serverTimezone=GMT%2B8**
//或者使用上海时间
**serverTimezone=Asia/Shanghai**

如果你设置**serverTimezone=UTC**，连接不报错，但是会有了8个小时的时差。

UTC代表的是全球标准时间 ，但是我们使用的时间是北京时区也就是东八区，领先UTC八个小时。

### 5.2 fastjson中toString与toJSONString的差别

**其实toString()方法内部还是调用了toJSONString()方法**

```java
@Override
    public String toString() {
        return toJSONString();
    }

    public String toJSONString() {
        SerializeWriter out = new SerializeWriter();
        try {
            new JSONSerializer(out).write(this);
            return out.toString();
        } finally {
            out.close();
        }
    }
```





### 5.3 一条sql在MySQL中的执行流程

**针对查询语句**: 权限校验---》查询缓存---》分析器---》优化器---》权限校验---》执行器---》引擎



**针对更新语句:**分析器----》权限校验----》执行器---》引擎---redo log prepare---》binlog---》redo log commit

### 5.4 SQL 查询顺序

from

where

group by

order by

### 5.5 索引类型

普通索引

联合索引

唯一索引

联合索引

### 5.6 Mybatis 缓存机制



## 六、SpringBoot

### 6.1 @Autowired注解与@Resource注解的区别

问题:直接使用@Autowired 无法注入 需要修改为@Resource

**@Resource**

@Resource注解由J2EE提供，需要导入包javax.annotation.Resource。

@Resource默认按照ByName自动注入。

@Resource装配顺序：

- 如果同时指定了name和type，则从Spring上下文中找到唯一匹配的bean进行装配，找不到则抛出异常
- 如果指定了name，则从Spring上下文中查找名称（id）匹配的bean进行装配，找不到则抛出异常
- 如果指定了type，则从Spring上下文中找到类型匹配的唯一bean进行装配，找不到或找到多个，都抛出异常
- 如果既没指定name，也没指定type,则自动按照byName方式进行装配。如果没有匹配，则回退为一个原始类型进行匹配，如果匹配则自动装配。



**@Autowired**

@Autowired为Spring提供的注解，需要导入包org.springframework.beans.factory.annotation.Autowired

@Autowired采取的策略为按照类型注入。

当一个类型有多个bean值的时候，会造成无法选择具体注入哪一个的情况，这个时候我们需要配合着@Qualifier使用。

@Qualifier告诉spring具体去装配哪个对象。 [@Qualifier(name="userDao1")]

https://www.cnblogs.com/jichi/p/10073404.html

**区别**

-  @Autowired 是Spring提供的，@Resource 是J2EE提供的。
-  @Autowired只按type装配,@Resource默认是按name装配。





## 文章TODO

[SpringBoot 常用注解](https://mp.weixin.qq.com/s/ob041oMvIHOJwKefTpkPIQ)

[Spring 夺命 35 问](https://mp.weixin.qq.com/s/GDNLVMJTgLHgF8uIT6jfOQ)

[并发编程的12种业务场景](https://mp.weixin.qq.com/s/by8cn0pr98wYIuzKTB8ocw)

[SpringBoot源码分析](https://mp.weixin.qq.com/s/_eeODuaJd-cKhO1x0m4xWg)

[合理设置线程大小](https://www.cnblogs.com/xiang--liu/p/9710096.html)

[田小波](http://www.tianxiaobo.com/)

[什么是死锁及死锁的必要条件和解决方法](https://blog.csdn.net/abigale1011/article/details/6450845)

[死锁详解](https://blog.csdn.net/wljliujuan/article/details/79614019?spm=1001.2101.3001.6650.3&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-3-79614019-blog-6450845.pc_relevant_paycolumn_v3&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-3-79614019-blog-6450845.pc_relevant_paycolumn_v3&utm_relevant_index=6)

[rabbitmq](https://blog.csdn.net/kavito/article/details/91403659?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522163227309716780271594669%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=163227309716780271594669&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-91403659.pc_search_insert_js_new&utm_term=rabbitmq&spm=1018.2226.3001.4187)

[vue-devtools vue开发调试工具](https://www.cnblogs.com/aaron-pan/p/7156615.html?utm_source=tuicool&utm_medium=referral)  

[Java万物之基---Object超类](https://juejin.cn/post/7071860248520327198#heading-10)

[Linux命令](https://mp.weixin.qq.com/s/EUa485IWbdjrqWzSfw8DSw)

[2021年，200本豆瓣高分必读书单！](https://zhuanlan.zhihu.com/p/364617275?utm_source=wechat_session&utm_medium=social&utm_oi=1103789516913016832)

[PostMan详解](https://www.toutiao.com/article/6913538714060800515/?wid=1655349332079)

[日志体系](https://mp.weixin.qq.com/s/f3bLgO4B8Ps6sXcdnze-BQ)

[Docker和k8s的区别与介绍](https://www.cnblogs.com/misswangxing/p/10669444.html)

### 阅读

- [ ] [Spring中涉及的设计模式总结](https://mp.weixin.qq.com/s/Zi6umVQ8HZWLlUjFxD-3Bg)

- [ ] [springcloud体系中的重要知识点](https://mp.weixin.qq.com/s/jfdauYGniX9DM2zyyjQGgg)

- [x] [sql优化](https://mp.weixin.qq.com/s/HuKptQYg3OOUsd5h0N8qWQ)

- [ ] [HashMap夺命21问](https://mp.weixin.qq.com/s/5nxmAogZRAFuG6BcyjNJlQ)

  

- [x] [有了http为什么还要用RPC](https://mp.weixin.qq.com/s/TpdaAleV3ghenvC39F_Y7w)

- [x] [万字复习http](https://mp.weixin.qq.com/s/YTlqMzvP2bdbO_QfwxEBIQ)

- [ ] [spring session与spring boot整合实战](https://mp.weixin.qq.com/s/thpl0BzXccQ99gexjcckgQ)

- [x] [springboot注解总结](https://mp.weixin.qq.com/s/Q-Sys6eK0E5FJ2uUNjkaFA)

- [ ] [代码优化建议](https://mp.weixin.qq.com/s/q8mG0ZtWFKA6yj_ZBScQFg)

- [ ] [服务组件Feign的工作原理](https://mp.weixin.qq.com/s/QFq5GU7jCQ_9YLY4XxpfKw)

- [ ] [23种设计模式详解](https://mp.weixin.qq.com/s/PkgBrHV4H16lG-_LP1RNHA)

- [x] [为什么SpringBoot的 jar 可以直接运行](https://mp.weixin.qq.com/s/U1pU4i11Y3jskQJA01us_g)

- [x] [RedisCRUD](https://juejin.cn/post/6844903957186215944)

- [x] [参数校验(Validator)](https://mp.weixin.qq.com/s/eW8bdeVwgs3AAkMX6CMm4A)

- [x] [MyBatis动态SQL](https://mp.weixin.qq.com/s/EulRVPYAC9XbfypNIzNiRw)

- [x] [List 如何一边遍历，一边删除](https://mp.weixin.qq.com/s/MR4csY3HEmY5NfZ7eZgRRw)

- [x] [重构](https://www.cnblogs.com/KnightsWarrior/archive/2010/06/30/1767981.html)

- [ ] [SpringBoot教程](https://mp.weixin.qq.com/s/6ZRO2CFg_SEqdzPhy9mIcQ)  

- [ ] [Java面试汇总](https://blog.csdn.net/guorui_java/article/details/120026816?spm=1001.2014.3001.5502)  

- [x] [Spring Boot项目的Logback配置文件使用yaml格式](http://t.zoukankan.com/EasonJim-p-9159195.html)

- [ ] [RabbitMQ详解](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzI1NDY0MTkzNQ==&action=getalbum&album_id=1995072560941580290&scene=173&from_msgid=2247496250&from_itemidx=1&count=3&nolastread=1#wechat_redirect)

- [ ] [参数校验、统一异常、统一响应](https://mp.weixin.qq.com/s/ANJ0DV9wyZA-mBdgDuiufw)

