## **windows环境搭建Vue开发环境**

参考地址:https://www.cnblogs.com/zhaomeizi/p/8483597.html

https://blog.csdn.net/zalan01408980/article/details/80029706

**一、安装node.js（https://nodejs.org/en/）**

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181651.png)

下载完毕后，可以安装node，建议不要安装在系统盘（如C：）。

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181649.png)

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181658.png)

**二、**cmd命令行：

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181645.png)

[npm](https://www.baidu.com/s?wd=npm&tn=24004469_oem_dg&rsv_dl=gh_pl_sl_csd) -v //显示npm包管理器版本 

1. 由于有些npm有些资源被屏蔽或者是国外资源的原因，经常会导致用npm安装依赖包的时候失败，所有我还需要npm的国内镜像---cnpm

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181704.png)

-cnpm

Cmd命令行中输入  npm install -g cnpm --registry=http://registry.npm.taobao.org

安装vue-cli[脚手架](https://www.baidu.com/s?wd=脚手架&tn=24004469_oem_dg&rsv_dl=gh_pl_sl_csd)构建工具   npm install -g vue-cli

**四、设置环境变量****（非常重要）**

说明：设置环境变量可以使得住任意目录下都可以使用cnpm、vue等命令，而不需要输入全路径

1、鼠标右键"此电脑"，选择“属性”菜单，在弹出的“系统”对话框中左侧选择“高级系统设置”，弹出“系统属性”对话框。

2、修改系统变量PATH

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181641.png)

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181623.png)

3、新增系统变量NODE_PATH

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181623.png)

**五、安装Vue**

cnpm install vue -g

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181623.png)

**六、安装vue命令行工具，即vue-cli 脚手架**

cnpm install vue-cli -g

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181623.png)

 **七、新项目的创建**

1.打开存放新建项目的文件夹

打开开始菜单，输入 CMD，或使用快捷键 win+R，输入 CMD，敲回车，弹出命令提示符。打开你将要新建的项目目录

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181623.png)

2.根据模版创建新项目

在当前目录下输入“vue init webpack-simple 项目名称（使用英文）”。

vue init webpack-simple mytest

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181623.png)

初始化完成后的项目目录结构如下：

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181714.png)

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181717.png)

3、安装工程依赖模块

定位到mytest的工程目录下，安装该工程依赖的模块，这些模块将被安装在：mytest\node_module目录下，node_module文件夹会被新建，而且根据package.json的配置下载该项目的modules

cd mytest

cnpm install

4、运行该项目，测试一下该项目是否能够正常工作，这种方式是用nodejs来启动。

cnpm run dev

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181720.png)

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181723.png)

![img](https://gitee.com/VincentBlog/image/raw/master/image/20211103181727.png)

八、借鉴网址：

https://www.cnblogs.com/zhouyu2017/p/6485265.html

https://www.cnblogs.com/ixxonline/p/6007885.html

http://blog.csdn.net/zhuming3834/article/details/72778147

https://www.cnblogs.com/fisheleven/p/6775380.html?utm_source=itdadao&utm_medium=referral

**Vue开发说明文件请参考下面的Word文件**

