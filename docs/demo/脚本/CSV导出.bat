@echo on
setlocal enabledelayedexpansion

::数据库名称
set dataBase=dataBase
set url=127.0.0.1
set username=username
set password=quGqpF8QZHFw3JWj

::保存txt文件的路径
set filePath=D:\Back_Up\
set fileName=test
::这边填写数据库表名
set dataTable=Delivery 
set tt=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%
set now=%tt: =0%

::使用bcp命令导出文件
::for %%i in (%dataTable%) do bcp "SELECT top 10 * FROM %dataBase%.dbo.%%i ORDER BY UpdateTime DESC" queryout %filePath%tvss_%%i_%now%.csv -w -t"`" -Se6projdevdb.ahn1.e6niu.com,8088 -US_tvss_user -PquGqpF8QZHFw3JWj

bcp "SELECT DeliveryNo,SendNo,ReceiveNo,CreateTime FROM %dataBase%.dbo.%dataTable% WHERE CreateTime>'2022-05-01'" queryout %filePath%tvss_%fileName%_%now%.csv -w -t"`" -S%url% -U%username% -P%password%
pause