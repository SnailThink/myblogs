## IDEA 回退代码



![img](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220530182854.png)



## 操作流程:

### 1.工作区 => 暂存区 —— git add

`git add`可将多个文件添加到暂存区。

```
$ git add readme.md Test1.py
```

### 2.暂存区 => 版本区 —— git commit

`git commit`将暂存区当中的所有文件一次性提交到版本区，`-m`参数后跟着每次提交说明，对哪些地方进行修改的简述。

```
$ git commit -m "commit the last Version"
```

### 3 版本区 => 暂存区 —— git reset --mixed

`git reset`命令`--mixed`跟着版本号，是指把该版本号提交的内容从版本区位置回滚到暂存区。

```
$ git reset --mixed d5d43ff
```

### 4.暂存区 => 工作区 —— git reset --soft

`git reset`命令`--soft`跟着版本号，是指把该版本号提交的内容从暂存区位置回滚到工作区。

```
$ git reset --soft d5d43ff
```

### 5.版本区 => 暂存区 => 工作区 —— git reset --hard

`git reset`命令`--hard`跟着版本号，是指把该版本号提交的内容从版本区位置回滚到工作区。

```
 git reset --hard d5d43ff
```

## 回退代码IDEA

### 1.提交到暂存区回退

直接使用Delete 删除数据

![image-20220922160744932](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220922160744932.png)

### 2.提交到版本区回退

**1.执行commit操作 提交代码到版本区**

![image-20220922161003462](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220922161003462.png)

**2.回退版本区代码到暂存区**

选择Reset HEAD

![image-20220922161116409](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220922161116409.png)





选择Validate

![image-20220922161136045](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220922161136045.png)

**选择要回退的文件test3**

![image-20220922161438015](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220922161438015.png)



**复制这个head**

![image-20220922161510296](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220922161510296.png)



**查看回退后的内容** 点击Reset 进行回退 就回退成功了

![image-20220922161542669](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/image-20220922161542669.png)





### 3.push 后进行回退



