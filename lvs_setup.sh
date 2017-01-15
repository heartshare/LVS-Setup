#! /bin/bash

function GM_REAL_SERVER(){
		echo "[INFO]Initializing..."
		sleep 1s
		echo "[INFO]We are configuring real server under DR/NAT mode..."
		sleep 2s
		modprobe ipip
		modprobe ip_vs
		lsmod |grep ipip
		lsmod |grep ip_vs
		sleep 1s
		echo "The following network interface should be configured:"
		echo "lo:0"
		read -p "Please enter the VIP for lo:0(xxx.xxx.xxx.xxx):" VIP_RS
		echo "[INFO]OK..."
		echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
		echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce
		echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
		echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
		ifconfig lo down
		ifconfig lo up
		ifconfig lo:0 $VIP_RS broadcast $VIP_RS netmask 255.255.255.255 up
		route add -host $VIP_RS dev lo:0
		if [ $? -eq 0  ];then
			echo "[OK]Configured successfully..."
			sleep 2s
			exit
		else
			echo "[ERROR]There probably be some troubles,please check..."
			sleep 2s
			exit
		fi
	}

function GM_LOAD_BALANCER(){
		IFCFG=`ifconfig |sed -n '1p;1q'|awk -F: '{print $1}'`
		echo "[INFO]Configuring load balancer under DR/NAT mode..."
		sleep 2s
		modprobe ipip
		modprobe ip_vs
		lsmod |grep ipip
		lsmod |grep ip_vs
		sleep 1s
		echo "The following network interface should be configured:"
		echo $IFCFG:0
		read -p "Please enter the VIP for $IFCFG:0(xxx.xxx.xxx.xxx):" VIP_LD
		echo "[INFO]OK..."
		sleep 1s
		echo "[INFO]Setting net.ipv4.ip_forward to 1..."
		echo 1 > /proc/sys/net/ipv4/ip_forward
		ifconfig $IFCFG:0 $VIP_LD broadcast $VIP_LD netmask 255.255.255.255 up
		route add -host $VIP_LD dev $IFCFG:0
		sleep 1s
		if [ $? -eq 0  ];then
			echo "[OK]Configured successfully..."
			sleep 2s
			exit
		else
			echo "[ERROR]There probably be some troubles,please check..."
			sleep 2s
			exit
		fi
	}


	#setting the real servers
function IP_REAL_SERVER(){
		echo "[INFO]Initializing..."
		sleep 1s
		echo "[INFO]We are configuring real server under IPTUN mode..."
		sleep 2s
		modprobe ipip
		modprobe ip_vs
		lsmod |grep ipip
		lsmod |grep ip_vs
		sleep 1s
		read -p "Please enter the VIP(xxx.xxx.xxx.xxx):" vip_rs
		echo "[INFO]OK..."
		echo 1 > /proc/sys/net/ipv4/conf/tunl0/arp_ignore
		echo 2 > /proc/sys/net/ipv4/conf/tunl0/arp_announce
		echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
		echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
		ifconfig tunl0 up
		ifconfig tunl0 $vip_rs broadcast $vip_rs netmask 255.255.255.255
		route add -host $vip_rs dev tunl0
		if [ $? -eq 0  ];then
			echo "[OK]Configured successfully..."
			sleep 2s
			exit
		else
			echo "[ERROR]There probably be some troubles,please check..."
			sleep 2s
			exit
		fi
	}

	#setting the load balancers
function IP_LOAD_BALANCER(){
		echo "[INFO]Configuring load balancer..."
		sleep 2s
		modprobe ipip
		modprobe ip_vs
		lsmod |grep ipip
		lsmod |grep ip_vs
		sleep 1s
		read -p "Please enter the VIP(xxx.xxx.xxx.xxx):" vip_ld
		echo "[INFO]OK..."
		sleep 1s
		echo "[INFO]Setting net.ipv4.ip_forward to 1..."
		echo 1 > /proc/sys/net/ipv4/ip_forward
		ifconfig tunl0 up
		ifconfig tunl0 $vip_ld broadcast $vip_ld netmask 255.255.255.255
		route add -host $vip_ld dev tunl0
		if [ $? -eq 0  ];then
			echo "[OK]Configured successfully..."
			sleep 2s
			exit
		else
			echo "[ERROR]There probably be some troubles,please check..."
			sleep 2s
			exit
		fi
	}


case $1 in 
		-iptun)
		case $2 in
			rs)
			IP_REAL_SERVER
			;;
			ld)
			IP_LOAD_BALANCER
			;;
			*)
			echo "Copyleft (c) PrexusTech Microsystems.Licensed by Apache."
			echo "$0: Usage $0 -<Options> [ld|rs]"
			echo "Options:"
			echo "	-nat:Using LVS NAT mode;"
			echo "	-dr:Using LVS DR mode;"
			echo "	-iptun:Using Linux IPIP Tunnel;"
			echo "ld : Configure the load balancer;"
			echo "rs : Configure the real server."
			exit
			;;
		esac
		;;
		
		-nat)
		case $2 in
			rs)
			GM_REAL_SERVER
			;;
			ld)
			GM_LOAD_BALANCER
			;;
			*)
			echo "Copyleft (c) PrexusTech Microsystems.Licensed by Apache."
			echo "$0: Usage $0 -<Options> [ld|rs]"
			echo "Options:"
			echo "	-nat:Using LVS NAT mode;"
			echo "	-dr:Using LVS DR mode;"
			echo "	-iptun:Using Linux IPIP Tunnel;"
			echo "ld : Configure the load balancer;"
			echo "rs : Configure the real server."
			exit
			;;
		esac
		;;
		
		-dr)
		case $2 in
			rs)
			GM_REAL_SERVER
			;;
			ld)
			GM_LOAD_BALANCER
			;;
			*)
			echo "Copyleft (c) PrexusTech Microsystems.Licensed by Apache."
			echo "$0: Usage $0 -<Options> [ld|rs]"
			echo "Options:"
			echo "	-nat:Using LVS NAT mode;"
			echo "	-dr:Using LVS DR mode;"
			echo "	-iptun:Using Linux IPIP Tunnel;"
			echo "ld : Configure the load balancer;"
			echo "rs : Configure the real server."
			exit
			;;
		esac
		;;
		
		*)
		echo "Copyleft (c) PrexusTech Microsystems.Licensed by Apache."
		echo "$0: Usage $0 -<Options> [ld|rs]"
		echo "Options:"
		echo "	-nat:Using LVS NAT mode;"
		echo "	-dr:Using LVS DR mode;"
		echo "	-iptun:Using Linux IPIP Tunnel;"
		echo "ld : Configure the load balancer;"
		echo "rs : Configure the real server."
		exit
		;;
esac
