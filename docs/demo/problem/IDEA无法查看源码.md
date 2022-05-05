

## Intellij-Cannot download Sources解决方法



当你点击Dowload Sources的时候它会报一个错误[无法查看源码]



![image-20211102180421044](https://gitee.com/VincentBlog/image/raw/master/image/20211102180428.png)



### 方法一：mvn dependency:resolve -Dclassifier=sources

在`Terminal`输入

```
mvn dependency:resolve -Dclassifier=sources
```





![image-20211102180619660](https://gitee.com/VincentBlog/image/raw/master/image/20211102180619.png)



### 方法二：设置setting

设置Maven home directory：

![image-20211102180834998](https://gitee.com/VincentBlog/image/raw/master/image/20211102180835.png)

### 方法三：设置maven sources

![image-20211102180944878](https://gitee.com/VincentBlog/image/raw/master/image/20211102180944.png)