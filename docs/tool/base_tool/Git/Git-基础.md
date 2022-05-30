

## git基础操作



#### 0.git工作流程



**git仓库的三大区域：工作区、暂存区、版本区**

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530182745.png)

**git 工作流程**

![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530182811.png)

add 后文件存储在暂存区

commit 后文件存储在版本库

push 后文件存在在远程仓库





#### 1.分支管理



##### 1.查看分支

```sh
# 查看本地分支
git branch

# 查看远程分支
git branch -r

# 查看所有分支包含远程和本地
git branch -a

#分支模糊查询
git branch | grep 'branchName'

#清理无效分支(远程已经删除本地没有删除的分支)
git fetch -p

# 查看分支下的文件
git ls-files

```

##### 2.新增分支

```sh
# 新增一个test分支
git branch test
```

##### 3. 切换分支

```sh
#切换到test分支
git checkout master
```

##### 4. 删除分支

```sh
#删除test分支
git bracnch -d test

#删除远程分支
git push origin --delete [branchname]
```

##### 5.合并分支

```sh
#切换到develop分支
git checkout develop 
git merge test   // 将test分支合并到当前分支
```

##### 6.推送分支

````sh
#关联分支
git remote add origin https://gitee.com/VincentBlog/testgit.git

# 推送分支 推送到远端仓库
git push origin https://gitee.com/VincentBlog/testgit.git

# 拉取分支
git clone https://gitee.com/VincentBlog/testgit.git
````

##### 7.重命名分支

```sh
git branch -m oldName newName
```



#### 2.gitlog

```sh
# 查看commit 提交日志 包含 11的提交记录
git log  --all  --grep='11'

#查看提交记录
git reflog 

#显示全部的版本历史
git log -3 //(查询最近3次的提交记录)

# 查看指定文件的修改记录
git blame filename
```



#### 3.git 回退

##### 1.版本库回退

```sh
#创建一个文本并添加
echo 'aaa111bbb'> temp.txt
#添加文本信息[追加]
echo '0000' >>temp.txt
#查询差异
git diff
#提交代码
git commit -m 'temp2'
#回退到没有添加0000版本
git reset --hard HEAD^  //回退一个版本（将版本退回上一个commit的状态）
git reset --hard HEAD^^ //回退两个版本
git reset --hard HEAD~100 //回退100个版本

# 回退到指定版本
git reset --hard 版本号
# 查看版本号
git log
```



##### 2.git未add操作

```sh
#由于未执行add操作则可以直接删除文件
rm test
git checkout  --filename
```



##### 3.add后回退，没有commit

```sh
#add添加到了暂存区 从暂存区中删除[暂存区可以直接删除]
git reset HEAD filename
git checkout --filename
```

##### 4.push后回退

````sh
#push后回退和commit回退的区别


````





#### 4.git 标签

```sh
# 新增tag
 git tag v1.0
# 查看标签
git tag
# 历史版本增加 tag
git tag v0.9 4ec76c9

#删除tag
git tag -d tagName 

#删除远程tag
git push origin :refs/tags/tagName  

```



#### 5.修改用户名密码

**修改用户/密码**

````sh
#修改用户名
$ git config --global --replace-all user.name "要修改的用户名"

#修改邮箱
$ git config --global --replace-all user.email"要修改的邮箱"

#修改密码
$ git config --global --replace-all user.password "要修改的密码"

#查看修改完后的用户名：

$ git config user.name 

#查看修改完后的邮箱：

$ git config user.email

#查看修改完后的密码：

$ git config user.password
````



**切换用户**

```sh
# 查看用户名
git config user.name 

# 切换用户
git config --global user.name "xxx" 

#切换邮箱
git config --global user.email "xxx"

```



#### 6.初始化

```sh
#新建仓库
git init

#add 添加到暂存区
git add .

#commit 添加到版本库
git commit -m 'temp'

#版本库关联
git remote add origin https://gitee.com/VincentBlog/testgit.git

#拉取远程分支
git pull 

#推送数据到远程
git push origin https://gitee.com/VincentBlog/testgit.git

```



#### 7.配置ssh



```sh
#查看用户名和邮箱是否配置
git config --global  --list 

#配置用户名以及邮箱
git config --global  user.name "这里换上你的用户名"
git config --global user.email "这里换上你的邮箱"

#生成秘钥
ssh-keygen -t rsa -C "这里换上你的邮箱"

#在路径下找到 id_rsa.pub 配置到github 中
C:\Users\Manager\.ssh

```

#### 8.git常用流程

![](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530182854.png)
git init 初始化git文件夹

git add .  添加到暂存区

git commit 添加到本地仓库

git push 推送到远程仓库

git pull 拉取远程仓库

git clone 将远程仓库拉取到本地仓库

git checkout 从本地仓库拉取到工作区

git reset --hard 版本号 回滚版本


#### 9.配置SSH

ssh-keygen -t rsa





