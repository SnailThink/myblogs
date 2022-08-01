## validation 参数校验

### 前言

之前我们验证前端查询的参数都是根据参数值进行判断，若参数不满足条件就进行抛出异常，

### 1.Maven依赖

```xml
 <!--第一种方式导入校验依赖-->
 <dependency>
     <groupId>javax.validation</groupId>
     <artifactId>validation-api</artifactId>
     <version>2.0.1.Final</version>
 </dependency>
 <!--第二种方式导入校验依赖-->
 <dependency>
     <groupId>org.hibernate.validator</groupId>
     <artifactId>hibernate-validator</artifactId>
 </dependency>
```

![image-20220801103640443](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220801103640443.png)

**引入依赖后查看**`javax.validation.constraints` 可以看到其中使用的注解如下，大家有时间也可以看看里面的源码，下面我将把使用的样例贴出来如下所示

### 2.值校验

#### 2.1 @Null注解

remark 必须为null

```java
    @Null(message = "必须为null")
    private String remark;
```

#### 2.2 @NotNull注解

```java
    @NotNull(message = "必须不为null")
    private String remark;
```

#### 2.3 @NotBlank注解

验证注解的元素值不为空（不为null、去除首位空格后长度为0） ，并且类型为String。

```java
@NotBlank(message = "必须不为空")
private String remark;
```

#### 2.4 @NotEmpty注解

验证注解的元素值不为null且不为空（[字符串](https://so.csdn.net/so/search?q=字符串&spm=1001.2101.3001.7020)长度不为0、集合大小不为0） ，并且类型为String。

```java
@NotEmpty(message = "必须不为null且不为空")
private String remark;
```

#### 2.5 @AssertTrue注解

被注解的元素必须为true，并且类型为[boolean](https://so.csdn.net/so/search?q=boolean&spm=1001.2101.3001.7020)。

```java
@AssertTrue(message = "必须为true")
private boolean status;
```

#### 2.6 @AssertFalse注解

被注解的元素必须为false，并且类型为boolean。

```java
@AssertFalse(message = "必须为false")
private boolean status;
```

### 3.范围校验

#### 3.1 @Min注解

被注解的元素其值必须大于等于最小值，并且类型为int，long，float，double。

```java
@Min(value = 18, message = "必须大于等于18")
private int age;
```

#### 3.2 @Max注解

被注解的元素其值必须小于等于最小值，并且类型为int，long，float，double

```java
@Max(value = 18, message = "必须小于等于18")
private int age;
```

#### 3.3 @DecimalMin注解

验证注解的元素值大于等于@DecimalMin指定的value值，并且类型为BigDecimal。

```java
@DecimalMin(value = "150", message = "必须大于等于150")
private BigDecimal height;
```

#### 3.4 @DecimalMax注解

验证注解的元素值小于等于@DecimalMax指定的value值 ，并且类型为BigDecimal。

```java
@DecimalMax(value = "300", message = "必须大于等于300")
private BigDecimal height;
```

#### 3.5 @Range注解

验证注解的元素值在最小值和最大值之间，并且类型为BigDecimal，BigInteger，CharSequence，byte，short，int，long。

```java
@Range(max = 80, min = 18, message = "必须大于等于18或小于等于80")
private int age;
```

#### 3.6 @Past注解

被注解的元素必须为过去的一个时间，并且类型为java.util.Date。

```java
@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
@Past(message = "必须为过去的时间")
private Date createDate;
```

#### 3.7 @Future注解

被注解的元素必须为未来的一个时间，并且类型为java.util.Date。

```java
@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
@Future(message = "必须为未来的时间")
private Date createDate;
```



### 4.长度校验

#### 4.1 @Size注解

被注解的元素的长度必须在指定范围内，并且类型为String，Array，List，Map。

```java
@Size(max = 11, min = 7, message = "长度必须大于等于7或小于等于11")
private String mobile;
```

#### 4.2 @Length注解

验证注解的元素值长度在min和max区间内 ，并且类型为String。

```java
@Length(max = 11, min = 7, message = "长度必须大于等于7或小于等于11")
private String mobile;
```

### 5.格式校验

#### 5.1 @Digits注解

验证注解的元素值的整数位数和小数位数上限 ，并且类型为float，double，BigDecimal。

```java
@Digits(integer=3,fraction = 2,message = "整数位上限为3位，小数位上限为2位")
private BigDecimal height;
```

#### 5.2 @Pattern注解

被注解的元素必须符合指定的正则表达式，并且类型为String。

```java
@Pattern(regexp = "\\d{11}",message = "必须为数字，并且长度为11")
private String mobile;
```

#### 5.3 @Email注解

验证注解的元素值是Email，也可以通过regexp和flag指定自定义的email格式，类型为String。

```java
 @Email(message = "必须是邮箱")
private String email;
```



### 6.自定义参数校验

在平时使用中有一些特殊的参数验证我们是否可以自定义参数检查 并直接使用注解实现呢，请各位看官往下看。

#### 6.1 添加IsMobile注解

```java
package com.whcoding.test.annotion;

import com.whcoding.test.common.validator.IsMobileValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.*;
import static java.lang.annotation.ElementType.TYPE_USE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

/**
 * @program: spring-boot-learning
 * @description:
 * @author: whcoding
 * @create: 2022-08-01 11:44
 **/
@Target({METHOD, FIELD, ANNOTATION_TYPE, CONSTRUCTOR, PARAMETER, TYPE_USE})
@Retention(RUNTIME)
@Documented
@Constraint(validatedBy = {IsMobileValidator.class})
public @interface IsMobile {

	boolean required() default true;

	String message() default "手机号码格式错误";

	Class<?>[] groups() default {};

	Class<? extends Payload>[] payload() default {};
}

```

#### 6.2 定义校验类

`@Constraint(validatedBy = { IsMobileValidator.class})`定义校验类

```java
package com.whcoding.test.common.validator;

import com.whcoding.test.annotion.IsMobile;
import org.apache.commons.lang3.StringUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

/**
 * @program: spring-boot-learning
 * @description:验证手机号正则
 * @author: whcoding
 * @create: 2022-08-01 11:46
 **/
public class IsMobileValidator implements ConstraintValidator<IsMobile,String> {

	private boolean required = false;

	@Override
	public void initialize(IsMobile constraintAnnotation) {
		required = constraintAnnotation.required();
	}

	@Override
	public boolean isValid(String value, ConstraintValidatorContext context) {
		if(required){
			return ValidatorRegExUtil.isMobile(value);
		}else{
			if(StringUtils.isEmpty(value)){
				return true;
			}else {
				return ValidatorRegExUtil.isMobile(value);
			}
		}

	}
}
```

#### 6.3 参数正则通用类

```java
package com.whcoding.test.common.validator;

import org.apache.commons.lang3.StringUtils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @program: spring-boot-learning
 * @description:
 * @author: whcoding
 * @create: 2022-08-01 11:46
 **/
public class ValidatorRegExUtil {
	private static final Pattern mobile_pattern = Pattern.compile("[1]([3-9])[0-9]{9}$");

	public static boolean isMobile(String mobile) {
		if (StringUtils.isEmpty(mobile)) {
			return false;
		}
		Matcher matcher = mobile_pattern.matcher(mobile);
		return matcher.matches();
	}
}
```

#### 6.4 注解使用

```java
	@NotNull(message = "手机号码不能为空")
	@IsMobile
	private String mobile;
```

### 7.自定义参数校验

**在VO中增加参数验证**

```java
package com.whcoding.test.pojo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

/**
 * @program: spring-boot-learning
 * @description:
 * @author: whcoding
 * @create: 2022-08-01 10:58
 **/

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ValidationParamVO {

	@Min(value = 0, message = "最小值不能小于0")
	private Integer userCode;


	@NotNull(message = "部门名称不能为空")
	private String userName;
}

```

**Controller层使用参数验证**

```java
package com.whcoding.test.controller;

import cn.hutool.core.lang.copier.SrcToDestCopier;
import com.whcoding.test.pojo.ValidationParamVO;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

/**
 * @program: spring-boot-learning
 * @description: 参数检测
 * @author: whcoding
 * @create: 2022-08-01 10:44
 **/
@RequestMapping("validation")
@RestController
public class ValidationController {

	private static final Logger logger = LoggerFactory.getLogger(ValidationController.class);

	/**
	 * 参数检查:第一版本
	 *
	 * @param userName
	 * @return
	 */
	@GetMapping("checkParam")
	public ResponseEntity checkParam(@RequestParam String userName, Integer userCode) {

		if (StringUtils.isEmpty(userName)) {
			throw new RuntimeException("userName参数不能为空");
		}
		if (userCode.equals(0)) {
			throw new RuntimeException("userCode参数必须大于0");
		}
		logger.info("checkParam  do something");
		System.out.println("checkParam");
		//do something
		return ResponseEntity.ok().build();
	}

	/**
	 * 参数检查:第2版本
	 *
	 * @param userName
	 * @return
	 */
	@GetMapping("checkParam2")
	public ResponseEntity checkParam2(@Validated @NotBlank(message = "用户名称不能为空") String userName) {
		//do something
		return ResponseEntity.ok().build();
	}

	/**
	 * 参数检查:第3版本
	 *
	 * @param paramVO
	 * @return
	 */
	@PostMapping("checkParam3")
	public ResponseEntity checkParam3(@Validated @RequestBody ValidationParamVO paramVO) {
		return ResponseEntity.ok().build();
	}
}
```



