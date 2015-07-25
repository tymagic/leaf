#########################################################################
# File Name: dty.sh
# Author: dty
# mail: 576786031@qq.com
# Created Time: Sat 25 Jul 2015 04:21:55 PM CST
#########################################################################
#!/bin/bash
. /etc/rc.d/init.d/functions
RETVAL=0
WEIXINNUM=1749587921
DOWN_TIME=`date +"%Y-%m-%d %H:%M:%S"`
WENJIAN=thinglist.txt
get_url(){
	FAILCOUNT=0
	for((i=1;i<=3;i++))
	do
		wget -T5 -t1 --spider http://$1 &>/dev/null
		[ $? -ne 0 ] && let FAILCOUNT+=1
	done
	if [ $FAILCOUNT -gt 1 ];then
		RETVAL=1
		echo "邓天元$1的httpd服务坏了，快去修，$DOWN_TIME" >$WENJIAN 
		php test.php $WEIXINNUM & > /dev/null 
	else RETVAL=0
	fi
	return $RETVAL
}
for URL in `cat list.txt`
do
	echo -n " checking $URL "
	get_url $URL && action "$DOWN_TIME -ok" /bin/true || action "$DOWN_TIME -down" /bin/false
done
