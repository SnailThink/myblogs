## Spring事务



## 一、Spring事务

### 1. 事务说明

在Spring中，事务有两种实现方式，分别是编程式事务管理和声明式事务管理两种方式。
编程式事务管理： 编程式事务管理使用TransactionTemplate或者直接使用底层的PlatformTransactionManager。对于编程式事务管理，spring推荐使用TransactionTemplate。
声明式事务管理： 建立在AOP之上的。其本质是对方法前后进行拦截，然后在目标方法开始之前创建或者加入一个事务，在执行完目标方法之后根据执行情况提交或者回滚事务。
声明式事务管理不需要入侵代码，通过@Transactional就可以进行事务操作，更快捷而且简单。推荐使用

### 2.如何使用

在Mybatis中使用事务，非常简单，只需要在函数增加注解@Transactional

```java
  /**
     * 关于事务的使用
     */
	@Transactional(rollbackFor = {RuntimeException.class, Error.class})
	public void transactionalDemo() {
		Long id = 1L;
		OrmDeptVO deptVO = queryDeptById(id);
		int updateNum = dao.updateOrmDeptById(deptVO);
		log.info("更新数据影响的条数："+updateNum);
		addDept(deptVO);
		log.info("执行新增数据完成！");
	}
```

### 3.常用配置

| **参 数 名 称**        | 功能描述                                                     |
| ---------------------- | ------------------------------------------------------------ |
| readOnly               | 该属性用于设置当前事务是否为只读事务，设置为true表示只读，false则表示可读写，默认值为false。例如：@Transactional(readOnly=true) |
| rollbackFor            | 该属性用于设置需要进行回滚的异常类数组，当方法中抛出指定异常数组中的异常时，则进行事务回滚。例如：指定单一异常类：@Transactional(rollbackFor=RuntimeException.class)指定多个异常类：@Transactional(rollbackFor={RuntimeException.class, Exception.class}) |
| rollbackForClassName   | 该属性用于设置需要进行回滚的异常类名称数组，当方法中抛出指定异常名称数组中的异常时，则进行事务回滚。例如：指定单一异常类名称@Transactional(rollbackForClassName=”RuntimeException”)指定多个异常类名称：@Transactional(rollbackForClassName={“RuntimeException”,”Exception”} |
| noRollbackFor          | 该属性用于设置不需要进行回滚的异常类数组，当方法中抛出指定异常数组中的异常时，不进行事务回滚。例如：指定单一异常类：@Transactional(noRollbackFor=RuntimeException.class)指定多个异常类：@Transactional(noRollbackFor={RuntimeException.class, Exception.class}) |
| noRollbackForClassName | 该属性用于设置不需要进行回滚的异常类名称数组，当方法中抛出指定异常名称数组中的异常时，不进行事务回滚。例如：指定单一异常类名称：@Transactional(noRollbackForClassName=”RuntimeException”)指定多个异常类名称：@Transactional(noRollbackForClassName={“RuntimeException”,”Exception”}) |
| propagation            | 该属性用于设置事务的传播行为。例如：@Transactional(propagation=Propagation.NOT_SUPPORTED,readOnly=true) |
| isolation              | 该属性用于设置底层数据库的事务隔离级别，事务隔离级别用于处理多事务并发的情况，通常使用数据库的默认隔离级别即可，基本不需要进行设置 |
| timeout                | 该属性用于设置事务的超时秒数，默认值为-1表示永不超时         |

### 4.事务属性

#### 事务隔离级别

隔离级别是指若干个并发的事务之间的隔离程度。TransactionDefinition 接口中定义了五个表示隔离级别的常量：

TransactionDefinition.ISOLATION_DEFAULT：这是默认值，表示使用底层数据库的默认隔离级别。对大部分数据库而言，通常这值就是TransactionDefinition.ISOLATION_READ_COMMITTED。
TransactionDefinition.ISOLATION_READ_UNCOMMITTED：该隔离级别表示一个事务可以读取另一个事务修改但还没有提交的数据。该级别不能防止脏读，不可重复读和幻读，因此很少使用该隔离级别。比如PostgreSQL实际上并没有此级别。
TransactionDefinition.ISOLATION_READ_COMMITTED：该隔离级别表示一个事务只能读取另一个事务已经提交的数据。该级别可以防止脏读，这也是大多数情况下的推荐值。
TransactionDefinition.ISOLATION_REPEATABLE_READ：该隔离级别表示一个事务在整个过程中可以多次重复执行某个查询，并且每次返回的记录都相同。该级别可以防止脏读和不可重复读。
TransactionDefinition.ISOLATION_SERIALIZABLE：所有的事务依次逐个执行，这样事务之间就完全不可能产生干扰，也就是说，该级别可以防止脏读、不可重复读以及幻读。但是这将严重影响程序的性能。通常情况下也不会用到该级别。

#### 事务传播行为

所谓事务的传播行为是指，如果在开始当前事务之前，一个事务上下文已经存在，此时有若干选项可以指定一个事务性方法的执行行为。在TransactionDefinition定义中包括了如下几个表示传播行为的常量：

TransactionDefinition.PROPAGATION_REQUIRED：如果当前存在事务，则加入该事务；如果当前没有事务，则创建一个新的事务。这是默认值。
TransactionDefinition.PROPAGATION_REQUIRES_NEW：创建一个新的事务，如果当前存在事务，则把当前事务挂起。
TransactionDefinition.PROPAGATION_SUPPORTS：如果当前存在事务，则加入该事务；如果当前没有事务，则以非事务的方式继续运行。
TransactionDefinition.PROPAGATION_NOT_SUPPORTED：以非事务方式运行，如果当前存在事务，则把当前事务挂起。
TransactionDefinition.PROPAGATION_NEVER：以非事务方式运行，如果当前存在事务，则抛出异常。
TransactionDefinition.PROPAGATION_MANDATORY：如果当前存在事务，则加入该事务；如果当前没有事务，则抛出异常。
TransactionDefinition.PROPAGATION_NESTED：如果当前存在事务，则创建一个事务作为当前事务的嵌套事务来运行；如果当前没有事务，则该取值等价于TransactionDefinition.PROPAGATION_REQUIRED。

#### 事务超时

所谓事务超时，就是指一个事务所允许执行的最长时间，如果超过该时间限制但事务还没有完成，则自动回滚事务。在 TransactionDefinition 中以 int 的值来表示超时时间，其单位是秒。
默认设置为底层事务系统的超时值，如果底层数据库事务系统没有设置超时值，那么就是none，没有超时限制。

#### 事务只读属性

只读事务用于客户代码只读但不修改数据的情形，只读事务用于特定情景下的优化，比如使用Hibernate的时候。
默认为读写事务。





## 二、事务失效场景

> 参考Spring事务失效：https://mp.weixin.qq.com/s/Yi0HK1DbAxv3N3Y-Drmqtw

### 1.数据库引擎不支持事务

这里以 MySQL 为例，其 MyISAM 引擎是不支持事务操作的，InnoDB 才是支持事务的引擎，一般要支持事务都会使用 InnoDB。

根据 MySQL 的官方文档：

> https://dev.mysql.com/doc/refman/5.5/en/storage-engine-setting.html

MySQL 5.5.5 开始的默认存储引擎是：InnoDB，之前默认的都是：MyISAM，所以这点要值得注意，底层引擎不支持事务再怎么搞都是白搭。

### 2.没有被 Spring 管理

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

如果把 @Service 注解注释掉，DeptTransactionServiceImpl类就不会被加载成一个Bean。类就不会被 Spring 管理了事务自然就失效了。

### 3.方法不是 public 的

以下来自 Spring 官方文档：

```
When using proxies, you should apply the @Transactional annotation only to methods with public visibility. If you do annotate protected, private or package-visible methods with the @Transactional annotation, no error is raised, but the annotated method does not exhibit the configured transactional settings. Consider the use of AspectJ (see below) if you need to annotate non-public methods.
```

 @Transactional 只能用于 public 的方法上，否则事务不会失效，如果要用在非 public 方法上，可以开启 AspectJ 代理模式。

### 4.自身调用问题

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

因为他们自身调用，没有经过Spring的代理类，默认只有在外部调用事务才会生效。如何解决这种情况呢？请小伙伴们往下继续看.

### 5.@Transactional的扩展配置不支持事务

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

### 6.异常被吃了

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

### 7.异常类型错误

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



