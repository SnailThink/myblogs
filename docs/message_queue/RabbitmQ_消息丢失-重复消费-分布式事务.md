# RabbitMQ如何保证消息的可靠性



### 一、首先看一下RabbitMQ为什么不可靠


RabbitMQ丢失的以下3种情况：

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531093820.png)

（1）生产者方面：生产者发送消息至MQ的数据丢失

（2）RabbitMQ方面：MQ收到消息，暂存内存中，还没消费，自己挂掉，数据会都丢失

（3）消费者方面：消费者刚拿到消息，还没处理，挂掉了，MQ又以为消费者处理完



### 二、RabbitMQ消息丢失

通过上诉我们知道RabbitMQ共有3处不可靠问题。

（1）生产者方面：生产者发送消息至MQ的数据丢失

（2）RabbitMQ方面：MQ收到消息，暂存内存中，还没消费，自己挂掉，数据会都丢失

（3）消费者方面：消费者刚拿到消息，还没处理，挂掉了，MQ又以为消费者处理完

我们针对这几方问题分别列出解决方案。

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531093855.png)

（1）生产者方面：有两种方案，**一是开启RabbitMQ事务（不推荐），二是开启confirm模式（异步，推荐）三是重试 （不推荐）**

**A.开启RabbitMQ事务**

AMQP协议提供了事务机制，在投递消息时开启事务支持，如果消息投递失败，则回滚事务。



```java
1.自定义事务管理器
@Configuration
public class RabbitTranscation {
    
    @Bean
    public RabbitTransactionManager rabbitTransactionManager(ConnectionFactory connectionFactory){
        return new RabbitTransactionManager(connectionFactory);
    }
@Bean
    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory){
        return new RabbitTemplate(connectionFactory);
    }
}
 
2.修改yml
spring:
  rabbitmq:
    # 消息在未被队列收到的情况下返回
    publisher-returns: true
 
3.开启事务支持
rabbitTemplate.setChannelTransacted(true);
 
4.消息未接收时调用ReturnCallback
rabbitTemplate.setMandatory(true);
 
5.生产者投递消息
@Service
public class ProviderTranscation implements RabbitTemplate.ReturnCallback {
@Autowired
    RabbitTemplate rabbitTemplate;
@PostConstruct
    public void init(){
        // 设置channel开启事务
        rabbitTemplate.setChannelTransacted(true);
        rabbitTemplate.setReturnCallback(this);
    }
    
    @Override
    public void returnedMessage(Message message, int replyCode, String replyText, String exchange, String routingKey) {
        System.out.println("这条消息发送失败了"+message+",请处理");
    }
    
    @Transactional(rollbackFor = Exception.class,transactionManager = "rabbitTransactionManager")
    public void publishMessage(String message) throws Exception {
        rabbitTemplate.setMandatory(true);
        rabbitTemplate.convertAndSend("javatrip",message);
    }
}
```

但是，很少有人这么干，因为这是同步操作，一条消息发送之后会使发送端阻塞，以等待RabbitMQ-Server的回应，之后才能继续发送下一条消息，生产者生产消息的吞吐量和性能都会大大降低。

**B.开启confirm模式**

发送消息时将信道设置为confirm模式，消息进入该信道后，都会被指派给一个唯一ID，一旦消息被投递到所匹配的队列后，RabbitMQ就会发送给生产者一个确认。

```java
1.开启消息确认机制
spring:
  rabbitmq:
    # 消息在未被队列收到的情况下返回
    publisher-returns: true
    # 开启消息确认机制
    publisher-confirm-type: correlated
 
2.消息未接收时调用ReturnCallback
rabbitTemplate.setMandatory(true);
 
3.生产者投递消息
@Service
public class ConfirmProvider implements RabbitTemplate.ConfirmCallback,RabbitTemplate.ReturnCallback {
@Autowired
    RabbitTemplate rabbitTemplate;
@PostConstruct
    public void init() {
        rabbitTemplate.setReturnCallback(this);
        rabbitTemplate.setConfirmCallback(this);
    }
@Override
    public void confirm(CorrelationData correlationData, boolean ack, String cause) {
        if(ack){
            System.out.println("确认了这条消息："+correlationData);
        }else{
            System.out.println("确认失败了："+correlationData+"；出现异常："+cause);
        }
    }
@Override
    public void returnedMessage(Message message, int replyCode, String replyText, String exchange, String routingKey) {
        System.out.println("这条消息发送失败了"+message+",请处理");
    }
public void publisMessage(String message){
        rabbitTemplate.setMandatory(true);
        rabbitTemplate.convertAndSend("javatrip",message);
    }
}
 
4.如果消息确认失败后，我们可以进行消息补偿，也就是消息的重试机制。当未收到确认信息时进行消息的重新投递。设置如下配置即可完成。
spring:
  rabbitmq:
    # 支持消息发送失败后重返队列
    publisher-returns: true
    # 开启消息确认机制
    publisher-confirm-type: correlated
    listener:
      simple:
        retry:
          # 开启重试
          enabled: true
          # 最大重试次数
          max-attempts: 5
          # 重试时间间隔
```

**C.监听重试 不推荐**

引入依赖 starter

```xml
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-amqp</artifactId>
    </dependency>
```

配置文件

```java
rabbitmq:
    publisher-returns: true
    publisher-confirm-type: correlated #新版本 publisher-confirms: true 已过时
```

然后编写监听回调

```java
@Configuration
@Slf4j
public class RabbitMQConfig {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @PostConstruct
    public void enableConfirmCallback() {
        //confirm 监听，当消息成功发到交换机 ack = true，没有发送到交换机 ack = false
        //correlationData 可在发送时指定消息唯一 id
        rabbitTemplate.setConfirmCallback((correlationData, ack, cause) -> {
            if(!ack){
                //记录日志、发送邮件通知、落库定时任务扫描重发
            }
        });
        
        //当消息成功发送到交换机没有路由到队列触发此监听
        rabbitTemplate.setReturnsCallback(returned -> {
            //记录日志、发送邮件通知、落库定时任务扫描重发
        });
    }
}

```

测试的时候可以在发送消息时故意写错交换机、路由键的名称，然后就会回调到我们刚刚写的监听方法， cause 会给我们展示具体没有发到交换机的原因；returned 对象中包含了消息相关信息。





(2)RabbitMQ方面：**开启RabbitMQ持久化，将内存数据持久化到磁盘中。**

创建队列的时候将持久化属性durable设置为true，同时要将autoDelete设置为false

```java
@Queue(value = "javatrip",durable = "false",autoDelete = "false")
```

***\*持久化消息\****

发送消息的时候将消息的deliveryMode设置为2，在Spring Boot中消息默认就是持久化的。

（3）消费者方面：**关闭RabbitMQ自动ACK**

消费者刚消费了消息，还没有处理业务，结果发生异常。这时候就需要关闭自动确认，改为手动确认消息

```java
1.修改yml为手动签收模式
spring:
  rabbitmq:
    listener:
      simple:
        # 手动签收模式
        acknowledge-mode: manual
        # 每次签收一条消息
        prefetch: 1
 
 
2.消费者手动签收
@Component
@RabbitListener(queuesToDeclare = @Queue(value = "javatrip", durable = "true"))
public class Consumer {
@RabbitHandler
    public void receive(String message, @Headers Map<String,Object> headers, Channel channel) throws Exception{
System.out.println(message);
        // 唯一的消息ID
        Long deliverTag = (Long) headers.get(AmqpHeaders.DELIVERY_TAG);
        // 确认该条消息
        if(...){
            channel.basicAck(deliverTag,false);
        }else{
            // 消费失败，消息重返队列
            channel.basicNack(deliverTag,false,true);
        }
      
    }
```



### 三、RabbitMQ幂等问题

幂等性问题通俗点讲就是保证数据不被重复消费，同时数据也不能少（就是上述的可靠性），也就是数据一致性问题。

数据重复的问题简单的多，就是在消费端判断数据是否已经被消费过



1. 比如你拿个数据要写库，你先根据主键查一下，如果这数据都有了，你就别插入了，update 一下好吧。
2. 比如你是写 Redis，那没问题了，反正每次都是 set，天然幂等性。
3. 比如你不是上面两个场景，那做的稍微复杂一点，你需要让生产者发送每条数据的时候，里面加一个全局唯一的 id，类似订单 id 之类的东西，然后你这里消费到了之后，先根据这个 id 去比如 Redis 里查一下，之前消费过吗？如果没有消费过，你就处理，然后这个 id 写 Redis。如果消费过了，那你就别处理了，保证别重复处理相同的消息即可。
4. 比如基于数据库的唯一键来保证重复数据不会重复插入多条。因为有唯一键约束了，重复数据插入只会报错，不会导致数据库中出现脏数据。



### 四、顺序消费

#### 单个消费者实例

其实队列本身是有顺序的，但是生产环境服务实例一般都是集群，当消费者是多个实例时，队列中的消息会分发到所有实例进行消费（同一个消息只能发给一个消费者实例），这样就不能保证消息顺序的消费，因为你不能确保哪台机器执行消费端业务代码的速度快

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531093927.webp)



![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531093944.png)

所以对于需要保证顺序消费的业务，我们可以只部署一个消费者实例，然后设置 RabbitMQ 每次只推送一个消息，再开启手动 ack 即可，配置如下

```yml
spring:
  rabbitmq:
    listener:
      simple:
        prefetch: 1 #每次只推送一个消息
        acknowledge-mode: manual
```

这样 RabbitMQ 每次只会从队列推送一个消息过来，处理完成之后我们 ack 回应，再消费下一个，就能确保消息顺序性。



#### 多个消费者实例

- todo、使用Hash



![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531093955.png)



### 五、分布式事务

了解分布式事务之前先回顾下之前的事务

**特征**

>事务是恢复和并发控制的基本单位。
>
>事务应该具有4个属性：**原子性、一致性、隔离性、持久性**。这四个属性通常称为**ACID特性**。
>
>**原子性（atomicity）**：一个事务是一个不可分割的工作单位，事务中包括的操作要么都做，要么都不做。
>
>**一致性（consistency）**：事务必须是使数据库从一个一致性状态变到另一个一致性状态。一致性与原子性是密切相关的。
>
>**隔离性（isolation）**：一个事务的执行不能被其他事务干扰。即一个事务内部的操作及使用的数据对并发的其他事务是隔离的，并发执行的各个事务之间不能互相干扰。
>
>**持久性（durability）**：**持久性也称永久性（permanence）**，指一个事务一旦提交，它对数据库中数据的改变就应该是永久性的。接下来的其他操作或故障不应该对其有任何影响。



布式事务大概分为：

- 2pc（两段式提交）
- 3pc（三段式提交）



![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094008.png)



![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094020.png)



>分布式事务 
>
>1.写入订单信息 id=10 add   service A
>
>1.1 写入信息成功后 向消息队列发送消息 [但是先不提交事务]
>
>2.扣减库存中的数据id=10  update  service B
>
>2.1 更新数据成功后先不提交事务 发送消息到消息队列
>
>3. 消息队列发现 订单和库存都成功后
>查询消息队列消息 [当消息队列都成功后 进行提交事务]
>查询消息队列消息 [当消息队列有一个失败 进行回滚事务] 订单和库存都要进行回滚事务


### 六、流程图

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531094030.png)

###  参考地址

[RabbitMQ如何保证消息的可靠性](https://suncat.blog.csdn.net/article/details/115266246)

[RabbitMQ重复顺序消费](https://juejin.cn/post/6977981645475282958#heading-9)

