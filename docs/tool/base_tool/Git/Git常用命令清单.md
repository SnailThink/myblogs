## 一. 专用名词的译名

```
Workspace：工作区
	Index / Stage：暂存区
	Repository：仓库区（或本地仓库）
	Remote：远程仓库

```

## 二. 常用命令

### 1.新建代码库

```javascript
$ git init   	//在当前目录新建一个Git代码库
$ git init [project-name]   //新建一个目录，将其初始化为Git代码库
$ git clone [url]   //下载一个项目和它的整个代码历史
```

### 2.配置信息

```git
# 显示当前的Git配置
$ git config --list

# 编辑Git配置文件
$ git config -e [--global]

# 设置提交代码时的用户信息
$ git config [--global] user.name "[name]"
$ git config [--global] user.email "[email address]"

# 生成密钥
$ cd ~/. ssh   //检查本机的ssh密钥
Ssh-keygen –t rsa –C “12345678@qq.com” //输入你的邮箱地址
登录github, Account Settings -->SSH Public keys --> add another public keys, 添加刚生成的公钥;
$ ssh –T git@github.com //连接

```

### 3.增加/删除文件(夹)

```
# 添加指定文件到暂存区
$ git add [file1] [file2] ...

# 添加指定目录到暂存区，包括子目录
$ git add [dir]

# 添加当前目录的所有文件到暂存区
$ git add .

# 添加每个变化前，都会要求确认
# 对于同一个文件的多处变化，可以实现分次提交
$ git add -p

# 删除工作区文件，并且将这次删除放入暂存区
$ git rm [file1] [file2] ...

# 删除工作区文件夹，并且将这次删除放入暂存区
$ git rm src/ -r   // -r 会把bbb/目录下的所有内容一次性移动

# 停止追踪指定文件，但该文件会保留在工作区
$ git rm --cached [file]

# 改名文件，并且将这个改名放入暂存区
$ git mv [file-original] [file-renamed]

```

### 4.代码提交

```
# 提交暂存区到仓库区
$ git commit -m [message]

# 提交暂存区的指定文件到仓库区
$ git commit [file1] [file2] ... -m [message]

# 提交工作区自上次commit之后的变化，直接到仓库区
$ git commit -a

# 提交时显示所有diff信息
$ git commit -v

# 使用一次新的commit，替代上一次提交
# 如果代码没有任何新变化，则用来改写上一次commit的提交信息
$ git commit --amend -m [message]

# 重做上一次commit，并包括指定文件的新变化
$ git commit --amend [file1] [file2] ...
```

### 5.分支管理

```
# 列出所有本地分支
$ git branch

# 列出所有远程分支
$ git branch -r

# 列出所有本地分支和远程分支
$ git branch -a

# 新建一个分支，但依然停留在当前分支
$ git branch [branch-name]

# 新建一个分支，并切换到该分支
$ git checkout -b [branch]

# 新建一个分支，指向指定commit
$ git branch [branch] [commit]

# 新建一个分支，与指定的远程分支建立追踪关系
$ git branch --track [branch] [remote-branch]

# 切换到指定分支，并更新工作区
$ git checkout [branch-name]

# 切换到上一个分支
$ git checkout -

# 建立追踪关系，在现有分支与指定的远程分支之间
$ git branch --set-upstream [branch] [remote-branch]

# 合并指定分支到当前分支
$ git merge [branch]

# 选择一个commit，合并进当前分支
$ git cherry-pick [commit]

# 删除分支
$ git branch -d [branch-name]

# 重命令本地分支
$ git branch -m [old-branch-name] [new-branch-name] 

#重命名远程分支
$ git branch -m [old-branch-name] [new-branch-name] 
$ git push origin :[old-branch-name] （删除远程分支）
$ git push origin [new-branch-name]:[new-branch-name] （push 到远程分支）
$ git branch --set-upstream  [new-branch-name]  origin/[new-branch-name] (绑定远程分支）

# 删除远程分支
$ git push origin --delete [branch-name] //需要有删除权限
$ git branch -dr [remote/branch]

```

### 6.标签管理

```
# 列出所有tag
$ git tag

# 新建一个tag在当前commit
$ git tag [tag]

# 新建一个tag在指定commit
$ git tag [tag] [commit]

# 删除本地tag
$ git tag -d [tag]

# 删除远程tag
$ git push origin :refs/tags/[tagName]

# 查看tag信息
$ git show [tag]

# 提交指定tag
$ git push [remote] [tag]

# 提交所有tag
$ git push [remote] --tags

# 新建一个分支，指向某个tag
$ git checkout -b [branch] [tag]

```

### 7.查看信息

```
# 显示有变更的文件
$ git status

# 显示当前分支的版本历史
$ git log

# 显示commit历史，以及每次commit发生变更的文件
$ git log --stat

# 搜索提交历史，根据关键词
$ git log -S [keyword]

# 显示某个commit之后的所有变动，每个commit占据一行
$ git log [tag] HEAD --pretty=format:%s

# 显示某个commit之后的所有变动，其"提交说明"必须符合搜索条件
$ git log [tag] HEAD --grep feature

# 显示某个文件的版本历史，包括文件改名
$ git log --follow [file]
$ git whatchanged [file]

# 显示指定文件相关的每一次diff
$ git log -p [file]

# 显示过去5次提交
$ git log -5 --pretty=oneline

# 显示当前分支的历史版本
$ git log --pretty=oneline  //如果嫌上面的输出信息过多可以使用这条（只输出版本号）

# 显示所有提交过的用户，按提交次数排序
$ git shortlog -sn

# 显示指定文件是什么人在什么时间修改过
$ git blame [file]

# 显示暂存区和工作区的差异
$ git diff

# 显示暂存区和上一个commit的差异
$ git diff --cached [file]

# 显示工作区与当前分支最新commit之间的差异
$ git diff HEAD

# 显示两次提交之间的差异
$ git diff [first-branch]...[second-branch]

# 显示今天你写了多少行代码
$ git diff --shortstat "@{0 day ago}"

# 显示某次提交的元数据和内容变化
$ git show [commit]

# 显示某次提交发生变化的文件
$ git show --name-only [commit]

# 显示某次提交时，某个文件的内容
$ git show [commit]:[filename]

# 显示当前分支的最近几次提交
$ git reflog //用git log 看不出来被删除的commitid，用git reflog则可以看到被删除的commitid ,并且可以看到所有分支的commit

```

### 8.远程同步

```
# 下载远程仓库的所有变动
$ git fetch [remote]

# 显示所有远程仓库
$ git remote -v

# 显示某个远程仓库的信息
$ git remote show [remote]

# 增加一个新的远程仓库，并命名
$ git remote add [shortname] [url]

# 取回远程仓库的变化，并与本地分支合并
$ git pull [remote] [branch]

# 上传本地指定分支到远程仓库
$ git push [remote] [branch]

# 强行推送当前分支到远程仓库，即使有冲突
$ git push [remote] --force

# 推送所有分支到远程仓库
$ git push [remote] --all

```

### 9.撤销

```
# 恢复暂存区的指定文件到工作区
$ git checkout [file]

# 恢复某个commit的指定文件到暂存区和工作区
$ git checkout [commit] [file]

# 恢复暂存区的所有文件到工作区
$ git checkout .

# 重置暂存区的指定文件，与上一次commit保持一致，但工作区不变
$ git reset [file]

# 重置暂存区与工作区，与上一次commit保持一致
$ git reset --hard

# 重置当前分支的指针为指定commit，同时重置暂存区，但工作区不变
$ git reset [commit]

# 重置当前分支的HEAD为指定commit，同时重置暂存区和工作区，与指定commit一致
$ git reset --hard [commit]

# 重置当前HEAD为指定commit，但保持暂存区和工作区不变
$ git reset --keep [commit]

# 新建一个commit，用来撤销指定commit
# 后者的所有变化都将被前者抵消，并且应用到当前分支
$ git revert [commit]

# 暂时将未提交的变化移除，稍后再移入
$ git stash
$ git stash pop

```

### 10.其他

```
# 生成一个可供发布的压缩包
$ git archive
```

## 三.应用场景

#### 场景一: 新建项目,如何提交到github/码云?

```
$ git status //查看工作区状态, 有多余文件可删除.
$ git add .  
$ git commit –m”new natter ”
$ git remote add origin git@github.com:defnngj/hibernate-demo.git   //当前项目与远程仓库建立连接, 已连接可忽略.
$ git remote -v  //查看你当前项目远程连接的是哪个仓库地址, 已连接可忽略.
$ git push -u origin master  //将本地的项目提交到远程仓库中。
```

#### 场景二: 创建新分支如何关联远程分支?

```
# 方法1:
$ git checkout -b a origin/a  //使用该方式会在本地新建分支a，并自动切换到该本地分支a。并且采用此种方法建立的本地分支会和远程分支建立映射关系。

# 方法2:
$ git fetch origin a:a 	//使用该方式会在本地新建分支a，但是不会自动切换到该本地分支a，需要手动checkout。采用此种方法建立的本地分支不会和远程分支建立映射关系。

```

**本地分支和远程分支建立映射关系**

```
$ git branch -vv   // 查看本地分支和远程分支的映射关系（跟踪关系track），前面带*号的表示当前分支
$ git branch -u origin/分支名   // 手动建立本地分支和远程分支都有映射关系
$ git branch --set-upstream-to origin/分支名      // 手动建立当前分支与远程分支的映射关系
$ git branch --unset-upstream   // 撤销本地分支与远程分支的映射关系
```

#### 场景三: 公共远程分支版本回退如何做才不会覆盖别人代码?

假设当前的远程分支为 :

>A1–A2–B1
>其中A、B分别代表两个人，A1、A2、B1代表各自的提交。并且所有人的本地分支都已经更新到最新版本，和远程分支一致

这时你发现A2这次提交有错误, 你使用命令回退到A1,并且远程分支master也回退到A1.

```
$ git reset --hard ^^;
$ git push -f origin [ branch-name ];

```

那么理想状态是你的队友一拉代码git pull，他们的master分支也回滚了，然而现实却是，你的队友会看到下面的提示：

```
$ git status
On branch master
Your branch is ahead of ‘origin/master’ by 2 commits.
(use “git push” to publish your local commits)
nothing to commit, working directory clean
```

也就是说，你的队友的分支并没有主动回退，而是比远程分支超前了两次提交，因为远程分支回退了嘛。
这个时候只要有人git push, 那么远程分支就又回到起点了, 一切白费.

所以我们可以换种方式回退:

```
git revert HEAD //撤销最近一次提交
git revert HEAD~1 //撤销上上次的提交，注意：数字从0开始
git revert 0ffaacc //撤销0ffaacc这次提交
```

git revert 命令意思是撤销某次提交。它会产生一个新的提交，虽然代码回退了，但是版本依然是向前的，所以，当你用revert回退之后，所有人pull之后，他们的代码也自动的回退了.

git revert 命令的好处就是不会丢掉别人的提交，即使你撤销后覆盖了别人的提交，他更新代码后，可以在本地用 reset 向前回滚，找到自己的代码，然后拉一下分支，再回来合并上去就可以找回被你覆盖的提交了。

如果在revert过程中出现了冲突, 而你又不想解决冲突, 那你可以终止操作:


```
git revert --abort
```

#### 场景四: commit之后,还没push, 想修改这次提交该怎么办?

```
git commit --amend -m "your new message"
```

#### 场景五: 提交错了分支该如何处理?

当你在提交的时候,忽然发现你切错分支,提交到了错误的分支上, 这个时候该怎么处理呢?

**方法1: reset**

```
# 取消最新的提交，然后保留现场原状
git reset HEAD~ --soft
git stash

# 切换到正确的分支
git checkout name-of-the-correct-branch
git stash pop
git add .    # 或添加特定文件
git commit -m "你的提交说明"

```

**方法2: cherry-pick(摘樱桃)**

```
git checkout name-of-the-correct-branch
# 把主分支上的最新提交摘过来
git cherry-pick master

# 再删掉主分支上的最新提交
git checkout master
git reset HEAD~ --hard
```

#### 场景六: 你发现历史提交中某一次commit信息有误,该怎么处理?

1.查看修改

```
git rebase -i master~1 #最后一次
git rebase -i master~5 #最后五次
git rebase -i HEAD~3   #当前版本的倒数第三次状态
git rebase -i 32e0a87f #指定的SHA位置
```

2.进入到编辑界面, 修改信息,并:wq退出

```
pick 92b495b 2019-10-18: ×××××××

# Rebase 9ef2b1f..92b495b onto 9ef2b1f
#
# Commands:
#  pick = use commit
#  edit = use commit, but stop for amending //改上面的 pick 为 edit
#  squash = use commit, but meld into previous commit
#
# If you remove a line here THAT COMMIT WILL BE LOST.
# However, if you remove everything, the rebase will be aborted.
#
```

3.命令行显示：

```
Stopped at e35b8f3… reflog branch first commit
You can amend the commit now, with

git commit –amend

Once you are satisfied with your changes, run

git rebase –continue
```

4.使用git rebase –continue完成操作

```
git rebase –continue
```

5.推送到远端

```
git push <remote> <branch> -f 
```

#### 场景七: 如果在写一个新功能的时候,突然接到一个紧急bug,必须马上解决, 但是这个bug不能在当前分支上解决, 其次新功能还没写完, 并不想现在提交, 该怎么办?

```
git stash //暂存当前工作区,
git checkout -b hotfix //新建bug分支并切换到该分支
# 修改完成切回分支
git stash pop // 重新应用缓存的stash
```

扩展: git stash相关命令

```
git stash //会把所有未提交的修改（包括暂存的和非暂存的）都保存起来，用于后续恢复当前工作目录。
git stash pop // 重新应用缓存的stash
git stash list //查看现有stash
git stash drop //移除stash
git stash show //查看指定stash的diff
git stash branch //从stash创建分支
```

#### 场景八: 如何合并多次commit提交记录?

在我们开发新功能的时候, 在feature分支会有很多提交记录, 再合并到主分支就会发现整个工作流看起来特别乱, 多了许多不必要显示的记录, 对于强迫症来说, 这绝对不能忍.
所以我们可以先把feature分支的提交合并之后再合并到主分支上,保持git工作流清爽.
把feature分支最新的三条记录合并为一条, 使用命令

```
git rebase -i  [startpoint]  [endpoint]
```

> 注: 其中-i的意思是–interactive，即弹出交互式的界面让用户编辑完成合并操作，[startpoint]
> [endpoint]则指定了一个编辑区间，如果不指定[endpoint]，则该区间的终点默认是当前分支HEAD所指向的commit(注：该区间指定的是一个前开后闭的区间)。

然后我们可以看到一个编辑信息界面:

![](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220419164934.jpg)

未被注释的部分列出的是本次rebase操作包含的所有提交，下面注释部分是git为我们提供的命令说明。每一个commit id 前面的pick表示指令类型，git 为我们提供了以下几个命令:

>
>
>pick：保留该commit（缩写:p）
>
>reword：保留该commit，但我需要修改该commit的注释（缩写:r）
>
>edit：保留该commit, 但我要停下来修改该提交(不仅仅修改注释)（缩写:e）
>
>squash：将该commit和前一个commit合并（缩写:s）
>
>fixup：将该commit和前一个commit合并，但我不要保留该提交的注释信息（缩写:f）
>
>exec：执行shell命令（缩写:x）
>
>drop：我要丢弃该commit（缩写:d）
>

根据我们的需求，我们将commit内容编辑如下:
(tips: i进入编辑, esc退出编辑)

```
pick d2cf1f9 fix: 第一次提交

s 47971f6 fix: 第二次提交

s fb28c8d fix: 第三次提交

```

上面的意思就是把第二次、第三次提交都合并到第一次提交上

然后wq保存退出后是注释修改界面:

#### 场景九: git add 提交到暂存区，出错怎么办

一般代码提交流程为：工作区 -> **git status** 查看状态 -> **git add .** 将所有修改加入暂存区-> **git commit -m “提交描述”** 将代码提交到 本地仓库 -> **git push** 将本地仓库代码更新到 远程仓库

###### 场景1：工作区

当你改乱了工作区某个文件的内容，想直接丢弃工作区的修改时，用命令**git checkout – file**。
// 丢弃工作区的修改

```
git checkout -- <文件名>
```

场景2：暂存区

当你不但改乱了工作区某个文件的内容，还 **git add** 添加到了暂存区时，想丢弃修改，分两步，第一步用命令 **git reset HEAD** ，就回到了场景1，第二步按场景1操作。
// 把暂存区的修改撤销掉（**unstage**），重新放回工作区。

```
git reset HEAD <文件名> 
```

#### 场景十: 发现某个版本的代码有问题, 可以不回退版本吗?

答案是:**可以.**
很多人在发现某个历史版本代码有问题的时候, 可能第一时间想到的就是使用**reset**进行版本回退或**revert**重置该版本的代码, 但实际上并不需要回退.
操作如下:

```
git log --oneline  //找到需要修改的版本号
git checkout 67ce50c  //检出版本分支
git branch -a   //检查分支, 当前分支为该版本分支
```

修改完之后, 再切回原来的分支, 提交代码, 再查看全部分支, 检出的版本分支已经不存在了, 都不用删除分支, 这样的方式是不是很爽





## 参考

[Git常用命令](https://blog.csdn.net/qq_37210523/article/details/102609046)