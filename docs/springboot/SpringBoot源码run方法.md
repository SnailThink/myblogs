# Spring Boot启动源码之run方法

> 原文:https://blog.csdn.net/yuanchangliang/article/details/124290682


### 前言

> 我们知道，Spring boot其实功能上，和Spring是一样的，只不过Spring boot更加方便开发，所以Spring boot的启动源码，本质上是和Spring一样的，只不过相比较于Spring的启动关键方法refresh()，只是对Spring的bean管理核心方法#refresh()进行了一些封装，以及一些前置处理，及后置处理。

### 1、run方法的大致流程概述

> 1、记录Spring boot启动时间
> 2、设置java.awt.headless属性
> 3、获取所有在构造器中,从spring.factories文件读取加载的监听器
> 4、启动所有监听器
> 5、将main方法中的args参数封装为ApplicationArguments类
> 6、读取profiles文件，并读取各种运行环境配置（jdk、jvm、操作系统等），生成为environment环境变量
> 7、打印banner
> 8、实例化一个Bean工厂DefaultListableBeanFactory，作为应用上下文用于调用后续刷新方法
> 9、从spring.factories中获取SpringBootExceptionReporter类型的异常解析器
> 10、用已有的数据准备上下文，为刷新做准备
> 11、刷新Context，最终会回到Spring中的核心流程AbstractApplicationContext #refresh

![image-20220711152642793](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220711152642793.png)

### 2、run方法源码

```java
public ConfigurableApplicationContext run(String... args) {
//计时器，用于统计启动耗时，stopWatch.start()开始计时，stopWotch.stop()结束计时
   StopWatch stopWatch = new StopWatch();
//开始计时
   stopWatch.start();
   ConfigurableApplicationContext context = null;
   Collection<SpringBootExceptionReporter> exceptionReporters = new ArrayList<>();
//设置java.awt.headless 属性是true 还是false。
   configureHeadlessProperty();
//获取所有在构造器中读取加载的监听器。
   SpringApplicationRunListeners listeners = getRunListeners(args);
//启动监听器。补充点⑥
   listeners.starting();
   try {
//将main方法中的args参数封装为ApplicationArguments类。
      ApplicationArguments applicationArguments = new DefaultApplicationArguments(args);
//顾名思义，准备环境（生成环境变量）
      ConfigurableEnvironment environment = prepareEnvironment(listeners, applicationArguments);
      configureIgnoreBeanInfo(environment);
//打印banner
      Banner printedBanner = printBanner(environment);
      // 创建ApplicationContext，通过从上到下实例化，实例化了一个DefaultListableBeanFactory，作为Spring框架中很重要的一个类
      context = createApplicationContext();
      //从spring.factories中获取SpringBootExceptionReporter类型的异常解析器
exceptionReporters = getSpringFactoriesInstances(SpringBootExceptionReporter.class,
      new Class[] { ConfigurableApplicationContext.class }, context);
     // 用已有的数据准备上下文，为刷新做准备
      prepareContext(bootstrapContext, context, environment, listeners, applicationArguments, printedBanner);
      // 刷新Context，最终会回到Spring中的核心流程AbstractApplicationContext#refresh
      refreshContext(context);
      //目前为空
      afterRefresh(context, applicationArguments);

      stopWatch.stop();
      //输出日志记录执行主类名、时间信息
      if (this.logStartupInfo) {
         new StartupInfoLogger(this.mainApplicationClass).logStarted(getApplicationLog(), stopWatch);
      }
      //发布应用上下文启动完成事件
      listeners.started(context);
      //执行所有 Runner 运行器
      callRunners(context, applicationArguments);
   }
   catch (Throwable ex) {
      handleRunFailure(context, ex, exceptionReporters, listeners);
      throw new IllegalStateException(ex);
   }

   try {
   //发布应用上下文就绪事件
      listeners.running(context);
   }
   catch (Throwable ex) {
      handleRunFailure(context, ex, exceptionReporters, null);
      throw new IllegalStateException(ex);
   }
   return context;
}

```

### 3、关键代码：configureHeadlessProperty()

```java
private void configureHeadlessProperty() {
   System.setProperty(SYSTEM_PROPERTY_JAVA_AWT_HEADLESS,
         System.getProperty(SYSTEM_PROPERTY_JAVA_AWT_HEADLESS, Boolean.toString(this.headless)));
}
```

点开来看，发现有步迷之操作，先getProperties()，再setProperties()，取出来然后存进去，脑子瓦特了？

其实是由于System中getProperty()有2个重载方法,但却只有一个setProperty()方法,其中getProperty()有单参和双参两方法,单参就是简单的获取属性，有就有，没有就没有。

源码中使用的是双参，双参则聪明一点，在没有的时候会返回一个调用者指定的默认值,所以经过这样操作后，不管有没有那个属性，最终都能保证有。

java.awt.headless是J2SE的一种模式，用于在缺少显示屏、键盘或者鼠标时的系统配置，很多监控工具如jconsole 需要将该值设置为true。



### 4、关键代码：getRunListeners(args)

```java
private SpringApplicationRunListeners getRunListeners(String[] args) {
		Class<?>[] types = new Class<?>[] { SpringApplication.class, String[].class };
		return new SpringApplicationRunListeners(logger,
				getSpringFactoriesInstances(SpringApplicationRunListener.class, types, this, args));
	}
```

看到这里的时候，我进行debug，发现在执行这行代码之前，this中已经加载了21个Listener，可能你会疑惑，纳尼，什么时候的事，这是在SpringApplication调用构造方法的时候就初始化了，具体可以看我以下文章:

https://blog.csdn.net/yuanchangliang/article/details/124247716?spm=1001.2014.3001.5502

[Spring boot启动源码之SpringApplication构造器](https://blog.csdn.net/yuanchangliang/article/details/124247716?spm=1001.2014.3001.5502)

这里又是我们熟悉的getSpringFactoriesInstances()方法，这个方法在Spring和Spring boot的源码中出镜率极高，因为Spring框架的大部分需要初始化的类都配置在了spring.factories文件中，所以每次要加载特定类型的类时，都得使用这个方法。

不过这里就是加载了一个EventPublishingRunListener，这是唯一实现了SpringApplicationRunListeners的实现类，该类定义了很多的方法用于在Spring启动过程中进行回调通知，具体的细节可以看我下面这篇文章：



### 5、关键代码：DefaultApplicationArguments(args)

```java
public DefaultApplicationArguments(String... args) {
		Assert.notNull(args, "Args must not be null");
		this.source = new Source(args);
		this.args = args;
	}
```

看起来用处是不大，对吧，这样new一个包装类来包装args干嘛，多此一举吗？按照我的理解，在这里的使用只是附带作用，这个包装类DefaultApplicationArguments最主要的作用是为了为我们提供获取main方法中参数的途径，比如，我们想要获取main方法中的参数，我们可以这样做：

```java
@Component
public class TestApplicationArguments { 	
    @Resource 	
    private ApplicationArguments arguments; 	
    
    public void test() { 		
        System.out.println("非选项参数数量: " + arguments.getNonOptionArgs().size()); 		
        System.out.println("选项参数数量: " + arguments.getOptionNames().size()); 		
        System.out.println("非选项参具参数:"); 		
        arguments.getNonOptionArgs().forEach(System.out::println); 	
         }
}
```

可以在controller，service中获取，非常方便，虽然不常用，但是有没有就是另一回事了。这也是spring boot强大的一种体现。

### 6、关键代码：prepareEnvironment(listeners, applicationArguments)

备环境（生成evironment环境变量），这个方法的作用总结来说就是生成environment实例，并填充各种属性，一般是基本属性，如jdk版本、路径，项目路径，文件编码，系统用户，所在机器的是什么系统，使用了什么版本的JVM等等这种基础属性。具体代码如下：

```java
private ConfigurableEnvironment prepareEnvironment(SpringApplicationRunListeners listeners,
      ApplicationArguments applicationArguments) {
   // Create and configure the environment
//关键代码
   ConfigurableEnvironment environment = getOrCreateEnvironment();
//配置环境变量，加了个解析器，可以解析@Value注解修饰的遍历了
   configureEnvironment(environment, applicationArguments.getSourceArgs());
   ConfigurationPropertySources.attach(environment);
   listeners.environmentPrepared(environment);
   bindToSpringApplication(environment);
   if (!this.isCustomEnvironment) {
      environment = new EnvironmentConverter(getClassLoader()).convertEnvironmentIfNecessary(environment,
            deduceEnvironmentClass());
   }
   ConfigurationPropertySources.attach(environment);
   return environment;
}

```

如上，关键代码是getOrCreateEnvironment()方法，这个方法就是通过前面提到的WebApplicationType类型创建不同的环境，我们这里是SERVLET，创建的是一个StandardServletEnvironment()。调用的是父类的父类AbstractEnvironment的无参构造，在无参构造中，调用了StandardServletEnvironment中重写的customizePropertySources方法，对environment进行了初始化。

我们看一下在调用完构造函数后的environment实例中的属性：

![image-20220711153418939](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220711153418939.png)



可以看到**systemProperties**中加载了64个系统属性，**systemEnvironment**中加载了46个系统环境变量，具体看看有哪些变量，了解一下，可以让我们对environment理解更加透彻。

![image-20220711153522288](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220711153522288.png)



以上只是部分，屏幕太小，放不下了，系统变量的概念就是这种东西。

以下是系统环境变量systemEnvironment中加载的属性，如下：

![image-20220711153611536](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220711153611536.png)

看看，看看，熟悉不，所谓的系统环境变量，不就是我们在配置Java运行环境时所配置的那些吗，比如常见的JAVA_HOME，MAVEN_HOME等等，简直不要太熟悉，就是在environment变量中被加载了，所以现在对environment变量承当的作用就更加清晰了

### 7、关键代码：configureIgnoreBeanInfo(environment)

```java
private void configureIgnoreBeanInfo(ConfigurableEnvironment environment) {
	if (System.getProperty(CachedIntrospectionResults.IGNORE_BEANINFO_PROPERTY_NAME) == null) {
		Boolean ignore = environment.getProperty("spring.beaninfo.ignore", Boolean.class, Boolean.TRUE);
		System.setProperty(CachedIntrospectionResults.IGNORE_BEANINFO_PROPERTY_NAME, ignore.toString());
	}
}
```

这代码的功能非常简单，就是获取上文中environment中的systemProperties中是否存在**spring.beaninfo.ignore**，存在则获取，不存在则添加到environment中的systemProperties中并设置为true。

根据Spring官网中对该属性的解释，

> System property that instructs Spring to use the
> Introspector.IGNORE_ALL_BEANINFO mode when calling the JavaBeans
> Introspector: “spring.beaninfo.ignore”, with a value of “true”
> skipping the search for BeanInfo classes (typically for scenarios
> where no such classes are being defined for beans in the application
> in the first place).

当值为true时，跳过对BeanInfo类的搜索(通常用于在应用程序中首先没有为bean定义此类的场景)。建议为true，减少不必要的启动损耗。

### 8、关键代码：printBanner(environment)

这是进行控制台打印banner的方法（如果不知道banner是啥，百度），可以看到这块代码是在prepareEnvironment后面的，因为在application.properties文件中可以配置一些banner的配置，比如banner.txt文件的位置、文件名、打印开关等。所以需要先加载配置，再提供配置给后续代码调用。

```java
private Banner printBanner(ConfigurableEnvironment environment) {
   if (this.bannerMode == Banner.Mode.OFF) {
      return null;
   }
   ResourceLoader resourceLoader = (this.resourceLoader != null) ? this.resourceLoader
         : new DefaultResourceLoader(getClassLoader());
   SpringApplicationBannerPrinter bannerPrinter = new SpringApplicationBannerPrinter(resourceLoader, this.banner);
   if (this.bannerMode == Mode.LOG) {
      return bannerPrinter.print(environment, this.mainApplicationClass, logger);
   }
   return bannerPrinter.print(environment, this.mainApplicationClass, System.out);
}

```

如果在这里debug，注意从prepareEnviroment开始，就执行了一些监听器，又重新调用到了run方法，就导致了第一遍执行时，bannerMode是OFF的，跳过断点，第二次执行时，才是真正的调用，bannerMode变回了console，能够打印，我之前就是钻了牛角尖，无法理解为什么bannerMode是OFF，banner还是打印了。

这方面比较简单，就不赘述了，另外提供一个生成banner的网址：

[banner在线生成器](http://patorjk.com/software/taag/#p=display&f=3D Diagonal&t=codermy)

### 9、关键代码：createApplicationContext()

```java
/**
	 * Strategy method used to create the {@link ApplicationContext}. By default this
	 * method will respect any explicitly set application context or application context
	 * class before falling back to a suitable default.
	 * @return the application context (not yet refreshed)
	 * @see #setApplicationContextClass(Class)
	 */
	protected ConfigurableApplicationContext createApplicationContext() {
		Class<?> contextClass = this.applicationContextClass;
		if (contextClass == null) {
			try {
				switch (this.webApplicationType) {
				case SERVLET:
					contextClass = Class.forName(DEFAULT_SERVLET_WEB_CONTEXT_CLASS);
					break;
				case REACTIVE:
					contextClass = Class.forName(DEFAULT_REACTIVE_WEB_CONTEXT_CLASS);
					break;
				default:
					contextClass = Class.forName(DEFAULT_CONTEXT_CLASS);
				}
			}
			catch (ClassNotFoundException ex) {
				throw new IllegalStateException(
						"Unable create a default ApplicationContext, please specify an ApplicationContextClass", ex);
			}
		}
		return (ConfigurableApplicationContext) BeanUtils.instantiateClass(contextClass);
	}

```

这方法非常简单，就是创建了一个空上下文，根据前文中的webApplicationType，创建对应类型的上下文，一般情况下，webApplicationType都是SERVLET，创建的是AnnotationConfigApplicationContext。提一嘴，AnnotationConfigApplicationContext的父类的父类实现了ConfigurableApplicationContext，所以可以使用ConfigurableApplicationContext进行统一接收这些子类。而父类可以统一接收不同的子类，这也是设计模式中，策略模式的理论基础。

### 10、关键代码：getSpringFactoriesInstances

```java
exceptionReporters = getSpringFactoriesInstances(SpringBootExceptionReporter.class,
      new Class[] { ConfigurableApplicationContext.class }, context);

```

熟悉的getSpringFactoriesInstances方法，见过好多次了。这个方法的作用就是从spring.factories文件中加载特定类型的实例，比如这里就是获取的SpringBootExceptionReporter类型。这里主要是加载异常分析器，用在try、catch中对异常进行处理。

### 11、关键代码：prepareContext

```java
private void prepareContext(ConfigurableApplicationContext context, ConfigurableEnvironment environment,
      SpringApplicationRunListeners listeners, ApplicationArguments applicationArguments, Banner printedBanner) {
//设置环境变量
   context.setEnvironment(environment);
//上下文后缀处理
   postProcessApplicationContext(context);
//执行Initializers
   applyInitializers(context);
//发布contextPrepared事件
   listeners.contextPrepared(context);
   if (this.logStartupInfo) {
      logStartupInfo(context.getParent() == null);
      logStartupProfileInfo(context);
   }
   // Add boot specific singleton beans
   ConfigurableListableBeanFactory beanFactory = context.getBeanFactory();
   beanFactory.registerSingleton("springApplicationArguments", applicationArguments);
   if (printedBanner != null) {
      beanFactory.registerSingleton("springBootBanner", printedBanner);
   }
   if (beanFactory instanceof DefaultListableBeanFactory) {
      ((DefaultListableBeanFactory) beanFactory)
            .setAllowBeanDefinitionOverriding(this.allowBeanDefinitionOverriding);
   }
   if (this.lazyInitialization) {
      context.addBeanFactoryPostProcessor(new LazyInitializationBeanFactoryPostProcessor());
   }
   // Load the sources
   Set<Object> sources = getAllSources();
   Assert.notEmpty(sources, "Sources must not be empty");
   load(context, sources.toArray(new Object[0]));
   listeners.contextLoaded(context);
}

```

这里又有很多需要注意的了，比如context.setEnviroment()，不仅仅是为context所属的AnnotationConfigApplicationContext设置了环境变量，还为其父类AbstractApplicationContext设置了同一个环境变量。为后续进行refreshContext的时候，调用AbstractApplicationContext中的refresh方法时做准备。

并且通过debug可以发现，此时context其实已经存在了environment对象，那为什么还要setEnviroment，因为context中的是未解析profiles文件的对象，是不完整的；而即将要设置的environment对象则是解析profiles文件后的对象，是完整的；

```java
public class AnnotationConfigServletWebServerApplicationContext
        extends ServletWebServerApplicationContext implements AnnotationConfigRegistry {
    @Override
    public void setEnvironment(ConfigurableEnvironment environment) {
        //显式调用父类AbstractApplicationContext的setEnvironment方法
        super.setEnvironment(environment);
        //调用AnnotatedBeanDefinitionReader#setEnvironment()方法
        this.reader.setEnvironment(environment);

        //ClassPathBeanDefinitionScanner继承了ClassPathScanningCandidateComponentProvider,所以调用了父类setEnvironment方法
        this.scanner.setEnvironment(environment);
    }
}

```

### 12、关键代码：refreshContext(context)

```java
private void refreshContext(ConfigurableApplicationContext context) {
		refresh(context);
		if (this.registerShutdownHook) {
			try {
			//向 JVM 运行时注册一个关闭挂钩,JVM关闭时，关闭此上下文
				context.registerShutdownHook();
			}
			catch (AccessControlException ex) {
				// Not allowed in some environments.
			}
		}
	}

```

就是调用的Spring的bean管理主要方法refresh，具体看我的文章：

[Spring源码之AbstractApplicationContext解析（refresh）](https://blog.csdn.net/yuanchangliang/article/details/123636114)

### 13、关键代码：callRunners

```java
private void callRunners(ApplicationContext context, ApplicationArguments args) {
		List<Object> runners = new ArrayList<>();
		//获取所有ApplicationRunner接口的实现类，并加入列表
		runners.addAll(context.getBeansOfType(ApplicationRunner.class).values());
		//获取所有ApplicationRunner接口的实现类，并加入列表
		runners.addAll(context.getBeansOfType(CommandLineRunner.class).values());
		//根据实现类上面的Order值进行排序，两种类型，如果order值相同，ApplicationRunner优先执行
		AnnotationAwareOrderComparator.sort(runners);
		for (Object runner : new LinkedHashSet<>(runners)) {
			if (runner instanceof ApplicationRunner) {
			    //运行实现了ApplicationRunner的实现类的run方法
				callRunner((ApplicationRunner) runner, args);
			}
			if (runner instanceof CommandLineRunner) {
				//运行实现了ApplicationRunner的实现类的run方法
				callRunner((CommandLineRunner) runner, args);
			}
		}
	}

```

这是一个项目运行成功后的回调通知方法，启动成功后，会调用所有实现了ApplicationRunner接口和CommandLineRunner接口的run方法。很巧，我目前主要负责的项目就有同事使用到了ApplicationRunner，每当项目启动完成，都会异步检查数据库中的省市区表中是否已有数据，没有就自动从高德地图同步并入库，有的话就不做操作。