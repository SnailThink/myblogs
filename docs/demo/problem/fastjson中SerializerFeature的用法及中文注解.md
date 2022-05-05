## fastjson中SerializerFeature用法



```java
package com.alibaba.fastjson.serializer;

public enum SerializerFeature {


    QuoteFieldNames,//输出key时是否使用双引号,默认为true 


    /**
     *
     */


    UseSingleQuotes,//使用单引号而不是双引号,默认为false


    /**
     *
     */


    WriteMapNullValue,//是否输出值为null的字段,默认为false 


    /**
     *
     */


    WriteEnumUsingToString,//Enum输出name()或者original,默认为false


    /**
     *
     */


    UseISO8601DateFormat,//Date使用ISO8601格式输出，默认为false


    /**
     * @since 1.1
     */


    WriteNullListAsEmpty,//List字段如果为null,输出为[],而非null 


    /**
     * @since 1.1
     */


    WriteNullStringAsEmpty,//字符类型字段如果为null,输出为"",而非null 


    /**
     * @since 1.1
     */


    WriteNullNumberAsZero,//数值字段如果为null,输出为0,而非null 


    /**
     * @since 1.1
     */


    WriteNullBooleanAsFalse,//Boolean字段如果为null,输出为false,而非null


    /**
     * @since 1.1
     */


    SkipTransientField,//如果是true，类中的Get方法对应的Field是transient，序列化时将会被忽略。默认为true


    /**
     * @since 1.1
     */


    SortField,//按字段名称排序后输出。默认为false


    /**
     * @since 1.1.1
     */


    @Deprecated


    WriteTabAsSpecial,//把\t做转义输出，默认为false


    /**
     * @since 1.1.2
     */


    PrettyFormat,//结果是否格式化,默认为false


    /**
     * @since 1.1.2
     */


    WriteClassName,//序列化时写入类型信息，默认为false。反序列化是需用到


    /**
     * @since 1.1.6
     */


    DisableCircularReferenceDetect,//消除对同一对象循环引用的问题，默认为false


    /**
     * @since 1.1.9
     */


    WriteSlashAsSpecial,//对斜杠'/'进行转义


    /**
     * @since 1.1.10
     */


    BrowserCompatible,//将中文都会序列化为\uXXXX格式，字节数会多一些，但是能兼容IE 6，默认为false


    /**
     * @since 1.1.14
     */


    WriteDateUseDateFormat,//全局修改日期格式,默认为false。JSON.DEFFAULT_DATE_FORMAT = "yyyy-MM-dd";JSON.toJSONString(obj, SerializerFeature.WriteDateUseDateFormat);


    /**
     * @since 1.1.15
     */


    NotWriteRootClassName,//暂不知，求告知


    /**
     * @since 1.1.19
     */


    DisableCheckSpecialChar,//一个对象的字符串属性中如果有特殊字符如双引号，将会在转成json时带有反斜杠转移符。如果不需要转义，可以使用这个属性。默认为false 


    /**
     * @since 1.1.35
     */

    BeanToArray 

    private SerializerFeature() {
        mask = (1 << ordinal());
    }

    private final int mask;

    public final int getMask() {
        return mask;
    }

    public static boolean isEnabled(int features, SerializerFeature feature) {
        return (features & feature.getMask()) != 0;
    }

    public static int config(int features, SerializerFeature feature, boolean state) {
        if (state) {
            features |= feature.getMask();
        } else {
            features &= ~feature.getMask();
        }
        return features;
    }
    }

```

**用法方法：**

```java
JSONObject outParam1 = new JSONObject ();
String str = JSONObject.toJSONString(outParam,SerializerFeature.WriteNullStringAsEmpty);
```

