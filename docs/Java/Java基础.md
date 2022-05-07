------



# 二 Java 基础+集合+多线程+JVM

> 作者：SnailThnink。
>

## 2.1. Java 基础

### 2.1.1. 面向对象和面向过程的区别

- **面向过程** ：**面向过程性能比面向对象高。** 因为类调用时需要实例化，开销比较大，比较消耗资源，所以当性能是最重要的考量因素的时候，比如单片机、嵌入式开发、Linux/Unix 等一般采用面向过程开发。但是，**面向过程没有面向对象易维护、易复用、易扩展。**
- **面向对象** ：**面向对象易维护、易复用、易扩展。** 因为面向对象有封装、继承、多态性的特性，所以可以设计出低耦合的系统，使系统更加灵活、更加易于维护。但是，**面向对象性能比面向过程低**。


> 这个并不是根本原因，面向过程也需要分配内存，计算内存偏移量，Java 性能差的主要原因并不是因为它是面向对象语言，而是 Java 是半编译语言，最终的执行代码并不是可以直接被 CPU 执行的二进制机械码。
>
> 而面向过程语言大多都是直接编译成机械码在电脑上执行，并且其它一些面向过程的脚本语言性能也并不一定比 Java 好。

### 2.1.2. Java 语言有哪些特点?

1. 简单易学；
2. 面向对象（封装，继承，多态）；
3. 平台无关性（ Java 虚拟机实现平台无关性）；
4. 可靠性；
5. 安全性；
6. 支持多线程（ C++ 语言没有内置的多线程机制，因此必须调用操作系统的多线程功能来进行多线程程序设计，而 Java 语言却提供了多线程支持）；
7. 支持网络编程并且很方便（ Java 语言诞生本身就是为简化网络编程设计的，因此 Java 语言不仅支持网络编程而且很方便）；
8. 编译与解释并存；


### 2.1.3. 关于 JVM JDK 和 JRE 最详细通俗的解答

#### 2.1.3.1. JVM

Java 虚拟机（JVM）是运行 Java 字节码的虚拟机。JVM 有针对不同系统的特定实现（Windows，Linux，macOS），目的是使用相同的字节码，它们都会给出相同的结果。

**什么是字节码?采用字节码的好处是什么?**

> 在 Java 中，JVM 可以理解的代码就叫做`字节码`（即扩展名为 `.class` 的文件），它不面向任何特定的处理器，只面向虚拟机。Java 语言通过字节码的方式，在一定程度上解决了传统解释型语言执行效率低的问题，同时又保留了解释型语言可移植的特点。所以 Java 程序运行时比较高效，而且，由于字节码并不针对一种特定的机器，因此，Java 程序无须重新编译便可在多种不同操作系统的计算机上运行。

**Java 程序从源代码到运行一般有下面 3 步：**

![Java程序运行过程](https://my-blog-to-use.oss-cn-beijing.aliyuncs.com/Java%20%E7%A8%8B%E5%BA%8F%E8%BF%90%E8%A1%8C%E8%BF%87%E7%A8%8B.png)

我们需要格外注意的是 .class->机器码 这一步。在这一步 JVM 类加载器首先加载字节码文件，然后通过解释器逐行解释执行，这种方式的执行速度会相对比较慢。而且，有些方法和代码块是经常需要被调用的(也就是所谓的热点代码)，所以后面引进了 JIT 编译器，而 JIT 属于运行时编译。当 JIT 编译器完成第一次编译后，其会将字节码对应的机器码保存下来，下次可以直接使用。而我们知道，机器码的运行效率肯定是高于 Java 解释器的。这也解释了我们为什么经常会说 Java 是编译与解释共存的语言。

> HotSpot 采用了惰性评估(Lazy Evaluation)的做法，根据二八定律，消耗大部分系统资源的只有那一小部分的代码（热点代码），而这也就是 JIT 所需要编译的部分。JVM 会根据代码每次被执行的情况收集信息并相应地做出一些优化，因此执行的次数越多，它的速度就越快。JDK 9 引入了一种新的编译模式 AOT(Ahead of Time Compilation)，它是直接将字节码编译成机器码，这样就避免了 JIT 预热等各方面的开销。JDK 支持分层编译和 AOT 协作使用。但是 ，AOT 编译器的编译质量是肯定比不上 JIT 编译器的。

**总结：**

Java 虚拟机（JVM）是运行 Java 字节码的虚拟机。JVM 有针对不同系统的特定实现（Windows，Linux，macOS），目的是使用相同的字节码，它们都会给出相同的结果。字节码和不同系统的 JVM 实现是 Java 语言“一次编译，随处可以运行”的关键所在。

#### 2.1.3.2. JDK 和 JRE

JDK 是 Java Development Kit，它是功能齐全的 Java SDK。它拥有 JRE 所拥有的一切，还有编译器（javac）和工具（如 javadoc 和 jdb）。它能够创建和编译程序。

JRE 是 Java 运行时环境。它是运行已编译 Java 程序所需的所有内容的集合，包括 Java 虚拟机（JVM），Java 类库，java 命令和其他的一些基础构件。但是，它不能用于创建新程序。

如果你只是为了运行一下 Java 程序的话，那么你只需要安装 JRE 就可以了。如果你需要进行一些 Java 编程方面的工作，那么你就需要安装 JDK 了。但是，这不是绝对的。有时，即使您不打算在计算机上进行任何 Java 开发，仍然需要安装 JDK。例如，如果要使用 JSP 部署 Web 应用程序，那么从技术上讲，您只是在应用程序服务器中运行 Java 程序。那你为什么需要 JDK 呢？因为应用程序服务器会将 JSP 转换为 Java servlet，并且需要使用 JDK 来编译 servlet。

### 2.1.4. Oracle JDK 和 OpenJDK 的对比

可能在看这个问题之前很多人和我一样并没有接触和使用过 OpenJDK 。那么 Oracle 和 OpenJDK 之间是否存在重大差异？下面我通过收集到的一些资料，为你解答这个被很多人忽视的问题。

对于 Java 7，没什么关键的地方。OpenJDK 项目主要基于 Sun 捐赠的 HotSpot 源代码。此外，OpenJDK 被选为 Java 7 的参考实现，由 Oracle 工程师维护。关于 JVM，JDK，JRE 和 OpenJDK 之间的区别，Oracle 博客帖子在 2012 年有一个更详细的答案：

> 问：OpenJDK 存储库中的源代码与用于构建 Oracle JDK 的代码之间有什么区别？
>
> 答：非常接近 - 我们的 Oracle JDK 版本构建过程基于 OpenJDK 7 构建，只添加了几个部分，例如部署代码，其中包括 Oracle 的 Java 插件和 Java WebStart 的实现，以及一些封闭的源代码派对组件，如图形光栅化器，一些开源的第三方组件，如 Rhino，以及一些零碎的东西，如附加文档或第三方字体。展望未来，我们的目的是开源 Oracle JDK 的所有部分，除了我们考虑商业功能的部分。

**总结：**

1. Oracle JDK 大概每 6 个月发一次主要版本，而 OpenJDK 版本大概每三个月发布一次。但这不是固定的，我觉得了解这个没啥用处。详情参见：https://blogs.oracle.com/java-platform-group/update-and-faq-on-the-java-se-release-cadence。
2. OpenJDK 是一个参考模型并且是完全开源的，而 Oracle JDK 是 OpenJDK 的一个实现，并不是完全开源的；
3. Oracle JDK 比 OpenJDK 更稳定。OpenJDK 和 Oracle JDK 的代码几乎相同，但 Oracle JDK 有更多的类和一些错误修复。因此，如果您想开发企业/商业软件，我建议您选择 Oracle JDK，因为它经过了彻底的测试和稳定。某些情况下，有些人提到在使用 OpenJDK 可能会遇到了许多应用程序崩溃的问题，但是，只需切换到 Oracle JDK 就可以解决问题；
4. 在响应性和 JVM 性能方面，Oracle JDK 与 OpenJDK 相比提供了更好的性能；
5. Oracle JDK 不会为即将发布的版本提供长期支持，用户每次都必须通过更新到最新版本获得支持来获取最新版本；
6. Oracle JDK 根据二进制代码许可协议获得许可，而 OpenJDK 根据 GPL v2 许可获得许可。

### 2.1.5. 公众号

如果大家想要实时关注我更新的文章以及分享的干货的话，可以关注我的公众号。

![](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220507200900.jpg)


## 2.2.八大排序算法

### 2.2.1 冒泡排序法

1. 从第一个元素开始，比较相邻的两个元素。如果第一个比第二个大，则进行交换。
2. 轮到下一组相邻元素，执行同样的比较操作，再找下一组，直到没有相邻元素可比较为止，此时最后的元素应是最大的数。
3. 除了每次排序得到的最后一个元素，对剩余元素重复以上步骤，直到没有任何一对元素需要比较为止。


![20201013163804124](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220506093912.gif)


```java
public void bubbleSortOpt(int[] arr) {

	if(arr == null) {
        throw new NullPoniterException();
    }
    if(arr.length < 2) {
        return;
    }
    int temp = 0;
    for(int i = 0; i < arr.length - 1; i++) {
        for(int j = 0; j < arr.length - i - 1; j++) {
            if(arr[j] > arr[j + 1]) {
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}
```


### 2.2.2 快速排序法

快速排序的思想很简单，就是先把待排序的数组拆成左右两个区间，左边都比中间的基准数小，右边都比基准数大。接着左右两边各自再做同样的操作，完成后再拆分再继续，一直到各区间只有一个数为止.

举个例子，现在我要排序 4、9、5、1、2、6 这个数组。一般取首位的 4 为基准数，第一次排序的结果是：

2、1、4、5、9、6 

以 4 为分界点，对 2、1、4 和 5、9、6 各自排序，得到：

1、2、4、5、9、6

不用管左边的 1、2、4 了，将 5、9、6 拆成 5 和 9、6，再排序，至此结果为：

1、2、4、5、6、9

为什么把快排划到交换排序的范畴呢？因为元素的移动也是靠交换位置来实现的。算法的实现需要用到递归（拆分区间之后再对每个区间作同样的操作）


![在这里插入图片描述](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220506094746.gif)


```java
public void quicksort(int[] arr, int start, int end) {

	if(start < end) {
        // 把数组中的首位数字作为基准数
        int stard = arr[start];
        // 记录需要排序的下标
        int low = start;
        int high = end;
        // 循环找到比基准数大的数和比基准数小的数
        while(low < high) {
            // 右边的数字比基准数大
            while(low < high && arr[high] >= stard) {
                high--;
            }
            // 使用右边的数替换左边的数
            arr[low] = arr[high];
            // 左边的数字比基准数小
            while(low < high && arr[low] <= stard) {
                low++;
            }
            // 使用左边的数替换右边的数
            arr[high] = arr[low];
        }
        // 把标准值赋给下标重合的位置
        arr[low] = stard;
        // 处理所有小的数字
        quickSort(arr, start, low);
        // 处理所有大的数字
        quickSort(arr, low + 1, end);
    }
}
```

### 2.2.3  插入排序

插入排序是一种简单的排序方法，其基本思想是将一个记录插入到已经排好序的有序表中，使得被插入数的序列同样是有序的。按照此法对所有元素进行插入，直到整个序列排为有序的过程。直接插入排序就是插入排序的粗暴实现。对于一个序列，选定一个下标，认为在这个下标之前的元素都是有序的。将下标所在的元素插入到其之前的序列中。接着再选取这个下标的后一个元素，继续重复操作。直到最后一个元素完成插入为止。我们一般从序列的第二个元素开始操作。

![在这里插入图片描述](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220506094953.gif)


```java
public void insertSort(int[] arr) {
    // 遍历所有数字
	for(int i = 1; i < arr.length - 1; i++) {
        // 当前数字比前一个数字小
        if(arr[i] < arr[i - 1]) {
            int j;
            // 把当前遍历的数字保存起来
            int temp = arr[i];
            for(j = i - 1; j >= 0 && arr[j] > temp; j--) {
                // 前一个数字赋给后一个数字
                arr[j + 1] = arr[j];
            }
            // 把临时变量赋给不满足条件的后一个元素
            arr[j + 1] = temp;
        }
    }
}
```


### 2.2.4  希尔排序


某些情况下直接插入排序的效率极低。比如一个已经有序的升序数组，这时再插入一个比最小值还要小的数，也就意味着被插入的数要和数组所有元素比较一次。我们需要对直接插入排序进行改进。怎么改进呢？前面提过，插入排序对已经排好序的数组操作时，效率很高。因此我们可以试着先将数组变为一个相对有序的数组，然后再做插入排序。

希尔排序能实现这个目的。希尔排序把序列按下标的一定增量（步长）分组，对每组分别使用插入排序。随着增量（步长）减少，一直到一，算法结束，整个序列变为有序。因此希尔排序又称缩小增量排序。

一般来说，初次取序列的一半为增量，以后每次减半，直到增量为一。


![在这里插入图片描述](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220506095125.jpeg)


```java
public void shellSort(int[] arr) {
    // gap 为步长，每次减为原来的一半。
    for (int gap = arr.length / 2; gap > 0; gap /= 2) {
        // 对每一组都执行直接插入排序
        for (int i = 0 ;i < gap; i++) {
            // 对本组数据执行直接插入排序
            for (int j = i + gap; j < arr.length; j += gap) {
                // 如果 a[j] < a[j-gap]，则寻找 a[j] 位置，并将后面数据的位置都后移
                if (arr[j] < arr[j - gap]) {
                    int k;
                    int temp = arr[j];
                    for (k = j - gap; k >= 0 && arr[k] > temp; k -= gap) {
                        arr[k + gap] = arr[k];
                    }
                    arr[k + gap] = temp;
                }
            }
        }
    }
}

```
### 2.2.5  简单选择排序


选择排序思想的暴力实现，每一趟从未排序的区间找到一个最小元素，并放到第一位，直到全部区间有序为止。


![在这里插入图片描述](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220506095250.gif)


```java
public static void selectSort(int[] arr) {
    // 遍历所有的数
    for (int i = 0; i < arr.length; i++) {
        int minIndex = i;
        // 把当前遍历的数和后面所有的数进行比较，并记录下最小的数的下标
        for (int j = i + 1; j < arr.length; j++) {
            if (arr[j] < arr[minIndex]) {
                // 记录最小的数的下标
                minIndex = j;
            }
        }
        // 如果最小的数和当前遍历的下标不一致，则交换
        if (i != minIndex) {
            int temp = arr[i];
            arr[i] = arr[minIndex];
            arr[minIndex] = temp;
        }
    }
}
```


### 2.2.6  堆排序


我们知道，对于任何一个数组都可以看成一颗完全二叉树，不了解这一方面的同学可以去看这篇博客。堆是具有以下性质的完全二叉树：每个结点的值都大于或等于其左右孩子结点的值，称为大顶堆；或者每个结点的值都小于或等于其左右孩子结点的值，称为小顶堆。如下图：

![image-20220506095401752](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220506095401.png)

像上图的大顶堆，映射为数组，就是 [50, 45, 40, 20, 25, 35, 30, 10, 15]。可以发现第一个下标的元素就是最大值，将其与末尾元素交换，则末尾元素就是最大值。所以堆排序的思想可以归纳为以下两步：

根据初始数组构造堆
每次交换第一个和最后一个元素，然后将除最后一个元素以外的其他元素重新调整为大顶堆.重复以上两个步骤，没有元素可操作，就完成排序了。

我们需要把一个普通数组转换为大顶堆，调整的起始点是最后一个非叶子结点，然后从左至右，从下至上，继续调整其他非叶子结点，直到根结点为止。

![在这里插入图片描述](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220506095427.gif)



```java
/**
 * 转化为大顶堆
 * @param arr 待转化的数组
 * @param size 待调整的区间长度
 * @param index 结点下标
 */
public void maxHeap(int[] arr, int size, int index) {
    // 左子结点
    int leftNode = 2 * index + 1;
    // 右子结点
    int rightNode = 2 * index + 2;
    int max = index;
    // 和两个子结点分别对比，找出最大的结点
    if (leftNode < size && arr[leftNode] > arr[max]) {
        max = leftNode;
    }
    if (rightNode < size && arr[rightNode] > arr[max]) {
        max = rightNode;
    }
    // 交换位置
    if (max != index) {
        int temp = arr[index];
        arr[index] = arr[max];
        arr[max] = temp;
        // 因为交换位置后有可能使子树不满足大顶堆条件，所以要对子树进行调整
        maxHeap(arr, size, max);
    }
}

/**
 * 堆排序
 * @param arr 待排序的整型数组
 */
public static void heapSort(int[] arr) {
    // 开始位置是最后一个非叶子结点，即最后一个结点的父结点
    int start = (arr.length - 1) / 2;
    // 调整为大顶堆
    for (int i = start; i >= 0; i--) {
        SortTools.maxHeap(arr, arr.length, i);
    }
    // 先把数组中第 0 个位置的数和堆中最后一个数交换位置，再把前面的处理为大顶堆
    for (int i = arr.length - 1; i > 0; i--) {
        int temp = arr[0];
        arr[0] = arr[i];
        arr[i] = temp;
        maxHeap(arr, i, 0);
    }
}

```


### 2.2.7  堆排序



归并排序是建立在归并操作上的一种有效，稳定的排序算法。该算法采用分治法的思想，是一个非常典型的应用。归并排序的思路如下：

1. 将 n 个元素分成两个各含 n/2 个元素的子序列

2. 借助递归，两个子序列分别继续进行第一步操作，直到不可再分为止

3. 此时每一层递归都有两个子序列，再将其合并，作为一个有序的子序列返回上一层，再继续合并，全部完成之后得到的就是一个有序的序列

   

   关键在于两个子序列应该如何合并。假设两个子序列各自都是有序的，那么合并步骤就是：

1. 创建一个用于存放结果的临时数组，其长度是两个子序列合并后的长度
2. 设定两个指针，最初位置分别为两个已经排序序列的起始位置
3. 比较两个指针所指向的元素，选择相对小的元素放入临时数组，并移动指针到下一位置
4. 重复步骤 3 直到某一指针达到序列尾
5. 将另一序列剩下的所有元素直接复制到合并序列尾

![在这里插入图片描述](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220506095607.gif)



```java
/**
 * 合并数组
 */
public static void merge(int[] arr, int low, int middle, int high) {
    // 用于存储归并后的临时数组
    int[] temp = new int[high - low + 1];
    // 记录第一个数组中需要遍历的下标
    int i = low;
    // 记录第二个数组中需要遍历的下标
    int j = middle + 1;
    // 记录在临时数组中存放的下标
    int index = 0;
    // 遍历两个数组，取出小的数字，放入临时数组中
    while (i <= middle && j <= high) {
        // 第一个数组的数据更小
        if (arr[i] <= arr[j]) {
            // 把更小的数据放入临时数组中
            temp[index] = arr[i];
            // 下标向后移动一位
            i++;
        } else {
            temp[index] = arr[j];
            j++;
        }
        index++;
    }
    // 处理剩余未比较的数据
    while (i <= middle) {
        temp[index] = arr[i];
        i++;
        index++;
    }
    while (j <= high) {
        temp[index] = arr[j];
        j++;
        index++;
    }
    // 把临时数组中的数据重新放入原数组
    for (int k = 0; k < temp.length; k++) {
        arr[k + low] = temp[k];
    }
}

/**
 * 归并排序
 */
public static void mergeSort(int[] arr, int low, int high) {
    int middle = (high + low) / 2;
    if (low < high) {
        // 处理左边数组
        mergeSort(arr, low, middle);
        // 处理右边数组
        mergeSort(arr, middle + 1, high);
        // 归并
        merge(arr, low, middle, high);
    }
}

```

### 2.2.8  基数排序


```java
/**
 * 基数排序
 */
public static void radixSort(int[] arr) {
    // 存放数组中的最大数字
    int max = Integer.MIN_VALUE;
    for (int value : arr) {
        if (value > max) {
            max = value;
        }
    }
    // 计算最大数字是几位数
    int maxLength = (max + "").length();
    // 用于临时存储数据
    int[][] temp = new int[10][arr.length];
    // 用于记录在 temp 中相应的下标存放数字的数量
    int[] counts = new int[10];
    // 根据最大长度的数决定比较次数
    for (int i = 0, n = 1; i < maxLength; i++, n *= 10) {
        // 每一个数字分别计算余数
        for (int j = 0; j < arr.length; j++) {
            // 计算余数
            int remainder = arr[j] / n % 10;
            // 把当前遍历的数据放到指定的数组中
            temp[remainder][counts[remainder]] = arr[j];
            // 记录数量
            counts[remainder]++;
        }
        // 记录取的元素需要放的位置
        int index = 0;
        // 把数字取出来
        for (int k = 0; k < counts.length; k++) {
            // 记录数量的数组中当前余数记录的数量不为 0
            if (counts[k] != 0) {
                // 循环取出元素
                for (int l = 0; l < counts[k]; l++) {
                    arr[index] = temp[k][l];
                    // 记录下一个位置
                    index++;
                }
                // 把数量置空
                counts[k] = 0;
            }
        }
    }
}

```
### 2.2.9  总结

| 排序法       | 最好情形 | 平均时间 | 最差情形 | 稳定度 | 空间复杂度  |
| ------------ | -------- | -------- | -------- | ------ | ----------- |
| 冒泡排序     | O(n)     | O(n^2^)  | O(n^2^)  | 稳定   | O(1)        |
| 快速排序     | O(nlogn) | O(nlogn) | O(n^2^)  | 不稳定 | O(nlogn)    |
| 直接插入排序 | O(n)     | O(n^2^)  | O(n^2^)  | 稳定   | O(1)        |
| 希尔排序     |          |          |          | 不稳定 | O(1)        |
| 直接选择排序 | O(n^2^)  | O(n^2^)  | O(n^2^)  | 不稳定 | O(1)        |
| 堆排序       | O(nlogn) | O(nlogn) | O(nlogn) | 不稳定 | O(1)        |
| 归并排序     | O(nlogn) | O(nlogn) | O(nlogn) | 稳定   | O(n + logn) |

参考: https://blog.csdn.net/CSDN_handsome/article/details/109055036