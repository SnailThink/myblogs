

# Windows 小工具脚本



###  一、获取文件夹下所有文件名称

- **1.将下面这段代码复制到文本文件中**
- 2.将文件名后缀改为`.bat`文件
- 3.将文件放到需要获取文件名称的文件夹下双击执行就会产生一个`LIST.TXT`文件，文件夹下所有的文件名称都在`LIST.TXT`文本中



```c
DIR *.* /B >LIST.TXT
```

### 二、微信轰炸

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

-  前提修改文件的后缀名称为.vbs,
- 在微信聊天输入框内输入你要发送的文字 然后Ctrl+C 复制文字
- 双击桌面的vbs文件 点击发送即可进行轰炸微信



