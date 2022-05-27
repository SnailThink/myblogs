

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



```
#### 1.



- ```java
  @SpringBootApplication 标注是一个springboot的应用 
  ```

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
 
```



 **SpringBoot自动装配**

![](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220527162029.png)

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



### 14.







## 文章TODO

[SpringBoot 常用注解](https://mp.weixin.qq.com/s/ob041oMvIHOJwKefTpkPIQ)

[Spring 夺命 35 问](https://mp.weixin.qq.com/s/GDNLVMJTgLHgF8uIT6jfOQ)

[并发编程的12种业务场景](https://mp.weixin.qq.com/s/by8cn0pr98wYIuzKTB8ocw)

[IDEA自动生成单元测试](https://mp.weixin.qq.com/s/FwXN5j-mpkD7r8zZqUNm8w)

[SpringBoot源码分析](https://mp.weixin.qq.com/s/_eeODuaJd-cKhO1x0m4xWg)

[合理设置线程大小](https://www.cnblogs.com/xiang--liu/p/9710096.html)

[田小波](http://www.tianxiaobo.com/)

[什么是死锁及死锁的必要条件和解决方法](https://blog.csdn.net/abigale1011/article/details/6450845)

[rabbitmq](https://blog.csdn.net/kavito/article/details/91403659?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522163227309716780271594669%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=163227309716780271594669&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-91403659.pc_search_insert_js_new&utm_term=rabbitmq&spm=1018.2226.3001.4187)

[easy code安装使用说明 ](https://www.cnblogs.com/chafe/p/9506001.html)

[vue-devtools vue开发调试工具](https://www.cnblogs.com/aaron-pan/p/7156615.html?utm_source=tuicool&utm_medium=referral)  

[windows运行jar包](https://www.cnblogs.com/sharesdk/p/10773192.html) 

[Linux运行jar包](https://www.cnblogs.com/linnuo/p/9084125.html) 

[Intellij IDEA 神级插件](https://mp.weixin.qq.com/s/AMCUUKP7ZTU2wIMiPUdhKw)

[Java万物之基---Object超类](https://juejin.cn/post/7071860248520327198#heading-10)

[关于 RabbitMQ，应该没有比这更详细的教程了！](https://mp.weixin.qq.com/s/AgrRVFLrQb5gzRGlUrTyHA)

[Linux命令](https://mp.weixin.qq.com/s/EUa485IWbdjrqWzSfw8DSw)

[2021年，200本豆瓣高分必读书单！](https://zhuanlan.zhihu.com/p/364617275?utm_source=wechat_session&utm_medium=social&utm_oi=1103789516913016832)



### 阅读

- [ ] [Spring中涉及的设计模式总结](https://mp.weixin.qq.com/s/Zi6umVQ8HZWLlUjFxD-3Bg)
- [ ] [springcloud体系中的重要知识点](https://mp.weixin.qq.com/s/jfdauYGniX9DM2zyyjQGgg)
- [x] [sql优化](https://mp.weixin.qq.com/s/HuKptQYg3OOUsd5h0N8qWQ)
- [ ] [HashMap夺命21问](https://mp.weixin.qq.com/s/5nxmAogZRAFuG6BcyjNJlQ)
- [ ] [消息队列](https://mp.weixin.qq.com/s/qQyV4M7SOcoJr8t05YsBrg)
- [x] [有了http为什么还要用RPC](https://mp.weixin.qq.com/s/TpdaAleV3ghenvC39F_Y7w)
- [x] [万字复习http](https://mp.weixin.qq.com/s/YTlqMzvP2bdbO_QfwxEBIQ)
- [ ] [spring session与spring boot整合实战](https://mp.weixin.qq.com/s/thpl0BzXccQ99gexjcckgQ)
- [x] [springboot注解总结](https://mp.weixin.qq.com/s/Q-Sys6eK0E5FJ2uUNjkaFA)
- [ ] [代码优化建议](https://mp.weixin.qq.com/s/q8mG0ZtWFKA6yj_ZBScQFg)
- [ ] [服务组件Feign的工作原理](https://mp.weixin.qq.com/s/QFq5GU7jCQ_9YLY4XxpfKw)
- [ ] [23种设计模式详解](https://mp.weixin.qq.com/s/PkgBrHV4H16lG-_LP1RNHA)
- [ ] [为什么SpringBoot的 jar 可以直接运行](https://mp.weixin.qq.com/s/U1pU4i11Y3jskQJA01us_g)
- [x] [redisCRUD](https://juejin.cn/post/6844903957186215944)
- [ ] [参数校验(Validator)](https://mp.weixin.qq.com/s/eW8bdeVwgs3AAkMX6CMm4A)
- [ ] [MyBatis动态SQL](https://mp.weixin.qq.com/s/EulRVPYAC9XbfypNIzNiRw)
- [x] [List 如何一边遍历，一边删除](https://mp.weixin.qq.com/s/MR4csY3HEmY5NfZ7eZgRRw)
- [x] [重构](https://www.cnblogs.com/KnightsWarrior/archive/2010/06/30/1767981.html)
- [ ] [springBoot教程](https://mp.weixin.qq.com/s/6ZRO2CFg_SEqdzPhy9mIcQ)  
- [ ] [Java面试汇总](https://blog.csdn.net/guorui_java/article/details/120026816?spm=1001.2014.3001.5502)  

*****

