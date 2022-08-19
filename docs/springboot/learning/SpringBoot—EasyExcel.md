## EasyExcel使用说明



## 前言



**博客说明**

> 文章所涉及的资料来自互联网整理和个人总结，意在于个人学习和经验汇总，如有什么地方侵权，请联系本人删除，谢谢！

### 一、EasyExcel注解说明

#### `@ExcelProperty`

这是最常用的一个注解，注解中有三个参数`value`,`index`,`converter`分别代表列明，列序号，数据转换方式，`value`和`index`只能二选一，通常不用设置`converter`

```java
public class ImeiEncrypt {
    @ExcelProperty(value = "imei")
    private String imei;
}
```

#### `@ColumnWith`

用于设置列宽度的注解,注解中只有一个参数value，value的单位是字符长度，最大可以设置255个字符，因为一个excel单元格最大可以写入的字符个数就是255个字符。

```java
public class ImeiEncrypt {
    @ColumnWidth(value = 18)
    private String imei;
}
```

#### `@ContentFontStyle`

用于设置单元格内容字体格式的注解

参数：

| 参数                 | 含义               |
| -------------------- | ------------------ |
| `fontName`           | 字体名称           |
| `fontHeightInPoints` | 字体高度           |
| `italic`             | 是否斜体           |
| `strikeout`          | 是否设置删除水平线 |
| `color`              | 字体颜色           |
| `typeOffset`         | 偏移量             |
| `underline`          | 下划线             |
| `bold`               | 是否加粗           |
| `charset`            | 编码格式           |

#### `@ContentLoopMerge`

用于设置合并单元格的注解

参数：

| 参数           | 含义 |
| -------------- | ---- |
| `eachRow`      |      |
| `columnExtend` |      |

#### `@ContentRowHeight`

用于设置行高

参数：

| 参数  | 含义                   |
| ----- | ---------------------- |
| value | 行高，`-1`代表自动行高 |

#### `@ContentStyle`

设置内容格式注解

参数：

| 参数                  | 含义                                                         |
| --------------------- | ------------------------------------------------------------ |
| `dataFormat`          | 日期格式                                                     |
| `hidden`              | 设置单元格使用此样式隐藏                                     |
| `locked`              | 设置单元格使用此样式锁定                                     |
| `quotePrefix`         | 在单元格前面增加`符号，数字或公式将以字符串形式展示          |
| `horizontalAlignment` | 设置是否水平居中                                             |
| `wrapped`             | 设置文本是否应换行。将此标志设置为`true`通过在多行上显示使单元格中的所有内容可见 |
| `verticalAlignment`   | 设置是否垂直居中                                             |
| `rotation`            | 设置单元格中文本旋转角度。03版本的Excel旋转角度区间为-90°~90°，07版本的Excel旋转角度区间为0°~180° |
| `indent`              | 设置单元格中缩进文本的空格数                                 |
| `borderLeft`          | 设置左边框的样式                                             |
| `borderRight`         | 设置右边框样式                                               |
| `borderTop`           | 设置上边框样式                                               |
| `borderBottom`        | 设置下边框样式                                               |
| `leftBorderColor`     | 设置左边框颜色                                               |
| `rightBorderColor`    | 设置右边框颜色                                               |
| `topBorderColor`      | 设置上边框颜色                                               |
| `bottomBorderColor`   | 设置下边框颜色                                               |
| `fillPatternType`     | 设置填充类型                                                 |
| `fillBackgroundColor` | 设置背景色                                                   |
| `fillForegroundColor` | 设置前景色                                                   |
| `shrinkToFit`         | 设置自动单元格自动大小                                       |

#### `@HeadFontStyle`

用于定制标题字体格式

| 参数                 | 含义             |
| -------------------- | ---------------- |
| `fontName`           | 设置字体名称     |
| `fontHeightInPoints` | 设置字体高度     |
| `italic`             | 设置字体是否斜体 |
| `strikeout`          | 是否设置删除线   |
| `color`              | 设置字体颜色     |
| `typeOffset`         | 设置偏移量       |
| `underline`          | 设置下划线       |
| `charset`            | 设置字体编码     |
| `bold`               | 设置字体是否家畜 |

#### `@HeadRowHeight`

设置标题行行高

| 参数    | 含义                     |
| ------- | ------------------------ |
| `value` | 设置行高，-1代表自动行高 |

#### `@HeadStyle`

设置标题样式

| 参数                  | 含义                                                         |
| --------------------- | ------------------------------------------------------------ |
| `dataFormat`          | 日期格式                                                     |
| `hidden`              | 设置单元格使用此样式隐藏                                     |
| `locked`              | 设置单元格使用此样式锁定                                     |
| `quotePrefix`         | 在单元格前面增加`符号，数字或公式将以字符串形式展示          |
| `horizontalAlignment` | 设置是否水平居中                                             |
| `wrapped`             | 设置文本是否应换行。将此标志设置为`true`通过在多行上显示使单元格中的所有内容可见 |
| `verticalAlignment`   | 设置是否垂直居中                                             |
| `rotation`            | 设置单元格中文本旋转角度。03版本的Excel旋转角度区间为-90°~90°，07版本的Excel旋转角度区间为0°~180° |
| `indent`              | 设置单元格中缩进文本的空格数                                 |
| `borderLeft`          | 设置左边框的样式                                             |
| `borderRight`         | 设置右边框样式                                               |
| `borderTop`           | 设置上边框样式                                               |
| `borderBottom`        | 设置下边框样式                                               |
| `leftBorderColor`     | 设置左边框颜色                                               |
| `rightBorderColor`    | 设置右边框颜色                                               |
| `topBorderColor`      | 设置上边框颜色                                               |
| `bottomBorderColor`   | 设置下边框颜色                                               |
| `fillPatternType`     | 设置填充类型                                                 |
| `fillBackgroundColor` | 设置背景色                                                   |
| `fillForegroundColor` | 设置前景色                                                   |
| `shrinkToFit`         | 设置自动单元格自动大小                                       |

#### `@ExcelIgnore`

不将该字段转换成Excel

#### `@ExcelIgnoreUnannotated`

没有注解的字段都不转换

### 二、SpringBoot集成EasyExcel

#### 2.1 引入依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>spring-boot-learning</artifactId>
        <groupId>com.whcoding</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>demo-easyexcel</artifactId>

    <!--模块版本-->
    <version>1.0.0-SNAPSHOT</version>
    <!--打包方式-->
    <packaging>jar</packaging>

    <!--设置版本-->
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
        <swagger.version>2.9.2</swagger.version>
        <fastjson.version>1.2.75</fastjson.version>
    </properties>

    <dependencies>
        <!--springboot启动类-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <!--springboot 测试类-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <!--Hutool Java工具包-->
        <dependency>
            <groupId>cn.hutool</groupId>
            <artifactId>hutool-all</artifactId>
        </dependency>

        <!--lombok依赖-->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>

        <!--EasyExcel相关依赖-->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>easyexcel</artifactId>
            <version>3.0.5</version>
        </dependency>

        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger2</artifactId>
            <version>${swagger.version}</version>
        </dependency>

        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger-ui</artifactId>
            <version>${swagger.version}</version>
        </dependency>

        <!-- https://mvnrepository.com/artifact/com.alibaba/fastjson -->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
            <version>${fastjson.version}</version>
        </dependency>

    </dependencies>


    <!--build 插件以及名称-->
    <build>
        <finalName>demo-easyexcel</finalName>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
```

## 参考

[EasyExcel使用说明官网](https://www.yuque.com/easyexcel/doc/easyexcel)

[EasyExcel](https://alibaba-easyexcel.github.io/)

[Excel注解说明](https://juejin.cn/post/6844904177974542343)