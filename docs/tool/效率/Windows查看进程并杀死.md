

## Windows查看进程并杀死



## 方法一：

### 1.查看所有进程

```shell
tasklist
# 或查看某个程序的进程
tasklist|findstr chrome.exe
```

### 2.强制结束进程

```shell
 taskkill /im chrome.exe  /f
```

- 1、`/im` 指定要终止的进程的映像名称。通配符 '*'可用来

- 2、`/f`的意思是强制结束 

  

## 方法二：



### 1.查看进程的pID

```shell
netstat –aon | findstr "16676"  
# 或者
netstat –aon | find "16676"  
```

### 2.根据PID查询进程

```shell
tasklist|findstr "16676"
```

### 3.显示 taskkill 帮助

```shell
 taskkill /?
```

![](https://gitee.com/VincentBlog/image/raw/master/image/20210522101912.png)

### 4.强制结束进程

```shell
taskkill /T /F /PID "16676" 
```



