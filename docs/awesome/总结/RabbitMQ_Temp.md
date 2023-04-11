

## RabbitMQ

**AMQP:消息队列协议:**

AMQP定义:是具有现代特征的二进制协议。是一个提供统一消息服务的应用层标准高级消息队列协议，是应用层协议的- -个开放标准，为面向消息的中间件设计。

**AMQP:协议模型**

![image-20220623095916476](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220623095916476.png)



**AMQP:核心概念**

Binding: Exchange和Queue之间的虚拟连接，binding中可以包含routing key

Routing key: 一个路由规则，虚拟机可用它来确定如何路由一个特定消息

Queue:也称为Message Queue,消息队列，保存消息并将它们转发给消费者



#### 1.命令行与管控台

- rabbitmqctl stop_ app:关闭应用
- rabbitmqctl start_ app:启动应用
- rabbitmqctl status:节点状态
- rabbitmqctl add_user username password 添加用户
- rabbitmqctl list_users: 列出所有用户
- rabbitmqctl delete_user  username 删除用户
- rabbitmqctl clear_ permissions -p vhostpath username : 删除用户权限
- rabbitmqctl list_ user_ permissions username:列出用户
- rabbitmqctl change_ password username newpassword 修改用户密码
- rabbitmqctl set_ permissions -p vhostpath username ".*"  ".*"  ".*" 设置用户权限
- rabbitmqctl add_ vhost vhostpath:创建虚拟主机
- rabbitmqctl list vhosts:列出所有虚拟主机
- rabbitmqctl list_ permissions -p vhostpath:列出虚拟主机
- rabbitmqctl delete. vhost vhostpath:删除虚拟主机
- rabbitmqctl list_ queues: 查看所有队列信息
- rabbitmqctl -p vhostpath purge_ queue blue:清除队列里的消息
- rabbitmqctl reset 移除所有的数据



#### 2.消息生产以及消费



ConnectionFactory ：连接工厂

Connection：连接

Channel ：数据通信信道 发送接收消息

Queue：具体的消息存储队列

Producer& Consumer 生产和消费者



#### 3.Exchange ：交换机

**接收消息：并根据路由键转发消息所绑定的队列**

![image-20220623111106850](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220623111106850.png)

##### **交换机属性**

Name:交换机名称

Type:交换机类型direct. topic、 fanout、 headers

Durability:是否需要持久化，true为持久化

Auto Delete:当最后一个绑定到Exchange. 上的队列删除后，自动删除该Exchange

Internal:当前Exchange是否用于RabbitMQ内部使用，默认为False

Arguments:扩展参数，用于扩展AMQP协议自制定化使用

##### **Direct Exchange**

所有发送到Direct Exchange的消息被转发到RouteKey中指定的Queue

![image-20220623111502333](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220623111502333.png)

##### Topic Exchange

所有发送到Topic Exchange的消息被转发到所有关心RouteKey中指定Topic的Queue上.

Exchange将RouteKey和某Topic进行模糊匹配，此时队列需要绑定一个Topic

可以使用通配符 进行模糊匹配

符号 "#" 匹配一个或者多个词

符号 "*" 只能匹配一个词

![image-20220623114421436](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220623114421436.png)



##### Fanout Exchange

不处理路由键，只需要简单的将队列绑定到交换机上发送到交换机的消息都会被转发到与该交换机绑定的所有队列上

Fanout交换机转发消息是最快的。

![image-20220623114644433](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220623114644433.png)

##### Binding-绑定

Exchange和Exchange、Queue之 间的连接关系

Binding中可以包含RoutingKey或者参数

##### **Queue -消息队列**

消息队列，实际存储消息数据

Durability:是否持久化，Durable: 是，Transient: 否

Auto delete:如选yes, 代表当最后- -个监听被移除之后, 该Queue会自动被删除

##### Message 消息

服务器和应用程序之间传送的数据

本质上就是一-段数据，由Properties和Payload ( Body )组成

常用属性: delivery mode、headers (自定义属性)

##### **Message-其他属性**

content_type、 content_encoding、 priority

correlation_id、reply_to、expiration、 message_id

timestamp、 type、 user_id、 app_id、 cluster_id

#### 参考

[RabbitMQ详解析](https://mp.weixin.qq.com/s/qFVDy_uBT0SlPMFzti9Urw)

