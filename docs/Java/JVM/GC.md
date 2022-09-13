### GC参数说明

```java
通用GC参数

-Xmn：年轻代大小   -Xms：堆初始大小  -Xmx：堆最大大小  -Xss：栈大小

-XX:+UseTlab：使用tlab，默认打开，涉及到对象分配问题

-XX:+PrintTlab：打印tlab使用情况

-XX:+TlabSize：设置Tlab大小

-XX:+DisabledExplictGC：java代码中的System.gc()不再生效，防止代码中误写，导致频繁触动GC，默认不起用。

-XX:+PrintGC(+PrintGCDetails/+PrintGCTimeStamps)打印GC信息(打印GC详细信息/打印GC执行时间)

-XX:+PrintHeapAtGC打印GC时的堆信息

-XX:+PrintGCApplicationConcurrentTime 打印应用程序的时间

-XX:+PrintGCApplicationStopedTime 打印应用程序暂停时间

-XX:+PrintReferenceGC 打印回收多少种引用类型的引用

-verboss:class 类加载详细过程

-XX:+PrintVMOptions 打印JVM运行参数

-XX:+PrintFlagsFinal(+PrintFlagsInitial)  -version | grep 查找想要了解的命令，很重要

-X:loggc:/opt/gc/log/path  输出gc信息到文件

-XX:MaxTenuringThreshold  设置gc升到年龄，最大值为15
parallel常用参数

-XX:PreTenureSizeThreshold 多大的对象判定为大对象，直接晋升老年代

-XX:+ParallelGCThreads 用于并发垃圾回收的线程

-XX:+UseAdaptiveSizePolicy 自动选择各区比例
CMS常用参数

-XX:+UseConcMarkSweepGC 使用CMS垃圾回收器

-XX:parallelCMSThreads CMS线程数量

-XX:CMSInitiatingOccupancyFraction 占用多少比例的老年代时开始CMS回收，默认值68%，如果频繁发生serial old，适当调小该比例，降低FGC频率

-XX:+UseCMSCompactAtFullCollection 进行压缩整理

-XX:CMSFullGCBeforeCompaction 多少次FGC以后进行压缩整理

-XX:+CMSClassUnloadingEnabled 回收永久代

-XX:+CMSInitiatingPermOccupancyFraction 达到什么比例时进行永久代回收

GCTimeTatio 设置GC时间占用程序运行时间的百分比，该参数只能是尽量达到该百分比，不是肯定达到

-XX:MaxGCPauseMills GCt停顿时间，该参数也是尽量达到，而不是肯定达到
G1常用参数

-XX:+UseG1 使用G1垃圾回收器

-XX:MaxGCPauseMills GCt停顿时间，该参数也是尽量达到，G1会调整yong区的块数来达到这个值

-XX:+G1HeapRegionSize 分区大小，范围为1M~32M，必须是2的n次幂，size越大，GC回收间隔越大，但是GC所用时间越长

G1NewSizePercent 新生代所占最小比例，默认5%

G1MaxNewSizePercent 新生代所占最大比例，默认60%

GCTimeRatio GC时间比例，此值为建议值，G1会调整堆大小来尽量达到这个值

ConcGCThreads GC线程数量

InitiatingHeapOccupancyPercent 启动G1的堆空间占用比例
```