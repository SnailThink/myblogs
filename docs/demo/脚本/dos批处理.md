## DOC批处理.bat


### 1.获取文件夹下所有文件名称
文件后缀为.bat
```basic
DIR *.* /B >LIST.TXT
```

### 3.自动提交git 并推送

后缀为.sh
```bash
git add . && git commit -m $1 && git push origin master
```

### 微信轰炸

**尾部带数字序号**

```c
set wshshell=wscript.createobject("wscript.shell") 
wshshell.AppActivate"要发送的人的名字" 
for i=1 to 100     //循环次数
wscript.sleep 100     //间隔时间，单位毫秒
wshshell.sendKeys "^v" 
wshshell.sendKeys i 
wshshell.sendKeys "%s" 
next
```

**尾部不带数字**

```c
set wshshell=wscript.createobject("wscript.shell") 
wshshell.AppActivate "A-拾贰" 
for i=1 to 100
wscript.sleep 100 
wshshell.sendKeys "^v" 
wshshell.sendKeys "%s" 
next
```

备注：

 前提修改文件的后缀名称为.vbs,

1.在微信聊天输入框内输入你要发送的文字 然后Ctrl+C 复制文字

2.双击桌面的vbs文件 点击发送即可进行轰炸微信

```c
set wshshell=wscript.createobject("wscript.shell") 
wshshell.AppActivate "A-拾贰" 
for i=1 to 100
wscript.sleep 100 
wshshell.sendKeys "^v" 
wshshell.sendKeys "%s" 
next
```

