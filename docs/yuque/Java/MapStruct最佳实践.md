# MapStruct最佳实践

**属性拷贝：BeanUtils不够用？试试MapStruct**

# 参考资料

- [MapStruct官网文档](https://mapstruct.org/documentation/installation/)
- [1.4.2.Final 版本官方文档：MapStruct 1.4.2.Final Reference Guide](https://mapstruct.org/documentation/stable/reference/html/)

- [1.4.2.Final 版本API](https://mapstruct.org/documentation/stable/api/)



- [网文：推荐一个 Java 实体映射工具 MapStruct](https://blog.csdn.net/zhige_me/article/details/80699784) （HelloWorld）
- [网文：mapstruct使用详解](https://www.cnblogs.com/mmzs/p/12735212.html) （有枚举类的处理）

- [网文：Mapstruct 使用教程](https://blog.csdn.net/qq_44732146/article/details/119968376) （首推，比较详细。逆映射、集成配置、共享配置、自定义类型转换）

- - 大多网文的pom都不规范，请以官方文档和本文为准

# 准备工作

1. 安装IDEA插件：mapstruct support

- - 更方便的使用 mapstruct 工具。可以使用快捷键进行提示、跳转等
  - ![img](https://cdn.nlark.com/yuque/0/2021/png/2666372/1635823285142-c9a5d909-d6b4-4dbf-a2aa-3bcfde752a94.png)

1. 版本：使用MapStruct最新稳定版本：**1.4.2.Final**
2. MapStruct + lombok 配合使用，需要指定lombok和lombok-mapstruct-binding的版本

- - 具体信息可以参考**MapStruct-1.4.2.Final**版本的官方文档

1. 按照官方文档的推荐创建项目，可查看源码**pom.xml**，三个关键点如下：

1. 1. 指定 MapStract + lombok 版本
   2. 引入 MapStract + lombok 依赖

1. 1. maven-compiler-plugin 插件配置

```xml
<!-- 1. 指定 MapStract + lombok 版本：以下三个包的版本有绑定关系，见官方文档 -->
<mapstruct.version>1.4.2.Final</mapstruct.version>
<lombok.version>1.18.16</lombok.version>
<lombok-mapstruct-binding.version>0.2.0</lombok-mapstruct-binding.version>


<!-- 2. 引入 MapStract + lombok 依赖 --> 
<dependency>
  <groupId>org.projectlombok</groupId>
  <artifactId>lombok</artifactId>
  <version>${lombok.version}</version>
  <scope>provided</scope>
</dependency>
<dependency>
  <groupId>org.mapstruct</groupId>
  <artifactId>mapstruct</artifactId>
  <version>${mapstruct.version}</version>
</dependency>


<!-- 3. maven-compiler-plugin 插件配置 -->
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-compiler-plugin</artifactId>
  <version>3.8.1</version>
  <configuration>
    <source>1.8</source>
    <target>1.8</target>
    <!-- MapStruct + lombok -->
    <annotationProcessorPaths>
      <path>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct-processor</artifactId>
        <version>${mapstruct.version}</version>
      </path>
      <path>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>${lombok.version}</version>
      </path>
      <path>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok-mapstruct-binding</artifactId>
        <version>${lombok-mapstruct-binding.version}</version>
      </path>
    </annotationProcessorPaths>
  </configuration>
</plugin>
```

# 原理

1. 定义一个名为Converter的接口，并在接口中定义转换方法：

```java
@Mapper(componentModel = "spring")
public interface PersonConverter {

    /**
     * 什么也不写，只做类型转换
     * @param person 
     * @return 
     */
    PersonDTO convertPerson2PersonDTO(Person person);
}
```

1. **编译时**，会根据转换接口，**自动生成**其实现类：

![img](https://cdn.nlark.com/yuque/0/2021/png/2666372/1635824887103-94baae21-6195-41d6-99b8-cc9e88afb40b.png)

1. **自动生成**的实现类如下：

```java
@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2021-11-02T11:38:03+0800",
    comments = "version: 1.4.2.Final, compiler: javac, environment: Java 1.8.0_261 (Oracle Corporation)"
)
@Component
public class PersonConverterImpl implements PersonConverter {

    @Override
    public PersonDTO convertPerson2PersonDTO(Person person) {
        if ( person == null ) {
            return null;
        }

        PersonDTO personDTO = new PersonDTO();

        personDTO.setId( person.getId() );
        personDTO.setName( person.getName() );
        personDTO.setEmail( person.getEmail() );

        return personDTO;
    }
}
```

1. 由此，MapStruct就帮我们完成了类的转换。对比BeanUtils：

1. 1. 功能强：BeanUtils只能是同名且同类型的属性复制，而MapStruct可以满足各种转换场景。后者功能更强大。
   2. 性能高：BeanUtils是用反射来实现，而MapStruct是用getter/setter方法。后者性能更高。

# 使用方法

## 1. 不包含任何映射规则，只做自动转换

- 测试类：`PersonConverterTest#convertPerson2PersonDTO()`
- **结论**：和BeanUtils差不多，对同名且同类型的属性进行转换。

```java
/**
 * 不包含任何映射规则，只做自动的类型转换。
 * @param person 。
 * @return 。
 */
PersonDTO person2PersonDTO(Person person);
```

## 2. 指定映射规则

- 测试类：`PersonConverterTest#convertPerson2PersonDTOWithMapping()`
- **结论**：通过`@Mapping`注解，指定映射规则

- 详细使用方法参考 `@Mapping` 注解的API

```java
@Mappings({
    // 属性名不同
    @Mapping(source = "birthday", target = "birth"),
    // 日期转字符串
    @Mapping(source = "birthday", target = "birthDateFormat", dateFormat = "yyyy-MM-dd HH:mm:ss"),
    // 使用自定义的规则来进行数据类型转换
    @Mapping(target = "birthExpressionFormat", expression = "java(org.apache.commons.lang3.time.DateFormatUtils.format(person.getBirthday(),\"yyyy-MM-dd\"))"),
    // User是Person中的一个嵌套属性
    @Mapping(source = "user.age", target = "age"),
    // 忽略这个属性 ignore
    @Mapping(target = "email", ignore = true)
})
PersonDTO convertPerson2PersonDTOWithMapping(Person person);
```

## 3. 多个对象映射到一个对象

- 测试类：`SkuConverterTest#itemAndSku2SkuDTO()`
- 结论：其实跟上面嵌套属性是类似的，就是"对象.属性"，还是比较符合直觉的

```java
@Mappings({
    @Mapping(source = "sku.id",target = "skuId"),
    @Mapping(source = "sku.code",target = "skuCode"),
    @Mapping(source = "sku.price",target = "skuPrice"),
    @Mapping(source = "item.id",target = "itemId"),
    @Mapping(source = "item.title",target = "itemName")
})
SkuDTO itemAndSku2SkuDTO(Item item, Sku sku);
```

## 4. 更新对象而不是生成对象

- 测试类：`PersonConverterTest#updatePersonDTO()`
- 结论：`@MappingTarget` 注解

```java
@Mapping(source = "email", target = "email")
void updatePersonDTO(Person person, @MappingTarget PersonDTO personDTO);
```

## 5. 业务场景举例

- 代码：OrderConverter
- 测试类：OrderConverterTest

## 其他特性

- 枚举类型的处理：@ValueMapping、官方文档-8

- 逆映射：@InheritInverseConfiguration。

- - 可选：name = 方法名。否则自动选择

- 继承配置：@InheritConfiguration

- - 可选：name = 方法名。否则自动选择

- 共享配置：@MapperConfig
- 自定义类型转换方法：

- @Qualifier 和 @Name
- 集合映射

- SPI（Service Provider Interface）：官方文档-13

# 一些坑

1. 如果是一个Module，必须使用父pom进行依赖，否咋无法自动编译，应该是生成的路径有问题。

1. 1. 暂时没有深究，正常的用法是没问题的。

1. 自动编译如果遇到问题（概率不高）：无脑 Ctrl + F9，或者 maven clean

# 