# PostMan 调用WebService



## 前言

最近和第三方对接，需要调用WebService，好家伙一直都没有用过，刚好记录下使用



### 1. 什么是WebService

Web Service是一个平台独立的，低耦合的，自包含的、基于可编程的web的应用程序，可使用开放的XML（标准通用标记语言下的一个子集）标准来描述、发布、发现、协调和配置这些应用程序，用于开发分布式的交互操作的应用程序。

Web Service技术， 能使得运行在不同机器上的不同应用无须借助附加的、专门的第三方软件或硬件， 就可相互交换数据或集成。依据Web Service规范实施的应用之间， 无论它们所使用的语言、 平台或内部协议是什么， 都可以相互交换数据。Web Service是自描述、 自包含的可用网络模块， 可以执行具体的业务功能。Web Service也很容易部署， 因为它们基于一些常规的产业标准以及已有的一些技术，诸如标准通用标记语言下的子集XML、HTTP。Web Service减少了应用接口的花费。Web Service为整个企业甚至多个组织之间的业务流程的集成提供了一个通用机制。

[WebService百度百科](https://baike.baidu.com/item/Web%20Service/1215039?fromtitle=webservice&fromid=2342584&fr=aladdin)



### 2.WebService如何使用

#### 2.1 SOAP 1.1

以下是 SOAP 1.2 请求和响应示例。所显示的占位符需替换为实际值。

```xml
POST /ws/services/TvssSap.asmx HTTP/1.1
Host: localhost
Content-Type: text/xml; charset=utf-8
Content-Length: length
SOAPAction: "http://tempuri.org/SaveWebServiceTest"

<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <SaveWebServiceTest xmlns="http://tempuri.org/">
      <strXml>string</strXml>
    </SaveWebServiceTest>
  </soap:Body>
</soap:Envelope>
```



```xml
HTTP/1.1 200 OK
Content-Type: text/xml; charset=utf-8
Content-Length: length

<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <SaveWebServiceTestResponse xmlns="http://tempuri.org/">
      <SaveWebServiceTestResult>string</SaveWebServiceTestResult>
    </SaveWebServiceTestResponse>
  </soap:Body>
</soap:Envelope>
```

#### 2.2 SOAP 1.2

以下是 SOAP 1.2 请求和响应示例。所显示的占位符需替换为实际值。

```xml
POST /ws/services/TvssSap.asmx HTTP/1.1
Host: localhost
Content-Type: application/soap+xml; charset=utf-8
Content-Length: length

<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <SaveWebServiceTest xmlns="http://tempuri.org/">
      <strXml>string</strXml>
    </SaveWebServiceTest>
  </soap12:Body>
</soap12:Envelope>
```

```xml
HTTP/1.1 200 OK
Content-Type: application/soap+xml; charset=utf-8
Content-Length: length

<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <SaveWebServiceTestResponse xmlns="http://tempuri.org/">
      <SaveWebServiceTestResult>string</SaveWebServiceTestResult>
    </SaveWebServiceTestResponse>
  </soap12:Body>
</soap12:Envelope>
```



#### 2.3 HTTP POST

以下是 HTTP POST 请求和响应示例。所显示的占位符需替换为实际值。

```xml
POST /ws/services/TvssSap.asmx/SaveWebServiceTest HTTP/1.1
Host: localhost
Content-Type: application/x-www-form-urlencoded
Content-Length: length
strXml=string
```



```xml
HTTP/1.1 200 OK
Content-Type: text/xml; charset=utf-8
Content-Length: length

<?xml version="1.0" encoding="utf-8"?>
<string xmlns="http://tempuri.org/">string</string>
```



![image-20220329161230200](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220329161230.png)

![image-20220329161153787](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220329161154.png)



#### 2.4 PostMan调用

我在使用PostMan 调用的时候遇到一个问题，不知道其他小伙伴有没有遇到过

我截取了部分参数如下所示,这样请求接口无法调用到，如何解决呢，请各位小伙伴继续往下看

```xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
        <SaveWebServiceTest  -- 方法名
            xmlns="http://tempuri.org/">
            <strXml> --参数
                <MessagePayload>
                    <PayloadRecord line='000001'>
                        <parameter1>AAA</parameter1>
                        <parameter2>BBB</parameter2>
                        <parameter3>CCC </parameter3>
                        <parameter4>DDD</parameter4>
                    </PayloadRecord>
                </MessagePayload>
            </strXml>
        </SaveWebServiceTest>
    </soap:Body>
</soap:Envelope>
```



**上述问题是由于 `xml`中的 `<>` 需要解析成改成`&lt;&gt;`**

1.设置`Content-Type` 为 `"text/xml; charset=utf-8"`

2.注意格式如下展示

```xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
        <SaveWebServiceTest  -- 方法名
            xmlns="http://tempuri.org/">
            <strXml>
                &lt;MessagePayload&gt;
                &lt;PayloadRecord line='000001'&gt;
                    &lt;parameter1&gt;AAA&lt;/parameter1&gt;
                    &lt;parameter2&gt;BBB&lt;/parameter2&gt;
                    &lt;parameter3&gt;CCC &lt;/parameter3&gt;
                    &lt;parameter4&gt;DDD&lt;/parameter4&gt;
                &lt;/PayloadRecord&gt;
            &lt;/MessagePayload&gt;
			</strXml>
        </SaveWebServiceTest>
    </soap:Body>
</soap:Envelope>
```



### 参考

[WebService详解](https://www.cnblogs.com/xingkongcanghai/p/15029460.html)