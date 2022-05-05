## MySQL全量+增量备份脚本



### **1、增量备份脚本，脚本中文件路径需要自行创建

```shell
[root@server mysqlbak]# cat binlogbak.sh 
#!/bin/bash
export LANG=en_US.UTF-8
BakDir=/u01/data/mysqlbak/data/zlbak
BinDir=/var/lib/mysql
LogFile=/u01/data/mysqlbak/log/binlog.log
BinFile=/var/lib/mysql/logindex.index
mysqladmin -h 172.16.40.92 -uroot -pIDEO-xwk123 flush-logs
#这个是用于产生新的mysql-bin.00000*文件

Counter=`wc -l $BinFile |awk '{print $1}'`
NextNum=0
#这个for循环用于比对$Counter,$NextNum这两个值来确定文件是不是存在或最新的。
for file in `cat $BinFile`
do
    base=`basename $file`
    #basename用于截取mysql-bin.00000*文件名，去掉./mysql-bin.000005前面的./
    NextNum=`expr $NextNum + 1`
    if [ $NextNum -eq $Counter ]
    then
        echo $base skip! >> $LogFile
    else
        dest=$BakDir/$base
        if(test -e $dest)
        #test -e用于检测目标文件是否存在，存在就写exist!到$LogFile去。
        then
            echo $base exist! >> $LogFile
        else
            cp $BinDir/$base $BakDir
            echo $base copying >> $LogFile
        fi
    fi
done
echo `date +"%Y年%m月%d日 %H:%M:%S"` Backup success! >> $LogFile
```

### **2、全量备份脚本，脚本中文件路径需要自行创建**



```shell
#!/bin/bash
export LANG=en_US.UTF-8
BakDir=/u01/data/mysqlbak/data/allbak
ZlbakDir=/u01/data/mysqlbak/data/zlbak
LogFile=/u01/data/mysqlbak/log/bak.log
Date=`date +%Y-%m-%d-%H-%M-%S`
Begin=`date +"%Y年%m月%d日 %H:%M:%S"`
Database=school
#BackName=`$Database-$Date`
cd $BakDir
DumpFile=$Database-$Date.sql
GZDumpFile=$Database-$Date.tar.gz
mysqldump -h 172.16.40.92 -uroot -pIDEO-xwk123 $Database --flush-logs --delete-master-logs --single-transaction > $BakDir/$DumpFile
#mysqldump -h 172.16.40.92 -uroot -pIDEO-xwk123 $Database  > $BakDir/$DumpFile
tar -czvf $GZDumpFile $DumpFile
rm $DumpFile

count=$(ls -l *.tar.gz |wc -l)
if [ $count -ge 2 ]
then
    file=$(ls -l *.tar.gz |awk '{print $9}'|awk 'NR==1')
    rm -f $file
fi
#只保留过去四周的数据库内容
Last=`date +"%Y年%m月%d日 %H:%M:%S"`
echo 开始:$Begin 结束:$Last $GZDumpFile success >> $LogFile
# 进入到增量备份目录，删除binlog
cd $ZlbakDir
rm -f *
```



### **3、设置定时任务**



```shell
[root@server mysqlbak]# crontab -e

#每个星期日凌晨2:00执行完全备份脚本0 2 * * 0 /u01/data/mysqlbak/databak.sh >/dev/null 2>&1
#周一到周六凌晨2:00做增量备份
0 2 * * 1-6 /u01/data/mysqlbak/binlogbak.sh >/dev/null 2>&1
```

### **4、使计划任务生效**



```shell
# systemctl restart crond.service

#查看计划任务
[root@server mysqlbak]# crontab -l

#每个星期日凌晨2:00执行完全备份脚本
0 2 * * 0 /u01/data/mysqlbak/databak.sh >/dev/null 2>&1
#周一到周六凌晨2:00做增量备份
0 2 * * 1-6 /u01/data/mysqlbak/binlogbak.sh >/dev/null 2>&1
```



 