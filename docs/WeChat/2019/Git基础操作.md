
# 常规操作 #

## 常见问题

### 1.如何推送代码到github
```
git init 
git add .
git commit  -m  "提交信息" 
git remote add origin 仓库链接地址
git pull origin master
git push -u origin master

>下面为仓库地址 https://github.com/VincentBlog/JavaBlog.git、git@github.com:VincentBlog/JavaBlog.git
```
### 2.git 如何回滚
```

查看历史提交版本：

2.1.git log 查看历史所有版本信息

2.2.git log -x 查看最新的x个版本信息

2.3.git log -x filename查看某个文件filename最新的x个版本信息（需要进入该文件所在目录）

2.4.git log --pretty=oneline查看历史所有版本信息，只包含版本号和记录描述

回滚版本：

2.1.git reset --hard HEAD^，回滚到上个版本

2.2.git reset --hard HEAD^~2，回滚到前两个版本

2.3.git reset --hard xxx(版本号或版本号前几位)，回滚到指定版本号，如果是版本号前几位，git会自动寻找匹配的版本号

2.4.git reset --hard xxx(版本号或版本号前几位) filename，回滚某个文件到指定版本号（需要进入该文件所在目录）
```

### 3.git 如何合并代码
```

3.1.git branch -a（查看所有分支：本地分支白色，当前分支绿色，远程分支红色）
3.2 git checkout develop （由自己的分支vincent 切换到develop分支）
3.3 git merge --no-ff -m '合并 双十一预售活动' vincent 
3.4 发现冲突文件，编辑冲突文件，解决冲突，再次提交
3.5 git diff develop vincent   提交之后，对比一下develop和vincent分支：
3.6 git log 查看提交记录
3.7 git pull origin develop  更新远程分支的最新代码
3.8 git push -u origin develop  推送到develp 分支上
```


### 4.git 如何解决冲突
```

合并远程库和你本地的代码执行命令：
4.1 git fetch 更新远程仓库文件
4.2 git diff master origin/master 本地文件和远程仓库文件进行对比
4.3 git merge origin/master 自动合并
根据需求手动删除不必要的代码，修改完成git push到远程仓库
```

### 5.git远程仓库操作
```
5.1 检出仓库：$ git clone git@github.com:VincentBlog/JavaBlog.git
5.2 查看远程仓库：$ git remote -v
5.3 添加远程仓库：$ git remote add [name] [url]
5.4 删除远程仓库：$ git remote rm [name]
5.5 修改远程仓库：$ git remote set-url --push [name] [newUrl]
5.6 拉取远程仓库：$ git pull [remoteName] [BranchName]
5.7 推送远程仓库：$ git push [remoteName] [BranchName]
```

### 6.基础命令
```
- git config --global user.name   //获取当前登录的用户

- git config --global user.email  //获取当前登录用户的邮箱

- git config --global user.name 'userName'    //设置git账户，userName为你的git账号，

- ls -al 查看目录

- git cat index.html 查看文件内容

- git add index.html 

- git add -A      //全部添加到缓存区

- git commit -m '备注信息' [添加到版本库]

- 比较差异
- git log --oneline     [查看版本]

- git diff   [比较的是暂存区和工作区的差异]

- git diff --cached [比较的是暂存区和历史区的差异]

- git diff master [比较的是历史区和工作区的差异（修改）]

- 撤回内容
- git checkout index.html [用暂存区中的内容或者版本库中的内容覆盖掉工作区]

- git reset HEAD index.html [取消增加到暂存区的内容]

- git status

- 删除文件
- rm fileName  [删除本地文件]

- git rm index.html --cached  [使用--cached 表示只删除缓存区中的内容]

```
#### 6.1 常规操作
```
- git push origin test 推送本地分支到远程仓库

- git rm -r --cached 文件/文件夹名字 取消文件被版本控制

- git reflog 获取执行过的命令

- git log --graph 查看分支合并图

- git merge --no-ff -m '合并描述' 分支名 不使用Fast forward方式合并，采用这种方式合并可以看到合并记录

- git check-ignore -v 文件名 查看忽略规则

- git add -f 文件名 强制将文件提交

- git --version   //查看git的版本信息

- git init 初始化

- git remote add origin url 关联远程仓库

- git pull

- git fetch 获取远程仓库中所有的分支到本地

- git update-index --assume-unchanged file 忽略单个文件

- git rm -r --cached 文件/文件夹名字 (. 忽略全部文件)

- git update-index --no-assume-unchanged file  --取消忽略文件

- git config --global credential.helper store  --拉取、上传免密码

```

#### 6.2 SSH Key
```
- ssh-keygen –t rsa –C "你的邮箱@xx.com" --生成SSH Key：

- 生成Key时弹出选项，回车选择默认即可。

- Key保存位置：/root/.ssh

- 登陆GitHub，创建new SSH key，其内容为/root/.ssh/id_rsa.pub中文本

- 已经有了本地库和远程库，二者实现同步

- 本地库的改动提交到远程库：git push origin master

- 更新本地库至远程库的最新改动：git pull
```

## 分支操作
```
- git branch 创建分支

- git branch -b 创建并切换到新建的分支上

- git checkout 切换分支

- git branch 查看分支列表

- git branch -v 查看所有分支的最后一次操作

- git branch -vv 查看当前分支

- git brabch -b 分支名 origin/分支名 创建远程分支到本地

- git branch --merged 查看别的分支和当前分支合并过的分支

- git branch --no-merged 查看未与当前分支合并的分支

- git branch -d 分支名 删除本地分支

- git branch -D 分支名 强行删除分支

- git branch origin :分支名 删除远处仓库分支

- git merge 分支名 合并分支到当前分支上

```

## 暂存操作
```
- git stash 暂存当前修改

- git stash apply 恢复最近的一次暂存

- git stash pop 恢复暂存并删除暂存记录

- git stash list 查看暂存列表

- git stash drop 暂存名 移除某次暂存

- git stash clear 清除暂存
```
## 回退操作
```
- git reset --hard HEAD^ 回退到上一个版本

- git reset --hard ahdhs1(commit_id) 回退到某个版本

- git checkout -- file撤销修改的文件(如果文件加入到了暂存区，则回退到暂存区的，如果文件加入到了版本库，则还原至加入版本库之后的状态)

- git reset HEAD file 撤回暂存区的文件修改到工作区
```

## 标签操作
```
- git tag 列出所有标签列表

- git tag 标签名 添加标签(默认对当前版本)

- git tag 标签名 commit_id 对某一提交记录打标签

- git tag -a 标签名 -m '描述' 创建新标签并增加备注

- git show 标签名 查看标签信息

- git tag -d 标签名 删除本地标签

- git push origin 标签名 推送标签到远程仓库

- git push origin --tags 推送所有标签到远程仓库

- git push origin :refs/tags/标签名 从远程仓库中删除标签
```

>参考网址:
https://blog.csdn.net/tomatozaitian/article/details/73515849

