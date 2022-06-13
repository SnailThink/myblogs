### Git常规操作

#### 1.Git修改已提交邮箱

```shell
-- 1.拉取最新代码
git clone 

-- 2.查看没修改之前的作者和邮箱
git log

-- 3. 在项目根目录新建modify_author.sh 
-- 注意：执行脚本前需要提交所有代码
git filter-branch -f --env-filter '
OLD_EMAIL="原来的邮箱"
CORRECT_NAME="现在的名字"
CORRECT_EMAIL="现在的邮箱"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags

-- 4.根目录打开git Bash 执行脚本
sh ./modify_author.sh

-- 5.看看是否已经修改了
git log

--6. 执行后强制同步
git push --force origin 分支名
    或者
git push origin --force --all
```

#### 2.修改git邮箱

```shell
-- 1.查看当前用户名、邮箱
git config user.name
git config user.email

-- 2.修改用户名、邮箱
git config user.name xxx
git config user.email xxx


[core]
	repositoryformatversion = 0
	filemode = false
	bare = false
	logallrefupdates = true
	symlinks = false
	ignorecase = true
[remote "origin"]
	url = https://gitee.com/VincentBlog/spring-boot-learning.git
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
	remote = origin
	merge = refs/heads/master
[user]
	name = whcoding
	email = 137299954@qq.com
```

