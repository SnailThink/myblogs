## Java8

### 1.1 Stream和parallelStream 区别

**并行流parallelStream:**parallelStream提供了流的并行处理，它是Stream的另一重要特性，其底层使用**Fork/Join**框架实现。简单理解就是多线程异步任务的一种实现。



**样例数据:**

```java
public String testMailRetryer() {
		String resp = "success";

		Callable<Boolean> mailCallable = new Callable<Boolean>() {
			int times = 0;

			@Override
			public Boolean call() {
				times++;
				logger.info("mail重试第{}次", times);
				if (times == 7) {
					return true;
				}
				return false;
			}
		};

		try {
			mailRetryer.call(mailCallable);
		} catch (Exception e) {
			System.out.println(e);
			resp = "fail";
		}

		return resp;
	}
```


### 1.2 forEachOrdered 和 forEach区别

`forEachOrdered()`和`forEach()`方法的区别在于`forEachOrdered()`将始终按照流(`stream`)中元素的遇到顺序执行给定的操作，而`forEach()`方法是不确定的。

在并行流(`parallel stream`)中，`forEach()`方法可能不一定遵循顺序，而`forEachOrdered()`将始终遵循顺序。

在序列流(`sequential stream`)中，两种方法都遵循顺序。

如果我们希望在每种情况下，不管流(`stream`)是连续的还是并行的，都要按照遵循顺序执行操作，那么我们应该使用`forEachOrdered()`方法。

如果流(`stream`)是连续的，我们可以使用任何方法来维护顺序。

但是如果流(`stream`)也可以并行，那么我们应该使用`forEachOrdered()`方法来维护顺序。


###  






