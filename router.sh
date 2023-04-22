#!/bin/bash

#  Ligar o roteamento no seu container
echo 1 > /proc/sys/net/ipv4/ip_forward

iptables -t filter -F
iptables -t nat -F 

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT




#  Adicionar ip no eth1
ip addr add 192.168.104.154/24 dev eth1

#  Deletar ip no eth1
# ip addr del 192.168.104.1NN/24 dev eth1


#  Roteamento
ip route show
ip route add 8.8.8.8 via 192.168.104.100
# ip route del 8.8.8.8 via 192.168.104.100

echo "---------------------------------------------";

ALVO=`nslookup www.teobaldo.pro.br |tail -2|grep "Address"|awk '{print $2}'`
ip route add $ALVO via 192.168.104.100 
#ip route del $ALVO via 192.168.104.100 


iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.102.0/24 -j SNAT --to 192.168.104.154

ip route show


