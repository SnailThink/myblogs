## IntelliJ Idea 常用11款插件

> 原文地址:https://blog.csdn.net/weixin_41846320/article/details/82697818
>
> [IDEA插件推荐](https://blog.csdn.net/weixin_46285416/article/details/107853987)
>
> [Intellij IDEA 神级插件](https://mp.weixin.qq.com/s/AMCUUKP7ZTU2wIMiPUdhKw)



### 插件安装方式

插件安装，可以直接在IDEA的插件库中实时搜索安装。`browse plugin repository`

对于**网络不好**的用户，可以登录官方插件仓库地址：[https://plugins.jetbrains.com/idea](https://links.jianshu.com/go?to=https%3A%2F%2Fplugins.jetbrains.com%2Fidea)，下载压缩包之后，选择`install from disk`



插件安装方式：

![image-20220617182055339](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182055339.png)



### 基础插件

新版本IDE安装方式略有不同，不一一赘述 

#### **1、Background Image Plus**

  这款插件并不能直接提高你的开发效率，但是可以让你面对的IDE不再单调，当把背景设置成你自己心仪的的图片，

是不是会感觉很赏心悦目，编码效率会不会因此间接的提高？！

 

![image-20220617182112158](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182112158.png)

使用方法：

![image-20220617182123438](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182123438.png)



![image-20220617182134743](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182134743.png)

注意，如果是IDEA版本是2020.1版本以上就不需要再额外装这个插件，这个插件是已经内置安装了。

####  **2、Mybatis Log Plugin**

Mybatis现在是java中操作数据库的首选，在开发的时候，我们都会把Mybatis的脚本直接输出在console中，

但是默认的情况下，输出的脚本不是一个可以直接执行的。

![image-20220617182142462](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182142462.png)

如果我们想直接执行，还需要在手动转化一下，比较麻烦。
MyBatis Log Plugin 这款插件是直接将Mybatis执行的sql脚本显示出来，无需处理，可以直接复制出来执行的 。

Tools -- >  Mybatis Log Plugin  打开其日志框，注意其转换的SQL不是输出到IDE的控制台!!!

![image-20220617182152022](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182152022.png)

再执行， 效果是不是很赞

![image-20220617182205741](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182205741.png)

 

#### **3、Grep Console**

由于Intellij idea不支持显示ascii颜色，grep-console插件能很好的解决这个问题， 可以设置不同级别log的字体颜色和背景色.

![image-20220617182215895](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182215895.png)



![image-20220617182227216](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182227216.png)

自定义设置后，可以运行下项目看下效果 

![image-20220617182240895](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182240895.png) 

 

#### **4、CodeGlance** 

CodeGlance是一款代码编辑区缩略图插件，可以快速定位代码，使用起来比拖动滚动条方便多了

![image-20220617182254625](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182254625.png)



![image-20220617182307423](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182307423.png)

#### **5、GenerateAllSetter**

一款效率插件，它主要有以下功能： 

- 通过alt+enter对变量类生成对类的所有setter方法的调用
- 当两个对象具有相同的字段时生成一个转换器
- 当returnType为List Set Map时生成默认值
- 在所有getter方法上生成对assertThat的调用

![img](https:////upload-images.jianshu.io/upload_images/8514567-2319658ade6ab006.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

#### **6、RestfulToolkit**

一套 RESTful 服务开发辅助工具集。

- **1.根据 URL 直接跳转到对应的方法定义 ( 快捷键搜索 \**Ctrl + Alt + N\** );** ---这个个人感觉非常好用，和Ctrl + F一样重要。
- 2.提供了一个 Services tree 的显示窗口;
- 3.一个简单的 http 请求工具;
- 4.在请求方法上添加了有用功能: 复制生成 URL;,复制方法参数...
- 5.其他功能: java 类上添加 Convert to JSON 功能，格式化 json 数据 ( Windows: Ctrl + Enter; Mac: Command + Enter )。

  安装后，右侧会有RestServices侧边栏，点击打开

![image-20220617182332911](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182332911.png)

 全局快捷搜索快捷键：*Ctrl \* 

 

#### **7、Maven Helper** 

分析依赖冲突插件

此插件可用来方便显示maven的依赖树，在没有此插件时，如果想看maven的依赖树需要输入命令行： mvn dependency:tree 才可查看依赖。如果想看是否有依赖包冲突的话也需要输入命令行等等的操作。而如果安装Maven Helper插件就可免去命令行困扰。通过界面即可操作完成。

使用方式：

打开项目中的pom文件，在底部会显示一个“Dependency Analyzer”,

C![image-20220617182351903](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182351903.png)

点击此按钮，切换到此工具栏

![img](https://img-blog.csdnimg.cn/20190121103011805.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTg0NjMyMA==,size_16,color_FFFFFF,t_70)

可进行相应操作：

- Conflicts（查看冲突）
- All Dependencies as List（列表形式查看所有依赖）
- All Dependencies as Tree（树形式查看所有依赖）
- 搜索功能

 

#### **8、JRebel**

热部署插件，让你在修改完代码后，不用再重新启动，很实用！但是，不是免费的，需要大家发挥下聪明才智自行百度破解！

（附一个参考地址：https://blog.csdn.net/qierkang/article/details/95095954）

安装好之后界面布局： 

![image-20220617182406102](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182406102.png)

 检查几个必要的设置看是否已配置，否则热部署可能没效果：

1）设置项目自动编译

![image-20220617182416551](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182416551.png)

2）设置 compiler.automake.allow.when.app.running 

快捷键ctrl+shift+A 或者 菜单help->find action…打开搜索框搜索“registry”

![image-20220617182424406](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182424406.png)



![image-20220617182434494](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182434494.png)

3）需要热部署的项目在此处是否勾选

![image-20220617182444655](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182444655.png)

#### **9、 Json Parser**

厌倦了打开浏览器格式化和验证JSON?为什么不安装JSON解析器并在IDE中使用离线支持呢?JSON解析器是一个用于验证和格式化JSON字符串的轻量级插件。

![image-20220617182453022](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182453022.png)

#### **10、Translation**

中英文翻译工具，之所以要把它也单独列出来，是使用起来真的很方便，不用再和其他翻译工具之间来回切换了。

#### **11、CamelCase**

大小写转换、驼峰式转换,下划线转驼峰、驼峰转下划线 快捷键[shift+alt+u]

官方介绍的特点：

- 多种翻译引擎.
  - 谷歌翻译.
  - 雅虎翻译.
  - 百度翻译.
- 多种语音互译.
- 文档注释翻译
- 文本转语音
- 自动选词

使用方式：

安装成功后，会在如图区域显示两个图标，

![img](https://img-blog.csdnimg.cn/20200420194550701.png)

可以点击图标调出不同的对话框进行搜索翻译

![image-20220617182521643](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182521643.png)



选择Translate，可以直接调出翻译面板，

![image-20220617182530029](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182530029.png)

选择Translate and Replace，可以直接将翻译结果显示在下拉框中，选择合适的点击之后会自动替换当前文本
![image-20220617182541850](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182541850.png)

以上两个右键操作可以使用快捷键 Ctrl + Shift + Y 和 Ctrl + Shift + X来代替

还有一种非常好用的功能，对于英文不是太好阅读源码英文文档比较吃力的，可以实现一键翻译，very nice！

就拿阅读java.lang.String的源码来说，进入到内部后，使光标处在文档注释区域，随便任何位置，然后右键，选择Translate Documentation,立马就有翻译出来，并且自动排版，非常易于阅读

![image-20220617182553925](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182553925.png)

#### **12、aiXcode & codota**

aiXcoder是一个强大的代码完成器和代码搜索引擎，基于最新的深度学习技术。 它有可能向您推荐一整套代码，这将帮助您更快地编写代码。 aiXcoder还提供了一个代码搜索引擎，以帮助您在GitHub上搜索API用例。

类似功能的插件还有codota，
codota基于数百万个开源Java程序和您的上下文来完成代码行，从而帮助您以更少的错误更快地进行编码。新版本的codota提供以下功能：

- 全线AI自动完成
- 内联和相关代码示例
- 根据用户自己的编码实践进行编码建议

不用担心你的代码会被公开。 codota不会将你的代码发送到codota服务器，它只会从当前编辑的文件中发送最少的上下文信息，从而使codota能够根据你当前的本地范围进行预测。

个人觉得代码示例功能要比aiCode的代码搜索引擎要方便好用的多，

 比如我想知道list.stream.map(..)方法的参考使用,只需要光标定位在map上，然后右键选择菜单“Get relevant examples”或者使用快捷键“Ctrl + Shift + O”就可以快速搜索出来很多示例，非常方便。

![image-20220617182607791](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182607791.png)

其实个人觉得IDEA自带的代码自动提示补全功能就已经非常智能好用，如果只是想使用这一功能，就没必要再装以上两款插件。

 



#### 13.GenerateSerialVersionUID

![img](https:////upload-images.jianshu.io/upload_images/8514567-f4cbc1fa2d2be65d?imageMogr2/auto-orient/strip|imageView2/2/w/1108/format/webp)

------

###  **主题美化篇**

**1、Material Theme UI**

Material Theme UI是JetBrains IDE（IntelliJ IDEA，WebStorm，Android Studio等）的插件，可将原始外观更改为Material Design外观。
该插件最初受Sublime Text的Material Theme启发，提供了一系列的设置，可按所需方式调整IDE。 除了令人印象深刻的主题调色板外，它还提供：

- 漂亮的配色方案支持绝大多数语言
- 用彩色的“材料设计”图标替换所有图标
- 自定义大多数IDE的控件和组件

安装后重启IDE会先进入主题设置导航页，按照提示一步一步设置

![image-20220617182618238](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182618238.png)

![image-20220617182630317](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182630317.png)

 

设置好后的效果
![image-20220617182640007](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182640007.png)

 还可以继续在setting中进行自定义设置：

![img](https://img-blog.csdnimg.cn/2019122518095330.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MTg0NjMyMA==,size_16,color_FFFFFF,t_70)

**2、Rainglow Color Schemes** 

一款颜色主题集合插件

 安装后到file->settings->Editor->Color Schemes 进行选择设置

![image-20220617182653670](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182653670.png)

 设置后效果，各种效果可自行设置体验

![image-20220617182706191](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220617182706191.png)

### 字体美化 

Intellij IDEA 公司 JetBrains 推出了一种新字体：JetBrains Mono，它是专为开发人员设计的。从 2019.3 版本开始，JetBrains Mono 字体将随 JetBrains 系列 IDEs 一起提供。老版本的话，,安装方式可以参见本博客另一文章介绍：
[IDEA JetBrains Mono字体介绍和安装](https://blog.csdn.net/weixin_41846320/article/details/104058969)

### IDEA 设置字体格式

https://blog.csdn.net/frankcheng5143/article/details/50779149

------

### **其他还有一些插件，根据实际情况选择使用** 

- 阿里代码规约检测：Alibaba Java Coding Guidelines
- 自动生成序列图插件：SequenceDiagram
- 快捷键提示工具：Key promoter X
- 代码注解插件： Lombok
- 代码生成工具：CodeMaker
- 代码质量检查工具：SonarLint
- 单元测试测试生成工具：JUnitGenerator
- Mybatis 工具：Free Mybatis plugin
- JSON转领域对象工具：GsonFormat
- 字符串工具：String Manipulation
- Redis可视化：Iedis
- K8s工具：Kubernetes
- 彩虹颜色括号：Rainbow Brackets

### 我的IDEA插件

![image-20220629152217860](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220629152217860.png)

### 



