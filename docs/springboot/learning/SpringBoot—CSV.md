

## Java导出CSV文件

### 背景：

最近项目中需要导出CSV文件，之前一直都是导出Excel文件，在网上看了其他的导出好多都是写的不清楚的，

借此总结下CSV文件的导出，CSV文件件的本质是导出以逗号为分隔的文本数据 。下面将详细介绍导出的流程



### 1.什么是CSV文件

 **逗号分隔值**（Comma-Separated Values，**CSV**，有时也称为**字符分隔值**，因为分隔字符也可以不是逗号），其文件以纯文本形式存储表格数据（数字和文本）。纯文本意味着该文件是一个[字符](https://baike.baidu.com/item/字符/4768913)序列，不含必须像[二进制数字](https://baike.baidu.com/item/二进制数字/5920908)那样被解读的数据。CSV文件由任意数目的记录组成，记录间以某种换行符分隔；每条记录由[字段](https://baike.baidu.com/item/字段/2885972)组成，字段间的分隔符是其它字符或字符串，最常见的是逗号或[制表符](https://baike.baidu.com/item/制表符/7337607)。通常，所有记录都有完全相同的字段序列。通常都是[纯文本文件](https://baike.baidu.com/item/纯文本文件/4865229)。 

### 2. 引入pom包

```java
       <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-csv</artifactId>
            <version>1.6</version>
        </dependency>
```



### 2.导出CSV文件

```java
package com.example.snailthink.common;

import com.example.snailthink.entity.OrmCustomerVO;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;

import java.io.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class CSVUtils {

    // private static final Logger logger = LoggerFactory.getLogger(CSVUtils.class);

    /**
     * io流导出
     * @param file csv文件(路径+文件名)，csv文件不存在会自动创建
     * @param dataList 数据，字符串用逗号分隔
     * @return 返回导出是否成功 true成功 false失败
     */
    public static boolean exportCsv(File file, List<String> dataList){
        boolean isSucess=false;

        FileOutputStream out=null;
        OutputStreamWriter osw=null;
        BufferedWriter bw=null;
        try {
            out = new FileOutputStream(file);
            //解决FileOutputStream中文乱码问题  解决MS office乱码问题
            osw = new OutputStreamWriter(out, "GBK");
            bw =new BufferedWriter(osw);
            if(dataList!=null && !dataList.isEmpty()){
                for(String data : dataList){
                    bw.append(data).append("\r");
                }
            }
            isSucess=true;
        } catch (Exception e) {
            isSucess=false;
        }finally{
            if(bw!=null){
                try {
                    bw.close();
                    bw=null;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if(osw!=null){
                try {
                    osw.close();
                    osw=null;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if(out!=null){
                try {
                    out.close();
                    out=null;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return isSucess;
    }

    /**
     * 导入
     * @param file  csv文件(路径+文件)
     * @return 返回List<String>列表
     */
    public static List<String> importCsv(File file){
        List<String> dataList=new ArrayList<String>();
        BufferedReader br=null;
        try {
            br = new BufferedReader(new FileReader(file));
            String line = "";
            while ((line = br.readLine()) != null) {
                dataList.add(line);
            }
        }catch (Exception e) {
            e.printStackTrace();
        }finally{
            if(br!=null){
                try {
                    br.close();
                    br=null;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return dataList;
    }

    /**
     * apache commons-csv导出
     * 注意jdk要在1.7及以上使用
     * map的数据个数要与header的个数相等 并且一一对应，可参照main方法
     * @param filePath 文件存储路径
     * @param list 数据列表
     * @param header 表头
     */
    public static void write(String filePath,List<LinkedHashMap<String, String>> list,String... header) {
        try {
            FileOutputStream fos = new FileOutputStream(filePath);
            OutputStreamWriter osw = new OutputStreamWriter(fos, "GBK");
            CSVFormat csvFormat = CSVFormat.DEFAULT.withHeader(header);
            CSVPrinter csvPrinter = new CSVPrinter(osw, csvFormat);
            //跟上面两行代码是一样的
            //CSVPrinter csvPrinter = CSVFormat.DEFAULT.withHeader(header).print(osw);
            for (Map<String, String> map : list) {
                csvPrinter.printRecord(map.values());
            }
            csvPrinter.flush();
            csvPrinter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
     //方法一：write 导出CSV文件
		String filePath = "D://CSV测试数据.csv";

		File saveFilePath=new File(filePath);

		List<OrmCustomerVO> ormCustomerVOList=new ArrayList<>();
		OrmCustomerVO ormCustomerVO1=new OrmCustomerVO();
		ormCustomerVO1.setCustomerNo("BJ001");
		ormCustomerVO1.setCustomerName("北京分仓");

		OrmCustomerVO ormCustomerVO2=new OrmCustomerVO();
		ormCustomerVO2.setCustomerNo("XA001");
		ormCustomerVO2.setCustomerName("西安分仓");

		OrmCustomerVO ormCustomerVO3=new OrmCustomerVO();
		ormCustomerVO3.setCustomerNo("SH001");
		ormCustomerVO3.setCustomerName("上海分仓");

		ormCustomerVOList.add(ormCustomerVO1);
		ormCustomerVOList.add(ormCustomerVO2);
		ormCustomerVOList.add(ormCustomerVO3);

		List<LinkedHashMap<String, String>> recordList2 = new ArrayList<>();
		for (OrmCustomerVO customerVO:ormCustomerVOList) {
			LinkedHashMap<String, String> map2 = new LinkedHashMap<>();
			map2.put("CustomerNo", customerVO.getCustomerNo());
			map2.put("CustomerName", customerVO.getCustomerName());
			recordList2.add(map2);
		}
		CSVUtils.write(filePath, recordList2,"CustomerNo","CustomerName");

		//方法二：write 导出CSV文件
		//io流导出
        List<String> dataList=new ArrayList<String>();
        dataList.add("1,2,3,'/N',4");
        dataList.add("1,2,3,'/N',4");
		CSVUtils.exportCsv(saveFilePath, dataList);
    }
}
```

