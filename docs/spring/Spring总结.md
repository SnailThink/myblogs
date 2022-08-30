# Spring总结



[Spring夺命35问](https://mp.weixin.qq.com/s/GDNLVMJTgLHgF8uIT6jfOQ)



## Spring

### 1.控制反转(IoC)和依赖注入(DI)

**IoC(Inversion of Control,控制反转)** 是Spring 中一个非常非常重要的概念，它不是什么技术，而是一种解耦的设计思想。它的主要目的是借助于“第三方”(Spring 中的 IOC 容器) 实现具有依赖关系的对象之间的解耦(IOC容器管理对象，你只管使用即可)，从而降低代码之间的耦合度。**IOC 是一个原则，而不是一个模式，以下模式（但不限于）实现了IoC原则。**

![ioc-patterns](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/ioc-patterns.png)

**Spring IOC 容器就像是一个工厂一样，当我们需要创建一个对象的时候，只需要配置好配置文件/注解即可，完全不用考虑对象是如何被创建出来的。** IOC 容器负责创建对象，将对象连接在一起，配置这些对象，并从创建中处理这些对象的整个生命周期，直到它们被完全销毁。

在实际项目中一个 Service 类如果有几百甚至上千个类作为它的底层，我们需要实例化这个 Service，你可能要每次都要搞清这个 Service 所有底层类的构造函数，这可能会把人逼疯。如果利用 IOC 的话，你只需要配置好，然后在需要的地方引用就行了，这大大增加了项目的可维护性且降低了开发难度。关于Spring IOC 的理解，推荐看这一下知乎的一个回答：<https://www.zhihu.com/question/23277575/answer/169698662>  ，非常不错。

**控制反转怎么理解呢?** 举个例子："对象a 依赖了对象 b，当对象 a 需要使用 对象 b的时候必须自己去创建。但是当系统引入了 IOC 容器后， 对象a 和对象 b 之前就失去了直接的联系。这个时候，当对象 a 需要使用 对象 b的时候， 我们可以指定 IOC 容器去创建一个对象b注入到对象 a 中"。 对象 a 获得依赖对象 b 的过程,由主动行为变为了被动行为，控制权反转，这就是控制反转名字的由来。

**DI(Dependecy Inject,依赖注入)是实现控制反转的一种设计模式，依赖注入就是将实例变量传入到一个对象中去。**



### 2.Spring有哪些模块

![image-20220519161938515](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161938.png)





### 3.Spring常用注解

![image-20220519161913133](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161913.png)



### 4.Spring中的 Bean 的作用域

![image-20220519161824720](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161824.png)

### 5.**Spring自动装配类型**



![image-20220519161809734](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161809.png)

### 6.代码执行流程

![image-20220519161704445](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161704.png)



### 7.**AOP有哪些环绕方式**

- 前置通知 (@Before)
- 返回通知 (@AfterReturning)
- 异常通知 (@AfterThrowing)
- 后置通知 (@After)
- 环绕通知 (@Around)



![image-20220519161644260](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161644.png)



### 8.Spring AOP和AspectJ AOP区别

![image-20220519161558012](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161558.png)

### 9.事务传播机制

![image-20220519161534246](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161534.png)

### 10.声明式事务在哪些情况下会失效

![image-20220519161513355](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161513.png)



## SpringMVC

### 1.SpringMVC 的工作流程

![image-20220519161450749](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161450.png)



### 2.SpringMVC Restful风格的接口的流程

![image-20220519161435958](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161436.png)



## SpringBoot



### 1.SpringBoot自动配置原理

![image-20220519161415404](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161415.png)

### 2.Springboot 启动原理？

SpringBoot 启动大致流程如下 ：

![image-20220519161352473](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161352.png)





## SpringCloud

### 1.SpringCloud 流程

![image-20220519161311325](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519161318.png)



### 2.**SpringCloud有哪些核心组件**

![image-20220519162134865](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220519162135.png)







**参考：**

- [1].《Spring揭秘》
- [2]. 面试官：关于Spring就问这13个：https://mp.weixin.qq.com/s/-gLXHd_mylv_86sTMOgCBg
- [3]. 15个经典的Spring面试常见问题  ：https://mp.weixin.qq.com/s/OMlwHHnGcN7iZ8lerUvW7w
- [4].面试还不知道BeanFactory和ApplicationContext的区别？：https://juejin.cn/post/6844903877574131726
- [5]. Java面试中常问的Spring方面问题（涵盖七大方向共55道题，含答案：https://juejin.cn/post/6844903654659473416#heading-8
- [6] .Spring Bean 生命周期 （实例结合源码彻底讲透：https://segmentfault.com/a/1190000020747302
- [7]. @Autowired注解的实现原理 ：https://juejin.cn/post/6844903957135884295
- [8].万字长文，带你从源码认识Spring事务原理，让Spring事务不再是面试噩梦https://segmentfault.com/a/1190000022754620
- [9].【技术干货】Spring事务原理一探https://zhuanlan.zhihu.com/p/54067384
- [10]. Spring的声明式事务@Transactional注解的6种失效场景：https://blog.csdn.net/j1231230/article/details/105534599
- [11].Spring官网
- [12].Spring使用了哪些设计模式？：https://zhuanlan.zhihu.com/p/336671458
- [13].《精通Spring4.X企业应用开发实战》
- [14].Spring 中的bean 是线程安全的吗？：https://www.cnblogs.com/myseries/p/11729800.html