# C# 利用 IKVM 调用JAVA 方法

![](https://gitee.com/VincentBlog/image/raw/master/image/20201112162712.jpg)



最近在带一个新人小易 , 由于经常犯错，现在把我的低血压都治好了。

不过，小易的心态一直很不错，他不觉得被我批评有什么丢人的，反而每次读完我的文章后觉得自己又可以了。

因此，我觉得小易大有前途，再这么干个一两年，老板要是觉得我的性价比低了，

没准就把我辞退留下小易了。一想到这，我竟然枯燥一笑了。 

		那天，我闲来无聊，小易跑过来找我，说能不能用C# 调用Java代码，实现接口加密。

Excuse me  告辞，

这孩子还真是初生牛犊不怕虎啊，

不过男人怎么能说不行呢，更何况是身为暖男的我。

![](https://gitee.com/VincentBlog/image/raw/master/image/20201112161545.gif)



## 一.环境配置

1. javaVersion ：”1.8.0_31”
2. IKVM：ikvm-8.1.5717.0

IKVM下载地址：链接：https://pan.baidu.com/s/1h2Ye5_euPV1567gjMyHYTw  提取码：44to 

IKVM官网地址：链接：http://www.ikvm.net/

IKVM 如果版本过低 ，无法适用 jdk高版本，如：IKVM7.1无法使用jdk1.8的。

IKVM需要配置环境 ：将IKVM.NET的bin文件夹的地址添加到环境变量。

计算机右键属性–高级系统设置–高级–环境变量–在系统变量中找到PATH–将bin文件夹的地址添加进去。

IKVM.NET是Java for [Mono](http://www.go-mono.org/)和[Microsoft .NET Framework的实现](http://msdn.microsoft.com/netframework/)。它包括以下组件：

- 在.NET中实现的Java虚拟机
- Java类库的.NET实现
- 支持Java和.NET互操作性的工具



## 二.生成jar包和dll文件

#### 2.1 实现SH256加密

```java
//package com.example.think.controller.test; 删除包名称

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;

/**
 * @program: think
 * @description:
 * @author: SnailThink
 * @create: 2020-11-12 14:14
 **/
public class IkvmSh256EncryptionHelp {

	public String getTestStr(){
		return  "AAA";
	}

	/**
	 * 加密
	 * @return
	 */
	public String passwardSh256Encryption() {
		final String secret = "tBKY94PUFZ3a";
		Map<String, String> params = new HashMap<String, String>();
		params.put("api_key", "dtt-13457");
		params.put("nonce_str", "123");
		params.put("timestamp", "2020-04-28 09:50:06");
		params.put("body", "{\n" +
				"    \"token\": \"TVSSsendtasknoservice\",\n" +
				"    \"taskNo\": \"12345\",\n" +
				"    \"receiveNo\": \"12345\",\n" +
				"    \"riskLevel\": \"H\"\n" +
				"}");

		List<String> paramList = new ArrayList<>();
		for (Map.Entry<String, String> entry : params.entrySet()) {
			paramList.add(entry.getKey() + "=" + entry.getValue());
		}
		Collections.sort(paramList);
		StringBuilder sb = new StringBuilder();
		sb.append(secret);
		for (String paramStr : paramList) {
			sb.append(paramStr);
			sb.append("&");
		}
		sb.replace(sb.length() - 1, sb.length(), secret);
		System.out.println(sb.toString());
		String aa = getSHA256(sb.toString());
		System.out.println(aa);
		return aa;
	}


	/**
	 * 利用java原生的类实现SHA256加密
	 *
	 * @param str
	 * @return
	 */
	public static String getSHA256(String str) {
		MessageDigest messageDigest;
		String encodestr = "";
		try {
			messageDigest = MessageDigest.getInstance("SHA-256");
			messageDigest.update(str.getBytes("UTF-8"));
			encodestr = byte2Hex(messageDigest.digest());
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return encodestr;
	}


	//15 转16进制

	/**
	 * 将byte转为16进制
	 *
	 * @param bytes
	 * @return
	 */
	public static String byte2Hex(byte[] bytes) {
		StringBuffer stringBuffer = new StringBuffer();
		String temp = null;
		for (int i = 0; i < bytes.length; i++) {
			temp = Integer.toHexString(bytes[i] & 0xFF);
			if (temp.length() == 1) {
				//1得到一位的进行补0操作
				stringBuffer.append("0");
			}
			stringBuffer.append(temp);
		}
		return stringBuffer.toString();
	}
}


```



#### 2.2 生成jar包

**1.将java文件转换为class文件**

```java
javac IkvmSh256EncryptionHelp.java
```

如何出现以下错误：是由于没有使用utf-8转码的则使用

```java
javac -encoding UTF-8 IkvmSh256EncryptionHelp.java
```

![](https://gitee.com/VincentBlog/image/raw/master/image/20201112161546.png)

**执行成功后如下图所示**

![](https://gitee.com/VincentBlog/image/raw/master/image/20201112161547.png)



**将class文件转换为jar包**

```
jar cvf IkvmSh256EncryptionHelp.jar IkvmSh256EncryptionHelp.class
```

![](https://gitee.com/VincentBlog/image/raw/master/image/20201112161548.png)

**下面就到关键的一步了将jar包转换为dll文件**

```
//这里是把IkvmSh256EncryptionHelp.jar包转成dll
ikvmc -target:library IkvmSh256EncryptionHelp.jar 
```

![](https://gitee.com/VincentBlog/image/raw/master/image/20201112161541.png)

dll文件生成成功

## 三 项目调用

**3.1 创建一个winform项目测试并安装Nuget**

![](https://gitee.com/VincentBlog/image/raw/master/image/20201112161542.png)



**3.2 在项目中添加 IkvmSh256EncryptionHelp.dll**

![](https://gitee.com/VincentBlog/image/raw/master/image/20201112161543.png)



**3.3 调用sh256加密**

```c#
 #region  NET 调用java 代码
 /// <summary>
 /// NET 调用java 代码
 /// </summary>
 /// <param name="sender"></param>
 /// <param name="e"></param>
 private void button26_Click(object sender, EventArgs e)
 {
     IkvmSh256EncryptionHelp ikvmHelp = new IkvmSh256EncryptionHelp();
     string testStr = ikvmHelp.getTestStr();
     string passwardSh256Encryption = ikvmHelp.passwardSh256Encryption();
 }
 #endregion

```



## 四 反编译dll文件

其实比较好奇内部是如何实现的，那么我们可以先看看dll文件反编译后的内容，可能有同学就要问了，用什么反

编译软件啊，我没有啊，傻瓜 身为暖男的我怎么不会为你们考虑呢，链接放在下面了

链接：https://pan.baidu.com/s/108VDeLkfarDFTlksSl5Brw 
提取码：gv56 

![](https://gitee.com/VincentBlog/image/raw/master/image/20201112161544.png)



根据反编译的文件可以看到

 ```c#
public virtual string getTestStr() {
	return "AAA"
}

[MethodImpl(MethodImplOptions.NoInlining)]
public virtual string passwardSh256Encryption()
{
		HashMap hashMap = new HashMap();
		hashMap.put("api_key", "dtt-13457");
		hashMap.put("nonce_str", "123");
		hashMap.put("timestamp", "2020-04-28 09:50:06");
		hashMap.put("body", "{\n    \"token\": \"TVSSsendtasknoservice\",\n    \"taskNo\": \"12345\",\n    \"receiveNo\": \"12345\",\n    \"riskLevel\": \"H\"\n}");
		ArrayList arrayList = new ArrayList();
		Iterator iterator = hashMap.entrySet().iterator();
		while (iterator.hasNext())
		{
			Map.Entry entry = (Map.Entry)iterator.next();
			arrayList.add(new StringBuilder().append((string)entry.getKey()).append("=").append((string)entry.getValue()).toString());
		}
		Collections.sort(arrayList);
		StringBuilder stringBuilder = new StringBuilder();
		stringBuilder.append("tBKY94PUFZ3a");
		Iterator iterator2 = arrayList.iterator();
		while (iterator2.hasNext())
		{
			string text = (string)iterator2.next();
			stringBuilder.append(text);
			stringBuilder.append("&");
		}
		stringBuilder.replace(stringBuilder.length() - 1, stringBuilder.length(), "tBKY94PUFZ3a");
		System.get_out().println(stringBuilder.toString());
		string sHA = IkvmSh256EncryptionHelp.getSHA256(stringBuilder.toString());
		System.get_out().println(sHA);
		return sHA;
}
 ```

## 五 回顾

 这个使用SH256加密主要是一个思路，在工作中遇到对接Java接口，涉及Java加密或者签名问题.net无法实现

就将java代码编辑为dll文件给net调用。

## 关注

![snailThink.png](http://ww1.sinaimg.cn/large/006aMktPgy1gdegzjxv6yj30go0gogmi.jpg)

![](https://pic.downk.cc/item/5f5e3aae160a154a67a7b936.gif)

 