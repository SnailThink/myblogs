## 最详细的RabbitMQ介绍

### 一、RabbitMQ是什么
RabbitMQ是一个由erlang语言编写的、开源的、在AMQP基础上完整的、可复用的企业消息系统。支持多种语言，包括java、Python、ruby、PHP、C/C++等。

备注：

(1)MQ：MQ是 message queue 的简称，是应用程序和应用程序之间通信的方法。

(2)AMQP：advanced message queuing protocol ，一个提供统一消息服务的应用层标准高级消息队列协议，是应用层协议的一个开放标准，为面向消息的中间件设计。基于此协议的客户端与消息中间件可传递消息并不受客户端/中间件不同产品、不同开发语言等条件的限制。


### 二、RabbitMQ的核心概念
生产者（Producer）：发送消息的应用。

消费者（Consumer）：接收消息的应用。

队列（Queue）：存储消息的缓存。

消息（Message）：由生产者通过RabbitMQ发送给消费者的信息。

连接（Connection）：连接RabbitMQ和应用服务器的TCP连接。

通道（Channel）：连接里的一个虚拟通道。当你通过消息队列发送或者接收消息时，这个操作都是通过通道进行的。

交换机（Exchange）：交换机负责从生产者那里接收消息，并根据交换类型分发到对应的消息列队里。要实现消息的接收，一个队列必须到绑定一个交换机。

绑定（Binding）：绑定是队列和交换机的一个关联连接。

路由键（Routing Key）：路由键是供交换机查看并根据键来决定如何分发消息到列队的一个键。路由键可以说是消息的目的地址。

### 三、RabbitMQ五种消息发送模式
生产者（Producer）发送->中间件->消费者（Consumer）接收消息。

RabbitMQ包括五种队列模式，简单队列、工作队列、发布/订阅、路由、主题、rpc等。

#### **1、简单队列**

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094418.png)

**总结**

P：生产者，也就是要发送消息的程序

C：消费者：消息的接受者，会一直等待消息到来。

queue：消息队列，图中红色部分。类似一个邮箱，可以缓存消息；生产者向其中投递消息，消费者从其中取出消息。

**模式总结：**一个生产者、一个消费者，不需要设置交换机（使用默认的交换机）

#### **2、工作队列**

（1）一个生产者，多个消费者。

（2）一个消息发送到队列时，只能被一个消费者获取。

（3）多个消费者并行处理消息，提升消息处理速度。

> 注意:channel.basicQos(1)表示同一时刻只发送一条消息给消费者。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094445.png)

**总结**

P：生产者，也就是要发送消息的程序

C：消费者：消息的接受者，会一直等待消息到来。

queue：消息队列，图中红色部分。类似一个邮箱，可以缓存消息；生产者向其中投递消息，消费者从其中取出消息。

**模式总结：**一个生产者、多个消费者（竞争关系），不需要设置交换机（使用默认的交换机）**



#### **3、发布/订阅模式(Publish/Subcribe)**

将消息发送到交换机，队列从交换机获取消息，队列需要绑定到交换机。

（1）一个生产者，多个消费者。

（2）每一个消费者都有自己的一个队列。

（3）生产者没有将消息直接发送到队列，而是发送到交换机。

（4）每一个队列都要绑定到交换机。

（5）生产者发送的消息，经过交换机到达队列，实现一个消息被多个消费者获取的目的。

（6）交换机类型为“fanout”。

>  注意：交换机本身没有存储消息的能力，消息只能存储到队列中。

![image-20220930165834532](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220930165834532.png)

**总结：**

P：生产者，也就是要发送消息的程序

X：Exchange（交换机），接收生产者的消息

C：消费者：消息的接受者，会一直等待消息到来。

queue：消息队列，图中红色部分。类似一个邮箱，可以缓存消息；生产者向其中投递消息，消费者从其中取出消息。

**模式总结：**需要设置类型为fanout的交换机，并且交换机和队列进行绑定，当发送消息到交换机后，交换机会将消息发送到绑定的队列







#### **4、路由模式（Routing）**

路由模式是发布/订阅模式的一种特殊情况。

（1）路由模式的交换机类型为“direct”。

（2）绑定队列到交换机时指定 key，即路由键，一个队列可以指定多个路由键。

（3）生产者发送消息时指定路由键，这时，消息只会发送到绑定的key的对应队列中。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094505.png)

P：生产者，向Exchange发送消息，发送消息时，会指定一个routing key。

X：Exchange（交换机），接收生产者的消息，然后把消息递交给 与routing key完全匹配的队列

C1：消费者，其所在队列指定了需要routing key 为 error 的消息

C2：消费者，其所在队列指定了需要routing key 为 info、error、warning 的消息

**模式总结：**需要设置类型为direct的交换机，交换机和队列进行绑定，并且指定routing key，当发送消息到交换机后，交换机会根据routing key将消息发送到对应的队列









#### 5、主题模式（Topic）

将路由键和某模式进行匹配。此时，队列需要绑定到一个模式上。

符号“#”匹配一个或多个词，“*”匹配不多不少一个词。

 绑定队列到交换机指定key时，进行通配符模式匹配。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094516.png)

Routingkey 一般都是有一个或多个单词组成，多个单词之间以”.”分割，例如： item.insert

通配符规则：

​	\#：匹配零个或多个词

​	*：匹配不多不少恰好1个词

举例：

item.#：能够匹配item.insert.abc 或者 item.insert

item.*：只能匹配item.insert

**模式总结：**需要设置类型为topic的交换机，交换机和队列进行绑定，并且指定通配符方式的routing key，当发送消息到交换机后，交换机会根据routing key将消息发送到对应的队列







### 四、RabbitMQ四种交换机

有4种不同的交换机类型：

扇形交换机：Fanout exchange
直连交换机：Direct exchange
主题交换机：Topic exchange
首部交换机：Headers exchange

#### （1）扇形交换机
扇形交换机是最基本的交换机类型，它所能做的事情非常简单———广播消息。

扇形交换机会把能接收到的消息全部发送给绑定在自己身上的队列。

因为广播不需要“思考”，所以扇形交换机处理消息的速度也是所有的交换机类型里面最快的。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094527.png)



#### （2）直连交换机
直连交换机是一种带路由功能的交换机，一个队列会和一个交换机绑定，除此之外再绑定一个routing_key，

当消息被发送的时候，需要指定一个binding_key，这个消息被送达交换机的时候，

就会被这个交换机送到指定的队列里面去。同样的一个binding_key也是支持应用到多个队列中的。

这样当一个交换机绑定多个队列，就会被送到对应的队列去处理。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094552.png)

#### （3）主题交换机
发送到主题交换机上的消息需要携带指定规则的routing_key，

主题交换机会根据这个规则将数据发送到对应的(多个)队列上。

主题交换机的routing_key需要有一定的规则，交换机和队列的binding_key需要采用*.#.*.....的格式，每个部分用.分开，其中：

- 表示一个单词
- 表示任意数量（零个或多个）单词。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094603.png)


当一个队列的绑定键为#的时候，这个队列将会无视消息的路由键，接收所有的消息。

#### （4）首部交换机
定义一个Hash的数据结构，消息发送的时候，会携带一组hash数据结构的信息，

当Hash的内容匹配上的时候，消息就会被写入队列

绑定交换机和队列的时候，Hash结构中要求携带一个键“x-match”，这个键的Value可以是any或者all，这代表消息携带的Hash是需要全部匹配(all)，还是仅匹配一个键(any)就可以了。相比直连交换机，首部交换机的优势是匹配的规则不被限定为字符串(string)。

### 五、RabbitMQ集群架构模式
有以下几种：

主备模式
远程模式
镜像模式
多活模式
（1）主备模式：
就是一个主/备方案（主节点如果挂了，从节点提供服务而已）

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094617.png)

HaProxy配置：

```java
  listen rabbitmq_cluster
  bind 0.0.0.0:5672 
  mode tcp  #配置TCP模式
  balance roundrobin #简单的轮询
  server bhz76 192.168.11.12:5672 check inter 5000 rise 2 fall 3 #主节点
  server bhz77 192.168.11.13:5672 backup check inter 5000 rise 2 fall 3 #备用节点
```


备注：rabbitmq集群节点配置 #inter 每隔5秒对mq集群做健康检查，2次正确证明服务器可用，3次失败证明服务器不可用，并且配置主备机制

（2）远程模式（不常用）
远距离通信和复制，就是我们可以把消息进行不同数据中心的复制工作，我们可以跨地域的让两个mq集群互联。

模型变成了近端同步确认，远端异步确认方式，大大提高了订单确认速度，并且还能保证可靠性。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094628.png)

（3）镜像模式（常用）
就是实现数据的同步，一般来讲是2-3个实现数据同步（对于100%数据可靠性解决方案一般是3个节点）

，保证100%数据不丢失，在实际工作中用的最多的。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094640.png)

（4）多活模式
采用双中心模式（多中心），那么在两套（或多套）数据中心中各部署一套RabbitMQ集群，各中心之间还需要实现部分队列消息共享。

实现异地数据复制的主流模式，

因为远程模式配置比较复杂，所以一般来说实现异地集群都是使用双活或者多活模式来实现的。

这种模式需要依赖rabbitmq的federation插件，可以实现继续的可靠AMQP数据通信，多活模式在实际配置与应用非常的简单。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094651.png)

备注：

（1）主备模式和主从模式的区别：

主备模式：主节点提供读写，从节点不提供读写服务，只是负责提供备份服务,备份节点的主要功能是在主节点宕机时，完成自动切换 从-->主

主从模式：主节点提供读写，从节点只读

（2）Federation插件

Federation插件是一个不需要构建Cluster，而在Brokers之间传输消息的高性能插件，

Federation插件可以在Brokers或者Cluster之间传输消息，连接双方可以使用不同的users和vistual hosts，

双方也可以使用版本不同的RabbitMQ和Erlang。Federation插件使用AMQP协议通信，可以接收不连续的传输。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094702.png)

Federation Exchanges,可以看成Downstream从Upstream主动拉取消息，但并不是拉取所有消息，

必须是在Downstream上已经明确定义Bindings关系的Exchange，也就是有实际的物理Queue来接收消息，才会从Upstream拉取消息到Downstream。

使用AMQP协议实施代理间通信，Downstream会将绑定关系组合在一起，绑定/解绑命令将会发送到Upstream交换机。

因此，FederationExchange只接收具有订阅的消息。

### 参考
[RabbitMq介绍](https://blog.csdn.net/github_37130188/article/details/115289346)