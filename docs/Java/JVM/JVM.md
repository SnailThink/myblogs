## JVM的组成 

## 一、JVM入门

>参考视频：[B站JVM入门](https://www.bilibili.com/video/BV1iJ411d7jS)
>
>作者：知否派。<br/>
>
>文章所涉及的资料来自互联网整理和个人总结，意在于个人学习和经验汇总，如有什么地方侵权，请联系本人删除，谢谢！



### 1.JVM的位置

​	![image-20220624144859463](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220624144859463.png)

### 2.JVM的体系结构

<img src="https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220624150407686.png" alt="image-20220624150407686" style="zoom: 80%;" />

**jvm调优：99%都是在方法区和堆，大部分时间调堆。** JNI（java native interface）本地方法接口

![image-20220624150640670](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220624150640670.png)



### 3.类加载器





![image-20220624162856282](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220624162856282.png)

- 类是模板，对象是具体的，通过new来实例化对象。car1，car2，car3，名字在栈里面，真正的实例，具体的数据在堆里面，栈只是引用地址。

1. 虚拟机自带的加载器

2. 启动类（根）加载器

3. 扩展类加载器

4. 应用程序加载器

   

```java
package com.deploy.demo.jvm;

/**
 * @program: deploy-demo
 * @description:
 * @author: whcoding
 * @create: 2022-06-24 16:02
 **/
public class JVMTest {

	public static void main(String[] args) {
		JVMTest jvmTest = new JVMTest();
		JVMTest test02 = new JVMTest();
		JVMTest test03 = new JVMTest();

		System.out.println(jvmTest.hashCode());
		System.out.println(test02.hashCode());
		System.out.println(test03.hashCode());

		/**
		 * 1634198
		 * 110456297
		 * 1989972246
		 */
		Class<? extends JVMTest> aClass1 = jvmTest.getClass();

		ClassLoader classLoader = aClass1.getClassLoader(); //获取类加载器 Application 
        
		System.out.println("获取到的类加载器："+classLoader);//ExtClassLoader  \jre\lib\ext
        
		System.out.println("获得ClassLoader的父类："+classLoader.getParent());
   		
         //null  1. 不存在  2. Java程序获取不到
		// private native void start0(); 是用的C 调用的
		System.out.println("获得ClassLoader的祖父："classLoader.getParent().getParent()); 
        
         /**
		 *sun.misc.Launcher$AppClassLoader@18b4aac2
		 * sun.misc.Launcher$ExtClassLoader@6aceb1a5
		 * null
		 */
		Class<? extends JVMTest> aClass2 = test02.getClass();
		Class<? extends JVMTest> aClass3 = test03.getClass();

		System.out.println(aClass1.hashCode());
		System.out.println(aClass2.hashCode());
		System.out.println(aClass3.hashCode());
        /*
        1389647288
        1389647288
        1389647288
         */
	}
}
```



**类加载器的分类**

- 虚拟机自带加载器
- Bootstrap ClassLoader 启动类加载器
- Extention ClassLoader 标准扩展类加载器
- Application ClassLoader 应用类加载器
- User ClassLoader 用户自定义类加载器(`ClassLoader` 是一个抽象类，实现 `ClassLoader`  就是一个用户自定义类加载器)

### 4.双亲委派机制



```java
package java.lang;

/**
 * @program: deploy-demo
 * @description:
 * @author: whcoding
 * @create: 2022-06-24 15:55
 **/
public class String {
    /*
    双亲委派机制:安全
    1.APP-->EXC-->BOOT(最终执行)
    BOOT
    EXC
    APP
     */
    public String toString() {
        return "Hello";
    }

    public static void main(String[] args) {
        String s = new String();
        System.out.println(s.getClass());
        s.toString();
            
       new Thread().start();
    }
    /*
    1.类加载器收到类加载的请求 Application
    2.将这个请求向上委托给父类加载器去完成，一直向上委托，知道启动类加载
    3.启动加载器检查是否能够加载当前这个类，能加载就结束，使用当前的加载器，否则，抛出异常，适知子加载器进行加载
    4.重复步骤3
    Class Notfound   
    null ： java 调用不到或者不存在 底层是用C 语言写的
    Java =C++ 去掉繁琐的东西 指针 ，内存管理[Java 内存管理交给JVM 处理]
   */
}
```



- 关于**双亲委派机制**的博客：

  **APP-->EXC-->BOOT(最终执行)**

- **过程总结**

  - 1.类加载器收到类加载的请求
  - 2.将这个请求向上委托给父类加载器去完成，一直向上委托，直到启动类加载器
  - 3.启动类加载器检查是否能够加载当前这个类，能加载就结束，使用当前的加载器，否则，抛出异常，一层一层向下，通知子加载器进行加载
  - 4.重复步骤3
  - 关于**双亲委派机制**的博客：[Java双亲委派机制及作用](https://www.jianshu.com/p/1e4011617650)

- 概念：当某个类加载器需要加载某个.class文件时，它首先把这个任务委托给他的上级类加载器，递归这个操作，如果上级的类加载器没有加载，自己才会去加载这个类。

- 例子：当一个Hello.class这样的文件要被加载时。不考虑我们自定义类加载器，首先会在AppClassLoader中检查是否加载过，如果有那就无需再加载了。如果没有，那么会拿到父加载器，然后调用父加载器的loadClass方法。父类中同理也会先检查自己是否已经加载过，如果没有再往上。注意这个类似递归的过程，直到到达Bootstrap classLoader之前，都是在检查是否加载过，并不会选择自己去加载。直到BootstrapClassLoader，已经没有父加载器了，这时候开始考虑自己是否能加载了，如果自己无法加载，会下沉到子加载器去加载，一直到最底层，如果没有任何加载器能加载，就会抛出ClassNotFoundException。

委派机制的流程图

<img src="https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/7634245-7b7882e1f4ea5d7d.png" alt="img" style="zoom: 67%;" />


### 6.Native

```java
public static void main(String[] args) {
	new Thread(() -> {
	}, "your thread name").start();
}
```

**点进去看start方法的源码：**

```java
public synchronized void start() {
    /**
     * This method is not invoked for the main method thread or "system"
     * group threads created/set up by the VM. Any new functionality added
     * to this method in the future may have to also be added to the VM.
     *
     * A zero status value corresponds to state "NEW".
     */
    if (threadStatus != 0)
        throw new IllegalThreadStateException();

    /* Notify the group that this thread is about to be started
     * so that it can be added to the group's list of threads
     * and the group's unstarted count can be decremented. */
    group.add(this);

    boolean started = false;
    try {
        start0();
        started = true;
    } finally {
        try {
            if (!started) {
                group.threadStartFailed(this);
            }
        } catch (Throwable ignore) {
            /* do nothing. If start0 threw a Throwable then
              it will be passed up the call stack */
        }
    }
}
// native 去调用底层C语言的库！
private native void start0();
```

- **凡是带了native关键字的，说明 java的作用范围达不到，去调用底层C语言的库！**
- **JNI：Java Native Interface（Java本地方法接口）** 
- **凡是带了native关键字的方法就会进入本地方法栈；**
- **Native Method Stack** 本地方法栈
- **本地接口的作用是融合不同的编程语言为Java所用**，它的初衷是融合C/C++程序，Java在诞生的时候是C/C++横行的时候，想要立足，必须有调用C、C++的程序，于是就在内存中专门开辟了一块区域处理标记为native的代码，它的具体做法是 在 Native Method Stack 中登记native方法，在 ( ExecutionEngine ) 执行引擎执行的时候加载Native Libraies。
- 目前该方法使用的越来越少了，除非是与硬件有关的应用，比如通过Java程序驱动打印机或者Java系统管理生产设备，在企业级应用中已经比较少见。因为现在的异构领域间通信很发达，比如可以使用Socket通信，也可以使用Web Service等等，不多做介绍！

### 7.PC寄存器

**程序计数器：**Program Counter Register

- 每个线程都有一个程序计数器，是线程私有的，就是一个指针，指向方法区中的方法字节码(用来存储指向像一条指令的地址，也即将要执行的指令代码)，在执行引擎读取下一条指令，是一个非常小的内存空间，几乎可以忽略不计。

### 8.方法区

**Method Area 方法区**



![image-20220624165147523](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220624165147523.png)



- 方法区是被所有线程共享，所有字段和方法字节码，以及一些特殊方法，如**构造函数，接口代码**也在此定义，简单说，所有定义的方法的信息都保存在该区域，**此区域属于共享区间;**
- 静态变量、常量、类信息(构造方法、接口定义)、运行时的常量池存在方法区中，但是实例变量存在堆内存中，和方法区无关。
- static ，final ，Class ，常量池~

### 9.栈

栈是一种数据结构、栈和队列比较

栈：先进后出、后进先出 (桶里方石头)

队列:先进先出 、(FIFO : First Input First OutPut)



**栈管理程序运行**

- 存储一些基本类型的值、对象的引用、方法等。
- **栈的优势是，存取速度比堆要快，仅次于寄存器，栈数据可以共享。**

问题：为什么main 方法先执行 最后结束：

![image-20220627110624733](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627110624733.png)

举个栗子：**喝多了吐 就是栈。吃多了拉就是队列**

说明：1、栈也叫栈内存，主管Java程序的运行，是在线程创建时创建，它的生命期是跟随线程的生命期，线程结束栈内存也就释放。

​	 2、**对于栈来说不存在垃圾回收问题**，只要线程一旦结束，该栈就Over，生命周期和线程一致

​	 3、方法自己调自己就会导致栈溢出（递归死循环测试）。



**递归死循环测试-栈溢出测试**

 递归调用 测试栈溢出

```java
package com.whcoding.test.demo;

/**
 * @program: spring-boot-learning
 * @description: 递归调用 测试栈溢出
 * @author: whcoding
 * @create: 2022-06-27 11:09
 **/
public class StackDemo {

	public static void main(String[] args) {
		new StackDemo().test();
	}

	public void test() {
		test2();
	}

	public void test2() {
		test();
	}
}
```



![image-20220627111154806](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627111154806.png)



**栈里面会放什么东西？**

- 8大基本类型 + 对象的引用 + 实例的方法

**栈运行原理**

- Java栈的组成元素——栈帧。
- 栈帧是一种用于帮助虚拟机执行方法调用与方法执行的数据结构。他是独立于线程的，一个线程有自己的一个栈帧。封装了方法的局部变量表、动态链接信息、方法的返回地址以及操作数栈等信息。
- 第一个方法从调用开始到执行完成，就对应着一个栈帧在虚拟机栈中从入栈到出栈的过程。

![image-20220627111839157](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627111839157.png)





**栈、堆、方法区**：交互关系

![image-20220627111921988](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627111921988.png)



### 10.三种JVM

- Sun公司HotSpot java Hotspot™64-Bit server vw (build 25.181-b13，mixed mode)
- BEA JRockit
- IBM 39 VM
- 我们学习都是：Hotspot

![image-20220627110013234](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627110013234.png)

### 11.堆

**Java 1.7之前**

- Heap 堆，一个JVM实例只存在一个堆内存，堆内存的大小是可以调节的。
- 类加载器读取了类文件后，需要把类，方法，常变量放到堆内存中，保存所有引用类型的真实信息，以方便执行器执行。
- 堆内存分为三部分：
  - 新生区 Young Generation Space Young/New
  - 养老区 Tenure generation space Old/Tenure
  - 永久区 Permanent Space Perm

- 堆内存逻辑上分为三部分：新生，养老，永久（元空间 : JDK8 以后名称）。

![image-20220627160918122](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627160918122.png)



**谁空谁是to**

- **GC**垃圾回收主要是在新生区和养老区，又分为轻GC 和 重GC，如果内存不够，或者存在死循环，就会导致` java.lang OutOfMemoryError : Java Heap space ` 堆内存不够
- 在JDK8以后，永久存储区改了个名字(元空间)。

```java
package com.whcoding.test.demo;

import java.util.Random;

/**
 * @program: spring-boot-learning
 * @description:  java.lang OutOfMemoryError : Java Heap space 
 * @author: whcoding
 * @create: 2022-06-27 16:18
 **/
public class HeapDemo {

	public static void main(String[] args) {
		String str="whcoding";
		while (true){
			str+=str+new Random().nextInt(888888888)+new Random().nextInt(999999999);
		}
	}
}
```



### 12.新生区、老年区

- 新生区是类诞生，成长，消亡的区域，一个类在这里产生，应用，最后被垃圾回收器收集，结束生命。
- 新生区又分为两部分：伊甸区（Eden Space）和幸存者区（Survivor Space），所有的类都是在伊甸区被new出来的，幸存区有两个：0区 和 1区，当伊甸园的空间用完时，程序又需要创建对象，JVM的垃圾回收器将对伊甸园区进行垃圾回收（Minor GC）。将伊甸园中的剩余对象移动到幸存0区，若幸存0区也满了，再对该区进行垃圾回收，然后移动到1区，那如果1区也满了呢？（这里幸存0区和1区是一个互相交替的过程）再移动到养老区，若养老区也满了，那么这个时候将产生MajorGC（Full GC），进行养老区的内存清理，若养老区执行了Full GC后发现依然无法进行对象的保存，就会产生OOM异常 “OutOfMemoryError ”。如果出现 java.lang.OutOfMemoryError：java heap space异常，说明Java虚拟机的堆内存不够，原因如下：
  - 1、Java虚拟机的堆内存设置不够，可以通过参数 -Xms（初始值大小），-Xmx（最大大小）来调整。
  - 2、代码中创建了大量大对象，并且长时间不能被垃圾收集器收集（存在被引用）或者死循环。

![image-20220627162756565](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627162756565.png)

**真相：** 经过研究,99%的对象都是临时对象



### 13.永久区

- 永久存储区是一个常驻内存区域，用于存放JDK自身所携带的Class，Interface的元数据，也就是说它存储的是运行环境必须的类信息，这个区域不存在垃圾回收，关闭JVM才会释放此区域所占用的内存。
- 如果出现 java.lang.OutOfMemoryError：PermGen space，说明是 Java虚拟机对永久代Perm内存设置不够。一般出现这种情况，都是程序启动需要加载大量的第三方jar包，
- 例如：在一个Tomcat下部署了太多的应用。或者大量动态反射生成的类不断被加载，最终导致Perm区被占满。

**注意：**

- JDK1.6之前： 有永久代，常量池1.6在方法区；
- JDK1.7： 有永久代，但是已经逐步 “去永久代”，常量池1.7在堆；
- JDK1.8及之后：无永久代，常量池1.8在元空间。.



- 实际而言，方法区（Method Area）和堆一样，是各个线程共享的内存区域，它用于存储虚拟机加载的：类信息+普通常量+静态常量+编译器编译后的代码，虽然JVM规范将方法区描述为**堆的一个逻辑部分，但它却还有一个别名，叫做Non-Heap（非堆），目的就是要和堆分开**。
- 对于HotSpot虚拟机，很多开发者习惯将方法区称之为 “永久代（Parmanent Gen）”，但严格本质上说两者不同，或者说使用永久代实现方法区而已，永久代是方法区（相当于是一个接口interface）的一个实现，Jdk1.7的版本中，已经将原本放在永久代的字符串常量池移走。
- 常量池（Constant Pool）是方法区的一部分，Class文件除了有类的版本，字段，方法，接口描述信息外，还有一项信息就是常量池，这部分内容将在类加载后进入方法区的运行时常量池中存放！

![image-20220627163834809](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627163834809.png)

### 14.堆内存调优

- -Xms：设置初始分配大小，默认为物理内存的 “1/64”。
- -Xmx：最大分配内存，默认为物理内存的 “1/4”。
- -XX:+PrintGCDetails：输出详细的GC处理日志。

#### **查看虚拟机最大内存：测试**

```java
public static void main(String[] args) {
		// 返回虚拟机试图使用的最大内存
		long max = Runtime.getRuntime().maxMemory();    // 字节：1024*1024
		// 返回jvm的总内存
		long total = Runtime.getRuntime().totalMemory();
		System.out.println("max=" + max + "字节	" + (max/(double)1024/1024) + "MB");
		System.out.println("total=" + total + "字节	" + (total/(double)1024/1024) + "MB");
		// 默认情况下:分配的总内存是电脑内存的1/4,初始化的内存是电脑的1/64
	}
```

#### **设置虚拟机内存为1024m**

- **IDEA**中进行VM调优参数设置，然后启动。VM参数调优：把初始内存，和总内存都调为 1024M，运行，查看结果！`-Xms1024m -Xmx1024m -XX:+PrintGCDetails`

![image-20220627164449073](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627164449073.png)



#### **查看新生代老年代内存空间**

![image-20220728150243446](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220728150243446.png)

再次验证：元空间并不在虚拟机中 (逻辑上存在，物理上不存在）



- user – 总计本次 GC 总线程所占用的总 CPU 时间。
- sys – OS 调用 or 等待系统时间。
- real – 应用暂停时间。
- 如果GC 线程是 Serial Garbage Collector 串行搜集器的方式的话（只有一条GC线程,）， real time 等于user 和 system 时间之和。
- 通过日志发现Young的区域到最后 GC 之前后都是0，old 区域 无法释放，最后报堆溢出错误。



#### **OOM问题排查**

- 1. 尝试扩大内存看结果
  2. 分析内存 看下哪个地方出现问题了

#### **设置虚拟机内存为8m**

`-Xms8m -Xmx8m -XX:+PrintGCDetails`

**测试设置JVM 内存8m**

```java
public class Demo02 {
    public static void main(String[] args) {
        String str = "whcoding";
        while (true) {
            str += str + new Random().nextInt(88888888)
                    + new Random().nextInt(999999999);
        }
    }
}
```



![image-20220627165518623](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627165518623.png)

**其他文章链接**

- [一文读懂 - 元空间和永久代](https://juejin.cn/post/684490402096480257)
- [Java方法区、永久代、元空间、常量池详解](https://blog.csdn.net/u011635492/article/details/81046174?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-2.control&dist_request_id=1331647.219.16183160373688617&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-2.control)

### 15.GC

#### Dump内存快照

在运行java程序的时候，有时候想测试运行时占用内存情况，这时候就需要使用测试工具查看了。在eclipse里面有 **Eclipse Memory Analyzer tool(MAT)**插件可以测试，而在idea中也有这么一个插件，就是**JProfiler**，一款性能瓶颈分析工具！



**1.安装JProﬁler插件**

**2.安装JProﬁler监控软件**

- 下载地址：[https://www.ej-technologies.com/download/jproﬁler/version_92](https://www.ej-technologies.com/download/jprofiler/version_92)

**3.注册**

```java
// 注册码仅供大家参考
L-Larry_Lau@163.com#23874-hrwpdp1sh1wrn#0620
L-Larry_Lau@163.com#36573-fdkscp15axjj6#25257
L-Larry_Lau@163.com#5481-ucjn4a16rvd98#6038
L-Larry_Lau@163.com#99016-hli5ay1ylizjj#27215
L-Larry_Lau@163.com#40775-3wle0g1uin5c1#0674
```

**4.配置IDEA运行环境**

- Settings–Tools–JProﬂier–JProﬂier executable选择JProﬁle安装可执行文件。（如果系统只装了一个版本， 启动IDEA时会默认选择）保存。

**5.代码测试**



```java
public class Demo03 {
    byte[] byteArray = new byte[1*1024*1024]; // 1M = 1024K
    public static void main(String[] args) {
        ArrayList<Demo03> list = new ArrayList<>();
        int count = 0;
        try {
            while (true) {
                list.add(new Demo03());  // 问题所在
                count = count + 1;
            }
        } catch (Error e) {
            System.out.println("count:" + count);
            e.printStackTrace();
        }
    }
}
```

- vm参数 ： `-Xms1m -Xmx8m -XX:+HeapDumpOnOutOfMemoryError`

使用 Jproﬁler 工具分析查看

双击这个文件默认使用 Jproﬁler 进行 Open大的对象！

![image-20220627172145327](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627172145327.png)

![image-20220627172159306](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627172159306.png)

![image-20220627172212094](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627172212094.png)

- 从软件开发的角度上，dump文件就是当程序产生异常时，用来记录当时的程序状态信息（例如堆栈的状态），用于程序开发定位问题。

#### GC垃圾回收四大算法

[GC垃圾回收四大算法](https://blog.csdn.net/qq_40585800/article/details/115301188)

### 16.创建对象内存分析

**一个对象实例化的过程中内存**

![image-20220627144937240](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627144937240.png)



![image-20220627141846649](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220627141846649.png)

1. 加载 PetRun类并放入方法区(Application main() 常量池：旺财)
2. 执行main()方法 放到栈中[**在栈中起了一个名字**]
3. new Pet。加载Pet类，将类中的参数放到方法区中(name age shout()),加载类的模板
4. dog 引用变量名称，在栈中创建
5. new pet()在堆中创建获取真实的对象，调用常量池中的数据。（堆内存需要new 关键字才能开辟）
6. cat 和pet是一样的
7. 静态方法区是在一开始的时候就加载了，和类一起加载的。
8. 

- **类是一个模板**
- **堆内存:**保存每一个对象的属性内容，堆内存需要用关键字new才能开辟。
- **栈内存：**保存的是一块堆内存的地址。
- 堆内存很好理解，可能有人会有疑问为什么会有栈内存，举个例子，好比学校有很多教室，每个教室有一个门牌号，教室内放了很多的桌椅等等，这个编号就好比地址，老师叫小明去一个教室拿东西，老师必须把房间号告诉小明才能拿到，也就是为什么地址必须存放在一个地方，而这个地方在计算机中就是栈内存。

### 17.Java 堆和栈的区别

#### 1.堆内存

##### 1.1.什么是堆内存？

堆内存是是Java内存中的一种，它的作用是用于存储Java中的对象和[数组](https://so.csdn.net/so/search?q=数组&spm=1001.2101.3001.7020)，当我们new一个对象或者创建一个数组的时候，就会在堆内存中开辟一段空间给它，用于存放。

##### 1.2.堆内存的特点是什么？

第一点：堆其实可以类似的看做是管道，或者说是平时去排队买票的的情况差不多，所以堆内存的特点就是：先进先出，后进后出，也就是你先排队，好，你先买票。第二点：堆可以动态地分配内存大小，生存期也不必事先告诉编译器，因为它是在运行时动态分配内存的，但缺点是，由于要在运行时动态分配内存，存取速度较慢。

##### 1.3.new对象在堆中如何分配？

由Java虚拟机的自动垃圾回收器来管理



#### 2.栈内存

##### 2.1.什么是栈内存

栈内存是Java的另一种内存，主要是用来执行程序用的，比如：基本类型的变量和对象的引用变量

##### 2.2.栈内存的特点

第一点：栈内存就好像一个矿泉水瓶，像里面放入东西，那么先放入的沉入底部，所以它的特点是：先进后出，后进先出

第二点：存取速度比堆要快，仅次于寄存器，栈数据可以共享，但缺点是，存在栈中的数据大小与生存期必须是确定的，缺乏灵活性

##### 2.3.栈内存分配机制

栈内存可以称为一级缓存，由垃圾回收器自动回收

##### 2.4.数据共享

```java
例子：
int a = 3;
int b = 3;
```

**第一步处理：**

1.编译器先处理int a = 3;
2.创建变量a的引用
3.在栈中查找是否有3这个值
4.没有找到，将3存放，a指向3

**第二步处理：**

1.处理b=3
2.创建变量b的引用
3.找到，直接赋值

**第三步改变：**

接下来
a = 4；
同上方法
a的值改变，a指向4，b的值是不会发生改变的

> PS：如果是两个对象的话，那就不一样了，对象指向的是同一个引用，一个发生改变，另一个也会发生改变

#### 3.栈和堆的区别

JVM是基于堆栈的虚拟机.JVM为每个新创建的线程都分配一个堆栈.也就是说,对于一个Java程序来说，它的运行就是通过对堆栈的操作来完成的。堆栈以帧为单位保存线程的状态。JVM对堆栈只进行两种操作:以帧为单位的压栈和出栈操作。

##### 3.1 差异

1.堆内存用来存放由new创建的对象和数组。
2.栈内存用来存放方法或者局部变量等
3.堆是先进先出，后进后出
4.栈是后进先出，先进后出

##### 3.2 相同

1.都是属于Java内存的一种
2.系统都会自动去回收它，但是对于堆内存一般开发人员会自动回收它


## 二. JVM基础
### 1.请你谈谈你对JVM的理解?



### 2.java8虚拟机和之前的变化更新?



### 3.什么是OOM，什么是栈溢出StackOverFlowError? 怎么分析?



### 4.JVM的常用调优参数有哪些?



### 5.内存快照如何抓取？怎么分析Dump文件？



### 6.谈谈JVM中，类加载器你的认识？

## 参考资料

[狂神说JVM](https://blog.csdn.net/qq_44430911/article/details/120780232)

[JVM视频](https://www.bilibili.com/video/BV1iJ411d7jS)

[JVM入门](http://t.zoukankan.com/gh110-p-14917326.html)

[GC垃圾回收四大算法](https://blog.csdn.net/qq_40585800/article/details/115301188)