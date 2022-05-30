## **Zookeeper包中 slf4j-log4j12和log4j冲突问题解决**

### 问题：引入com.101tec 包冲突

主要是因为Zookeeper包中，slf4j-log4j12和log4j冲突了，需要处理一下

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530180956.png)





### 解决方案：剔除依赖

在服务提供者和消费中的pom.xml文件的ZooKeeper依赖中添加如下内容

```xml
<dependency>
   <groupId>com.101tec</groupId>
   <artifactId>zkclient</artifactId>
   <version>0.10</version>
          <exclusions>
              <exclusion>
                  <groupId>log4j</groupId>
                  <artifactId>log4j</artifactId>
              </exclusion>
              <exclusion>
                  <groupId>org.slf4j</groupId>
                  <artifactId>slf4j-log4j12</artifactId>
              </exclusion>
          </exclusions>
</dependency>
```







### 