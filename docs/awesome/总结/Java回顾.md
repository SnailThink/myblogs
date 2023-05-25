## 一、Git

### 1.Git环境配置

环境变量是针对全局的，

Git下载镜像：官网下载太慢,我们可以使用淘宝镜像下载:

```shell
 http://mpm.taobao.org/mirrors/git-for-windows/
```

#### **查询系统配置**

git config --system --list：

![image-20220623141835603](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220623141835603.png)

#### **查询全局配置**

git config --global --list：



![image-20220623141835603](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220623141835603.png)

#### **设置账户密码**

```shell
#设置账号
git conifg  --global user.name "whcoding"
#设置邮箱
git conifg  --global user.password "邮箱地址"
```

### 2.Git基本理论



![image-20220623142346592](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220623142346592.png)

working Directory 工作文件夹(工作区)

add 提交到暂存区

git commit 提交到本地仓库

git push 推送到远程服务器

git pull  从服务器端拉代码到本地仓库

git reset 将本地仓库回滚到暂存区

git chenckout 将暂存区回滚到工作文件夹中

****

working Directory 工作文件夹(工作区)

Stage(index) 暂存区 （其实是一个文件）

Repository ：本地仓库

Remote：远程仓库



<img src="https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220623143301573.png" alt="image-20220623143301573" style="zoom: 67%;" />



**git工作流程:**

1.在工作目录中添加文件

2.需要版本管理的文件 git add. 操作加入到暂存区

3.将暂存区的文件提交到git commit 仓库

4.将文件推送到远程服务器 push

![image-20220623143733140](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220623143733140.png)



### 3.设置远端仓库

**设置本机绑定ssh实现免密码登录**

1. 进入.ssh文件夹 cd C:\Users\Manager\.ssh ，生成公钥 ssh-keygen -t rsa

2. 将公钥信息public key 添加到码云账户配置中 SSH 公钥中。



## 二、部署jar包到服务器

**执行步骤**

1. 上传文件到服务器
2. Linux服务器开启防火墙
3. 开启对外访问端口
4. 执行jar包 `java -jar springdemo.jar &`  &代表在后台运行。当前ssh窗口不被锁定，但是当窗口关闭时，程序中止运行。


```
1.查看防火墙状态
firewall-cmd --state
如果返回的是“not running”，那么需要先开启防火墙；
2. 开启防火墙
systemctl start firewalld.service

3. 开启指定端口
firewall-cmd --zone=public --add-port=2099/tcp --permanent
显示success表示成功
–zone=public表示作用域为公共的
–add-port=443/tcp添加tcp协议的端口端口号为443
–permanent永久生效，如果没有此参数，则只能维持当前 服 务生命周期内，重新启动后失效；
4. 重启防火墙
systemctl restart firewalld.service
系统没有任何提示表示成功！
5. 重新加载防火墙
firewall-cmd --reload
显示success表示成功
6.查看已开启的端口
firewall-cmd --list-ports

7.关闭指定端口
firewall-cmd --zone=public --remove-port=2099/tcp --permanent
systemctl restart firewalld.service
firewall-cmd --reload

8.查看端口被哪一个进程占用
netstat -lnpt |grep 2099
centos7默认没有 netstat 命令，需要安装 net-tools 工具：
安装 net-tools
yum install -y net-tools

9.临时关闭防火墙
systemctl stop firewalld.service
# 或者
systemctl stop firewalld

查看系统对外开放的端口
netstat -tunlp
```



> 当在Linux中成功开启了某个端口，但是远程telnet还是无法ping通，是正常的！
>
> **因为端口没有被Linux进程监听，换句话说，就是该端口上没有运行任何程序！！！**



## 三、Linux配置MySQL

### 1.Linux 删除MySQL

[Linux系统彻底卸载MySQL](https://blog.csdn.net/qq_41437844/article/details/123255412)

[Linux安装MySQL](https://blog.csdn.net/Aykl119/article/details/122223582?spm=1001.2101.3001.6650.5&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7Edefault-5-122223582-blog-123974466.pc_relevant_multi_platform_whitelistv1&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7Edefault-5-122223582-blog-123974466.pc_relevant_multi_platform_whitelistv1&utm_relevant_index=10)

### 2.开启MySQL端口

**如果本地访问Linux数据库失败，则记得看下下面三个配置是否OK。**

1.服务器的防火墙mysql端口3306是否开放

```
查看防火墙是否已开放3306端口
firewall-cmd --query-port=3306/tcp
 
设置3306端口为永久开放
firewall-cmd --add-port=3306/tcp --permanent
 
查看firewalld状态，发现当前是dead状态，即防火墙未开启
systemctl status firewalld
 
关闭防火墙
systemctl stop firewalld
 
重启防火墙（设置了新的端口记得先关闭，再重启）
systemctl status firewalld
```

2. 如果是阿里云ECS，记得查看云安全组规则是否开放了3306端口，如果没有，记得加上
3. 如果连接数据库提示 `is not allowed to connect to this MySQL serve`，则是没有允许远程登录

​	登录服务器mysql数据库

```sql
执行 use mysql;
执行 update user set host = '%' where user = 'root';
执行 FLUSH PRIVILEGES;
```

## 四、Mybatis

- Mybatis
- Mybatis3
- Mybstis-PageHelper
- generator

### 1.CRUD

**1.namespace** ： namespace 中的包要和Dao/Mapper 接口的包名称一样

**2.Select：**

- id： 就是对应namespace 中的方法名称
- resultType：SQL 语句执行的返回值
- parameterType： 参数类型

**3.resultMap**

**解决属性和字段名称不一致的情况**

```xml
 <!-- property 代表实体类中的字段，column:为表结构的字段-->
    <resultMap id="ormDeptMap" type="com.whcoding.base.project.pojo.OrmDeptVO">
        <id property="id" jdbcType="INTEGER" column="id"/>
        <result property="deptId" jdbcType="INTEGER" column="dept_id"/>
        <result property="deptNo" jdbcType="VARCHAR" column="dept_no"/>
        <result property="deptType" jdbcType="INTEGER" column="dept_type"/>
        <result property="deptName" jdbcType="VARCHAR" column="dept_name"/>
        <result property="createTime" jdbcType="DATETIME" column="create_time"/>
        <result property="updateTime" jdbcType="DATETIME" column="update_time"/>
        <result property="deptPerf" jdbcType="DECIMAL" column="dept_perf"/>
        <result property="isValidFlag" jdbcType="INTEGER" column="is_valid_flag"/>
        <result property="shortName" jdbcType="VARCHAR" column="short_name"/>
        <result property="remark" jdbcType="VARCHAR" column="remark"/>
    </resultMap>
```

- 如果是驼峰格式则使用下面开启即可：eg:`column=dept_id`表中对应字段`deptId`

```xml
<settings>
    <!--  开启自动驼峰命名规则映射  -->
    <setting name="mapUnderscoreToCamelCase" value="true"/>
</settings>
```

- **如果世界总是这么简单就好了**

### 2. 日志工厂



### 3. 缓存机制

**二级缓存的执行流程**

1.默认情况下，只有一级缓存(SqlSession级别的缓存也称为本地缓存)默认开启。 当Session close后，所有的cache就会清空。

2、二级缓存需要手动开启和配置，他是基于Namespace级别的缓存，使用二级缓存 需要实现`Serializable` 序列化.

3、对于缓存数据更新机制 当某一个作用域(一级缓存Session/二级缓存Namespace)进行了 增加，更新，删除操作后 默认改作用域下所有Select

中的缓存被clear.





<img src="https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/21ee8a0a16604a51955476511a2c20a0.png" alt="在这里插入图片描述" style="zoom:50%;" />

[Spring boot 整合mybatis 开启二级缓存](https://blog.csdn.net/LvQiFen/article/details/124884623)





### 4. 一对多





### 5. 多对一



## 五、SpringBoot

SpringBoot 使用版本如下

```xml
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-dependencies</artifactId>
   <version>2.1.0</version>
</dependency>
```

### 1.SpringBoot如何完成自动配置的

`@SpringBootApplication` 分析

```java
/**
 * @program: spring-boot-learning
 * @description: 启动类
 * @author: TestApplication
 * @create: 2021-10-28 17:28
 **/
@SpringBootApplication
public class TestApplication {
	public static void main(String[] args) {
		SpringApplication.run(TestApplication.class, args);
	}
}
```

**1.进入`@SpringBootApplication` 查看源码**

```java
//
@Target({ElementType.TYPE})

@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
//1.标注当前类是配置类，并将当前类内声明的一 个或多个以@Bean注解标记的方法的实例注入到spring容器中
@SpringBootConfiguration
//2.从classpath中搜索所有jar包下的ME TA- INF/spring. factories配置文件，
// 然后将其中key为org. springframework.boot.autoconfigure.EnableAutoConfiguration
// value对象实例注入到spring容器中
@EnableAutoConfiguration
//3.这个注解，就是扫描注解，默认是扫描当前类下的package.将
// @Controller/@Service/@Component/@Reposi tory等注解加载到spring容器中。
@ComponentScan(
    excludeFilters = {@Filter(
    type = FilterType.CUSTOM,
    classes = {TypeExcludeFilter.class}
), @Filter(
    type = FilterType.CUSTOM,
    classes = {AutoConfigurationExcludeFilter.class}
)}
)
public @interface SpringBootApplication {
```



**2.查看 `@EnableAutoConfiguration注解`**

<img src="https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220707113800797.png" alt="image-20220707113800797" style="zoom: 80%;" />

**3. 查看 `@AutoConfigurationImportSelector` 注解**

<img src="https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220707114139056.png" alt="image-20220707114139056" style="zoom: 67%;" />

**获取配置文件**

<img src="https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220707114224969.png" alt="image-20220707114224969" style="zoom:80%;" />

**加载jar包下面的每个spring.factories 文件**

![image-20220707114317197](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220707114317197.png)

**查看spring.factories 文件 kay value **

![image-20220707114538253](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220707114538253.png)



**查看自动导入的配置**

![image-20220707115428589](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220707115428589.png)

### 2.SpringBoot run()方法执行流程

SpringBoot启动分为两部分，
1.创建SpringApplication对象，主要是加载Initializer和Listeners
2.执行run方法

![image-20220707145714963](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220707145714963.png)

**1.new SpringApplication(primarySources)，SpringApplication实例化的创建过程**

```java
public SpringApplication(Class<?>... primarySources) {
		this(null, primarySources);
	}
public SpringApplication(ResourceLoader resourceLoader, Class<?>... primarySources) {

		this.sources = new LinkedHashSet();
		this.bannerMode = Mode.CONSOLE;
		this.logStartupInfo = true;
		this.addCommandLineProperties = true;
		this.addConversionService = true;
		this.headless = true;
		this.registerShutdownHook = true;
		this.additionalProfiles = new HashSet();
		this.isCustomEnvironment = false;
		this.resourceLoader = resourceLoader;
		Assert.notNull(primarySources, "PrimarySources must not be null");

		//项目启动类 SpringbootDemoApplication.class设置为属性存储起来
		this.primarySources = new LinkedHashSet<>(Arrays.asList(primarySources));

		//设置应用类型是SERVLET应用（Spring 5之前的传统MVC应用）还是REACTIVE应用（Spring 5开始出现的WebFlux交互式应用）
		this.webApplicationType = WebApplicationType.deduceFromClasspath();

		// 设置初始化器(Initializer),最后会调用这些初始化器
		//所谓的初始化器就是org.springframework.context.ApplicationContextInitializer的实现类,在Spring上下文被刷新之前进行初始化的操作
		setInitializers((Collection) getSpringFactoriesInstances(ApplicationContextInitializer.class));

		// 设置监听器(Listener)
		setListeners((Collection) getSpringFactoriesInstances(ApplicationListener.class));

		// 初始化 mainApplicationClass 属性:用于推断并设置项目main()方法启动的主程序启动类
		this.mainApplicationClass = deduceMainApplicationClass();
	}
```

**SpringApplication的初始化过程主要分为四个部分**

```
1.this.webApplicationType = WebApplicationType.deduceFromClasspath()，主要作用是设置应用类型是SERVLET应用（Spring 5之前的传统MVC应用）还是REACTIVE应用（Spring 5开始出现的WebFlux交互式应用）

2.this.setInitializers(this.getSpringFactoriesInstances(ApplicationContextInitializer.class))，设置初始化器(Initializer),在初始化器设置过程中，会使用SpringFactoriesLoader从META-INF/spring.factories文件获取所有可用的应用初始化器类ApplicationContextInitializer

3.this.setListeners(this.getSpringFactoriesInstances(ApplicationListener.class))，设置监听器(Listener)，与上面的设置初始化器一样，也是使用SpringFactoriesLoader从META-INF/spring.factories文件获取所有可用的监听器类ApplicationListener

4.this.mainApplicationClass = this.deduceMainApplicationClass()，用于推断并设置项目main()方法启动的主程序启动类

```



```java
	public ConfigurableApplicationContext run(String... args) {
		//创建时间对象并启动计时，设置当前任务名和记录启动时间
		StopWatch stopWatch = new StopWatch();
		stopWatch.start();
		//创建IOC容器
		ConfigurableApplicationContext context = null;
		//异常相关
		Collection<SpringBootExceptionReporter> exceptionReporters = new ArrayList<>();
		// headless 模式 自力更生模式
		configureHeadlessProperty();
		//获取运行时监听器，详情可以点进去这个类，可以看到监听的细节
		SpringApplicationRunListeners listeners = getRunListeners(args);
		listeners.starting();
         Collection exceptionReporters;
		try {
			ApplicationArguments applicationArguments = new DefaultApplicationArguments(args);
			//准备环境对象，下面单独说明
			ConfigurableEnvironment environment = prepareEnvironment(listeners, applicationArguments);
			configureIgnoreBeanInfo(environment);
			//打印信息 spring图标
			Banner printedBanner = printBanner(environment);
			//创建Spring容器
			context = createApplicationContext();
			//通过调用 getSpringFactoriesInstances 方法来获取配置的异常类名称并实例化所有的异常处理类。
			exceptionReporters = getSpringFactoriesInstances(SpringBootExceptionReporter.class,
					new Class[] { ConfigurableApplicationContext.class }, context);
			//准备容器
			prepareContext(context, environment, listeners, applicationArguments, printedBanner);
			//刷新容器 重要
			refreshContext(context);
			afterRefresh(context, applicationArguments);
			stopWatch.stop();
             //打印 Spring Boot 启动的时长日志。
			if (this.logStartupInfo) {
				new StartupInfoLogger(this.mainApplicationClass).logStarted(getApplicationLog(), stopWatch);
			}
            
             //发出结束执行的事件通知
             //用于调用项目中自定义的执行器XxxRunner类，使得在项目启动完成后立即执行一些特定程序
			//Runner 运行器用于在服务启动时进行一些业务初始化操作，这些操作只在服务启动后执行一次。
			//Spring Boot提供了ApplicationRunner和CommandLineRunner两种服务接口
            
			listeners.started(context);
             //执行Runners 
			callRunners(context, applicationArguments);
		}
		catch (Throwable ex) {
             // 如果发生异常，则进行处理，并抛出 IllegalStateException 异常
			handleRunFailure(context, ex, exceptionReporters, listeners);
			throw new IllegalStateException(ex);
		}
	//表示在前面一切初始化启动都没有问题的情况下，使用运行监听器SpringApplicationRunListener持续运行配置好的应用上下文		ApplicationContext， 这样整个Spring Boot项目就正式启动完成了。
		try {
			listeners.running(context);
		}
		catch (Throwable ex) {
             // 如果发生异常，则进行处理，并抛出 IllegalStateException 异常
			handleRunFailure(context, ex, exceptionReporters, null);
			throw new IllegalStateException(ex);
		}
         //返回容器
		return context;
	}

```

**prepareEnvironment()方法说明**

```java
    private ConfigurableEnvironment prepareEnvironment(SpringApplicationRunListeners listeners, ApplicationArguments applicationArguments) {
        //创建环境对象
        ConfigurableEnvironment environment = this.getOrCreateEnvironment();
        //配置环境对象
        this.configureEnvironment((ConfigurableEnvironment)environment, applicationArguments.getSourceArgs());
        
        //将环境对象和 ConfigurationPropertySource关联。
        listeners.environmentPrepared((ConfigurableEnvironment)environment);
         //将配置好的环境对象绑定到SpringApplication。
        this.bindToSpringApplication((ConfigurableEnvironment)environment);
        if (!this.isCustomEnvironment) {
            environment = (new EnvironmentConverter(this.getClassLoader())).convertEnvironmentIfNecessary((ConfigurableEnvironment)environment, this.deduceEnvironmentClass());
        }

        ConfigurationPropertySources.attach((Environment)environment);
        return (ConfigurableEnvironment)environment;
    }
```

[SpringApplication.run 源码分析](https://blog.csdn.net/rzpy_qifengxiaoyue/article/details/107321380?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-1-107321380-blog-125079696.pc_relevant_aa&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-1-107321380-blog-125079696.pc_relevant_aa&utm_relevant_index=1)

## 六、MySQL

### 1.MySQL函数

```sql
SELECT ABS(-8) -- 绝对值
SELECT CEILING(9.4)  -- 向上取整
SELECT FLOOR(X)(9.4) -- 向下取整
SELECT RAND() -- 返回一个0-1之间的随机数
SELECT SIGN(10)-- 判断一个数的符号 0-0负数返回-1 正数返回1


-- 字符串
SELECT CHAR_LENGTH(str) -- 字符串长度
SELECT CONCAT("hello","world") -- 拼接字符串
SELECT LOWER(str) -- 小写
SELECT UPPER(str) -- 大写
SELECT REPLACE("helloworld",'h','H') -- 替换
SELECT SUBSTRING("helloworld",1,5)
SELECT REVERSE("helloworld") -- 反转


SELECT CURRENT_DATE --当前日期
SELECT CURRENT_TIME() --当前时间
SELECT CURDATE()
SELECT NOW()
SELECT LOCALTIME() -- 获取当前时间
SELECT SYSDATE() -- 获取系统时间

SELECT COUNT(dept_no) FROM  orm_dept  -- 忽略为null 的数据
```

### 2.ACID

脏读：一个事务读取了另外一个事务没有提交的数据

不可重复读：第一个事务在读取一条数据时候 发现数据已经变了

幻读：一个事务读取到了 另外一个事务插入的数据

### 3.MyISAM和innonDB区别

InnonDB 默认使用

1. InnoDB支持事务，MyISAM不支持
2. InnoDB支持外键，而MyISAM不支持
3. InnoDB是聚集索引，使用B+Tree作为索引结构主键索引会存放具体行信息,MyISAMB+树主键索引和辅助索引的叶子节点都是数据文件的地址指针。
4. InnoDB不保存表的具体行数，执行select count(*) from table时需要全表扫描。而MyISAM用一个变量保存了整个表的行数，执行上述语句时只需要读出该变量即可，速度很快（注意不能加有任何WHERE条件）
5. InnoDB支持表、行(默认)级锁，而MyISAM支持表级锁。InnoDB的行锁是实现在索引上的，而不是锁在物理行记录上。潜台词是，如果访问没有命中索引，也无法使用行锁，将要退化为表锁
6. InnoDB表必须有唯一索引（如主键），MyISAM没有
7. Innodb存储文件有frm、ibd，而Myisam是frm、MYD、MYI。Innodb：frm是表定义文件，ibd是数据文件； Myisam：frm是表定义文件，myd是数据文件，myi是索引文件。

> 在物理空间存在的位置

所有的数据都存在data目录下，本质还是文件存储，一个文件夹对应一个数据库

MySQL引擎在物理文件上的区别

- Myisam 对应文件
   - *.frm  表结构定义的文件
   - *.MYD  数据文件（data）
   - *.MYI 索引文件
   -

**设置数据库表的字符集编码：** CHARSET = utf8

不设置会是mysql默认的字符集编码。不支持中文

### 4.常用SQL语句

```sql
-- 1.查看创建表语句
SHOW CREATE DATABASE snailthink -- 查看创建数据库语句
SHOW CREATE TABLE orm_dept -- 查看创建表语句

-- 2.字段CRUD
-- 添加字段
alter table 【表名】 add 【列名】 varchar(64);
-- 删除字段
alter table 【表名】 drop column 【列名】;
-- 删除默认值
alter table 【表名】 alter 【列名】 drop default;
-- 修改字段
ALTER TABLE 【表名】 CHANGE 【列名】【新列名称】 varchar(32) NOT NULL  COMMENT '注释说明'


-- 3.索引CRUD
-- 1>添加索引
ALTER TABLE 表名 ADD INDEX 索引名称 (字段名);
-- 1.添加主键索引　　
ALTER TABLE `table_name` ADD PRIMARY KEY (`column`) 　
-- 2.添加唯一索引　　
ALTER TABLE `table_name` ADD UNIQUE (`column`) 　
-- 3.添加全文索引　　
ALTER TABLE `table_name` ADD FULLTEXT (`column`) 　
-- 4.添加普通索引　　
ALTER TABLE `table_name` ADD INDEX index_name (`column`) 　
-- 5.添加多列索引　　
ALTER TABLE `table_name` ADD INDEX index_name (`column1`, `column2`, `column3`)

-- 2>删除索引
DROP INDEX 索引名称 ON 表名;

-- 3> 查看索引
SHOW INDEX FROM 表名；或者SHOW KEYS FROM 表名;
```



### 5.数据库事务

**1.事务特性**

原子性：即不可分割性，事务要么全部被执行，要么就全部不被执行。

一致性：事务的执行使得数据库从一种正确状态转换成另一种正确状态。

隔离性：在事务正确提交之前，不允许把该事务对数据的任何改变提供给任何其他事务。

持久性：事务正确提交后，其结果将永久保存在数据库中，即使在事务提交后有了其他故障， 事务的处理结果也会得到保存。

**2.隔离级别**

1. 提交未读
2. 提交已读
3. 可重复读
4. 可串行读

### 6.索引

#### **1.索引类型**

1. 普通索引：最基本的索引 没有任何限制
2. 唯一索引：和普通索引类似，不同的是索引列的值必须唯一，但是允许为空值。如果是组合索引，则组合必须唯一。
3. 主键索引：用于标识数据库中的某一条记录 不允许有空值 `primary key`约束
4. 联合索引(复合索引)：多字段上建立的索引 能够加速复合查询条件的检索
5. 全文索引：新版本 MySQL 5.6 的 InnoDB 支持全文索引。默认MySQL不支持中文全文索引

#### **2.索引底层**





#### **3.如何避免索引失效**

1.使用like关键字模糊查询时，%放在前面索引不起作用 eg: `like'%abc'，like'%abc%' `

```sql
explain SELECT dept_id,dept_no,dept_name FROM orm_dept where dept_no like '%001%'
explain SELECT dept_id,dept_no,dept_name FROM orm_dept where dept_no like '%001'
```

2.索引列参与运算或者索引列参使用了函数

3.使用OR操作

4.两列数据做比较，即便两列都创建了索引，索引也会失效。`explain SELECT dept_id,dept_no,dept_name FROM orm_dept where dept_id>id`

5.不等于比较

6.is not null

7.查询条件使用not in时，如果是主键则走索引，如果是普通索引，则索引失效

8.查询条件使用not exists时，索引失效。





[索引失效场景](https://blog.csdn.net/m0_71777195/article/details/125655380)

[Explain执行计划](https://blog.csdn.net/u014532775/article/details/106623994)

#### 4.分析执行计划

```sql
-- 1.添加索引字段
ALTER TABLE orm_dept ADD INDEX IDEX_DEPT_ID (dept_id);

-- 添加dept_no 索引
ALTER TABLE orm_dept ADD INDEX IDEX_DEPT_NO (dept_no);

-- 查看执行计划
explain SELECT dept_id,dept_no,dept_name FROM orm_dept where dept_id>1000 AND is_valid_flag=1 ;
```

![image-20220726182617625](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220726182617625.png)

**执行计划字段解析**

##### **ID**

**`id`的值越大，代表优先级越高，越先执行**

##### select_type

`select_type`：表示 `select` 查询的类型，主要是用于区分各种复杂的查询，例如：`普通查询`、`联合查询`、`子查询`等。

`SIMPLE`：表示最简单的 select 查询语句，也就是在查询中不包含子查询或者 `union`交并差集等操作。

`PRIMARY`：当查询语句中包含任何复杂的子部分，最外层查询则被标记为`PRIMARY`。

`SUBQUERY`：当 `select` 或 `where` 列表中包含了子查询，该子查询被标记为：`SUBQUERY`。

`DERIVED`：表示包含在`from`子句中的子查询的select，在我们的 `from` 列表中包含的子查询会被标记为`derived` 。

`UNION`：如果`union`后边又出现的`select` 语句，则会被标记为`union`；若 `union` 包含在 `from` 子句的子查询中，外层 `select` 将被标记为 `derived`。

`UNION RESULT`：代表从`union`的临时表中读取数据，而`table`列的`<union1,4>`表示用第一个和第四个`select`的结果进行`union`操作。

##### table

table:查询的表名称

##### partitions

查询时匹配到的分区信息，对于非分区表值为`NULL`，当查询的是分区表时，`partitions`显示分区表命中的分区情况。

##### type

type：查询使用了何种类型，它在 SQL优化中是一个非常重要的指标，以下性能从好到坏依次是：system  > const > eq_ref > ref  > ref_or_null > index_merge > unique_subquery > index_subquery > range > index > ALL


`system`： 当表仅有一行记录时(系统表)，数据量很少，往往不需要进行磁盘IO，速度非常快。

`const`：表示查询时命中 primary key 主键或者 unique 唯一索引，或者被连接的部分是一个常量(const)值。这类扫描效率极高，返回数据量少，速度非常快。

`eq_ref`：查询时命中主键`primary key` 或者 `unique key`索引， `type` 就是 `eq_ref`。

`ref`：区别于`eq_ref` ，`ref`表示使用非唯一性索引，会找到很多个符合条件的行。

`ref_or_null`：这种连接类型类似于 ref，区别在于 `MySQL`会额外搜索包含`NULL`值的行。

`index_merge`：使用了索引合并优化方法，查询使用了两个以上的索引。

`unique_subquery`：替换下面的 `IN`子查询，子查询返回不重复的集合。

`index_subquery`：区别于`unique_subquery`，用于非唯一索引，可以返回重复值。

`range`：使用索引选择行，仅检索给定范围内的行。简单点说就是针对一个有索引的字段，给定范围检索数据。在`where`语句中使用 `bettween...and`、`<`、`>`、`<=`、`in` 等条件查询 `type` 都是 `range`。

`index`：`Index` 与`ALL` 其实都是读全表，区别在于`index`是遍历索引树读取，而`ALL`是从硬盘中读取。

`ALL`：将遍历全表以找到匹配的行，性能最差

##### possible_keys

possible_keys：表示在MySQL中通过哪些索引，能让我们在表中找到想要的记录，一旦查询涉及到的某个字段上存在索引，则索引将被列出，但这个索引并不定一会是最终查询数据时所被用到的索引。

##### key

key：区别于possible_keys，key是查询中实际使用到的索引，若没有使用索引，显示为NULL.当type 为 index_merge 时，可能会显示多个索引。



##### key_len

key_len：表示查询用到的索引长度（字节数），原则上长度越短越好 。

单列索引，那么需要将整个索引长度算进去；

多列索引，不是所有列都能用到，需要计算查询中实际用到的列



##### ref

`ref`：常见的有：`const`，`func`，`null`，字段名。

- 当使用常量等值查询，显示`const`，
- 当关联查询时，会显示相应关联表的`关联字段`
- 如果查询条件使用了`表达式`、`函数`，或者条件列发生内部隐式转换，可能显示为`func`
- 其他情况`null`



##### rows

`rows`：以表的统计信息和索引使用情况，估算要找到我们所需的记录，需要读取的行数。

这是评估`SQL` 性能的一个比较重要的数据，`mysql`需要扫描的行数，很直观的显示 `SQL` 性能的好坏，一般情况下 `rows` 值越小越好。

##### filtered

filtered 这个是一个百分比的值，表里符合条件的记录数的百分比。简单点说，这个字段表示存储引擎返回的数据在经过过滤后，剩下满足条件的记录数量的比例。

在MySQL.5.7版本以前想要显示filtered需要使用explain extended命令。MySQL.5.7后，默认explain直接显示partitions和filtered的信息。


##### Extra

`Extra` ：不适合在其他列中显示的信息，`Explain` 中的很多额外的信息会在 `Extra` 字段显示。

`Using index`：我们在相应的 `select` 操作中使用了覆盖索引，通俗一点讲就是查询的列被索引覆盖，使用到覆盖索引查询速度会非常快，`SQl`优化中理想的状态。

什么又是覆盖索引?

一条 `SQL`只需要通过索引就可以返回，我们所需要查询的数据（一个或几个字段），而不必通过二级索引，查到主键之后再通过主键查询整行数据（`select *` ）。

#### 5.数据库锁

##### 1.行锁合并和表锁

1. 行锁：锁定整行数据 ，开销小，不会出现死锁，锁定力度大 发生锁冲突概率高 并发度最低
2. 表锁：锁定整张表的数据 ，开销大 会出现死锁 锁定力度小 发生锁冲突概率低 并发度最高

##### 2.悲观锁和乐观锁

1. 悲观锁：每次去拿数据的时候都认为别人会修改，所以每次在拿数据的时候都会上锁，这样别人想拿这个数据就会block直到它拿到锁。传统的关系型数据库里边就用到了很多这种锁机制，比如行锁，表锁等，读锁，写锁等，都是 在做操作之前先上锁。
2. 乐观锁： 顾名思义，就是很乐观，每次去拿数据的时候都认为别人不会修改，所以不会 上锁，但是在更新的时候会判断一下在此期间别人有没有去更新这个数据，可以使用版本号等 机制。
3. 乐观锁适用于多读的应用类型，这样可以提高吞吐量，像数据库如果提供类似于 write_condition机制的其实都是提供的乐观锁。

##### 3.如何解决死锁





#### **5.分库分表**

分割表：

水平拆分：可以按照时间进行拆分，比如一年的时间放到一张表中

垂直拆分：将表中的大字段 单独拆分到另外一张表中。



### MySQL问题

**执行count(1)、count(*) 与 count(列名)区别**

1.count(1) and count(字段)区别

- count(1) 会统计表中的所有的记录数，包含字段为null 的记录。
- count(字段) 会统计该字段在表中出现的次数，忽略字段为null 的情况。即不统计字段为null 的记录。
- count(*)包括了所有的列，相当于行数，在统计结果的时候，不会忽略为NULL的值。

2.执行效率上区别

- 列名为主键，count(列名)会比count(1)快
- 列名不为主键，count(1)会比count(列名)快
- 如果表多个列并且没有主键，则 count(1 的执行效率优于 count（*）
- 如果有主键，则 select count（主键）的执行效率是最优的
- 如果表只有一个字段，则 select count（*）最优。

### 7.测试

```sql
-- 删除历史存储过程
DROP PROCEDURE IF EXISTS `insert_t_user`

-- 创建存储过程
delimiter $

CREATE PROCEDURE insert_t_user(IN limit_num int)
BEGIN
  DECLARE i INT DEFAULT 10;
    DECLARE id_no varchar(18) ;
    DECLARE username varchar(32) ;
    DECLARE age TINYINT DEFAULT 1;
    WHILE i < limit_num DO
        SET id_no = CONCAT("NO", i);
        SET username = CONCAT("Tom",i);
        SET age = FLOOR(10 + RAND()*2);
        INSERT INTO `t_user` VALUES (NULL, id_no, username, age, NOW());
        SET i = i + 1;
    END WHILE;
END $

-- 调用存储过程
call insert_t_user(100);
```



### .参考资料

[MySQL环境变量配置](https://blog.csdn.net/cc297322716/article/details/75481687)

[MySQL安装详细说明图文详解](https://blog.csdn.net/cc297322716/article/details/75481687)

## 七、网络通讯部分

### 1.TCP的三次握手

![image-20220727201737597](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220727201737597.png)

**为什么要三次握手**

（第一次握手）客户端 ： 你吃饭了么

（第二次握手）服务器端 ： 吃了 （==服务器端听到了客户端的问题，说明客户端发送正常，服务端的接受正常 ==，此时我们并不知道客户端的接受和服务端的发送功能是否正常）
（第三次握手）客服端：okk（客服端，知道到了服务端的答案。说明客户端接受正常，服务端的发送正常）

所以必须要三次握手，才能确认出服务端和客户端的接受和发送功能是正常的
