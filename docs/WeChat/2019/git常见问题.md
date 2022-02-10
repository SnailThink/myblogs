## 前言

最近在使用git还是遇到了不少的问题，自己整理了遇到的问题。​

里面有部分资料来源于网络，具体的链接忘了，如侵必删！

###  1.“Please make sure you have the correct access rights and the repository exists.”
```
出现这样的问题是 ssh key  有问题了

1、首先我得重新在git设置一下身份的名字和邮箱

git config --global user.name "yourname"

git config --global user.email“your@email.com"

注：yourname是你要设置的名字，your@email是你要设置的邮箱。

2、删除.ssh文件夹（直接搜索该文件夹）下的known_hosts(手动删除即可，不需要git）

3、git输入命令

$ ssh-keygen -t rsa -C "your@email.com"（请填你设置的邮箱地址）

4.找到ssh位置   C:\Users\用户名\.ssh
一般位置如上所示，找到id_rsa.pub文件用记事本打开复制到github ssh key中

```


### 2.git提交代码到github冲突解决

```shell
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

解决方法

1.强制推送(**会覆盖冲突以这次为准，不建议** )

```sehll
$ git push -f 
```

2.正常解决

```shell
git fetch origin 

git merge origin/master
```

### 3. Failed to connect to 127.0.0.1 port 1080: Connection refused拒绝连接错误

```
#取消代理1
$ git config --global --unset http.proxy
$ git config --global --unset https.proxy

# 方式2
$ unset http_proxy
$ unset ftp_proxy
$ unset all_proxy
$ unset https_proxy
$ unset no_proxy

```

![git.png](https://imgconvert.csdnimg.cn/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC8zLzI1LzE3MTEyMDE4NTI0ZGMwMWI?x-oss-process=image/format,png)



### 4.git回退

**方法1**： git reset –hard HEAD ^   ( ^ 表示回到上一个版本，如果需要回退到上上个版本的话，将HEAD^改成

HEAD^^, 以此类推。那如果要回退到前100个版本，这种方法肯定不方便，我们可以使用简便命令操作：

git reset –hard HEAD~100 );



>在window中执行的时候需要加上  git reset –hard HEAD ''^''
>
> eg： git reset –hard HEAD ^ 



 **方法2** ：git reset –hard 版本号 ，但是现在的问题是加入我已经关掉了命令行或者第三个版本的版本号，我并不知道？那么要如何知道第三个版本的版本号呐。可以通过如下命令获取到版本号： git reflog  找到commit的ID

**小技巧 使用gitk 有惊喜呦**


> eg:  git reset –hard 40f1d78



### 5.git Push需要输入密码

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
> git remote rm origin 



> 3.添加新的ssh方式的origin： 
>
> git remote add origin git@github.com:VincentBlog/JavaBlog.git 



> 4.改动完之后直接执行git push是无法推送代码的，需要设置一下上游要跟踪的分支，与此同时会自动执行一次git push命令，此时已经不用要求输入用户名及密码啦！ 
>
> git push --set-upstream origin master 

![git.png](https://imgconvert.csdnimg.cn/aHR0cDovL3d3MS5zaW5haW1nLmNuL2xhcmdlLzAwNmFNa3RQbHkxZ2NiMHYwYzVuZ2ozMGY3MGFmbXhyLmpwZw?x-oss-process=image/format,png)



------

### 6.合并git代码 Pull is not possible because you have unmerged files....

```
解决方法：
1.pull代码的时候会进行git merge操作导致冲突，需要将冲突的文件先resolve掉，再进行git add -u, git commit之后才能成功git pull。
2.如果想放弃本地的文件修改，可以使用git reset --hard FETCH_HEAD，FETCH_HEAD表示上一次成功时git pull之后形成的commit点。后面就可以成功git pull.
ps：git merge会形成MERGE-HEAD(FETCH-HEAD) 。git push会形成HEAD这样的引用。HEAD代表本地最近成功push后形成的引用。
```

### 7.git项目不显示绿色图标或者红色图标解决办法

1.win+r,regedit.exe,打开注册表 按照文件的层次关系依次找到 

 HKEY_LOCAL_MACHINE–>SOFTWARE–>Microsoft–>Windows–>CurrentVersion–>Explorer–>ShellIconOverlayIdentifiers”这一项 

或者编辑-->查找-->输入ShellIconOverlayIdentifiers

 将Tortoise相关的项都提到靠前的位置（重命名，在名称之前加几个空格） 

Windows会使用掉4项默认排序，另外还有11项是供应用程序配置的，如果排在11项之后，可能导致应用程序的配置无效 

排到靠前位置后 ，重启资源管理器即可（任务管理器-->资源管理器（重新启动））

![tort.png](https://imgconvert.csdnimg.cn/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC8zLzExLzE3MGM5MzkwYWUxMjM2MjU?x-oss-process=image/format,png)

-------



### 8. **fatal:Unable to create index.lock File exists 错误。** 

 暂存代码时非法中止了操作，结果再次提交的时候一直报错。 

解决办法：在项目根目录下找到.git文件夹，删掉里面的index.lock文件即可。

**官方对index.lock文件的解释**：
在进行某些比较费时的git操作时自动生成，操作结束后自动删除，相当于一个锁定文件，目的在于防止对一个目录同时进行多个操作。有时强制关闭进行中的git操作，这个文件没有被自动删除，之后你就无法进行其他操作，必须手动删除。

### 9.从git中删除文件而不从文件系统中删除它**

如果你在`git add` 时操作不慎，最终可能会添加你不想提交的文件。 但是，`git rm`会将它从暂存区域以及文件系统中删除，这可能不是你想要的。在这种情况下，确保只删除暂存版本，并将文件添加到`.gitingore`以避免再次出现同样的错误：

```text
git reset filename          # or git remove --cached filename
echo filename >> .gitignore # add it to .gitingore to avoid re-adding it
```



### 10. 解决git clone 子模块没下载全的问题 

```
git submodule update --init --recursive
```


### 11.代码可以pull却不能push Access denied. fatal: The remote end hung up unexpectedly

 1.使用了git clone http://xxx的形式，这是以只读的方式来获取代码的。需要重新拉取代码。git clone git@xxx。这就是为什么git提供了http和ssh两种类型的链接的原因。
2.公钥加错地方了，项目公钥是只读属性，你要把它删除，加到个人公钥里面 



### 12.其他分支可以合并，当合并master代码时候遇到 You are not allowed to push code to protected branches on this project

 解决方法：遇到这种情况多是master分支被设置为保护分支了，需要有管理员身份的账号可以合并，如果想非管理账号也想合并，需要将master去除保护分支的设置 



### 13.Authentication failed for 修改密码后遇到的坑

最近修改过git密码，修改完后发现git无法获取代码

操作步骤:控制面板=》凭据管理器=》Windows凭据 =》普通凭据=》删除/更新密码

![032601.png](https://imgconvert.csdnimg.cn/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC8zLzI2LzE3MTE3MDEwZGNhZjQzODY?x-oss-process=image/format,png)

### 14.Failed to connect to 127.0.0.1 port 1080: Connection refused拒绝连接错误


![git.png](https://user-gold-cdn.xitu.io/2020/3/25/17112018524dc01b?w=943&h=613&f=png&s=79757)


### 15.分支的合并
**一、开发分支（dev）上的代码达到上线的标准后，要合并到 master 分支**

```linux
git checkout dev
git pull
git checkout master
git merge dev
git push -u origin master
```



**一、当master代码改动了，需要更新开发分支（dev）上的代码**

```linux
git checkout master 
git pull 
git checkout dev
git merge master 
git push -u origin dev
```

参考文章:

- [参考文章:https://blog.csdn.net/weixin_41010198/article/details/87929622](https://blog.csdn.net/weixin_41010198/article/details/87929622)


- [Git遇到的坑:https://www.cnblogs.com/EchoHG/p/7291184.html](https://www.cnblogs.com/EchoHG/p/7291184.html)


- [使用Git过程中经常会遇到的问题:https://www.cnblogs.com/youyoui/p/10406712.html](https://www.cnblogs.com/youyoui/p/10406712.html)