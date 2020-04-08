#!/bin/bash

#此处修改脚本名称：
APP_NAME=app.jar

#脚本菜单项
usage() {
 echo "Usage: sh ShellName.sh [start|stop|restart|status]"
 exit 1
}

is_exist(){
 pid=`ps -ef|grep $APP_NAME|grep -v grep|awk '{print $2}' `
 #如果不存在返回1，存在返回0
 if [ -z "${pid}" ]; then
 return 1
 else
 return 0
 fi
}
#启动脚本
start(){
 is_exist
 if [ $? -eq "0" ]; then
 echo "${APP_NAME} is already running. pid=${pid} ."
 else
outNohuplog="${APP_NAME%.jar*}.log"
if [ ! -d "$outNohuplog" ]; then
touch  "$outNohuplog"
fi
 nohup java -jar $APP_NAME > ${APP_NAME%.jar*}.log   2>&1 &
#此处打印log日志：
 tail -f ${APP_NAME%.jar*}.log
 fi
}
#停止脚本
stop(){
 is_exist
 if [ $? -eq "0" ]; then
 kill -9 $pid
rm ${APP_NAME%.jar*}.log
 else
 echo "${APP_NAME} is not running"
 fi
}
#显示当前jar运行状态
status(){
 is_exist
 if [ $? -eq "0" ]; then
 echo "${APP_NAME} is running. Pid is ${pid}"
 else
 echo "${APP_NAME} is NOT running."
 fi
}
#重启脚本
restart(){
 stop
 start
}

case "$1" in
 "start")
 start
 ;;
 "stop")
 stop
 ;;
 "status")
 status
 ;;
 "restart")
 restart
 ;;
 *)
 usage
 ;;
esac

