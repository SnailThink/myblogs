## IDEA技巧

## 前言

> 工欲善其事
>
> 必先利其器
>
> 原文地址: https://www.jianshu.com/p/228c20d37db5 

最近受部门的邀请，给入职新人统一培训IDEA，发现有很多新人虽然日常开发使用的是IDEA，但是还是很多好用的技巧没有用到，只是用到一些基本的功能，蛮浪费IDEA这个优秀的IDE。 同时，在这次分享之后，本人自己也学习到了一些新的使用技巧，所以借着这次机会，一起分享出来。希望可以帮到一些人。

> 基于的 IDEA 版本信息：IntelliJ IDEA 2018.2.2 (Ultimate Edition)

------

## 高效率配置

### 1. 代码提示不区分大小写

```
Settings -> Editor -> General -> Code Completion
```

![img](https:////upload-images.jianshu.io/upload_images/8514567-f5b5f30c22d0bdce.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


(低版本 将 Case sensitive completion 设置为 None 就可以了)

### 2. 自动导包功能及相关优化功能

```
Settings -> Editor -> General -> Auto Import
```

![img](https:////upload-images.jianshu.io/upload_images/8514567-67408eaa51091de3.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


### 3. CTRL + 滑动滚轮 调整窗口显示大小

```
Settings -> Editor -> General -> Change font size (Zoom) with Ctrl+Mouse wheel
```

![img](https:////upload-images.jianshu.io/upload_images/8514567-727680eff3b7f7af.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


选择之后，就可以通过CTRL+滑动滚轮的方式，调整编辑器窗口的字体大小

### 4. tab 多行显示

这点因人而异，有些人喜欢直接取消所有tab，改用快捷键的方式，我屏幕比较大，所以喜欢把tab全部显示出来。

`Window -> Editor Tabs -> Tabs Placement`，取消勾选 `Show Tabs In Single Row`选项。

![img](https:////upload-images.jianshu.io/upload_images/8514567-5634b86ce319a153.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1010/format/webp)


效果如下：

![img](https:////upload-images.jianshu.io/upload_images/8514567-4ec32b9a13182944.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


### 5. 代码编辑区显示行号

```
Settings -> Editor -> General -> Appearance` 勾选 `Show Line Numbers
```

![img](https:////upload-images.jianshu.io/upload_images/8514567-2efc8422c5127358.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


![img](https:////upload-images.jianshu.io/upload_images/8514567-216c1b5ba12289e3.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/898/format/webp)



### 查看maven 关系图

![](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530182355.png)

![](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530182356.png)

### 配置Maven路径

![](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530182318.png)

![](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530182254.png)



### 设置项目编码

![](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530182231.png)


### 设置自动编译

![](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530182212.png)



## 6. 日常使用 必备快捷键（★★）

### 查找

| 快捷键                 | 介绍                         |
| ---------------------- | ---------------------------- |
| Ctrl + F               | 在当前文件进行文本查找       |
| Ctrl + R               | 在当前文件进行文本替换       |
| Shift + Ctrl + F       | 在项目进行文本查找           |
| Shift + Ctrl + R       | 在项目进行文本替换           |
| Shift  + Shift         | 快速搜索                     |
| Ctrl + N               | 查找class                    |
| Ctrl + Shift + N       | 查找文件                     |
| Ctrl + Shift + Alt + N | 查找symbol（查找某个方法名） |

### 跳转切换

| 快捷键            | 介绍                  |
| ----------------- | --------------------- |
| Ctrl + E          | 最近文件              |
| Ctrl + Tab        | 切换文件              |
| Ctrl  + Alt + ←/→ | 跳转历史光标所在处    |
| Alt + ←/→ 方向键  | 切换子tab             |
| Ctrl + G          | go to（跳转指定行号） |

### 编码相关

| 快捷键                      | 介绍                                                         |
| --------------------------- | ------------------------------------------------------------ |
| Ctrl + W                    | 快速选中                                                     |
| (Shift + Ctrl) + Alt + J    | 快速选中同文本                                               |
| Ctrl + C/Ctrl + X/Ctrl + D  | 快速复制或剪切                                               |
| 多行选中 Tab / Shift  + Tab | tab                                                          |
| Ctrl + Y                    | 删除整行                                                     |
| 滚轮点击变量/方法/类        | 快速进入变量/方法/类的定义处                                 |
| Shift + 点击Tab             | 快速关闭tab                                                  |
| Ctrl + Z 、Ctrl + Shift + Z | 后悔药，撤销/取消撤销                                        |
| Ctrl + Shift + enter        | 自动收尾，代码自动补全                                       |
| Alt + enter                 | IntelliJ IDEA 根据光标所在问题，提供快速修复选择，光标放在的位置不同提示的结果也不同 |
| Alt + ↑/↓                   | 方法快速跳转                                                 |
| F2                          | 跳转到下一个高亮错误 或 警告位置                             |
| Alt + Insert                | 代码自动生成，如生成对象的 set / get 方法，构造函数，toString() 等 |
| Ctrl + Shift + L            | 格式化代码                                                   |
| Shift + F6                  | 快速修改方法名、变量名、文件名、类名等                       |
| Ctrl + F6                   | 快速修改方法签名                                             |

### 代码阅读相关

| 快捷键                     | 介绍                               |
| -------------------------- | ---------------------------------- |
| Ctrl + P                   | 方法参数提示显示                   |
| Ctrl + Shift + i           | 就可以在当前类里再弹出一个窗口出来 |
| Alt + F7                   | 可以列出变量在哪些地方被使用了     |
| 光标在子类接口名，Ctrl + u | 跳到父类接口                       |
| Alt + F1 + 1， esc         |                                    |
| (Shift) + Ctrl + +/-       | 代码块折叠                         |
| Ctrl + Shift + ←/→         | 移动窗口分割线                     |
| Ctrl  + (Alt) + B          | 跳转方法定义/实现                  |
| Ctrl  + H                  | 类的层级关系                       |
| Ctrl  + F12                | Show Members 类成员快速显示        |

### 版本管理相关

| 快捷键       | 介绍             |
| ------------ | ---------------- |
| Ctrl + D     | Show Diff        |
| (Shift) + F7 | （上）下一处修改 |

> 更多快捷键请参考此文章 [https://github.com/judasn/IntelliJ-IDEA-Tutorial/blob/master/keymap-introduce.md](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fjudasn%2FIntelliJ-IDEA-Tutorial%2Fblob%2Fmaster%2Fkeymap-introduce.md)
>
> **mac os** 快捷键请参考本文章 [https://github.com/judasn/IntelliJ-IDEA-Tutorial/blob/master/keymap-win-mac.md](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fjudasn%2FIntelliJ-IDEA-Tutorial%2Fblob%2Fmaster%2Fkeymap-win-mac.md)

## 编码效率相关（★★）

### 文件代码模板

```
Settings -> Editor -> File and Code Template
```

![img](https:////upload-images.jianshu.io/upload_images/8514567-3965b6ece339771a.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


在这里可以看到IDEA所有内置的文件代码模板，当你选择某个文件生成时，就会按照这里面的模板生成指定的代码文件。

另外，你可以在这里设置文件头。

![img](https:////upload-images.jianshu.io/upload_images/8514567-7a9d1f465946c68a.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


设置之后，效果如下

![img](https:////upload-images.jianshu.io/upload_images/8514567-1e0a8c57d30dd4e2.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/513/format/webp)


### 实时代码模板

IDEA提供了强大的实时代码模板功能，并且原生内置了很多的模板，比如，当你输入`sout`或者`psvm`，就会快速自动生成`System.out.println();`和`public static void main(String[] args) {}`的代码块。

![img](https:////upload-images.jianshu.io/upload_images/8514567-d08103a3d1ce64f9.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/836/format/webp)


![img](https:////upload-images.jianshu.io/upload_images/8514567-4bc1406a5d7b1cad.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/950/format/webp)


这些的模板可以在`Settings -> Editor -> Live Templates`看到。使用者可以按照自己的使用习惯来熟悉相关的代码模板。

![img](https:////upload-images.jianshu.io/upload_images/8514567-dbf1cea0f6e1317c.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


#### 定制代码模板

IDEA也提供自己定制实时代码模板的功能。

1. 创建自己的模板库
2. 创建定制的代码模板

![img](https:////upload-images.jianshu.io/upload_images/8514567-142593ccc1f5c30c.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


图中的`MyGroup`就存放着我自己定义的代码模板。

### 其他

#### CRTL+ALT+T

![img](https:////upload-images.jianshu.io/upload_images/8514567-fefb3123492b8231.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/755/format/webp)


`Ctrl + Alt + T` 提供的是代码块包裹功能 - Surround With。可以快速将选中的代码块，包裹到选择的语句块中。

#### 本地历史版本

IDEA 自带本地版本管理的功能，能够让你本地编写代码变得更加的安心和方便。

![img](https:////upload-images.jianshu.io/upload_images/8514567-ded75fe855e5c3e9.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


## 代码调试 源码阅读相关（★★★）

### 视图模式

![img](https:////upload-images.jianshu.io/upload_images/8514567-fad93c27dfd1d78c.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/465/format/webp)


IDEA提供两种特殊的视图模式，

1. Presentation Mode - 演示模式，专门用于Code Review这种需要展示代码的场景
2. Distraction Free Mode - 禅模式，专注于代码开发

### 代码调试

#### 1. 条件断点

IDEA 可以设置指定条件的断点，增加我们调试的效率。

![img](https:////upload-images.jianshu.io/upload_images/8514567-aae136a085a821a8.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


#### 2. 强制返回

IDEA 可以在打断点的方法栈处，强制返回你想要的方法返回值给调用方。非常灵活！

![img](https:////upload-images.jianshu.io/upload_images/8514567-3e54dc1f200eece1.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


![img](https:////upload-images.jianshu.io/upload_images/8514567-b59753da0e2843fa.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/393/format/webp)


#### 3. 模拟异常

IDEA 可以在打断点的方法栈处，强制抛出异常给调用方。这个在调试源码的时候非常有用。

![img](https:////upload-images.jianshu.io/upload_images/8514567-e4bcddbe72ca2420.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/394/format/webp)


#### 4. Evaluate Expression

IDEA 还可以在调试代码的时候，动态修改当前方法栈中变量的值，方便我们的调试。

![img](https:////upload-images.jianshu.io/upload_images/8514567-71e8c0b10b76f9b1.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)



## 参考


1. [https://github.com/judasn/IntelliJ-IDEA-Tutorial](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fjudasn%2FIntelliJ-IDEA-Tutorial)

2. [扩展](https://blog.csdn.net/chenchunlin526/article/details/85340368)

(By the way, 更多IDEA使用请参考此延伸文档以及官方文档)