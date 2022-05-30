## 走进多线程

1. 多线程是什么？
2. 为什么要用多线程？
3. 多线程能解决什么问题？
4. 什么时候用多线程

[多线程基础](https://blog.csdn.net/wanliguodu/article/details/81005560)

### 1.多线程是什么？

介绍多线程之前要介绍线程，介绍线程则离不开进程。

#### 1.1 什么是进程？ 

**进程** ： 进程（Process）是计算机中的程序关于某数据集合上的一次运行活动，是系统进行资源分配和调度的基本单位，是操作系统结构的基础 。

这是百度百科找到的资料,不太好理解。下面我举个栗子：

栗子：如下图的QQ,tim，Notepad++，每一个程序都有一个独立的进程，进程之间是相互独立存在的。互不干涉，你可以一边听音乐一边写代码。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530181347.png)

#### 1.2 什么是线程？

进程想要执行任务就要依赖线程，也就是说，进程里面的最小单位就是线程，并且一个进程至少有一个线程。

串行：其实相当于单线程执行多个任务 按照顺序执行

并行：下载多个文件，一边上网冲浪，一边写代码，一边听音乐

举个栗子：QQ音乐本身就是一个程序。也就是说他是一个进程，可以听音乐，下载音乐，评论，按照单线程来说我们必须先完成一件事情后才能做下一件事情，这里面有一个执行顺序的。

若是多线程,我们可以在听音乐的时候，一边下载音乐，一边评论。

### 2.为什么要用多线程？

1. 为了更好的利用cpu的资源，如果只有一个线程，则第二个任务必须等到第一个任务结束后才能进行，如果使用多线程则在主线程执行任务的同时可以执行其他任务，而不需要等待；
2. 进程之间不能共享数据，线程可以；
3. 系统创建进程需要为该进程重新分配系统资源，创建线程代价比较小。
4. Java语言内置了多线程功能支持，简化了Java多线程编程。

### 3.实现多线程？

多线程常用的两种方式：`Thread 和Runnable` Runnable具有更好的扩展性，Thread是一个类，Thread本身就是实现了Runnable接口， 此外，Runnable还可以用于“资源共享”。即，多个线程都是基于某个Runnable对象建立的，它们会共享Runnable对象上资源。

#### 3.1 定义任务(Runnable)

线程可以驱动任务，因此只需要一种描述任务的方式，在Java中用 `Runnable`接口来提供。需要定义任务，只需要实现Runnable接口并编写`run()`方法，使得该任务可以执行你的命令。 

```java
public class RunnableTest {

    /**
     * @param args
     */
    public static void main(String[] args) {

        class MyRunnable implements Runnable{
            private int ticket=10; 
            @Override
            public void run() {
                for(int i=0;i<20;i++){ 
                    if(this.ticket>0){
                        System.out.println(Thread.currentThread().getName()+" 卖票：ticket "+this.ticket--);
                    }
                }

            }

        }

        // 启动3个线程t1,t2,t3(它们共用一个Runnable对象)，
        //这3个线程一共卖10张票！这说明它们是共享了MyRunnable接口的。
        MyRunnable runnable = new MyRunnable();
        Thread t1 = new Thread(runnable);
        Thread t2 = new Thread(runnable);
        Thread t3 = new Thread(runnable);
        t1.start();
        t2.start();
        t3.start();
    }
}
```

**运行结果**

```
Thread-2 卖票：ticket 10
Thread-2 卖票：ticket 9
Thread-2 卖票：ticket 8
Thread-2 卖票：ticket 7
Thread-2 卖票：ticket 6
Thread-2 卖票：ticket 5
Thread-2 卖票：ticket 4
Thread-2 卖票：ticket 3
Thread-0 卖票：ticket 2
Thread-0 卖票：ticket 1
```

#### 3.2 继承Thread

 将Runnable对象转变为工作任务的传统方式是把它提交给一个Thread构造器。 

```java

/**
 * @program: snailthink
 * @description:
 * @author: SnailThink
 * @create: 2021-03-04 11:31
 **/
public class ThreadTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		class MyThread extends Thread{
			private int ticket = 10;
			public  void run(){
				for(int i=0;i<20;i++){
					if(this.ticket>0){
						System.out.println(this.getName()+"买票：ticket "+this.ticket--);
					}
				}
			}
		}

		// 启动3个线程t1,t2,t3；每个线程各卖10张票！
		// 和上面的结果对比，并揣摩 “Runnable还可以用于“资源共享”。
		//即，多个线程都是基于某个Runnable对象建立的，
		//它们会共享Runnable对象上的资源”这句话。
		MyThread t1 =new MyThread();
		MyThread t2 =new MyThread();
		MyThread t3 =new MyThread();
		t1.start();
		t2.start();
		t3.start();
	}
}
```

**输出结果**

```
Thread-1买票：ticket 10
Thread-2买票：ticket 10
Thread-0买票：ticket 10
Thread-2买票：ticket 9
Thread-1买票：ticket 9
Thread-2买票：ticket 8
Thread-0买票：ticket 9
Thread-2买票：ticket 7
Thread-1买票：ticket 8
Thread-2买票：ticket 6
Thread-0买票：ticket 8
Thread-2买票：ticket 5
Thread-1买票：ticket 7
Thread-2买票：ticket 4
Thread-0买票：ticket 7
Thread-0买票：ticket 6
Thread-0买票：ticket 5
Thread-0买票：ticket 4
Thread-0买票：ticket 3
Thread-0买票：ticket 2
Thread-0买票：ticket 1
Thread-2买票：ticket 3
Thread-2买票：ticket 2
Thread-2买票：ticket 1
Thread-1买票：ticket 6
Thread-1买票：ticket 5
Thread-1买票：ticket 4
Thread-1买票：ticket 3
Thread-1买票：ticket 2
Thread-1买票：ticket 1
```

### 4.synchronized基本原则和实例

#### 4.1 synchronized 原则

第一条:当一个线程访问某对象的synchronized方法或者synchronized代码块时，其他线程对该对象的该synchronized方法或者synchronized代码块的访问将被阻塞。
第二条:当一个线程访问某对象的synchronized方法或者synchronized代码块时，其他线程仍然可以访问该对象的非同步代码块。
第三条:当一个线程访问某对象的synchronized方法或者synchronized代码块时，其他线程对该对象的其他的synchronized方法或者synchronized代码块的访问将被阻塞。

#### 4.2  第一条

当一个线程访问**`某对象`**的**`synchronized方法`**或者**`synchronized代码块`**时，其他线程对**`该对象`**的该**`synchronized方法`**或者**`synchronized代码块`**的访问将被阻塞。 

```java
/**
 * @program: snailthink
 * @description:
 * @author: SnailThink
 * @create: 2021-03-04 14:03
 **/
public class SynchronizedRunnableTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		class MyRunnable implements Runnable{
			private int j=5;
			@Override
			public void run() {

				synchronized(this){
					for(int i=0;i<5;i++){
						try {
							Thread.sleep(100);
							System.out.println(Thread.currentThread().getName()+" loop "+i);
						} catch (InterruptedException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				}
			}
		}
		Runnable runnable = new MyRunnable();
		Thread t1 = new Thread(runnable,"t1");
		Thread t2 = new Thread(runnable,"t2");

		t1.start();
		t2.start();
	}
}
```

运行结果

```java
t1 loop 0
t1 loop 1
t1 loop 2
t1 loop 3
t1 loop 4
t2 loop 0
t2 loop 1
t2 loop 2
t2 loop 3
t2 loop 4
```





#### 4.3 第二条

当一个线程访问**`某对象`**的**`synchronized方法`**或者**`synchronized代码块`**时，其他线程仍然可以访问**`该对象`**的非同步代码块。 



```java
package com.example.snailthinkdemo.Thread;

/**
 * @program: snailthink
 * @description:
 * @author: SnailThink
 * @create: 2021-03-04 14:23
 **/
public class SyncAndNoSync {

    /**
     * @param args
     */
    public static void main(String[] args) {

        class Count {

            // 含有synchronized同步块的方法
            public void synMethod() {
                synchronized(this) {
                    try {  
                        for (int i = 0; i < 5; i++) {
                            Thread.sleep(100); // 休眠100ms
                            System.out.println(Thread.currentThread().getName() + " synMethod loop " + i);  
                        }
                    } catch (InterruptedException ie) {  
                    }
                }  
            }

            // 非同步的方法
            public void nonSynMethod() {
                try {  
                    for (int i = 0; i < 5; i++) {
                        Thread.sleep(100);
                        System.out.println(Thread.currentThread().getName() + " nonSynMethod loop " + i);  
                    }
                } catch (InterruptedException ie) {  
                }
            }
        }

        final Count count = new Count();
        // 新建t1, t1会调用“count对象”的synMethod()方法
        Thread t1 = new Thread(
                new Runnable() {
                    @Override
                    public void run() {
                        count.synMethod();
                    }
                }, "t1");

        // 新建t2, t2会调用“count对象”的nonSynMethod()方法
        Thread t2 = new Thread(
                new Runnable() {
                    @Override
                    public void run() {
                        count.nonSynMethod();
                    }
                }, "t2");  

        t1.start();  // 启动t1
        t2.start();  // 启动t2
    }
}
```

 运行结果： 

```java
t1 synMethod loop 0
t2 nonSynMethod loop 0
t2 nonSynMethod loop 1
t1 synMethod loop 1
t2 nonSynMethod loop 2
t1 synMethod loop 2
t2 nonSynMethod loop 3
t1 synMethod loop 3
t1 synMethod loop 4
t2 nonSynMethod loop 4
```

结果说明：
线程t1和t2交替执行。t1会调用count对象的synMethod()方法，该方法中含有同步块；而t2则会调用count对象的nonSynMethod()方法，该方法不是同步方法。t1运行时，虽然调用synchronized(this)获取count对象的同步锁；但是并没有造成t2的阻塞，因为t2没有用到count对象的同步锁。

#### 4.4 第三条

 `第三条`:当一个线程访问**`某对象`**的**`synchronized方法`**或者**`synchronized代码块`**时，其他线程对**`该对象`**的其他的**`synchronized方法`**或者**`synchronized代码块`**的访问将被阻塞。 

```java
public class SyncAndSync {

    /**
     * @param args
     */
    public static void main(String[] args) {
        class Count {

            // 含有synchronized同步块的方法
            public void synMethod() {
                synchronized(this) {
                    try {  
                        for (int i = 0; i < 5; i++) {
                            Thread.sleep(100); // 休眠100ms
                            System.out.println(Thread.currentThread().getName() + " synMethod loop " + i);  
                        }
                    } catch (InterruptedException ie) {  
                    }
                }  
            }

            // 也包含synchronized同步块的方法
            public void synMethod2() {
                synchronized(this) {
                    try {  
                        for (int i = 0; i < 5; i++) {
                            Thread.sleep(100);
                            System.out.println(Thread.currentThread().getName() + " synMethod2 loop " + i);  
                        }
                    } catch (InterruptedException ie) {  
                    }
                }
            }
        }

        final Count count = new Count();

        // 新建t1, t1会调用“count对象”的synMethod()方法
        Thread t1 = new Thread(
                new Runnable() {
                    @Override
                    public void run() {
                        count.synMethod();
                    }
                }, "t1");

        // 新建t2, t2会调用“count对象”的synMethod2()方法
        Thread t2 = new Thread(
                new Runnable() {
                    @Override
                    public void run() {
                        count.synMethod2();
                    }
                }, "t2");  
        t1.start();  // 启动t1
        t2.start();  // 启动t2
    }

}
```

运行结果：

```java
t1 synMethod loop 0
t1 synMethod loop 1
t1 synMethod loop 2
t1 synMethod loop 3
t1 synMethod loop 4
t2 synMethod2 loop 0
t2 synMethod2 loop 1
t2 synMethod2 loop 2
t2 synMethod2 loop 3
t2 synMethod2 loop 4
```

结果说明：
t1和t2运行时都调用**synchronized(this)**，这个this是Count对象(count)，而t1和t2共用count。因此，在t1运行时，t2会被阻塞，等待t1运行释放“count对象的同步锁”，t2才能运行。 

### 5. synchronized方法和synchronized代码块

#### 5.1 概念

**synchronized方法：**是用synchronized修饰方法，这是一种粗粒度锁；这个同步方法（非static方法）无需显式指定同步监视器，同步方法的同步监视器是this，也就是调用该方法的对象。
**synchronized代码块:**  是用synchronized修饰代码块，这是一种细粒度锁。线程开始执行同步代码块之前，必须先获得对同步监视器的锁定，任何时候只能有一个线程可以获得对同步监视器的锁定，当同步代码块执行完成后，该线程会释放对同步监视器的锁定。虽然Java允许使用任何对象作为同步监视器，但同步监视器的目的就是为了阻止两个线程对同一个共享资源进行并发访问，因此通常推荐使用可能被并发访问的共享资源充当同步监视器。

#### 5.2 实例

```java
public class SnchronizedTest {

    public static void main(String[] args) {

        class Demo {

             public synchronized void synMethod() {
                    for(int i=0; i<1000000; i++)
                        ;
                }

                public void synBlock() {
                    synchronized( this ) {
                        for(int i=0; i<1000000; i++)
                            ;
                    }
                }
        }

        Demo demo = new Demo();
        long start,diff;
        start = System.currentTimeMillis();
        demo.synMethod();                                 // 调用“synchronized方法块”
        diff = System.currentTimeMillis() - start;        // 获取“时间差值”
        System.out.println("synMethod() : "+ diff);


        start = System.currentTimeMillis();              
        demo.synBlock();                                // 调用“synchronized方法块”
        diff = System.currentTimeMillis() - start;      // 获取“时间差值”
        System.out.println("synBlock()  : "+ diff);
    }
}
```

运行结果：

```java
synMethod() : 24
synBlock()  : 9
```



### 6.线程的生命周期

新建 ：从新建一个线程对象到程序start() 这个线程之间的状态，都是新建状态；

就绪 ：线程对象调用start()方法后，就处于就绪状态，等到JVM里的线程调度器的调度；

运行 ：就绪状态下的线程在获取CPU资源后就可以执行run(),此时的线程便处于运行状态，运行状态的线程可变为就绪、阻塞及死亡三种状态。

等待/阻塞/睡眠 ：在一个线程执行了sleep（睡眠）、suspend（挂起）等方法后会失去所占有的资源，从而进入 阻塞状态，在睡眠结束后可重新进入就绪状态。

终止 ：run（）方法完成后或发生其他终止条件时就会切换到终止状态。



### 多线程常见面试题

**1. 进程和线程之间有什么不同？**

一个进程是一个独立(self contained)的运行环境，它可以被看作一个程序或者一个应用。而线程是在进程中执行的一个任务。Java运行环境是一个包含了不同的类和程序的单一进程。线程可以被称为轻量级进程。线程需要较少的资源来创建和驻留在进程中，并且可以共享进程中的资源。

**2. 多线程编程的好处是什么？**

在多线程程序中，多个线程被并发的执行以提高程序的效率，CPU不会因为某个线程需要等待资源而进入空闲状态。多个线程共享堆内存(heap memory)，因此创建多个线程去执行一些任务会比创建多个进程更好。举个例子，Servlets比CGI更好，是因为Servlets支持多线程而CGI不支持。

**3. 用户线程和守护线程有什么区别？**

当我们在Java程序中创建一个线程，它就被称为用户线程。一个守护线程是在后台执行并且不会阻止JVM终止的线程。当没有用户线程在运行的时候，JVM关闭程序并且退出。一个守护线程创建的子线程依然是守护线程。

**4. 我们如何创建一个线程？**

有两种创建线程的方法：一是实现Runnable接口，然后将它传递给Thread的构造函数，创建一个Thread对象；二是直接继承Thread类。若想了解更多可以阅读这篇关于如何在Java中创建线程的文章。

**5. 有哪些不同的线程生命周期？**

当我们在Java程序中新建一个线程时，它的状态是New。当我们调用线程的start()方法时，状态被改变为Runnable。线程调度器会为Runnable线程池中的线程分配CPU时间并且讲它们的状态改变为Running。其他的线程状态还有Waiting，Blocked 和Dead。读这篇文章可以了解更多关于线程生命周期的知识。

**6. 可以直接调用Thread类的run()方法么？**

当然可以，但是如果我们调用了Thread的run()方法，它的行为就会和普通的方法一样，为了在新的线程中执行我们的代码，必须使用Thread.start()方法。

**7. 如何让正在运行的线程暂停一段时间？**

我们可以使用Thread类的Sleep()方法让线程暂停一段时间。需要注意的是，这并不会让线程终止，一旦从休眠中唤醒线程，线程的状态将会被改变为Runnable，并且根据线程调度，它将得到执行。

**8. 你对线程优先级的理解是什么？**

每一个线程都是有优先级的，一般来说，高优先级的线程在运行时会具有优先权，但这依赖于线程调度的实现，这个实现是和操作系统相关的(OS dependent)。我们可以定义线程的优先级，但是这并不能保证高优先级的线程会在低优先级的线程前执行。线程优先级是一个int变量(从1-10)，1代表最低优先级，10代表最高优先级。

**9. 什么是线程调度器(Thread Scheduler)和时间分片(Time Slicing)？**

线程调度器是一个操作系统服务，它负责为Runnable状态的线程分配CPU时间。一旦我们创建一个线程并启动它，它的执行便依赖于线程调度器的实现。时间分片是指将可用的CPU时间分配给可用的Runnable线程的过程。分配CPU时间可以基于线程优先级或者线程等待的时间。线程调度并不受到Java虚拟机控制，所以由应用程序来控制它是更好的选择（也就是说不要让你的程序依赖于线程的优先级）。

**10. 在多线程中，什么是上下文切换(context-switching)？**

上下文切换是存储和恢复CPU状态的过程，它使得线程执行能够从中断点恢复执行。上下文切换是多任务操作系统和多线程环境的基本特征。

**11. 你如何确保main()方法所在的线程是Java程序最后结束的线程？**

我们可以使用Thread类的joint()方法来确保所有程序创建的线程在main()方法退出前结束。这里有一篇文章关于Thread类的joint()方法。

**12.线程间是如何通信的？**

当线程间是可以共享资源时，线程间通信是协调它们的重要的手段。Object类中wait()\notify()\notifyAll()方法可以用于线程间通信关于资源的锁的状态。点击这里有更多关于线程wait, notify和notifyAll.

**13.为什么线程通信的方法wait(), notify()和notifyAll()被定义在Object类里？**

Java的对象中都有一个锁(monitor，也可以成为监视器) 并且wait()，notify()等方法用于等待对象的锁或者通知其他线程对象的监视器可用。在Java的线程中并没有可供任何对象使用的锁和同步器。这就是为什么这些方法是Object类的一部分，这样Java的每一个类都有用于线程间通信的基本方法

**14. 为什么wait(), notify()和notifyAll()必须在同步方法或者同步块中被调用？**

当一个线程需要调用对象的wait()方法的时候，这个线程必须拥有该对象的锁，接着它就会释放这个对象锁并进入等待状态直到其他线程调用这个对象上的notify()方法。同样的，当一个线程需要调用对象的notify()方法时，它会释放这个对象的锁，以便其他在等待的线程就可以得到这个对象锁。由于所有的这些方法都需要线程持有对象的锁，这样就只能通过同步来实现，所以他们只能在同步方法或者同步块中被调用。

**15. 为什么Thread类的sleep()和yield()方法是静态的？**

Thread类的sleep()和yield()方法将在当前正在执行的线程上运行。所以在其他处于等待状态的线程上调用这些方法是没有意义的。这就是为什么这些方法是静态的。它们可以在当前正在执行的线程中工作，并避免程序员错误的认为可以在其他非运行线程调用这些方法。

**16.如何确保线程安全？**

在Java中可以有很多方法来保证线程安全——同步，使用原子类(atomic concurrent classes)，实现并发锁，使用volatile关键字，使用不变类和线程安全类。

**17. volatile关键字在Java中有什么作用？**

当我们使用volatile关键字去修饰变量的时候，所以线程都会直接读取该变量并且不缓存它。这就确保了线程读取到的变量是同内存中是一致的。

**18. 同步方法和同步块，哪个是更好的选择？**

同步块是更好的选择，因为它不会锁住整个对象（当然你也可以让它锁住整个对象）。同步方法会锁住整个对象，哪怕这个类中有多个不相关联的同步块，这通常会导致他们停止执行并需要等待获得这个对象上的锁。

**19.如何创建守护线程？**

使用Thread类的setDaemon(true)方法可以将线程设置为守护线程，需要注意的是，需要在调用start()方法前调用这个方法，否则会抛出IllegalThreadStateException异常。

**20. 什么是ThreadLocal?**

ThreadLocal用于创建线程的本地变量，我们知道一个对象的所有线程会共享它的全局变量，所以这些变量不是线程安全的，我们可以使用同步技术。但是当我们不想使用同步的时候，我们可以选择ThreadLocal变量。

每个线程都会拥有他们自己的Thread变量，它们可以使用get()\set()方法去获取他们的默认值或者在线程内部改变他们的值。ThreadLocal实例通常是希望它们同线程状态关联起来是private static属性。在ThreadLocal例子这篇文章中你可以看到一个关于ThreadLocal的小程序。

**21. 什么是Thread Group？为什么不建议使用它？**

ThreadGroup是一个类，它的目的是提供关于线程组的信息。

ThreadGroup API比较薄弱，它并没有比Thread提供了更多的功能。它有两个主要的功能：一是获取线程组中处于活跃状态线程的列表；二是设置为线程设置未捕获异常处理器(ncaught exception handler)。但在Java 1.5中Thread类也添加了setUncaughtExceptionHandler(UncaughtExceptionHandler eh) 方法，所以ThreadGroup是已经过时的，不建议继续使用。

**22. 什么是Java线程转储(Thread Dump)，如何得到它？**

线程转储是一个JVM活动线程的列表，它对于分析系统瓶颈和死锁非常有用。有很多方法可以获取线程转储——使用Profiler，Kill -3命令，jstack工具等等。我更喜欢jstack工具，因为它容易使用并且是JDK自带的。由于它是一个基于终端的工具，所以我们可以编写一些脚本去定时的产生线程转储以待分析。读这篇文档可以了解更多关于产生线程转储的知识。

**23. 什么是死锁(Deadlock)？如何分析和避免死锁？**

死锁是指两个以上的线程永远阻塞的情况，这种情况产生至少需要两个以上的线程和两个以上的资源。

分析死锁，我们需要查看Java应用程序的线程转储。我们需要找出那些状态为BLOCKED的线程和他们等待的资源。每个资源都有一个唯一的id，用这个id我们可以找出哪些线程已经拥有了它的对象锁。

避免嵌套锁，只在需要的地方使用锁和避免无限期等待是避免死锁的通常办法，阅读这篇文章去学习如何分析死锁。

**24. 什么是Java Timer类？如何创建一个有特定时间间隔的任务？**

java.util.Timer是一个工具类，可以用于安排一个线程在未来的某个特定时间执行。Timer类可以用安排一次性任务或者周期任务。

java.util.TimerTask是一个实现了Runnable接口的抽象类，我们需要去继承这个类来创建我们自己的定时任务并使用Timer去安排它的执行。

这里有关于java Timer的例子。

**25. 什么是线程池？如何创建一个Java线程池？**

一个线程池管理了一组工作线程，同时它还包括了一个用于放置等待执行的任务的队列。

java.util.concurrent.Executors提供了一个 java.util.concurrent.Executor接口的实现用于创建线程池。线程池例子展现了如何创建和使用线程池，或者阅读ScheduledThreadPoolExecutor例子，了解如何创建一个周期任务。

