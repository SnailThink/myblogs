## SpringBoot—单元测试

>作者：知否派
>博客地址: [https://snailthink.github.io/myblogs](https://snailthink.github.io/myblogs)
>项目地址：[spring-boot-learning](https://gitee.com/VincentBlog/spring-boot-learning.git)
>文章所涉及的资料来自互联网整理和个人总结，意在于个人学习和经验汇总，如有什么地方侵权，请联系本人删除，谢谢！

### 前言

最近公司项目增加代码质量考核，测评每个项目的单元测试覆盖率，以及`sonar` 代码检查。由于历史原因很多老项目，时间紧以及没有进行单元测试覆盖率的考核，导致项目单元测试严重缺失。写单元测试真是个体力活，最近几天疯狂的堆单元测试。感觉写完遥遥无期，是自己写的还好，要是别人之前写的代码那叫一个头疼。黄天不负有心人，找到了个自动成功单元测试的插件。

### 什么是单元测试

单元测试其实就是对代码的进行检查，用来测试我们的数据或者逻辑是否和预期的一样。

单元测试：**对某个类中**的代码进行测试，查看是否正常

集成测试：**跨模块测试**查看代码是否正常

端到端测试：以用户的角度把系统作为一个**整体看功能**是否正常

### 为什么用单元测试

优点:开发人员对代码最熟悉，而且开发人员编程技能相对比较强，所以开发人员自己写单元测试效率上和覆盖率上都比较高

缺点:开发人员平时写业务代码就要花费很多时间，有时候确实没有时间写单元测试；而且大部分开发人员没有太好的测试思想，单元测试可能只是写个最简单的用例就完了；自己写的代码自己测，往往都是不靠谱！

### 单元测试怎么写

1.IDEA中增加**squaretest**插件

![image-20220507192726043](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220507192726.png)





2.安装完插件可以在标题行看到插件

![](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220507192637.png)

![image-20220507193546981](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220507193547.png)



3.生成单元测试

![image-20220507193412508](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220507193412.png)



4.生成controller单元测试

```java
package com.whcoding.base.project.controller;

import com.whcoding.base.project.common.api.Result;
import com.whcoding.base.project.pojo.OrmDeptVO;
import com.whcoding.base.project.service.DeptService;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.http.ResponseEntity;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class DeptControllerTest {

	@Mock
	private DeptService mockDeptService;

	@InjectMocks
	private DeptController deptControllerUnderTest;

	@Before
	public void setUp() {
		initMocks(this);
	}

	@Test
	public void testSayHello() {
		// Setup

		// Run the test
		final String result = deptControllerUnderTest.sayHello("name");

		// Verify the results
		assertEquals("result", result);
		verify(mockDeptService).saveCarrierCsvFile();
	}

	@Test
	public void testAddDept() {
		// Setup
		final OrmDeptVO deptVO = new OrmDeptVO(0L, 0, "deptNo", "deptName", 0, new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new BigDecimal("0.00"), 0, "shortName", "remark", Arrays.asList("value"));
		when(mockDeptService.addDept(new OrmDeptVO(0L, 0, "deptNo", "deptName", 0, new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new BigDecimal("0.00"), 0, "shortName", "remark", Arrays.asList("value")))).thenReturn(false);

		// Run the test
		final boolean result = deptControllerUnderTest.addDept(deptVO);

		// Verify the results
		assertTrue(result);
	}

	@Test
	public void testQueryDeptById() {
		// Setup

		// Configure DeptService.queryDeptById(...).
		final OrmDeptVO deptVO = new OrmDeptVO(0L, 0, "deptNo", "deptName", 0, new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new BigDecimal("0.00"), 0, "shortName", "remark", Arrays.asList("value"));
		when(mockDeptService.queryDeptById(0L)).thenReturn(deptVO);

		// Run the test
		final Result result = deptControllerUnderTest.queryDeptById(0L);

		// Verify the results
	}

	@Test
	public void testQueryAllDept() {
		// Setup
		final List<OrmDeptVO> expectedResult = Arrays.asList(new OrmDeptVO(0L, 0, "deptNo", "deptName", 0, new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new BigDecimal("0.00"), 0, "shortName", "remark", Arrays.asList("value")));

		// Configure DeptService.queryAllDept(...).
		final List<OrmDeptVO> deptVOS = Arrays.asList(new OrmDeptVO(0L, 0, "deptNo", "deptName", 0, new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new BigDecimal("0.00"), 0, "shortName", "remark", Arrays.asList("value")));
		when(mockDeptService.queryAllDept()).thenReturn(deptVOS);

		// Run the test
		final List<OrmDeptVO> result = deptControllerUnderTest.queryAllDept();

		// Verify the results
		assertEquals(expectedResult, result);
	}

	@Test
	public void testUpdateDept() {
		// Setup
		final OrmDeptVO deptVO = new OrmDeptVO(0L, 0, "deptNo", "deptName", 0, new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new BigDecimal("0.00"), 0, "shortName", "remark", Arrays.asList("value"));
		when(mockDeptService.updateDept(new OrmDeptVO(0L, 0, "deptNo", "deptName", 0, new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new GregorianCalendar(2019, Calendar.JANUARY, 1).getTime(), new BigDecimal("0.00"), 0, "shortName", "remark", Arrays.asList("value")))).thenReturn(false);

		// Run the test
		final boolean result = deptControllerUnderTest.updateDept(deptVO);

		// Verify the results
		assertTrue(result);
	}

	@Test
	public void testDeleteDeptById() {
		// Setup
		when(mockDeptService.deleteDeptById(0L)).thenReturn(false);

		// Run the test
		final boolean result = deptControllerUnderTest.deleteDeptById(0L);

		// Verify the results
		assertTrue(result);
	}

	@Test
	public void testInsertOrUpdateBatch() {
		// Setup

		// Run the test
		final ResponseEntity result = deptControllerUnderTest.insertOrUpdateBatch(0L);

		// Verify the results
		verify(mockDeptService).insertOrUpdateBatch(0L);
	}
}

```

5.生成entity单元测试

```java
package com.whcoding.base.project.common;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.boot.test.context.SpringBootTest;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

/**
 * @program: spring-boot-learning
 * @description:
 * @author: whcoding
 * @create: 2022-05-07 17:01
 **/
@SpringBootTest
@RunWith(MockitoJUnitRunner.class)
public abstract class BaseVoEntityTest<T> {


	protected T t;

	protected abstract T getT();

	public void testGetAndSet() throws IllegalAccessException, InstantiationException, IntrospectionException,
			InvocationTargetException {
		 t = getT();
		Class modelClass = t.getClass();
		Object obj = modelClass.newInstance();
		Field[] fields = modelClass.getDeclaredFields();
		for (Field f : fields) {
			//是否为静态类
			boolean isStatic = Modifier.isStatic(f.getModifiers());
			// 过滤字段
			if (f.getName().equals("isSerialVersionUID")
					|| f.getName().equals("serialVersionUID")
					|| f.getName().equals("bTime")
					|| f.getName().equals("eTime")
					|| isStatic
					|| f.getGenericType().toString().equals("boolean")
					|| f.isSynthetic()) {
				continue;
			}
			PropertyDescriptor pd = new PropertyDescriptor(f.getName(), modelClass);
			Method get = pd.getReadMethod();
			Method set = pd.getWriteMethod();
			set.invoke(obj, get.invoke(obj));
		}
	}

	@Test
	public void getAndSetTest() throws InvocationTargetException, IntrospectionException,
			InstantiationException, IllegalAccessException {
		this.testGetAndSet();
	}

}
```



5.生成impl单元测试

```java
package com.whcoding.base.project.common;

import org.junit.Before;
import org.junit.runner.RunWith;
import org.mockito.MockitoAnnotations;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.boot.test.context.SpringBootTest;

/**
 * @program: spring-boot-learning
 * @description:
 * @author: whcoding
 * @create: 2022-05-07 17:01
 **/
@SpringBootTest
@RunWith(MockitoJUnitRunner.class)
public abstract class BaseImplMockitoTest {

	@Before
	public void setupMock() {
		MockitoAnnotations.initMocks(this);
	}
}

```

