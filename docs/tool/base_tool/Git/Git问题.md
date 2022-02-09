### 问题1:git Push需要输入密码

github上的工程clone到本地后，修改完代码后想要push到github，但一直会有提示输入用户名及密码 



**原因分析** 

出现这种情况的原因是我们使用了http的方式clone代码到本地

也是使用http的方式将代码push到服务器。 



**解决办法**

 将http方式改为**ssh方式**即可。 

> 1.查看当前方式
>
> git remote -v 



> 2.把http方式改为ssh方式。先移除旧的http的origin 
>
>  git remote rm origin 



> 3.添加新的ssh方式的origin： 
>
> git remote add origin git@github.com:VincentBlog/JavaBlog.git 



> 4.改动完之后直接执行git push是无法推送代码的，需要设置一下上游要跟踪的分支，与此同时会自动执行一次git push命令，此时已经不用要求输入用户名及密码啦！ 
>
>   git push --set-upstream origin master 

![git.png](http://ww1.sinaimg.cn/large/006aMktPly1gcb0v0c5ngj30f70afmxr.jpg)





------

### 问题2:git项目不显示绿色图标或者红色图标解决办法


 1.win+r,regedit.exe,打开注册表 按照文件的层次关系依次找到 

 HKEY_LOCAL_MACHINE–>SOFTWARE–>Microsoft–>Windows–>CurrentVersion–>Explorer–>ShellIconOverlayIdentifiers”这一项 

或者编辑-->查找-->输入ShellIconOverlayIdentifiers

 将Tortoise相关的项都提到靠前的位置（重命名，在名称之前加几个空格） 

（Windows会使用掉4项默认排序，另外还有11项是供应用程序配置的，如果排在11项之后，可能导致应用程序的配置无效）。 

排到靠前位置后

重启资源管理器即可（任务管理器-->资源管理器（重新启动））

![tort.png](https://user-gold-cdn.xitu.io/2020/3/11/170c9390ae123625?w=712&h=713&f=png&s=14124)

------

### 问题3: git提交代码到github冲突解决

```
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

解决方法

**解决方案一.正常解决推荐**

```shell

git fetch origin  //更新远程仓库文件

git diff master origin/master  //本地文件和远程仓库文件进行对比

git merge origin/master  //自动合并

```

解决方案二:强制推送( **会覆盖冲突以这次为准，不建议 ** )

```sehll
$ git push -f 
```



解决方案三:（强制覆盖本地代码，你自己修改的代码即将被远程库的代码所覆盖）

把你修改的代码进行备份，然后执行命令：

```
git reset --hard origin/master
git pull
```



小命令：最后，补充一个我之前在工作当中经常使用的查看Git提交日志的命令，除了git log之外还有一个很好用“gitk”在小黑窗中执行一下，会有神奇的事情发生...



### 问题4:切换分支异常

```
$ git checkout master
error: Your local changes to the following files would be overwritten by checkou                                                                                                                t:
        src/Vicnent/Java/git/git问题解决.md
Please commit your changes or stash them before you switch branches.
Aborting
```




### 问题5:git遇到的问题之“Please make sure you have the correct access rights and the repository exists.”



#### 问题 

 Please make sure you have the correct access rights and the repository exists. this

出现这样的问题是 ssh key  有问题了

1、首先我得重新在git设置一下身份的名字和邮箱（因为当初都忘了设置啥了，因为遇到坑了）进入到需要提交的文件夹底下（因为直接打开git Bash，在没有路径的情况下，根本没！法！改！刚使用git时遇到的坑。。。）

```shell
git config --global user.name "yourname"

git config --global user.email“your@email.com"
#注：yourname是你要设置的名字，your@email是你要设置的邮箱。
```



2、删除.ssh文件夹（直接搜索该文件夹）下的known_hosts(手动删除即可，不需要git）



3、git输入命令

```shell
$ ssh-keygen -t rsa -C "your@email.com"（请填你设置的邮箱地址）
```



接着出现：

Generating public/private rsa key pair.

Enter file in which to save the key (/Users/your_user_directory/.ssh/id_rsa):



请直接按下回车



然后系统会自动在.ssh文件夹下生成两个文件，id_rsa和id_rsa.pub，用记事本打开id_rsa.pub



将全部的内容复制



4、打开https://github.com/，登陆你的账户，进入设置

![21.png](https://user-gold-cdn.xitu.io/2020/3/25/1710f6add8deacfc?w=1692&h=792&f=png&s=40702)



5、在git中输入命令：

ssh -T git@github.com

然后会跳出一堆话。。

输入命令：yes

回车


### 问题5:git回退


**方法1**： git reset –hard HEAD ^   ( ^ 表示回到上一个版本，如果需要回退到上上个版本的话，将HEAD^改成

HEAD^^, 以此类推。那如果要回退到前100个版本，这种方法肯定不方便，我们可以使用简便命令操作：

git reset –hard HEAD~100 );



> #在window中执行的时候需要加上  git reset –hard HEAD ''^ ''
>
> eg： git reset –hard HEAD ^ 



 **方法2** ：git reset –hard 版本号 ，但是现在的问题是加入我已经关掉了命令行或者第三个版本的版本号，我并不知道？那么要如何知道第三个版本的版本号呐。可以通过如下命令获取到版本号： git reflog  找到commit的ID

**小技巧 使用gitk 有惊喜呦**

![UTOOLS1585099894053.png](https://user-gold-cdn.xitu.io/2020/3/25/1710f50e4ad50f67?w=566&h=373&f=png&s=31528)

> eg:  git reset –hard 40f1d78


### 问题6:git从远程仓库更新代码

 首先，查看远程仓库方法：

```shell
$ git remote -v
origin [git@github.com](mailto:git@github.com):tupelo-shen/ATC.git (fetch)
origin [git@github.com](mailto:git@github.com):tupelo-shen/ATC.git (push) 
```

其次，这儿介绍远程仓库更新代码到本地仓库的两种方法：

一 方式1
远程仓库为origin master，本地仓库分支为master，那么：
（1）从远程获取最新版本到本地

```shell
$ git fetch origin master
```



这句的意思是：从远程的origin仓库的master分支下载代码到本地的origin master
（2）比较本地的仓库和远程参考的区别

```shell
$ git log -p master… origin/master
```



因为我的本地仓库和远程仓库代码相同所以没有其他任何信息

（3）把远程下载下来的代码合并到本地仓库，远程的和本地的合并

```shell
$ git merge origin/master
```

二 方式2
远程仓库为origin master，本地仓库分支为atc_develop001，那么：
（1）从远程获取最新版本到本地

```shell
$ git fetch origin master:temp
Enter passphrase for key ‘/c/Users/30032183/.ssh/id_rsa’:
From github.com:tupelo-shen/ATC
```



[new branch] master -> temp
上面第一句，把远程分支更新到临时分支temp的命令；第二句提示输入密码，输入后enter就可以了。
（2）比较本地的仓库和远程参考的区别

```shell
$ git diff temp diff --git
```

…(此处应为不同信息的提示）

（3）合并temp分支到atc_develop001分支

```shell
$ git merge temp
```

合并提示信息

合并的时候可能会出现冲突，有时间了再把如何处理冲突写一篇博客补充上。
（4）如果不想要temp分支了，可以删除此分支

```shell
$ git branch -d temp
```

总结：方式二更好理解，更安全，对于pull也可以更新代码到本地，相当于fetch+merge，多人写作的话不够安全

### 问题7 git for windows下的Filename too long

git有可以创建4096长度的文件名，然而在windows最多是260，因为git用了旧版本的windows api，为此踩了个坑。

```shell
git config --global core.longpaths true
```

