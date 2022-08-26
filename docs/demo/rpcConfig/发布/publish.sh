#! /bin/sh
#author trtmu

# 只需要在这里维护好程序名称和对应的绝对路径就可以了
declare -A locationMap=(
["api-v4-gateway"]="/data/e6yun3/3.0/api-v4-gateway"
["common-dev-user-info-cache-center"]="/data/e6yun3/3.0/common-dev-user-info-cache-center"
["common-module-base-file-processor-web"]="/data/e6yun3/3.0/common-module-base-file-processor-web"
["e6-ms-e6yun3-gateway"]="/data/e6yun3/3.0/e6-ms-e6yun3-gateway"
["e6-ms-tms-base-web"]="/data/e6yun3/3.0/e6-ms-tms-base-web"
["e6-ms-tms-busi-web"]="/data/e6yun3/3.0/e6-ms-tms-busi-web"
["e6-ms-tms-common-operation-log-web"]="/data/e6yun3/3.0/e6-ms-tms-common-operation-log-web"
["e6-ms-tms-e6yun-base-web"]="/data/e6yun3/3.0/e6-ms-tms-e6yun-base-web"
["e6-ms-tms-iot-sdk"]="/data/e6yun3/3.0/e6-ms-tms-iot-sdk"
["e6-ms-tms-message-push"]="/data/e6yun3/3.0/e6-ms-tms-message-push"
["e6-ms-tms-personalize-web"]="/data/e6yun3/3.0/e6-ms-tms-personalize-web"
["e6-ms-tms-report-web"]="/data/e6yun3/3.0/e6-ms-tms-report-web"
["e6-ms-tms-busi-open-api-web"]="/data/e6yun3/3.0/e6-ms-tms-busi-open-api-web"
["map-api-web"]="/data/e6yun3/3.0/map-api-web"
["e6-ms-tms-financial-web"]="/data/e6yun3/3.0/e6-ms-tms-financial-web"
)
cdFun(){
        printf " ************************************\n"
    echo "进入路径 $path 操作为:${operatMap[$operates]} "
        printf "\n ************************************\n"
    cd $path
    if [[ "$operates" == "1" ]]; then
                openFun
        elif [[ "$operates" == "2" ]]; then
                stopFun
        elif [[ "$operates" == "3" ]]; then
                autoFun
        else
        echo "未知的操作类型 $operates"
        fi
}
autoFun(){
        rm -rf $path/log nohup.out sql-statistics-log
        echo "服务正在停止"
		stopFun
        sleep 3
        openFun
        sleep 3
}
stopFun(){
        basepath=$path
        jarFullName=$(ls $basepath |grep ".jar$")
        jar=${jarFullName##*/}
        pid=`( ps -ef | grep $jar|grep java | grep -v "grep") | awk '{print $2}'`
        function checkPidAlive {
		        wwcl=$(jps|grep ${pid}|wc -l)
         return $wwcl;
        }
        if [[ ${pid} ]];then
                kill -9 $pid
				echo "请等待当前程序停止... pid="$pid
				sleep 3
				checkPidAlive
				wwcl=$?
				if [[(wwcl -lt 1)]]; then
				   printf "\n$(date) 当前程序已停止\n"
				else
					printf " *** 使用强行停止方式停止: kill -9 $pid ***\n"
					kill -9 $pid
				fi                
        else
         printf "\n ************************************"
         printf "\n *** 当前程序未运行 \n"
         printf "\n ************************************\n"
        fi
}


openFun(){
        basepath=$path
        cd $basepath
        jarFullName=$(ls $basepath|grep ".jar$")
        jar=${jarFullName##*/}
        pid=`( ps -ef | grep $jar|grep java | grep -v "grep") | awk '{print $2}'`
        if [[ ${pid} ]];then
          printf "\n *************************ERROR*******************\n"
          printf "\n\n 当前程序 ${jar}正在运行, pid=${pid},请先停止该程序  \n\n"
          printf "\n *************************ERROR*******************\n"
          exit 0;
        fi
        # 下面的-Djava.security.egd=file:/dev/./urandom  这个是解决  SecureRandom 很慢的一个解决方案,
		# 在这做个判断,如果路径里面有start.sh文件,使用文件夹里面的start.sh文件
		sh $basepath/start.sh
        echo ${jarFullName}" 正在启动 ... ... "
        sleep 2
        pid=`( ps -ef | grep $jar|grep java | grep -v "grep") | awk '{print $2}'`
        if [[ ${pid} ]];then
                printf "\n ---------------------------------------"
                printf "\n ***  当前程序启动成功!!! pid=${pid}\n "
                printf "\n ---------------------------------------\n"
                
				if [[ "$types" == "99" ]]; then
					# 这里什么都不输出  因为如果是批量的  输出日志的话会卡住 导致下一个无法执行
					echo '全部启动不输出日志'
				else
					sleep 3
					echo '即将开始日志输出'
					find . -name '*[0–9].log' -mmin -3 |xargs tail -100f
				fi
        else
                printf "\n ************************************"
                printf "\n ***  当前程序启动失败!!!  FAIL FAIL FAIL!!!! \n"
                printf "\n ************************************\n"
				# 报错的话查看nohup文件及 err.log
        fi
}





declare -A countMap
declare count=1;
echo "请选择需要重启的jar(输入前面的数字即可):"
for key in ${!locationMap[@]};do
  echo " $count) $key "
  countMap[$count]=$key
  ((count++))
done
  echo " 99) 全部操作"
  

read types

printf "\n ************************************\n"
# 如果是全部操作, 则不一样的输出 
if [[ "$types" == "99" ]]; then
	echo "您选择的是批量操作,请谨慎处理!!"
	echo "您选择的是批量操作,请谨慎处理!!"
	echo "您选择的是批量操作,请谨慎处理!!"
else
	declare tmp=${countMap[$types]}
	declare path=${locationMap[$tmp]}
	echo "您选择操作的是: $tmp 路径为: $path"
fi
printf "\n ************************************\n"
declare -A operatMap=(
        ["1"]="start[启动]"
        ["2"]="stop[停止]"
        ["3"]="restart[重启]"
)
echo "请选择操作 (输入前面的数字即可):"
for key in ${!operatMap[@]};do
  echo " $key)  ${operatMap[$key]}"
done


read operates
if [[ "$types" == "99" ]]; then
	for key in ${!locationMap[@]}
		do
			path=${locationMap[$key]}
			
			cdFun
			echo "$key  处理完成,开始处理下一个!"
		done
else
	cdFun
fi
