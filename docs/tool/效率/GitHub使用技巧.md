## github 使用技巧

参考网址:https://mp.weixin.qq.com/s/Ugk3bnjLBjDzLqOD_bZn6Q


2. 明确搜索 star、fork 数大于多少的
stars: > 数字  关键字。

比如咱们要找 star 数大于 3000 的Spring Cloud 仓库，就可以这样

stars:>3000 spring cloud

3. 明确搜索仓库大小的

比如你只想看个简单的 Demo，不想找特别复杂的且占用磁盘空间较多的，可以在搜索的时候直接限定仓库的 size 。

使用方式：

 size:>=5000 关键词    

这里注意下，这个数字代表K, 5000代表着5M。

4. 明确仓库是否还在更新维护

我们在确认是否要使用一些开源产品，框架的时候，是否继续维护是很重要的一点。如果已经过时没人维护的东西，踩了坑就不好办了。而在 GitHub 上找项目的时候，不再需要每个都点到项目里看看最近 push 的时间，直接在搜索框即可完成。

元旦刚过，比如咱们要找临近年底依然在勤快更新的项目，就可以直接指定更新时间在哪个时间前或后的 

通过这样一条搜索  pushed:>2019-01-03 spring cloud

咱们就找到了1月3号之后，还在更新的项目。

5. 明确搜索仓库的 LICENSE

咱们经常使用开源软件，一定都知道，开源软件也是分不同的「门派」不同的LICENSE。开源不等于一切免费，不同的许可证要求也大不相同。2018年就出现了 Facebook 修改 React 的许可协议导致各个公司纷纷修改自己的代码，寻找替换的框架。
例如咱们要找协议是最为宽松的 Apache License 2 的代码，可以这样

license:apache-2.0 spring cloud

6. 明确搜索仓库的语言
比如咱们就找 Java 的库， 除了像上面在左侧点击选择之外，还可以在搜索中过滤。像这样：
language:java  关键词

7.明确搜索某个人或组织的仓库

比如咱们想在 GitHub 上找一下某个大神是不是提交了新的功能，就可以指定其名称后搜索，例如咱们看下 Josh Long 有没有提交新的 Spring Cloud 的代码，可以这样使用

user:joshlong

--- 

## Github 下载慢
通过查看下载链接，能够发现最终被指向到Amazon的服务器（http://github-cloud.s3.amazonaws.com）了。由于国内访问亚马逊网站非常慢，我们需要修改Hosts文件来实现流畅访问。

### 第一步，打开本机上的Hosts文件  

首先，什么是Hosts文件？

> 在互联网协议中，host表示能够同其他机器互相访问的本地计算机。一台本地机有唯一标志代码，同网络掩码一起组成IP地址，如果通过点到点协议通过ISP访问互联网，那么在连接期间将会拥有唯一的IP地址，这段时间内，你的主机就是一个host。
>
> 在这种情况下，host表示一个网络节点。host是根据TCP/IP for Windows 的标准来工作的，它的作用是包含IP地址和Host name(主机名)的映射关系，是一个映射IP地址和Host name(主机名)的规定，规定要求每段只能包括一个映射关系，IP地址要放在每段的最前面，空格后再写上映射的Host name主机名　。对于这段的映射说明用“#”分割后用文字说明。

#### ~Windows

Hosts文件的路径是：

> *C:\Windows\System32\drivers\etc*

由于文件没有后缀名，可以利用鼠标右键点击，选择用记事本打开，如下图。

![img](https:////upload-images.jianshu.io/upload_images/10482796-b3d057d8d3b69f5f.png?imageMogr2/auto-orient/strip|imageView2/2/w/646/format/webp)

#### ~Mac  

终端内输入：

> sudo vim /etc/hosts

打开之后，我们就要向里面追加信息了。

### 第二步，追加域名的IP地址

我们可以利用https://www.ipaddress.com/ 来获得以下两个GitHub域名的IP地址：

(1) github.com

(2) github.global.ssl.fastly.net

打开网页后，利用输入框内分别查询两个域名：

![img](https:////upload-images.jianshu.io/upload_images/10482796-d4b8d060d057b6f1.png?imageMogr2/auto-orient/strip|imageView2/2/w/974/format/webp)

先试一下github.com：

![img](https:////upload-images.jianshu.io/upload_images/10482796-c26549b216011c9a.png?imageMogr2/auto-orient/strip|imageView2/2/w/1080/format/webp)

在标注的IP地址中，任选一个记录下来。

再来是github.global.ssl.fastly.net：

![img](https:////upload-images.jianshu.io/upload_images/10482796-2748b78e2e38b87d.png?imageMogr2/auto-orient/strip|imageView2/2/w/1080/format/webp)

将以上两段IP写入Hosts文件中：

![img](https:////upload-images.jianshu.io/upload_images/10482796-c789141b563632cf.png?imageMogr2/auto-orient/strip|imageView2/2/w/917/format/webp)

保存。

###  **第三步，****刷新 DNS 缓存** 

在终端或CMD中，执行以下命令：

> ipconfig /flushdns

收工。

现在再来试一下 git clone 命令，是不是可以轻松过百K了? :)





##  方法二:从Gitee中导入github内容

 将github中的内容导入到gitee中

 ![gitee.png](https://user-gold-cdn.xitu.io/2020/3/9/170be65787dcaeed?w=1189&h=600&f=png&s=48475)



## 方法三:设置代理

```shell
#添加全局代理
git config --global http.proxy http://127.0.0.1:34828
git config --global https.proxy https://127.0.0.1:34828
#取消全局代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```


