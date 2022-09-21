## 第一章 基础知识

### 1.this和super关键字

- 调用当前类的方法
- `this()`可以调用的当前类的构造方法
- this 可以作为参数字在方法中传递
- this 可以作为参数在构造函数中调用
- this 可以作为方法的返回值 返回当前类的对象



#### 1.1 指向的当前对象

 **注意:如果构造方法的参数和变量名相同、没有使用this关键字所以无法实例变量赋值** 

```java
public class ExampelUserVO {

	/**
	 * 客户名称
	 */
	private String customerName;

	/**\
	 * 客户编码
	 * 赋值 默认值为空
	 */
	private String customerNo;


	ExampelUserVO(String customerNo,String customerName){
		customerNo=customerNo;
		customerName=customerName;
	}
	void soutStr(){
		System.out.println(customerNo+"_"+customerName);
	}

	public static void main(String[] args) {
		ExampelUserVO userVO=new ExampelUserVO("SnailThink","思考的蜗牛");
		userVO.soutStr();
	}
}
```

**输出结果为 null_null**

```java
public class ExampelUserVO {


	/**
	 * 客户名称
	 */
	private String customerName;

	/**\
	 * 客户编码
	 * 赋值 默认值为空
	 */
	private String customerNo;


	ExampelUserVO(String customerNo,String customerName){
		this.customerNo=customerNo;
		this.customerName=customerName;
	}
	void soutStr(){
		System.out.println(customerNo+"_"+customerName);
	}

	public static void main(String[] args) {
		ExampelUserVO userVO=new ExampelUserVO("SnailThink","思考的蜗牛");
		userVO.soutStr();
	}
}
```

**输出结果为SnailThink_思考的蜗牛**



#### 1.2. 调用当前类的方法

在同一个类中使用this关键字调用另外一个方法，如果没有使用this，编译器会加上this 关键字

```java
public class ExampelUserVO {


	/**
	 * 客户名称
	 */
	private String customerName;

	/**\
	 * 客户编码
	 * 赋值 默认值为空
	 */
	private String customerNo;


	ExampelUserVO(String customerNo,String customerName){
		this.customerNo=customerNo;
		this.customerName=customerName;
	}
	void soutStr(){
		System.out.println(customerNo+"_"+customerName);
	}
	//soutPrintStr方法调用 soutStr 方法
	void soutPrintStr(){
		soutStr();
	}

	public static void main(String[] args) {
		ExampelUserVO userVO=new ExampelUserVO("SnailThink","思考的蜗牛");
		userVO.soutPrintStr();
	}
}

```

**输出结果为 SnailThink_思考的蜗牛**



#### 1.3.调用当前类的构造方法

在一个类中有参构造调用无参构造、只需加上`this（）`就可以调用了，但是需要注意的是、`this()`需要加在方法的第一行。

```java
public class ExampelUserVO {


	/**
	 * 客户名称
	 */
	private String customerName;

	/**\
	 * 客户编码
	 * 赋值 默认值为空
	 */
	private String customerNo;

	/**
	 * 无参构造
	 */
	ExampelUserVO(){
		System.out.println("我是无参构造");
	}
	/**
	 * 有参构造
	 * @param customerNo
	 * @param customerName
	 */
	ExampelUserVO(String customerNo,String customerName){
		this();
		this.customerNo=customerNo;
		this.customerName=customerName;
	}

	void soutStr(){
		System.out.println(customerNo+"_"+customerName);
	}

	void soutPrintStr(){
		soutStr();
	}

	public static void main(String[] args) {
		ExampelUserVO userVO=new ExampelUserVO("SnailThink","思考的蜗牛");
		userVO.soutPrintStr();
	}
}
```



#### 1.4.作为参数在方法中传递

this关键字可作为参数在方法中传递，此时它指向的是当前类的对象

`method2()`调用了`method1()`并传递了 参数this  ,`method1()`打印当前对象的字符串  

```java
	/**
	 * 打印对象
	 * @param vo
	 */
	void method1(ExampelUserVO vo) {
		System.out.println(vo);
	}

	void method2() {
		method1(this);
	}
```



```java
public class ExampelUserVO {
	/**
	 * 客户名称
	 */
	private String customerName;

	/**\
	 * 客户编码
	 * 赋值 默认值为空
	 */
	private String customerNo;

	/**
	 * 无参构造
	 */
	ExampelUserVO(){
		System.out.println("我是无参构造");
	}
	/**
	 * 有参构造
	 * @param customerNo
	 * @param customerName
	 */
	ExampelUserVO(String customerNo,String customerName){
		this();
		this.customerNo=customerNo;
		this.customerName=customerName;
	}

	void soutStr(){
		System.out.println(customerNo+"_"+customerName);
	}

	void soutPrintStr() {
		soutStr();
	}

	/**
	 * 打印对象
	 * @param vo
	 */
	void method1(ExampelUserVO vo) {
		System.out.println(vo);
	}

	void method2() {
		method1(this);
	}

	public static void main(String[] args) {
		ExampelUserVO userVO=new ExampelUserVO("SnailThink","思考的蜗牛");
		userVO.soutPrintStr();
	}
}
```

#### 1.5.作为参数的返回值

`getExampelVO()`方法返回了this关键字 指向的就是 ·`new ExampelUserVO() `这个对象，所以可以接着调用

`strOut()`方法 -达到链式调用的目的 



```java
ExampelUserVO getExampelVO() {
		return this;
	}
	void strOut(){
		System.out.println("hello");
	}
	public static void main(String[] args) {
		ExampelUserVO userVO=new ExampelUserVO("SnailThink","思考的蜗牛");
		userVO.soutPrintStr();
		new ExampelUserVO().getExampelVO().strOut();
	}
```

#### 1.6.super关键字

`super` 关键字的用法用3种

- 指向父类对象 
- 调用父类的方法
- `super()`可以调用父类的构造方法

每当创建一个子类队对象的时候也会隐式创建父类用super



### 2、方法的重载和重写

#### 2.1.方法重载

同一个类中 方法名称相同 参数不同



#### 2.2.方法重写

- 重写的方法必须和父类中的方法名称相同
- 重写方法必须和父类方法的参数相同
- 必须是继承关系

### 3、instanceof

instanceof 用来测试一个对象是否为一个类的实例 用法为

```java
boolean result = obj instanceof Class
```

obj为一个对象，Class表示一个类或者一个接口 ，当obj为Class的对象，或者是其直接或间接子类，或者是其接口的实现类，结果result 都返回的true  否则返回false 

注意：编辑器会检查obj是否能转化为右边的class类型 如果不能转换则直接报错。

```java
/**
	 * 参数类型校验
	 */
	@Test
	void getInstanceof() {
		Object str = "AAA";
		if (str instanceof String) {
			String strObj = (String) str;
			System.out.println(strObj);
		}
	}
```

- obj必须是引用类型 不能是基本类型
- obj为class类的实例对象
- obj为class接口的实现类

### 4、Java关键字

```java
//访问控制
private protected public

//类方法和变量修饰符
abstract class extends final implements interface native new 
static strictfp synchronized transient volatile

//程序控制
break continue return do while if else  for instanceof switch case default
    
//异常处理
 try catch throw throws 
//包相关
import package

//基本类型
boolean byte char double float int long short null true false 
//变量引用
super this void 
//保留字
goto const
```

### 5.抽象类和接口的区别

1. 接口默认方法是public，所有方法在接口中不能有实现，抽象类可以有非抽象的方法
2. 接口中除了`static` `final` 变量不能有其他的变量，而抽象类中则不一定
3. 一个类可以实现多个接口、但只能实现一个抽象类、接口可以通过`extend关键字扩展多个接口
4. 接口方法默认修饰符为`public`  抽象方法可以有 `public`、`protected` 和 `default` 这些修饰符（抽象方法就是为了被重写所以不能使用 `private` 关键字修饰！）。 
5. 从设计层面来说、抽象是对类的抽象、是一种模板设计、而接口是对行为的抽象、是一种行为的规范

### 6. 成员变量与局部变量的区别

1. 在类中的位置不同， 成员变量：类中方法外 局部变量：方法定义中或者方法声明上
2. 在内存中的位置不同: **成员变量：在堆中**   **局部变量：在栈中** 
3.  **生命周期不同**     **成员变量：随着对象的创建而存在，随着对象的消失而消失**   **局部变量：随着方法的调用而存在，随着方法的调用完毕而消失** 
4.  **初始化值不同**  **成员变量：有默认值**   **局部变量：没有默认值，必须定义，赋值，然后才能使用** 

### 7.构造方法有哪些特性？

1. 名字与类相同
2. 没有返回值、但不能用void声明构造函数
3. 生成类的对象自动执行、无需调用

### 8.静态方法和实例方法的区别？

1. 外部调用静态方法时候 可以通过 `类名称.方法名` 、也可以通过 `对象名.方法名`、而实例方法只能通过后面这种方式获取、调用静态方法不需创建对象
2. 静态方法访问本类、只允许访问静态成员、实例方法无此限制

### 9.对象相等与指向他们的引用相等、有什么不同

1. 对象相等比较的是内存的存放内容是否相等、而引用相等、比较的是内存地址是否相同

### 10.==和equals

1. ==:它的作用是判断二个对象的地址是不是相等、判断二个对象是不是同一个对象[基本数据类型==比较的值，引用数据类型==比较的是内存地址]
2. equals：它的作用是判断俩个对象是否相等
   - 类没有覆写equals() 方法、则通过equals() 比较该类的两个对象 等价于通过 == 比较两个对象
   - 类覆写了equals() 方法、比较两个对象的内容是否相同

### 11.Java序列化

```java
/**
	 * 序列化VO
	 */
	@Test
	void xlh(){
		StudentVO person = new StudentVO("张三","男",16,"13100000000");

		String ormUserPOJsonStr = JSON.toJSONString(person /*, SerializerFeature.UseSingleQuotes*/);
		System.out.println(ormUserPOJsonStr);

		//1.序列化创建
		try (
				//1.创建一个ObjectOutputStream输出流
				//2.调用ObjectOutputStream对象的writeObject输出可序列化对象。
			 ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("object.txt"))) {
			//将对象序列化到文件s
			oos.writeObject(person);
		} catch (Exception e) {
			e.printStackTrace();
		}

		//2.反序列化
		//创建一个ObjectInputStream输入流；
		//调用ObjectInputStream对象的readObject()得到序列化的对象。

		try (
				//创建一个ObjectInputStream输入流
			ObjectInputStream ois = new ObjectInputStream(new FileInputStream("person.txt"))) {
			StudentVO brady = (StudentVO) ois.readObject();
			System.out.println(brady);
		} catch (Exception e) {
			e.printStackTrace();
		}
        
        //2.若对象中的某一个参数不需要进行序列化则在参数签名加上 transient 关键字修饰。
       //private transient String name;

	}
```

### 12.深拷贝和浅拷贝的区别

1. 浅拷贝：对基本数据类型进行值传递、对引用数据类型进行引用传递的拷贝
2. 深拷贝：对基本数据类型进行值传递、对引用类型创建一个新的对象、并创建一个新的对象 并赋值其内容



## 第二章 数据结构

### 1.堆、栈、内存区





### 2.Map/List

#### 2.1.HashSet如何检查重复

当你把对象加入`HashSet`时，`HashSet` 会先计算对象的`hashcode`值来判断对象加入的位置，同时也会与其他加入的对象的 `hashcode` 值作比较，如果没有相符的 `hashcode`，`HashSet` 会假设对象没有重复出现。但是如果发现有相同 `hashcode` 值的对象，这时会调用`equals()`方法来检查 `hashcode` 相等的对象是否真的相同。如果两者相同，`HashSet` 就不会让加入操作成功。 

1. 如果两个对象相等，则 `hashcode` 一定也是相同的
2. 两个对象相等，对两个 `equals()` 方法返回 true
3. 两个对象有相同的 `hashcode` 值，它们也不一定是相等的

#### 2.2.底层实现

**List**

- `Arraylist`： `Object[]`数组
- `Vector`：`Object[]`数组
- `LinkedList`： 双向链表(JDK1.6 之前为循环链表，JDK1.7 取消了循环)

**Set**

- `HashSet`（无序，唯一）: 基于 `HashMap` 实现的，底层采用 `HashMap` 来保存元素
- `LinkedHashSet`：`LinkedHashSet` 是 `HashSet` 的子类，并且其内部是通过 `LinkedHashMap` 来实现的。有点类似于我们之前说的 `LinkedHashMap` 其内部是基于 `HashMap` 实现一样，不过还是有一点点区别的
- `TreeSet`（有序，唯一）： 红黑树(自平衡的排序二叉树)

**Map**

- `HashMap`： JDK1.8 之前 `HashMap` 由数组+链表组成的，数组是 `HashMap` 的主体，链表则是主要为了解决哈希冲突而存在的（“拉链法”解决冲突）。JDK1.8 以后在解决哈希冲突时有了较大的变化，当链表长度大于阈值（默认为 8）（将链表转换成红黑树前会判断，如果当前数组的长度小于 64，那么会选择先进行数组扩容，而不是转换为红黑树）时，将链表转化为红黑树，以减少搜索时间.
- `LinkedHashMap`： `LinkedHashMap` 继承自 `HashMap`，所以它的底层仍然是基于拉链式散列结构即由数组和链表或红黑树组成。另外，`LinkedHashMap` 在上面结构的基础上，增加了一条双向链表，使得上面的结构可以保持键值对的插入顺序。同时通过对链表进行相应的操作，实现了访问顺序相关逻辑。详细可以查看：[《LinkedHashMap 源码详细分析（JDK1.8）》](https://www.imooc.com/article/22931)
- `Hashtable`： 数组+链表组成的，数组是 `HashMap` 的主体，链表则是主要为了解决哈希冲突而存在的
- `TreeMap`： 红黑树（自平衡的排序二叉树）



## 第三章 多线程

### 1.synchronized 关键字和 volatile 关键字的区别

1. **`volatile` 关键字**是线程同步的**轻量级实现**，所以**`volatile`性能肯定比`synchronized`关键字要好**。但是**`volatile` 关键字只能用于变量而 `synchronized` 关键字可以修饰方法以及代码块**。
2. **`volatile` 关键字能保证数据的可见性，但不能保证数据的原子性。`synchronized` 关键字两者都能保证。**
3.  **`volatile`关键字主要用于解决变量在多个线程之间的可见性，而 `synchronized` 关键字解决的是多个线程之间访问资源的同步性** 













## 常见问题

#### 1. ACID

[ACID](https://blog.csdn.net/shuaihj/article/details/14163713)

1. **Atomicity 原子性**:要么全是，要么全不是
2. **Consistency 一致性**：成功/失败数据保持不变一样
3. **Isolation 隔离性**：多个事务并发访问，事务之间是隔离的，一个事务不影响其他的事务
4. **Durability 持久性**：事务完成后，数据保存到数据库中，并不回被回滚。

#### 2. Java CPU 100% 排查

[CPU100](https://blog.csdn.net/weixin_28958411/article/details/114277817)



#### 3.堆栈的区别



#### 4. synchronized与Lock的区别 

![](https://gitee.com/VincentBlog/image/raw/master/image/20210519095736.png)



#### 5.死锁产生的条件是什么？如何避免死锁以及消除死锁？

1. 破坏互斥条件
2. 破坏与报出条件
3. 不剥夺条件
4. 循环等待 若干进程之间形成头尾相接的循环等待资源关系



#### 6. 双亲委派模式



![image-20210308100901528](C:\Users\Manager\AppData\Roaming\Typora\typora-user-images\image-20210308100901528.png)

#### 7. lambda表达式处理集合 

[lambda](https://blog.csdn.net/lmy86263/article/details/51057733)

`lambda` foreach()处理集合时**不能使用break和continue**这两个方法 

而如果要实现在普通for循环中的效果时，可以使用return来达到，也就是说如果你在一个方法的lambda表达式中使用return时，这个方法是不会返回的，而只是执行下一次遍历，看如下的测试代码：

```java
List<String> list = Arrays.asList("123", "45634", "7892", "abch", "sdfhrthj", "mvkd");
list.stream().forEach(e ->{
	if(e.length() >= 5){
		return;
	}
	System.out.println(e);
});
```

 **return起到的作用和continue是相同的**。 







