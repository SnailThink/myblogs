## SpringBoot—环境切换

>作者：知否派
>博客地址: [https://snailthink.github.io/myblogs](https://snailthink.github.io/myblogs)
>项目地址：[spring-boot-learning](https://gitee.com/VincentBlog/spring-boot-learning.git)
>文章所涉及的资料来自互联网整理和个人总结，意在于个人学习和经验汇总，如有什么地方侵权，请联系本人删除，谢谢！


## 前言

在实际开发过程中，一般会有三个环境，本地环境，dev环境，prod环境，因为三个环境的配置都是不一样的我们应该如何实现呢？

---

`提示：以下是本篇文章正文内容，下面案例可供参考`

### 一、配置文件可以放在哪里

[查看配置文件存在路径](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-external-config)

**查看配置文件优先级**

![image-20220803183325938](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803183325938.png)



### 二、多环境配置

**在config文件夹下增加三个文件如下图所示**

![image-20220803183737738](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220803183737738.png)

#### 2.1 方式一

**application.properties**

```properties
server.port= 9993
#指定开启哪个环境
spring.profiles.active=dev
```

**application-dev.properties**

```properties
server.port= 9992
```

**application-prod.properties**

```properties
server.port= 9991
```

#### 2.2 方式二

**application.yaml**

```yml

#选择要激活那个环境块
spring:
  profiles:
  active: dev
---
server:
  port: 9992
spring:
  profiles: dev #配置环境的名称
---
server:
  port: 9993
spring:
  profiles: prod #配置环境的名称
```

**注意：如果yml和properties同时都配置了端口，并且没有激活其他环境 ， 默认会使用properties配置文件的！**

##  公众号

如果大家想要实时关注我更新的文章以及分享的干货的话，可以关注我的公众号。
<img src="https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220507200900.jpg" style="zoom:50%;" />



