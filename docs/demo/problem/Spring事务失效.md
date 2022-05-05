# Spring事务失效场景



![template](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220330175847.png)

# 前言

今天遇到事务失效的问题，找了下事务失效的问题 ，发现事务失效的情况还是挺多的，有时候不注意就会导致问题，本篇文章进行整理总结了常见的事务失效的情况。

**博客说明**

> 文章所涉及的资料来自互联网整理和个人总结，意在于个人学习和经验汇总，如有什么地方侵权，请联系本人删除，谢谢！



## 1.**数据库引擎不支持事务**

这里以 MySQL 为例，其 MyISAM 引擎是不支持事务操作的，InnoDB 才是支持事务的引擎，一般要支持事务都会使用 InnoDB。

根据 MySQL 的官方文档：

> https://dev.mysql.com/doc/refman/5.5/en/storage-engine-setting.html

MySQL 5.5.5 开始的默认存储引擎是：InnoDB，之前默认的都是：MyISAM，所以这点要值得注意，底层引擎不支持事务再怎么搞都是白搭。



## 2.**没有被 Spring 管理**

如下所示：

```java
// @Service  
public class DeptTransactionServiceImpl implements DeptService {

	@Transactional
	public void updateDept(OrmDeptCondition deptCondition) {
		// update dept
	}
}
```

如果把 @Service 注解注释掉，DeptTransactionServiceImpl类就不会被加载成一个 Bean。类就不会被 Spring 管理了，事务自然就失效了。

## 3.**方法不是 public 的**

以下来自 Spring 官方文档：

```
When using proxies, you should apply the @Transactional annotation only to methods with public visibility. If you do annotate protected, private or package-visible methods with the @Transactional annotation, no error is raised, but the annotated method does not exhibit the configured transactional settings. Consider the use of AspectJ (see below) if you need to annotate non-public methods.
```

 @Transactional 只能用于 public 的方法上，否则事务不会失效，如果要用在非 public 方法上，可以开启 AspectJ 代理模式。

## 4.**自身调用问题**

**示例一如下**

```java
//示例 1
@Service
public class DeptTransactionServiceImpl implements DeptService {


	public void updateDept(OrmDeptCondition deptCondition) {
		updateDeptTest(deptCondition);
	}

	@Transactional
	public void updateDeptTest(OrmDeptCondition deptCondition) {
		// update dept
	}
}

```

**示例二如下**

```java
@Service
public class DeptTransactionServiceImpl implements DeptService {

	@Transactional
	public void updateDept(OrmDeptCondition deptCondition) {
		updateDeptTest(deptCondition)
	}

	@Transactional(propagation = Propagation.REQUIRES_NEW)
	public void updateDeptTest(OrmDeptCondition deptCondition) {
		// update dept
	}
}

```

- 示例1 中，updateDept方法上面没有加 @Transactional 注解,调用有 @Transactional 注解的 updateOrder 方法
- 示例2 中，updateDept方法和updateDeptTest方法都加上注解

上面2种情况事务都会失效

因为他们自身调用，没有经过Spring的代理类，默认只有在外部调用事务才会生效。如何解决这种情况呢？请小伙伴们往下继续看



## 5.**@Transactional的扩展配置不支持事务**

`Propagation.NOT_SUPPORTED`：表示不以事务运行，当前若存在事务则挂起。这表示不支持以事务的方式运行，所以即使事务生效也是白搭！



```java
@Service
public class DeptTransactionServiceImpl implements DeptService {

	@Transactional
	public void updateDept(OrmDeptCondition deptCondition) {
		updateDeptTest(deptCondition);
	}

	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	public void updateDeptTest(OrmDeptCondition deptCondition) {
		// update dept
	}
}
```

**扩展 Spring事务传播属性**

在 Spring的 TransactionDefinition接口中一共定义了六种事务传播属性：

```
REQUIRED(0),支持当前事务，如果当前没有事务，就新建一个事务。这是最常见的选择。
SUPPORTS(1),支持当前事务，如果当前没有事务，就以非事务方式执行。 
MANDATORY(2),支持当前事务，如果当前没有事务，就抛出异常。 
REQUIRES_NEW(3),新建事务，如果当前存在事务，把当前事务挂起。 
NOT_SUPPORTED(4),以非事务方式执行操作，如果当前存在事务，就把当前事务挂起。 
NEVER(5),非事务方式执行，如果当前存在事务，则抛出异常。 
NESTED(6);如果当前存在事务，则在嵌套事务内执行。如果当前没有事务，则进行与PROPAGATION_REQUIRED类似的操作
```

**在第四步骤中：自身调用事务失效问题如何解决**

```java
@Service
public class ServiceA {

    @Autowired
    private ServiceB serviceB;
    @Transactional
    public void doSomething(){
        serviceB.insert();
        调用其他系统;
    }
}
```



```java
@Service
public class ServiceB {

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void insert(){
        向数据库中添加数据;
    }
}
```

我们将要事务分离出来的方法写在另一个service中，再次测试，发现执行完插入语句之后，数据库中就已经能查到数据了，说明事务分离了.

## **6.异常被吃了**

把异常吃了，然后又不抛出来，事务也不会回滚！



```java
@Service
public class DeptTransactionServiceImpl implements DeptService {

	@Transactional
	public void updateDept(OrmDeptCondition deptCondition) {
		try {
			updateDeptTest(deptCondition);
		} catch(Exception e) {

		}
	}
}
```

## **7.异常类型错误**



```java
@Service
public class DeptTransactionServiceImpl implements DeptService {

	@Transactional
   //@Transactional(rollbackFor = Exception.class)  
	public void updateDept(OrmDeptCondition deptCondition) throws Exception{
		try {
			updateDeptTest(deptCondition);
		} catch(Exception e) {
			throw new Exception("11");
		}
	}
}
```

这样事务也是不生效的，因为默认回滚的是：RuntimeException，如果你想触发其他异常的回滚，需要在注解上配置一下，如：

` @Transactional(rollbackFor = Exception.class)  `



## 参考

Spring事务失效：https://mp.weixin.qq.com/s/Yi0HK1DbAxv3N3Y-Drmqtw