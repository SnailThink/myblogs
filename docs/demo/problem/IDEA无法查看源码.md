

## Intellij-Cannot download Sources解决方法



当你点击Dowload Sources的时候它会报一个错误[无法查看源码]



![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530180224.png)



### 方法一：mvn dependency:resolve -Dclassifier=sources

在`Terminal`输入

```
mvn dependency:resolve -Dclassifier=sources
```





![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530180254.png)



### 方法二：设置setting

设置Maven home directory：

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530180306.png)

### 方法三：设置maven sources

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530180316.png)