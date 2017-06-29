#!/bin/bash

BIND_PORT=2345
IFACE=enp3s0

ip tuntap add tap0 mode tap 
ip addr add 10.0.0.1/24 dev tap0  
ip link set tap0 up 

iptables -P FORWARD ACCEPT 
iptables -t nat -A POSTROUTING -o $IFACE -j MASQUERADE 
iptables -t nat -A PREROUTING -p tcp --dport ${BIND_PORT} -j DNAT --to-destination 10.0.0.2

export LD_PRELOAD=./liblkl-hijack.so
export LKL_HIJACK_NET_QDISC="root|fq"
export LKL_HIJACK_SYSCTL="net.ipv4.tcp_congestion_control=bbr;net.ipv4.tcp_wmem=4096 65536 67108864"
export LKL_HIJACK_NET_IFTYPE=tap
export LKL_HIJACK_NET_IFPARAMS=tap0
export LKL_HIJACK_NET_IP=10.0.0.2
export LKL_HIJACK_NET_NETMASK_LEN=24
export LKL_HIJACK_NET_GATEWAY=10.0.0.1
export LKL_HIJACK_OFFLOAD="0x8883"
export LKL_HIJACK_DEBUG=0

# your program here
