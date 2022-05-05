# @Valid-参数验证

# 参考

- [@Valid注解是什么](https://blog.csdn.net/weixin_38118016/article/details/80977207)
- [接口入参验证](https://blog.csdn.net/zhoubingzb/article/details/88311624)

- [@Valid和@Validated的总结区分](https://blog.csdn.net/gaojp008/article/details/80583301)
- [@Validated @RequestBody @RequestParam配合使用校验参数](https://www.cnblogs.com/cjyboy/p/11465876.html)

# 常用注解

常用注解都在 `javax.validation.constraints` 包里面：



- `@AssertFalse` / `@AssertTrue` ： 用于Boolean
- `@DecimalMax` / `@DecimalMin` / `@Max` / `@Min` ：数字最大值、最小值

- `@Digits` ：数字在允许范围内，几位整数、几位小数
- `@Future` / `@FutureOrPresent` / `@Past` / `@PastOrPresent` ：时间、日期

- `@Positive` / `@PositiveOrZero` / `@Negative` / `@NegativeOrZero` ：正数、负数
- `@NotBlank` / `@NotEmpty` / `@NotNull` / `@Null` ：trim后非空、非空字符串、非Null、Null

- `@Pattern` ：正则
- `@Size` ：集合的长度

- `@Email` ：电子邮件格式

# 使用方式

- 对于`@PathVariable`和`@RequestParam`，在controller上加`@Validated`注解，在参数上做验证
- 对于`@RequestBody`，在变量前面加`@Validated`，在类属性里面做验证

```java
@Validated
@RestController
@RequestMapping("/demo")
public class DemoController {

    @GetMapping("/{id}")
    public ResponseEntity getById(@Positive(message = "id >= 0") @PathVariable Long id) {
        return new ResponseEntity(LocalDateTime.now(), HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity get(@Digits(integer = 5, fraction = 3) @RequestParam BigDecimal id) {
        return new ResponseEntity(LocalDateTime.now(), HttpStatus.OK);
    }

    @PutMapping
    @ApiOperation("更新")
    public ResponseEntity save(@Validated @RequestBody Demo demo) {
        return new ResponseEntity(LocalDateTime.now(), HttpStatus.OK);
    }
    
    // 验证多个参数
    @PostMapping("/do")
    public String doSomething(@Validated Demo demo1, @Validated Foo demo2) {
        return "do something ...";
    }
}
```

# 对象嵌套的验证

在嵌套的对象上加`@Valid`注解：

```java
@ApiModel(description = "demo")
@Data
public class Demo {

    @ApiModelProperty(value = "id", example = "id")
    @NotNull(message = "id不为空")
    private String id;

    @ApiModelProperty(value = "名称", example = "name")
    @NotBlank(message = "name不为空")
    private String name;

    // 嵌套验证
    @Valid
    @ApiModelProperty("Foo")
    private Foo foo;
}

@ApiModel(description = "foo")
@Data
public class Foo {

    @NotBlank(message = "foo不为空")
    private String foo;

    @NotBlank(message = "bar不为空")
    private String bar;
}
```

# 异常处理

- 对于`@RequestParam`和`@PathVariable`，拦截`ConstraintViolationException` 异常，他的父类是 `ValidationException` ，也有拦截这个的
- 对于`@RequestBody`，拦截`MethodArgumentNotValidException`异常

- 验证多个参数的情况应该不会用到，拦截`BindException` 异常

```java
@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 全局处理 {@link org.springframework.web.bind.annotation.RequestParam} 和
     * {@link org.springframework.web.bind.annotation.PathVariable} 的校验异常
     * @param e
     * @return
     */
    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity handlerConstraintViolationException(ConstraintViolationException e) {
        // 状态码随便写个500，不要学
        return new ResponseEntity("自定义异常：" + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
    }

    /**
     * 全局处理 {@link org.springframework.web.bind.annotation.RequestBody} 的异常
     * @param e
     * @return
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity handlerMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        BindingResult bindingResult = e.getBindingResult();
        List<String> messageList = bindingResult.getFieldErrors().stream()
                            .map(fieldError -> fieldError.getField() + ": " + fieldError.getDefaultMessage())
                            .collect(Collectors.toList());
        String result = String.join(", \n", messageList);
        // 状态码随便写个500，不要学
        return new ResponseEntity("自定义异常：" + result, HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    /**
     * 多个参数， 只对应这个 {@link com.xi.valid.controller.DemoController#doSomething(Demo, Foo)}
     * @param e
     * @return
     */
    @ExceptionHandler(BindException.class)
    public ResponseEntity handlerBindException(BindException e) {
        List<String> messageList = e.getBindingResult().getAllErrors().stream()
                .map(objectError -> objectError.getObjectName() + ": " + objectError.getDefaultMessage())
                .collect(Collectors.toList());
        return new ResponseEntity("自定义异常-BindException：" + String.join(", \n", messageList),
                HttpStatus.INTERNAL_SERVER_ERROR);
    }

}
```

# 自定义校验器

## 使用示例

```java
	// 使用
    @InConstraint(value = {"1", "2", "3"}, message = "只能输入1、2、3")
    private String custom;
```

## 定义注解

```java
// 这里写校验器 InConstraintValidator
@Constraint(validatedBy = {InConstraintValidator.class})
@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface InConstraint {
    String[] value();
    String message();
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```

## 校验类

校验器可以对每种数据类型都做一个，如String/Integer等等，详见`ConstraintValidator`的各种实现类：

```java
@Slf4j
public class InConstraintValidator implements ConstraintValidator<InConstraint, String> {

    private String[] allowed;

    @Override
    public void initialize(InConstraint constraintAnnotation) {
        /*
        constraintAnnotation 里面有注解的信息
         */
        this.allowed = constraintAnnotation.value();
    }

    /**
     *
     * @param value value的类型由泛型上面决定，这里是String。可以配置多个类型的校验器
     * @param context
     * @return
     */
    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        for (String str : this.allowed) {
            if (str.equals(value)) {
                return true;
            }
        }
        return false;
    }
}
```



# `@Validated`的其他特性

分组、顺序、验证多个对象等，见 [@Valid和@Validated的总结区分](https://blog.csdn.net/gaojp008/article/details/80583301)



若有收获，就点个赞吧