## 重构 if else 

### 背景

最近接手一同事负责的系统，开始以为是缝缝补补，后来发现愚公移山，再后来是精卫填海，最后是女娲补天，后来我绝望了，md,8个if套在一起，算了直接盘古开天地。 

```java
static void testDemo() {
		String medalType = "bronze";
		if ("bronze".equals(medalType)) {
			System.out.println("青铜");
		} else if ("silver".equals(medalType)) {
			System.out.println("白银");
		} else if ("gold".equals(medalType)) {
            // doshomething
			System.out.println("黄金");
		}else if ("platinum".equals(medalType)) {
            // doshomething
			System.out.println("铂金");
		}else if ("diamond".equals(medalType)) {
            // doshomething
			System.out.println("钻石");
		}else if ("transcendency".equals(medalType)) {
            // doshomething
			System.out.println("超凡大师");
		}else if ("Challenger".equals(medalType)) {
            // doshomething
			System.out.println("最强王者");
		}
	}
```

如果将代码都放到 if else代码，代码很难维护也很丑，我们一开始就用了策略模式来处理这种情况。 

![](https://gitee.com/VincentBlog/image/raw/master/image/20210830160128.jpg) 



### 实现思路

使用策略模式+工厂模式，不了解策略模式和工厂模式的同学自行`面壁思过` 。

1. 我们把每个条件逻辑代码块，抽象成一个公共的接口，我们根据每个逻辑条件，定义相对应的策略实现类。
2. 定义策略工厂类，用来管理这些勋章实现策略类

#### 实现策略模式

**1.抽象成一个公共的接口**

```java
public interface IGradeService {
	void showMedal();
}
```

**2.根据逻辑条件实现策略**

青铜勋章实现

```java
/**
 * @program: snailthink
 * @description:
 * @author: SnailThink
 * @create: 2021-08-30 15:30
 **/
public class BronzeServiceImpl implements IGradeService {
	@Override
	public void showMedal() {
		System.out.println("青铜勋章");
	}
}
```

白银勋章实现

```java

/**
 * @program: snailthink
 * @description:
 * @author: SnailThink
 * @create: 2021-08-30 15:30
 **/
public class SilverServiceImpl implements IGradeService {
	@Override
	public void showMedal() {
		System.out.println("白银勋章");
	}
}
```

黄金勋章实现

```java
/**
 * @program: snailthink
 * @description:
 * @author: SnailThink
 * @create: 2021-08-30 15:30
 **/
public class GoldServiceImpl implements IGradeService {
	@Override
	public void showMedal() {
		System.out.println("黄金勋章");
	}
}
```



#### 策略工厂类

```java
/**
 * @program: snailthink
 * @description:勋章服务工产类
 * @author: SnailThink
 * @create: 2021-08-30 15:31
 **/
public class MedalServicesFactory {

	private static final Map<String, IGradeService> map = new HashMap<>();
	static {
		map.put("bronze", new BronzeServiceImpl());
		map.put("silver", new SilverServiceImpl());
		map.put("gold", new GoldServiceImpl());
	}
	public static IGradeService getMedalService(String medalType) {
		return map.get(medalType);
	}
}
```



#### 调用

```java
**
 * @program: snailthink
 * @description:
 * @author: SnailThink
 * @create: 2021-08-30 15:29
 **/
public class DesignModeTest {


	public static void main(String[] args) {
		String medalType = "bronze";
		IGradeService medalService = MedalServicesFactory.getMedalService(medalType);
		medalService.showMedal();
	}


	/**
	 * if eles
 	 */
	static void testDemo() {
		String gradeType = "guest";
		if ("guest".equals(gradeType)) {
			System.out.println("嘉宾勋章");
		} else if ("vip".equals(gradeType)) {
			System.out.println("会员勋章");
		} else if ("guard".equals(gradeType)) {
			System.out.println("展示守护勋章");
		}
	}
}

```



### 总结

if else 是否使用策略模式+ 工厂模式实现需要根据 实际的业务场景是否采用。不要为了用设计模式而用设计模式，会增加系统的复杂性。

