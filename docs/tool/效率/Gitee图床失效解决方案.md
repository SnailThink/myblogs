# Gitee 图床失效

# 前言

周末发现Gitee图床增加了防盗链，不能使用了。果然免费的就是最贵的，推荐大家将图片迁移到云服务器上，一年就几块钱比较便宜。

**博客说明**

> 文章所涉及的资料来自互联网整理和个人总结，意在于个人学习和经验汇总，如有什么地方侵权，请联系本人删除，谢谢！



## 一、PicGo + 阿里云OSS图床配置

### 1.开通阿里云OSS

开通阿里云OSS https://www.aliyun.com/product/oss/

![image-20220329165851953](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220329165852.png)

### 2.创建Bucket 

- 读写权限我选的是公共读比较简单
- Bucket名称是填写什么对应生成的图片域名就是下面这种格式：  https://Bucket名称-cn-hangzhou.aliyuncs.com/ 
- 其他的可以不用勾选(直接选择默认的就可以了)

![image-20220329170036416](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220329170036.png)

### 3.创建子账户

#### 3.1 添加用户

我们需要AccessKey进行管理



![image-20220329170631332](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220329170631.png)

![image-20220329170723122](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220329170723.png)

创建好账户就可以看见Appkey，后面再说这个怎么用

#### 3.1 配置用户权限设置

![image-20220329171040796](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220329171040.png)

### 4.配置PicGo

#### 4.1配置阿里云图床



![image-20220329171308772](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220329171308.png)



- `设定KeyId`和`设定KeySecret`处填写前面记录的**AccessKey ID**和**AccessKey Secret**。
- `设定存储空间名`处填写Bucket的名字。
- `确定存储区域`也是在创建Bucket时设定的。如果忘记了，可在阿里云后台的Bucket概览界面查看，比如我的是**oss-cn-hangzhou**。见下图。
- `指定存储路径`可填写为**img/**。



![image-20220329171414283](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220329171414.png)

点击确定，到此便完成了**PicGo+阿里云OSS**的图床配置。建议勾选「设为默认图床」。



#### 4.2.设置自动上传图片

![image-20220329173408408](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220329173408.png)

## 二、迁移Markdown文件图片到阿里云OSS



### 1.Gitee图床还可以访问迁移



#### 1.1 在PicGo中增加插件pic-migrater

![image-20220329172015844](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220329172015.png)



#### 1.2.选择需要替换的md文件

![image-20220329172039250](https://whcoding.oss-cn-hangzhou.aliyuncs.com/img/20220329172039.png)

选择文件后就会自动替换 `Markdown`文件中的图片位置。



### 2.Gitee图床还不可以访问迁移

针对Gitee图床无法访问，我想到的解决办法是，将`Markdown`文件中的图片路径替换就行。但是文件太多手动替换不太现实。

我的思路是，获取文件夹下的所有md格式文件，并按照行读取文件，然后替换文件。

由于格式都是`![]（）`的并且图片名称都是相同的。此方案比较笨拙，若大佬们有好的解决方案，欢迎留言告知我。







```java
package com.whcoding.test;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.junit.Test;

import java.io.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @program: spring-boot-learning
 * @description: 读取写入文件
 * @author: whcoding
 * @create: 2022-03-28 17:46
 **/
@Slf4j
public class ReadTxtTest{

	/**
	 *
	 * 替换字符串
	 * @param args
	 */
	public static void main(String args[]) {
		String path = "F:\\temp\\oss-img-md";
		//1.读取文件夹下的所有视频文件
		List<File> fileList = new ArrayList<>();
		readFileInDir(path, fileList);
		//2.获取文件名称
		List<String> fileNameList = fileList.stream().map(File::getName).collect(Collectors.toList());

		log.info("得到的文件列表为:");
		fileNameList.stream().forEach(t -> System.out.println(t));
		log.info("待转换的文件个数为:{}",fileNameList.size());

		//3.需要转换处理的字符串
		String toOldStr = "https://gitee.com/image/raw/master/image/";
		String toReplaceStr = "https://Bucket.oss-cn-hangzhou.aliyuncs.com/img/";
		String outFilePath = "F:\\博客文档_新";
		//4.替换文件
		fileList.stream().forEach(c-> easyReadAndWriteFile(c.getAbsolutePath(),outFilePath,toOldStr,toReplaceStr));
		System.out.println("执行完成！");
	}

	

	/**
	 *
	 * @param readFilePath 读取文件的地址
	 * @param outFilePath 输出文件的路径
	 * @param toOldStr 旧文件【需要替换的文件】
	 * @param toReplaceStr 【替换成新的文件】
	 */
	@Test
	public static void easyReadAndWriteFile(String readFilePath,String outFilePath,String toOldStr,String toReplaceStr) {
		BufferedReader reader = null;
		try {
			reader = new BufferedReader(new FileReader(readFilePath));
			PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(outFilePath)));
			String lineStr;
			while ((lineStr = reader.readLine()) != null) {
				if (StringUtils.isNotEmpty(lineStr) && lineStr.contains(toOldStr)) {
					out.println(lineStr.replaceAll(toOldStr, toReplaceStr));
					count++;
				}
			}
			reader.close();
			out.close();
			System.out.println("执行完成！");
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			//关闭流
			if (reader != null) {
				try {
					reader.close();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
			}
		}
	}



	/**
	 * 递归读取文件夹下的所有文件
	 *
	 * @param path
	 */
	public static void readFileInDir(String path, List<File> fileList) {
		File f = new File(path);
		//得到文件下的所有文件
		File[] files = f.listFiles();

		for (File file : files) {
			if (file.isDirectory()) {
				readFileInDir(file.getAbsolutePath(), fileList);
			} else {
				if (isMarkDownFile(file.getName())) {
					fileList.add(file);
				}
			}
		}
	}

	/**
	 * 判断是否是markdown文档
	 *
	 * @param fileName
	 * @return
	 */
	public static boolean isMarkDownFile(String fileName) {
		boolean result = false;
		 Set<String> markDownFileSuffix = new HashSet<>();
		markDownFileSuffix.add("md");
		String suffix = fileName.substring(fileName.lastIndexOf('.') + 1);
		if (markDownFileSuffix.contains(suffix)) {
			result = true;
		}
		return result;
	}
}
```







## 参考

PicGo + 阿里云OSS：https://mp.weixin.qq.com/s/Mry9_HdLbXz8w4_874_7eQ

阿里云官网: *https://www.aliyun.com*

购买存储空间: *https://common-buy.aliyun.com/?spm=5176.8465980.0.0.4e701450E6303q&commodityCode=ossbag&request=%7B%22region%22%3A%22china-common%22%7D#/buy*

流量费用官方说明: *https://help.aliyun.com/document_detail/59636.html?spm=5176.11451019.101.3.5b302135Qd1ak4*

PicGo: *https://github.com/Molunerfinn/PicGo/releases*