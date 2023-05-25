# EMQX的安装以及使用说明



MQTT属于是物联网的通信协议，在MQTT协议中有两大角色：客户端（发布者/订阅者），服务端（Mqtt
broker）；针对客户端和服务端需要有遵循该协议的的具体实现，EMQ/EMQ X就是MQTT Broker的一种实现。

## 1.EMQ X是什么

EMQ X 基于 Erlang/OTP 平台开发的 MQTT 消息服务器，是开源社区中最流行的 MQTT 消息服务器。EMQ X 是开源百万级分布式 MQTT 消息服务器（MQTT Messaging Broker），用于支持各种接入标准 MQTT

协议的设备，实现从设备端到服务器端的消息传递，以及从服务器端到设备端的设备控制消息转发。从而实现物联
网设备的数据采集，和对设备的操作和控制。

## 2.为什么选择EMQ X

**到目前为止，比较流行的 MQTT Broker 有几个：**

• 1. Eclipse Mosquitto: https://github.com/eclipse/mosquitto

使用 C 语言实现的 MQTT Broker。Eclipse 组织还还包含了大量的 MQTT 客户端项目：https://www.eclipse.org/paho/#

• 2. EMQX: https://github.com/emqx/emqx使用 Erlang 语言开发的 MQTT Broker，支持许多其他 IoT 协议比如 CoAP、LwM2M 等

• 3. Mosca: https://github.com/mcollina/mosca使用 Node.JS 开发的 MQTT Broker，简单易用。

• 4. VerneMQ: https://github.com/vernemq/vernemq同样使用 Erlang 开发的 MQTT Broker

从支持 MQTT5.0、稳定性、扩展性、集群能力等方面考虑，EMQX 的表现应该是最好的。

**与别的MQTT服务器相比EMQ X 主要有以下的特点：**

• 经过100+版本的迭代，EMQ X 目前为开源社区中最流行的 MQTT 消息中间件，在各种客户严格的生产环境上经受了严苛的考验；

• EMQ X 支持丰富的物联网协议，包括 MQTT、MQTT-SN、CoAP、 LwM2M、LoRaWAN 和 WebSocket等；

• 优化的架构设计，支持超大规模的设备连接。企业版单机能支持百万的 MQTT 连接；集群能支持千万级别的 MQTT 连接；

• 易于安装和使用；

• 灵活的扩展性，支持企业的一些定制场景；

• 中国本地的技术支持服务，通过微信、QQ等线上渠道快速响应客户需求；

• 基于 Apache 2.0 协议许可，完全开源。EMQ X 的代码都放在 Github 中，用户可以查看所有源代码。

• EMQ X 3.0 支持 MQTT 5.0 协议，是开源社区中第一个支持 5.0协议规范的消息服务器，并且完全兼容MQTT V3.1 和 V3.1.1 协议。除了 MQTT 协议之外，EMQ X 还支持别的一些物联网协议

• 单机支持百万连接，集群支持千万级连接；毫秒级消息转发。EMQ X 中应用了多种技术以实现上述功能，

• 扩展模块和插件，EMQ X 提供了灵活的扩展机制，可以实现私有协议、认证鉴权、数据持久化、桥接转发和管理控制台等的扩展

• 桥接：EMQ X 可以跟别的消息系统进行对接，比如 EMQ X Enterprise 版本中可以支持将消息转发到Kafka、RabbitMQ 或者别的 EMQ 节点等

• 共享订阅：共享订阅支持通过负载均衡的方式在多个订阅者之间来分发 MQTT 消息。比如针对物联网等数据采集场景，会有比较多的设备在发送数据，通过共享订阅的方式可以在订阅端设置多个订阅者来实现这几个订阅者之间的工作负载均衡



## 3.EMQ X服务端环境搭建与配置



## 4.Java使用说明

```java
package com.whcoding.wheels.schedule.mqtt;

import lombok.extern.slf4j.Slf4j;
import org.eclipse.paho.client.mqttv3.*;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

/**
 * @author whcoding
 * @Description mqtt消费
 * @Date 2023/05/10 10:00
 * 参考:https://www.kuangstudy.com/bbs/1401763436836229121
 */
@Component
@Slf4j
public class MqttConsumer implements ApplicationRunner {

    private static MqttClient client;

    /**
     * userame
     */
    @Value("${mqtt.userame}")
    private String MQTT_USER_NAME;

    /**
     * password
     */
    @Value("${mqtt.password}")
    private String MQTT_PASS_WORD;

    /**
     * topic
     */
    @Value("${mqtt.topic:test-dev-topic/#}")
    private String topic;

    /**
     * qos2消耗较大，请使用1或0
     */
    @Value("${mqtt.qos:1}")
    private Integer qos;
    /**
     * MQTT 服务器地址
     */
    @Value("${mqtt.broker:mqtt://broker.emqx.io}")
    private String broker;

    /**
     * clientId
     */
    @Value("${mqtt.clientId:mqttx_264dc474}")
    private String clientId;

    /**
     * MQTT是否开启
     */
    @Value("${mqtt.isOpenMqtt:false}")
    private Boolean isOpenMqtt;


    @Override
    public void run(ApplicationArguments args) throws Exception {
        if (isOpenMqtt) {
            log.info("初始化并启动mqtt......");
            this.connect();
        }
    }


    /**
     * 连接mqtt服务器
     */
    private void connect() {
        try {
            // 1 创建客户端
            getClient();
            // 2 设置配置
            MqttConnectOptions options = getOptions();
            // 3 创建回调
            create(options, topic, qos, clientId);
        } catch (Exception e) {
            log.error("mqtt连接异常：" + e);
        }
    }


    /**
     * 1.创建客户端
     */
    public void getClient() {
        try {
            if (null == client) {
                client = new MqttClient(broker, clientId, new MemoryPersistence());
            }
            log.info("创建mqtt客户端完成");
        } catch (Exception e) {
            log.error("创建mqtt客户端异常：" + e);
        }
    }

    /**
     * 2.生成配置对象，用户名，密码等
     */
    public MqttConnectOptions getOptions() {
        MqttConnectOptions connOpts = new MqttConnectOptions();
//        connOpts.setUserName(MQTT_USER_NAME);
//        connOpts.setPassword(MQTT_PASS_WORD.toCharArray());

        //cleanSession为false时，下次以相同clientId登录将可以获取存储的所有消息
        //如果为true，将获取到retained标记的最后一条消息
        //(是否清除session) cleanSession调试测试阶段设置为true，生产设置为false

        // 设置超时时间
//        connOpts.setConnectionTimeout();
//        // 设置会话心跳时间
//        connOpts.setKeepAliveInterval();

        connOpts.setCleanSession(false);
        //设置自动重连
        /*
         * 设置如果连接断开，客户端是否将自动尝试重新连接到服务器。
         * 如果设置为false，则在连接丢失的情况下，客户端将不会尝试自动重新连接到服务器。
         * 如果设置为true，则在连接断开的情况下，客户端将尝试重新连接到服务器。
         * 它最初会等待1秒它会尝试重新连接之前，对于每一个失败的尝试重新连接，延迟将增加一倍，直到它于2分钟，
         * 此时的延迟将保持在2分钟。
         * 参数：
         * automaticReconnect-如果设置为True，将启用自动重新连接
         */
        connOpts.setAutomaticReconnect(true);
        log.info("--生成mqtt配置对象");
        return connOpts;
    }


    /**
     * qos   --- 3 ---
     */
    public int[] getQos(int length) {
        int[] qos = new int[length];
        for (int i = 0; i < length; i++) {
            /**
             *  MQTT协议中有三种消息发布服务质量:
             *
             * QOS0： “至多一次”，消息发布完全依赖底层 TCP/IP 网络。会发生消息丢失或重复。这一级别可用于如下情况，环境传感器数据，丢失一次读记录无所谓，因为不久后还会有第二次发送。
             * QOS1： “至少一次”，确保消息到达，但消息重复可能会发生。
             * QOS2： “只有一次”，确保消息到达一次。这一级别可用于如下情况，在计费系统中，消息重复或丢失会导致不正确的结果，资源开销大
             */
            qos[i] = 2;
        }
        log.info("--设置消息发布质量");
        return qos;
    }


    /**
     * 发布
     */
    public static void publish(int qos, boolean retained, String topic, String pushMessage) {
        MqttMessage message = new MqttMessage();
        message.setQos(qos);
        message.setRetained(retained);
        message.setPayload(pushMessage.getBytes());
        MqttTopic mTopic = client.getTopic(topic);
        if (null == mTopic) {
            log.error("topic：" + topic + " 不存在");
        }
        MqttDeliveryToken token;
        try {
            token = mTopic.publish(message);
            token.waitForCompletion();
            if (token.isComplete()) {
                log.info("消息发送成功");
            }
        } catch (MqttPersistenceException e) {
            e.printStackTrace();
        } catch (MqttException e) {
            e.printStackTrace();
        }
    }


    /**
     * 3.装在各种实例和订阅主题
     */
    public void create(MqttConnectOptions options, String topic, int qos, String clientId) {
        try {
            client.setCallback(new MqttConsumerCallback(client, options, topic, qos, clientId));
            log.info("添加回调处理类");
            client.connect(options);
            //订阅topic
            client.subscribe(topic, qos);
        } catch (Exception e) {
            log.info("装载实例或订阅主题异常：" + e);
        }
    }

}

```



**MQTT回调类**

```java
package com.whcoding.wheels.schedule.mqtt;

import com.alibaba.fastjson.JSONObject;
import com.whcoding.wheels.example.service.ExampleService;
import com.whcoding.wheels.pojo.vo.OrmDeptVO;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.eclipse.paho.client.mqttv3.*;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.annotation.EnableAsync;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.LongAdder;


/**
 * MQTT 数据处理
 */
@Slf4j
@EnableAsync
public class MqttConsumerCallback implements MqttCallbackExtended {
    private String topic;
    private String clientId;

    private int qos;
    private MqttConnectOptions options;
    private MqttClient client;
    private final static LongAdder longAdder = new LongAdder();


    public MqttConsumerCallback(MqttClient client, MqttConnectOptions options, String topic, int qos, String clientId) {
        this.client = client;
        this.options = options;
        this.topic = topic;
        this.clientId = clientId;
        this.qos = qos;
    }


    /**
     * 连接丢失后的处理逻辑
     * 1、连接重连
     * 2、重新订阅Topic数据
     *
     * @param cause
     */
    @Override
    public void connectionLost(Throwable cause) {
        cause.printStackTrace();
        while (true) {
            try {
                //重连
                if (!client.isConnected()) {
                    client.reconnect();
                    log.info("尝试重新连接");
                }
                //重新订阅Topic数据
                if (client.isConnected()) {
                    client.subscribe(topic, qos);
                    log.info("重新订阅Topic数据");
                    break;
                }
                TimeUnit.SECONDS.sleep(100);
            } catch (MqttException | InterruptedException e1) {
                e1.printStackTrace();
            }
            log.error("client not connect");
        }
    }

    /**
     * 消息处理
     *
     * @param topic
     * @param message
     * @throws Exception
     */
    @Override
    public void messageArrived(String topic, MqttMessage message) throws Exception {
        if (message != null && message.toString().length() > 0) {
            longAdder.increment();

            // subscribe后得到的消息会执行到这里面
            String result = new String(message.getPayload(), "UTF-8");
            log.info("topic:{},msg:{},消费总数:{},消息内容:{}", topic, message, longAdder.longValue(), result);

            disposeData(result);
        }
    }

    /**
     * 接收到消息调用令牌中调用
     */
    @Override
    public void deliveryComplete(IMqttDeliveryToken token) {
        //log.info("deliveryComplete---------" + Arrays.toString(topic));
    }


    /**
     * 处理数据
     *
     * @param resultStr
     */
    private void disposeData(String resultStr) {
        if (StringUtils.isEmpty(resultStr)) {
            return;
        }
        // 获取Spring容器
        ApplicationContext context = SpringUtil.context;
        // 一定要这样才能获取到service，StringUtil在下面
        ExampleService equService = context.getBean(ExampleService.class);
        OrmDeptVO deptVO = equService.queryDeptById(1L);
        String deptVOJsonStr = JSONObject.toJSONString(deptVO);
        System.out.println("解析后获取的结果为:" + deptVOJsonStr);
        //1.转为JSON
        JSONObject jsonObject = JSONObject.parseObject(deptVOJsonStr);

        //2.将数据推送到MQTT
        publish(deptVOJsonStr);
    }

    /**
     * mqtt连接后订阅主题
     */
    @Override
    public void connectComplete(boolean b, String s) {
        try {
            if (null != topic && qos > 0) {
                if (client.isConnected()) {
                    client.subscribe(topic, qos);
                    log.info("mqtt连接成功，客户端ID：" + clientId);
                    log.info("--订阅主题:：" + topic);
                } else {
                    log.info("mqtt连接失败，客户端ID：" + clientId);
                }
            }
        } catch (Exception e) {
            log.info("mqtt订阅主题异常:" + e);
        }
    }


    /**
     * 数据推送到MQTT
     *
     * @param jsonMessageStr
     */
    private void publish(String jsonMessageStr) {
        if (StringUtils.isEmpty(jsonMessageStr)) {
            log.info("获取到的jsonMessageStr数据为空!");
            return;
        }
        try {
            log.info("开始执行消息推送到MQTT!");
            topic="test-dev-topic/";
            topic=topic.replace("#","");
            MqttConsumer.publish(qos, true, topic, jsonMessageStr);
            log.info("结束执行消息推送到MQTT!");
        } catch (Exception exception) {
            log.error("推送数据到MQTT异常!topic={},jsonMessageStr={}", topic, jsonMessageStr);

        }

    }
}
```



**获取Spring容器**

```java
package com.whcoding.wheels.schedule.mqtt;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ApplicationObjectSupport;
import org.springframework.stereotype.Component;


/**
 * 获取启动类bean
 */
@Component
public class SpringUtil extends ApplicationObjectSupport {

    public static ApplicationContext context;

    public static Object getBean(String serviceName) {
        return context.getBean(serviceName);
    }

    @Override
    protected void initApplicationContext(ApplicationContext context) throws BeansException {
        super.initApplicationContext(context);
        SpringUtil.context = context;
    }
}

```



**MQTT配置类**

```yml
# MQTT配置类
mqtt:
  isOpenMqtt: false
  qos: 1
  topic: test-dev-topic/#
  clientId: mqttx_264dc474
  broker: tcp://broker.emqx.io:1883
  userame:
  password:
```

## 5.文档

MQTT客户端 :https://mqttx.app/zh/docs

MQTTX下载:https://www.emqx.com/zh/try?product=MQTTX

MQTT安装以及JAVA使用:https://www.kuangstudy.com/bbs/1401763436836229121



