## Java8 Stream

Java 8 API添加了一个新的抽象称为流Stream，可以让你以一种声明的方式处理数据。

Stream 使用一种类似用 SQL 语句从数据库查询数据的直观方式来提供一种对 Java 集合运算和表达的高阶抽象。

Stream API可以极大提高Java程序员的生产力，让程序员写出高效率、干净、简洁的代码。

这种风格将要处理的元素集合看作一种流， 流在管道中传输， 并且可以在管道的节点上进行处理， 比如筛选， 排序，聚合等。

元素流在管道中经过中间操作（intermediate operation）的处理，最后由最终操作(terminal operation)得到前面处理的结果。

## 1.什么是Stream？

Stream（流）是一个来自数据源的元素队列并支持聚合操作

- 元素是特定类型的对象，形成一个队列。 Java中的Stream并不会存储元素，而是按需计算。
- **数据源** 流的来源。 可以是集合，数组，I/O channel， 产生器generator 等。
- **聚合操作** 类似SQL语句一样的操作， 比如filter, map, reduce, find, match, sorted等。

和以前的Collection操作不同， Stream操作还有两个基础的特征：

- **Pipelining**: 中间操作都会返回流对象本身。 这样多个操作可以串联成一个管道， 如同流式风格（fluent style）。 这样做可以对操作进行优化， 比如延迟执行(laziness)和短路( short-circuiting)。
- **内部迭代**： 以前对集合遍历都是通过Iterator或者For-Each的方式, 显式的在集合外部进行迭代， 这叫做外部迭代。 Stream提供了内部迭代的方式， 通过访问者模式(Visitor)实现。

## 2.生成流

在 Java 8 中, 集合接口有两个方法来生成流：

- **stream()** − 为集合创建串行流。
- **parallelStream()** − 为集合创建并行流。

```java
List<String> strings = Arrays.asList("AAA", "BBB", "CCC", "DDD");
List<String> filtered = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.toList());
```

## 3.常用方法

### 1.filter(T->Boolean)

筛选Boolean为true的数据

```java
//筛选查询ID=20 的数据
List<CustomerVO> customerVOList = getArrayList();
List<CustomerVO> idList= customerVOList.stream().filter(customerVO -> customerVO.getId().equals(20)).collect(Collectors.toList());
```

### 2.distinct()

去除重复元素，根据类的equals判断是否相同

```java
//筛选ID大于0并且去重的数据
List<CustomerVO> customerDistinctList =customerVOList.stream().filter(t->t.getId().compareTo(0)==1).distinct().collect(Collectors.toList());
```

### 3.map(T -> R)

 将流中的每一个元素 T 映射为一个流，再把每一个流连接成为一个流 

```java
//1.获取到customerVOList中的收货方
List<String> receiveNoList = customerVOList.stream().map(CustomerVO::getReceiveNo).collect(Collectors.toList());
//filter和map函数结合
List<String> receiveNoList2=customerVOList.stream().filter(customerVO -> customerVO.getId().equals(20)).map(CustomerVO::getReceiveNo).collect(Collectors.toList());

```

###  4.anyMatch(T -> boolean)

 流中是否有一个元素匹配给定的 `T -> boolean` 条件 

```java
//customerVOList是否存在一个 CustomerVO 对象的 id 等于 20：
boolean resultBool= customerVOList.stream().allMatch(person -> person.getId() == 20);
```

### 5.anyMatch(T -> boolean)

```java
//customerVOList是否 CustomerVO 对象的 id 都等于 20：
boolean resultBool= customerVOList.stream().allMatch(person -> person.getId() == 20);
```

### 6. noneMatch(T -> boolean)

```java
//customerVOList是否不存在 CustomerVO 对象的 id 等于 20：
boolean resultBool= customerVOList.stream().noneMatch(person -> person.getId() == 20);
```

### 7. findAny() 和 findFirst()

- findAny()：找到其中一个元素 （使用 stream() 时找到的是第一个元素；使用 parallelStream() 并行时找到的是其中一个元素）
- findFirst()：找到第一个元素
-  **这两个方法返回的是一个 Optional 对象**，它是一个容器类，能代表一个值存在或不存在 
- limit，findFirst， 因为这两个方法会考虑元素的顺序性，而并行本身就是违背顺序性的，也是因为如此 findAny 一般比 findFirst 的效率要高 

```java
//findFirst
Optional<CustomerVO> voOptional= customerVOList.stream().filter(cp->cp.getId().compareTo(0)==0).findFirst();
		if (voOptional.isPresent()){
			System.out.println(voOptional.get());
		}
//findAny		
Optional<CustomerVO> voOptional= customerVOList.stream().filter(cp->cp.getId().compareTo(0)==0).findAny();
		if (voOptional.isPresent()){
			System.out.println(voOptional.get());
		}
```

### 8. flatMap(T -> Stream)

 将流中的每一个元素 T 映射为一个流，再把每一个流连接成为一个流 

 ```java
eg:1
//查询收货方
List<String> receiveNoList = customerVOList.stream().map(CustomerVO::getReceiveNo).collect(Collectors.toList());
//eg:2
List<String> list = new ArrayList<>();
list.add("aaa bbb ccc");
list.add("ddd eee fff");
list.add("ggg hhh iii");
 
list = list.stream().map(s -> s.split(" ")).flatMap(Arrays::stream).collect(toList());
 ```

上面例子中，我们的目的是把 List 中每个字符串元素以" "分割开，变成一个新的 List。
首先 map 方法分割每个字符串元素，但此时流的类型为 Stream<String[ ]>，因为 split 方法返回的是 String[ ] 类型；所以我们需要使用 flatMap 方法，先使用Arrays::stream将每个 String[ ] 元素变成一个 Stream 流，然后 flatMap 会将每一个流连接成为一个流，最终返回我们需要的 Stream

### 9. limit(long n)

返回前n个元素

```java
//返回前2个元素
list = customerVOList.stream()
            .limit(2)
            .collect(toList());
```

### 10. skip(long n)

去除前n和元素

```java
list = customerVOList.stream()
            .skip(2)
            .collect(toList());
```

**tips**:

- 用在 limit(n) 前面时，先去除前 m 个元素再返回剩余元素的前 n 个元素
- limit(n) 用在 skip(m) 前面时，先返回前 n 个元素再在剩余的 n 个元素中去除 m 个元素

```java
//skip/limit 获取List中低n->m的数据 [获取id 2到10之间的数据]
customerVOList.stream().sorted(Comparator.comparing(CustomerVO::getId).reversed()).skip(2).limit(10).collect(Collectors.toList());
```

### 11.sorted() / sorted((T, T) -> int)

如果流中的元素的类实现了 Comparable 接口，即有自己的排序规则，那么可以直接调用 sorted() 方法对元素进行排序，如 Stream

反之, 需要调用 `sorted((T, T) -> int)` 实现 Comparator 接口

```java
//根据ID大小进行比较
list = customerVOList.stream()
           .sorted((p1, p2) -> p1.getId() - p2.getId())
           .collect(toList())
//还以可以写成
customerVOList.stream().filter(cp->cp.getId().compareTo(0)==1).			sorted(Comparator.comparing(CustomerVO::getId).reversed().thenComparing(CustomerVO::getId)).collect(Collectors.toList());
				
//可以简化为
list = customerVOList.stream()
           .sorted(Comparator.comparingInt(CustomerVO::getId))
           .collect(toList());
```

### 12. forEach()

```java
//使用forEash调用方法
customerVOList.stream().forEach(cp->getSendNOLambda(cp.getSendNo(),cp.getReceiveNo()));

//当ID大于0循环输出
customerVOList.stream().filter(cp->cp.getId()>0).forEach(System.out::println);

private void getSendNOLambda(String sendNo,String receiveNo){
	System.out.println(sendNo+','+receiveNo);
}
```

### 13.Map

```java
//转换为Map[获取ID大于0的发货方和收货方转换为Map]
Map<String,String> stringMap=customerVOList.stream().filter(customerVO -> customerVO.getId()>0).collect(Collectors.toMap(CustomerVO::getSendNo,CustomerVO::getReceiveNo));


Map<Long, String> collectMap = customerVOList.stream().collect(Collectors.toMap(OrmCustomerVO::getId, OrmCustomerVO::getCustomerName));
		//方法一：
		Map<Long, OrmCustomerVO> collectByID = customerVOList.stream().collect(Collectors.toMap(OrmCustomerVO::getId, t -> t));
		//方法二：
		Map<Long, OrmCustomerVO> collectByID2 = customerVOList.stream().collect(Collectors.toMap(OrmCustomerVO::getId, Function.identity()));
		//方法三： 筛选指定对象
		Map<Long, OrmCustomerVO> collectMap3 = customerVOList.stream().filter(cp -> StringUtils.isNotBlank(cp.getCustomerName())).
				collect(Collectors.toMap(OrmCustomerVO::getId, ormUserVO -> {
					Integer userType = ormUserVO.getCustomerType();
					if (BaseConstant.DEFAULT_VALID_ONE.equals(userType)) {
						ormUserVO.setId(10L);
					}
					return ormUserVO;
				}, (t1, t2) -> t1));

		//Map转为List
		Map<Long, OrmCustomerVO> map = customerVOList.stream().collect(Collectors.toMap(OrmCustomerVO::getId, a -> a, (k1, k2) -> k1));
		for (Map.Entry<Long, OrmCustomerVO> entry : map.entrySet()) {
			Long key = entry.getKey();
			System.out.println("map中的key是:" + key);
			System.out.println("map中的value是:" + entry.getValue().toString());
		}
```

### 14.toArray

```java
//1.不带参数返回的是Object数组
Object[] receiveNoArray= customerVOList.stream().filter(cp->cp.getId()>0).map(CustomerVO::getReceiveNo).toArray();

String[] receiveArray= customerVOList.stream().filter(cp->cp.getId()>0).map(CustomerVO::getReceiveNo).toArray(String[]::new);

CustomerVO[] customerVOArray= customerVOList.stream().filter(cp->cp.getId()>0).toArray(CustomerVO[]::new);
```

### 15. groupingBy 分组

 groupingBy 用于将数据分组，最终返回一个 Map 类型 

```java
//其中返回的 Map 键为 Integer 类型，值为 Map<T, List> 类型，即参数中 groupBy(...) 返回的类型
// groupingBy(CustomerVO::getId) 等同于 groupingBy(CustomerVO::getId, toList())
Map<Integer, List<CustomerVO>> map = list.stream().collect(groupingBy(CustomerVO::getId));

// group By 单个字段
Map<Long, List<OrmCustomerVO>> customerMap = customerVOList.stream().collect(Collectors.groupingBy(OrmCustomerVO::getId));

//方法一： 遍历map
for (Map.Entry<Long, List<OrmCustomerVO>> entry : customerMap.entrySet()) {
	System.out.println("key：" + entry.getKey() + "value：" + entry.getValue());
}
//方法二： 遍历map
customerMap.forEach((key, value) -> {
	System.out.println("key：" + key + "value：" + value);
	//2.遍历value
	value.forEach(cp -> System.out.println(cp.getCustomerName()));
});


//group By 多个字段
Map<String, Map<String, Map<Integer, List<OrmCustomerVO>>>> groupByMoreFiled
		= customerVOList.stream().collect(
		groupingBy(OrmCustomerVO::getCustomerNo,
				groupingBy(OrmCustomerVO::getCustomerName,
						groupingBy(OrmCustomerVO::getCustomerType)
)));

//方法一： 遍历多个字段
for (Map.Entry<String, Map<String, List<OrmCustomerVO>>> entryMap : group2.entrySet()) {
	String entryMapKey = entryMap.getKey();
	Map<String, List<OrmCustomerVO>> entryMapValue = entryMap.getValue();

	System.out.println("第一遍遍历获取key：" + entryMapKey + " value：" + entryMapValue);

	for (Map.Entry<String, List<OrmCustomerVO>> map : entryMapValue.entrySet()) {
		String mapKey = map.getKey();
		System.out.println("第二遍遍历获取key：" + mapKey + " value：" + map.getValue());
		List<OrmCustomerVO> mapValueList = map.getValue();
		for (OrmCustomerVO ormCustomerVO : mapValueList) {
			System.out.println("遍历List中的数据" + ormCustomerVO);
		}
	}
}
```

### 16. 取最值

 maxBy，minBy 两个方法，需要一个 Comparator 接口作为参数 

```java
//1.最大值
Optional<CustomerVO> optional = customerVOList.stream().collect(maxBy(comparing(CustomerVO::getId)));
//2.最小值
Optional<CustomerVO> optiona2 = customerVOList.stream().collect(minBy(comparing(CustomerVO::getId)));
//优化
Optional<CustomerVO> optional = customerVOList.stream().max(comparing(CustomerVO::getId));
```

### 17.汇总

```JAVA
//1.计算总数
long listCount = customerVOList.stream().collect(counting());
long listCount2 = customerVOList.stream().count();//推荐

//2.summingInt ，summingLong ，summingDouble
Integer sum = customerVOList.stream().collect(summingInt(CustomerVO::getMoney));
Integer sum2 = customerVOList.stream().mapToInt(CustomerVO::getMoney).sum();
BigDecimal sumBigDecimal = customerVOList.stream().map(OrmCustomerVO::getCustomerFund).reduce(BigDecimal.ZERO, BigDecimal::add);
//3.averagingInt，averagingLong，averagingDouble
Double average = customerVOList.stream().collect(averagingInt(CustomerVO::getMoney));
OptionalDouble average2 = customerVOList.stream().mapToInt(CustomerVO::getAge).getMoney();
```
### Java 8 Functional 

- 举例：枚举类 + Functional 实现一个轻量级“工厂”（包 demo1）
- PropertyNamer

| name           | type                | description                     |
| -------------- | ------------------- | ------------------------------- |
| Consumer       | Consumer< T >       | 接收T对象，不返回值             |
| Predicate      | Predicate< T >      | 接收T对象并返回boolean          |
| Function       | Function< T, R >    | 接收T对象，返回R对象            |
| Supplier       | Supplier< T >       | 提供T对象（例如工厂），不接收值 |
| UnaryOperator  | UnaryOperator< T >  | 接收T对象，返回T对象            |
| BiConsumer     | BiConsumer<T, U>    | 接收T对象和U对象，不返回值      |
| BiPredicate    | BiPredicate<T, U>   | 接收T对象和U对象，返回boolean   |
| BiFunction     | BiFunction<T, U, R> | 接收T对象和U对象，返回R对象     |
| BinaryOperator | BinaryOperator< T > | 接收两个T对象，返回T对象        |


**推荐阅读 **

[Java 8系列之Stream的基本语法详解](https://blog.csdn.net/IO_Field/article/details/54971761?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase)

[Java集合Stream类filter的使用](https://blog.csdn.net/qq_33829547/article/details/80279488?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.nonecase&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.nonecase)

## 关注

>如果你觉得我的文章对你有帮助话，欢迎点赞👍 关注❤️ 分享👥！
>如果本篇博客有任何错误，请批评指教，不胜感激！
>点个在看，分享到朋友圈，对我真的很重要！！！

![知否派](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530174025.jpg)