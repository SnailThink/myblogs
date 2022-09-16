## @Autowired 和 @Resource 注解区别

[注解区别](https://mp.weixin.qq.com/s/9cKCg3irlAf2CnWKix8bMw)

>大家在使用IDEA开发的时候有没有注意到过一个提示，在字段上使用Spring的依赖注入注解`@Autowired`后会出现警告，但是使用`@Resource`却不会出现，今天我们来聊聊这两者的区别。

@Autowired 和 @Resource 都是 Spring/Spring Boot 项目中，用来进行依赖注入的注解。它们都提供了将依赖对象注入到当前对象的功能，但二者却有众多不同，并且这也是常见的面试题之一，所以我们今天就来盘它。@Autowired 和 @Resource 的区别主要体现在以下 5 点：

1. 来源不同；
2. 依赖查找的顺序不同；
3. 支持的参数不同；
4. 依赖注入的支持不同；
5. 编译器 IDEA 的提示不同。

### 1.来源不同

**@Autowired 和 @Resource 来自不同的“父类”，其中 @Autowired 是 Spring 定义的注解，而 @Resource 是 Java 定义的注解，它来自于 JSR-250（Java 250 规范提案）。**

> 小知识：JSR 是 Java Specification Requests 的缩写，意思是“Java 规范提案”。任何人都可以提交 JSR 给 Java 官方，但只有最终确定的 JSR，才会以 JSR-XXX 的格式发布，如 JSR-250，而被发布的 JSR 就可以看作是 Java 语言的规范或标准。

### 2.依赖查找顺序不同

**@Autowired 是先根据类型（byType）查找，如果存在多个 Bean 再根据名称（byName）进行查找**，它的具体查找流程如下：

![640](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/640.png)

关于以上流程，可以通过查看 Spring 源码中的 org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor#postProcessPropertyValues 实现分析得出，源码执行流程如下图所示：

![640 (1)](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/640%20(1).png)

#### **2.2 @Resource 查找顺序**

**@Resource 是先根据名称查找，如果（根据名称）查找不到，再根据类型进行查找**，它的具体流程如下图所示：

![640 (2)](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/640%20(2).png)

关于以上流程可以在 Spring 源码的 org.springframework.context.annotation.CommonAnnotationBeanPostProcessor#postProcessPropertyValues 中分析得出。虽然 @Resource 是 JSR-250 定义的，但是由 Spring 提供了具体实现，它的源码实现如下：

![640 (3)](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/640%20(3).png)

#### **2.3 查找顺序小结**

由上面的分析可以得出：

- **@Autowired 先根据类型（byType）查找，如果存在多个（Bean）再根据名称（byName）进行查找；**
- **@Resource 先根据名称（byName）查找，如果（根据名称）查找不到，再根据类型（byType）进行查找。**

### 3.支持的参数不同

@Autowired 和 @Resource 在使用时都可以设置参数，比如给 @Resource 注解设置 name 和 type 参数，实现代码如下：

```java
@Resource(name = "userinfo", type = UserInfo.class)
private UserInfo user;
```



但**二者支持的参数以及参数的个数完全不同，其中 @Autowired 只支持设置一个 required 的参数，而 @Resource 支持 7 个参数**，支持的参数如下图所示：

![image-20220916150742512](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220916150742512.png)

![image-20220916150748988](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220916150748988.png)

### 4.依赖注入的支持不同

@Autowired 和 @Resource 支持依赖注入的用法不同，常见依赖注入有以下 3 种实现：

1. 属性注入
2. 构造方法注入
3. Setter 注入

这 3 种实现注入的实现代码如下。

**a) 属性注入**

```java
@RestController
public class UserController {
    // 属性注入
    @Autowired
    private UserService userService;

    @RequestMapping("/add")
    public UserInfo add(String username, String password) {
        return userService.add(username, password);
    }
}
```

**b) 构造方法注入**

```java
@RestController
public class UserController {
    // 构造方法注入
    private UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @RequestMapping("/add")
    public UserInfo add(String username, String password) {
        return userService.add(username, password);
    }
}
```

**c) Setter 注入**

```java
@RestController
public class UserController {
    // Setter 注入
    private UserService userService;

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @RequestMapping("/add")
    public UserInfo add(String username, String password) {
        return userService.add(username, password);
    }
}
```

其中，**@Autowired 支持属性注入、构造方法注入和 Setter 注入，而 @Resource 只支持属性注入和 Setter 注入**，当使用 @Resource 实现构造方法注入时就会提示以下错误：

![image-20220916150856821](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220916150856821.png)

### 5.编译器提示不同

**当使用 IDEA 专业版在编写依赖注入的代码时，如果注入的是 Mapper 对象，那么使用 @Autowired 编译器会提示报错信息**，报错内容如下图所示：

![image-20220916150914660](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220916150914660.png)

虽然 IDEA 会出现报错信息，但程序是可以正常执行的。然后，我们再**将依赖注入的注解更改为 @Resource 就不会出现报错信息了**，具体实现如下：

![image-20220916150925005](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220916150925005.png)

## 总结

@Autowired 和 @Resource 都是用来实现依赖注入的注解（在 Spring/Spring Boot 项目中），但二者却有着 5 点不同：

1. 来源不同：@Autowired 来自 Spring 框架，而 @Resource 来自于（Java）JSR-250；
2. 依赖查找的顺序不同：@Autowired 先根据类型再根据名称查询，而 @Resource 先根据名称再根据类型查询；
3. 支持的参数不同：@Autowired 只支持设置 1 个参数，而 @Resource 支持设置 7 个参数；
4. 依赖注入的用法支持不同：@Autowired 既支持构造方法注入，又支持属性注入和 Setter 注入，而 @Resource 只支持属性注入和 Setter 注入；
5. 编译器 IDEA 的提示不同：当注入 Mapper 对象时，使用 @Autowired 注解编译器会提示错误，而使用 @Resource 注解则不会提示错误。
