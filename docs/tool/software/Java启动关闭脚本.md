# java启动关闭脚本

- 这三个文件，放到jar包同级目录下，这个目录下只能有一个jar文件

- 支持在任何目录下直接调用这三个脚本

- start.sh中的启动参数 根据各个应用情况需要单独配置

- deploy.sh的关闭等待时长，特殊应用可以适当延长(改进版已经解决)

- 目前脚本已到，注意根据自己服务器情况修改里面的java路径，为什么要写死java路径？因为一个机器可能存在多个java版本，也因为jenkins在远程触发脚本的时候可能无法感知java_home。

> 如果不清楚java命令所在目录，可以用 echo $JAVA_HOME 输出一下试试, jps和java在同一个目录下.

### [start.sh](http://start.sh) 第一版

```
#! /bin/sh
jar=$(ls |grep jar)
nohup java  -jar ./$jar >/dev/null 2>&1 &
echo ${jar}" start success!"
```

### [stop.sh](http://stop.sh) 第一版

```
#!/bin/bash
jar=$(ls |grep jar)
pid=`(ps -ef|grep java | grep ./$jar | grep -v "grep") | awk '{print $2}'`
kill -9 $pid
echo ${jar}" stop success!"
```

### 启动脚本 [start.sh](http://start.sh) 第二版

```
#! /bin/sh
echo "in start.sh"
basepath=$(cd `dirname $0`; pwd)
cd $basepath
jarFullName=$(ls $basepath |grep ".jar$")
jar=${jarFullName##*/}
nohup /usr/local/java/jdk1.8.0_91/bin/java -Xmx400m -Xms400m -Xmn250m -jar $jar >/dev/null 2>&1 &
echo ${jarFullName}" starting ... ... "
```

### [stop.sh](http://stop.sh) 第二版

```
#!/bin/bash
echo "in stop.sh"
basepath=$(cd `dirname $0`; pwd)
jarFullName=$(ls $basepath |grep ".jar$")
jar=${jarFullName##*/}
pid=`(ps -ef | grep $jar | grep -v "grep") | awk '{print $2}'`
if [ ${pid} ];then
 kill $pid  #不用-9，让程序优雅退出
 echo  ${jarFullName}" stop success! oldPid="${pid}
else
 echo ${jarFullName}" not run"
fi
```

### 重启 [deploy.sh](http://deploy.sh)

```shell
#!/bin/bash
basepath=$(cd `dirname $0`; pwd)
echo "basepath=" $basepath
sh $basepath/stop.sh
echo "waiting ... "
sleep 3 #等待一下，避免程序关闭比较慢，特殊应用这个时间要延长
sh $basepath/start.sh
```

### [stop.sh](http://stop.sh) 第三版

```shell
#! /bin/sh
echo "in stop.sh"
basepath=$(cd `dirname $0`; pwd)
jarFullName=$(ls $basepath |grep ".jar$")
jar=${jarFullName##*/}
pid=`(ps -ef | grep $jar|grep java | grep -v "grep") | awk '{print $2}'`
function checkPidAlive {
 wwcl=$(/usr/local/java/jdk1.8.0_91/bin/jps|grep ${pid}|wc -l)
 return $wwcl;
}

if [ ${pid} ];then
    kill $pid
    declare -i counter=0
        declare -i max_counter=10 # 10*3=30s
        declare -i total_time=0
        echo "waiting for ${jar} stop...pid="$pid
        while [[(counter -le max_counter)]]
        do
         printf "."
         counter+=1
         sleep 3
         checkPidAlive
         wwcl=$?
         if [[(wwcl -lt 1)]]; then
           printf "\n$(date) ${jar} has stoped\n"
           exit 0;
         fi
        done
        total_time=counter*3
    printf  "\n$(date) ${jarFullName}  has not stop success! total_time=$total_time\n"
else
 printf "\n$(date) ${jarFullName} not run\n"
fi
```

###  的重启 [deploy.sh](http://deploy.sh)

```shell
#!/bin/bash
basepath=$(cd `dirname $0`; pwd)
echo "basepath=" $basepath
sh $basepath/stop.sh
sh $basepath/start.sh
```

### [start.sh](http://start.sh) 第四版

```shell
#! /bin/sh
echo "in start.sh"
basepath=$(cd `dirname $0`; pwd)
cd $basepath
jarFullName=$(ls $basepath|grep ".jar$")
jar=${jarFullName##*/}

pid=`(ps -ef | grep $jar|grep java | grep -v "grep") | awk '{print $2}'`
if [ ${pid} ];then
  printf "\n *************************ERROR*******************\n"
  printf "\n\n ERROR,ERROR, ${jar} is running,cannot start again...you must stop it first.  \n\n"
  printf "\n *************************ERROR*******************\n"
  exit 0;
fi

nohup /usr/local/java/jdk1.8.0_91/bin/java -Xmx300m -jar $jar >/dev/null 2>&1 &
echo ${jarFullName}" starting ... ... "
sleep 2
pid=`(ps -ef | grep $jar|grep java | grep -v "grep") | awk '{print $2}'`

if [ ${pid} ];then
    printf "\n ---------------------------------------"
    printf "\n *** ${jarFullName} Start OK!!!! pid=${pid}\n"
    printf "\n ---------------------------------------\n"
else 
    printf "\n ************************************"
    printf "\n *** ${jarFullName} Start FAIL FAIL FAIL!!!! \n"
    printf "\n ************************************\n"
fi
```

### [stop.sh](http://stop.sh) 第四版

```shell
#! /bin/sh
echo "in stop.sh"
basepath=$(cd `dirname $0`; pwd)
jarFullName=$(ls $basepath |grep ".jar$")
jar=${jarFullName##*/}
pid=`(ps -ef | grep $jar|grep java | grep -v "grep") | awk '{print $2}'`


function checkPidAlive {
 wwcl=$(/usr/local/java/jdk1.8.0_91/bin/jps|grep ${pid}|wc -l)
 return $wwcl;
}

if [ ${pid} ];then
    kill $pid
    declare -i counter=0
        declare -i max_counter=15 # 15*2=30s
        declare -i total_time=0
        echo "waiting for ${jar} stop...pid="$pid
        while [[(counter -le max_counter)]]
        do
         printf "."
         counter+=1
         sleep 2
         checkPidAlive
         wwcl=$?
         if [[(wwcl -lt 1)]]; then
           printf "\n$(date) ${jar} has stoped\n"
           exit 0;
         fi
        done
        total_time=counter*3
    printf  "\n$(date) ${jarFullName}  has not stop success! total_time=$total_time\n"
    kill -9 $pid
    printf " *** has use: kill -9 $pid ***\n"
else
 printf "\n ************************************"
 printf "\n *** ${jarFullName} not run \n"
 printf "\n ************************************\n"
fi
```

