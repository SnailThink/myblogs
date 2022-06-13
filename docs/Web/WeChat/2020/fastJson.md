##  FastJSON 

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531092141.jpeg)

FastJSON是一个Java语言编写的高性能，功能完善，完全支持[http://json.org](http://json.org/)的标准的JSON库。

它采用一种假定有序快速匹配的算法，是号称Java中最快的JSON库，下面看看



**FastJSON 的简单使用**


如果使用Maven,在pom.xml文件加入以下依赖。

```xml
  <dependency>
      <groupId>com.alibaba</groupId>
      <artifactId>fastjson</artifactId>
      <version>1.2.31</version>
  </dependency>
```



### 序列化

序列化就是指 把JavaBean对象转成JSON格式的字符串。

com.alibaba.fastjson.JSON提供了许多方法（多态）实现序列化

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531092124.png)

 

**1.单个对象的序列化**

```java
//1.构造对象
GrootCustomerPO customerPO=new GrootCustomerPO();
        customerPO.setCustomerName("北京中关村");
        customerPO.setCustomerNo("BJZWC");
        customerPO.setCustomerId(1001);
        customerPO.setCustomerAddress("北京市中关村123号");
        customerPO.setCustomerType(1);
        customerPO.setCustomerFund(BigDecimal.ZERO);
        customerPO.setOrderDate(new Date());
        customerPO.setOrderNo("A20826");
        customerPO.setOrderId(20);
        System.out.println(customerPO);
```



**1.将对象转换为json**

```java
//1.将对象转换为json
String objJson = JSON.toJSONString(customerPO);

//1.1 将对象转换为json并且序列化
String objJson = JSON.toJSONString(customerPO, boolean prettyFormat);

```



**3.将`Map`转成JSON**



```java
 //2.map转换为json
 Map<String, Object> map=new HashMap<>();
 map.put("A",10);
 map.put("B",20);
 map.put("C",30);
 map.put("D",40);
 String mapJson = JSON.toJSONString(map);
```



**3.将List`<Map>`转成JSON**

```java
 //3.将List<Map>转成JSON。
 List<Map<String, Object>> list = new ArrayList<>();
 Map<String, Object> map1 = new HashMap<>();
 map1.put("key1", "One");
 map1.put("key2", "Two");

 Map<String, Object> map2 = new HashMap<>();
 map2.put("key1", "Three");
 map2.put("key2", "Four");

 list.add(map1);
 list.add(map2);

 String listJson = JSON.toJSONString(list);

 //4.将List<Map>转成JSON。boolean prettyFormat 是否进行格式化 [转换成格式化的sql]
 String objJsonA = JSON.toJSONString(customerPO, true);

```



**4.传递枚举**

```java
String objJson = JSON.toJSONString(Object object, SerializerFeature... features) 
```



传入一个对象和SerializerFeature类型的可变变量。SerializerFeature是一个枚举。

com.alibaba.fastjson.serializer.SerializerFeature

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531092111.png)



![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531092059.png)



你可以根据自己的情况使用这些特性。

简单说下几个常用的特性：

1.日期格式化：

FastJSON可以直接对日期类型格式化，在缺省的情况下，FastJSON会将Date转成long。

eg:FastJSON将java.util.Date转成long。

```java
 String dateJson = JSON.toJSONString(new Date());
         
 System.out.println(dateJson);
```



 eg：使用SerializerFeature特性格式化日期。 

```java
String dateJson = JSON.toJSONString(new Date(), SerializerFeature.WriteDateUseDateFormat);
         
System.out.println(dateJson);
```

 eg： 指定输出日期格式。 

```
 String dateJson = JSON.toJSONStringWithDateFormat(new Date(), "yyyy-MM-dd HH:mm:ss.SSS");
         
 System.out.println(dateJson)

```

 eg:使用单引号

```
String listJson = JSON.toJSONString(list, SerializerFeature.UseSingleQuotes);
//输出结果
[{'key1':'One','key2':'Two'},{'key3':'Three','key4':'Four'}]
```

  eg:输出Null字段。 

  缺省情况下FastJSON不输入为值Null的字段，可以使用SerializerFeature.WriteMapNullValue使其输出。 

 ```java
 Map<String, Object> map = new HashMap<String,Object>();
         
 String b = null;
 Integer i = 1;
         
 map.put("a", b);
 map.put("b", i);
         
 String listJson = JSON.toJSONString(map, SerializerFeature.WriteMapNullValue);

//输出结果
{"a":null,"b":1}
 ```





### 反序列化

反序列化就是把JSON格式的字符串转化为Java Bean对象。

com.alibaba.fastjson.JSON提供了许多方法（多态）实现反序列化。



**将对象反序列化**

```java
 User user1 = JSON.parseObject(userJson, User.class);
 System.out.println(user1.getUserName());
```



**map反序列化**

```java
List<Map> list1 = JSON.parseArray(listJson, Map.class);
 for(Map<String, Object> map : list1){
     System.out.println(map.get("key1"));
     System.out.println(map.get("key2"));         
 }
```

**maplist **

```java
 Map<String, Object> map1 = JSON.parseObject(mapJson, new TypeReference<Map<String, Object>>(){});
 System.out.println(map1.get("key1"));
 System.out.println(map1.get("key2"));
```



**将List对象转成JSONArray，然后输出 **

```java
List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        
Map<String, Object> map = new HashMap<String, Object>();
map.put("key1", "One");
map.put("key2", "Two");
        
Map<String, Object> map2 = new HashMap<String, Object>();
map2.put("key1", "Three");
map2.put("key2", "Four");
        
list.add(map);
list.add(map2);
        
JSONArray j = JSONArray.parseArray(JSON.toJSONString(list));
         
for(int i=0; i<j.size(); i++){
    System.out.println(j.get(i));
}

```

 简单附上自己写的json工具类： 



```java

public class MyJsonUtil {

	private static final SerializerFeature[] features = {
			SerializerFeature.WriteMapNullValue,
			// 输出空置字段
			// SerializerFeature.WriteNullListAsEmpty,
			// // list字段如果为null，输出为[]，而不是null
			// SerializerFeature.WriteNullNumberAsZero,
			// // 数值字段如果为null，输出为0，而不是null
			// SerializerFeature.WriteNullBooleanAsFalse,
			// // Boolean字段如果为null，输出为false，而不是null
			// SerializerFeature.WriteNullStringAsEmpty,
			// // 字符类型字段如果为null，输出为""，而不是null
			SerializerFeature.WriteDateUseDateFormat
			// 日期格式化yyyy-MM-dd HH:mm:ss
	};

	public static String toJson(Object object) {
		return JSON.toJSONString(object, features);
	}
}
```



### 关注

![snailThink.png](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531092000.jpeg)

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220531092038.gif)