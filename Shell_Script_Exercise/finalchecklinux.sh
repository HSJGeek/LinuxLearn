#!/bin/bash
#author:geek_huang
#desc:final check linux status information 

echo -e "\n\e[32m"

echo -e "███████╗██╗ █████╗ ███╗   ██╗██╗          ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗    ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗";
echo -e "██╔════╝██║██╔══██╗████╗  ██║██║         ██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝";
echo -e "█████╗  ██║███████║██╔██╗ ██║██║         ██║     ███████║█████╗  ██║     █████╔╝     ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ ";
echo -e "██╔══╝  ██║██╔══██║██║╚██╗██║██║         ██║     ██╔══██║██╔══╝  ██║     ██╔═██╗     ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ ";
echo -e "██║     ██║██║  ██║██║ ╚████║███████╗    ╚██████╗██║  ██║███████╗╚██████╗██║  ██╗    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗";
echo -e "╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝     ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝    ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝";
echo -e "\n Author:             geek_huang                                                                                              ";
echo -e " Edit Time:          2024_05_16                                                                                              ";
echo -e " Description:        final check linux status information                                                                    ";
echo -e "\e[0m"



echo -e "-----------------------------------脚本开始执行----------------------------------------------"

echo -e "请在15秒内，输入你要检查的web服务状态的IP或域名(或者回车跳过)\n"
read -t 15 IPIFtion
if [[ -n $IPIFtion ]]; then
     echo -e "要检查的web服务是:    \e[32m\e[5m$IPIFtion\e[25m\e[0m\n"
else
     echo -e "不检查web服务\n"
fi

#主机名
hostName=$(hostname)i

#IP地址
ipInformation=$(ip a s | sed -n '9p' | awk -F'[ /]+' '{print $3}')

#公网ip
adderip=$(wget -qO- ifconfig.me)

#系统发行版本
sysTem_version=$(hostnamectl | sed -n '7p' | awk -F':' '{print $NF}' | column -t)

#内核版本
kernal_version=$(hostnamectl | sed -nr '/Kernel/p' | awk '{print $(NF-1),$NF}' | column -t)

#系统语言字符集
langue=$LANG

#负载均衡 最近1分钟，5分钟，15分钟
loadAvg=$(w | awk -F [\,\ ] '{if(NR==1)print$(NF-4)" "$(NF-2)" "$(NF)}' | column -t)

echo -e "\n----------<===主机信息===>----------\n"
printf "主机名:    $hostName\nIP地址:  $ipInformation\n公网IP: $adderip\n系统发行版本: $sysTem_version\n内核版本:  $kernal_version\n系统语言字符集:    $langue\n系统负载均衡:  $loadAvg"


#cpu信息
#CPU型号
cpuModel=$(lscpu | grep -i 'model name' | awk -F : '{print $2}' | column -t)
#CPU颗数
cpuNumbers=$(lscpu | grep soc | awk '{print $NF}')
#CPU核心数
cpuCoreNumbers=$(lscpu | awk '{if(NR==5)print $NF}')
#CPU空闲率
cpuIdle=$(top -bn1 | awk -F "[ ,]+" '{if(NR==3)print $8}')
#CPU用户态使用率
cpuUserIdle=$(top -bn1 | awk -F "[ ,]+" '{if(NR==3)print $2}')
#CPU系统态使用率CPU
cpuSystemIdle=$(top -bn1 | awk -F "[ ,]+" '{if(NR==3)print $4}')
#io占用的CPU使用率
cpuIoIdle=$(top -bn1 | awk -F "[ ,]+" '{if(NR==3)print $10}')
echo -e "\n\n----------<===CPU信息===>----------\n"
echo -e "CPU型号:   $cpuModel\nCPU颗数: $cpuNumbers\nCPU核心数: $cpuCoreNumbers\nCPU空闲率: $cpuIdle%\nCPU用户使用率:    $cpuUserIdle%\nCPU系统使用率:    $cpuSystemIdle%\nIO占用的CPU使用率:  $cpuIoIdle%"

#内存信息
#总内存可用
totalMemoryAvailable=$(free -h | grep Mem | awk '{print $NF}')
#内存已用
memoryUsed=$(free -h | grep Mem | awk '{print $3}')

echo -e "\n\n----------<===内存信息===>----------\n"
echo -e "总内存可用:    $totalMemoryAvailable\n内存已用:    $memoryUsed"

echo -e "\n\n----------<===swap信息===>----------\n"
#内存是否有swap
ifSwap=$(free -h | grep -oi swap)
#echo -n "$ifSwap" &&echo "存在"
if [ "$ifSwap" = Swap ]; then
    echo -e "存在swap"
else
    echo -e "不存在swap"
fi
#swap大小
swapSize=$(free -h | awk '{if(NR==3)print $2}')
#swap使用情况
swapUtilization=$(free -h | awk '{if(NR==3)print $3}')
#swap剩余情况
swapRemaining=$(free -h | awk '{if(NR==3)print $NF}')

echo -e "swap大小: $swapSize\nswap使用情况: $swapUtilization\nswap剩余: $swapRemaining"

#磁盘
#磁盘个数
diskNumber=$(fdisk -l | egrep "^Disk /dev/(sd|vd)" | wc -l)
#磁盘大小
diskSize=$(fdisk -l | egrep "^Disk /dev/(sd|vd)" | awk '{print $1,$2,$3,$4}' | sed -n "s#\,##gp")
#磁盘分区大小
diskPart=$(fdisk -l | egrep -i '/dev/(sd|vd)' | sed -nr "s#\*|LVM# #gp" | awk '{print $1,$(NF-2)}')
#diskPart1=$( df -h $(awk '!/swap|^$|#/{print $2}' /etc/fstab)  | awk '{print $1,$2}' |column -t)
#磁盘分区使用率
diskSizeIdle=$(df -h $(awk '!/swap|^$|#/{print $2}' /etc/fstab) | awk '{print $1,$5}' | column -t)
#磁盘分区inode使用率
diskInodeIdle=$(df -i $(awk '!/swap|^$|#/{print $2}' /etc/fstab) | awk '{print $1,$5}' | column -t)

echo -e "\n\n----------<===磁盘信息===>----------\n"
echo -e "磁盘个数: $diskNumber\n磁盘大小:  $diskSize\n\n磁盘分区大小:\n$diskPart\n\n磁盘分区使用率:\n$diskSizeIdle%\n\n磁盘分区Inode使用率:\n$diskInodeIdle%\n\n"

#用户
#可登录用户数量
userLogin=$(cat /etc/passwd | grep -v 'nologin' | wc -l)
#可登录用户名字
userLoginName=$(cat /etc/passwd | grep -v 'nologin' | awk -F: '{print $1}')
#虚拟用户数量
systemUser=$(cat /etc/passwd | grep 'nologin' | wc -l)
echo -e "可登录用户数量: $userLogin\n----------<===可登录的用户名===>----------\n$userLoginName\n虚拟用户数量:   $systemUser"

#dns
DNS=$(cat /etc/resolv.conf | awk '{if(NR>1)print $NF}')
#配置什么dns
echo -e "\n\n----------<===DNS===>----------\n$DNS"
#dns是否可用
testDNS=$(ping -c1 $DNS)
if [ $? ]; then
    echo "DNS   可用"
else
    echo "DNS   不可用"
fi

#yum源
#是否有epel源
if [ "$(yum repolist | grep epel)" = epel ]; then
    echo "epel源   已启用"
else
    echo "epel源   未启用 "
fi

#是否为默认的源
SYSTEM=$(hostnamectl | awk -F "[ :]+" '{if(NR==7)  print $4 }')
case $SYSTEM in
*Kylin*)
    grep -q "^baseurl = https://update.cs2c.com.cn" /etc/yum.repos.d/kylin_x86_64.repo
    if [ $? -eq 0 ]; then
        echo 'Kylin系统的源 是默认源'
    else
        echo 'Kylin系统的源 不是默认源'
    fi
;;
*Ubuntu*)
    grep -q "^deb http://archive.ubuntu.com" /etc/apt/sources.list
    if [ $? -eq 0 ]; then
        echo "Ubuntu系统的源 是默认源"
    else
        echo 'Ubuntu系统的源 不是默认源'
    fi
;;
*CentOS*)
    grep -q "^baseurl=http://mirror.centos.org" /etc/yum.repos.d/CentOS-Base.repo
    if [ $? -eq 0 ]; then
        echo 'Centos系统的源 是默认源'
    else
        echo 'Centos系统的源 不是默认源'
    fi
;;
*)
    echo '未知系统无法判断'
;;
esac

#是否开启selinux

if [ $(getenforce) = Disabled ]; then
    echo "selinux   未开启"
else
    echo "selinux   已开启"
fi

#防火墙
echo -e "\n\n----------<===防火墙信息===>----------"
firewall=$(systemctl is-active firewalld.service)
ipTable=$(systemctl is-active iptables.service)
#是否开启
#开启显示规则
#如果关闭提示关闭
if [ $firewall = active ]; then
    echo "iptables  已关闭"
    echo "firewalld    已开启"
    echo "firewalld    规则如下"
    echo "$(firewall-cmd --list-all)"
elif [ $ipTable = active ]; then
    echo "firewall  已关闭"
    echo "iptables  已开启"
    echo "iptable   规则如下"
    echo "$(iptables -L)"
else
    echo -e "\033[37;31;5m fiewall 和 iptable都关闭 \033[39;49;0m"
fi

#端口 显示已经开启的端口
portStart=$(ss -nptul | awk '{if(NR>=2){print $5}}' | sed -nr 's#.*:# #gp' | sort | uniq)

echo -e "\n\n----------<===开启的端口===>----------\n$portStart"

#服务进程
<<'COMMENT'
SSHD=$(ps -ef | grep sshd | grep -v grep ) 
NGINX=$(ps -ef | grep nginx| grep -qv grep) 
MYSQL=$(ps -ef | grep mysql| grep -qv grep)
#判断主机运行了nginx sshd 数据库
if [ "$SSHD" ]; then
     echo "sshd: 正在运行"  
else 
 echo "sshd: 未运行"
fi

case "${NGINX}" in
    *nginx*)
        echo "nginx: 正在运行"
    ;;
    *)
        echo "nginx: 未运行"
    ;;
esac
COMMENT

echo -e "\n\n----------<===服务信息===>----------\n"
#服务进程
#判断主机运行了nginx sshd 数据库
SERVER=("sshd" "nginx" "mysql")
for i in "${SERVER[@]}"; do

    if systemctl is-active $i &>/dev/null; then
        echo -e "\e[1;32m$i    运行中\e[0m"
    else
        echo -e"$i    未运行"
    fi

done

#僵尸进程数量
ZOMBIE=$(ps aux | awk '{print $8}' | grep -i z | wc -l)
#后台挂起进行
STOP=$(top -bn1 | awk '{if(NR==2) print $8}')
#开机自启动
ENABLE=$(systemctl list-unit-files | grep enabled | wc -l)
echo -e "\e[91m僵尸进程数量:  \e[95m\e[5m$ZOMBIE\e[25m\e[0m \n后台挂起运行数量: $STOP \n开机自启动数量: $ENABLE\n"

#web服n
#状态码 检查服务状态

if [[ -n $IPIFtion ]]; then

    webServiceStatusCode=$(curl --head -s "$IPIFtion" | head -1)
    echo -e "$IPIFtion 的服务状态\n$webServiceStatusCode\n"

else
    echo -e "未输入要查询的web服务 \e[33m\e[5m无法查询\e[25m\e[0m\n"
fi

#连接数 web服务连接数
webALLNumber=$(netstat -ant | grep -v LISTEN | wc -l)
#并发数 web服务并发数
webEstabNumber=$(netstat -ant | grep ESTAB | wc -l)
echo -e "web服务连接数:  $webALLNumber \nweb服务并发数:  $webEstabNumber\n"

echo -e "\n\n----------<===定时任务信息===>----------\n"
#是否有备份  定时任务，是否有备份
#是否配置时间同步，定时任务，是否有ntpunc
function IFCRON() {
    local cronserver=$1
    if crontab -l | grep $cronserver; then
        echo "\e[1;34m存在定时任务: $cronserver\e[0m"
    else
        echo -e "不存在定时任务: $cronserver"
    fi
}

CRONTAB=("tar" "ntpdate")
for i in "${CRONTAB[@]}"; do
    IFCRON "$i"
done
