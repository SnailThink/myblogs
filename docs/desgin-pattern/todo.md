# 设计模式

### 设计模式分类

#### 创建型模式：

单例模式、工厂模式、抽象工厂模式、建造者模式、原型模式

#### 结构型模式：

适配器模式、桥接模式、装饰模式、组合模式、外观模式、享元模式、代理模式

#### 行为型模式：

模板方式模式、命令模式、迭代器模式、观察者模式、中介者模式、备忘录模式、状态模式、策略模式、职责链模式、访问者模式

#### OOP七大原则：

- 开闭原则：对扩展开放、对修改关闭
- 里氏替换原则：基础必须确保超类所拥有的性质在子类中仍然存在
- 依赖倒置原则：要面向接口编程、不要面向实现编程
- 单一职责原则：控制类的粒度大小、将对象解耦、提高其内聚
- 接口隔离原则：要为各个类建立他们需要的专有接口
- 迪米特法则：只与你的直接朋友交谈、不跟陌生人说话
- 合成复用原则：尽量先使用组合或聚合等关联关系来实现、其次才考虑使用继承关系实现






[单例模式](https://zhuanlan.zhihu.com/p/33102022)

[抽象工厂模式](https://mp.weixin.qq.com/s/K_E9pI5rnkjHU0eizg9lqg)

[装饰器模式](https://mp.weixin.qq.com/s/mz9rJELjcWlTv4LFzmKmTA)

[代理模式](https://mp.weixin.qq.com/s/O8_A2Ms9MPKEe9m6Y6t2-g)

[责任链模式](https://mp.weixin.qq.com/s/oP3GOPbjg5wHcgtizExThw)

[单例设计模式](https://mp.weixin.qq.com/s/-Iww0kShHBoo8dPHDRjAXA)

[漫画：什么是 “设计模式” ？](http://mp.weixin.qq.com/s?__biz=MzIxMjE5MTE1Nw==&mid=2653208991&idx=1&sn=7c5756612a62a3a4aad84a52aba40aa0&chksm=8c99b345bbee3a53dc802f16066756e23c4fe1b14fc922f79d3863e5553e5f09695567ea2765&scene=21#wechat_redirect)

[漫画：设计模式中的 “观察者模式”](http://mp.weixin.qq.com/s?__biz=MzIxMjE5MTE1Nw==&mid=2653207999&idx=1&sn=38f3f0d5d0cd6228e476a04d32de8ab3&chksm=8c99cf65bbee4673ca6648eb91b6748298ce9a34779ddc3bb52022c61550c7438fe34eaf89bf&scene=21#wechat_redirect)

[漫画：设计模式之 “外观模式”](http://mp.weixin.qq.com/s?__biz=MzIxMjE5MTE1Nw==&mid=2653210733&idx=1&sn=5e67b9342ce33c5d276d2da5676f7b07&chksm=8c99bab7bbee33a143d26f6a92a55567468a87aad1a661ca447a0f4e995c4ccbdbf594d2b35a&scene=21#wechat_redirect)

[漫画：设计模式之 “工厂模式”](http://mp.weixin.qq.com/s?__biz=MzIxMjE5MTE1Nw==&mid=2653211827&idx=1&sn=e904685440a524a3482f7cda95b2f80a&chksm=8c99be69bbee377fc02ca54fa5d2beb695371437fdec625da786fe3a9752308a4246ecec68f3&scene=21#wechat_redirect)

[漫画：什么是 “抽象工厂模式” ？](http://mp.weixin.qq.com/s?__biz=MzIxMjE5MTE1Nw==&mid=2653212055&idx=1&sn=2308694d9aafa1f053d7f2e7d7d7fbf3&chksm=8c99bf4dbbee365bc05d4c746a044f46c31cd50a642ee96768061c4f308afdd9402934f2147b&scene=21#wechat_redirect)



 https://www.cnblogs.com/tongkey/p/7170826.html 



## 单例模式

[漫画：什么是单例模式？](https://zhuanlan.zhihu.com/p/33102022)

[JAVA设计模式之单例模式](https://blog.csdn.net/jason0539/article/details/23297037)

单例模式特点:

- 单例类只能有一个实例
- 单例类必须自己创建自己的唯一实例
- 单例类必须给所有其他对象提供实例

### 1.懒汉写法（线程不安全）

```java
public class Singleton {
    private Singleton() {}  //私有构造函数
    private static Singleton instance = null;  //单例对象
    //静态工厂方法
    public static Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton();
        }
        return instance;
    }
}
```

**注意**

- 一个类只能构建一个对象，自然不能让它随便去做new操作，因此Signleton的构造方法是私有的。 
-  getInstance是获取单例对象的方法 
-  instance是Singleton类的静态成员，也是单例对象， 它的初始值可以写成Null  则是 **懒汉模式。** 
-  单例对象一开始就被new Singleton()主动构建，则不再需要判空操作，这种写法属于**饿汉模式**。 如下所示

### 2.懒汉式写法（线程安全）

```java
public class Singleton {  
    private static Singleton instance;  
    private Singleton (){}  
    public static synchronized Singleton getInstance() {  
    if (instance == null) {  
        instance = new Singleton();  
    }  
    return instance;  
    }  
}   
```



### 2.1 饿汉式

```java
public class Singleton {  
    private static Singleton instance = new Singleton();  
    private Singleton (){}  
    public static Singleton getInstance() {  
    return instance;  
    }  
}  
```



### 3. 静态内部类

```java
public class Singleton {  
    private static class SingletonHolder {  
    private static final Singleton INSTANCE = new Singleton();  
    }  
    private Singleton (){}  
    public static final Singleton getInstance() {  
    return SingletonHolder.INSTANCE;  
    }  
} 
```

**注意**

- 从外部无法访问静态内部类`SingletonHolder`，只有当调用Singleton.getInstance方法的时候，才能得到单例对象INSTANCE。 
-  INSTANCE对象初始化的时机并不是在单例类Singleton被加载的时候，而是在调用getInstance方法，使得静态内部类`SingletonHolder`被加载的时候。因此这种实现方式是利用**classloader的加载机制**来实现懒加载，并保证构建单例的线程安全。 

### 4.枚举

```java
public enum Singleton {  
    INSTANCE;  
    public void whateverMethod() {  
    }  
}  
```

### 5.双重校验锁

```java
public class Singleton {  
    private volatile static Singleton singleton;  
    private Singleton (){}  
    public static Singleton getSingleton() {  
    if (singleton == null) {  
        synchronized (Singleton.class) {  
        if (singleton == null) {  
            singleton = new Singleton();  
        }  
        }  
    }  
    return singleton;  
    }  
} 
```

 1.为了防止new Singleton被执行多次，因此在new操作之前加上Synchronized 同步锁，锁住整个类（注意，这里不能使用对象锁） 

 2.进入Synchronized 临界区以后，还要再做一次判空。因为当两个线程同时访问的时候，线程A构建完对象，线程B也已经通过了最初的判空验证，不做第二次判空的话，线程B还是会再次构建instance对象。 

**注意**

- volatile关键字不但可以防止指令重排，也可以保证线程访问的变量值是**主内存中的最新值** 
-  使用枚举实现的单例模式，不但可以防止利用反射强行构建单例对象，而且可以在枚举类对象被**反序列化**的时候，保证反序列的返回结果是同一对象。 
-  对于其他方式实现的单例模式，如果既想要做到可序列化，又想要反序列化为同一对象，则必须实现**readResolve**方法。 

### **使用场景：**

● 要求生成唯一序列号的环境；

● 在整个项目中需要一个共享访问点或共享数据，例如一个Web页面上的计数器，可以不用把每次刷新都记录到数据库中，使用单例模式保持计数器的值，并确保是线程安全的；

● 创建一个对象需要消耗的资源过多，如要访问IO和数据库等资源；

● 需要定义大量的静态常量和静态方法（如工具类）的环境，可以采用单例模式（当然，也可以直接声明为static的方式）。

## 工厂模式

核心本质

- 实例化对象不用new 用工厂方法代替
- 将选择实现类、创建对象统一管理和控制、从而将调用者跟实现类解耦

### 1.简单工厂模式

用来生产同一等级结构中的任意产品[对于增加新的产品、需要扩展已有代码]

### 2.工厂方法模式

用来生产同一等级结构中的固定产品(支持增加任意产品)

![image-20210510163315874](C:\Users\Manager\AppData\Roaming\Typora\typora-user-images\image-20210510163315874.png)

### 3.抽象工厂模式

- 围绕一个超级工厂创建其他工厂，该超级工厂又称为其他工厂的工厂。

定义：抽象工厂提供了一个创建一系列相关或者相互依赖对象的接口、无需指定他们具体的类



适用场景：

- 客户端(应用层)不依赖产品实例如何创建 实现等细节

- 强调一系列相关的产品对象
- 提供一个产品的库，所有的产品以同样的接口出现从而使得客户端不依赖具体的实现

优点：

- 具体产品在应用层的代码隔离、无需关心创建细节
- 将一个系列的产品统一到一起创建

缺点：

- 规定了所有可能被创建的产品集合、产品族中扩展新的产品困难
- 增加了系统的抽象性和理解难度



根据设计原则：工厂方法模式

根据实际业务：简单工厂模式

小结：

简单工厂模式（静态工厂模式）

- 虽然某种程度上不符合设计原则、但实际使用最多

工厂方法模式

- 不修改已有类的前提下、通过增加新的工厂类实现扩展

抽象工厂模式：

- 不可以增加产品、可以增加产品族

**应用场景**

- JDK中`Calendar`的`getInstance`方法
- JDBC中的Connection 对象的获取
- Spring中IOC容器创建管理bean对象
- 反射中Class对象newinstance 方法
- 

## [狂神的设计模式笔记-代理模式](https://www.cnblogs.com/theory/p/13338734.html)

[设计模式](https://www.cnblogs.com/theory/p/13338734.html)

