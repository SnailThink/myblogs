
## 一、ArrayList

**ArrayList** 底层数据结构为 **动态数组** ，所以我们可以将之称为数组队列。 ArrayList 的依赖关系：

```java
public class ArrayList<E> extends AbstractList<E>
    	implements List<E>, RandomAccess, Cloneable, java.io.Serializable
```



![img](https://user-gold-cdn.xitu.io/2018/5/4/1632a41105e95860?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



从依赖关系可以看出，ArrayList 首先是一个列表，其次，他具有列表的相关功能，支持快速（固定时间）定位资源位置。可以进行拷贝操作，同时支持序列化。这里我们需要重点关注的是 AbstractLit 以及 RandomAccess 。这个类，一个是定义了列表的基本属性，以及确定我们列表中的常规动作。而RandomAccess 主要是提供了快速定位资源位置的功能。

### 1.1、ArrayList 成员变量

```java
  /**
     * Default initial capacity.数组默认大小
     */
    private static final int DEFAULT_CAPACITY = 10;

    /**
     空队列
     */
    private static final Object[] EMPTY_ELEMENTDATA = {};

    /**
        如果使用默认构造方法，则默认对象内容是该值
     */
    private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = {};

    /**
        用于存储数据
     */
    transient Object[] elementData; 

     // 当前队列有效数据长度
      private int size;

     // 数组最大值
     private static final int MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8;
```

在ArrayList 的源码中，主要有上述的几个成员变量：

- elementData ： 动态数组，也就是我们存储数据的核心数组
- DEFAULT_CAPACITY：数组默认长度，在调用默认构造器的时候会有介绍
- size：记录有效数据长度，size（）方法直接返回该值
- MAX_ARRAY_SIZE：数组最大长度，如果扩容超过该值，则设置长度为 Integer.MAX_VALUE

拓展思考： **EMPTY_ELEMENTDATA** 和 **DEFAULTCAPACITY_EMPTY_ELEMENTDATA** 都是两个空的数组对象，他们到底有什么区别呢？我们在下一节讲解构造方法的时候，会做详细对比。

### 1.2、构造方法

**ArrayList** 中提供了三种构造方法：

- ArrayList()
- ArrayList(int initialCapacity)
- ArrayList（Collection c）

根据构造器的不同，构造方法会有所区别。我们在平常开发中，可能会出现在默认构造器内部调用了 ArrayList（int capacity） 这种方式，但是ArrayList 中对于**不同的构造器的内部实现都有所区别**，主要跟上述提到的成员变量有关。

#### 1.2.1 ArrayList（）

在源码给出的注释中这样描述：构造一个初始容量为十的空列表

```java
    /**
     * Constructs an empty list with an initial capacity of ten.
     */
    public ArrayList() {
        this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;
    }
```

从源码可以看到，它只是将 **elementData** 指向了 **DEFAULTCAPACITY_EMPTY_ELEMENTDATA** 的存储地址，而 **DEFAULTCAPACITY_EMPTY_ELEMENTDATA** 其实是一个空的数组对象，那么它为什么说创建一个默认大小为10 的列表呢？

或者我们从别的角度思考一下，如果这个空的数组，需要添加元素，会怎么样？

```java
    public boolean add(E e) {
        ensureCapacityInternal(size + 1);  //确认内部容量
        elementData[size++] = e;
        return true;
    }
    
    private void ensureCapacityInternal(int minCapacity) {
        // 如果elementData 指向的是 DEFAULTCAPACITY_EMPTY_ELEMENTDATA 的地址
        if (elementData == DEFAULTCAPACITY_EMPTY_ELEMENTDATA) {
            设置默认大小 为DEFAULT_CAPACITY
            minCapacity = Math.max(DEFAULT_CAPACITY, minCapacity);
        }
        //确定实际容量
        ensureExplicitCapacity(minCapacity);
    }
    
    private void ensureExplicitCapacity(int minCapacity) {
        modCount++;

        // 如果超出了容量，进行扩展
        if (minCapacity - elementData.length > 0)
            grow(minCapacity);
    }
    
    private void grow(int minCapacity) {
        // overflow-conscious code
        int oldCapacity = elementData.length;
        int newCapacity = oldCapacity + (oldCapacity >> 1);
        if (newCapacity - minCapacity < 0)
            newCapacity = minCapacity;
        if (newCapacity - MAX_ARRAY_SIZE > 0)
            newCapacity = hugeCapacity(minCapacity);
        // minCapacity is usually close to size, so this is a win:
        elementData = Arrays.copyOf(elementData, newCapacity);
    }
```

上述代码块比较长，这里做个简单的总结：

1、add（E e）：添加元素，首先会判断 elementData 数组的长度，然后设置值

2、ensureCapacityInternal（int minCapacity）：判断 element 是否为空，如果是，则设置默认数组长度

3、ensureExplicitCapacity（int minCapacity）：判断预期增长数组长度是否超过当前容量，如果过超过，则调用grow（）

4、grow(int minCapacity)：对数组进行扩展

```
回到刚才的问题：为什么说创建一个默认大小为10 的列表呢？或许你已经找到答案了～
```

#### 1.2.2 ArrayList(int initialCapacity)

根据指定大小初始化 ArrayList 中的数组大小，如果默认值大于0，根据参数进行初始化，如果等于0，指向EMPTY_ELEMENTDATA 内存地址（与上述默认构造器用法相似）。如果小于0，则抛出IllegalArgumentException 异常。

```java
public ArrayList(int initialCapacity) {
        if (initialCapacity > 0) {
            this.elementData = new Object[initialCapacity];
        } else if (initialCapacity == 0) {
            this.elementData = EMPTY_ELEMENTDATA;
        } else {
            throw new IllegalArgumentException("Illegal Capacity: "+
                                               initialCapacity);
        }
    }
```

拓展思考：为什么这里是用 **EMPTY_ELEMENTDATA** 而不是跟默认构造器一样使用 **DEFAULTCAPACITY_EMPTY_ELEMENTDATA** ？有兴趣的童鞋可以自己县思考，经过思考的知识，才是你的～

#### 1.2.3 ArrayList（Collection c）

将Collection<T>  c 中保存的数据，首先转换成数组形式（toArray（）方法），然后判断当前数组长度是否为0，为 0 则只想默认数组（EMPTY_ELEMENTDATA）；否则进行数据拷贝。

```java
    public ArrayList(Collection<? extends E> c) {
        elementData = c.toArray();
        if ((size = elementData.length) != 0) {
            // c.toArray might (incorrectly) not return Object[] (see 6260652)
            if (elementData.getClass() != Object[].class)
                elementData = Arrays.copyOf(elementData, size, Object[].class);
        } else {
            // replace with empty array.
            this.elementData = EMPTY_ELEMENTDATA;
        }
    }
```

#### 1.2.4 总结

上述的三个构造方法可以看出，其实每个构造器内部做的事情都不一样，特别是默认构造器与 ArrayList(int initialCapacity) 这两个构造器直接的区别 ，我们是需要做一些区别的。

- ArrayList（）：指向 **DEFAULTCAPACITY_EMPTY_ELEMENTDATA**，当列表使用的时候，才会进行初始化，会通过判断是不是 DEFAULTCAPACITY_EMPTY_ELEMENTDATA 这个对象而设置数组默认大小。
- ArrayList(int initialCapacity)：当 initialCapacity >0 的时候，设置该长度。如果 initialCapacity =0，则指向 **EMPTY_ELEMENTDATA** 在使用的时候，并不会设置默认数组长度 。

因此 DEFAULTCAPACITY_EMPTY_ELEMENTDATA 与 EMPTY_ELEMENTDATA 的本质区别就在于，会不会设置默认的数组长度。

### 1.3、添加方法（Add）

ArrayList 添加了四种添加方法：

- add(E  element)
- add(int i , E element)
- addAll(Collection<? extends E> c)
- addAll(int index, Collection<? extends E> c)

#### 1.3.1 add(E element)

首先看add（T t）的源码：

```java
  public boolean add(E e) {
        ensureCapacityInternal(size + 1);  // 元素个数加一，并且确认数组长度是否足够 
        elementData[size++] = e;		//在列表最后一个元素后添加数据。
        return true;
    }
```

结合默认构造器或其他构造器中，如果默认数组为空，则会在 ensureCapacityInternal（）方法调用的时候进行数组初始化。这就是为什么默认构造器调用的时候，我们创建的是一个空数组，但是在注释里却介绍为 长度为10的数组。

#### 1.3.2 add（int i , T t）

```java
   public void add(int index, E element) {
    // 判断index 是否有效
        rangeCheckForAdd(index);
    // 计数+1，并确认当前数组长度是否足够
        ensureCapacityInternal(size + 1);  // Increments modCount!!
        System.arraycopy(elementData, index, elementData, index + 1,
                         size - index); //将index 后面的数据都往后移一位
        elementData[index] = element; //设置目标数据
        size++;
    }
```

这个方法其实和上面的add类似，该方法可以按照元素的位置，指定位置插入元素，具体的执行逻辑如下：

1）确保数插入的位置小于等于当前数组长度，并且不小于0，否则抛出异常

2）确保数组已使用长度（size）加1之后足够存下 下一个数据

3）修改次数（modCount）标识自增1，如果当前数组已使用长度（size）加1后的大于当前的数组长度，则调用grow方法，增长数组

4）grow方法会将当前数组的长度变为原来容量的1.5倍。

5）确保有足够的容量之后，使用System.arraycopy 将需要插入的位置（index）后面的元素统统往后移动一位。

6）将新的数据内容存放到数组的指定位置（index）上

#### 1.3.3 addAll(Collection<? extends E> c)

```java
    public boolean addAll(Collection<? extends E> c) {
        Object[] a = c.toArray();
        int numNew = a.length;
        ensureCapacityInternal(size + numNew);  // Increments modCount
        System.arraycopy(a, 0, elementData, size, numNew);
        size += numNew;
        return numNew != 0;
    }
```

addAll() 方法，通过将collection 中的数据转换成 Array[] 然后添加到elementData 数组，从而完成整个集合数据的添加。在整体上没有什么特别之初，这里的collection 可能会抛出控制异常 NullPointerException  需要注意一下。

#### 1.3.4 addAll(int index，Collection<? extends E> c)

```java
 public boolean addAll(int index, Collection<? extends E> c) {
        rangeCheckForAdd(index);

        Object[] a = c.toArray();
        int numNew = a.length;
        ensureCapacityInternal(size + numNew);  // Increments modCount

        int numMoved = size - index;
        if (numMoved > 0)
            System.arraycopy(elementData, index, elementData, index + numNew,
                             numMoved);

        System.arraycopy(a, 0, elementData, index, numNew);
        size += numNew;
        return numNew != 0;
    }
```

与上述方法相比，这里主要多了两个步骤，判断添加数据的位置是不是在末尾，如果在中间，则需要先将数据向后移动 collection 长度 的位置。

### 1.4、删除方法（Remove）

ArrayList 中提供了 五种删除数据的方式：

- remove（int i）
- remove（E element）
- removeRange（int start,int end）
- clear（）
- removeAll（Collection c）

#### 1.4.1、remove（int i）:

删除数据并不会更改数组的长度，只会将数据重数组种移除，如果目标没有其他有效引用，则在GC 时会进行回收。

```java
public E remove(int index) {
        rangeCheck(index); // 判断索引是否有效
        modCount++;
        E oldValue = elementData(index);  // 获取对应数据
        int numMoved = size - index - 1;  // 判断删除数据位置
        if (numMoved > 0) //如果删除数据不是最后一位，则需要移动数组
            System.arraycopy(elementData, index+1, elementData, index,
                             numMoved);
        elementData[--size] = null; // 让指针最后指向空，进行垃圾回收
        return oldValue;
    }
```

#### 1.4.2、remove（E element）:

这种方式，会在内部进行 AccessRandom 方式遍历数组，当匹配到数据跟 Object 相等，则调用 fastRemove（） 进行删除

```java
public boolean remove(Object o) {
        if (o == null) {
            for (int index = 0; index < size; index++)
                if (elementData[index] == null) {
                    fastRemove(index);
                    return true;
                }
        } else {
            for (int index = 0; index < size; index++)
                if (o.equals(elementData[index])) {
                    fastRemove(index);
                    return true;
                }
        }
        return false;
    }
```

fastRemove( ): fastRemove 操作与上述的根据下标进行删除其实是一致的。

```java
   private void fastRemove(int index) {
        modCount++;
        int numMoved = size - index - 1;
        if (numMoved > 0)
            System.arraycopy(elementData, index+1, elementData, index,
                             numMoved);
        elementData[--size] = null; // clear to let GC do its work
    }
```

#### 1.4.3、removeRange（int fromIndex, int toIndex）

该方法主要删除了在范围内的数据，通过System.arraycopy  对整部分的数据进行覆盖即可。

```java
    protected void removeRange(int fromIndex, int toIndex) {
        modCount++;
        int numMoved = size - toIndex;
        System.arraycopy(elementData, toIndex, elementData, fromIndex,
                         numMoved);

        // clear to let GC do its work
        int newSize = size - (toIndex-fromIndex);
        for (int i = newSize; i < size; i++) {
            elementData[i] = null;
        }
        size = newSize;
    }
```

#### 1.4.4、clear（）

直接将整个数组设置为 null ，这里不做细述。

#### 1.4.5、removeAll（Collection c）

主要通过调用：

```java
    private boolean batchRemove(Collection<?> c, boolean complement) {
        //获取数组指针
        final Object[] elementData = this.elementData;
        int r = 0, w = 0;
        boolean modified = false;
        try {
            for (; r < size; r++)
                //根据 complement 进行判断删除或留下
                if (c.contains(elementData[r]) == complement)
                    elementData[w++] = elementData[r];
        } finally {
            // 进行数据整理
            if (r != size) {
                System.arraycopy(elementData, r,
                                 elementData, w,
                                 size - r);
                w += size - r;
            }
            if (w != size) {
                // clear to let GC do its work
                for (int i = w; i < size; i++)
                    elementData[i] = null;
                modCount += size - w;
                size = w;
                modified = true;
            }
        }
        return modified;
    }
```

在retainAll（Collection c）也有调用，主要作用分别为，删除这个集合中所包含的元素和留下这个集合中所包含的元素。

### 拓展思考

清楚ArrayList 的删除方法后，再结合我们常用的删除方式，进行思考，到底哪些步骤会出问题，我们通常会选择变量列表，如果匹配，则删除。我们遍历的方式有以下几种：

- foreach()：主要出现 ConcurrentModificationException 异常
- for(int i;**;i++)：主要出现相同数据跳过，可参考：[blog.csdn.net/sun_flower7…](https://blog.csdn.net/sun_flower77/article/details/78008491)
- Iterator 遍历：主要出现 **ConcurrentModificationException**  可参考：[www.cnblogs.com/dolphin0520…](https://www.cnblogs.com/dolphin0520/p/3933551.html)

避免 ConcurrentModificationException 的有效办法是使用 Concurrent包下面的 CopyOnWriteArrayList ，后续会进行详细分析

### 1.5、toArray（）

ArrayList提供了2个toArray()函数：

- Object[] toArray()
- T[] toArray(T[] contents)

调用 toArray() 函数会抛出“java.lang.ClassCastException”异常，但是调用 toArray(T[] contents) 能正常返回 T[]。

toArray() 会抛出异常是因为 toArray() 返回的是 Object[] 数组，将 Object[] 转换为其它类型(如如，将Object[]转换为的Integer[])则会抛出“java.lang.ClassCastException”异常，因为Java不支持向下转型。

toArray（） 源码：

```java
    public Object[] toArray() {
        return Arrays.copyOf(elementData, size);
    }
```

### 1.6、subList（）

如果我们在开发过程中有需要获取集合中的某一部分的数据进行操作，我们可以通过使用SubList（） 方法来进行获取，这里会创建ArrayList 的一个内部类 SubList（）。

SubList 继承了 AbstractList，并且实现了大部分的 AbstractList 动作。

需要注意的是，SubList 返回的集合中的某一部分数据，是会与原集合相关联。即当我们对Sublist 进行操作的时候，其实还是会影响到原始集合。 我们来看一下 Sublist 中的 add 方法：

```java
  	public void add(int index, E e) {
        rangeCheckForAdd(index);
            checkForComodification();
            parent.add(parentOffset + index, e);
            this.modCount = parent.modCount;
            this.size++;
      }
```

可以看到，Sublist 中的 加操作，其实还是调用了 parent（也就是原集合） 中的加操作。所以在使用subList方法时，一定要想清楚，是否需要对子集合进行修改元素而不影响原有的list集合。

## 总结

ArrayList总体来说比较简单，不过ArrayList还有以下一些特点：

- ArrayList自己实现了序列化和反序列化的方法，因为它自己实现了 private void writeObject(java.io.ObjectOutputStream s)和 private void readObject(java.io.ObjectInputStream s) 方法
- ArrayList基于数组方式实现，无容量的限制（会扩容）
- 添加元素时可能要扩容（所以最好预判一下），删除元素时不会减少容量（若希望减少容量，trimToSize()），删除元素时，将删除掉的位置元素置为null，下次gc就会回收这些元素所占的内存空间。
- 线程不安全
- add(int index, E element)：添加元素到数组中指定位置的时候，需要将该位置及其后边所有的元素都整块向后复制一位
- get(int index)：获取指定位置上的元素时，可以通过索引直接获取（O(1)）
- remove(Object o)需要遍历数组
- remove(int index)不需要遍历数组，只需判断index是否符合条件即可，效率比remove(Object o)高
- contains(E)需要遍历数组
- 使用iterator遍历可能会引发多线程异常

### 拓展思考

- 拓展思考1、RandomAccess 接口是如何实现快速定位资源的？
- 拓展思考2、EMPTY_ELEMENTDATA 与 DEFAULTCAPACITY_EMPTY_ELEMENTDATA的作用？
- 拓展思考3、remove 方法存在的坑？
- 拓展思考4:、ArrayList为什么不是线程安全？

## 二、Vector

在介绍Vector 的时候，人们常说：

```java
底层实现与 ArrayList 类似，不过Vector 是线程安全的，而ArrayList 不是。
```

那么这句话定义的到底对不对呢？我们接下来结合上一篇文章进行分析：

[Java 集合系列1、细思极恐之ArrayList](https://juejin.im/post/5aec1863518825671c0e6c75)



![Vector 依赖关系](https://user-gold-cdn.xitu.io/2018/5/5/16330ecb7a653419?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



```java
public class Vector<E>
    extends AbstractList<E>
    implements List<E>, RandomAccess, Cloneable, java.io.Serializable
```

**Vector** 是一个矢量队列，它的依赖关系跟 **ArrayList**  是一致的，因此它具有一下功能：

- 1、**Serializable**：支持对象实现序列化，虽然成员变量没有使用 transient 关键字修饰，Vector 还是实现了 writeObject() 方法进行序列化。
- 2、**Cloneable**：重写了 clone（）方法，通过 Arrays.copyOf（） 拷贝数组。
- 3、**RandomAccess**：提供了随机访问功能，我们可以通过元素的序号快速获取元素对象。
- 4、**AbstractList**：继承了AbstractList ，说明它是一个列表，拥有相应的增，删，查，改等功能。
- 5、**List**：留一个疑问，为什么继承了 AbstractList 还需要 实现List 接口？

***拓展思考**：为什么 Vector 的序列化，只重写了 writeObject（）方法？

细心的朋友如果在查看 vector 的源码后，可以发现，writeObject（） 的注释中有这样的说法：

```java
This method performs synchronization to ensure the consistency
    of the serialized data.
```

看完注释，可能会有一种恍然大悟的感觉，Vector 的核心思想不就是 线程安全吗？那么序列化过程肯定也要加锁进行操作，才能过说其是线程安全啊。因此，即使没有 elementData 没有使用 transient 进行修饰，还是需要重写writeObject()。

***拓展思考**：与ArrayLit，以及大部分集合类相同，为什么继承了 AbstractList 还需要 实现List 接口？

有两种说法，大家可以参考一下：

1、在StackOverFlow 中：[传送门](http://stackoverflow.com/questions/2165204/why-does-linkedhashsete-extend-hashsete-and-implement-sete) 得票最高的答案的回答者说他问了当初写这段代码的 Josh Bloch，得知这就是一个写法错误。

2、Class类的getInterfaces 可以获取到实现的接口，却不能获取到父类实现接口，但是这种操作无意义。

### 2、Vector 成员变量

```java
    /**
        与 ArrayList 中一致，elementData 是用于存储数据的。
     */
    protected Object[] elementData;

    /**
     * The number of valid components in this {@code Vector} object.
      与ArrayList 中的size 一样，保存数据的个数
     */
    protected int elementCount;

    /**
     * 设置Vector 的增长系数，如果为空，默认每次扩容2倍。
     *
     * @serial
     */
    protected int capacityIncrement;
    
     // 数组最大值
     private static final int MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8;

```

与ArrayList 中的成员变量相比，Vector 少了两个空数组对象： **EMPTY_ELEMENTDATA** 和 **DEFAULTCAPACITY_EMPTY_ELEMENTDATA**

因此，Vector 与 ArrayList 中的第一个不同点就是，**成员变量不一致**。

### 2.1、Vector构造函数

Vector 提供了四种构造函数：

- **Vector()**：默认构造函数
- **Vector(int initialCapacity)**：capacity是Vector的默认容量大小。当由于增加数据导致容量增加时，每次容量会增加一倍。
- **Vector(int initialCapacity, int capacityIncrement)**：capacity是Vector的默认容量大小，capacityIncrement是每次Vector容量增加时的增量值。
- **Vector(Collection c)**：创建一个包含collection的Vector

乍一眼看上去，Vector 中提供的构造函数，与ArrayList 中的一样丰富。但是在[上一节内容](https://juejin.im/post/5aec1863518825671c0e6c75) 中分析过 ArrayList 的构造函数后，再来看Vector 的构造函数，会觉得有一种索然无味的感觉。

```java
    //默认构造函数
    public Vector() {
        this(10);
    }
    
    //带初始容量构造函数
    public Vector(int initialCapacity) {
        this(initialCapacity, 0);
    }
    
    //带初始容量和增长系数的构造函数
    public Vector(int initialCapacity, int capacityIncrement) {
        super();
        if (initialCapacity < 0)
            throw new IllegalArgumentException("Illegal Capacity: "+
                                               initialCapacity);
        this.elementData = new Object[initialCapacity];
        this.capacityIncrement = capacityIncrement;
    }
```

代码看上去没有太多的问题，跟我们平时写的代码一样，只是与ArrayList 中的构造函数相比 缺少了一种韵味。有兴趣的同学可以去看一下ArrayList 中的构造函数实现。

```java
    public Vector(Collection<? extends E> c) {
        elementData = c.toArray();
        elementCount = elementData.length;
        // c.toArray might (incorrectly) not return Object[] (see 6260652)
        if (elementData.getClass() != Object[].class)
            elementData = Arrays.copyOf(elementData, elementCount, Object[].class);
    }
```

JDK 1.2 之后提出了将Collection 转换成 Vector 的构造函数，实际操作就是通过Arrays.copyOf() 拷贝一份Collection 数组中的内容到Vector 对象中。这里会有可能抛出 **NullPointerException**。

在构造函数上面的对比：Vector 的构造函数的设计上输于 ArrayList。

### 2.2、添加方法（Add）

Vector 在添加元素的方法上面，比ArrayList 中多了一个方法。Vector 支持的add 方法有：

- add(E)
- addElement(E)
- add(int i , E element)
- addAll(Collection<? extends E> c)
- addAll(int index, Collection<? extends E> c)

#### 2.2.1 addElement(E)

我们看一下这个多出来的 **addElement(E)** 方法 有什么特殊之处：

```java
    /**
     * Adds the specified component to the end of this vector,
     * increasing its size by one. The capacity of this vector is
     * increased if its size becomes greater than its capacity.
     *
     * <p>This method is identical in functionality to the
     * {@link #add(Object) add(E)}
     * method (which is part of the {@link List} interface).
     *
     * @param   obj   the component to be added
     */
    public synchronized void addElement(E obj) {
        modCount++;
        ensureCapacityHelper(elementCount + 1);
        elementData[elementCount++] = obj;
    }
```

从注释上面来看，这个方法就是 跟 add（E） 方法是有着一样的功能的。因此除了返回数据不同外，也没什么特殊之处了。

我们顺着上述代码来进行分析 Vector 中的添加方法。可以看到 Vector 对整个add 方法都上锁了（添加了 **synchronized** 修饰），其实我们可以理解，在添加元素的过程主要包括以下几个操作：

- ensureCapacityHelper（）：确认容器大小
- grow（）：如果有需要，进行容器扩展
- elementData[elementCount++] = obj：设值

为了避免多线程情况下，在 ensureCapacityHelper 容量不需要拓展的情况下，其他线程刚好将数组填满了，这时候就会出现 **ArrayIndexOutOfBoundsException** ，因此对整个方法上锁，就可以避免这种情况出现。

与ArrayList 中对比，确认容器大小这一步骤中，少了 **ArrayList#ensureCapacityInternal** 这一步骤，主要也是源于 Vector 在构造时，以及创建好默认数组大小，不会出现数组为空的情况。

其次 grow（） 方法中：

```java
    private void grow(int minCapacity) {
        int oldCapacity = elementData.length;
        //区别与ArrayList 中的位运算，这里支持自定义增长系数
        int newCapacity = oldCapacity + ((capacityIncrement > 0) ?
                                         capacityIncrement : oldCapacity);
        if (newCapacity - minCapacity < 0)
            newCapacity = minCapacity;
        if (newCapacity - MAX_ARRAY_SIZE > 0)
            newCapacity = hugeCapacity(minCapacity);
        elementData = Arrays.copyOf(elementData, newCapacity);
    }
```

Vector 中支持自定义的增长系数，也是它在 **add()** 方法中为数不多的亮点了。

#### 2.2.2 add(int index, E element)

这部分代码跟ArrayList 中没有太多的差异，主要是抛出的异常有所不同，ArrayList 中抛出的是IndexOutOfBoundsException。这里则是抛出 ArrayIndexOutOfBoundsException。至于为什么需要将操作抽取到 insertElementAt（） 这个方法中呢？童鞋们可以进行相关思考。

```java
    /**
     * @throws ArrayIndexOutOfBoundsException if the index is out of range
     *         ({@code index < 0 || index > size()})
     * @since 1.2
     */
    public void add(int index, E element) {
        insertElementAt(element, index);
    }
    
    public synchronized void insertElementAt(E obj, int index) {
        modCount++;
        if (index > elementCount) {
            throw new ArrayIndexOutOfBoundsException(index
                                                     + " > " + elementCount);
        }
        ensureCapacityHelper(elementCount + 1);
        System.arraycopy(elementData, index, elementData, index + 1, elementCount - index);
        elementData[index] = obj;
        elementCount++;
    }
```

在添加方法上面，Vector 与ArrayList 大同小异。Vector 多了一个奇怪的 addElement(E)。

### 2.3、删除方法（Remove）

Vecotr 中提供了比较多的删除方法，但是只要查看一下源码，就可以发现其实大部分都是相同的方法。

- remove(int location)
- remove(Object object)
- removeAll(Collection<?> collection)
- removeAllElements()
- removeElement(Object object)
- removeElementAt(int location)
- removeRange(int fromIndex, int toIndex)
- clear()

#### 2.3.1、remove(int location) & removeElementAt(int location)

对比一下 **remove(int location)** 和 **removeElementAt(int location)**

```java
public synchronized void removeElementAt(int index) {
        modCount++;
        if (index >= elementCount) {
            throw new ArrayIndexOutOfBoundsException(index + " >= " +
                                                     elementCount);
        }
        else if (index < 0) {
            throw new ArrayIndexOutOfBoundsException(index);
        }
        int j = elementCount - index - 1;
        if (j > 0) {
            System.arraycopy(elementData, index + 1, elementData, index, j);
        }
        elementCount--;
        elementData[elementCount] = null; /* to let gc do its work */
    }


public synchronized E remove(int index) {
        modCount++;
        if (index >= elementCount)
            throw new ArrayIndexOutOfBoundsException(index);
        E oldValue = elementData(index);

        int numMoved = elementCount - index - 1;
        if (numMoved > 0)
            System.arraycopy(elementData, index+1, elementData, index,
                             numMoved);
        elementData[--elementCount] = null; // Let gc do its work

        return oldValue;
    }
```

除了返回的数据类型不同，其他内部操作其实是一致的。remove 是重写了父类的操作，而removeElement 则是Vector 中自定义的方法。ArrayList 中提供了 fastRemove（） 方法，与其有着同样的效果，不过removeElement 作用范围为public。

#### 2.3.2、remove(Object object) & removeElement(Object object)

```java
    public boolean remove(Object o) {
        return removeElement(o);
    }
    
    public synchronized boolean removeElement(Object obj) {
        modCount++;
        int i = indexOf(obj);
        if (i >= 0) {
            removeElementAt(i);
            return true;
        }
        return false;
    }
```

remove(Object object) 实际内部调用的就是 removeElement(Object object) 。删除操作首先找到 对象的索引（与ArrayList 中的remmove（E）一样），然后调用removeElementAt（i）（ArrayList 中调用 fastRemove（）方法）进行删除。

其余删除操作与ArrayList 类似，这里不做详细解析。总体来说，在删除方法这一块的话，Vector 与ArrayList 也是大同小异。

### 2.4、线程安全 Vector？

拓展思考，我们常说Vector 是线程安全的数组列表，那么它到底是不是无时无刻都是线程安全的呢？在StackOverFlow 中有这样一个问题：

[StackOverFlow 传送门](https://stackoverflow.com/questions/23246059/java-vector-thread-safety?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)

Is there any danger, if im using one Vector(java.util.Vector) on my server program when  im accessing it from multiple threads only for reading?  (myvector .size() .get() ...) For writing im using synchronized methods. Thank you.

其中有一个答案解析的比较详细的：

Vector 中的每一个独立方法都是线程安全的，因为它有着 synchronized 进行修饰。但是如果遇到一些比较复杂的操作，并且多个线程需要依靠 vector 进行相关的判断，那么这种时候就不是线程安全的了。

```java
if (vector.size() > 0) {
    System.out.println(vector.get(0));
}
```

如上述代码所示，Vector 判断完 size（）>0 之后，另一线程如果同时清空vector 对象，那么这时候就会出现异常。因此，在复合操作的情况下，Vector 并不是线程安全的。

### 总结

本篇文章标题是：百密一疏之Vector，原因在于，如果我们没有详细去了解过Vector，或者在面试中，常常会认为Vector 是线程安全的。但是实际上 Vector 只是在每一个单一方法操作上是线程安全的。

总结一下与ArrayList 之间的差异：

- 1、构造函数，ArrayList 比Vector 稍有深度，Vector 默认数组长度为10，创建是设置。
- 2、扩容方法 grow（），ArrayList 通过位运算进行扩容，而Vector 则通过增长系数（创建是设置，如果过为空，则增长一倍）
- 3、Vector 方法调用是线程安全的。
- 4、成员变量有所不同

## 三、LinkedList

我们在前面的文章中已经介绍过 **List** 大家族中的 [ArrayList](https://juejin.im/post/5aec1863518825671c0e6c75) 和[Vector](https://juejin.im/post/5aedcc80518825673c61ccd6) 这两位犹如孪生兄弟一般，从底层实现，功能都有着相似之处，除了一些个人行为不同（成员变量，构造函数和方法线程安全）。接下来，我们将会认识一下他们的另一位功能强大的兄弟：**LinkedList**



LinkedList 的依赖关系：

```java
public class LinkedList<E>
    extends AbstractSequentialList<E>
    implements List<E>, Deque<E>, Cloneable, java.io.Serializable
```

- 1、继承于 AbstractSequentialList ，本质上面与继承 AbstractList 没有什么区别，AbstractSequentialList 完善了 AbstractList 中没有实现的方法。
- 2、Serializable：成员变量 Node 使用 transient 修饰，通过重写read/writeObject 方法实现序列化。
- 3、Cloneable：重写clone（）方法，通过创建新的LinkedList 对象，遍历拷贝数据进行对象拷贝。
- 4、Deque：实现了Collection 大家庭中的队列接口，说明他拥有作为双端队列的功能。

eng～从上述实现接口来看，LinkedList 与 ArrayList 之间在整体上面的区别在于，**LinkedList 实现了 Collection 大家庭中的Queue（Deque）接口，拥有作为双端队列的功能**。（就好比一个小孩子，他不仅仅有父母的特性，他们有些人还会有舅舅的一些特性，好比 外甥长得像舅舅一般）。

### 3.1、LinkedList 成员变量

```java
    transient int size = 0;

    /**
     * Pointer to first node.
     * Invariant: (first == null && last == null) ||
     *            (first.prev == null && first.item != null)
     */
    transient Node<E> first;

    /**
     * Pointer to last node.
     * Invariant: (first == null && last == null) ||
     *            (last.next == null && last.item != null)
     */
    transient Node<E> last;
    
    private static class Node<E> {
        E item;
        Node<E> next;
        Node<E> prev;

        Node(Node<E> prev, E element, Node<E> next) {
            this.item = element;
            this.next = next;
            this.prev = prev;
        }
    }
```

LinkedList 的成员变量主要由 size（数据量大小），first(头节点)和last（尾节点）。结合数据结构中双端链表的思想，每个节点需要拥有，保存数据（E item），指向下一节点（Node next ）和指向上一节点（Node prev）。

LinkedList 与ArrayLit、Vector 的成员变量对比中，明显没有提供 **MAX_ARRAY_SIZE** 这一个最大值的限定，这是由于链表没有长度限制的原因，他的内存地址不需要分配固定长度进行存储，只需要记录下一个节点的存储地址即可完成整个链表的连续。

**拓展思考**： LinkedList 中 JDK 1.8 与JDK 1.6 有哪些不同？

主要不同为，LinkedList 在1.6 版本以及之前，只通过一个 header 头指针保存队列头和尾。这种操作可以说很有深度，但是从代码阅读性来说，却加深了阅读代码的难度。因此在后续的JDK 更新中，将头节点和尾节点 区分开了。节点类也更名为 Node。

### 3.2、LinkedList 构造函数

LinkedList 只提供了两个构造函数：

- LinkedList()
- LinkedList(Collection<? extends E> c)

在JDK1.8 中，LinkedList 的构造函数 LinkedList（） 是一个空方法，并没有提供什么特殊操作。区别于 JDK1.6 中，会初始化 header 为一个空的指针对象。

#### 3.2.1 LinkedList()

**JDK 1.6**

```java
private transient Entry<E> header = new Entry<E>(null, null, null);
    public LinkedList() {
        header.next = header.previous = header;
    }
```

**JDK 1.8** 在使用的时候，才会创建第一个节点。

```java
    public LinkedList() {
    }
```

#### 3.2.2 LinkedList(Collection<? extends E> c)

```java
   public LinkedList(Collection<? extends E> c) {
        this();
        addAll(c);
    }
```

这一构造方法主要通过 调用addAll 进行创建对象，在介绍LinkedList 添加方法的时候再进行细述。

#### 3.2.3 小结

LinkedList 在新版本的实现中，除了区分了头节点和尾节点外，更加注重在使用时进行内存分配，这里跟ArrayList 类似（ArrayList 默认构造器是创建一个空的数组对象）。

### 4、添加方法（Add）

LinkedList 继承了 AbstractSequentialList（AbstractList），同时实现了Deque 接口，因此，他在添加方法 这一块，包含了两者的操作：

**AbstractSequentialList**:

- add(E e)
- add(int index，E e)
- addAll(Collection<? extends E> c)
- addAll(int index, Collection<? extends E> c)

**Deque**

- addFirst(E e)
- addLast(E e)
- offer(E e)
- offerFirst(E e)
- offerLast(E e)

#### 4.1 add(E e) & addLast(E e) & offer(E e) & offerLast(E e)

虽然 LinkedList 分别实现了List 和 Deque 的添加方法，但是在某种意义上，这些方法其实都是有共性的。例如，我们调用add（E e） 方法，不管是ArrayList 或 Vector 等列表，都是默认在数组末尾进行添加，因此与 队列中在末尾添加节点 addLast（E e） 是有着一样的韵味的。所以，从LinkedList 的源码中，这几个方法，底层操作其实是一致的。

```java
    public boolean add(E e) {
        linkLast(e);
        return true;
    }
    
    public void addLast(E e) {
        linkLast(e);
    }
    
     public boolean offer(E e) {
        return add(e);
    }
    
    public boolean offerLast(E e) {
        addLast(e);
        return true;
    }
    
    void linkLast(E e) {
        final Node<E> l = last;
        final Node<E> newNode = new Node<>(l, e, null);
        last = newNode;
        if (l == null)
            first = newNode;
        else
            l.next = newNode;
        size++;
        modCount++;
    }
```

我们主要分析一下 linkLast 这个方法：

- 获取尾节点（last）
- 创建插入节点，并且设置上一节点为 last，下一节点为 null。
- 设置新节点为末尾节点（last）
- 如果 l（初始末尾节点）==null，说明这是第一次操作，新加入的为头节点
- 否则，设置 l（初始末尾节点）的下一节点为新加入的节点
- size + 1，操作计数 + 1

**拓展思考**：为什么内部变量 Node l 需要使用 final 进行修饰？

#### 4.2 addFirst(E e) & offerFirst（E e）

```java
    public boolean offerFirst(E e) {
        addFirst(e);
        return true;
    }
    
    public void addFirst(E e) {
        linkFirst(e);
    }

    private void linkFirst(E e) {
        final Node<E> f = first;
        final Node<E> newNode = new Node<>(null, e, f);
        first = newNode;
        if (f == null)
            last = newNode;
        else
            f.prev = newNode;
        size++;
        modCount++;
    }
```

从上述代码可以看出，offerFirst 和addFirst 其实都是一样的操作，只是返回的数据类型不同。而 **linkFirst** 方法，则与 linkLast 其实是一样的思想，这里也不做细述。

#### 4.3 add(int index，E e)

这里我们主要讲一下，为什么LinkedList 在添加、删除元素这一方面优于 ArrayList。

```java
    public void add(int index, E element) {
        checkPositionIndex(index);
        // 如果插入节点为末尾，直接插入
        if (index == size)
            linkLast(element);
        // 否则，找到该节点，进行插入
        else
            linkBefore(element, node(index));
    }
    
    Node<E> node(int index) {
        // 这里顺序查找元素，通过二分查找的方式，决定从头或尾节点开始进行查找，时间复杂度为 n/2
        if (index < (size >> 1)) {
            Node<E> x = first;
            for (int i = 0; i < index; i++)
                x = x.next;
            return x;
        } else {
            Node<E> x = last;
            for (int i = size - 1; i > index; i--)
                x = x.prev;
            return x;
        }
    }
    
    void linkBefore(E e, Node<E> succ) {
        // assert succ != null;
        final Node<E> pred = succ.prev;
        final Node<E> newNode = new Node<>(pred, e, succ);
        succ.prev = newNode;
        if (pred == null)
            first = newNode;
        else
            pred.next = newNode;
        size++;
        modCount++;
    }
```

LinkedList 在 add（int index，Element e）方法的流程

- 判断下标有效性
- 如果插入位置为末尾，直接插入
- 否则，遍历1/2的链表找到 index 下标的节点
- 通过 succ 设置新节点的前，后节点

LinkedList 在插入数据之所以会优于ArrayList，主要是由于在插入数据这一环节（linkBefore），插入计算只需要设置节点的前，后节点即可，而ArrayList 则需要将整个数组的数据进行后移（

```java
System.arraycopy(elementData, index, elementData, index + 1,size - index);

```



#### 4.4 addAll(Collection<? extends E> c)

LinkedList 中提供的两个addAll 方法中，其实内部实现也是一样的，主要通过： addAll(int index, Collection<? extends E> c)进行实现：

```java
    public boolean addAll(Collection<? extends E> c) {
        return addAll(size, c);
    }
    
      public boolean addAll(int index, Collection<? extends E> c) {
        checkPositionIndex(index);
        //将集合转化为数组
        Object[] a = c.toArray();
        int numNew = a.length;
        if (numNew == 0)
            return false;

        Node<E> pred, succ;
        //获取插入节点的前节点（prev）和尾节点（next）
        if (index == size) {
            succ = null;
            pred = last;
        } else {
            succ = node(index);
            pred = succ.prev;
        }
        //将集合中的数据编织成链表
        for (Object o : a) {
            @SuppressWarnings("unchecked") E e = (E) o;
            Node<E> newNode = new Node<>(pred, e, null);
            if (pred == null)
                first = newNode;
            else
                pred.next = newNode;
            pred = newNode;
        }
        //将 Collection 的链表插入 LinkedList 中。
        if (succ == null) {
            last = pred;
        } else {
            pred.next = succ;
            succ.prev = pred;
        }

        size += numNew;
        modCount++;
        return true;
    }
```

#### 4.5 小结

LinkedList 在插入数据优于ArrayList ，主要是因为他只需要修改指针的指向即可，而不需要将整个数组的数据进行转移。而LinkedList 优于没有实现 RandomAccess，或者说 不支持索引搜索的原因，他在查找元素这一操作，需要消耗比较多的时间进行操作（n/2）。

### 5、删除方法（Remove）

**AbstractSequentialList**：

- remove（int index）
- remove（Object o）

**Deque**

- remove()
- removeFirst()
- removeLast()
- removeFirstOccurrence(Object o)
- removeLastOccurrence(Object o)

#### 5.1 remove（int index)&remove（Object o）

在 ArrayList 中，remove（Object o） 方法，是通过遍历数组，找到下标后，通过fastRemove（与 remove（int i） 类似的操作）进行删除。而LinkedList，则是遍历链表，找到目标节点（node），通过 unlink 进行删除： 我们这里主要来看看 unlink 方法：

```java
    E unlink(Node<E> x) {
        // assert x != null;
        final E element = x.item;
        final Node<E> next = x.next;
        final Node<E> prev = x.prev;

        if (prev == null) {
            first = next;
        } else {
            prev.next = next;
            x.prev = null;
        }

        if (next == null) {
            last = prev;
        } else {
            next.prev = prev;
            x.next = null;
        }

        x.item = null;
        size--;
        modCount++;
        return element;
    }
```

整个过程为：

- 获取目标节点的 next、prev
- 如果prev 为空，说明目标节点为头节点
- 设置first 为目标节点的下一节点（next）
- 否则设置prev节点的下一节点为next（即将自己重链表中剔除）
- 如果 next 为空，说明目标节点为尾节点
- 设置last 为目标节点的上一节点
- 否则，设置next节点的上一节点为prev
- 将目标节点设置为null

可以看到，删除方法与添加方法类似，只需要修改节点关系即可，避免了类似于ArrayList 的数组平移情况，大大减少了时间损耗。

#### 5.2 Deque 中的Remove

Deque 中的 removeFirstOccurrence 和 removeLastOccurrence 主要过程为，首先从first/last 节点开始遍历，当发现第一个目标对象，则低哦啊用remove（Object o） 进行删除对象。总体上没有什么特别之处。

稍有不同的是Deque 中的removeFirst（）和removeLast（）方法，在底层实现上面，由于明确知道删除的对象为first/last对象，因此在删除操作上面 会更加简单：

```java
    public E removeFirst() {
        final Node<E> f = first;
        if (f == null)
            throw new NoSuchElementException();
        return unlinkFirst(f);
    }

    private E unlinkFirst(Node<E> f) {
        // assert f == first && f != null;
        final E element = f.item;
        final Node<E> next = f.next;
        f.item = null;
        f.next = null; // help GC
        first = next;
        if (next == null)
            last = null;
        else
            next.prev = null;
        size--;
        modCount++;
        return element;
    }
```

整体操作为，将first 节点的next 设置为新的头节点，然后将 f 清空。 removeLast 操作也类似。

结合队列的思想，removeFirst 和removeLast 都会返回 数据 E，相当于我们的出列操作（**pollFirst**/**pollLast**）

### 6 LinkedList 双端链表

我们之所以说LinkedList 为双端链表，是因为他实现了Deque 接口，支持队列的一些操作，我们来看一下有哪些方法实现：

- pop（）
- poll（）
- push（）
- peek（）
- offer（）

可以看到Deque 中提供的方法主要有上述的几个方法，接下来我们来看看在LinkedList 中是如何实现这些方法的。

### 6.1 pop（） & poll（）

**LinkedList#pop** 的源码：

```java
    public E pop() {
       return removeFirst();
   }
       public E removeFirst() {
       final Node<E> f = first;
       if (f == null)
           throw new NoSuchElementException();
       return unlinkFirst(f);
   }
```

从上述代码可以看出，Pop（） 的操作为，队列头部元素出队列，如果过first 为空 会抛出异常。

**LinkedList#poll** 的源码：

```java
    public E poll() {
       final Node<E> f = first;
       return (f == null) ? null : unlinkFirst(f);
   }
```

对比 pop 和poll 的源码可以看到，虽然同样是 first 出列，不同的是，如果first 为null， **pop（）方法会抛出异常**。

### 6.2 push（）

push（） 方法的底层实现，其实就是调用了 addFirst（Object o）：

```java
    public void push(E e) {
       addFirst(e);
   }
```

push()方法的操作，主要跟 栈（Stack） 中的入栈操作类似。

### 6.3 peek（）

LinkedList#peek 操作主要为，将取队列头部元素的值（根据队列的 FIFO，peek为取头部数据）

```java
    public E peek() {
       final Node<E> f = first;
       return (f == null) ? null : f.item;
   }
```

### 6.4 offer（）

offer()方法为直接调用添加方法。

```java
    public boolean offer(E e) {
       return add(e);
   }
```

### 7 LinkedList 遍历

LinkedList 由于没有实现 RandomAccess，因此，在以随机访问的形式进行遍历时效果会非常低下。除此之外，LinkedList 提供了类似于通过Iterator 进行遍历，节点的prev 或 next 进行遍历，还有for循环遍历，都有不错的效果。

## 四、HashMap

在接下来主要为大家介绍一下`Java` 集合家庭中另一小分队 `Map` ，我们先来看看 `Map` 家庭的整体架构：



![img](data:image/svg+xml;utf8,<?xml version="1.0"?><svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="1280" height="802"></svg>)



我们主要介绍一下HashMap：



![img](data:image/svg+xml;utf8,<?xml version="1.0"?><svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="880" height="444"></svg>)



HashMap 的依赖关系：

```
public class HashMap<K,V> extends AbstractMap<K,V>
    implements Map<K,V>, Cloneable, Serializable 
复制代码
```

- 1、AbstractMap：表明它是一个散列表，基于Key-Value 的存储方式
- 2、Cloneable：支持拷贝功能
- 3、Seriablizable：重写了write/readObject，支持序列化

从依赖关系上面来看，`HashMap` 并没有 `List` 集合 那么的复杂，主要是因为在迭代上面，HashMap 区别 key-value 进行迭代，而他们的迭代又依赖与keySet-valueSet 进行，因此，虽然依赖关系上面HashMap 看似简单，但是内部的依赖关系更为复杂。

### 4.1、HashMap 成员变量

```java
默认 桶（数组） 容量 16
static final int DEFAULT_INITIAL_CAPACITY = 1 << 4;

最大容量
static final int MAXIMUM_CAPACITY = 1 << 30;

负载因子
static final float DEFAULT_LOAD_FACTOR = 0.75f;

链表转树 大小
static final int TREEIFY_THRESHOLD = 8;

树转链表 大小
static final int UNTREEIFY_THRESHOLD = 6;

最小转红黑树容量
static final int MIN_TREEIFY_CAPACITY = 64;

存储数据节点
static class Node<K,V> implements Map.Entry<K,V> 

节点数组
transient Node<K,V>[] table;

数据容量
transient int size;

操作次数
transient int modCount;

扩容大小
int threshold;

```

对比于JDK8之前的HashMap ，成员变量主要的区别在于多了红黑树的相关变量，用于标示我们在什么时候进行 `list` -> `Tree` 的转换。

附上Jdk8 中HashMap 的数据结构展示图：



![img](https://user-gold-cdn.xitu.io/2018/5/26/1639be07da9b9ccf?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



### 4.2、HashMap 构造函数

HashMap  提供了四种构造函数：

- HashMap（）：默认构造函数，参数均使用默认大小
- HashMap（int initialCapacity）：指定初始数组大小
- HashMap（int initialCapacity, float loadFactor）：指定初始数组大小，加载因子
- HashMap（Map<? extends K, ? extends V> m）：创建新的HashMap，并将 `m` 中内容存入HashMap中

### 4.3、HashMap Put 过程

接下来我们主要讲解一下，HashMap 在JDK8中的添加数据过程（引用）：



![img](data:image/svg+xml;utf8,<?xml version="1.0"?><svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="1280" height="1014"></svg>)



#### 4.3.1、put(K key, V value)

```java
    public V put(K key, V value) {
        return putVal(hash(key), key, value, false, true);
    }
```

上述方法是我们在开发过程中最常使用到的方法，但是却很少人知道，其实内部真正调用的方法是这个`putVal(hash(key), key, value, false, true)` 方法。这里稍微介绍一下这几个参数：

- hash 值，用于确定存储位置
- key：存入键值
- value：存入数据
- onlyIfAbsent：是否覆盖原本数据，如果为true 则不覆盖
- onlyIfAbsent：table 是否处于创建模式

##### 4.3.1.1 hash(Object key)

```java
    static final int hash(Object key) {
        int h;
        return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
    }
```

这里的Hash算法本质上就是三步：取key的hashCode值、高位运算、取模运算。 这里引用一张图，易于大家了解相关机制



![img](https://user-gold-cdn.xitu.io/2018/5/26/1639bfb092e33964?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

 这里可能会比较疑惑，为什么需要对自身的hashCode 进行运算，这么做可以在数组table 比较小的时候，让高位bit 也能参与到hash 运算中，同时不会又太大的开销。



#### 4.3.2、putVal(int hash, K key, V value, boolean onlyIfAbsent, boolean evict)

由于源码篇幅过长，这里我进行分开讲解，同学们可以对照源码进行阅读

##### 4.3.2.1 声明成员变量（第一步）

```java
Node<K,V>[] tab; Node<K,V> p; int n, i;
```

第一部分主要县声明几个需要使用到的成员变量：

- tab：对应table 用于存储数据
- p：我们需要存储的数据，将转化为该对象
- n：数组（table） 长度
- i：数组下标

##### 4.3.2.2 Table 为 null，初始化Table（第二步）

table 为空说明当前操作为第一次操作，通过上面构造函数的阅读，我们可以了解到，我们并没有对table 进行初始化，因此在第一次put 操作的时候，我们需要先将table 进行初始化。

```java
        if ((tab = table) == null || (n = tab.length) == 0)
            n = (tab = resize()).length;
```

从上述代码可以看到，table 的初始化和扩容，都依赖于 `resize（）` 方法，在后面我们会对该方法进行详细分析。

##### 4.3.2.3 Hash碰撞确认下标（True）

```java
 if ((p = tab[i = (n - 1) & hash]) == null)
            tab[i] = newNode(hash, key, value, null);
```

在上一步我们以及确认当前table不为空，然后我们需要计算我们对象需要存储的下标了。

如果该下标中并没有数据，我们只需创建一个新的节点，然后将其存入 `tab[]` 即可。

##### 4.3.2.4 Hash碰撞确认下标（False）

与上述过程相反，Hash碰撞结果后，发现该下标有保存元素，将其保存到变量 `p = tab[i = (n - 1) & hash]` ，现在 `p` 保存的是目标数组下标中的元素。如上图所示(引用)：



![img](https://user-gold-cdn.xitu.io/2018/5/26/1639c02e64af223b?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



###### 4.3.2.4.1 key 值相同覆盖

在获取到 `p` 后，我们首先判断它的 key 是否与我们这次插入的key 相同，如果相同，我们将其引用传递给 `e`

```java
if (p.hash == hash &&
                ((k = p.key) == key || (key != null && key.equals(k))))
                e = p;
```

###### 4.3.2.4.2 红黑树节点处理

```java
else if (p instanceof TreeNode)
                e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
```

由于在JDK 8后，会对过长的链表进行处理，即 链表 -> 红黑树，因此对应的节点也会进行相关的处理。红黑树的节点则为TreeNode，因此在获取到`p`后，如果他跟首位元素不匹配，那么他就有可能为红黑树的内容。所以进行`putTreeVal(this, tab, hash, key, value)` 操作。该操作的源码，将会在后续进行细述。

###### 4.3.2.4.3 链表节点处理

```java
        else {
            //for 循环遍历链表，binCount 用于记录长度，如果过长则进行树的转化
                for (int binCount = 0; ; ++binCount) {
                // 如果发现p.next 为空，说明下一个节点为插入节点
                    if ((e = p.next) == null) {
                        //创建一个新的节点
                        p.next = newNode(hash, key, value, null);
                        //判断是否需要转树
                        if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
                            treeifyBin(tab, hash);
                        //结束遍历
                        break;
                    }
                    //如果插入的key 相同，退出遍历
                    if (e.hash == hash &&
                        ((k = e.key) == key || (key != null && key.equals(k))))
                        break;
                    //替换 p
                    p = e;
                }
            }
```

链表遍历处理，整个过程就是，遍历所有节点，当发现如果存在key 与插入的key 相同，那么退出遍历，否则在最后插入新的节点。判断链表长度是否大于8，大于8的话把链表转换为红黑树，在红黑树中执行插入操作，否则进行链表的插入操作；遍历过程中若发现key已经存在直接覆盖value即可；

##### 4.3.2.4.3 判断是否覆盖

```java
        if (e != null) { // existing mapping for key
                V oldValue = e.value;
                if (!onlyIfAbsent || oldValue == null)
                    e.value = value;
                afterNodeAccess(e);
                return oldValue;
            }
```

如果 `e` 不为空，说明在校验 key 的hash 值，发现存在相同的 key，那么将会在这里进行判断是否对其进行覆盖。

##### 4.3.2.5 容量判断

```java
        if (++size > threshold)
            resize();
```

如果 `size` 大于 `threshold` 则进行扩容处理。

### 4.4、Resize（）扩容

在上面的构造函数，和 `put`过程都有调用过`resize（）` 方法，那么，我们接下来将会分析一下 `resize（）`过程。由于`JDK 8`引入了红黑树，我们先从`JDK 7`开始阅读 `resize（）` 过程。下面部分内容参考：[传送门](https://tech.meituan.com/java-hashmap.html)

#### 4.4.1 JDK 7 resize()

在 `JDK 7` 中，扩容主要分为了两个步骤：

- 容器扩展
- 内容拷贝

##### 4.4.1.1 容器扩展

```java
  void resize(int newCapacity) {   //传入新的容量
      Entry[] oldTable = table;    //引用扩容前的Entry数组
      int oldCapacity = oldTable.length;         
     if (oldCapacity == MAXIMUM_CAPACITY) {  //扩容前的数组大小如果已经达到最大(2^30)了
         threshold = Integer.MAX_VALUE; //修改阈值为int的最大值(2^31-1)，这样以后就不会扩容了
          return;
      }
   
      Entry[] newTable = new Entry[newCapacity];  //初始化一个新的Entry数组
     transfer(newTable);                         //！！将数据转移到新的Entry数组里
     table = newTable;                           //HashMap的table属性引用新的Entry数组
     threshold = (int)(newCapacity * loadFactor);//修改阈值
 }
```

##### 4.4.1.2 内容拷贝

```java
  void transfer(Entry[] newTable) {
      Entry[] src = table;                   //src引用了旧的Entry数组
      int newCapacity = newTable.length;
      for (int j = 0; j < src.length; j++) { //遍历旧的Entry数组
          Entry<K,V> e = src[j];             //取得旧Entry数组的每个元素
          if (e != null) {
              src[j] = null;//释放旧Entry数组的对象引用（for循环后，旧的Entry数组不再引用任何对象）
              do {
                  Entry<K,V> next = e.next;
                 int i = indexFor(e.hash, newCapacity); //！！重新计算每个元素在数组中的位置
                 e.next = newTable[i]; //标记[1]
                 newTable[i] = e;      //将元素放在数组上
                 e = next;             //访问下一个Entry链上的元素
             } while (e != null);
         }
     }
 }
```

##### 4.4.1.3 扩容过程展示（引用）

下面举个例子说明下扩容过程。假设了我们的hash算法就是简单的用key mod 一下表的大小（也就是数组的长度）。其中的哈希桶数组table的size=2， 所以key = 3、7、5，put顺序依次为 5、7、3。在mod 2以后都冲突在table[1]这里了。这里假设负载因子 loadFactor=1，即当键值对的实际大小size 大于 table的实际大小时进行扩容。接下来的三个步骤是哈希桶数组 resize成4，然后所有的Node重新rehash的过程。



![img](https://user-gold-cdn.xitu.io/2018/5/27/163a03f96d371bf8?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



#### 4.4.2 JDK 8 resize()

由于扩容部分代码篇幅比较长，童鞋们可以对比着博客与源码进行阅读。 与上述流程相似，`JDK 8` 中扩容过程主要分成两个部分：

- 容器扩展
- 内容拷贝

##### 4.4.2.1 容器扩展

```java
        Node<K,V>[] oldTab = table;         //创建一个对象指向当前数组
        int oldCap = (oldTab == null) ? 0 : oldTab.length;      // 获取旧数组的长度
        int oldThr = threshold;                             //获取旧的阀值
        int newCap, newThr = 0;   
        // 第一步，确认数组长度
        if (oldCap > 0) {                           //如果数组不为空
            if (oldCap >= MAXIMUM_CAPACITY) {           //当容器大小以及是最大值时
                threshold = Integer.MAX_VALUE;          //设置阀值为最大值，并且不再做扩容处理
                return oldTab;
            }
            else if ((newCap = oldCap << 1) < MAXIMUM_CAPACITY &&
                     oldCap >= DEFAULT_INITIAL_CAPACITY)
                // 容器扩容一倍，并且将阀值设置为原来的一倍
                newThr = oldThr << 1; // double threshold   
        }
        else if (oldThr > 0) // initial capacity was placed in threshold
            //如果阀值不为空，那么将容量设置为当前阀值
            newCap = oldThr;
        else {               // zero initial threshold signifies using defaults
            //如果数组长度与阀值为空，创建一个默认长度的数组长度
            newCap = DEFAULT_INITIAL_CAPACITY;
            newThr = (int)(DEFAULT_LOAD_FACTOR * DEFAULT_INITIAL_CAPACITY);
        }
        
        // 第二步，创建新数组
        threshold = newThr;
        @SuppressWarnings({"rawtypes","unchecked"})
            Node<K,V>[] newTab = (Node<K,V>[])new Node[newCap];
        table = newTab;
```

从上面的流程分析，我们可以看到在 `JDK 8 HashMap` 中，开始使用位运算进行扩容计算，主要优点将会在后续数据拷贝中具体表现。

##### 4.4.2.2 内容拷贝

在上述容器扩容结束后，如果发现 `oldTab` 不为空，那么接下来将会进行内容拷贝：

```java
    if (oldTab != null) {
            //对旧数组进行遍历
            for (int j = 0; j < oldCap; ++j) {
                Node<K,V> e;
                //
                if ((e = oldTab[j]) != null) {
                    //将旧数组中的内容清空
                    oldTab[j] = null;
                    //如果 e 没有后续内容，只处理当前值即可
                    if (e.next == null)
                        通过位运算确定下标
                        newTab[e.hash & (newCap - 1)] = e;
                    //如果 当前节点为红黑树节点，进行红黑树相关处理    
                    else if (e instanceof TreeNode)
                        ((TreeNode<K,V>)e).split(this, newTab, j, oldCap);
                    else { // preserve order
                        Node<K,V> loHead = null, loTail = null;
                        Node<K,V> hiHead = null, hiTail = null;
                        Node<K,V> next;
                        do {
                            next = e.next;
                            //高位 与运算，确定索引为原索引
                            if ((e.hash & oldCap) == 0) {
                                if (loTail == null)
                                    loHead = e;
                                else
                                    loTail.next = e;
                                loTail = e;
                            }
                            //高位与运算，确认索引为 愿索引+ oldCap
                            else {
                                if (hiTail == null)
                                    hiHead = e;
                                else
                                    hiTail.next = e;
                                hiTail = e;
                            }
                        } while ((e = next) != null);
                        // 将所以设置到对应的位置
                        if (loTail != null) {
                            loTail.next = null;
                            newTab[j] = loHead;
                        }
                        if (hiTail != null) {
                            hiTail.next = null;
                            newTab[j + oldCap] = hiHead;
                        }
                    }
                }
            }
        }
```

内容拷贝，在`JDK 8` 中优化，主要是：

- 通过高位与运算确认存储地址
- 链表不会出现导致，JDK 8 通过创建新链表方式进行转移

我们来看一下 `JDK 8` 是如何通过高位与运算确认存储位置的：



![img](https://user-gold-cdn.xitu.io/2018/5/27/163a059cde5d4eea?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



### 4.5、小结

HashMap中，如果key经过hash算法得出的数组索引位置全部不相同，即Hash算法非常好，那样的话，getKey方法的时间复杂度就是O(1)，如果Hash算法技术的结果碰撞非常多，假如Hash算极其差，所有的Hash算法结果得出的索引位置一样，那样所有的键值对都集中到一个桶中，或者在一个链表中，或者在一个红黑树中，时间复杂度分别为O(n)和O(lgn)。

(1) 扩容是一个特别耗性能的操作，所以当程序员在使用HashMap的时候，估算map的大小，初始化的时候给一个大致的数值，避免map进行频繁的扩容。

(2) 负载因子是可以修改的，也可以大于1，但是建议不要轻易修改，除非情况非常特殊。

(3) HashMap是线程不安全的，不要在并发的环境中同时操作HashMap，建议使用ConcurrentHashMap。

(4) JDK1.8引入红黑树大程度优化了HashMap的性能。

(5) 还没升级JDK1.8的，现在开始升级吧。HashMap的性能提升仅仅是JDK1.8的冰山一角。

### 参考

- [tech.meituan.com/java-hashma…](https://tech.meituan.com/java-hashmap.html)
- [www.2cto.com/kf/201505/4…](https://www.2cto.com/kf/201505/401433.html)
- [https://juejin.im/post/5ef84184e51d45348424d810](https://juejin.im/post/5ef84184e51d45348424d810)

## 关注

>如果你觉得我的文章对你有帮助话，欢迎点赞👍 关注❤️ 分享👥！
>如果本篇博客有任何错误，请批评指教，不胜感激！
>点个在看，分享到朋友圈，对我真的很重要！！！

![公众号](https://gitee.com/VincentBlog/image/raw/master/image/20211013200549.jpg)